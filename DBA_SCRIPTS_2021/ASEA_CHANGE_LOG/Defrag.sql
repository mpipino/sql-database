--EXECUTE [dba].[IndexOptimize]
--						 @Databases = 'Asea_Stage', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE'
--						 ,@FragmentationHigh = 'INDEX_REORGANIZE', @FragmentationLevel1 = 20, @FragmentationLevel2 = 40
--						 --,@FragmentationHigh = 'INDEX_REORGANIZE', @FragmentationLevel1 = 40, @FragmentationLevel2 = 80
--						 , @MaxDOP = 4				
--						 ,@MaxNumberOfPages=100000
--						 --,@MinNumberOfPages=10000
--						 ,@Execute='n'
--						 --,@LogToTable='y'
--						 --Commissions_Distributor_Temp
--						 --,@Indexes = 'BodyLogic_Live.dbo.Commissions_Distributor_Temp'
--						 --,@Indexes = 'Asea_Prod.dbo.tbl_distributor_commissions_v2.PK__tbl_dist__3214EC275D93B669'

Date and time: 2021-04-01 18:40:15
Server: dlo6zra872
Version: 12.0.2000.8
Edition: SQL Azure
Platform: Windows
Procedure: [Asea_Prod].[dba].[IndexOptimize]
Parameters: @Databases = 'Asea_Prod', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE', @FragmentationHigh = 'INDEX_REORGANIZE', @FragmentationLevel1 = 40, @FragmentationLevel2 = 99, @MinNumberOfPages = 1000, @MaxNumberOfPages = 200000, @SortInTempdb = 'N', @MaxDOP = 4, @FillFactor = NULL, @PadIndex = NULL, @LOBCompaction = 'Y', @UpdateStatistics = NULL, @OnlyModifiedStatistics = 'N', @StatisticsModificationLevel = NULL, @StatisticsSample = NULL, @StatisticsResample = 'N', @PartitionLevel = 'Y', @MSShippedObjects = 'N', @Indexes = NULL, @TimeLimit = NULL, @Delay = NULL, @WaitAtLowPriorityMaxDuration = NULL, @WaitAtLowPriorityAbortAfterWait = NULL, @Resumable = 'N', @AvailabilityGroups = NULL, @LockTimeout = NULL, @LockMessageSeverity = 16, @StringDelimiter = ',', @DatabaseOrder = NULL, @DatabasesInParallel = 'N', @ExecuteAsUser = NULL, @LogToTable = 'N', @Execute = 'y'
Version: 2020-12-31 18:58:56
Source: https://ola.hallengren.com
	
Date and time: 2021-04-01 18:40:15
Database: [Asea_Prod]
State: ONLINE
Standby: No
Updateability: READ_WRITE
User access: MULTI_USER
Recovery model: FULL
	
Date and time: 2021-04-01 18:40:23
Database context: [Asea_Prod]
Command: ALTER INDEX [HIERARCHY_BRIDGE_CHILD_IDX] ON [dbo].[AseaI_Hierarchy_Bridge_Tbl] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: Yes, AllowPageLocks: Yes, PageCount: 49919, Fragmentation: 98.752
Outcome: Succeeded
Duration: 00:01:43
Date and time: 2021-04-01 18:42:06
	
Date and time: 2021-04-01 18:42:36
Database context: [Asea_Prod]
Command: ALTER INDEX [PK__PromoCod__3214EC2729363F76] ON [dbo].[PromoCodeDetail] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: Clustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 18258, Fragmentation: 62.5863
Outcome: Succeeded
Duration: 00:00:29
Date and time: 2021-04-01 18:43:05
	
Date and time: 2021-04-01 18:43:11
Database context: [Asea_Prod]
Command: ALTER INDEX [IDX__Autoship_Projected_Cancelled_Autoships_Date] ON [dbo].[tbl_Autoship_Projected_Cancelled_Autoships] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 7088, Fragmentation: 62.3589
Outcome: Succeeded
Duration: 00:00:14
Date and time: 2021-04-01 18:43:25
	
Date and time: 2021-04-01 18:43:25
Database context: [Asea_Prod]
Command: ALTER INDEX [IDX_Autoship_Projected_Cancelled_Autoships_Main_Date] ON [dbo].[tbl_Autoship_Projected_Cancelled_Autoships] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 10395, Fragmentation: 79.9615
Outcome: Succeeded
Duration: 00:00:24
Date and time: 2021-04-01 18:43:49
	
Date and time: 2021-04-01 18:43:49
Database context: [Asea_Prod]
Command: ALTER INDEX [IDX_Autoship_Projected_Cancelled_Autoships_MainDistributorId_RunSequence] ON [dbo].[tbl_Autoship_Projected_Cancelled_Autoships] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 6650, Fragmentation: 64.782
Outcome: Succeeded
Duration: 00:00:11
Date and time: 2021-04-01 18:44:00
	
Date and time: 2021-04-01 18:44:00
Database context: [Asea_Prod]
Command: ALTER INDEX [IDX_Autoship_Projected_Delayed_Orders_Date] ON [dbo].[tbl_Autoship_Projected_Delayed_Orders] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 2321, Fragmentation: 61.6114
Outcome: Succeeded
Duration: 00:00:04
Date and time: 2021-04-01 18:44:04
	
Date and time: 2021-04-01 18:44:04
Database context: [Asea_Prod]
Command: ALTER INDEX [IDX_Autoship_Projected_Delayed_Orders_Main_Date] ON [dbo].[tbl_Autoship_Projected_Delayed_Orders] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 11953, Fragmentation: 99.222
Outcome: Succeeded
Duration: 00:00:22
Date and time: 2021-04-01 18:44:26
	
Date and time: 2021-04-01 18:44:26
Database context: [Asea_Prod]
Command: ALTER INDEX [IDX_Autoship_Projected_Earned_Autoships_DateNext] ON [dbo].[tbl_Autoship_Projected_Earned_Autoships] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 38140, Fragmentation: 94.8243
Outcome: Succeeded
Duration: 00:01:16
Date and time: 2021-04-01 18:45:42
	
Date and time: 2021-04-01 18:45:42
Database context: [Asea_Prod]
Command: ALTER INDEX [IDX_Autoship_Projected_Earned_Autoships_Drilldown] ON [dbo].[tbl_Autoship_Projected_Earned_Autoships] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 112034, Fragmentation: 61.5322
Outcome: Succeeded
Duration: 00:02:36
Date and time: 2021-04-01 18:48:18
	
Date and time: 2021-04-01 18:48:18
Database context: [Asea_Prod]
Command: ALTER INDEX [IDX_Autoship_Projected_Earned_Autoships_Main_Date] ON [dbo].[tbl_Autoship_Projected_Earned_Autoships] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 45357, Fragmentation: 78.8412
Outcome: Succeeded
Duration: 00:01:10
Date and time: 2021-04-01 18:49:28
	
Date and time: 2021-04-01 18:49:28
Database context: [Asea_Prod]
Command: ALTER INDEX [IDX_Autoship_Projected_Earned_Autoships_MainDistributorId] ON [dbo].[tbl_Autoship_Projected_Earned_Autoships] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 46746, Fragmentation: 64.0697
Query was canceled by user.
-----------------

Date and time: 2021-04-02 10:51:06
Server: dlo6zra872
Version: 12.0.2000.8
Edition: SQL Azure
Platform: Windows
Procedure: [Asea_Prod].[dba].[IndexOptimize]
Parameters: @Databases = 'Asea_Prod', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE', @FragmentationHigh = 'INDEX_REBUILD_OFFLINE', @FragmentationLevel1 = 20, @FragmentationLevel2 = 80, @MinNumberOfPages = 1000, @MaxNumberOfPages = 20000, @SortInTempdb = 'N', @MaxDOP = 4, @FillFactor = NULL, @PadIndex = NULL, @LOBCompaction = 'Y', @UpdateStatistics = NULL, @OnlyModifiedStatistics = 'N', @StatisticsModificationLevel = NULL, @StatisticsSample = NULL, @StatisticsResample = 'N', @PartitionLevel = 'Y', @MSShippedObjects = 'N', @Indexes = NULL, @TimeLimit = NULL, @Delay = NULL, @WaitAtLowPriorityMaxDuration = NULL, @WaitAtLowPriorityAbortAfterWait = NULL, @Resumable = 'N', @AvailabilityGroups = NULL, @LockTimeout = NULL, @LockMessageSeverity = 16, @StringDelimiter = ',', @DatabaseOrder = NULL, @DatabasesInParallel = 'N', @ExecuteAsUser = NULL, @LogToTable = 'N', @Execute = 'y'
Version: 2020-12-31 18:58:56
Source: https://ola.hallengren.com
	
Date and time: 2021-04-02 10:51:06
Database: [Asea_Prod]
State: ONLINE
Standby: No
Updateability: READ_WRITE
User access: MULTI_USER
Recovery model: FULL
	
Date and time: 2021-04-02 10:51:29
Database context: [Asea_Prod]
Command: ALTER INDEX [IDX_Leadership_Development_Pool_Downline_Temp_Filters] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = OFF, MAXDOP = 4)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 7703, Fragmentation: 97.4815
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-02 10:51:30
	
Date and time: 2021-04-02 10:51:30
Database context: [Asea_Prod]
Command: ALTER INDEX [ix_NN_tbl_Leadership_Development_Pool_Downline_Temp_Incl_Comp_4_1_2021] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = OFF, MAXDOP = 4)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 2038, Fragmentation: 96.9087
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-02 10:51:30
	
Date and time: 2021-04-02 10:51:30
Database context: [Asea_Prod]
Command: ALTER INDEX [missing_index_6956_6955] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = OFF, MAXDOP = 4)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 5835, Fragmentation: 99.1945
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-02 10:51:31
	
Date and time: 2021-04-02 10:51:31
Database context: [Asea_Prod]
Command: ALTER INDEX [missing_index_748_747] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = OFF, MAXDOP = 4)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 3358, Fragmentation: 99.3151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-02 10:51:31
	
Date and time: 2021-04-02 10:51:38
Database context: [Asea_Prod]
Command: ALTER INDEX [PK__tbl_Loya__3213E83FFDAE2B91] ON [dbo].[tbl_Loyalty_Rewards_Program_Main] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = OFF, MAXDOP = 4)
Comment: ObjectType: Table, IndexType: Clustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 12046, Fragmentation: 99.5517
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-02 10:51:38
	
Date and time: 2021-04-02 10:52:08
	

Completion time: 2021-04-02T07:52:08.8404691-03:00


Date and time: 2021-04-02 11:16:51
Server: dlo6zra872
Version: 12.0.2000.8
Edition: SQL Azure
Platform: Windows
Procedure: [Asea_Prod].[dba].[IndexOptimize]
Parameters: @Databases = 'Asea_Prod', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE', @FragmentationHigh = 'INDEX_REBUILD_OFFLINE', @FragmentationLevel1 = 40, @FragmentationLevel2 = 80, @MinNumberOfPages = 1000, @MaxNumberOfPages = NULL, @SortInTempdb = 'N', @MaxDOP = 4, @FillFactor = NULL, @PadIndex = NULL, @LOBCompaction = 'Y', @UpdateStatistics = NULL, @OnlyModifiedStatistics = 'N', @StatisticsModificationLevel = NULL, @StatisticsSample = NULL, @StatisticsResample = 'N', @PartitionLevel = 'Y', @MSShippedObjects = 'N', @Indexes = NULL, @TimeLimit = NULL, @Delay = NULL, @WaitAtLowPriorityMaxDuration = NULL, @WaitAtLowPriorityAbortAfterWait = NULL, @Resumable = 'N', @AvailabilityGroups = NULL, @LockTimeout = NULL, @LockMessageSeverity = 16, @StringDelimiter = ',', @DatabaseOrder = NULL, @DatabasesInParallel = 'N', @ExecuteAsUser = NULL, @LogToTable = 'N', @Execute = 'y'
Version: 2020-12-31 18:58:56
Source: https://ola.hallengren.com
	
Date and time: 2021-04-02 11:16:51
Database: [Asea_Prod]
State: ONLINE
Standby: No
Updateability: READ_WRITE
User access: MULTI_USER
Recovery model: FULL
	
Date and time: 2021-04-02 11:19:15
Database context: [Asea_Prod]
Command: ALTER INDEX [PK__tbl_Dist__3213E83F01DE82B7] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = OFF, MAXDOP = 4)
Comment: ObjectType: Table, IndexType: Clustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 26777, Fragmentation: 99.1411
Outcome: Succeeded
Duration: 00:00:05
Date and time: 2021-04-02 11:19:20
	
Date and time: 2021-04-02 11:19:20
Database context: [Asea_Prod]
Command: ALTER INDEX [idx_distributor_commissions_custom6_distributorid_marketid_activeminpv] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = OFF, MAXDOP = 4)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 19686, Fragmentation: 86.9044
Outcome: Succeeded
Duration: 00:00:02
Date and time: 2021-04-02 11:19:22
	
Date and time: 2021-04-02 11:19:22
Database context: [Asea_Prod]
Command: ALTER INDEX [idx_tbl_Distributor_Commissions_Temp_v2_Accounttype] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = OFF, MAXDOP = 4)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 18831, Fragmentation: 83.0014
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-02 11:19:23
	
Date and time: 2021-04-02 11:19:23
Database context: [Asea_Prod]
Command: ALTER INDEX [missing_index_16615_16614] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = OFF, MAXDOP = 4)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 15402, Fragmentation: 99.0001
Outcome: Succeeded
Duration: 00:00:02
Date and time: 2021-04-02 11:19:25
	
Date and time: 2021-04-02 11:19:26
Database context: [Asea_Prod]
Command: ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumber] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = OFF, MAXDOP = 4)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 696233, Fragmentation: 99.2139
Outcome: Succeeded
Duration: 00:01:11
Date and time: 2021-04-02 11:20:37
	
Date and time: 2021-04-02 11:20:37
Database context: [Asea_Prod]
Command: ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumber_IWeekGV] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = OFF, MAXDOP = 4)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 1211464, Fragmentation: 99.274
The statement has been terminated.
The statement has been terminated.
Query was canceled by user.
--BLOQUEO, 30 SEGUNDOS.

Date and time: 2021-04-02 11:22:21
Server: dlo6zra872
Version: 12.0.2000.8
Edition: SQL Azure
Platform: Windows
Procedure: [Asea_Prod].[dba].[IndexOptimize]
Parameters: @Databases = 'Asea_Prod', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE', @FragmentationHigh = 'INDEX_REBUILD_ONLINE', @FragmentationLevel1 = 40, @FragmentationLevel2 = 80, @MinNumberOfPages = 1000, @MaxNumberOfPages = NULL, @SortInTempdb = 'N', @MaxDOP = 4, @FillFactor = NULL, @PadIndex = NULL, @LOBCompaction = 'Y', @UpdateStatistics = NULL, @OnlyModifiedStatistics = 'N', @StatisticsModificationLevel = NULL, @StatisticsSample = NULL, @StatisticsResample = 'N', @PartitionLevel = 'Y', @MSShippedObjects = 'N', @Indexes = NULL, @TimeLimit = NULL, @Delay = NULL, @WaitAtLowPriorityMaxDuration = NULL, @WaitAtLowPriorityAbortAfterWait = NULL, @Resumable = 'N', @AvailabilityGroups = NULL, @LockTimeout = NULL, @LockMessageSeverity = 16, @StringDelimiter = ',', @DatabaseOrder = NULL, @DatabasesInParallel = 'N', @ExecuteAsUser = NULL, @LogToTable = 'N', @Execute = 'y'
Version: 2020-12-31 18:58:56
Source: https://ola.hallengren.com
	
Date and time: 2021-04-02 11:22:21
Database: [Asea_Prod]
State: ONLINE
Standby: No
Updateability: READ_WRITE
User access: MULTI_USER
Recovery model: FULL
	
Date and time: 2021-04-02 11:22:32
Database context: [Asea_Prod]
Command: ALTER INDEX [PK__tbl_Dist__3213E83F01DE82B7] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: Clustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 27460, Fragmentation: 98.9658
Outcome: Succeeded
Duration: 00:00:12
Date and time: 2021-04-02 11:22:44
	
Date and time: 2021-04-02 11:22:44
Database context: [Asea_Prod]
Command: ALTER INDEX [idx_distributor_commissions_custom6_distributorid_marketid_activeminpv] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 18863, Fragmentation: 97.5667
Outcome: Succeeded
Duration: 00:00:03
Date and time: 2021-04-02 11:22:47
	
Date and time: 2021-04-02 11:22:47
Database context: [Asea_Prod]
Command: ALTER INDEX [idx_tbl_Distributor_Commissions_Temp_v2_Accounttype] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 18831, Fragmentation: 83.729
Outcome: Succeeded
Duration: 00:00:04
Date and time: 2021-04-02 11:22:51
	
Date and time: 2021-04-02 11:22:51
Database context: [Asea_Prod]
Command: ALTER INDEX [missing_index_16615_16614] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 13001, Fragmentation: 98.677
Outcome: Succeeded
Duration: 00:00:04
Date and time: 2021-04-02 11:22:55
	
Date and time: 2021-04-02 11:22:56
Database context: [Asea_Prod]
Command: ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumber_IWeekGV] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 1211464, Fragmentation: 99.274
Outcome: Succeeded
Duration: 00:06:13
Date and time: 2021-04-02 11:29:09
	
Date and time: 2021-04-02 11:29:09
Database context: [Asea_Prod]
Command: ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumberCommPeriodId] ON [dbo].[tbl_distributor_commissions_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 2428689, Fragmentation: 99.205
The statement has been terminated.
The statement has been terminated.
Query was canceled by user.
--alto uso de CPU

Date and time: 2021-04-02 11:35:04
Server: dlo6zra872
Version: 12.0.2000.8
Edition: SQL Azure
Platform: Windows
Procedure: [Asea_Prod].[dba].[IndexOptimize]
Parameters: @Databases = 'Asea_Prod', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE', @FragmentationHigh = 'INDEX_REORGANIZE', @FragmentationLevel1 = 40, @FragmentationLevel2 = 80, @MinNumberOfPages = 1000, @MaxNumberOfPages = NULL, @SortInTempdb = 'N', @MaxDOP = 4, @FillFactor = NULL, @PadIndex = NULL, @LOBCompaction = 'Y', @UpdateStatistics = NULL, @OnlyModifiedStatistics = 'N', @StatisticsModificationLevel = NULL, @StatisticsSample = NULL, @StatisticsResample = 'N', @PartitionLevel = 'Y', @MSShippedObjects = 'N', @Indexes = NULL, @TimeLimit = NULL, @Delay = NULL, @WaitAtLowPriorityMaxDuration = NULL, @WaitAtLowPriorityAbortAfterWait = NULL, @Resumable = 'N', @AvailabilityGroups = NULL, @LockTimeout = NULL, @LockMessageSeverity = 16, @StringDelimiter = ',', @DatabaseOrder = NULL, @DatabasesInParallel = 'N', @ExecuteAsUser = NULL, @LogToTable = 'N', @Execute = 'y'
Version: 2020-12-31 18:58:56
Source: https://ola.hallengren.com
	
Date and time: 2021-04-02 11:35:05
Database: [Asea_Prod]
State: ONLINE
Standby: No
Updateability: READ_WRITE
User access: MULTI_USER
Recovery model: FULL
	
Date and time: 2021-04-02 11:35:10
Database context: [Asea_Prod]
Command: ALTER INDEX [IX_NN_tbldistributorcommissionsv2_LegacyNumberCommPeriodId] ON [dbo].[tbl_distributor_commissions_v2] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 2428689, Fragmentation: 99.205
Query was canceled by user.
--28 munutos. 20% DTU.

Date and time: 2021-04-02 12:12:15
Server: dlo6zra872
Version: 12.0.2000.8
Edition: SQL Azure
Platform: Windows
Procedure: [Asea_Prod].[dba].[IndexOptimize]
Parameters: @Databases = 'Asea_Prod', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE', @FragmentationHigh = 'INDEX_REBUILD_ONLINE', @FragmentationLevel1 = 20, @FragmentationLevel2 = 40, @MinNumberOfPages = 1000, @MaxNumberOfPages = 20000, @SortInTempdb = 'N', @MaxDOP = 4, @FillFactor = NULL, @PadIndex = NULL, @LOBCompaction = 'Y', @UpdateStatistics = NULL, @OnlyModifiedStatistics = 'N', @StatisticsModificationLevel = NULL, @StatisticsSample = NULL, @StatisticsResample = 'N', @PartitionLevel = 'Y', @MSShippedObjects = 'N', @Indexes = NULL, @TimeLimit = NULL, @Delay = NULL, @WaitAtLowPriorityMaxDuration = NULL, @WaitAtLowPriorityAbortAfterWait = NULL, @Resumable = 'N', @AvailabilityGroups = NULL, @LockTimeout = NULL, @LockMessageSeverity = 16, @StringDelimiter = ',', @DatabaseOrder = NULL, @DatabasesInParallel = 'N', @ExecuteAsUser = NULL, @LogToTable = 'N', @Execute = 'y'
Version: 2020-12-31 18:58:56
Source: https://ola.hallengren.com
	
Date and time: 2021-04-02 12:12:15
Database: [Asea_Prod]
State: ONLINE
Standby: No
Updateability: READ_WRITE
User access: MULTI_USER
Recovery model: FULL
	
Date and time: 2021-04-02 12:12:19
Database context: [Asea_Prod]
Command: ALTER INDEX [idx_001] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 3340, Fragmentation: 37.2156
Outcome: Succeeded
Duration: 00:00:03
Date and time: 2021-04-02 12:12:22
	
Date and time: 2021-04-02 12:12:22
Database context: [Asea_Prod]
Command: ALTER INDEX [idx_02] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 4154, Fragmentation: 72.5806
Outcome: Succeeded
Duration: 00:00:02
Date and time: 2021-04-02 12:12:24
	
Date and time: 2021-04-02 12:12:24
Database context: [Asea_Prod]
Command: ALTER INDEX [idx_03] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 3888, Fragmentation: 61.5998
Outcome: Succeeded
Duration: 00:00:02
Date and time: 2021-04-02 12:12:26
	
Date and time: 2021-04-02 12:12:26
Database context: [Asea_Prod]
Command: ALTER INDEX [idx_distributor_commissions_custom6_distributorid_marketid_activeminpv] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 15456, Fragmentation: 66.162
Outcome: Succeeded
Duration: 00:00:04
Date and time: 2021-04-02 12:12:30
	
Date and time: 2021-04-02 12:12:30
Database context: [Asea_Prod]
Command: ALTER INDEX [idx_distributorCommissions_joincommperiodid] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 3908, Fragmentation: 48.3112
Outcome: Succeeded
Duration: 00:00:02
Date and time: 2021-04-02 12:12:32
	
Date and time: 2021-04-02 12:12:32
Database context: [Asea_Prod]
Command: ALTER INDEX [idx_tbl_Distributor_Commissions_Temp_v2_001] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 6015, Fragmentation: 70.9559
Outcome: Succeeded
Duration: 00:00:02
Date and time: 2021-04-02 12:12:34
	
Date and time: 2021-04-02 12:12:34
Database context: [Asea_Prod]
Command: ALTER INDEX [missing_index_1637_1636] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 6206, Fragmentation: 73.8479
Outcome: Succeeded
Duration: 00:00:02
Date and time: 2021-04-02 12:12:36
	
Date and time: 2021-04-02 12:12:36
Database context: [Asea_Prod]
Command: ALTER INDEX [missing_index_1938_1937] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 4158, Fragmentation: 74.8437
Outcome: Succeeded
Duration: 00:00:02
Date and time: 2021-04-02 12:12:38
	
Date and time: 2021-04-02 12:12:45
Database context: [Asea_Prod]
Command: ALTER INDEX [IDX_Leadership_Development_Pool_Downline_Temp_Filters] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 7798, Fragmentation: 97.7302
Outcome: Succeeded
Duration: 00:00:02
Date and time: 2021-04-02 12:12:47
	
Date and time: 2021-04-02 12:12:47
Database context: [Asea_Prod]
Command: ALTER INDEX [ix_NN_tbl_Leadership_Development_Pool_Downline_Temp_Incl_Comp_4_1_2021] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 2053, Fragmentation: 96.3955
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-02 12:12:48
	
Date and time: 2021-04-02 12:12:48
Database context: [Asea_Prod]
Command: ALTER INDEX [missing_index_6956_6955] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 5775, Fragmentation: 99.2035
Outcome: Succeeded
Duration: 00:00:03
Date and time: 2021-04-02 12:12:51
	
Date and time: 2021-04-02 12:12:51
Database context: [Asea_Prod]
Command: ALTER INDEX [missing_index_748_747] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 3342, Fragmentation: 99.2519
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-02 12:12:52
	
Date and time: 2021-04-02 12:13:28
Database context: [Asea_Prod]
Command: ALTER INDEX [ix_NN_LoginHistory_LoginHistoryUsername_Comp_4_1_2021] ON [Sec].[LoginHistory] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 3021, Fragmentation: 30.3211
Outcome: Succeeded
Duration: 00:00:07
Date and time: 2021-04-02 12:13:35
	
Date and time: 2021-04-02 12:13:35
Database context: [Asea_Prod]
Command: ALTER INDEX [ix_NN_LoginHistoryUsername__Incl_Comp_4_1_2021] ON [Sec].[LoginHistory] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 3031, Fragmentation: 30.7489
Outcome: Succeeded
Duration: 00:00:06
Date and time: 2021-04-02 12:13:41
	
Date and time: 2021-04-02 12:13:41
	

Completion time: 2021-04-02T09:13:42.3349564-03:00



Date and time: 2021-04-02 12:22:27
Server: dlo6zra872
Version: 12.0.2000.8
Edition: SQL Azure
Platform: Windows
Procedure: [Asea_Prod].[dba].[IndexOptimize]
Parameters: @Databases = 'Asea_Prod', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE', @FragmentationHigh = 'INDEX_REBUILD_ONLINE', @FragmentationLevel1 = 20, @FragmentationLevel2 = 40, @MinNumberOfPages = 1000, @MaxNumberOfPages = 30000, @SortInTempdb = 'N', @MaxDOP = 4, @FillFactor = NULL, @PadIndex = NULL, @LOBCompaction = 'Y', @UpdateStatistics = NULL, @OnlyModifiedStatistics = 'N', @StatisticsModificationLevel = NULL, @StatisticsSample = NULL, @StatisticsResample = 'N', @PartitionLevel = 'Y', @MSShippedObjects = 'N', @Indexes = NULL, @TimeLimit = NULL, @Delay = NULL, @WaitAtLowPriorityMaxDuration = NULL, @WaitAtLowPriorityAbortAfterWait = NULL, @Resumable = 'N', @AvailabilityGroups = NULL, @LockTimeout = NULL, @LockMessageSeverity = 16, @StringDelimiter = ',', @DatabaseOrder = NULL, @DatabasesInParallel = 'N', @ExecuteAsUser = NULL, @LogToTable = 'N', @Execute = 'y'
Version: 2020-12-31 18:58:56
Source: https://ola.hallengren.com
	
Date and time: 2021-04-02 12:22:27
Database: [Asea_Prod]
State: ONLINE
Standby: No
Updateability: READ_WRITE
User access: MULTI_USER
Recovery model: FULL
	
Date and time: 2021-04-02 12:25:47
Database context: [Asea_Prod]
Command: ALTER INDEX [PK__tbl_Dist__3213E83F01DE82B7] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: Clustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 29582, Fragmentation: 99.094
Outcome: Succeeded
Duration: 00:00:11
Date and time: 2021-04-02 12:25:58
	
Date and time: 2021-04-02 12:25:58
Database context: [Asea_Prod]
Command: ALTER INDEX [idx_distributor_commissions_custom6_distributorid_marketid_activeminpv] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 21475, Fragmentation: 97.6205
Outcome: Succeeded
Duration: 00:00:03
Date and time: 2021-04-02 12:26:01
	
Date and time: 2021-04-02 12:26:01
Database context: [Asea_Prod]
Command: ALTER INDEX [idx_tbl_Distributor_Commissions_Temp_v2_001] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 10670, Fragmentation: 98.9316
Outcome: Succeeded
Duration: 00:00:04
Date and time: 2021-04-02 12:26:05
	
Date and time: 2021-04-02 12:26:05
Database context: [Asea_Prod]
Command: ALTER INDEX [idx_tbl_Distributor_Commissions_Temp_v2_Accounttype] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 21105, Fragmentation: 83.8427
Outcome: Succeeded
Duration: 00:00:03
Date and time: 2021-04-02 12:26:08
	
Date and time: 2021-04-02 12:26:08
Database context: [Asea_Prod]
Command: ALTER INDEX [IDX_tbl_Distributor_Commissions_Temp_v2_RunDateRunSequenceAccountType] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 6851, Fragmentation: 99.314
Outcome: Succeeded
Duration: 00:00:03
Date and time: 2021-04-02 12:26:11
	
Date and time: 2021-04-02 12:26:11
Database context: [Asea_Prod]
Command: ALTER INDEX [IDX_tbl_Distributor_Commissions_Temp_v2_RunDateRunSequenceAccountTypeCustom6] ON [dbo].[tbl_Distributor_Commissions_Temp_v2] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 7278, Fragmentation: 84.8173
Outcome: Succeeded
Duration: 00:00:03
Date and time: 2021-04-02 12:26:14
	
Date and time: 2021-04-02 12:26:22
Database context: [Asea_Prod]
Command: ALTER INDEX [IDX_Leadership_Development_Pool_Downline_Temp_Filters] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 1804, Fragmentation: 95.7317
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-02 12:26:22
	
Date and time: 2021-04-02 12:26:22
Database context: [Asea_Prod]
Command: ALTER INDEX [missing_index_6956_6955] ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 1377, Fragmentation: 99.2738
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-02 12:26:23
	
Date and time: 2021-04-02 12:26:58
	

Completion time: 2021-04-02T09:26:59.3238718-03:00
