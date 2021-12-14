--SP_ORDERS_UPDATETRANSACTION

[dba].sp_BlitzCache @StoredProcName = 'SP_ORDERS_UPDATETRANSACTION'
dba.sp_BlitzQueryStore @StoredProcName = 'SP_ORDERS_UPDATETRANSACTION'
[dba].sp_BlitzCache @SortOrder = 'query hash'

--Statement (parent [dbo].[sp_Phoenix_AutoShip_Projection_widget])
SELECT qp.query_plan, 
       CP.usecounts, 
       cp.cacheobjtype, 
       cp.size_in_bytes, 
       cp.usecounts, 
       SQLText.text
  FROM sys.dm_exec_cached_plans AS CP
  CROSS APPLY sys.dm_exec_sql_text( plan_handle)AS SQLText
  CROSS APPLY sys.dm_exec_query_plan( plan_handle)AS QP
  WHERE objtype = 'Adhoc' and cp.cacheobjtype = 'Compiled Plan'

/*
You have 77725 plans in your cache, and 98.00% are duplicates with more than 5 entries, 
meaning similar queries are generating the same plan repeatedly. Forced Parameterization may fix the issue. 
To find troublemakers, use: EXEC sp_BlitzCache @SortOrder = 'query hash'; 
*/


SELECT TOP 50 d.object_id, db_name(d.database_id) as BaseDatos, OBJECT_NAME(object_id, database_id) 'proc name', 
d.cached_time, d.last_execution_time, d.total_elapsed_time, d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],
d.last_elapsed_time, d.execution_count,max_logical_reads,max_logical_writes, max_logical_reads  * 8.0 / 1024 / 1024 as READS_GB, max_logical_writes  * 8.0 / 1024 / 1024 as WRITES_GB
FROM sys.dm_exec_procedure_stats AS d
where OBJECT_NAME(object_id, database_id) like '%SP_ORDERS_UPDATETRANSACTION%'
--ORDER BY last_execution_time desc --, max_logical_reads desc, [total_worker_time] DESC;
ORDER BY max_logical_reads desc



WITH RedundantQueries AS 
        (SELECT TOP 10 query_hash, statement_start_offset, statement_end_offset,
            /* PICK YOUR SORT ORDER HERE BELOW: */
 
            COUNT(query_hash) AS sort_order,            --queries with the most plans in cache
 
            /* Your options are:
            COUNT(query_hash) AS sort_order,            --queries with the most plans in cache
            SUM(total_logical_reads) AS sort_order,     --queries reading data
            SUM(total_worker_time) AS sort_order,       --queries burning up CPU
            SUM(total_elapsed_time) AS sort_order,      --queries taking forever to run
            */
 
            COUNT(query_hash) AS PlansCached,
            COUNT(DISTINCT(query_hash)) AS DistinctPlansCached,
            MIN(creation_time) AS FirstPlanCreationTime,
            MAX(creation_time) AS LastPlanCreationTime,
			MAX(s.last_execution_time) AS LastExecutionTime,
            SUM(total_worker_time) AS Total_CPU_ms,
            SUM(total_elapsed_time) AS Total_Duration_ms,
            SUM(total_logical_reads) AS Total_Reads,
            SUM(total_logical_writes) AS Total_Writes,
			SUM(execution_count) AS Total_Executions,
            --SUM(total_spills) AS Total_Spills,
            N'EXEC sp_BlitzCache @OnlyQueryHashes=''0x' + CONVERT(NVARCHAR(50), query_hash, 2) + '''' AS MoreInfo
            FROM sys.dm_exec_query_stats s
            GROUP BY query_hash, statement_start_offset, statement_end_offset
            ORDER BY 4 DESC)
SELECT r.query_hash, r.PlansCached, r.DistinctPlansCached, q.SampleQueryText, q.SampleQueryPlan,
        r.Total_Executions, r.Total_CPU_ms, r.Total_Duration_ms, r.Total_Reads, r.Total_Writes, --r.Total_Spills,
        r.FirstPlanCreationTime, r.LastPlanCreationTime, r.LastExecutionTime, 
		r.statement_start_offset, r.statement_end_offset, r.sort_order, r.MoreInfo
    FROM RedundantQueries r
    CROSS APPLY (SELECT TOP 10 st.text AS SampleQueryText, qp.query_plan AS SampleQueryPlan, qs.total_elapsed_time
        FROM sys.dm_exec_query_stats qs 
        CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
        CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
        WHERE r.query_hash = qs.query_hash
            AND r.statement_start_offset = qs.statement_start_offset
            AND r.statement_end_offset = qs.statement_end_offset
        ORDER BY qs.total_elapsed_time DESC) q
    ORDER BY r.sort_order DESC, r.query_hash, r.statement_start_offset, r.statement_end_offset, q.total_elapsed_time DESC;

-------------------------------------------

SELECT TOP 10
  q.query_hash
  , count (distinct p.query_id ) AS number_of_distinct_query_ids
  , min(qt.query_sql_text) AS sampled_query_text
FROM sys.query_store_query_text AS qt
  JOIN sys.query_store_query AS q
     ON qt.query_text_id = q.query_text_id
  JOIN sys.query_store_plan AS p
     ON q.query_id = p.query_id
  JOIN sys.query_store_runtime_stats AS rs
     ON rs.plan_id = p.plan_id
  JOIN sys.query_store_runtime_stats_interval AS rsi
     ON rsi.runtime_stats_interval_id = rs.runtime_stats_interval_id
WHERE
  rsi.start_time >= DATEADD(hour, -2, GETUTCDATE())
  AND query_parameterization_type_desc IN ('User', 'None')
GROUP BY q.query_hash
ORDER BY count (distinct p.query_id) DESC;