SELECT sssn.login_time,
       DATEDIFF(MILLISECOND, conn.connect_time, sssn.login_time)
                  AS [MillisecondsBetweenConnectionAndSessionStart],
       conn.*,
       sssn.[program_name],
       sssn.host_process_id,
       sssn.client_interface_name,
       sssn.login_name,
       qry.[text]
FROM sys.dm_exec_connections conn
INNER JOIN sys.dm_exec_sessions sssn
        ON sssn.session_id = conn.session_id
OUTER APPLY sys.dm_exec_sql_text(conn.most_recent_sql_handle) qry
WHERE conn.session_id <> conn.most_recent_session_id
OR    DATEDIFF(MILLISECOND, conn.connect_time, sssn.login_time) > 50
ORDER BY conn.connect_time;

SELECT count(*)
FROM sys.dm_exec_connections conn
INNER JOIN sys.dm_exec_sessions sssn
        ON sssn.session_id = conn.session_id
OUTER APPLY sys.dm_exec_sql_text(conn.most_recent_sql_handle) qry
WHERE conn.session_id <> conn.most_recent_session_id
OR    DATEDIFF(MILLISECOND, conn.connect_time, sssn.login_time) > 50
waitfor delay '00:00:5'
go 1000