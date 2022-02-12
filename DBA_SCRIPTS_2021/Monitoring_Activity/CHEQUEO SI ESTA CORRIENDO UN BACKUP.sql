When you are experiencing performance issues, could you please run the below and check if there are any backup operations going on?

 SELECT r.command, query = a.text, start_time, percent_complete,
       eta = dateadd(second,estimated_completion_time/1000, getdate())
 FROM sys.dm_exec_requests r
     CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a
  WHERE r.command IN ('BACKUP DATABASE','BACKUP LOG')