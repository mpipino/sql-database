--Creates the ALTER INDEX Statements
 
SET NOCOUNT ON
SELECT ps.[reserved_page_count]
,o.[name]
,'ALTER INDEX '+ '[' + i.[name] + ']' + ' ON ' + '[' + s.[name] + ']' + '.' + '[' + o.[name] + ']' + ' REBUILD WITH (ONLINE=ON, DATA_COMPRESSION=PAGE);'

FROM sys.objects AS o WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON o.[object_id] = i.[object_id]
INNER JOIN sys.schemas s WITH (NOLOCK)
ON o.[schema_id] = s.[schema_id]
INNER JOIN sys.dm_db_partition_stats AS ps WITH (NOLOCK)
ON i.[object_id] = ps.[object_id]
AND ps.[index_id] = i.[index_id]
WHERE o.type = 'U' AND i.[index_id] >1 -->0
ORDER BY ps.[reserved_page_count] desc
/*
No hay waits por uso de CPU. Comprimir no supone un problema de presión de cpu
*/