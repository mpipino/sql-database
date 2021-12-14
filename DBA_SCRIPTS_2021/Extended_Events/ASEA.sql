/*
Storage para guardar eventos: 

Test:
--https://aseadbextendedevents.blob.core.windows.net/aseatest

Prod:
--https://aseadbextendedevents.blob.core.windows.net/aseaprod

*/

--Credenciales


--select Count(*) from sys.symmetric_keys where name like '%DatabaseMasterKey%'

--DROP DATABASE SCOPED CREDENTIAL [https://aseadbextendedevents.blob.core.windows.net/aseastage]

CREATE DATABASE SCOPED CREDENTIAL
[https://aseadbextendedevents.blob.core.windows.net/aseastage]
WITH IDENTITY='SHARED ACCESS SIGNATURE'
, SECRET='sp=racwdl&st=2021-05-20T13:52:30Z&se=2022-12-31T21:52:30Z&spr=https&sv=2020-02-10&sr=c&sig=gIHtl%2BiUWru5Wt%2BdHpcwSUjyxNsN6eCf6jJy9L5f7AI%3D'


-------------------------------------------------------------------------------
--DROP EVENT SESSION [SP_CalculateVolume] ON DATABASE 

CREATE EVENT SESSION [SP_CalculateVolume] ON DATABASE 
ADD EVENT sqlserver.cursor_close(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.cursor_execute(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)
	WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.error_reported(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.excessive_non_grant_memory_used(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)
	WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.exchange_spill(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)
	WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.missing_column_statistics(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)
	WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.missing_join_predicate(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)
	WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.module_end(SET collect_statement=(1)
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.rpc_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.rpc_starting(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.sp_statement_completed(SET collect_object_name=(1)
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.sql_batch_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.sql_statement_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139)))
ADD TARGET package0.event_file(SET filename=N'https://aseadbextendedevents.blob.core.windows.net/aseastage/SP_CalculateVolume.xel',max_file_size=(5120))
WITH (MAX_MEMORY=40139 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO












----------------------------------------------------------------------------------





 --DROP EVENT SESSION [ASEA_Tuning_SP_CALCULATEVOLUME] ON DATABASE 

CREATE EVENT SESSION [ASEA_Tuning_SP_CALCULATEVOLUME] ON DATABASE 
ADD EVENT sqlos.wait_info(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlos.wait_info_external(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.rpc_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.rpc_starting(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.sp_statement_completed(SET collect_object_name=(1),collect_statement=(1)
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.sp_statement_starting(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.sql_batch_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.sql_batch_starting(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.sql_statement_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139))),
ADD EVENT sqlserver.sql_statement_starting(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([sqlserver].[session_id]=(139)))
ADD TARGET package0.event_file(SET filename=N'https://aseadbextendedevents.blob.core.windows.net/aseastage/SP_CalculateVolume_Tuning.xel',max_file_size=(1024))
WITH (MAX_MEMORY=40139 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO











CREATE EVENT SESSION ImplicitConversionOnly
ON DATABASE
ADD EVENT sqlserver.plan_affecting_convert
(ACTION (sqlserver.sql_text)
-- WHERE (sqlserver.equal_i_sql_unicode_string(sqlserver.database_name, N'AdventureWorks2017'))
)
ADD TARGET package0.event_file(SET filename=N'https://aseadbextendedevents.blob.core.windows.net/aseastage/ImplicitConversionOnly',max_file_size=(5120))
--(SET filename = N'ImplicitConversionOnly')
WITH (MAX_MEMORY=40139 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF);

ALTER EVENT SESSION ImplicitConversionOnly ON DATABASE STATE = START;
GO
---------------------------------------------

CREATE EVENT SESSION [Capture execution plan] 
ON DATABASE 
ADD EVENT sqlserver.query_post_execution_showplan(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_id,sqlserver.database_name,sqlserver.plan_handle,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.sql_text)
	)
	ADD TARGET package0.event_file(SET filename=N'https://aseadbextendedevents.blob.core.windows.net/aseastage/Execution_Plan',max_file_size=(5120))
WITH (MAX_MEMORY=40139 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO

ALTER EVENT SESSION  [Capture execution plan] ON DATABASE STATE = START;
GO
---------------------------------------------



CREATE EVENT SESSION [SP_CalculateVolume] ON DATABASE 
ADD EVENT sqlserver.cursor_close(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.cursor_execute(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.error_reported(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0)))),
ADD EVENT sqlserver.excessive_non_grant_memory_used(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.exchange_spill(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.missing_column_statistics(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.missing_join_predicate(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.module_end(SET collect_statement=(1)
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0)))),
ADD EVENT sqlserver.rpc_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0)))),
ADD EVENT sqlserver.rpc_starting(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.sp_statement_completed(SET collect_object_name=(1)
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0)))),
ADD EVENT sqlserver.sql_batch_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0)))),
ADD EVENT sqlserver.sql_statement_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0))))
ADD TARGET package0.event_file(SET filename=N'https://aseadbextendedevents.blob.core.windows.net/aseastage/',max_file_size=(5120))
WITH (MAX_MEMORY=40139 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO










CREATE EVENT SESSION [SP_CalculateVolume] ON DATABASE 
ADD EVENT sqlserver.cursor_close(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.cursor_execute(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.error_reported(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (([package0].[greater_than_uint64]([sqlserver].[database_id],(4))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0))))),
ADD EVENT sqlserver.excessive_non_grant_memory_used(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.exchange_spill(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.missing_column_statistics(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.missing_join_predicate(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.module_end(SET collect_statement=(1)
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (([package0].[greater_than_uint64]([sqlserver].[database_id],(4))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0))))),
ADD EVENT sqlserver.rpc_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (([package0].[greater_than_uint64]([sqlserver].[database_id],(4))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0))))),
ADD EVENT sqlserver.rpc_starting(
    ACTION(sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.sql_text)),
ADD EVENT sqlserver.sp_statement_completed(SET collect_object_name=(1)
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (([package0].[greater_than_uint64]([sqlserver].[database_id],(4))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0))))),
ADD EVENT sqlserver.sql_batch_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (([package0].[greater_than_uint64]([sqlserver].[database_id],(4))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0))))),
ADD EVENT sqlserver.sql_statement_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.execution_plan_guid,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (([package0].[greater_than_uint64]([sqlserver].[database_id],(4))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0)))))
ADD TARGET package0.event_file(SET filename=N'https://aseadbextendedevents.blob.core.windows.net/aseastage/',max_file_size=(5120))
WITH (MAX_MEMORY=40139 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO










--DROP EVENT SESSION [ASEA_Tuning_SP_CALCULATEVOLUME] ON DATABASE 

CREATE EVENT SESSION [aseai_event_query_monitor] ON DATABASE 
ADD EVENT sqlserver.sql_statement_completed(
    ACTION(sqlserver.client_app_name,sqlserver.client_connection_id,sqlserver.client_hostname,sqlserver.client_pid,sqlserver.context_info,sqlserver.execution_plan_guid,sqlserver.plan_handle,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_stack,sqlserver.username)
    WHERE ([sql_text] like '%(select max(most_recent_purchase) from ASEAI_RECENT_PURCHASES_PRODUCT_CATEGORIES where dist_id = d.legacynumber and product_type in (1,2))%'))
ADD TARGET package0.event_file(SET filename=N'https://aseareportsrandom.blob.core.windows.net/asea-prod-event-logs/event_session.xel')
WITH (MAX_MEMORY=10240 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO

-----------------------------------------------------------------------------

DROP EVENT SESSION [ASEA_Tuning_SP_CALCULATEVOLUME] ON DATABASE 
GO


CREATE EVENT SESSION [ASEA_Tuning_SP_CALCULATEVOLUME] ON DATABASE 
ADD EVENT sqlos.wait_info(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (((([package0].[divides_by_uint64]([sqlserver].[session_id],(5))) AND ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0)))) AND ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'sp_CalculateVolume')))),
ADD EVENT sqlos.wait_info_external(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (((([package0].[divides_by_uint64]([sqlserver].[session_id],(5))) AND ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0)))) AND ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'sp_CalculateVolume')))),
ADD EVENT sqlserver.rpc_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (((([package0].[divides_by_uint64]([sqlserver].[session_id],(5))) AND ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0)))) AND ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'sp_CalculateVolume')))),
ADD EVENT sqlserver.rpc_starting(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (((([package0].[divides_by_uint64]([sqlserver].[session_id],(5))) AND ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0)))) AND ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'sp_CalculateVolume')))),
ADD EVENT sqlserver.sp_statement_completed(SET collect_object_name=(1),collect_statement=(1)
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (((([package0].[divides_by_uint64]([sqlserver].[session_id],(5))) AND ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0)))) AND ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'sp_CalculateVolume')))),
ADD EVENT sqlserver.sp_statement_starting(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (((([package0].[divides_by_uint64]([sqlserver].[session_id],(5))) AND ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0)))) AND ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'sp_CalculateVolume')))),
ADD EVENT sqlserver.sql_batch_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (((([package0].[divides_by_uint64]([sqlserver].[session_id],(5))) AND ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0)))) AND ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'sp_CalculateVolume')))),
ADD EVENT sqlserver.sql_batch_starting(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (((([package0].[divides_by_uint64]([sqlserver].[session_id],(5))) AND ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0)))) AND ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'sp_CalculateVolume')))),
ADD EVENT sqlserver.sql_statement_completed(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (((([package0].[divides_by_uint64]([sqlserver].[session_id],(5))) AND ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0)))) AND ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'sp_CalculateVolume')))),
ADD EVENT sqlserver.sql_statement_starting(
    ACTION(sqlserver.client_app_name,sqlserver.database_id,sqlserver.num_response_rows,sqlserver.query_hash,sqlserver.query_plan_hash,sqlserver.session_id,sqlserver.sql_text)
    WHERE (((([package0].[divides_by_uint64]([sqlserver].[session_id],(5))) AND ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)))) AND ([package0].[equal_boolean]([sqlserver].[is_system],(0)))) AND ([sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'sp_CalculateVolume'))))
ADD TARGET package0.event_file(SET filename=N'https://aseadbextendedevents.blob.core.windows.net/aseastage/SP_CalculateVolume_Waits.xel',max_file_size=(1024))
WITH (MAX_MEMORY=40139 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO


ALTER
    EVENT SESSION
        [ASEA_Tuning_SP_CALCULATEVOLUME]
    ON DATABASE
    STATE = START;
GO
