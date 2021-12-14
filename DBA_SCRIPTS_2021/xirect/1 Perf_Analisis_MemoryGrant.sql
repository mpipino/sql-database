--Gather and report on most memory hungry queries
--the top 50 queries with the highest memory grants. 
DECLARE @Reportinginterval int;
DECLARE @Database sysname;
DECLARE @StartDateText varchar(30);
DECLARE @TotalExecutions decimal(20,3);
DECLARE @TotalDuration decimal(20,3);
DECLARE @TotalCPU decimal(20,3);
DECLARE @TotalLogicalReads decimal(20,3);
DECLARE @SQL varchar(MAX);

--Set Reporting interval in days
SET @Reportinginterval = 1;

SET @StartDateText = CAST(DATEADD(DAY, -@Reportinginterval, GETUTCDATE()) AS varchar(30));

--Cursor to step through the databases
DECLARE curDatabases CURSOR FAST_FORWARD FOR
SELECT [name]
FROM sys.databases 
WHERE is_query_store_on = 1
  AND state_desc = 'ONLINE';

--Temp table to store the results
DROP TABLE IF EXISTS #Stats;
CREATE TABLE #Stats (
   DatabaseName sysname,
   SchemaName sysname NULL,
   ObjectName sysname NULL,
   QueryText varchar(1000),
   MaxMemoryGrantMB decimal(20,3)
);

OPEN curDatabases;
FETCH NEXT FROM curDatabases INTO @Database;

--Loop through the datbases and gather the stats
WHILE @@FETCH_STATUS = 0
BEGIN
    
    SET @SQL = '
	   USE [' + @Database + ']
	   INSERT INTO #Stats
		SELECT
			DB_NAME(),
			s.name AS SchemaName,
			o.name AS ObjectName,
			SUBSTRING(t.query_sql_text,1,1000) AS QueryText,
			(MAX(rs.max_query_max_used_memory)/128) AS MaxMemoryMB
		FROM sys.query_store_query q
		INNER JOIN sys.query_store_query_text t
			ON q.query_text_id = t.query_text_id
		INNER JOIN sys.query_store_plan p
			ON q.query_id = p.query_id
		INNER JOIN sys.query_store_runtime_stats rs
			ON p.plan_id = rs.plan_id
		INNER JOIN sys.query_store_runtime_stats_interval rsi
			ON rs.runtime_stats_interval_id = rsi.runtime_stats_interval_id
		LEFT JOIN sys.objects o
			ON q.OBJECT_ID = o.OBJECT_ID
		LEFT JOIN sys.schemas s
			ON o.schema_id = s.schema_id     
		WHERE rsi.start_time > ''' + @StartDateText + '''
		GROUP BY s.name, o.name, SUBSTRING(t.query_sql_text,1,1000)
		OPTION(RECOMPILE);'

    EXEC (@SQL);

    FETCH NEXT FROM curDatabases INTO @Database;
END;

CLOSE curDatabases;
DEALLOCATE curDatabases;

--Report Results
SELECT TOP 50
	getdate() as runtime,
	DatabaseName,
	SchemaName,
	ObjectName,
	QueryText,
	MaxMemoryGrantMB
FROM #Stats
WHERE QueryText not like 'INSERT INTO #Stats%' --Exclude current query
ORDER BY MaxMemoryGrantMB DESC;

DROP TABLE #Stats;





SELECT mg.session_id
,mg.granted_memory_kb
,mg.requested_memory_kb
,mg.ideal_memory_kb
,mg.request_time
,mg.grant_time
,mg.query_cost
,mg.dop
,st.[TEXT]
,qp.query_plan,*
FROM sys.dm_exec_query_memory_grants AS mg
CROSS APPLY sys.dm_exec_sql_text(mg.plan_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(mg.plan_handle) AS qp
ORDER BY mg.required_memory_kb DESC;


-- Find single-use, ad-hoc queries that are bloating the plan cache
SELECT TOP(100) [text], cp.size_in_bytes
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_sql_text(plan_handle) 
WHERE cp.cacheobjtype = N'Compiled Plan' 
AND cp.objtype = N'Adhoc' 
AND cp.usecounts = 1
ORDER BY cp.size_in_bytes DESC;