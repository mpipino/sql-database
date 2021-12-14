--bloqueos
--USE Master
--GO
SELECT session_id, wait_duration_ms, wait_type, blocking_session_id 
FROM sys.dm_os_waiting_tasks 
WHERE blocking_session_id <> 0
GO




--bloqueos
SELECT
db.name DBName,
tl.request_session_id,
wt.blocking_session_id,
OBJECT_NAME(p.OBJECT_ID) BlockedObjectName,
tl.resource_type,
h1.TEXT AS RequestingText,
h2.TEXT AS BlockingTest,
tl.request_mode
FROM sys.dm_tran_locks AS tl
INNER JOIN sys.databases db ON db.database_id = tl.resource_database_id
INNER JOIN sys.dm_os_waiting_tasks AS wt ON tl.lock_owner_address = wt.resource_address
INNER JOIN sys.partitions AS p ON p.hobt_id = tl.resource_associated_entity_id
INNER JOIN sys.dm_exec_connections ec1 ON ec1.session_id = tl.request_session_id
INNER JOIN sys.dm_exec_connections ec2 ON ec2.session_id = wt.blocking_session_id
CROSS APPLY sys.dm_exec_sql_text(ec1.most_recent_sql_handle) AS h1
CROSS APPLY sys.dm_exec_sql_text(ec2.most_recent_sql_handle) AS h2
GO


/*

to find the actively executing queries and their current SQL batch text or input buffer text, using the sys.dm_exec_sql_text 
or sys.dm_exec_input_buffer DMVs. If the data returned by the text field of sys.dm_exec_sql_text is NULL, the query is not 
currently executing. In that case, the event_info field of sys.dm_exec_input_buffer will contain the last command string passed
to the SQL engine. 
This query can also be used to identify sessions blocking other sessions, including a list of session_ids blocked per session_id.

*/

WITH cteBL (session_id, blocking_these) AS 
(SELECT s.session_id, blocking_these = x.blocking_these FROM sys.dm_exec_sessions s 
CROSS APPLY    (SELECT isnull(convert(varchar(6), er.session_id),'') + ', '  
                FROM sys.dm_exec_requests as er
                WHERE er.blocking_session_id = isnull(s.session_id ,0)
                AND er.blocking_session_id <> 0
                FOR XML PATH('') ) AS x (blocking_these)
)
SELECT s.session_id, blocked_by = r.blocking_session_id, bl.blocking_these
, batch_text = t.text, input_buffer = ib.event_info, * 
FROM sys.dm_exec_sessions s 
LEFT OUTER JOIN sys.dm_exec_requests r on r.session_id = s.session_id
INNER JOIN cteBL as bl on s.session_id = bl.session_id
OUTER APPLY sys.dm_exec_sql_text (r.sql_handle) t
OUTER APPLY sys.dm_exec_input_buffer(s.session_id, NULL) AS ib
WHERE blocking_these is not null or r.blocking_session_id > 0
ORDER BY len(bl.blocking_these) desc, r.blocking_session_id desc, r.session_id;


/*
--https://docs.microsoft.com/en-us/azure/azure-sql/database/understand-resolve-blocking
Run this more elaborate sample query, provided by Microsoft Support, to identify the head of a multiple session 
blocking chain, including the query text of the sessions involved in a blocking chain.
*/
WITH cteHead ( session_id,request_id,wait_type,wait_resource,last_wait_type,is_user_process,request_cpu_time
,request_logical_reads,request_reads,request_writes,wait_time,blocking_session_id,memory_usage
,session_cpu_time,session_reads,session_writes,session_logical_reads
,percent_complete,est_completion_time,request_start_time,request_status,command
,plan_handle,sql_handle,statement_start_offset,statement_end_offset,most_recent_sql_handle
,session_status,group_id,query_hash,query_plan_hash) 
AS ( SELECT sess.session_id, req.request_id, LEFT (ISNULL (req.wait_type, ''), 50) AS 'wait_type'
    , LEFT (ISNULL (req.wait_resource, ''), 40) AS 'wait_resource', LEFT (req.last_wait_type, 50) AS 'last_wait_type'
    , sess.is_user_process, req.cpu_time AS 'request_cpu_time', req.logical_reads AS 'request_logical_reads'
    , req.reads AS 'request_reads', req.writes AS 'request_writes', req.wait_time, req.blocking_session_id,sess.memory_usage
    , sess.cpu_time AS 'session_cpu_time', sess.reads AS 'session_reads', sess.writes AS 'session_writes', sess.logical_reads AS 'session_logical_reads'
    , CONVERT (decimal(5,2), req.percent_complete) AS 'percent_complete', req.estimated_completion_time AS 'est_completion_time'
    , req.start_time AS 'request_start_time', LEFT (req.status, 15) AS 'request_status', req.command
    , req.plan_handle, req.[sql_handle], req.statement_start_offset, req.statement_end_offset, conn.most_recent_sql_handle
    , LEFT (sess.status, 15) AS 'session_status', sess.group_id, req.query_hash, req.query_plan_hash
    FROM sys.dm_exec_sessions AS sess
    LEFT OUTER JOIN sys.dm_exec_requests AS req ON sess.session_id = req.session_id
    LEFT OUTER JOIN sys.dm_exec_connections AS conn on conn.session_id = sess.session_id 
    )
, cteBlockingHierarchy (head_blocker_session_id, session_id, blocking_session_id, wait_type, wait_duration_ms,
wait_resource, statement_start_offset, statement_end_offset, plan_handle, sql_handle, most_recent_sql_handle, [Level])
AS ( SELECT head.session_id AS head_blocker_session_id, head.session_id AS session_id, head.blocking_session_id
    , head.wait_type, head.wait_time, head.wait_resource, head.statement_start_offset, head.statement_end_offset
    , head.plan_handle, head.sql_handle, head.most_recent_sql_handle, 0 AS [Level]
    FROM cteHead AS head
    WHERE (head.blocking_session_id IS NULL OR head.blocking_session_id = 0)
    AND head.session_id IN (SELECT DISTINCT blocking_session_id FROM cteHead WHERE blocking_session_id != 0)
    UNION ALL
    SELECT h.head_blocker_session_id, blocked.session_id, blocked.blocking_session_id, blocked.wait_type,
    blocked.wait_time, blocked.wait_resource, h.statement_start_offset, h.statement_end_offset,
    h.plan_handle, h.sql_handle, h.most_recent_sql_handle, [Level] + 1
    FROM cteHead AS blocked
    INNER JOIN cteBlockingHierarchy AS h ON h.session_id = blocked.blocking_session_id and h.session_id!=blocked.session_id --avoid infinite recursion for latch type of blocking
    WHERE h.wait_type COLLATE Latin1_General_BIN NOT IN ('EXCHANGE', 'CXPACKET') or h.wait_type is null
    )
SELECT bh.*, txt.text AS blocker_query_or_most_recent_query 
FROM cteBlockingHierarchy AS bh 
OUTER APPLY sys.dm_exec_sql_text (ISNULL ([sql_handle], most_recent_sql_handle)) AS txt;

--------------------------------------------------------------------
/*

To catch long-running or uncommitted transactions, use another set of DMVs for viewing current open transactions, including sys.dm_tran_database_transactions
, sys.dm_tran_session_transactions,  sys.dm_exec_connections, and sys.dm_exec_sql_text. There are several DMVs associated with tracking transactions
, see more DMVs on transactions here.

*/
SELECT [s_tst].[session_id],
[database_name] = DB_NAME (s_tdt.database_id),
[s_tdt].[database_transaction_begin_time], 
[sql_text] = [s_est].[text] 
FROM sys.dm_tran_database_transactions [s_tdt]
INNER JOIN sys.dm_tran_session_transactions [s_tst] ON [s_tst].[transaction_id] = [s_tdt].[transaction_id]
INNER JOIN sys.dm_exec_connections [s_ec] ON [s_ec].[session_id] = [s_tst].[session_id]
CROSS APPLY sys.dm_exec_sql_text ([s_ec].[most_recent_sql_handle]) AS [s_est];

----------------------------------------------------------------------------------------------------------------------------


--SELECT TOP 1000 
--     R.[Request_id]
--    ,Request_queue_time_sec = CONVERT(numeric(25,3),DATEDIFF(ms,R.[submit_time],R.[start_time]) / 1000.0)
--    ,Request_compile_time_sec = CONVERT(numeric(25,3),DATEDIFF(ms,R.[start_time],R.[end_compile_time]) / 1000.0)
--    ,Request_execution_time_sec = CONVERT(numeric(25,3),DATEDIFF(ms,R.[end_compile_time],R.[end_time]) / 1000.0)
--    ,Total_Elapsed_time_sec = CONVERT(numeric(25,2),R.[total_Elapsed_time] / 1000.0)
--    ,Total_Elapsed_time_min = CONVERT(numeric(25,2),R.[total_Elapsed_time] / 1000.0 / 60 )
--    ,nbr_files
--    ,gb_processed
--    ,R.* 
--FROM sys.dm_pdw_exec_requests R
--LEFT JOIN (
--    SELECT 
--        request_id
--        ,count(distinct input_name) as nbr_files
--        ,sum(bytes_processed)/1024/1024/1024 as gb_processed
--    FROM sys.dm_pdw_dms_external_work s
--    GROUP BY s.request_id
--) S
--    ON r.request_id = s.request_id
--WHERE R.session_id <> session_id()
----AND submit_time >= DATEADD(hour, -2, sysdatetime())
--AND status = 'Running' -- ONLY RUNNING
--AND R.resource_class IS NOT NULL -- REMOVE BATCH QIDs
--ORDER BY submit_time DESC


--SELECT * FROM sys.dm_pdw_request_steps 
--WHERE request_id = 'QID35849'

--SELECT 
--     Total_Elapsed_time_sec = CONVERT(numeric(25,2),[total_Elapsed_time] / 1000.0)
--    ,Total_Elapsed_time_min = CONVERT(numeric(25,2),[total_Elapsed_time] / 1000.0 / 60 )
--    ,* 
----FROM sys.dm_pdw_sql_requests 
--WHERE request_id = 'QID35849'
--ORDER BY [total_Elapsed_time] desc


--SELECT * FROM sys.dm_pdw_waits 
--WHERE request_id = 'QID35849'
--WHERE blocked.state <> 'Granted' -- WAITING FOR SOMETHING

-- blocked session info
--WITH blocked_sessions (login_name, blocked_session, state, type, command, object)
--AS
--(
--SELECT 
--    sessions.login_name,
--    blocked.session_id as blocked_session, 
--    blocked.state , 
--    blocked.type,
--    requests.command,
--    blocked.object_name
--    FROM sys.dm_pdw_waits blocked
--    JOIN sys.dm_pdw_exec_requests requests
--        ON blocked.request_id = requests.request_id
--    JOIN sys.dm_pdw_exec_sessions sessions
--        ON blocked.session_id = sessions.session_id
--    WHERE blocked.state <> 'Granted'
--    )
----merging with blocking session info
--SELECT 
--    blocked_sessions.login_name as blocked_user,
--    blocked_sessions.blocked_session as blocked_session,
--    blocked_sessions.state as blocked_state,
--    blocked_sessions.type as blocked_type,
--    blocked_sessions.command as blocked_command,
--    sessions.login_name as blocking_user,
--    blocking.session_id as blocking_session, 
--    blocking.state as blocking_state, 
--    blocking.type as blocking_type,
--    requests.command as blocking_command
--    FROM sys.dm_pdw_waits blocking
--    JOIN blocked_sessions 
--        ON blocked_sessions.object = blocking.object_name
--    JOIN sys.dm_pdw_exec_requests requests
--        ON blocking.request_id = requests.request_id
--    JOIN sys.dm_pdw_exec_sessions sessions
--        ON blocking.session_id = sessions.session_id
--    WHERE blocking.state = 'Granted'