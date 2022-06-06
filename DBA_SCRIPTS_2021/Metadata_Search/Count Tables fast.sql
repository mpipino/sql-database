SELECT distinct schema_name(schema_id)+'.'+name as tablename, row_count as rows
FROM sys.dm_db_partition_stats ps
              inner join sys.objects o
			    on ps.object_id = o.object_id
ORDER BY Rows DESC;