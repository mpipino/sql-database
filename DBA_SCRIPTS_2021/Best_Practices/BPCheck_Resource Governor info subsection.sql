SET NOCOUNT ON;
SET ANSI_WARNINGS ON;
SET QUOTED_IDENTIFIER ON;

DECLARE @sqlmajorver int
DECLARE @sqlcmd NVARCHAR(max), @params NVARCHAR(600)

SELECT @sqlmajorver = CONVERT(int, (@@microsoftversion / 0x1000000) & 0xff);

IF @sqlmajorver > 9
BEGIN
	SELECT 'Information' AS [Category], 'RG_Classifier_Function' AS [Information], CASE WHEN classifier_function_id = 0 THEN 'Default_Configuration' ELSE OBJECT_SCHEMA_NAME(classifier_function_id) + '.' + OBJECT_NAME(classifier_function_id) END AS classifier_function, is_reconfiguration_pending
	FROM sys.dm_resource_governor_configuration

	SET @sqlcmd = 'SELECT ''Information'' AS [Category], ''RG_Resource_Pool'' AS [Information], rp.pool_id, name, statistics_start_time, total_cpu_usage_ms, cache_memory_kb, compile_memory_kb, 
	used_memgrant_kb, total_memgrant_count, total_memgrant_timeout_count, active_memgrant_count, active_memgrant_kb, memgrant_waiter_count, max_memory_kb, used_memory_kb, target_memory_kb, 
	out_of_memory_count, min_cpu_percent, max_cpu_percent, min_memory_percent, max_memory_percent' + CASE WHEN @sqlmajorver > 10 THEN ', cap_cpu_percent, rpa.processor_group, rpa.scheduler_mask' ELSE '' END + '
FROM sys.dm_resource_governor_resource_pools rp' + CASE WHEN @sqlmajorver > 10 THEN ' LEFT JOIN sys.dm_resource_governor_resource_pool_affinity rpa ON rp.pool_id = rpa.pool_id' ELSE '' END
	EXECUTE sp_executesql @sqlcmd

	SET @sqlcmd = 'SELECT ''Information'' AS [Category], ''RG_Workload_Groups'' AS [Information], group_id, name, pool_id, statistics_start_time, total_request_count, total_queued_request_count, 
	active_request_count, queued_request_count, total_cpu_limit_violation_count, total_cpu_usage_ms, max_request_cpu_time_ms, blocked_task_count, total_lock_wait_count, 
	total_lock_wait_time_ms, total_query_optimization_count, total_suboptimal_plan_generation_count, total_reduced_memgrant_count, max_request_grant_memory_kb, 
	active_parallel_thread_count, importance, request_max_memory_grant_percent, request_max_cpu_time_sec, request_memory_grant_timeout_sec, 
	group_max_requests, max_dop' + CASE WHEN @sqlmajorver > 10 THEN ', effective_max_dop' ELSE '' END + ' 
FROM sys.dm_resource_governor_workload_groups'
	EXECUTE sp_executesql @sqlcmd
END;