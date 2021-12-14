/*
dormant = SQL Server is resetting the session.
running = The session is running one or more batches. When Multiple Active Result Sets --(MARS) is enabled, a session can run multiple batches. For more information, see Using Multiple Active Result Sets --(MARS).
background = The session is running a background task, such as deadlock detection.
rollback = The session has a transaction rollback in process.
pending = The session is waiting for a worker thread to become available.
runnable = The task in the session is in the runnable queue of a scheduler while waiting to get a time quantum.
spinloop = The task in the session is waiting for a spinlock to become free.
suspended = The session is waiting for an event, such as I/O, to complete.
*/

--EXEC dba.sp_WhoIsActive	 
--    @format_output = 0
--    ,@destination_table = 'dba.sp_WhoIsActive_historico'
--	,@get_locks=1, @get_plans=1, @get_task_info=2, @get_additional_info=1, @get_outer_command=1
--	, @get_transaction_info=1	
--	,@sort_order = '[start_time] ASC'
--waitfor delay '00:00:05'
--go 720

[dba].[sp_BlitzFirst] @CheckProcedureCache=1

[dba].sp_BlitzCache @StoredProcName = 'sp_CalculateVolume'

--exec sp_CalculateVolume with recompile
 select * from tbl_Commission_Run_Logs 
 --where rundate = '2021-04-21' --and id >= 2915522
 order by CreatedDate desc

EXEC [dba].sp_WhoIsActive 
        @find_block_leaders = 1,
        @get_plans = 1,
        @sort_order = '[blocked_session_count] DESC'

EXEC [dba].sp_WhoIsActive
    @filter = '',
    @filter_type = 'session',
    @not_filter = '',
    @not_filter_type = 'session',
    @show_own_spid = 0,
    @show_system_spids = 0,
    @show_sleeping_spids = 1,
    @get_full_inner_text = 1,
    @get_plans = 1,
    @get_outer_command = 1,
    @get_transaction_info = 1,
    @get_task_info = 2,
    @get_locks = 1,
    @get_avg_time = 1,
    @get_additional_info = 1,
    @find_block_leaders = 1,
    @delta_interval = 1,
    @output_column_list = '[dd%][session_id][sql_text][sql_command][login_name][wait_info][tasks][tran_log%][cpu%][temp%][block%][reads%][writes%][context%][physical%][query_plan][locks][%]',
    @sort_order = '[start_time] ASC',
    @format_output = 1,    
    @return_schema = 0,
    @schema = NULL,
    @help = 0 
	,@destination_table = 'dba.sp_WhoIsActive_historico'
--waitfor delay '00:00:30'
--go 920
go 200

--truncate table [dba].[sp_WhoIsActive_historico]

SELECT *
  FROM [dba].[sp_WhoIsActive_historico] with --(nolock)
  where login_name <> 'NT AUTHORITY\SYSTEM'
 -- where convert--(varchar--(8000),sql_command) like '%sp_CalculateVolume%'
  order by collection_time asc

  
  

--kill 201
--aseastage
--Asea_Stage.dbo.sp_CalculateVolume;1
EXEC dba.sp_WhoIsActive	 
--dba.sp_BlitzCache @StoredProcName = 'sp_CalculateVolume', @sortorder='Reads'
--kill 165




dbcc opentran
DBCC SQLPERF--(logspace)
go 10

--kill 148
--kill 153


EXEC dba.sp_WhoIsActive	 
    @format_output = 0
    --,@destination_table = 'sp_WhoIsActive_historico'
	,@get_locks=1, @get_plans=1, @get_task_info=2, @get_additional_info=1, @get_outer_command=1
	, @get_transaction_info=1	
	,@sort_order = '[start_time] ASC'
	--,@filter=1
WAITFOR DELAY '00:00:10'
GO 120


--para crear la tabla
DECLARE @s VARCHAR--(MAX)
EXEC [dba].sp_WhoIsActive
    @filter = '',
    @filter_type = 'session',
    @not_filter = '',
    @not_filter_type = 'session',
    @show_own_spid = 0,
    @show_system_spids = 0,
    @show_sleeping_spids = 1,
    @get_full_inner_text = 1,
    @get_plans = 1,
    @get_outer_command = 1,
    @get_transaction_info = 1,
    @get_task_info = 2,
    @get_locks = 1,
    @get_avg_time = 1,
    @get_additional_info = 1,
    @find_block_leaders = 1,
    @delta_interval = 1,
    @output_column_list = '[dd%][session_id][sql_text][sql_command][login_name][wait_info][tasks][tran_log%][cpu%][temp%][block%][reads%][writes%][context%][physical%][query_plan][locks][%]',
    @sort_order = '[start_time] ASC',
    @format_output = 1,      
    @help = 0,
	@destination_table = 'dba.sp_WhoIsActive_historico'
	,@return_schema = 1,
    @schema = @s OUTPUT
SELECT @s


CREATE INDEX ix_CN_sp_WhoIsActive_historico ON dba.sp_WhoIsActive_historico
--([collection_time])
with --(data_compression=page)
GO


/*
	To see the number of concurrent requests, run this Transact-SQL query on your database:
*/
SELECT COUNT--(*) AS [Concurrent_Requests]
FROM sys.dm_exec_requests R;


--To see the number of current active sessions, run this Transact-SQL query on your database:
SELECT COUNT--(*) AS [Sessions]
FROM sys.dm_exec_connections;


