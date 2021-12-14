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

-- Most used SPs with missing indexes
;WITH
 XMLNAMESPACES
     (DEFAULT N'http://schemas.microsoft.com/sqlserver/2004/07/showplan' 
             ,N'http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS ShowPlan)     
SELECT ECP.[usecounts]    AS [UsageCounts]
      ,ECP.[refcounts]    AS [RefencedCounts]
      ,ECP.[objtype]      AS [ObjectType]
      ,ECP.[cacheobjtype] AS [CacheObjectType]
      ,EST.[dbid]         AS [DatabaseID]
      ,EST.[objectid]     AS [ObjectID]
      ,EST.[text]         AS [Statement]     
      ,EQP.[query_plan]   AS [QueryPlan]
FROM sys.dm_exec_cached_plans AS ECP
     CROSS APPLY sys.dm_exec_sql_text(ECP.[plan_handle]) AS EST
     CROSS APPLY sys.dm_exec_query_plan(ECP.[plan_handle]) AS EQP
WHERE ECP.[usecounts] > 1  -- Plan should be used more then one time (= no AdHoc queries)
      AND EQP.[query_plan].exist(N'/ShowPlanXML/BatchSequence/Batch/Statements/StmtSimple/QueryPlan/MissingIndexes/MissingIndexGroup') <> 0
ORDER BY ECP.[usecounts] DESC
go


