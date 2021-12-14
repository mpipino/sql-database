SELECT counter_name as CounterName, (a.cntr_value * 1.0 / b.cntr_value) * 100.0 as BufferCacheHitRatio 
FROM sys.dm_os_performance_counters  a 
JOIN  (SELECT cntr_value,OBJECT_NAME FROM sys.dm_os_performance_counters 
		WHERE counter_name = 'Buffer cache hit ratio base' AND OBJECT_NAME LIKE '%Buffer Manager%') b ON  a.OBJECT_NAME = b.OBJECT_NAME WHERE a.counter_name =
 'Buffer cache hit ratio' AND a.OBJECT_NAME LIKE '%Buffer Manager%'

 /*
Identify memory grant wait performance issues
If your top wait type is RESOURCE_SEMAHPORE and you don't have a high CPU usage issue
, you may have a memory grant waiting issue.

Determine if a RESOURCE_SEMAHPORE wait is a top wait
Use the following query to determine if a RESOURCE_SEMAHPORE wait is a top wait.
--https://docs.microsoft.com/en-us/azure/azure-sql/database/monitoring-with-dmvs#identify-tempdb-performance-issues
 */
 SELECT wait_type,
       SUM(wait_time) AS total_wait_time_ms
FROM sys.dm_exec_requests AS req
    JOIN sys.dm_exec_sessions AS sess
        ON req.session_id = sess.session_id
WHERE is_user_process = 1
GROUP BY wait_type
ORDER BY SUM(wait_time) DESC;


----------------------------------------------------------------------------------------------------

/*
Identify high memory-consuming statements
*/
drop table if exists #tmp
SELECT IDENTITY(INT, 1, 1) rowId,
    CAST(query_plan AS XML) query_plan,
    p.query_id
INTO #tmp
FROM sys.query_store_plan AS p
    JOIN sys.query_store_runtime_stats AS r
        ON p.plan_id = r.plan_id
    JOIN sys.query_store_runtime_stats_interval AS i
        ON r.runtime_stats_interval_id = i.runtime_stats_interval_id
--WHERE start_time > '2021-4-22 14:00:00.0000000'
--      AND end_time < '2021-4-22 23:00:00.0000000';
GO
;WITH cte
AS (SELECT query_id,
        query_plan,
        m.c.value('@SerialDesiredMemory', 'INT') AS SerialDesiredMemory
    FROM #tmp AS t
        CROSS APPLY t.query_plan.nodes('//*:MemoryGrantInfo[@SerialDesiredMemory[. > 0]]') AS m(c) )
SELECT TOP 50
    cte.query_id,
    t.query_sql_text,
    cte.query_plan,
    CAST(SerialDesiredMemory / 1024. AS DECIMAL(10, 2)) SerialDesiredMemory_MB
FROM cte
    JOIN sys.query_store_query AS q
        ON cte.query_id = q.query_id
    JOIN sys.query_store_query_text AS t
        ON q.query_text_id = t.query_text_id
ORDER BY SerialDesiredMemory DESC;

---------------------------------------------------------------------------------------------------

/*
	Use the following query to identify the top 10 active memory grants:
*/

SELECT TOP 10
    CONVERT(VARCHAR(30), GETDATE(), 121) AS runtime,
       r.session_id,
       r.blocking_session_id,
       r.cpu_time,
       r.total_elapsed_time,
       r.reads,
       r.writes,
       r.logical_reads,
       r.row_count,
       wait_time,
       wait_type,
       r.command,
       OBJECT_NAME(txt.objectid, txt.dbid) 'Object_Name',
       LTRIM(RTRIM(REPLACE(
                              REPLACE(
                                         SUBSTRING(
                                                      SUBSTRING(
                                                                   text,
                                                                   (r.statement_start_offset / 2) + 1,
                                                                   ((CASE r.statement_end_offset
                                                                         WHEN -1 THEN
                                                                             DATALENGTH(text)
                                                                         ELSE
                                                                             r.statement_end_offset
                                                                     END - r.statement_start_offset
                                                                    ) / 2
                                                                   ) + 1
                                                               ),
                                                      1,
                                                      1000
                                                  ),
                                         CHAR(10),
                                         ' '
                                     ),
                              CHAR(13),
                              ' '
                          )
                  )
            ) stmt_text,
       mg.dop,                                               --Degree of parallelism
       mg.request_time,                                      --Date and time when this query requested the memory grant.
       mg.grant_time,                                        --NULL means memory has not been granted
       mg.requested_memory_kb / 1024.0 requested_memory_mb,  --Total requested amount of memory in megabytes
       mg.granted_memory_kb / 1024.0 AS granted_memory_mb,   --Total amount of memory actually granted in megabytes. NULL if not granted
       mg.required_memory_kb / 1024.0 AS required_memory_mb, --Minimum memory required to run this query in megabytes.
       max_used_memory_kb / 1024.0 AS max_used_memory_mb,
       mg.query_cost,                                        --Estimated query cost.
       mg.timeout_sec,                                       --Time-out in seconds before this query gives up the memory grant request.
       mg.resource_semaphore_id,                             --Non-unique ID of the resource semaphore on which this query is waiting.
       mg.wait_time_ms,                                      --Wait time in milliseconds. NULL if the memory is already granted.
       CASE mg.is_next_candidate --Is this process the next candidate for a memory grant
           WHEN 1 THEN
               'Yes'
           WHEN 0 THEN
               'No'
           ELSE
               'Memory has been granted'
       END AS 'Next Candidate for Memory Grant',
       qp.query_plan
FROM sys.dm_exec_requests AS r
    JOIN sys.dm_exec_query_memory_grants AS mg
        ON r.session_id = mg.session_id
           AND r.request_id = mg.request_id
    CROSS APPLY sys.dm_exec_sql_text(mg.sql_handle) AS txt
    CROSS APPLY sys.dm_exec_query_plan(r.plan_handle) AS qp
ORDER BY mg.granted_memory_kb DESC;

-------------------------------------------------------------------------------------------------------

--avg_memory_usage_percent
--https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-resource-stats-azure-sql-database?view=azuresqldb-current
--https://www.brentozar.com/archive/2018/12/azure-sql-db-is-slow-do-i-need-to-buy-more-dtus/



----------------------------------------------------------------------------------

--https://techcommunity.microsoft.com/t5/DataCAT/CPU-and-Memory-Allocation-on-Azure-SQL-Database-Managed-Instance/ba-p/305508
SELECT cntr_value / 1024
FROM sys.dm_os_performance_counters
WHERE object_name LIKE '%Memory Manager%'
	AND counter_name = 'Target Server Memory (KB)';

SELECT CONVERT(INT, value_in_use) / 1024 / 1024
FROM sys.configurations
WHERE name = 'max server memory (MB)';

SELECT process_memory_limit_mb,
	non_sos_mem_gap_mb,
	mem = process_memory_limit_mb - non_sos_mem_gap_mb
FROM sys.dm_os_job_object;
