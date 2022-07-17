-- Este esta bueno porque da el ultimo index seek asi vemos de crear indices que sean usados  
-- Missing indexes with CREATE statement for it  
SELECT    MID.[statement] AS ObjectName  
	,MID.equality_columns AS EqualityColumns  
	,MID.inequality_columns AS InequalityColms  
	,MID.included_columns AS IncludedColumns  
	,MIGS.last_user_seek AS LastUserSeek  
	,MIGS.avg_total_user_cost  
	* MIGS.avg_user_impact  * (MIGS.user_seeks + MIGS.user_scans) AS Impact  
	,N'CREATE NONCLUSTERED INDEX ix_NN_' + REPLACE(REPLACE(REPLACE(MID.equality_columns, ']', '_'),'[',''), ',','_') + '_Incl_Comp_176072022 ' +
	N'ON ' + MID.[statement] +  
	N' (' + MID.equality_columns  
	+ ISNULL(', ' + MID.inequality_columns, N'') +  
	N') ' + ISNULL(N'INCLUDE (' + MID.included_columns + N')', ' ') + 'WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs'
	AS CreateStatement   
FROM sys.dm_db_missing_index_group_stats AS MIGS  
 INNER JOIN sys.dm_db_missing_index_groups AS MIG  
	 ON MIGS.group_handle = MIG.index_group_handle  
INNER JOIN sys.dm_db_missing_index_details AS MID  
	 ON MIG.index_handle = MID.index_handle  
WHERE database_id = DB_ID()  
	 AND MIGS.last_user_seek >= DATEDIFF(day, GetDate(), -1)  
	 --and MID.included_columns is null
	 --and  MID.[statement] like '%tbl_distributor_commissions_v2%'
ORDER BY Impact DESC;
--ORDER BY LastUserSeek desc, Impact DESC;
go


--nueva:
WITH DbTuneRec
AS (SELECT ddtr.reason,
ddtr.score,
pfd.query_id,
pfd.regressedPlanId,
pfd.recommendedPlanId,
JSON_VALUE(ddtr.state,
'$.currentValue') AS CurrentState,
JSON_VALUE(ddtr.state,
'$.reason') AS CurrentStateReason,
JSON_VALUE(ddtr.details,
'$.implementationDetails.script') AS ImplementationScript
FROM sys.dm_db_tuning_recommendations AS ddtr
CROSS APPLY
OPENJSON(ddtr.details,
'$.planForceDetails')
WITH (query_id INT '$.queryId',
regressedPlanId INT '$.regressedPlanId',
recommendedPlanId INT '$.recommendedPlanId') AS pfd)
SELECT qsq.query_id,
dtr.reason,
dtr.score,
dtr.CurrentState,
dtr.CurrentStateReason,
qsqt.query_sql_text,
CAST(rp.query_plan AS XML) AS RegressedPlan,
CAST(sp.query_plan AS XML) AS SuggestedPlan,
dtr.ImplementationScript
FROM DbTuneRec AS dtr
JOIN sys.query_store_plan AS rp
ON rp.query_id = dtr.query_id
AND rp.plan_id = dtr.regressedPlanId
JOIN sys.query_store_plan AS sp
ON sp.query_id = dtr.query_id
AND sp.plan_id = dtr.recommendedPlanId
JOIN sys.query_store_query AS qsq
ON qsq.query_id = rp.query_id
JOIN sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id;












