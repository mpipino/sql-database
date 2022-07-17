--You can also query master or directly the database using TSQL
-- Connect to master
-- Database data space used in MB
SELECT TOP 1 storage_in_megabytes AS DatabaseDataSpaceUsedInMB
FROM sys.resource_stats
WHERE database_name = 'logging'
ORDER BY end_time DESC


------------------------------
-- Connect to database
-- Database data space allocated in MB and database data space allocated unused in MB
SELECT SUM(size/128.0) AS DatabaseDataSpaceAllocatedInMB,
SUM(size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0) AS DatabaseDataSpaceAllocatedUnusedInMB
FROM sys.database_files
GROUP BY type_desc
HAVING type_desc = 'ROWS'

-- Connect to database
-- Database data max size in bytes
SELECT DATABASEPROPERTYEX('Logging', 'MaxSizeInBytes') AS DatabaseDataMaxSizeInBytes