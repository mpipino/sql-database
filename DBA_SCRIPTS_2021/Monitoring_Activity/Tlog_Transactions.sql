dbcc opentran
DBCC SQLPERF(logspace)
select log_reuse_wait_desc, * from sys.databases


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


---------------------------------------------
/*
--https://docs.microsoft.com/en-us/azure/azure-sql/database/understand-resolve-blocking
sys.dm_tran_active_transactions The sys.dm_tran_active_transactions DMV contains data about open transactions that c
an be joined to other DMVs for a complete picture of transactions awaiting commit or rollback. Use the following query 
to return information on open transactions, joined to other DMVs including sys.dm_tran_session_transactions. Consider a 
transaction's current state, transaction_begin_time, and other situational data to evaluate whether it could be a source 
of blocking.

*/

SELECT tst.session_id, [database_name] = db_name(s.database_id)
, tat.transaction_begin_time
, transaction_duration_s = datediff(s, tat.transaction_begin_time, sysdatetime()) 
, transaction_type = CASE tat.transaction_type  WHEN 1 THEN 'Read/write transaction'
                                                WHEN 2 THEN 'Read-only transaction'
                                                WHEN 3 THEN 'System transaction'
                                                WHEN 4 THEN 'Distributed transaction' END
, input_buffer = ib.event_info, tat.transaction_uow     
, transaction_state  = CASE tat.transaction_state    
            WHEN 0 THEN 'The transaction has not been completely initialized yet.'
            WHEN 1 THEN 'The transaction has been initialized but has not started.'
            WHEN 2 THEN 'The transaction is active - has not been committed or rolled back.'
            WHEN 3 THEN 'The transaction has ended. This is used for read-only transactions.'
            WHEN 4 THEN 'The commit process has been initiated on the distributed transaction.'
            WHEN 5 THEN 'The transaction is in a prepared state and waiting resolution.'
            WHEN 6 THEN 'The transaction has been committed.'
            WHEN 7 THEN 'The transaction is being rolled back.'
            WHEN 8 THEN 'The transaction has been rolled back.' END 
, transaction_name = tat.name, request_status = r.status
, azure_dtc_state = CASE tat.dtc_state 
                    WHEN 1 THEN 'ACTIVE'
                    WHEN 2 THEN 'PREPARED'
                    WHEN 3 THEN 'COMMITTED'
                    WHEN 4 THEN 'ABORTED'
                    WHEN 5 THEN 'RECOVERED' END
, tst.is_user_transaction, tst.is_local
, session_open_transaction_count = tst.open_transaction_count  
, s.host_name, s.program_name, s.client_interface_name, s.login_name, s.is_user_process
FROM sys.dm_tran_active_transactions tat 
INNER JOIN sys.dm_tran_session_transactions tst  on tat.transaction_id = tst.transaction_id
INNER JOIN Sys.dm_exec_sessions s on s.session_id = tst.session_id 
LEFT OUTER JOIN sys.dm_exec_requests r on r.session_id = s.session_id
CROSS APPLY sys.dm_exec_input_buffer(s.session_id, null) AS ib;



