--Creates the ALTER INDEX Statements
 
SET NOCOUNT ON
SELECT 'ALTER INDEX '+ '[' + i.[name] + ']' + ' ON ' + '[' + s.[name] + ']' + '.' + '[' + o.[name] + ']' + ' REBUILD WITH (DATA_COMPRESSION=PAGE);'
	, ps.[reserved_page_count],*
FROM sys.objects AS o WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON o.[object_id] = i.[object_id]
INNER JOIN sys.schemas s WITH (NOLOCK)
ON o.[schema_id] = s.[schema_id]
INNER JOIN sys.dm_db_partition_stats AS ps WITH (NOLOCK)
ON i.[object_id] = ps.[object_id]
AND ps.[index_id] = i.[index_id]
--WHERE o.type = 'U' AND i.[index_id] >0 and o.name='tbl_Orders_Header' 
ORDER BY ps.[reserved_page_count] desc


SET NOCOUNT ON

GO

SELECT DISTINCT

SERVERPROPERTY('servername') [instance]

,DB_NAME() [database]

,QUOTENAME(OBJECT_SCHEMA_NAME(sp.object_id)) +'.'+QUOTENAME(Object_name(sp.object_id))

,ix.name [index_name]

,sp.data_compression

,sp.data_compression_desc

FROM sys.partitions SP

LEFT OUTER JOIN sys.indexes IX

ON sp.object_id = ix.object_id

and sp.index_id = ix.index_id

WHERE sp.data_compression <> 0

ORDER BY 2;



------------------------------------------------------------------------------------------------------------------

/*
	Busca_INDICESyTABLAS_Comprimidos
*/
SELECT [t].[name] AS [Table], [p].[partition_number] AS [Partition],
    [p].[data_compression_desc] AS [Compression]
FROM [sys].[partitions] AS [p]
INNER JOIN sys.tables AS [t] ON [t].[object_id] = [p].[object_id]
WHERE [p].[index_id] in (0,1)

SELECT [t].[name] AS [Table], [i].[name] AS [Index],  
    [p].[partition_number] AS [Partition],
    [p].[data_compression_desc] AS [Compression]
FROM [sys].[partitions] AS [p]
INNER JOIN sys.tables AS [t] ON [t].[object_id] = [p].[object_id]
INNER JOIN sys.indexes AS [i] ON [i].[object_id] = [p].[object_id] AND [i].[index_id] = [p].[index_id]
WHERE [p].[index_id] > 1
ORDER BY [t].[name] asc


