-- Stored Procedures mas lentos, ALGUIEN CORRIO ALGO PESADO HACE POCO?:
-- QUE EJECUTARON EN LOS ULTIMOS MINUTOS¿?
SELECT TOP 50 d.object_id, db_name(d.database_id) as BaseDatos, OBJECT_NAME(object_id, database_id) 'proc name', 
d.cached_time, d.last_execution_time, d.total_elapsed_time, d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],
d.last_elapsed_time, d.execution_count,max_logical_reads,max_logical_writes, max_logical_reads  * 8.0 / 1024 / 1024 as READS_GB
, max_logical_writes  * 8.0 / 1024 / 1024 as WRITES_GB
FROM sys.dm_exec_procedure_stats AS d
--where  OBJECT_NAME(object_id, database_id) like 'SP_RPT_SALESPRODUCTSUMMARYBYDAY%'
--ORDER BY last_execution_time desc --, max_logical_reads desc, [total_worker_time] DESC;
ORDER BY max_logical_reads desc

select 27520284/1000000