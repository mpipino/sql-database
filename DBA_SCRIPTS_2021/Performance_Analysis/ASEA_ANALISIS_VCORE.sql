/*
Purchasing Models:
https://docs.microsoft.com/en-us/azure/azure-sql/database/purchasing-models#:~:text=There%20are%20two%20purchasing%20models,available%20for%20Azure%20SQL%20Database.
LINKS:
https://docs.microsoft.com/en-us/azure/azure-sql/database/migrate-dtu-to-vcore
https://docs.microsoft.com/en-us/azure/azure-sql/database/single-database-scale
Downtime:
https://docs.microsoft.com/en-us/azure/azure-sql/database/scale-resources
VCORE:
https://docs.microsoft.com/en-us/azure/azure-sql/database/service-tiers-vcore
https://docs.microsoft.com/en-us/azure/azure-sql/database/service-tiers-sql-database-vcore
VCORE Limits:
https://docs.microsoft.com/en-us/azure/azure-sql/database/resource-limits-vcore-single-databases
DTU Limits:
https://docs.microsoft.com/en-us/azure/azure-sql/database/resource-limits-dtu-single-databases
https://youtu.be/1AKDj0_wOFs
PRICING:
https://azure.microsoft.com/en-us/pricing/details/azure-sql-managed-instance/single/
https://docs.microsoft.com/en-us/azure/azure-sql/database/reserved-capacity-overview
*/


/*
VCORE equivalente al modelo DTUs, en ASEA_PROD:
dtu_service_tier
Premium
vcore_service_tier
Business Critical or Hyperscale
Gen5_vcores
18.000
Gen5_memory_per_core_gb
5.05
Fsv2_memory_per_core_gb
1.89
M_vcores
16.200
M_memory_per_core_gb
29.4
*/

WITH dtu_vcore_map AS
(
SELECT rg.slo_name,
       DATABASEPROPERTYEX(DB_NAME(), 'Edition') AS dtu_service_tier,
       CASE WHEN rg.slo_name LIKE '%SQLG4%' THEN 'Gen4'
            WHEN rg.slo_name LIKE '%SQLGZ%' THEN 'Gen4'
            WHEN rg.slo_name LIKE '%SQLG5%' THEN 'Gen5'
            WHEN rg.slo_name LIKE '%SQLG6%' THEN 'Gen5'
            WHEN rg.slo_name LIKE '%SQLG7%' THEN 'Gen5'
       END AS dtu_hardware_gen,
       s.scheduler_count * CAST(rg.instance_cap_cpu/100. AS decimal(3,2)) AS dtu_logical_cpus,
       CAST((jo.process_memory_limit_mb / s.scheduler_count) / 1024. AS decimal(4,2)) AS dtu_memory_per_core_gb
FROM sys.dm_user_db_resource_governance AS rg
CROSS JOIN (SELECT COUNT(1) AS scheduler_count FROM sys.dm_os_schedulers WHERE status = 'VISIBLE ONLINE') AS s
CROSS JOIN sys.dm_os_job_object AS jo
WHERE rg.dtu_limit > 0
      AND
      DB_NAME() <> 'master'
      AND
      rg.database_id = DB_ID()
)
SELECT dtu_logical_cpus,
       dtu_hardware_gen,
       dtu_memory_per_core_gb,
       dtu_service_tier,
       CASE WHEN dtu_service_tier = 'Basic' THEN 'General Purpose'
            WHEN dtu_service_tier = 'Standard' THEN 'General Purpose or Hyperscale'
            WHEN dtu_service_tier = 'Premium' THEN 'Business Critical or Hyperscale'
       END AS vcore_service_tier,
       CASE WHEN dtu_hardware_gen = 'Gen4' THEN dtu_logical_cpus
            WHEN dtu_hardware_gen = 'Gen5' THEN dtu_logical_cpus * 0.7
       END AS Gen4_vcores,
       7 AS Gen4_memory_per_core_gb,
       CASE WHEN dtu_hardware_gen = 'Gen4' THEN dtu_logical_cpus * 1.7
            WHEN dtu_hardware_gen = 'Gen5' THEN dtu_logical_cpus
       END AS Gen5_vcores,
       5.05 AS Gen5_memory_per_core_gb,
       CASE WHEN dtu_hardware_gen = 'Gen4' THEN dtu_logical_cpus
            WHEN dtu_hardware_gen = 'Gen5' THEN dtu_logical_cpus * 0.8
       END AS Fsv2_vcores,
       1.89 AS Fsv2_memory_per_core_gb,
       CASE WHEN dtu_hardware_gen = 'Gen4' THEN dtu_logical_cpus * 1.4
            WHEN dtu_hardware_gen = 'Gen5' THEN dtu_logical_cpus * 0.9
       END AS M_vcores,
       29.4 AS M_memory_per_core_gb
FROM dtu_vcore_map;


--cuanta memoria, si tenes vcore.
SELECT cpu_rate / 100 as CPU_vCores,
	CAST( (process_memory_limit_mb) /1024. as DECIMAL(9,1)) as TotalMemoryGB
FROM sys.dm_os_job_object;


SELECT
(total_physical_memory_kb/1024) AS Total_OS_Memory_MB,
(available_physical_memory_kb/1024)  AS Available_OS_Memory_MB
FROM sys.dm_os_sys_memory;

SELECT  
(physical_memory_in_use_kb/1024) AS Memory_used_by_Sqlserver_MB,  
(locked_page_allocations_kb/1024) AS Locked_pages_used_by_Sqlserver_MB,  
(total_virtual_address_space_kb/1024) AS Total_VAS_in_MB,
process_physical_memory_low,  
process_virtual_memory_low  
FROM sys.dm_os_process_memory;


-- este anduvo en Azure con DTU:
SELECT
sqlserver_start_time,
(committed_kb/1024) AS Total_Server_Memory_MB,
(committed_target_kb/1024)  AS Target_Server_Memory_MB
FROM sys.dm_os_sys_info; --2022-01-01 23:53:03.630	84723	84723
-----------------------------------------------------------------

