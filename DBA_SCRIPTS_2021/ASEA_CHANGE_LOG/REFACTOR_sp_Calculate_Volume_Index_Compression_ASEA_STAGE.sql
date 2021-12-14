ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId] ON [dbo].[tbl_distributor_commissions_v2] 
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = NONE, ONLINE = ON, SORT_IN_TEMPDB = ON); --3137 mb 4 minutes. 3:59 secs after L2S.

--ALTER INDEX [PKLogWebservice_Id] ON [dbo].[Log_Webservice] 
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = NONE, ONLINE = ON, SORT_IN_TEMPDB = ON); --3198 -- 44 seconds. 51 secs after L2S.

--ALTER INDEX [nci_wi_tbl_Leadership_Development_Pool_Downline_F82B02917E09CF59481A7FD13D26A933] 
--ON [dbo].[tbl_Leadership_Development_Pool_Downline] 
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = NONE, ONLINE = ON, SORT_IN_TEMPDB = ON); --5163 mb --7 minutes 4 seconds --select 259714*8/1024 --2029 mb after compression

--ALTER INDEX [PKLosingActivity_Detail_Temp] ON [dbo].[LosingActivity_Detail_Temp] 
--REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = ROW, ONLINE = ON, SORT_IN_TEMPDB = ON); 
--23099 mb 1% fragmentation 2809599 NONEs. min row size: 169, max row size:379, avg: 226 6 LARGE NVARCHAR. 8 minutes 58 seconds.
--      After compression:  1540943 NONEs. min row size: 93, max row size: 223, avg: 124.


ALTER INDEX [PK_TBL_ORDERS_HEADER] ON [dbo].[tbl_Orders_Header] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = NONE, ONLINE = ON, SORT_IN_TEMPDB = ON); -- after L2S.
--11 minutes. 15:40 minutes after L2S.


--select    
--      sum(reserved_NONE_count) * 8.0 / 1024 / 1024 [SizeInGB] 
--from    
--      sys.dm_db_partition_stats --845.82297515820


--CREATE CLUSTERED INDEX ix_CU_Translation_Key_Value_Detail_By_Module_Log_ID_Comp ON [Translation_Key_Value_Detail_By_Module_Log] 
--([id]) 
--WITH (ONLINE=ON,DATA_COMPRESSION=NONE, drop_existing=off);  -- 33:43 minutes. -- after L2S!!!!!!!!!!!!!!!!!!!!!!!

----tbl_distributor_commissions_v2. Index: PK__tbl_dist__3214EC275D93B669
----ALTER INDEX [PK__tbl_dist__3214EC275D93B669] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL 
----WITH (DATA_COMPRESSION = NONE, ONLINE = ON, SORT_IN_TEMPDB = ON); --15 MINUTES. 14 minutes after L2S.


----select    
----      sum(reserved_NONE_count) * 8.0 / 1024 / 1024 [SizeInGB] 
----from    
----      sys.dm_db_partition_stats -- 729.62310028027

----ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId_IRanks] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=NONE);
------7 minutes
------1:10 after L2S.


----ALTER INDEX [Ix_Nn_tbl_distributor_commissions_v2_MARKETID_CommPeriodId_TOTAL_COMMISSIONS_VALUE] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=NONE); --2 minutes. After L2S: 3 minutes.

----ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumberCommPeriodId] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=NONE);

--select sum(reserved_NONE_count) * 8.0 / 1024 / 1024 [SizeInGB] 
--from sys.dm_db_partition_stats --707.26773834179


----ALTER INDEX [PK__Commissi__3214EC07ACFF1DE7] ON [dbo].[Commissions_VolumeCalculationLog] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
----ALTER INDEX [PK_TBL_ORDERSTATUS] ON [dbo].[TBL_ORDERSTATUS] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
----ALTER TABLE [dbo].[Commissions_VolumeCalculationLog_Detail] REBUILD PARTITION = ALL
----WITH (DATA_COMPRESSION = NONE)
----ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_DistributorPeriods] REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)
----ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_DistributorPeriods_temp] REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)

----ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Downline] REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----) 5:14 minutes.

----ALTER INDEX [nci_wi_tbl_Leadership_Development_Pool_Downline_F82B02917E09CF59481A7FD13D26A933] 
----ON [dbo].[tbl_Leadership_Development_Pool_Downline] 
----REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
---- 1:14 minutes


----ALTER INDEX [PK__tbl_Lead__3213E83FD909C1E8] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] 
----REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE) 0 minutes

----ALTER INDEX [missing_index_748_747] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
----ALTER INDEX missing_index_6958_6957 ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)

----ALTER INDEX missing_index_6956_6955 ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
----ALTER INDEX missing_index_13177_13176 ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
----ALTER INDEX ix_NN_tbl_Leadership_Development_Pool_Downline_Temp_Incl_Comp_4_1_2021 ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
----ALTER INDEX IDX_Leadership_Development_Pool_Downline_Temp_Filters ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)

----ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Golds] REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)
----ALTER INDEX [missing_index_13259_13258] ON [dbo].[tbl_Leadership_Development_Pool_Golds] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)

----ALTER TABLE [dbo].[TBL_LOG_LDP_APPLY] REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)

----ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit] REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)

----ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit_Temp] REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)

--ALTER TABLE [dbo].tbl_Leadership_Development_Pool_DistributorPeriods REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE [dbo].tbl_Leadership_Development_Pool_DistributorPeriods_Temp REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE [dbo].tbl_Leadership_Development_Pool_Downline REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--) --5 minutes

--ALTER INDEX [nci_wi_tbl_Leadership_Development_Pool_Downline_F82B02917E09CF59481A7FD13D26A933] 
--ON [dbo].[tbl_Leadership_Development_Pool_Downline] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
---- 1:25 minutes

--ALTER TABLE [dbo].tbl_Leadership_Development_Pool_Downline_Temp REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--) 


--ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Golds] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER INDEX [missing_index_13259_13258] ON [dbo].[tbl_Leadership_Development_Pool_Golds] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)


--ALTER TABLE [dbo].[TBL_LOG_LDP_APPLY] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE [dbo].Tbl_Leadership_Development_Pool_Logs_Hourly REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE
--Tbl_Leadership_Development_Pool_Payouts
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE
--Tbl_Leadership_Development_Pool_Rank_Achievements_Temp
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE
--Tbl_Leadership_Development_Pool_Ranks_Audit_Temp
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE
--Tbl_Leadership_Development_Pool_Ranks_Details_Temp
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE
--Tbl_Leadership_Development_Quarter
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE
--Leadership_Development_ReducePayoutException
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE
--Tbl_Ldpparameters
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE
--Tbl_Ldpparameters_Temp
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE
--Tbl_Leadership_Development_Pool_Downline_Temp
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)



--ALTER TABLE

--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE

--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE
--[Tbl_Leadership_Development_Pool_Logs]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE
--[Tbl_Leadership_Development_Pool_Parameters]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE
--[Tbl_Log_Rankadvancement]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)



--ALTER TABLE
--[tbl_Orders_Header]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--) --2:22 minutes


--ALTER TABLE
--[Distributor_Bought_Account]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE
--[Tbl_Executive_Momentum_Exceptions]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE
--[Tbl_Executive_Momentum_Pool]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE
--[Tbl_Executive_Momentum_Pool]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE
--[Tbl_Executive_Momentum_Pool_Master]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE
--[Tbl_Executive_Momentum_Pool_Temp]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)






--ALTER TABLE
--[TBL_ADJUSTMENTS]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE
--[Tbl_Bonus_Team_Commissions_Summary_V2]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE
--[Tbl_Commission_Execute]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE
--[Tbl_Commissions_Runs]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE
--[Tbl_Distributor]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE
--[Tbl_Distributor_Snapshot]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE
--[Tbl_Log_Reportupdated]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE
--[Tbl_Orders_Header_Commissions_Summary_V2]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE
--[Tbl_Orders_Header_Commissions_Temp_V2]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--) -- hasta acá compirmi


--ALTER TABLE
--[Tbl_Orders_Header_Snapshot]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE
--[Tbl_Pegrates]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE
--[tbl_orderstatus]
--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)


--ALTER TABLE

--REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)
--29 minutes


select    
      sum(reserved_NONE_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats --554.55195617675



