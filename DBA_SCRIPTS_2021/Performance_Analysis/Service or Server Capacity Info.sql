SELECT @@VERSION
SELECT * FROM sys.databases
SELECT * FROM sys.objects
SELECT * FROM sys.dm_os_schedulers
SELECT * FROM sys.dm_os_sys_info
SELECT * FROM sys.dm_os_process_memory --Not supported in Azure SQL Database
SELECT * FROM sys.dm_exec_requests
SELECT SERVERPROPERTY('EngineEdition')
SELECT * FROM sys.dm_user_db_resource_governance -- Only available in Azure SQL DB and MI
SELECT * FROM sys.dm_instance_resource_governance -- Only available in Azure SQL MI
SELECT * FROM sys.dm_os_job_object -- Only available in Azure SQL DB and MI

SELECT * FROM sys.dm_db_resource_stats;


/*
--https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-db-resource-stats-azure-sql-database?view=azuresqldb-current

avg_memory_usage_percent:
Average memory utilization in percentage of the limit of the service tier.
This includes memory used for buffer pool pages and storage of In-Memory OLTP objects.
*/
SELECT * FROM sys.dm_db_resource_stats ORDER BY end_time DESC