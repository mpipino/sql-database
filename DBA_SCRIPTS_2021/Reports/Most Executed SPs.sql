

-- Para ver los SPs
-- que mas se ejecutan

SELECT TOP 10
d.object_id, db_name(d.database_id) as BaseDatos, OBJECT_NAME(object_id,
database_id) 'proc name', 

d.cached_time,
d.last_execution_time, d.total_elapsed_time,
d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],

d.last_elapsed_time,
d.execution_count,max_logical_reads

FROM
sys.dm_exec_procedure_stats AS d

ORDER BY
execution_count DESC;