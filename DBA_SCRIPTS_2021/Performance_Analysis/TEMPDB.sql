/*

Top queries that use table variables and temporary tables
https://docs.microsoft.com/en-us/azure/azure-sql/database/monitoring-with-dmvs#identify-tempdb-performance-issues

Use the following query to identify top queries that use table variables and temporary tables:

*/

SELECT plan_handle, execution_count, query_plan
INTO #tmpPlan
FROM sys.dm_exec_query_stats
     CROSS APPLY sys.dm_exec_query_plan(plan_handle);
GO

WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS sp)
SELECT plan_handle, stmt.stmt_details.value('@Database', 'varchar(max)') 'Database', stmt.stmt_details.value('@Schema', 'varchar(max)') 'Schema', stmt.stmt_details.value('@Table', 'varchar(max)') 'table'
INTO #tmp2
FROM(SELECT CAST(query_plan AS XML) sqlplan, plan_handle FROM #tmpPlan) AS p
    CROSS APPLY sqlplan.nodes('//sp:Object') AS stmt(stmt_details);
GO

SELECT t.plan_handle, [Database], [Schema], [table], execution_count
FROM(SELECT DISTINCT plan_handle, [Database], [Schema], [table]
     FROM #tmp2
     WHERE [table] LIKE '%@%' OR [table] LIKE '%#%') AS t
    JOIN #tmpPlan AS t2 ON t.plan_handle=t2.plan_handle;

--6k rows wen executed on ASEA_STAGE!!!!!!!!!

---------------------------------------------------------------------------------------
--Identify long running transactions
--Use the following query to identify long running transactions. Long running transactions prevent version store cleanup.
SELECT DB_NAME(dtr.database_id) 'database_name',
       sess.session_id,
       atr.name AS 'tran_name',
       atr.transaction_id,
       transaction_type,
       transaction_begin_time,
       database_transaction_begin_time transaction_state,
       is_user_transaction,
       sess.open_transaction_count,
       LTRIM(RTRIM(REPLACE(
                              REPLACE(
                                         SUBSTRING(
                                                      SUBSTRING(
                                                                   txt.text,
                                                                   (req.statement_start_offset / 2) + 1,
                                                                   ((CASE req.statement_end_offset
                                                                         WHEN -1 THEN
                                                                             DATALENGTH(txt.text)
                                                                         ELSE
                                                                             req.statement_end_offset
                                                                     END - req.statement_start_offset
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
            ) Running_stmt_text,
       recenttxt.text 'MostRecentSQLText'
FROM sys.dm_tran_active_transactions AS atr
    INNER JOIN sys.dm_tran_database_transactions AS dtr
        ON dtr.transaction_id = atr.transaction_id
    LEFT JOIN sys.dm_tran_session_transactions AS sess
        ON sess.transaction_id = atr.transaction_id
    LEFT JOIN sys.dm_exec_requests AS req
        ON req.session_id = sess.session_id
           AND req.transaction_id = sess.transaction_id
    LEFT JOIN sys.dm_exec_connections AS conn
        ON sess.session_id = conn.session_id
    OUTER APPLY sys.dm_exec_sql_text(req.sql_handle) AS txt
    OUTER APPLY sys.dm_exec_sql_text(conn.most_recent_sql_handle) AS recenttxt
WHERE atr.transaction_type != 2
      AND sess.session_id != @@spid
ORDER BY start_time ASC;

kill 327
-----------------------------------------------------------------------------------------------------------

-- Obtaining the space consumed by internal objects in all currently running tasks in each session
SELECT session_id,
  SUM(internal_objects_alloc_page_count) AS task_internal_objects_alloc_page_count,
  SUM(internal_objects_dealloc_page_count) AS task_internal_objects_dealloc_page_count
FROM sys.dm_db_task_space_usage
GROUP BY session_id;

-- Obtaining the space consumed by internal objects in the current session for both running and completed tasks
SELECT R2.session_id,
  R1.internal_objects_alloc_page_count
  + SUM(R2.internal_objects_alloc_page_count) AS session_internal_objects_alloc_page_count,
  R1.internal_objects_dealloc_page_count
  + SUM(R2.internal_objects_dealloc_page_count) AS session_internal_objects_dealloc_page_count
FROM sys.dm_db_session_space_usage AS R1
INNER JOIN sys.dm_db_task_space_usage AS R2 ON R1.session_id = R2.session_id
GROUP BY R2.session_id, R1.internal_objects_alloc_page_count,
  R1.internal_objects_dealloc_page_count;

-----------------------------------------------------------------------------------------
-- Determining the amount of free space in tempdb
SELECT SUM(unallocated_extent_page_count) AS [free pages],
  (SUM(unallocated_extent_page_count)*1.0/128) AS [free space in MB]
FROM sys.dm_db_file_space_usage;

-- Determining the amount of space used by the version store
SELECT SUM(version_store_reserved_page_count) AS [version store pages used],
  (SUM(version_store_reserved_page_count)*1.0/128) AS [version store space in MB]
FROM sys.dm_db_file_space_usage;

-- Determining the amount of space used by internal objects
SELECT SUM(internal_object_reserved_page_count) AS [internal object pages used],
  (SUM(internal_object_reserved_page_count)*1.0/128) AS [internal object space in MB]
FROM sys.dm_db_file_space_usage;

-- Determining the amount of space used by user objects
SELECT SUM(user_object_reserved_page_count) AS [user object pages used],
  (SUM(user_object_reserved_page_count)*1.0/128) AS [user object space in MB]
FROM sys.dm_db_file_space_usage;



-- Determining the Amount of Space Used  / free
SELECT 
	 [Source] = 'database_files'
	,[TEMPDB_max_size_MB] = SUM(max_size) * 8 / 1027.0
	,[TEMPDB_current_size_MB] = SUM(size) * 8 / 1027.0
	,[FileCount] = COUNT(FILE_ID)
FROM tempdb.sys.database_files
WHERE type = 0 --ROWS


--not for Azure.
SELECT 
	 [Source] = 'dm_db_file_space_usage'
	,[free_space_MB] = SUM(U.unallocated_extent_page_count) * 8 / 1024.0
	,[used_space_MB] = SUM(U.internal_object_reserved_page_count + U.user_object_reserved_page_count + U.version_store_reserved_page_count) * 8 / 1024.0
    ,[internal_object_space_MB] = SUM(U.internal_object_reserved_page_count) * 8 / 1024.0
    ,[user_object_space_MB] = SUM(U.user_object_reserved_page_count) * 8 / 1024.0
    ,[version_store_space_MB] = SUM(U.version_store_reserved_page_count) * 8 / 1024.0
FROM tempdb.sys.dm_db_file_space_usage U



-- Obtaining the space consumed currently in each session
SELECT 
	 [Source] = 'dm_db_session_space_usage'
	,[session_id] = Su.session_id
	,[login_name] = MAX(S.login_name)
	,[database_id] = MAX(S.database_id)
	,[database_name] = MAX(D.name)
	,[elastic_pool_name] = MAX(DSO.elastic_pool_name)
	,[internal_objects_alloc_page_count_MB] = SUM(internal_objects_alloc_page_count) * 8 / 1024.0
	,[user_objects_alloc_page_count_MB] = SUM(user_objects_alloc_page_count) * 8 / 1024.0
FROM tempdb.sys.dm_db_session_space_usage SU
LEFT JOIN sys.dm_exec_sessions S
        ON SU.session_id = S.session_id
LEFT JOIN sys.database_service_objectives DSO
        ON S.database_id = DSO.database_id
LEFT JOIN sys.databases D
	ON S.database_id = D.database_id
WHERE internal_objects_alloc_page_count + user_objects_alloc_page_count > 0
GROUP BY Su.session_id
ORDER BY [user_objects_alloc_page_count_MB] desc, Su.session_id;

--------------------------------------------------------

-- Obtaining the space consumed in all currently running tasks in each session
SELECT 
	 [Source] = 'dm_db_task_space_usage'
	,[session_id] = SU.session_id
	,[login_name] = MAX(S.login_name)
	,[database_id] = MAX(S.database_id)
	,[database_name] = MAX(D.name)
	,[elastic_pool_name] = MAX(DSO.elastic_pool_name)
	,[internal_objects_alloc_page_count_MB] = SUM(SU.internal_objects_alloc_page_count) * 8 / 1024.0
	,[user_objects_alloc_page_count_MB] = SUM(SU.user_objects_alloc_page_count) * 8 / 1024.0
--FROM tempdb.sys.dm_db_task_space_usage SU --para named instances o on premise.
FROM sys.dm_db_task_space_usage SU
LEFT JOIN sys.dm_exec_sessions S
        ON SU.session_id = S.session_id
LEFT JOIN sys.database_service_objectives DSO
        ON S.database_id = DSO.database_id
LEFT JOIN sys.databases D
	ON S.database_id = D.database_id
WHERE internal_objects_alloc_page_count + user_objects_alloc_page_count > 0
GROUP BY SU.session_id
ORDER BY [user_objects_alloc_page_count_MB] desc, session_id;








