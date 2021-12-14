

Declare @Database varchar(max)
Declare @Tabla varchar(max)
select  
                        GETDATE() AS SNAPSHOT_DATE,
                        S.[Name] as Tabla, 
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
Where  S.[Name] = 'TBL_DISTRIBUTOR'
--(@Tabla is null or S.[name] = @Tabla)
and S.type = 'U'
--and SIU.database_id = DB_ID(@Database)
--Order by Tabla, Si.index_id
Order by SIu.user_seeks DESC