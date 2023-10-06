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


SELECT
OBJECT_SCHEMA_NAME(ips.OBJECT_ID) 'Schema',
OBJECT_NAME(ips.OBJECT_ID) 'Table',
i.NAME,
ips.index_id,
index_type_desc,
avg_fragmentation_in_percent,
avg_page_space_used_in_percent,
page_count
FROM
sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') ips
INNER JOIN
sys.indexes i
ON (ips.object_id = i.object_id)
AND
(
ips.index_id = i.index_id
)
ORDER BY
avg_fragmentation_in_percent DESC
