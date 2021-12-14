[dba].sp_BlitzCache @StoredProcName = 'Bl_Autoship_Distributor_Discounts'

[dba].sp_BlitzCache

SELECT *
FROM sys.dm_exec_cached_plans
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
where objtype <> 'Proc'
order by usecounts desc

[dba].sp_BlitzCache @expertmode=1
EXEC [dba].sp_BlitzCache @OnlySqlHandles = '0x0200000025DFEF029B7502EE241572E576ED4C0D742D964C0000000000000000000000000000000000000000'; 