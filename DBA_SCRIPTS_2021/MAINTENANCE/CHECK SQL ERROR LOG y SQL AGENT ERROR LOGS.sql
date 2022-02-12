EXEC xp_ReadErrorLog --SOLO PARA xcomm1.database.xirect.com

EXEC xp_ReadErrorLog 0,2 --we specify a value for LogType parameter 2 that refers to SQL Server agent logs:

EXEC xp_ReadErrorLog 0, 1, N'Warning'

EXEC xp_ReadErrorLog 0, 1, N'Database',N'Initialization'

EXEC xp_readerrorlog 
    0, 
    1, 
    N'Recovery', 
    --N'', 
    --N'2019-11-07 00:00:01.000', 
    --N'2019-11-07 09:00:01.000',
    N'desc'



	   


-- ERRORES DE SQL AGENT
SELECT J.[name] 
       ,[step_name]
      ,[message]
      ,[run_status]
      ,[run_date]
      ,[run_time]
      ,[run_duration]
  FROM [msdb].[dbo].[sysjobhistory] JH
  JOIN [msdb].[dbo].[sysjobs] J
  ON JH.job_id= J.job_id
  WHERE J.name='Log_Failed_Logins'

--DURACION POR JOB
SELECT jobs.name AS 'JobName',
msdb.dbo.agent_datetime(run_date, run_time) AS 'Run Date Time',
history.run_duration AS 'Duration in Second'
FROM msdb.dbo.sysjobs jobs
INNER JOIN msdb.dbo.sysjobhistory history
ON jobs.job_id = history.job_id
WHERE jobs.enabled = 1



WITH JobCounters AS
(
SELECT
job_id
,MIN(run_duration) AS MinRunDurationSeconds
,MAX(run_duration) AS MaxRunDurationSeconds
,MAX([msdb].[dbo].[agent_datetime]([run_date], [run_time])) AS LastStartDateTime
,AVG(run_duration) AS AvgRunDurationSeconds
FROM [msdb].[dbo].[sysjobhistory]
WHERE step_id = 0 --Job Outcome
GROUP BY job_id
)
SELECT
J.[name] AS JobName
,JC.[name] AS JobCategory
,CAST((CASE WHEN J.[enabled] = 1 THEN 1 ELSE 0 END) AS BIT) AS IsEnabled
,(CASE
WHEN LastJobExecution.run_status = 2 THEN 'RETRY_STEP'
WHEN JA.job_id IS NOT NULL AND JA.stop_execution_date IS NULL AND JA.start_execution_date IS NOT NULL THEN 'EXECUTING…'
WHEN LastJobExecution.run_status = 0 THEN 'ERROR'
WHEN LastJobExecution.run_status = 1 THEN 'SUCCESS'
WHEN LastJobExecution.run_status = 3 THEN 'ABORT'
ELSE NULL
END) AS LastRunStatus
,COALESCE(JA.start_execution_date, JobCounters.LastStartDateTime) AS LastStartDateTime
,JA.next_scheduled_run_date AS NextStartDateTime
,(CASE JA.run_requested_source WHEN 1 THEN 'SQL Agent' WHEN 2 THEN 'Alarming' WHEN 3 THEN 'Boot' WHEN 4 THEN 'User' ELSE JA.run_requested_source END) AS StartedBy
,JS.step_name AS LastJobStep
,LastJobExecution.run_duration AS LastRunDurationSeconds
,JobCounters.MinRunDurationSeconds
,JobCounters.MaxRunDurationSeconds
,JobCounters.AvgRunDurationSeconds
FROM [msdb].[dbo].[sysjobs] AS J
LEFT JOIN [msdb].[dbo].[syscategories] AS JC ON J.category_id = JC.category_id
LEFT JOIN JobCounters ON J.job_id = JobCounters.job_id
LEFT JOIN [msdb].[dbo].[sysjobactivity] JA ON J.job_id = JA.job_id
LEFT JOIN [msdb].[dbo].[sysjobsteps] JS ON JA.job_id = JS.job_id AND JA.last_executed_step_id = JS.step_id
LEFT JOIN (
SELECT run_duration, run_status, step_id, job_id, run_date, run_time, retries_attempted, [message], ROW_NUMBER() OVER (PARTITION BY job_id ORDER BY instance_id DESC) AS RowId
FROM msdb.dbo.[sysjobhistory]
) AS LastJobExecution ON J.job_id = LastJobExecution.job_id AND ISNULL(LastJobExecution.RowId, 1) = 1
WHERE
JA.session_id IS NULL
OR EXISTS (SELECT NULL FROM [msdb].[dbo].[sysjobactivity] GROUP BY job_id HAVING job_id = J.job_id AND MAX(session_id) = JA.session_id)
ORDER BY J.[name];