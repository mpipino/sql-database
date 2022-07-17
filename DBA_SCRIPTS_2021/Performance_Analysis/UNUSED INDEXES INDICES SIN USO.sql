SELECT   
o.name AS TableName,  
i.name AS Indexname,  
i.is_primary_key AS PrimaryKey,  
s.user_seeks + s.user_scans + s.user_lookups AS NumOfReads,  
s.user_updates AS NumOfWrites,  
(SELECT SUM(p.rows) FROM sys.partitions p WHERE p.index_id = s.index_id AND s.object_id = p.object_id) AS TableRows,  
'DROP INDEX ' + QUOTENAME(i.name) + ' ON ' + QUOTENAME(c.name) + '.' + QUOTENAME(OBJECT_NAME(s.object_id)) AS 'DropStatement'  
FROM sys.dm_db_index_usage_stats s   
INNER JOIN sys.indexes i ON i.index_id = s.index_id AND s.object_id = i.object_id   
INNER JOIN sys.objects o ON s.object_id = o.object_id  
INNER JOIN sys.schemAS c ON o.schema_id = c.schema_id  
WHERE OBJECTPROPERTY(s.object_id,'IsUserTable') = 1  
AND s.databASe_id = DB_ID()   
AND i.type_desc = 'NONCLUSTERED'  
AND i.is_primary_key = 0  
AND i.is_unique_constraint = 0  
AND s.user_seeks + s.user_scans + s.user_lookups =0