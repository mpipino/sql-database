-- Connect to master
-- Info detallada por base.
SELECT *
FROM sys.resource_stats
--WHERE database_name = 'BodyLogic_Test'
ORDER BY end_time DESC;

SELECT * FROM sys.dm_db_resource_stats ORDER BY end_time DESC;  

-- Connect to database
-- Database data space allocated in MB and database data space allocated unused in MB
SELECT SUM(size/128.0) AS DatabaseDataSpaceAllocatedInMB,
SUM(size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0) AS DatabaseDataSpaceAllocatedUnusedInMB
FROM sys.database_files
GROUP BY type_desc
HAVING type_desc = 'ROWS';
/* BodyLogic_Live
DatabaseDataSpaceAllocatedInMB          DatabaseDataSpaceAllocatedUnusedInMB
--------------------------------------- ---------------------------------------
88384.000000                            30989.312500
Completion time: 2021-03-03T19:16:45.9558041-03:00
*/

-- Connect to database
-- Database data max size in bytes
SELECT DATABASEPROPERTYEX('BodyLogic_Live', 'MaxSizeInBytes') AS DatabaseDataMaxSizeInBytes;