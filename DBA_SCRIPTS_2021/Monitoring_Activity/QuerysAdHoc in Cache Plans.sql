SELECT *
FROM sys.dm_exec_cached_plans
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
where objtype = 'Proc'
--where objtype <> 'Proc'
order by usecounts desc

[dba].sp_BlitzCache @expertmode=1
--EXEC sp_BlitzCache @OnlySqlHandles = '0x0200000025DFEF029B7502EE241572E576ED4C0D742D964C0000000000000000000000000000000000000000'; 
EXEC sp_BlitzCache @OnlySqlHandles = '0x030006004AA8EB335602860117AD000001000000000000000000000000000000000000000000000000000000'; 

sp_helptext 'sp_calculatevolume'