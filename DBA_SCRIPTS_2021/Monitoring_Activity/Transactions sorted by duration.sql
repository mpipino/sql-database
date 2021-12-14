-- Transactions sorted by duration
SELECT st.session_id,
       dt.database_transaction_begin_time,
       DATEDIFF(second, dt.database_transaction_begin_time, CURRENT_TIMESTAMP) AS transaction_duration_seconds,
       dt.database_transaction_log_bytes_used,
       dt.database_transaction_log_bytes_reserved,
       st.is_user_transaction,
       st.open_transaction_count,
       ib.event_type,
       ib.parameters,
       ib.event_info
FROM sys.dm_tran_database_transactions AS dt
INNER JOIN sys.dm_tran_session_transactions AS st
ON dt.transaction_id = st.transaction_id
OUTER APPLY sys.dm_exec_input_buffer(st.session_id, default) AS ib
WHERE dt.database_id = DB_ID()
ORDER BY transaction_duration_seconds DESC;