EXEC dba.sp_WhoIsActive	 
    @format_output = 0
    ,@destination_table = 'dba.sp_WhoIsActive_historico'
	,@get_locks=1, @get_plans=1, @get_task_info=2, @get_additional_info=1, @get_outer_command=1
	, @get_transaction_info=1	
	,@sort_order = '[start_time] ASC'
	--,@filter=1
waitfor delay '00:00:01'
go 60

EXEC dba.sp_WhoIsActive	 	
waitfor delay '00:00:01'
go 60

DBCC SQLPERF(logspace)



--use BodyLogic_Live
/*
-- Stored Procedures mas lentos:
-- 
SELECT TOP 50 d.object_id, db_name(d.database_id) as BaseDatos, OBJECT_NAME(object_id, database_id) 'proc name', 
d.cached_time, d.last_execution_time, d.total_elapsed_time, d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],
d.last_elapsed_time, d.execution_count,max_logical_reads
FROM sys.dm_exec_procedure_stats AS d
ORDER BY max_logical_reads desc, [total_worker_time] DESC;
*/

-- Este esta bueno porque da el ultimo index seek asi vemos de crear indices que sean usados  
-- Missing indexes with CREATE statement for it  
SELECT    MID.[statement] AS ObjectName  
	,MID.equality_columns AS EqualityColumns  
	,MID.inequality_columns AS InequalityColms  
	,MID.included_columns AS IncludedColumns  
	,MIGS.last_user_seek AS LastUserSeek  
	,MIGS.avg_total_user_cost  
	* MIGS.avg_user_impact  * (MIGS.user_seeks + MIGS.user_scans) AS Impact  
	,N'CREATE NONCLUSTERED INDEX <Add Index Name here> ' +  
	N'ON ' + MID.[statement] +  
	N' (' + MID.equality_columns  
	+ ISNULL(', ' + MID.inequality_columns, N'') +  
	N') ' + ISNULL(N'INCLUDE (' + MID.included_columns + N');', ';')  
	AS CreateStatement  
 
FROM sys.dm_db_missing_index_group_stats AS MIGS  
 INNER JOIN sys.dm_db_missing_index_groups AS MIG  
	 ON MIGS.group_handle = MIG.index_group_handle  
INNER JOIN sys.dm_db_missing_index_details AS MID  
	 ON MIG.index_handle = MID.index_handle  
WHERE database_id = DB_ID()  
	 AND MIGS.last_user_seek >= DATEDIFF(month, GetDate(), -1)  
ORDER BY LastUserSeek desc, Impact DESC;
go


SELECT 'Waiting_tasks' AS [Information], owt.session_id,
	owt.wait_duration_ms, owt.wait_type, owt.blocking_session_id,
	owt.resource_description, es.program_name, est.text,
	est.dbid, eqp.query_plan, er.database_id, es.cpu_time,
	es.memory_usage*8 AS memory_usage_KB
FROM sys.dm_os_waiting_tasks owt
INNER JOIN sys.dm_exec_sessions es ON owt.session_id = es.session_id
INNER JOIN sys.dm_exec_requests er ON es.session_id = er.session_id
OUTER APPLY sys.dm_exec_sql_text (er.sql_handle) est
OUTER APPLY sys.dm_exec_query_plan (er.plan_handle) eqp
WHERE es.is_user_process = 1
ORDER BY owt.session_id;
GO



--WAITFOR DELAY '00:00:11'

exec dba.sp_BlitzCache @ExpertMode = 1, @SortOrder = 'reads', @Top=20
--EXEC dba.sp_BlitzCache @OnlySqlHandles = '0x030007007434F64C7C5C20014DAC000001000000000000000000000000000000000000000000000000000000'; 
--EXEC dba.sp_BlitzCache @OnlyQueryHashes = '0x98506896B840E8A0'; 
--EXEC dba.sp_BlitzCache @OnlySqlHandles = '0x02000000EA301C3A2CB152044BA4CB337ECC87ADDEC2D6510000000000000000000000000000000000000000'; 

select * from sys.dm_db_resource_stats


/*
IO por base
*/
WITH IO_Per_DB
AS
(SELECT 
  DB_NAME(database_id) AS Db
  , CONVERT(DECIMAL(12,2), SUM(num_of_bytes_read + num_of_bytes_written) / 1024 / 1024) AS TotalMb
 FROM sys.dm_io_virtual_file_stats(NULL, NULL) dmivfs
 GROUP BY database_id)
 SELECT 
    Db
    ,TotalMb
    ,CAST(TotalMb / SUM(TotalMb) OVER() * 100 AS DECIMAL(5,2)) AS [I/O]
FROM IO_Per_DB
ORDER BY [I/O] DESC;


-- retrieve every query plan from the plan cache  
SELECT * FROM sys.dm_exec_cached_plans cp CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle);  
GO  








/*
page splits
*/
SELECT 
getdate() as snapshot_date ,
IOS.INDEX_ID,
O.NAME AS OBJECT_NAME,
I.NAME AS INDEX_NAME,
IOS.LEAF_ALLOCATION_COUNT AS PAGE_SPLIT_FOR_INDEX,
IOS.NONLEAF_ALLOCATION_COUNT PAGE_ALLOCATION_CAUSED_BY_PAGESPLIT
FROM SYS.DM_DB_INDEX_OPERATIONAL_STATS(DB_ID(N'DB_NAME'),NULL,NULL,NULL) IOS
JOIN
SYS.INDEXES I
ON
IOS.INDEX_ID=I.INDEX_ID
AND IOS.OBJECT_ID = I.OBJECT_ID
JOIN
SYS.OBJECTS O
ON
IOS.OBJECT_ID=O.OBJECT_ID
--WHERE O.TYPE_DESC='USER_TABLE'
--ORDER BY PAGE_ALLOCATION_CAUSED_BY_PAGESPLIT DESC
ORDER BY PAGE_SPLIT_FOR_INDEX DESC


---------------------------------




--Dashboard
EXEC dba.sp_BlitzFirst @expertmode=1




-- Executions Plan with convert inplicit.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @dbname SYSNAME
SET @dbname = QUOTENAME(DB_NAME());

WITH XMLNAMESPACES
   (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
SELECT
   stmt.value('(@StatementText)[1]', 'varchar(max)') as STATEMENT,
   t.value('(ScalarOperator/Identifier/ColumnReference/@Schema)[1]', 'varchar(128)') as [Schema],
   t.value('(ScalarOperator/Identifier/ColumnReference/@Table)[1]', 'varchar(128)') as [Table],
   t.value('(ScalarOperator/Identifier/ColumnReference/@Column)[1]', 'varchar(128)'),
   ic.DATA_TYPE AS ConvertFrom,
   ic.CHARACTER_MAXIMUM_LENGTH AS ConvertFromLength,
   t.value('(@DataType)[1]', 'varchar(128)') AS ConvertTo,
   t.value('(@Length)[1]', 'int') AS ConvertToLength,
   query_plan
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp
CROSS APPLY query_plan.nodes('/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple') AS batch(stmt)
CROSS APPLY stmt.nodes('.//Convert[@Implicit="1"]') AS n(t)
JOIN INFORMATION_SCHEMA.COLUMNS AS ic
   ON QUOTENAME(ic.TABLE_SCHEMA) = t.value('(ScalarOperator/Identifier/ColumnReference/@Schema)[1]', 'varchar(128)')
   AND QUOTENAME(ic.TABLE_NAME) = t.value('(ScalarOperator/Identifier/ColumnReference/@Table)[1]', 'varchar(128)')
   AND ic.COLUMN_NAME = t.value('(ScalarOperator/Identifier/ColumnReference/@Column)[1]', 'varchar(128)')
WHERE t.exist('ScalarOperator/Identifier/ColumnReference[@Database=sql:variable("@dbname")][@Schema!="[sys]"]') = 1






--kill 93



SELECT TOP (1000) *
  FROM [WMS].[dbo].[sp_WhoIsActive_historico] with (nolock)






SELECT  TS.session_id ,
        TS.request_id ,
        TS.database_id ,
        CAST(TS.user_objects_alloc_page_count / 128 AS DECIMAL(15, 2)) [Total Allocation User Objects MB] ,
        CAST(( TS.user_objects_alloc_page_count
               - TS.user_objects_dealloc_page_count ) / 128 AS DECIMAL(15, 2)) [Net Allocation User Objects MB] ,
        CAST(TS.internal_objects_alloc_page_count / 128 AS DECIMAL(15, 2)) [Total Allocation Internal Objects MB] ,
        CAST(( TS.internal_objects_alloc_page_count
               - TS.internal_objects_dealloc_page_count ) / 128 AS DECIMAL(15,
                                                              2)) [Net Allocation Internal Objects MB] ,
        CAST(( TS.user_objects_alloc_page_count
               + internal_objects_alloc_page_count ) / 128 AS DECIMAL(15, 2)) [Total Allocation MB] ,
        CAST(( TS.user_objects_alloc_page_count
               + TS.internal_objects_alloc_page_count
               - TS.internal_objects_dealloc_page_count
               - TS.user_objects_dealloc_page_count ) / 128 AS DECIMAL(15, 2)) [Net Allocation MB] ,
        T.text [Query Text]
FROM    sys.dm_db_task_space_usage TS
        INNER JOIN sys.dm_exec_requests ER ON ER.request_id = TS.request_id
                                              AND ER.session_id = TS.session_id
        OUTER APPLY sys.dm_exec_sql_text(ER.sql_handle) T


SELECT * FROM sys.dm_io_virtual_file_stats (NULL, NULL);
GO




-----------------------------------------------------------------------------------------------------------------------------
/*
	MuestraObjetosUsandoCACHEdeSQL
*/

-- Note: querying sys.dm_os_buffer_descriptors
-- requires the VIEW_SERVER_STATE permission.
DECLARE @total_buffer INT;
SELECT @total_buffer = cntr_value
   FROM sys.dm_os_performance_counters 
   WHERE RTRIM([object_name]) LIKE '%Buffer Manager'
   AND counter_name = 'Total Pages';
;WITH src AS
(
   SELECT 
       database_id, db_buffer_pages = COUNT_BIG(*)
       FROM sys.dm_os_buffer_descriptors
       --WHERE database_id BETWEEN 5 AND 32766
       GROUP BY database_id
)
SELECT
   [db_name] = CASE [database_id] WHEN 32767 
       THEN 'Resource DB' 
       ELSE DB_NAME([database_id]) END,
   db_buffer_pages,
   db_buffer_MB = db_buffer_pages / 128,
   db_buffer_percent = CONVERT(DECIMAL(6,3), 
       db_buffer_pages * 100.0 / @total_buffer)
FROM src
ORDER BY db_buffer_MB DESC;


-----------------------------------------------------------------------------------------------------------------------------
/*
	CACHECalculaEspacioUtilizadoporSPROC
*/
SELECT objtype AS [CacheType]
        , count_big(*) AS [Total Plans]
        , sum(cast(size_in_bytes as decimal(18,2)))/1024/1024 AS [Total MBs]
        , avg(usecounts) AS [Avg Use Count]
        , sum(cast((CASE WHEN usecounts = 1 THEN size_in_bytes ELSE 0 END) as decimal(18,2)))/1024/1024 AS [Total MBs – USE Count 1]
        , sum(CASE WHEN usecounts = 1 THEN 1 ELSE 0 END) AS [Total Plans – USE Count 1]
FROM sys.dm_exec_cached_plans
GROUP BY objtype
ORDER BY [Total MBs – USE Count 1] DESC
go


-----------------------------------------------------------------------------------------------------------------------------
/*
	CantidadDeEjecucionesdeSPs
	llamadas por segundo
*/

SELECT
    OBJECT_NAME(qt.objectid) AS 'SP'
  , SUM(qs.execution_count) AS [Execution Count]
  , SUM(qs.execution_count) / DATEDIFF(Second, MIN(qs.creation_time), GETDATE()) AS [Calls/Second]
  , SUM(qs.total_worker_time) / SUM(qs.execution_count) AS [AvgWorkerTime]
  , SUM(qs.total_worker_time) AS [TotalWorkerTime]
  , SUM(qs.total_elapsed_time) / SUM(qs.execution_count) AS [AvgElapsedTime]
  , SUM(qs.max_logical_reads) AS [LECTURAS]
  , SUM(qs.max_logical_writes) AS [ESCRITURAS]
  , SUM(qs.total_physical_reads) AS [LECTURAS_FISICAS]
FROM
    sys.dm_exec_query_stats AS qs
CROSS APPLY 
    sys.dm_exec_sql_text(qs.[sql_handle]) AS qt
WHERE
    qt.[dbid] = DB_ID()
GROUP BY qt.objectid
ORDER BY 2 DESC

DBCC MEMORYSTATUS 



SELECT 'DETALLE DE QUE ESTA EJECUTANDO CON PLAN DE EJECUCION, READS, WRITES, CPU TIME'  
SELECT	r.session_id,  
		se.host_name,  
		se.login_name,  
		Db_name(r.database_id) AS dbname,  
		r.status,  
		r.command,  
		r.cpu_time,  
		r.total_elapsed_time,  
		r.reads,  
		r.logical_reads,  
		r.writes,  
		s.text AS sql_text,  
		p.query_plan AS query_plan,  
		SQL_CURSORSQL.text,  
		SQL_CURSORPLAN.query_plan  
FROM	sys.dm_exec_requests r  
INNER JOIN sys.dm_exec_sessions se  
		ON r.session_id = se.session_id  

OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) s  
OUTER APPLY sys.dm_exec_query_plan(r.plan_handle) p  
OUTER APPLY sys.dm_exec_cursors(r.session_id) AS SQL_CURSORS  
OUTER APPLY sys.dm_exec_sql_text(SQL_CURSORS.sql_handle) AS SQL_CURSORSQL  
LEFT JOIN sys.dm_exec_query_stats AS SQL_CURSORSTATS  
		ON SQL_CURSORSTATS.sql_handle = SQL_CURSORS.sql_handle  
OUTER APPLY sys.dm_exec_query_plan(SQL_CURSORSTATS.plan_handle) AS SQL_CURSORPLAN  

WHERE	r.session_id <> @@SPID  
		AND se.is_user_process = 1  
		AND r.Logical_Reads > 2000