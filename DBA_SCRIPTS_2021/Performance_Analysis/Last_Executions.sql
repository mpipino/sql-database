-- Stored Procedures mas lentos por ultima ejecucion:
SELECT TOP 500 d.object_id, db_name(d.database_id) as BaseDatos, OBJECT_NAME(object_id, database_id) 'proc name', 
d.cached_time, d.last_execution_time, d.total_elapsed_time, d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],
d.last_elapsed_time, d.execution_count,max_logical_reads,max_logical_writes
FROM sys.dm_exec_procedure_stats AS d
--where OBJECT_NAME(object_id, database_id) like '%SP_DISTRIBUTOR_GETADVANCESEARCH%'
ORDER BY last_execution_time desc --, max_logical_reads desc, [total_worker_time] DESC;