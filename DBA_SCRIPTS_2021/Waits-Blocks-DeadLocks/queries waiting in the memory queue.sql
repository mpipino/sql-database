--Find all queries waiting in the memory queue  
SELECT * FROM sys.dm_exec_query_memory_grants where grant_time is null  