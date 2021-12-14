-- Este esta bueno porque da el ultimo index seek asi vemos de crear indices que sean usados  
-- Missing indexes with CREATE statement for it  
SELECT    MID.[statement] AS ObjectName  
	,MID.equality_columns AS EqualityColumns  
	,MID.inequality_columns AS InequalityColms  
	,MID.included_columns AS IncludedColumns  
	,MIGS.last_user_seek AS LastUserSeek  
	,MIGS.avg_total_user_cost  
	* MIGS.avg_user_impact  * (MIGS.user_seeks + MIGS.user_scans) AS Impact  
	,N'CREATE NONCLUSTERED INDEX ix_NN_' + REPLACE(REPLACE(REPLACE(MID.equality_columns, ']', '_'),'[',''), ',','_') + '_Incl_Comp_4_1_2021 ' +
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
	 AND MIGS.last_user_seek >= DATEDIFF(month, GetDate(), -1)  
ORDER BY LastUserSeek desc, Impact DESC;
go


-------------------------------------------


-- Missing indexes
Declare @Database varchar--(max)
Declare @Tabla varchar--(max)
Set @Database = 'Express_Test' 
--Set @Tabla = 'Materiales'
--Set @Tabla = 'TRF_TRANSFERS'
select  S.[Name] as Tabla, 
             s.object_id,
             Si.[name] As Indice, SI.[index_id], SI.[type_desc] as Tipo_Indice,
             SIu.user_seeks,
             SIU.user_scans,
             SIU.user_lookups,
             SIU.user_updates,
             SIU.last_user_seek,
             SIU.last_user_scan,
             SIU.last_user_lookup,
             SIU.last_user_update
From sys.objects S 
Inner Join sys.indexes SI On S.object_id = SI.object_id
Inner Join sys.dm_db_index_usage_stats SIU On Siu.object_id = SI.object_id and SIU.index_id = SI.index_id
Where 
 --(@Tabla is null or S.[name] = @Tabla) and 
 S.type = 'U'
--and SIU.database_id = DB_ID--(@Database)
--Order by Tabla, Si.index_id
Order by SIu.user_seeks DESC