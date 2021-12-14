DECLARE @s VARCHAR(MAX)

EXEC dba.sp_WhoIsActive
    @get_locks=1, @get_plans=1, @get_task_info=2, @get_additional_info=1, @get_outer_command=1, @get_transaction_info=1, 
    @format_output = 0,
    @return_schema = 1,
    @schema = @s OUTPUT

SET @s = REPLACE(@s, '<table_name>', 'dba.sp_WhoIsActive_historico')

EXEC(@s)
GO

EXEC dba.sp_WhoIsActive
    @format_output = 0
    ,@destination_table = 'dba.sp_WhoIsActive_historico'
	,@get_locks=1, @get_plans=1, @get_task_info=2, @get_additional_info=1, @get_outer_command=1, @get_transaction_info=1
WAITFOR DELAY '00:00:05'
GO 60

select * from dba.sp_WhoIsActive with (nolock)
DROP table dba.sp_WhoIsActive_historico
