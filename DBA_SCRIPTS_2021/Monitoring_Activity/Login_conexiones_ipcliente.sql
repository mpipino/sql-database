--Login, conexiones, ip cliente, etc
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT 
SPID = er.session_id 
,BlkBy = er.blocking_session_id 
,ElapsedMS = er.total_elapsed_time 
,CPU = er.cpu_time 
,IOReads = er.logical_reads + er.reads 
,IOWrites = er.writes 
,Executions = ec.execution_count 
,CommandType = er.command 
,ObjectName = OBJECT_SCHEMA_NAME(qt.objectid,dbid) + '.' + OBJECT_NAME(qt.objectid, qt.dbid) 
,SQLStatement = 
SUBSTRING 
( 
qt.text, 
er.statement_start_offset/2, 
(CASE WHEN er.statement_end_offset = -1 
THEN LEN(CONVERT(nvarchar(MAX), qt.text)) * 2 
ELSE er.statement_end_offset 
END - er.statement_start_offset)/2 
) 
,Status = ses.status 
,[Login] = ses.login_name 
,Host = ses.host_name 
,DBName = DB_Name(er.database_id) 
,LastWaitType = er.last_wait_type 
,StartTime = er.start_time 
,Protocol = con.net_transport 
,transaction_isolation = 
CASE ses.transaction_isolation_level 
WHEN 0 THEN 'Unspecified' 
WHEN 1 THEN 'Read Uncommitted' 
WHEN 2 THEN 'Read Committed' 
WHEN 3 THEN 'Repeatable' 
WHEN 4 THEN 'Serializable' 
WHEN 5 THEN 'Snapshot' 
END 
,ConnectionWrites = con.num_writes 
,ConnectionReads = con.num_reads 
,ClientAddress = con.client_net_address 
,Authentication = con.auth_scheme 
FROM sys.dm_exec_requests er 
LEFT JOIN sys.dm_exec_sessions ses ON ses.session_id = er.session_id 
LEFT JOIN sys.dm_exec_connections con ON con.session_id = ses.session_id 
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) as qt 
OUTER APPLY 
( 
SELECT execution_count = MAX(cp.usecounts) 
FROM sys.dm_exec_cached_plans cp 
WHERE cp.plan_handle = er.plan_handle 
) ec 
ORDER BY 
er.blocking_session_id DESC, 
er.logical_reads + er.reads DESC, 
er.session_id;



SELECT  SS.session_id ,        SS.database_id ,
        CAST(SS.user_objects_alloc_page_count / 128 AS DECIMAL(15, 2)) [Total Allocation User Objects MB] ,
        CAST(( SS.user_objects_alloc_page_count
               - SS.user_objects_dealloc_page_count ) / 128 AS DECIMAL(15, 2)) [Net Allocation User Objects MB] ,
        CAST(SS.internal_objects_alloc_page_count / 128 AS DECIMAL(15, 2)) [Total Allocation Internal Objects MB] ,
        CAST(( SS.internal_objects_alloc_page_count
               - SS.internal_objects_dealloc_page_count ) / 128 AS DECIMAL(15,
                                                              2)) [Net Allocation Internal Objects MB] ,
        CAST(( SS.user_objects_alloc_page_count
               + internal_objects_alloc_page_count ) / 128 AS DECIMAL(15, 2)) [Total Allocation MB] ,
        CAST(( SS.user_objects_alloc_page_count
               + SS.internal_objects_alloc_page_count
               - SS.internal_objects_dealloc_page_count
               - SS.user_objects_dealloc_page_count ) / 128 AS DECIMAL(15, 2)) [Net Allocation MB] ,
        T.text [Query Text]
FROM    sys.dm_db_session_space_usage SS
        LEFT JOIN sys.dm_exec_connections CN ON CN.session_id = SS.session_id
        OUTER APPLY sys.dm_exec_sql_text(CN.most_recent_sql_handle) T

------------------------------------------------------------------------------------------------------------------

SELECT DB_NAME(dbid) as DBName, loginame, HOSTNAME, COUNT(dbid) as cantidad_por_bd
    --DB_NAME(dbid) as DBName, 
    --COUNT(dbid) as NumberOfConnections,
    --loginame as LoginName
--INTO DBAADMIN..tblConexionesPorBasePorLogin
FROM
    sys.sysprocesses
WHERE 
    dbid > 0
GROUP BY 
    dbid, loginame, HOSTNAME
order by COUNT(dbid) desc
;