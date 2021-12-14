--ALTER INDEX [PK__tbl_Loya__3213E83FFDAE2B91] ON [tbl_Loyalty_Rewards_Program_Main] REORGANIZE 
--ALTER INDEX [PK__TBL_SHIP__3214EC27CF2FEA5F] ON [TBL_SHIPPINGRATES_NEW] REORGANIZE 
--ALTER INDEX [IDX_Autoship_Projected_Delayed_Orders_Main_Date] ON [tbl_Autoship_Projected_Delayed_Orders] REORGANIZE 
--ALTER INDEX [missing_index_6956_6955] ON [tbl_Leadership_Development_Pool_Downline_Temp] REORGANIZE 
--ALTER INDEX [IDX_tbl_Distributor_Commissions_Temp_v2_RunDateRunSequenceAccountType] ON [tbl_Distributor_Commissions_Temp_v2] REORGANIZE 
--ALTER INDEX [PK__tbl_Exec__3213E83F326F595A] ON [tbl_Executive_Momentum_Pool_Master] REORGANIZE 
--ALTER INDEX [nci_wi_TBL_DISTRIBUTOR_07C4D0A8CFDB7469BCBF8C8AD973A521] ON [TBL_DISTRIBUTOR] REORGANIZE 
--ALTER INDEX [PK__tbl_Dist__3213E83F01DE82B7] ON [tbl_Distributor_Commissions_Temp_v2] REORGANIZE 
-- 3 minutes on Stage.

--ALTER INDEX [IX_Translation_Value_TranslationKeyIdAndLanguageId] ON [Translation_Value] REORGANIZE 
--ALTER INDEX [nci_wi_TBL_USERNAVSETTINGS_4AC086F3AAC32D84649EC6C65C9C6C80] ON [RightsManagement_NavSettings_Users] REORGANIZE 
--ALTER INDEX [IDX_Autoship_Projected_Failed_Orders_Main_Date] ON [tbl_Autoship_Projected_Failed_Orders] REORGANIZE 
--ALTER INDEX [IDX_Autoship_Projected_Delayed_Orders_Date] ON [tbl_Autoship_Projected_Delayed_Orders] REORGANIZE 
-- 23 seconds on Stage

--ALTER INDEX [IDX_Autoship_Projected_Failed_Orders_Date] ON [tbl_Autoship_Projected_Failed_Orders] REORGANIZE 
--ALTER INDEX [missing_index_748_747] ON [tbl_Leadership_Development_Pool_Downline_Temp] REORGANIZE 
--ALTER INDEX [IDX_Autoship_Projected_Earned_Autoships_DateNext] ON [tbl_Autoship_Projected_Earned_Autoships] REORGANIZE 
--ALTER INDEX [IX_Translation_Value_TranslationKeyID] ON [Translation_Value] REORGANIZE 
--ALTER INDEX [HIERARCHY_BRIDGE_CHILD_IDX] ON [AseaI_Hierarchy_Bridge_Tbl] REORGANIZE 
--ALTER INDEX [nci_wi_TBL_USERNAVSETTINGS_ABC26F2AC2C73654704B061DD88D6D4C] ON [RightsManagement_NavSettings_Users] REORGANIZE 
--ALTER INDEX [IDX__Autoship_Projected_Cancelled_Autoships_Date] ON [tbl_Autoship_Projected_Cancelled_Autoships] REORGANIZE 
-- 2 minutes 47 seconds on Stage

--ALTER INDEX [idx_tbl_Distributor_Commissions_Temp_v2_001] ON [tbl_Distributor_Commissions_Temp_v2] REORGANIZE 
--ALTER INDEX [PK__tbl_Dist__3213E83F804C112A] ON [tbl_Distributor_Commissions_summary_v2] REORGANIZE 
--ALTER INDEX [IDX_Autoship_Projected_Cancelled_Autoships_Main_Date] ON [tbl_Autoship_Projected_Cancelled_Autoships] REORGANIZE 
--ALTER INDEX [IDX_tbl_Autoship_Projected_Failed_Orders_MainDistributorId_RunSequence] ON [tbl_Autoship_Projected_Failed_Orders] REORGANIZE 
--ALTER INDEX [PK__TBL_SHIP__3214EC27072A992D] ON [TBL_SHIPPINGRATES] REORGANIZE 
-- 6:00 minutes on Stage


--ALTER INDEX [PK_TBL_ORDERS_HEADER] ON [dbo].[tbl_Orders_Header] REORGANIZE
----REORGANIZING index [PK_TBL_ORDERS_HEADER] on table [tbl_Orders_Header]
--  --Fragmentation: 62.4569
--  --Page Count:    1,844,668
 
--ALTER INDEX [PK_TBL_AUTOSHIPORDERS_HEADER] ON [dbo].[TBL_AUTOSHIPORDERS_HEADER] REORGANIZE
----REORGANIZING index [PK_TBL_AUTOSHIPORDERS_HEADER] on table [TBL_AUTOSHIPORDERS_HEADER]
--  --Fragmentation: 93.8891
--  --Page Count:    112,799
 
--ALTER INDEX [missing_index_19561_19560] ON [dbo].[tbl_Distributor_Commissions_summary_v2] REORGANIZE
----REORGANIZING index [missing_index_19561_19560] on table [tbl_Distributor_Commissions_summary_v2]
--  --Fragmentation: 32.8375
--  --Page Count:    31,665

-- 46 minutes 56 seconds on Stage. 18% de log.
 

--ALTER INDEX [PK_TBL_ORDERS_HEADER] ON [dbo].[tbl_Orders_Header] REORGANIZE
----REORGANIZING index [PK_TBL_ORDERS_HEADER] on table [tbl_Orders_Header]
--  --Fragmentation: 58.6609
--  --Page Count:    1,792,374

-- 12 minutes 38 seconds on Stage
 

--ALTER INDEX [PK_TBL_AUTOSHIPORDERS_HEADER] ON [dbo].[TBL_AUTOSHIPORDERS_HEADER] REORGANIZE
----REORGANIZING index [PK_TBL_AUTOSHIPORDERS_HEADER] on table [TBL_AUTOSHIPORDERS_HEADER]
--  --Fragmentation: 93.8891
--  --Page Count:    112,799

-- -- 0 seconds on Stage
 
--ALTER INDEX [missing_index_19561_19560] ON [dbo].[tbl_Distributor_Commissions_summary_v2] REORGANIZE
----REORGANIZING index [missing_index_19561_19560] on table [tbl_Distributor_Commissions_summary_v2]
--  --Fragmentation: 32.8375
--  --Page Count:    31665

---- 0 minutes 0 seconds on Stage


--ALTER INDEX [IDX_tbl_Distributor_Commissions_Temp_v2_RunDateRunSequenceAccountTypeCustom6] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REORGANIZE
----REORGANIZING index [IDX_tbl_Distributor_Commissions_Temp_v2_RunDateRunSequenceAccountTypeCustom6] on table [tbl_Distributor_Commissions_Temp_v2]
--  --Fragmentation: 85.3993
--  --Page Count:    7301
 
--ALTER INDEX [missing_index_1637_1636] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REORGANIZE
----REORGANIZING index [missing_index_1637_1636] on table [tbl_Distributor_Commissions_Temp_v2]
--  --Fragmentation: 74.2321
--  --Page Count:    6186
 
--ALTER INDEX [idx_tbl_Distributor_Commissions_Temp_v2_Accounttype] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REORGANIZE
----REORGANIZING index [idx_tbl_Distributor_Commissions_Temp_v2_Accounttype] on table [tbl_Distributor_Commissions_Temp_v2]
--  --Fragmentation: 83.1747
--  --Page Count:    20695
 
--ALTER INDEX [idx_distributor_commissions_custom6_distributorid_marketid_activeminpv] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REORGANIZE
----REORGANIZING index [idx_distributor_commissions_custom6_distributorid_marketid_activeminpv] on table [tbl_Distributor_Commissions_Temp_v2]
--  --Fragmentation: 66.4186
--  --Page Count:    15455
-- 1 minutes 14 seconds on Stage

 
--ALTER INDEX [PK_TBL_DISTRIBUITOR] ON [dbo].[TBL_DISTRIBUTOR] REORGANIZE
----REORGANIZING index [PK_TBL_DISTRIBUITOR] on table [TBL_DISTRIBUTOR]
--  --Fragmentation: 53.6393
--  --Page Count:    128391

---- 3 minutes 16 seconds on Stage

 
--ALTER INDEX [idx_colums_tbldistributor] ON [dbo].[TBL_DISTRIBUTOR] REORGANIZE
----REORGANIZING index [idx_colums_tbldistributor] on table [TBL_DISTRIBUTOR]
--  --Fragmentation: 95.6202
--  --Page Count:    13174
 
--ALTER INDEX [IDX_Leadership_Development_Pool_Downline_Temp_Filters] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REORGANIZE
----REORGANIZING index [IDX_Leadership_Development_Pool_Downline_Temp_Filters] on table [tbl_Leadership_Development_Pool_Downline_Temp]
--  --Fragmentation: 92.7792
--  --Page Count:    7243
 
--ALTER INDEX [IDX_Autoship_Projected_Earned_Autoships_MainDistributorId] ON [dbo].[tbl_Autoship_Projected_Earned_Autoships] REORGANIZE
----REORGANIZING index [IDX_Autoship_Projected_Earned_Autoships_MainDistributorId] on table [tbl_Autoship_Projected_Earned_Autoships]
--  --Fragmentation: 82.951
--  --Page Count:    17526
 
--ALTER INDEX [IDX_Autoship_Projected_Earned_Autoships_Main_Date] ON [dbo].[tbl_Autoship_Projected_Earned_Autoships] REORGANIZE
----REORGANIZING index [IDX_Autoship_Projected_Earned_Autoships_Main_Date] on table [tbl_Autoship_Projected_Earned_Autoships]
--  --Fragmentation: 91.3195
--  --Page Count:    16082
 
--ALTER INDEX [IDX_Autoship_Projected_Earned_Autoships_Drilldown] ON [dbo].[tbl_Autoship_Projected_Earned_Autoships] REORGANIZE
----REORGANIZING index [IDX_Autoship_Projected_Earned_Autoships_Drilldown] on table [tbl_Autoship_Projected_Earned_Autoships]
--  --Fragmentation: 63.8865
--  --Page Count:    41868

---- 2 minutes 45 seconds on Stage
--Completion time: 2021-04-06T18:46:21.0055978-03:00
 

/*

Most used table
Has a lot of indexes
Critial SPs are slow because this table
*/

--error: ALTER INDEX [PK__tbl_dist__3214EC275D93B669] ON [dbo].[tbl_distributor_commissions_v2] REORGANIZE
--REORGANIZING index [PK__tbl_dist__3214EC275D93B669] on table [tbl_distributor_commissions_v2]
--Fragmentation: 32.1818
--Page Count:    18,124,386
--Msg 121, Level 20, State 0, Line 132
--A transport-level error has occurred when receiving results from the server. (provider: TCP Provider, error: 0 - The semaphore timeout period has expired.)

-- ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumberCommPeriodId] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
-- ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumberCommPeriodId_ICustom] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
-- ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumber_IWeekGV] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
-- ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId_Itotals] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
-- ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId_IRanks] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
-- ALTER INDEX [Ix_Nn_tbldistributorcommissionsv2_New_Commperiodid_Accounttype] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
-- ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumber] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
-- ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId_I] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
-- ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodIdTotalCommissions] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
-- ALTER INDEX [Ix_Nn_tbl_distributor_commissions_v2_MARKETID_CommPeriodId_TOTAL_COMMISSIONS_VALUE] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
-- ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId_ITotalCV] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
-- ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodIdPaidAsRank] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);
-- ALTER INDEX [IX_NN_tbldistributorcommissionsv2_CommPeriodId] ON [dbo].[tbl_distributor_commissions_v2] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB = ON);

 


