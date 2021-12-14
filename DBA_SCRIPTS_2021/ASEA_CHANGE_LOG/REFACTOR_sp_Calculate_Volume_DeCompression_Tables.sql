--Decompressed tables because sp_calculatevolume performance degradation related with table compression.

ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId] ON [dbo].[tbl_distributor_commissions_v2] 
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = NONE, ONLINE = ON, SORT_IN_TEMPDB = ON); --3137 mb 4 minutes. 3:59 secs after L2S.

ALTER INDEX [PK_TBL_ORDERS_HEADER] ON [dbo].[tbl_Orders_Header] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = NONE, ONLINE = ON, SORT_IN_TEMPDB = ON); -- after L2S.
--11 minutes. 15:40 minutes after L2S.


--ALTER INDEX [PK__Commissi__3214EC07ACFF1DE7] ON [dbo].[Commissions_VolumeCalculationLog] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
--ALTER INDEX [PK_TBL_ORDERSTATUS] ON [dbo].[TBL_ORDERSTATUS] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
--ALTER TABLE [dbo].[Commissions_VolumeCalculationLog_Detail] REBUILD PARTITION = ALL
--WITH (DATA_COMPRESSION = NONE)
--ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_DistributorPeriods] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)
--ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_DistributorPeriods_temp] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Downline] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--) 5:14 minutes.

--ALTER INDEX [nci_wi_tbl_Leadership_Development_Pool_Downline_F82B02917E09CF59481A7FD13D26A933] 
--ON [dbo].[tbl_Leadership_Development_Pool_Downline] 
--REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
-- 1:14 minutes


--ALTER INDEX [PK__tbl_Lead__3213E83FD909C1E8] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] 
--REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE) 0 minutes

--ALTER INDEX [missing_index_748_747] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
--ALTER INDEX missing_index_6958_6957 ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)

--ALTER INDEX missing_index_6956_6955 ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
--ALTER INDEX missing_index_13177_13176 ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
--ALTER INDEX ix_NN_tbl_Leadership_Development_Pool_Downline_Temp_Incl_Comp_4_1_2021 ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
--ALTER INDEX IDX_Leadership_Development_Pool_Downline_Temp_Filters ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)

--ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Golds] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)
--ALTER INDEX [missing_index_13259_13258] ON [dbo].[tbl_Leadership_Development_Pool_Golds] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)

--ALTER TABLE [dbo].[TBL_LOG_LDP_APPLY] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit_Temp] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

ALTER TABLE [dbo].tbl_Leadership_Development_Pool_DistributorPeriods REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE [dbo].tbl_Leadership_Development_Pool_DistributorPeriods_Temp REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE [dbo].tbl_Leadership_Development_Pool_Downline REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
) --5 minutes

ALTER INDEX [nci_wi_tbl_Leadership_Development_Pool_Downline_F82B02917E09CF59481A7FD13D26A933] 
ON [dbo].[tbl_Leadership_Development_Pool_Downline] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
-- 1:25 minutes

ALTER TABLE [dbo].tbl_Leadership_Development_Pool_Downline_Temp REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
) 


ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Golds] REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER INDEX [missing_index_13259_13258] ON [dbo].[tbl_Leadership_Development_Pool_Golds] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)


ALTER TABLE [dbo].[TBL_LOG_LDP_APPLY] REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE [dbo].Tbl_Leadership_Development_Pool_Logs_Hourly REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
Tbl_Leadership_Development_Pool_Payouts
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
Tbl_Leadership_Development_Pool_Rank_Achievements_Temp
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
Tbl_Leadership_Development_Pool_Ranks_Audit_Temp
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
Tbl_Leadership_Development_Pool_Ranks_Details_Temp
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
Tbl_Leadership_Development_Quarter
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
Leadership_Development_ReducePayoutException
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
Tbl_Ldpparameters
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
Tbl_Ldpparameters_Temp
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
Tbl_Leadership_Development_Pool_Downline_Temp
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
[Tbl_Leadership_Development_Pool_Logs]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
[Tbl_Leadership_Development_Pool_Parameters]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
[Tbl_Log_Rankadvancement]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)



ALTER TABLE
[tbl_Orders_Header]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
) --2:22 minutes


ALTER TABLE
[Distributor_Bought_Account]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[Tbl_Executive_Momentum_Exceptions]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
[Tbl_Executive_Momentum_Pool]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
[Tbl_Executive_Momentum_Pool]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[Tbl_Executive_Momentum_Pool_Master]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
[Tbl_Executive_Momentum_Pool_Temp]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[TBL_ADJUSTMENTS]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[Tbl_Bonus_Team_Commissions_Summary_V2]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[Tbl_Commission_Execute]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[Tbl_Commissions_Runs]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[Tbl_Distributor]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[Tbl_Distributor_Snapshot]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[Tbl_Log_Reportupdated]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[Tbl_Orders_Header_Commissions_Summary_V2]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[Tbl_Orders_Header_Commissions_Temp_V2]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
) -- hasta acá compirmi


ALTER TABLE
[Tbl_Orders_Header_Snapshot]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[Tbl_Pegrates]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[tbl_orderstatus]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

--2h 19 minutos


select    
      sum(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats --710.57924652050


ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId] ON [dbo].[tbl_distributor_commissions_v2] 
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = NONE, ONLINE = ON, SORT_IN_TEMPDB = ON); --3137 mb 4 minutes. 3:59 secs after L2S.
--sigue lento.


ALTER INDEX [PKLosingActivity_Detail_Temp] ON [dbo].[LosingActivity_Detail_Temp] 
REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = none, ONLINE = ON, SORT_IN_TEMPDB = ON);  --15 minutes

--sigue lento?

--por si sigue lento probar esto:
CREATE CLUSTERED INDEX ix_CU_Translation_Key_Value_Detail_By_Module_Log_ID_Comp ON [Translation_Key_Value_Detail_By_Module_Log] 
([id]) 
WITH (ONLINE=ON,DATA_COMPRESSION=NONE, drop_existing=off);  -- 1h 24 minutos decompressing

--sigue lento desues de descomprimir ix_CU_Translation_Key_Value_Detail_By_Module_Log_ID_Comp: SI. PEOR, 1H 53 M.

--tbl_distributor_commissions_v2. Index: PK__tbl_dist__3214EC275D93B669
ALTER INDEX [PK__tbl_dist__3214EC275D93B669] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL 
WITH (DATA_COMPRESSION = NONE, ONLINE = ON, SORT_IN_TEMPDB = ON); --15 MINUTES. 14 minutes after L2S.

--sigue lento desues de descomprimir [PK__tbl_dist__3214EC275D93B669]? SIIIIII 1h 52 minutos!!! No se entiende.

ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId_IRanks] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=NONE);

--sigue lento desues de descomprimir [[IX_NN_tbldistributorcommissionsv2_CommPeriodId_IRanks]]?  sigue lento.

ALTER INDEX [Ix_Nn_tbl_distributor_commissions_v2_MARKETID_CommPeriodId_TOTAL_COMMISSIONS_VALUE] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=NONE); 
ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumberCommPeriodId] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (DATA_COMPRESSION=NONE);

--sigue lento desues de descomprimir [Ix_Nn_tbl_distributor_commissions_v2_MARKETID_CommPeriodId_TOTAL_COMMISSIONS_VALUE] y [IX_NN_tbldistributorcommissionsv2_LegacyNumberCommPeriodId] ??
--nota para domingo: hay que ejecutar spcalculavolume para verificar que va lento. Ejecutandose... 1:h 55 m


--ALTER INDEX [PK__Commissi__3214EC07ACFF1DE7] ON [dbo].[Commissions_VolumeCalculationLog] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
--ALTER INDEX [PK_TBL_ORDERSTATUS] ON [dbo].[TBL_ORDERSTATUS] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
--ALTER TABLE [dbo].[Commissions_VolumeCalculationLog_Detail] REBUILD PARTITION = ALL
--WITH (DATA_COMPRESSION = NONE)
--ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_DistributorPeriods] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)
--ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_DistributorPeriods_temp] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Downline] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--) 5:14 minutes.

--ALTER INDEX [nci_wi_tbl_Leadership_Development_Pool_Downline_F82B02917E09CF59481A7FD13D26A933] 
--ON [dbo].[tbl_Leadership_Development_Pool_Downline] 
--REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
-- 1:14 minutes


--ALTER INDEX [PK__tbl_Lead__3213E83FD909C1E8] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] 
--REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE) 0 minutes

--ALTER INDEX [missing_index_748_747] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
--ALTER INDEX missing_index_6958_6957 ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)

--ALTER INDEX missing_index_6956_6955 ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
--ALTER INDEX missing_index_13177_13176 ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
--ALTER INDEX ix_NN_tbl_Leadership_Development_Pool_Downline_Temp_Incl_Comp_4_1_2021 ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)
--ALTER INDEX IDX_Leadership_Development_Pool_Downline_Temp_Filters ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)

--ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Golds] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)
--ALTER INDEX [missing_index_13259_13258] ON [dbo].[tbl_Leadership_Development_Pool_Golds] REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = NONE)

--ALTER TABLE [dbo].[TBL_LOG_LDP_APPLY] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

--ALTER TABLE [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit_Temp] REBUILD PARTITION = ALL
--WITH 
--(DATA_COMPRESSION = NONE
--)

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

ALTER TABLE
Tbl_Leadership_Development_Pool_Ranks_Audit_Temp
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
Tbl_Leadership_Development_Pool_Ranks_Details_Temp
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
Tbl_Leadership_Development_Quarter
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
Leadership_Development_ReducePayoutException
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
Tbl_Ldpparameters
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
Tbl_Ldpparameters_Temp
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
Tbl_Leadership_Development_Pool_Downline_Temp
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[Tbl_Leadership_Development_Pool_Logs]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
[Tbl_Leadership_Development_Pool_Parameters]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
[Tbl_Log_Rankadvancement]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)



ALTER TABLE
[tbl_Orders_Header]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
) --2:22 minutes


ALTER TABLE
[Distributor_Bought_Account]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[Tbl_Executive_Momentum_Exceptions]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
[Tbl_Executive_Momentum_Pool]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
[Tbl_Executive_Momentum_Pool]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)


ALTER TABLE
[Tbl_Executive_Momentum_Pool_Master]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)

ALTER TABLE
[Tbl_Executive_Momentum_Pool_Temp]
REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)






----ALTER TABLE
----[TBL_ADJUSTMENTS]
----REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)


----ALTER TABLE
----[Tbl_Bonus_Team_Commissions_Summary_V2]
----REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)


----ALTER TABLE
----[Tbl_Commission_Execute]
----REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)


----ALTER TABLE
----[Tbl_Commissions_Runs]
----REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)


----ALTER TABLE
----[Tbl_Distributor]
----REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)


----ALTER TABLE
----[Tbl_Distributor_Snapshot]
----REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)


----ALTER TABLE
----[Tbl_Log_Reportupdated]
----REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)


/*

The statement has been terminated.
Msg 40544, Level 17, State 12, Line 689
The database 'Asea_Stage' has reached its size quota. Partition or delete data, drop indexes, or consult the documentation for possible resolutions.

*/

----ALTER TABLE
----[Tbl_Orders_Header_Commissions_Summary_V2]
----REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)


----ALTER TABLE
----[Tbl_Orders_Header_Commissions_Temp_V2]
----REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----) -- hasta acá compirmi


----ALTER TABLE
----[Tbl_Orders_Header_Snapshot]
----REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)


----ALTER TABLE
----[Tbl_Pegrates]
----REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)


----ALTER TABLE
----[tbl_orderstatus]
----REBUILD PARTITION = ALL
----WITH 
----(DATA_COMPRESSION = NONE
----)


ALTER TABLE

REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = NONE
)
29 minutes


--ALTER INDEX  Ix_Nn_tbldistributorcommissionsv2_New_Commperiodid_Accounttype ON tbl_distributor_commissions_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
--ALTER INDEX  IX_NN_tbldistributorcommissionsv2_CommPeriodId_I ON tbl_distributor_commissions_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
--ALTER INDEX  IX_NN_tbldistributorcommissionsv2_CommPeriodId_Itotals ON tbl_distributor_commissions_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
--ALTER INDEX  IX_NN_tbldistributorcommissionsv2_LegacyNumberCommPeriodId_ICustom ON tbl_distributor_commissions_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
--ALTER INDEX  IX_NN_tbldistributorcommissionsv2_CommPeriodIdPaidAsRank ON tbl_distributor_commissions_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
--ALTER INDEX  IX_NN_tbldistributorcommissionsv2_CommPeriodIdTotalCommissions ON tbl_distributor_commissions_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
--ALTER INDEX  IX_NN_tbldistributorcommissionsv2_CommPeriodId_ITotalCV ON tbl_distributor_commissions_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
--ALTER INDEX  IX_NN_tbldistributorcommissionsv2_LegacyNumber ON tbl_distributor_commissions_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
--ALTER INDEX  IX_NN_tbldistributorcommissionsv2_LegacyNumber_IWeekGV ON tbl_distributor_commissions_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  PK__tbl_dist__3214EC275D93B669 ON tbl_distributor_commissions_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  IX_NN_tbldistributorcommissionsv2_CommPeriodId_IRanks ON tbl_distributor_commissions_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  Ix_Nn_tbl_distributor_commissions_v2_MARKETID_CommPeriodId_TOTAL_COMMISSIONS_VALUE ON tbl_distributor_commissions_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  IX_NN_tbldistributorcommissionsv2_LegacyNumberCommPeriodId ON tbl_distributor_commissions_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  IX_NN_tbldistributorcommissionsv2_CommPeriodId ON tbl_distributor_commissions_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  PK__tbl_Orde__3214EC279A8E8B9C ON tbl_Orders_Header_Commissions_summary_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  idx_tbl_Orders_Header_Commissions_summary_v2_rundate_sequence ON tbl_Orders_Header_Commissions_summary_v2 REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  PkMerchantBraintree_BraintreeId ON MerchantBraintree REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  ix_NN_BraintreeMethod_BraintreeResultCode__Incl_Comp_4_16_2021 ON MerchantBraintree REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  ix_NN_BraintreePayPalMethod_ModuleId__Incl_Comp_4_16_2021 ON MerchantBraintreePayPal REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  ix_NN_ModuleId__Incl_Comp_4_16_2021_2 ON MerchantBraintreePayPal REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  PkMerchantBraintreePayPal_BraintreePayPalId ON MerchantBraintreePayPal REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  IDX_MerchantBraintreePayPal_OrdersId ON MerchantBraintreePayPal REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  Pk_TaxAvalara_AvalaraId ON TaxAvalara REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  PK_TBL_TF_LOGEMAIL ON TBL_TF_LOGEMAIL REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  missing_index_7051_7050 ON TBL_TF_LOGEMAIL REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  missing_index_190_189 ON TBL_TF_LOGEMAIL REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  Ix_Nn_Losingactivity_Detail_Temp_Commperiodid_Runsequence_Maindistributorid ON LosingActivity_Detail_Temp REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'
ALTER INDEX  PKLosingActivity_Detail_Temp ON LosingActivity_Detail_Temp REBUILD WITH (DATA_COMPRESSION=NONE, ONLINE=ON);  WAITFOR DELAY '00:00:01'



