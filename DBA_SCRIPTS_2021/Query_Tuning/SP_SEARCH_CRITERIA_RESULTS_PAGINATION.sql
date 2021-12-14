--SP_SEARCH_CRITERIA_RESULTS_PAGINATION
--https://tickets.xirect.com/issues/55579?issue_count=31&issue_position=16&next_issue_id=55576&prev_issue_id=55694

[dba].sp_BlitzCache @StoredProcName = 'SP_SEARCH_CRITERIA_RESULTS_PAGINATION'

--Usa Recompile con lo cual no deja plan en la cache.

sp_helptext 'SP_SEARCH_CRITERIA_RESULTS_PAGINATION' 

EXEC dba.sp_WhoIsActive	 
    @format_output = 0
    --,@destination_table = 'sp_WhoIsActive_historico'
	,@get_locks=1, @get_plans=1, @get_task_info=2, @get_additional_info=1, @get_outer_command=1
	, @get_transaction_info=1	
	,@sort_order = '[start_time] ASC'
	--,@filter=1

EXEC dba.sp_WhoIsActive	 

--https://dba.stackexchange.com/questions/263998/find-specific-query-in-query-store
--no funciona:
SELECT 
    qsq.query_id,
    qsq.last_execution_time,
    qsqt.query_sql_text, *
FROM sys.query_store_query qsq
    INNER JOIN sys.query_store_query_text qsqt
        ON qsq.query_text_id = qsqt.query_text_id
WHERE
    qsqt.query_sql_text LIKE '%SP_SEARCH_CRITERIA_RESULTS_PAGINATION%';



--solution:
--CREATE NONCLUSTERED INDEX ix_NN_tbl_Orders_Header_InvoiceNo_LegacyNumber_Incl_Comp_4_12_2021 
--ON [dbo].[tbl_Orders_Header] (InvoiceNo,LegacyNumber)
--INCLUDE (ID,OrderDate,DistributorId,SubTotal,OrderTotal,OrderStatus)
--WITH (ONLINE = ON,DATA_COMPRESSION=PAGE) -- 50 secs
--GO

--Sp_Search_Criteria_Results_Pagination 0,10,0,5,'1500131292','lsbrtXoCPkLu5c2HjN7tpw=='
exec [SP_SEARCH_CRITERIA_RESULTS_PAGINATION] @PAGEID=0,@TOTALPERPAGE=10,@FILTER=0,@SearchValue=N'1800310546',@SearchValueEnc=N'Gkdr4Pd+nOYYcV+q3cKtAA==',@SearchBy=5
--Sacadas con el profiler de Azure Data Studio apuntando a prod:
exec [SP_SEARCH_CRITERIA_RESULTS_PAGINATION_test] @PAGEID=0,@TOTALPERPAGE=10,@FILTER=0,@SearchValue=N' heike.steffen@me.com',@SearchValueEnc=N'kMkGfJpQcL0fC3d4x/hbmjpmkQLLDIfyC9V1tPizfKU=',@SearchBy=5  
-- 1 minute 15 seconds.


--ALTER FULLTEXT CATALOG ftDistributor REBUILD
--ALTER FULLTEXT INDEX ON tbl_distributor START FULL POPULATION 

-- Luego del rebuild 6 segundos!
exec [SP_SEARCH_CRITERIA_RESULTS_PAGINATION] @PAGEID=0,@TOTALPERPAGE=10,@FILTER=0,@SearchValue=N'1800386121',@SearchValueEnc=N'c1PCwknx29+L/7kGEkHhYw==',@SearchBy=5