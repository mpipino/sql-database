/*
-- Genera el alter index reorganize
SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName, 
ind.name AS IndexName, indexstats.index_type_desc AS IndexType, 
indexstats.avg_fragmentation_in_percent,
'ALTER INDEX ' + QUOTENAME(ind.name)  + ' ON ' +QUOTENAME(object_name(ind.object_id)) + 
CASE    WHEN indexstats.avg_fragmentation_in_percent>30 THEN ' REORGANIZE ' 
        WHEN indexstats.avg_fragmentation_in_percent>=5 THEN 'REORGANIZE'
        ELSE NULL END as [SQLQuery]  -- if <5 not required, so no query needed
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats 
INNER JOIN sys.indexes ind ON ind.object_id = indexstats.object_id 
    AND ind.index_id = indexstats.index_id 
WHERE 
indexstats.avg_fragmentation_in_percent > 20
and ind.Name is not null 
ORDER BY indexstats.avg_fragmentation_in_percent DESC
*/


--ALTER INDEX [missing_index_6_5] ON [dbo].[tbl_OrderTracking] 
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --266 mb --13 secs. 13 secs after L2S.

--ALTER INDEX [missing_index_1017_1016] ON [dbo].[tbl_Bonus_Matching_v2] 
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --274 mb --16 secs. 15  secs after L2S.

--ALTER INDEX [missing_index_439_438] ON [dbo].[tbl_adjustments] 
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --2552 1 minute 1 second.  1:04 secs after L2S.

--ALTER INDEX [PK__TBL_LOG___3214EC271B9A9AF6] ON [dbo].[TBL_LOG_WEBSERVICE_PAYNOW] 
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --2730 37 seconds
----Cannot find index 'PK__TBL_LOG___3214EC271B9A9AF6'.

--ALTER INDEX [PK__Distribu__3214EC07CCD6F409] ON [dbo].[Distributor_Commissions_Bonus_Summary] 
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --2773 0 seconds
----Cannot find index 'PK__Distribu__3214EC07CCD6F409'.

 --ALTER INDEX [missing_index_85_84] ON [dbo].[TBL_LOG_AUTOSHIP] 
 --REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = ROW, ONLINE = ON, SORT_IN_TEMPDB = ON); --3040 mb --1:14 secs. 1:16 secs after L2S.

---------------------

--ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId] ON [dbo].[tbl_distributor_commissions_v2] 
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --3137 mb 4 minutes. 3:59 secs after L2S.

--ALTER INDEX [PKLogWebservice_Id] ON [dbo].[Log_Webservice] 
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --3198 -- 44 seconds. 51 secs after L2S.

--ALTER INDEX [nci_wi_tbl_Leadership_Development_Pool_Downline_F82B02917E09CF59481A7FD13D26A933] 
--ON [dbo].[tbl_Leadership_Development_Pool_Downline] 
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --5163 mb --7 minutes 4 seconds --select 259714*8/1024 --2029 mb after compression

--ALTER INDEX [PKLosingActivity_Detail_Temp] ON [dbo].[LosingActivity_Detail_Temp] 
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = ROW, ONLINE = ON, SORT_IN_TEMPDB = ON); 
----23099 mb 1% fragmentation 2809599 pages. min row size: 169, max row size:379, avg: 226 6 LARGE NVARCHAR. 8 minutes 58 seconds.
----      After compression:  1540943 pages. min row size: 93, max row size: 223, avg: 124.

------------------------------

--For use on the ticket: Index compression on tablea, tableb based on analysis of Updates, Seeks, Scan and Compression ratio.
---***canceled ALTER TABLE [dbo].[Translation_Key_Value_Log] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = ROW, ONLINE = ON, SORT_IN_TEMPDB = ON);
--97 % Estimated compression. 23356 mb. 0 % Scan and Update Percent.
-- Lots of waits on:
--VDI_CLIENT_OTHER					
--PWAIT_EXTENSIBILITY_CLEANUP_TASK	
--********CANCELED ON STAGE AFTER ONE RUNNING ABOUT ONE HOUR.
--Lot of ghost records, aparently.

--Aplicado en Stage y Test.

-------------------
--select getdate() 2021-04-08 16:04:34.787 (utc)

--ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumberCommPeriodId_ICustom] 
--ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --51 secs
----9 12 24 (min, max, avg row size) 174254 pages.


--select getdate()
--2021-04-09 22:32:14.533
--ALTER INDEX [PK_TBL_ORDERS_HEADER] ON [dbo].[tbl_Orders_Header] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); -- after L2S.
--11 minutes. 15:40 minutes after L2S.

--36315 user seeks, user_scan 6, user_lookups 23659 user_updates:1440
--9962 mb
--1 275 125 pages
--max row size: 1839
--min row size: 838
--Avg row size: 1384
------------

select    
      sum(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats
--DB Size: 817.04077911328. 685.81636810253 after L2S.

--ALTER INDEX [PK__tbl_adju__3214EC27C0A32CF4] ON [dbo].[tbl_adjustments] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
 --Cannot find index 'PK__tbl_adju__3214EC27C0A32CF4' --after L2S.
-- 2 minutes 29 seconds
-- 5150 MB
-- user seeks, user_scan , user_lookups, user_updates:
-- 592	0	0	416 
-- pages max row size, min, avg. Fragmentation <3%
-- 659105 2279 262 317



--Translation_Key_Value_Detail_By_Module_Log
---- ALTER TABLE [dbo].[Translation_Key_Value_Detail_By_Module_Log] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
--1H: 10m. Canceled because is very low. -H:1 m:14 cancelled. / second run: the same: 1h:15 minutes.

--CREATE CLUSTERED INDEX ix_CU_MaxCallSupport_TimeStamps_Maxcallsupportid_Incl_Comp ON [Translation_Key_Value_Detail_By_Module_Log] 
--([id]) 
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE, drop_existing=on);  -- 33:43 minutes. -- after L2S!!!!!!!!!!!!!!!!!!!!!!!

-- 12045 MB
-- user seeks, user_scan , user_lookups, user_updates:
-- 0	0	0	28 . Solo pocos updates. (pero es stage)
-- pages max row size, min, avg. Fragmentation <3%
-- 129,811 349, 26, 55. 0.01% --poco uso no se de donde lo saqué.
-- no wait and block.
-- note: 293,064,815, 30 MINUTES RUNNING. HIGH EXTEND FRAGMENTATION.   12,995,576 WRITES.
-- Mas detalles del problema:
-- https://onedrive.live.com/view.aspx?resid=C6FA59824AB3963E%21115377&id=documents&wd=target%28LOG%20DE%20OPTIMIZACION.one%7CA6546222-B86D-4AE2-A63E-AA60D8D77127%2FSe%20qued%C3%B3%20sin%20memoria%20el%20sort.%7CF413C1C0-4958-4EB3-B5A4-63D6F0825D1E%2F%29
-- onenote:https://d.docs.live.net/c6fa59824ab3963e/NOTAS/xirectds/LOG%20DE%20OPTIMIZACION.one#Se%20quedó%20sin%20memoria%20el%20sort.&section-id={A6546222-B86D-4AE2-A63E-AA60D8D77127}&page-id={F413C1C0-4958-4EB3-B5A4-63D6F0825D1E}&end
-- basicamente la table no tiene índice cluster y recontruirla con compresión genera un sort que necesita mucha memoria y hace spill a la tempdb


--CREATE STATISTICS stats_
--ON [Translation_Key_Value_Detail_By_Module_Log]
--( 
--   id   
--) 
--WITH SAMPLE 100 PERCENT;
--GO

/*
	506,242 páginas con el índice comprimido. 

pages max row size, min, avg. Fragmentation.
506,242 11 9 11. 0.
*/

select    
      sum(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats
/*
 750.38040161132 685.81655120800 -- after L2S! and after compression above.
*/

--/****** Object:  Index [ix_CU_MaxCallSupport_TimeStamps_Maxcallsupportid_Incl_Comp]    Script Date: 4/10/2021 5:41:21 PM ******/
--DROP INDEX [ix_CU_MaxCallSupport_TimeStamps_Maxcallsupportid_Incl_Comp] ON [dbo].[Translation_Key_Value_Detail_By_Module_Log] WITH ( ONLINE = OFF )
--GO --5 minutes.



 /*
tbl_distributor_commissions_v2
ALTER INDEX [IX_DistributorCommissions_LegacyCommperioID_I] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL 
WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
--16,373 mb
user seeks, user_scan , user_lookups, user_updates:
6	0	0	3 --sin uso

pages max row size, min, avg. Fragmentation.
2 095 814 128 114 114.	61.06 %
241 288 52 12 17

Execution Time: 7 minutes. 5:44 minutes after L2S.
 */


/*
select    
      sum(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats
 Now: 730.21230316113. 685.81655120800 after L2S.
*/

/*
--tbl_distributor_commissions_v2. Index: PK__tbl_dist__3214EC275D93B669
--ALTER INDEX [PK__tbl_dist__3214EC275D93B669] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL 
--WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --15 MINUTES. 14 minutes after L2S.

142,518 MB

user seeks, user_scan , user_lookups, user_updates:
0				1			10988			5

-- pages max row size, min, avg. Fragmentation <3%
18,360,281  1317 1114 1151 1118 . 61%
1,963,648 509 94 148. 0.01 %
BIG IMPROVEMENT!!!!!!!!!!
SELECT (18360281*8)/1024/1024 140 GB
SELECT (1963648*8)/1024/1024 14 GB
*/

/*
select    
      sum(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats
 --Now: 604.21230316113.
 --685.81722259472 after L2S.
*/


-- Time measure compressing all indexes on [tbl_distributor_commissions_v2]

--ALTER INDEX [Ix_Nn_tbl_Distributor_Commissions_Temp_v2_CommPeriodId_Include] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
-- 3 minutes
-- 1:44 after L2S.

--ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId_IRanks] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--7 minutes
--1:10 after L2S.

/*
select    
      sum(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats
 --Now: 590.80522918652
 --After L2S: 672.47599792480
*/

--ALTER INDEX [IX_DistributorCommissions_LegacyCommperioID_ITotalCv] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE); --2 minutes. After L2S: 1:15.
--ALTER INDEX [Ix_Nn_tbl_distributor_commissions_v2_MARKETID_CommPeriodId_TOTAL_COMMISSIONS_VALUE] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE); --2 minutes. After L2S: 3 minutes.
/*
--ALTER INDEX [Ix_Nn_tbl_distributor_commissions_v2_MARKETID_CommPeriodId_GROSS_COMMISSIONS_VALUE] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumberCommPeriodId] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [Ix_Nn_tbl_distributor_commissions_v2_CommPeriodId_DirectorBonusPaid] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
-- 9 minutes. After L2S: 6:13 minutes.
*/
/*
select    
      sum(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats
	  577.51657867382
	  After L2S: 645.15902709960
*/
/*
ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumberCommPeriodId_ICustom] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumber_IWeekGV] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumber] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId_Itotals] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
-- 9 minutes
-- After L2S: 6:15 minutes.


*/
/*
ALTER INDEX [IX_DistributorCommissions_LegacyCommperioID_I] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
ALTER INDEX [Ix_Nn_tbldistributorcommissionsv2_New_Commperiodid_Accounttype] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId_I] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodIdTotalCommissions] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId_ITotalCV] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodIdPaidAsRank] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
-- 13 minutes
-- After L2S: 8:47 minutes.
*/

/*
select    
      sum(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats
	573.25766754101
-- After L2S: 594.29913330078
*/

ALTER INDEX [PK__tbl_Orde__3214EC279A8E8B9C] ON [dbo].[tbl_Orders_Header_Commissions_summary_v2] 
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
--46 minutes.
--After L2S: 38:03 minutes. 
--156,382 MB
-- pages max row size, min, avg. Fragmentation 
-- 20,023,318 526 458 525. <1%
--After Compression:
-- 4,147,457 59 178 102.  Fragmentation <1%
/*
select    
      sum(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats
451.90276336621
After L2S: 470.70372009277
*/


--ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Downline] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
--Es un HEAP!!! 46 minutes of execution. Canceled.

--CREATE CLUSTERED INDEX ix_CN_tbl_Leadership_Development_Pool_Downline_Comp_4_13_2021 
--ON [dbo].tbl_Leadership_Development_Pool_Downline ([DistributorId])
--WITH (ONLINE = ON,DATA_COMPRESSION=PAGE) -- 54 minutes. --Optimization of INSERT WHICH COST 25.000. Ejecutarlo: creo que va a tardar 45 minutos.
----esto si lo vi en sp_calculate volume.

--dba.sp_BlitzCache
--ALTER INDEX [idx_dctempv20002] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE); --RESERVED PAGE COUNT:11442. RESERVED PAGE COUNT AFTER COMPRESSION: 5024. 30 SECONDS.
--ALTER INDEX [IDX_tbl_Distributor_Commissions_Temp_v2_RunDateRunSequenceAccountTypeMore] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE); --RESERVED PAGE COUNT: 24330. 6 SECONDS. RESERVED PAGE COUNT AFTER COMPRESSION: 3473
--ALTER INDEX [idx_tbl_Distributor_Commissions_Temp_v2_Accounttype] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE); --RESERVED PAGE COUNT: 12553. 2 SECONDS. RESERVED PAGE COUNT AFTER COMPRESSION: 5314
--ALTER INDEX [idx_distributor_commissions_custom6_distributorid_marketid_activeminpv] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);  --RESERVED PAGE COUNT: 11442. 3 SECONDS .RESERVED PAGE COUNT AFTER COMPRESSION: 2001

--CREATE NONCLUSTERED INDEX ix_NN_tbl_Distributor_Commissions_Temp_v2_CURRENCYCODE_PEGRATE_Comp_4_13_2021
--ON [dbo].[tbl_Distributor_Commissions_Temp_v2] ([CURRENCYCODE],[PEGRATE])
--WITH (ONLINE = ON,DATA_COMPRESSION=PAGE) --2 seconds


-- 4/14/2021.
--Index compression on tbl_Distributor_Commissions_Temp_v2 and TBL_DISTRIBUTOR. Analyzing execution plan of sp_CalculateVolume and how Compression affect to this process.
--https://tickets.xirect.com/issues/55701/time_entries/new

--ALTER INDEX PK_TBL_DISTRIBUITOR ON [dbo].TBL_DISTRIBUTOR 
--REBUILD WITH (DATA_COMPRESSION=PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);  
-- pages: 130,815. Min: 792 max: 1330 avg: 1009. Rows: 714,400. Total Fragmentation: 55.47%. 11 seconds.


--tbl_Distributor_Commissions_Temp_v2
--ALTER INDEX PK__tbl_Dist__3213E83F01DE82B7 on tbl_Distributor_Commissions_Temp_v2
--REBUILD WITH (DATA_COMPRESSION=PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);  --6 seconds
-- Pages: 28,381. Min: 122. Max: 343, avg:159. Fragmentation: 99%

--1:13 seconds
--ALTER INDEX [missing_index_16615_16614] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [PK__tbl_Dist__3213E83F01DE82B7] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [idx_dctempv20002] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [IDX_tbl_Distributor_Commissions_Temp_v2_RunDateRunSequenceAccountTypeMore] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [idx_distributor_commissions_custom6_distributorid_marketid_activeminpv] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [idx_dctv2_7gen1] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [idx_tbl_Distributor_Commissions_Temp_v2_Accounttype] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [idx_dctemp0002] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [IDX_tbl_Distributor_Commissions_Temp_v2_RunDateRunSequenceAccountTypeCustom6] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [idx_tbl_Distributor_Commissions_Temp_v2_001] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [missing_index_1637_1636] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [idx_03] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [idx_dctemp0001] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [IDX_tbl_Distributor_Commissions_Temp_v2_RunDateRunSequenceAccountType] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [idx_001] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [idx_distributorCommissions_joincommperiodid] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [idx_01] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [missing_index_1938_1937] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [idx_02] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [ix_NN_tbl_Distributor_Commissions_Temp_v2_CURRENCYCODE_PEGRATE_Comp_4_13_2021] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (DATA_COMPRESSION=PAGE);



---------4/15/2021----------------
--stage/Prod
--ALTER INDEX [Ix_Nn_tbl_Distributor_Commissions_Temp_v2_CommPeriodId_Include] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --4m 33s
--ALTER INDEX [PKProStartFulfillment_Id] ON [dbo].[Log_Api_ProStartFulfillment] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --2m 26 s
--ALTER INDEX [PK__TBL_LOG___3214EC27A0C1AEED] ON [dbo].[TBL_LOG_WEBSERVICE_WP] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --3m 49 s
--ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId_IRanks] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);-- 4M 19s
--ALTER INDEX [PK__tbl_Log___3214EC07D210C85B] ON [dbo].[Log_Global] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --3m 50s
--stage/Prod

--ALTER INDEX [IX_DistributorCommissions_LegacyCommperioID_ITotalCv] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); 4m 16s
--ALTER INDEX [idx_tbl_Orders_Header_Commissions_summary_v2_rundate_sequence] ON [dbo].[tbl_Orders_Header_Commissions_summary_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); 13m 45s
--ALTER INDEX [PK__tbl_adju__3214EC27C0A32CF4] ON [dbo].[tbl_adjustments] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --Cannot find index 'PK__tbl_adju__3214EC27C0A32CF4'.
--ALTER INDEX [PK_TBL_LOG_ORDERS_TRANSACTIONDETAILS] ON [dbo].[TBL_LOG_TRANSACTIONDETAILS] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --1m 59s
--ALTER INDEX [PK_TBL_LOG_WEBSERVICE_BTB] ON [dbo].[TBL_LOG_WEBSERVICE_BTB] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --1m 28s
--ALTER INDEX [Ix_Nn_tbl_distributor_commissions_v2_MARKETID_CommPeriodId_TOTAL_COMMISSIONS_VALUE] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); 8m 50s
--ALTER INDEX [PK__Api_Paym__068612DD6B5F6A72] ON [dbo].[Api_Paymentstatus] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --1m 33s
--ALTER INDEX [Ix_Nn_Losingactivity_Detail_Temp_Commperiodid_Runsequence_Maindistributorid] ON [dbo].[LosingActivity_Detail_Temp] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); 5m 27s
--ALTER INDEX [Ix_Nn_tbl_distributor_commissions_v2_MARKETID_CommPeriodId_GROSS_COMMISSIONS_VALUE] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); 6m 41s
--ALTER INDEX [PkTaxXirect_XirectId] ON [dbo].[TaxXirect] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); 53s
--ALTER INDEX [PK_TBL_LOG_WEBSERVICE] ON [dbo].[TBL_LOG_WEBSERVICE] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); 1m 3s
--ALTER INDEX [idx_orderid_detail] ON [dbo].[tbl_Orders_Detail] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); 53s
--ALTER INDEX [PK_PGVProjected_Detail_Temp] ON [dbo].[PGVProjected_Detail_Temp] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); 2m 56s
--ALTER INDEX [PK__TBL_LOG___3214EC27FDF82B5A] ON [dbo].[TBL_LOG_AUTOSHIP] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); 1m 16s
--ALTER INDEX [Ix_Nn_tbl_distributor_commissions_v2_CommPeriodId_DirectorBonusPaid] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --4m 22s
--ALTER TABLE [dbo].[Api_Paymentstatus_worldpay] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); 1m 7s
--ALTER INDEX [PK__TBL_LOG___3214EC27EAA882A2] ON [dbo].[TBL_LOG_ORDER] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --1m 9s
--ALTER INDEX [PK__TBL_LOG___3214EC27A10495A1] ON [dbo].[TBL_LOG_DISTRIBUTOR_V2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --1m 25 s
--ALTER INDEX [PK_TBL_ORDERS_TAXDETAIL] ON [dbo].[tbl_Orders_TaxDetail] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); 1m 22s

----12 minutes:
----ALTER TABLE [dbo].[TBL_PHOENIX_LOG_IPADDRESS] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PkShippingWareTwoGo_WareTwoGoId] ON [dbo].[ShippingWareTwoGo] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK_TBL_DISTRIBUTOR_NOTES] ON [dbo].[TBL_DISTRIBUTOR_NOTES] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [missing_index_5650_5649] ON [dbo].[tbl_Distributor_Snapshot] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [idx_tbl_Distributor_Snapshot_1] ON [dbo].[tbl_Distributor_Snapshot] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [Ix_Nn_tbl_Distributor_Snapshot_SnapshotCommPeriodId_Include] ON [dbo].[tbl_Distributor_Snapshot] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [idx_tbl_Distributor_Snapshot_2] ON [dbo].[tbl_Distributor_Snapshot] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK__TBL_LOG___3214EC27CCDCE1FF] ON [dbo].[TBL_LOG_WEBSERVICE_BPOST] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [Idx_PGVProjected_Detail_Temp_CommPeriod_RunSequence_Maindistributorid] ON [dbo].[PGVProjected_Detail_Temp] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK__tbl_Bonu__3214EC2739CEEC46] ON [dbo].[tbl_Bonus_Team_Commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK_TBL_ORDERPAYMENTS] ON [dbo].[tbl_OrderPayments] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);


---- minutes:
----ALTER TABLE [dbo].[tbl_OrderTracking] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PkShippingReadyShipper_ReadyShipperId] ON [dbo].[ShippingReadyShipper] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK_TBL_ORDERS_TAXLINE] ON [dbo].[tbl_Orders_TaxLine] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK__Distribu__3214EC0747FA0DC8] ON [dbo].[Distributor_Commissions_Bonus] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK_TBL_DISTRIBUITOR] ON [dbo].[TBL_DISTRIBUTOR] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [missing_index_19230_19229] ON [dbo].[tbl_Orders_Header_Snapshot] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK_TBL_LOG_WEBSERVICE_JIXITI] ON [dbo].[TBL_LOG_WEBSERVICE_JIXITI] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [missing_index_681_680] ON [dbo].[tbl_adjustments] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK_TBL_ADDRESSES] ON [dbo].[TBL_ADDRESSES] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK__tbl_Bonu__3214EC277CFCAFB2] ON [dbo].[tbl_Bonus_Matching_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER TABLE [dbo].[Log_Webservice_Mfl] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER TABLE [dbo].[AseaI_Promotion_PPP2020_PaidAtRank_Tbl_2020Backup] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);--Cannot find index 'nci_wi_tbl_adjustments_67F5207B2DFBE22E7892B938F99A5548'.

----ALTER INDEX [idx_hist_comm_01] ON [dbo].[tbl_Distributor_Commissions_ApplyHistory_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [nci_wi_tbl_adjustments_67F5207B2DFBE22E7892B938F99A5548] ON [dbo].[tbl_adjustments] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON); --Cannot find index 'nci_wi_tbl_adjustments_67F5207B2DFBE22E7892B938F99A5548'.


----16m 44s
----ALTER INDEX [Ix_Nn_tbl_adjustments_COMMPERIOD_TRANSACTIONTYPE_AMOUNT] ON [dbo].[tbl_adjustments] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER TABLE [dbo].[TBL_LOGS_AUTDIT] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [IDX_Autoship_Projected_Profiles_MainRunsequence] ON [dbo].[tbl_Autoship_Projected_Profiles] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK__TBL_LOG___3214EC27FFA1C421] ON [dbo].[TBL_LOG_WEBSERVICE_GC] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PkApiLandmark_ApiLandmarkId] ON [dbo].[ApiLandmark] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER TABLE [dbo].[TBL_DISTRIBUTOR_XPOSTOPROD] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER TABLE [dbo].[AseaI_Promotion_PPP2020_PaidAtRank_Tbl] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [missing_index_437_436] ON [dbo].[tbl_adjustments] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [Ix_Nn_tbl_Orders_Header_OrderSource_OrderDate_AutoshipOrderNo_Include] ON [dbo].[tbl_Orders_Header] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK_HIERARCHY_BRIDGE] ON [dbo].[AseaI_Hierarchy_Bridge_Tbl] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK_TBL_AUTOSHIPORDERS_HEADER] ON [dbo].[TBL_AUTOSHIPORDERS_HEADER] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK__tbl_Loya__3213E83F6151B878] ON [dbo].[tbl_Loyalty_Rewards_Program_Main_temp] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER TABLE [dbo].[tbl_distributor_xpos] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK_LosingActivity_Temp] ON [dbo].[LosingActivity_Temp] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK_TBL_ORDERS_TRANSACTIONDETAILS] ON [dbo].[TBL_ORDERS_TRANSACTIONDETAILS] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [HIERARCHY_BRIDGE_CHILD_IDX] ON [dbo].[AseaI_Hierarchy_Bridge_Tbl] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [missing_index_1015_1014] ON [dbo].[tbl_Bonus_Team_Commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [idx_dctempv20002] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK__tbl_Loya__3213E83F4C6AFE36] ON [dbo].[tbl_Loyalty_Rewards_Program_Autoship_Detail] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PkDistributor_X_Flags_Id] ON [dbo].[Distributor_X_Flags] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK_LosingActivity_Detail] ON [dbo].[LosingActivity_Detail] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER TABLE [dbo].[Tbl_Loyalty_Rewards_Program_Autoship_Detail_Lastrun] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [Ix_Nn_tbl_Orders_Detail_Id_Include] ON [dbo].[tbl_Orders_Detail] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [missing_index_512_511] ON [dbo].[tbl_Orders_Detail] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [missing_index_19561_19560] ON [dbo].[tbl_Distributor_Commissions_summary_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK_TBL_LOG_SHIPMENTPROCESS] ON [dbo].[TBL_LOG_SHIPMENTPROCESS] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [Ix_Nn_tbl_Orders_Header_OrderStatus_WarehouseId] ON [dbo].[tbl_Orders_Header] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [PK__TBL_CARD__3214EC2778293D3D] ON [dbo].[TBL_CARDS_TOKEN] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [IX_LOG_SHIPMENTPROCESS_WarehouseProcessStatusCreatedDate] ON [dbo].[TBL_LOG_SHIPMENTPROCESS] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
----ALTER INDEX [nci_wi_tbl_Orders_Header_6F576094BFE561FA20AC365249640C36] ON [dbo].[tbl_Orders_Header] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);

