/*
Let’s say you are troubleshooting a report from the application team on perceived slow-down of an application.  
You use the Waits and Queues methodology , and your analysis reveals blocking as your primary bottleneck.  
If you have a significant number of database objects, you can use sys.dm_db_index_operational_stats to 
efficiently identify tables associated with a significant amount of blocking.  Relevant columns from this DMV 
include row_lock_wait_count, row_lock_wait_in_ms, page_lock_wait_count, and page_lock_wait_in_ms.  ( On a side 
note – you can also identify latching waits through this DMV via the page_latch_wait_count, 
page_latch_wait_in_ms, page_io_latch_wait_count, and page_io_latch_wait_in_ms columns .)

The following query demonstrates identifying the top n objects associated with waits on page locks:

*/
SELECT TOP 10 OBJECT_NAME(o.object_id, o.database_id) object_nm
	,o.index_id
	,partition_number
	,page_lock_wait_count
	,page_lock_wait_in_ms
	,CASE 
		WHEN mid.database_id IS NULL
			THEN 'N'
		ELSE 'Y'
		END AS missing_index_identified
FROM sys.dm_db_index_operational_stats(db_id(), NULL, NULL, NULL) o
LEFT OUTER JOIN (
	SELECT DISTINCT database_id
		,object_id
	FROM sys.dm_db_missing_index_details
	) AS mid ON mid.database_id = o.database_id
	AND mid.object_id = o.object_id
ORDER BY page_lock_wait_count DESC


/*
Lock Escalations.

You can use sys.dm_db_index_operational_stats to track how many attempts were made to escalate to 
table locks (index_lock_promotion_attempt_count), as well as how many times escalations actually 
succeeded (index_lock_promotion_count).  
The following query shows the top three objects with the highest number of escalations:
*/
SELECT TOP 3 OBJECT_NAME(object_id, database_id) object_nm
	,index_id
	,partition_number
	,index_lock_promotion_attempt_count
	,index_lock_promotion_count
FROM sys.dm_db_index_operational_stats(db_id(), NULL, NULL, NULL)
ORDER BY index_lock_promotion_count DESC







