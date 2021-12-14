SELECT 
@@servername as server,
db_name() as BD,
dbschemas.[name] as 'Schema',
dbtables.[name] as 'Table',
dbindexes.[name] as 'Index',
indexstats.alloc_unit_type_desc,
convert(decimal (10,2), indexstats.avg_fragmentation_in_percent) as avg_fragmentation_in_percent,
indexstats.page_count,
getdate() as Fecha_Analisis
FROM sys.dm_db_index_physical_stats (db_id(DB_NAME()), NULL, NULL, NULL, NULL) AS indexstats -- PedidosFtp_Sap=7
INNER JOIN sys.tables dbtables on dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas on dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
AND indexstats.index_id = dbindexes.index_id
WHERE indexstats.database_id = DB_ID() 
ORDER BY indexstats.page_count desc