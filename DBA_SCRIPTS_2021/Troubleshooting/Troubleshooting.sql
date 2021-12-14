--en master
/*
Successful connections
Failed connections
Throttling issues
Blocked by firewall attempts
Connection termination
*/
SELECT database_name,start_time,end_time,event_type, severity =
CASE Severity
WHEN 0 THEN 'Informational'
WHEN 1 THEN 'WARNING'
WHEN 2 THEN 'ERROR'
ELSE 'No Data Avaliable'
END,
description

FROM sys.event_log
--where severity=2
ORDER BY start_time DESC
--select getdate()

SELECT * FROM sys.event_log
--WHERE event_type = 'deadlock'
ORDER BY start_time DESC
--    AND database_name = 'bodylogic_live';  

-------------------------------------------------------------
--https://www.cloudiqtech.com/deadlocks-in-azure-sql-database/
-- Deadlock Detail:

SELECT * FROM sys.event_log
WHERE event_type = 'deadlock';
WITH CTE AS (
SELECT CAST(event_data AS XML)  AS [target_data_XML]
FROM sys.fn_xe_telemetry_blob_target_read_file('dl',
null, null, null)
)
SELECT target_data_XML.value('(/event/@timestamp)[1]',
'DateTime2') AS Timestamp,
target_data_XML.query('/event/data[@name=''xml_report'']
/value/deadlock') AS deadlock_xml,
target_data_XML.query('/event/data[@name=''Asea_Prod'']
/value').value('(/value)[1]', 'nvarchar(100)') AS db_name
FROM CTE

-----------------------------------------------------------

SELECT * FROM sys.event_log
--WHERE start_time >= '2011-09-25 12:00:00'
  --AND end_time <= '2011-09-28 12:00:00';
 order by start_time desc

DBCC SQLPERF(logspace)

SELECT *
  ,CAST(event_data AS XML).value('(/event/@timestamp)[1]', 'datetime2') AS TIMESTAMP
  ,CAST(event_data AS XML).value('(/event/data[@name="error"]/value)[1]', 'INT') AS error
  ,CAST(event_data AS XML).value('(/event/data[@name="state"]/value)[1]', 'INT') AS STATE
  ,CAST(event_data AS XML).value('(/event/data[@name="is_success"]/value)[1]', 'bit') AS is_success
  ,CAST(event_data AS XML).value('(/event/data[@name="database_name"]/value)[1]', 'sysname') AS database_name
FROM sys.fn_xe_telemetry_blob_target_read_file('el', NULL, NULL, NULL)
WHERE object_name = 'database_xml_deadlock_report'


--en master:
-- batch request/sec
DECLARE @v1 BIGINT, @delay SMALLINT = 2, @time DATETIME;
SELECT @time = DATEADD(SECOND, @delay, '00:00:00');
SELECT @v1 = cntr_value 
FROM master.sys.dm_os_performance_counters
WHERE counter_name = 'Batch Requests/sec';
WAITFOR DELAY @time;
SELECT (cntr_value - @v1)/@delay
FROM master.sys.dm_os_performance_counters
WHERE counter_name='Batch Requests/sec';

EXEC dba.sp_WhoIsActive	 
    @format_output = 0
    --,@destination_table = 'sp_WhoIsActive_historico'
	,@get_locks=1, @get_plans=1, @get_task_info=2, @get_additional_info=1, @get_outer_command=1
	, @get_transaction_info=1	
	,@sort_order = '[start_time] ASC'
	--,@filter=1

EXEC dba.sp_WhoIsActive	 




select name as username,
       create_date,
       modify_date,
       type_desc as type,
       authentication_type_desc as authentication_type
from sys.database_principals
where type not in ('A', 'G', 'R', 'X')
      and sid is not null
order by username;

SELECT ConnectionStatus = CASE WHEN dec.most_recent_sql_handle = 0x0 
        THEN 'Unused' 
        ELSE 'Used' 
        END
    , CASE WHEN des.status = 'Sleeping' 
        THEN 'sleeping' 
        ELSE 'Not Sleeping' 
        END
    , ConnectionCount = COUNT(1)
FROM sys.dm_exec_connections dec
    INNER JOIN sys.dm_exec_sessions des ON dec.session_id = des.session_id
GROUP BY CASE WHEN des.status = 'Sleeping' 
        THEN 'sleeping' 
        ELSE 'Not Sleeping' 
        END
    , CASE WHEN dec.most_recent_sql_handle = 0x0 
        THEN 'Unused' 
        ELSE 'Used' 
        END;


--conexiones por usuario y por base
SELECT 
    DB_NAME(dbid) as DBName, 
    COUNT(dbid) as NumberOfConnections,
    loginame as LoginName
FROM
    sys.sysprocesses
WHERE 
    dbid > 0
GROUP BY 
    dbid, loginame

SELECT 
    COUNT(dbid) as TotalConnections
FROM
    sys.sysprocesses
WHERE 
    dbid > 0


--para ver los connection pools.
SELECT 
DB_NAME(dbid) as DBName, 
COUNT(dbid) as NumberOfConnections,
loginame as LoginName, hostname, hostprocess
FROM
sys.sysprocesses with (nolock)
WHERE 
dbid > 0
GROUP BY 
dbid, loginame, hostname, hostprocess


 DECLARE @temp TABLE(spid int , ecid int, status varchar(50),
                     loginname varchar(50),   
                     hostname varchar(50),
blk varchar(50), dbname varchar(50), cmd varchar(50), request_id int) 
INSERT INTO @temp  

EXEC sp_who

SELECT COUNT(*) FROM @temp WHERE dbname = 'DB NAME'

SELECT
[DATABASE] = DB_NAME(DBID), 
OPNEDCONNECTIONS =COUNT(DBID),
[USER] =LOGINAME
FROM SYS.SYSPROCESSES
GROUP BY DBID, LOGINAME
ORDER BY DB_NAME(DBID), LOGINAME

SELECT *
FROM sys.dm_os_performance_counters
WHERE counter_name = 'User Connections';

SELECT *
FROM sys.dm_exec_connections

SELECT DB_NAME(eS.database_id) AS the_database
	, eS.is_user_process
	, COUNT(eS.session_id) AS total_database_connections
FROM sys.dm_exec_sessions eS 
GROUP BY DB_NAME(eS.database_id)
	, eS.is_user_process
ORDER BY 1, 2;



--=============================================
--Database Connections Using sys.sysprocesses
--=============================================
SELECT DB_NAME(sP.dbid) AS the_database
	, COUNT(sP.spid) AS total_database_connections
FROM sys.sysprocesses sP
GROUP BY DB_NAME(sP.dbid)
ORDER BY 1;







