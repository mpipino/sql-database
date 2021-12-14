/*
 3/5/2021 (marzo 2021)
*/

--bodylogic_live:
-- inconcluso: cambio de estrategia, creación de índices comprimidos en paralelo.
--ALTER INDEX [Ix_04_Bl_Commissions_Distributor_SemiMonthly_Temp] ON [dbo].[Bl_Commissions_Distributor_SemiMonthly_Temp] 
--REORGANIZE WITH (LOB_COMPACTION = ON)
--Primer intento: 0 bloqueos, 1:17 segundos. 3.510907 de TLog. La fragmentación continúa en 99%. Solo hizo Reads!!!


--ALTER INDEX [PK_IDDETAILCREDITCARDORDERS] ON [dbo].[tbl_DetailPayment_Orders] REORGANIZE WITH (LOB_COMPACTION = ON)	
--Comment: ObjectType: Table, IndexType: Clustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 4728, Fragmentation: 94.9662
--1:30 segundos OMG! en test. En Live: 4 segundos!

--ALTER INDEX [PkBl_Autoship_Distributor_Discounts_Id] ON [dbo].[Bl_Autoship_Distributor_Discounts] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: Clustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 1858, Fragmentation: 94.4026
--37 s en TEST. En Live 6 segundos.

--NO ejecutado por tamaño: ALTER INDEX [Ix_01_Bl_Commissions_Distributor_SemiMonthly_Temp] ON [dbo].[Bl_Commissions_Distributor_SemiMonthly_Temp] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 58902, Fragmentation: 99.2428
--12:16
--DBCC SQLPERF(logspace) 10% del log

--ALTER INDEX [Ix_02_Bl_Commissions_Distributor_SemiMonthly_Temp] ON [dbo].[Bl_Commissions_Distributor_SemiMonthly_Temp] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 15021, Fragmentation: 99.0214
--3:48 minutos en test. 1:04 en live. 5% tlog.

-- ALTER INDEX [Ix_03_Bl_Commissions_Distributor_SemiMonthly_Temp] ON [dbo].[Bl_Commissions_Distributor_SemiMonthly_Temp] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 154396, Fragmentation: 97.9384
-- 3:31 corté por 12% TLOG.


--Command: ALTER INDEX [Ix_04_Bl_Commissions_Distributor_SemiMonthly_Temp] ON [dbo].[Bl_Commissions_Distributor_SemiMonthly_Temp] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 29947, Fragmentation: 99.272
--56 segundos.

	
--ALTER INDEX [Ix_Nc_Commissions_Distributor_Snapshot_DistributorId_CommissionsPeriodId] ON [dbo].[Commissions_Distributor_Snapshot] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 20783, Fragmentation: 61.9016
--4:38 en test. En Live: 1:22 segundos.

DBCC SQLPERF(logspace)
--ALTER INDEX [PK_TBL_DISTRIBUITOR] ON [dbo].[tbl_Distributor] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: Clustered, ImageText: No, NewLOB: Yes, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 32526, Fragmentation: 96.9563
-- 4:35 en test.  44 segundos en Live. 20% TLOG. 16k páginas luego de la desfragmentación (50%)
--DBCC SQLPERF(logspace) 17% de 5623 . 31 segundos Live.

--ALTER INDEX [Ix_tbl_Distributor_AccountType_MarketId] ON [dbo].[tbl_Distributor] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 11631, Fragmentation: 93.053
-- 1:43 en test. 13 segundos en Live.

--ALTER INDEX [Ix_Nn_tbl_Distributor_Notes_DistributorID_Include] ON [dbo].[tbl_Distributor_Notes] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 28872, Fragmentation: 31.7228
--5:44 en test. 1:37 segundos. Tardo mucho en proporción (notes, será qyue tiene ntext?)
--DBCC SQLPERF(logspace) 12% en test y 11% en live.
	
--ALTER INDEX [nci_wi_tbl_Orders_Header_8A022999096DD5FEC57EA99E9422CA0F] ON [dbo].[tbl_Orders_Header] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 18973, Fragmentation: 47.8996
-- 3:18 en test. 1:12 en Live.

--ALTER INDEX [PK_TBL_REPLICATEDSITES] ON [dbo].[tbl_ReplicatedSites] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: Clustered, ImageText: No, NewLOB: Yes, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 5309, Fragmentation: 99.2466
-- 46 secs. 6 sec on Live.


--ALTER INDEX [Ix_03_Bl_Commissions_Distributor_SemiMonthly_Temp] ON [dbo].[Bl_Commissions_Distributor_SemiMonthly_Temp] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 143169, Fragmentation: 97.8969
-- 7:17 minutos y corté el proceso.
-- + 21:06
--DBCC SQLPERF(logspace)
	
--ALTER INDEX [Ix_04_Bl_Commissions_Distributor_SemiMonthly_Temp] ON [dbo].[Bl_Commissions_Distributor_SemiMonthly_Temp] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 29947, Fragmentation: 99.272

--ALTER INDEX [Ix_01_Azure_Nc_Commissions_Distributor] ON [dbo].[Commissions_Distributor] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 36965, Fragmentation: 18.5337
--6:02 mins
	
--ALTER INDEX [Ix_01_Commissions_Distributor_CommissionsPeriodId_DistributorId] ON [dbo].[Commissions_Distributor] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 18259, Fragmentation: 25.2643
-- 3:13
	
--ALTER INDEX [Ix_01_Commissions_Distributor_Compressed_Temp] ON [dbo].[Commissions_Distributor_Compressed_Temp] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 136105, Fragmentation: 20.4724
--25:25 mins

--ALTER INDEX [Ix_Nn_Commissions_Distributor_Rank_Lines_Temp_RunDate_RunSequence] ON [dbo].[Commissions_Distributor_Rank_Lines_Temp] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 143081, Fragmentation: 23.9585
-- 16:16
-- +
	
--Command: ALTER INDEX [Ix_01_Commissions_Distributor_Temp_ExportSummaryTemp] ON [dbo].[Commissions_Distributor_Temp] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 1104539, Fragmentation: 18.2942
	
--Command: ALTER INDEX [Ix_Nn_tbl_Distributor_JoinDate_include] ON [dbo].[tbl_Distributor] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 4763, Fragmentation: 10.6865
-- 11 secs on live.
	
--Command: ALTER INDEX [Ix_Nn_tbl_Distributor_UserName_Password] ON [dbo].[tbl_Distributor] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 2873, Fragmentation: 19.8399
-- 11 secs on live.
	
--Command: ALTER INDEX [Ix_Nn_Folio_Details_ProductId_Include] ON [Lgt].[Folio_Details] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 2979, Fragmentation: 18.9325
-- 9 secs on live

--ALTER INDEX [Ix_01_Bl_Commissions_Distributor_SemiMonthly_Temp] ON [dbo].[Bl_Commissions_Distributor_SemiMonthly_Temp] 
--REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 133556
--, Fragmentation: 97.8399
-- 4:21 secs on live

--ALTER INDEX [Ix_01_Azure_Nc_Commissions_Distributor] ON [dbo].[Commissions_Distributor] REORGANIZE WITH (LOB_COMPACTION = ON)
-- Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 37467, Fragmentation: 18.6137
-- 1:24 secs, Live.

--Date and time: 2021-03-05 09:46:45
--Database context: [BodyLogic_Live]
--ALTER INDEX [Ix_03_Bl_Commissions_Distributor_SemiMonthly_Temp] ON [dbo].[Bl_Commissions_Distributor_SemiMonthly_Temp] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 133556, Fragmentation: 97.8399
--Outcome: Stopped 6:20 secs. 22 %TLOG.

--Date and time: 2021-03-05 09:46:45
--Database context: [BodyLogic_Live]
--ALTER INDEX [Ix_01_Commissions_Distributor_CommissionsPeriodId_DistributorId] ON [dbo].[Commissions_Distributor] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 18680, Fragmentation: 26.9272
--Outcome: Not Executed

--Date and time: 2021-03-05 09:46:47
--Database context: [BodyLogic_Live]
--ALTER INDEX [PkInvoiceAxosnet_AxosnetId] ON [dbo].[InvoiceAxosnet] REORGANIZE WITH (LOB_COMPACTION = ON)
--Comment: ObjectType: Table, IndexType: Clustered, ImageText: No, NewLOB: Yes, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 4836, Fragmentation: 11.89
--Outcome: Not Executed
--Duration: 00:00:12
/*
Date and time: 2021-03-05 10:04:08
Server: bodylogic
Version: 12.0.2000.8
Edition: SQL Azure
Platform: Windows
Procedure: [BodyLogic_Live].[dba].[IndexOptimize]
Parameters: @Databases = 'BodyLogic_Live', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE', @FragmentationHigh = 'INDEX_REORGANIZE', @FragmentationLevel1 = 10, @FragmentationLevel2 = 99, @MinNumberOfPages = 1000, @MaxNumberOfPages = 10000, @SortInTempdb = 'N', @MaxDOP = 4, @FillFactor = NULL, @PadIndex = NULL, @LOBCompaction = 'Y', @UpdateStatistics = NULL, @OnlyModifiedStatistics = 'N', @StatisticsModificationLevel = NULL, @StatisticsSample = NULL, @StatisticsResample = 'N', @PartitionLevel = 'Y', @MSShippedObjects = 'N', @Indexes = NULL, @TimeLimit = NULL, @Delay = NULL, @WaitAtLowPriorityMaxDuration = NULL, @WaitAtLowPriorityAbortAfterWait = NULL, @Resumable = 'N', @AvailabilityGroups = NULL, @LockTimeout = NULL, @LockMessageSeverity = 16, @StringDelimiter = ',', @DatabaseOrder = NULL, @DatabasesInParallel = 'N', @ExecuteAsUser = NULL, @LogToTable = 'N', @Execute = 'y'
Version: 2020-12-31 18:58:56
Source: https://ola.hallengren.com
	
Date and time: 2021-03-05 10:04:08
Database: [BodyLogic_Live]
State: ONLINE
Standby: No
Updateability: READ_WRITE
User access: MULTI_USER
Recovery model: FULL
	
Date and time: 2021-03-05 10:04:10
Database context: [BodyLogic_Live]
Command: ALTER INDEX [Ix_Nn_Ledger_Commissions_Detail_DistributorLegacyNumber_LedgerCommissionsDetailStatus] ON [dbo].[Ledger_Commissions_Detail] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 1076, Fragmentation: 96.7472
Outcome: Succeeded
Duration: 00:00:07
Date and time: 2021-03-05 10:04:17
	
Date and time: 2021-03-05 10:04:17
Database context: [BodyLogic_Live]
Command: ALTER INDEX [Ix_Nc_01_PromoCodeDistributor] ON [dbo].[PromoCodeDistributor] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 1256, Fragmentation: 10.9076
Outcome: Succeeded
Duration: 00:00:07
Date and time: 2021-03-05 10:04:24
	
Date and time: 2021-03-05 10:04:24
Database context: [BodyLogic_Live]
Command: ALTER INDEX [ix_1_performance_tbl_Distributor] ON [dbo].[tbl_Distributor] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 5639, Fragmentation: 11.0658
Outcome: Succeeded
Duration: 00:00:34
Date and time: 2021-03-05 10:04:58
	
Date and time: 2021-03-05 10:04:59
	
*/

/*
Date and time: 2021-03-05 10:06:22
Database context: [BodyLogic_Live]
Command: ALTER INDEX [Ix_01_Commissions_Distributor_CommissionsPeriodId_DistributorId] ON [dbo].[Commissions_Distributor] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: NonClustered, ImageText: No, NewLOB: No, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 18680, Fragmentation: 26.9272
Outcome: Succeeded
Duration: 00:00:46
Date and time: 2021-03-05 10:07:08	
*/

/*
Date and time: 2021-03-05 10:08:11
Database context: [BodyLogic_Live]
Command: ALTER INDEX [PK_TBL_DISTRIBUITOR] ON [dbo].[tbl_Distributor] REORGANIZE WITH (LOB_COMPACTION = ON)
Comment: ObjectType: Table, IndexType: Clustered, ImageText: No, NewLOB: Yes, FileStream: No, ColumnStore: No, AllowPageLocks: Yes, PageCount: 20538, Fragmentation: 37.5743
Outcome: Succeeded
Duration: 00:00:15
Date and time: 2021-03-05 10:08:26
*/

/*
Fin 3/5/2021 (marzo 2021)
*/


/*
3/6/2021
*/
--ALTER INDEX [Ix_Nn_tbl_Addresses_DistributorId_CharType] ON [dbo].[tbl_Addresses] REORGANIZE WITH (LOB_COMPACTION = ON)
--ALTER INDEX [PK_TBL_DISTRIBUITOR] ON [dbo].[tbl_Distributor] REORGANIZE WITH (LOB_COMPACTION = ON) 
 /*
3/6/2021 end
*/
