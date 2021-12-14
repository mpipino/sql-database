--- to identify setting on SQL Server and Azure SQL Database managed instance:

select compatibility_level, snapshot_isolation_state_desc, is_read_committed_snapshot_on,

  is_auto_update_stats_on, is_auto_update_stats_async_on, delayed_durability_desc 
from sys.databases;
GO

select * from sys.database_scoped_configurations;
GO

dbcc tracestatus;
GO

select * from sys.configurations;