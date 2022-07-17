--En que tablas se espera mas


select 
    object_name(ops.object_id)         as [Object Name]
    , sum(ops.range_scan_count)         as [Range Scans]
    , sum(ops.singleton_lookup_count)   as [Singleton Lookups]
    , sum(ops.row_lock_count)           as [Row Locks]
    , sum(ops.row_lock_wait_in_ms)      as [Row Lock Waits (ms)]
    , sum(ops.page_lock_count)          as [Page Locks]
    , sum(ops.page_lock_wait_in_ms)     as [Page Lock Waits (ms)]
    , sum(ops.page_io_latch_wait_in_ms) as [Page IO Latch Wait (ms)]
from sys.dm_db_index_operational_stats(null,null,NULL,NULL) as ops
  inner join sys.indexes as idx on idx.object_id = ops.object_id and idx.index_id = ops.index_id
  inner join sys.sysindexes as sysidx on idx.object_id = sysidx.id
--where ops.object_id = 1542973269 
group by ops.object_id
order by sum(ops.page_io_latch_wait_in_ms) desc