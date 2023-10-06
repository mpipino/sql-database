--Actualizacion estadisticas.
EXECUTE dba.IndexOptimize
@Databases = 'Asea_Stage',
@FragmentationLow = NULL,
@FragmentationMedium = NULL,
@FragmentationHigh = NULL,
@UpdateStatistics = 'ALL',
--@MinNumberOfPages=10000,
--@OnlyModifiedStatistics = 'Y',
@StatisticsModificationLevel=10 
--Specify a percentage of modified rows for when the statistics should be updated. 
--https://ola.hallengren.com/sql-server-index-and-statistics-maintenance.html
,@Execute='y'
,@LogToTable='y'

---------------------log----------------------------
/*------------------------
--Actualizacion estadisticas.
EXECUTE dba.IndexOptimize
@Databases = 'Asea_Stage',
@FragmentationLow = NULL,
@FragmentationMedium = NULL,
@FragmentationHigh = NULL,
@UpdateStatistics = 'ALL',
--@MinNumberOfPages=10000,
--@OnlyModifiedStatistics = 'Y',
@StatisticsModificationLevel=10 
--Specify a percentage of modified rows for when the statistics should be updated. 
--https://ola.hallengren.com/sql-server-index-and-statistics-maintenance.html
,@Execute='y'
,@LogToTable='y'
------------------------*/
Date and time: 2021-04-15 13:52:26
Server: dlo6zra872
Version: 12.0.2000.8
Edition: SQL Azure
Platform: Windows
Procedure: [Asea_Stage].[dba].[IndexOptimize]
Parameters: @Databases = 'Asea_Stage', @FragmentationLow = NULL, @FragmentationMedium = NULL, @FragmentationHigh = NULL, @FragmentationLevel1 = 5, @FragmentationLevel2 = 30, @MinNumberOfPages = 1000, @MaxNumberOfPages = NULL, @SortInTempdb = 'N', @MaxDOP = NULL, @FillFactor = NULL, @PadIndex = NULL, @LOBCompaction = 'Y', @UpdateStatistics = 'ALL', @OnlyModifiedStatistics = 'N', @StatisticsModificationLevel = 10, @StatisticsSample = NULL, @StatisticsResample = 'N', @PartitionLevel = 'Y', @MSShippedObjects = 'N', @Indexes = NULL, @TimeLimit = NULL, @Delay = NULL, @WaitAtLowPriorityMaxDuration = NULL, @WaitAtLowPriorityAbortAfterWait = NULL, @Resumable = 'N', @AvailabilityGroups = NULL, @LockTimeout = NULL, @LockMessageSeverity = 16, @StringDelimiter = ',', @DatabaseOrder = NULL, @DatabasesInParallel = 'N', @ExecuteAsUser = NULL, @LogToTable = 'y', @Execute = 'y'
Version: 2020-12-31 18:58:56
Source: https://ola.hallengren.com
	
Date and time: 2021-04-15 13:52:26
Database: [Asea_Stage]
State: ONLINE
Standby: No
Updateability: READ_WRITE
User access: MULTI_USER
Recovery model: FULL
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Com].[Payout_Distributor_Account] [PkPayout_Distributor_Account_PayoutsDistributorAccountId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 892, ModificationCounter: 140
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Com].[Payout_Distributor_Account] [_WA_Sys_00000002_0F6031C5]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 892, ModificationCounter: 140
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Com].[Payout_Distributor_Account] [_WA_Sys_00000003_0F6031C5]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 892, ModificationCounter: 140
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dba].[sp_WhoIsActive_historico] [_WA_Sys_00000006_3DDC7DB4]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 192, ModificationCounter: 2651
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccount] [PK__ACHAccou__EE673C2B54F254F9]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 31, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccount] [_WA_Sys_00000002_66421954]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 31, ModificationCounter: 125
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccount] [_WA_Sys_00000004_66421954]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 31, ModificationCounter: 125
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccount] [_WA_Sys_0000000A_66421954]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 31, ModificationCounter: 125
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccount] [_WA_Sys_0000000B_66421954]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 31, ModificationCounter: 125
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccount] [_WA_Sys_0000000C_66421954]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 31, ModificationCounter: 125
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccount] [_WA_Sys_0000000D_66421954]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 31, ModificationCounter: 125
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccount] [_WA_Sys_00000010_66421954]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 31, ModificationCounter: 125
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccount] [_WA_Sys_00000015_66421954]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 31, ModificationCounter: 125
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccount] [_WA_Sys_00000016_66421954]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 31, ModificationCounter: 125
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccount] [_WA_Sys_00000017_66421954]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 31, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccount] [_WA_Sys_00000018_66421954]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 31, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccountExtend] [PkACHAccountExtendId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 5, ModificationCounter: 37
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccountExtend] [_WA_Sys_00000007_2627943F]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 5, ModificationCounter: 37
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccountExtend] [_WA_Sys_0000000E_2627943F]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 5, ModificationCounter: 37
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ACHAccountExtend] [_WA_Sys_0000000F_2627943F]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 5, ModificationCounter: 37
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:28
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ASEA_PRODUCTS_INTERNAL_WEIGHTS] [_WA_Sys_00000001_2F571C04]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 929, ModificationCounter: 9290
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ASEA_PRODUCTS_INTERNAL_WEIGHTS] [_WA_Sys_00000004_2F571C04]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 929, ModificationCounter: 9290
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_00000003_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 432, ModificationCounter: 1490
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_00000004_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 434, ModificationCounter: 298
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_00000005_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 434, ModificationCounter: 298
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_00000006_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 434, ModificationCounter: 298
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_00000007_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 434, ModificationCounter: 298
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_00000008_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 434, ModificationCounter: 298
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_00000009_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 434, ModificationCounter: 298
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_0000000B_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 432, ModificationCounter: 1490
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_0000000E_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 432, ModificationCounter: 2098
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_00000010_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 432, ModificationCounter: 306
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_00000011_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 432, ModificationCounter: 306
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_00000012_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 434, ModificationCounter: 298
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_00000013_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 434, ModificationCounter: 298
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_00000014_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 434, ModificationCounter: 298
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_DiamondLifestyle_Summary_V2] [_WA_Sys_00000015_095AC0C8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 432, ModificationCounter: 1490
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Hierarchy_Bridge_Tbl] [PK_HIERARCHY_BRIDGE]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 9681, ModificationCounter: 6219376
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Hierarchy_Bridge_Tbl] [HIERARCHY_BRIDGE_CHILD_IDX]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 9681, ModificationCounter: 6219376
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Hierarchy_Bridge_Tbl] [_WA_Sys_00000002_3FD996D2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6224010, ModificationCounter: 162059299
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Hierarchy_Bridge_Tbl] [_WA_Sys_00000003_3FD996D2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6224010, ModificationCounter: 162059299
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:29
	
Date and time: 2021-04-15 13:52:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Hierarchy_Bridge_Tbl] [_WA_Sys_00000004_3FD996D2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6224010, ModificationCounter: 162059299
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Hierarchy_Bridge_Tbl] [_WA_Sys_00000005_3FD996D2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6224010, ModificationCounter: 162059299
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Hierarchy_Bridge_Tbl] [_WA_Sys_00000006_3FD996D2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6224010, ModificationCounter: 162059299
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Hierarchy_Bridge_Tbl] [_WA_Sys_00000007_3FD996D2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6224010, ModificationCounter: 162059299
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_LU_DirectorBuilderBonus_Tbl] [_WA_Sys_00000002_2F473509]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 11156, ModificationCounter: 183544
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_LU_DirectorBuilderBonus_Tbl] [_WA_Sys_00000005_2F473509]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 11156, ModificationCounter: 183544
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_LU_DirectorBuilderBonus_Tbl] [_WA_Sys_00000006_2F473509]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 11156, ModificationCounter: 183544
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_LU_DirectorBuilderBonus_Tbl] [_WA_Sys_00000007_2F473509]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 11156, ModificationCounter: 183544
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_LU_DirectorBuilderBonus_Tbl] [_WA_Sys_00000008_2F473509]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 11156, ModificationCounter: 183544
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_LU_DirectorBuilderBonus_Tbl] [_WA_Sys_00000009_2F473509]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 11156, ModificationCounter: 183544
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_LU_DirectorBuilderBonus_Tbl] [_WA_Sys_0000000A_2F473509]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 11156, ModificationCounter: 183544
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_LU_DirectorBuilderBonus_Tbl] [_WA_Sys_0000000B_2F473509]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 11156, ModificationCounter: 183544
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_LU_DirectorBuilderBonus_Tbl] [_WA_Sys_0000000C_2F473509]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 11156, ModificationCounter: 183544
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_LU_DirectorBuilderBonus_Tbl] [_WA_Sys_0000000D_2F473509]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 11156, ModificationCounter: 183544
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_LU_DirectorBuilderBonus_Tbl] [_WA_Sys_0000000E_2F473509]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 11156, ModificationCounter: 183544
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_LU_DirectorBuilderBonus_Tbl] [_WA_Sys_00000014_2F473509]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 11156, ModificationCounter: 183544
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ASEAI_PROMO_ASIA_EMP_UNLOCKS] [_WA_Sys_00000001_55D1DF28]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 27, ModificationCounter: 324
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ASEAI_PROMO_ASIA_EMP_UNLOCKS] [_WA_Sys_00000002_55D1DF28]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 27, ModificationCounter: 324
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ASEAI_PROMO_ASIA_EMP_UNLOCKS] [_WA_Sys_00000003_55D1DF28]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 27, ModificationCounter: 1080
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ASEAI_PROMO_ASIA_EMP_UNLOCKS] [_WA_Sys_00000005_55D1DF28]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 27, ModificationCounter: 1080
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_Cashville_2021_Summary_Tbl] [_WA_Sys_00000008_4D47E155]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 343, ModificationCounter: 6706
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_EUMarrakesh2021_Summary_Tbl] [_WA_Sys_00000001_0E6E94CE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 118851, ModificationCounter: 237829
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_Ascent_PrizeCheck_Tbl] [_WA_Sys_00000001_513FD230]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 638, ModificationCounter: 1275
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_Ascent_PrizeCheck_Tbl] [_WA_Sys_00000002_513FD230]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 638, ModificationCounter: 1275
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_Ascent_PrizeCheck_Tbl] [_WA_Sys_00000003_513FD230]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 638, ModificationCounter: 1275
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_Ascent_PrizeCheck_Tbl] [_WA_Sys_00000004_513FD230]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 638, ModificationCounter: 1275
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_Ascent_PrizeCheck_Tbl] [_WA_Sys_00000005_513FD230]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 638, ModificationCounter: 1275
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentEnrollments_Tbl] [_WA_Sys_00000002_0864FD83]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 32755, ModificationCounter: 654851
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:30
	
Date and time: 2021-04-15 13:52:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentEnrollments_Tbl] [_WA_Sys_00000003_0864FD83]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 32755, ModificationCounter: 654851
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:52:31
	
Date and time: 2021-04-15 13:52:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentEnrollments_Tbl] [_WA_Sys_00000004_0864FD83]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 32755, ModificationCounter: 654851
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:31
	
Date and time: 2021-04-15 13:52:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentEnrollments_Tbl] [_WA_Sys_00000005_0864FD83]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 32755, ModificationCounter: 654851
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:31
	
Date and time: 2021-04-15 13:52:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentEnrollments_Tbl] [_WA_Sys_00000006_0864FD83]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 32755, ModificationCounter: 654851
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:31
	
Date and time: 2021-04-15 13:52:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentLeaderboard_Asia_Tbl] [IX_NN_PromotionPPP2020_AscentLeaderboard_Asia_DistributorID]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 43863, ModificationCounter: 877588
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:31
	
Date and time: 2021-04-15 13:52:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentLeaderboard_Asia_Tbl] [IX_NN_PromotionPPP2020_AscentLeaderboard_Asia_Prize_I]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 43863, ModificationCounter: 877588
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:31
	
Date and time: 2021-04-15 13:52:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentLeaderboard_Asia_Tbl] [_WA_Sys_00000001_34647873]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 43814, ModificationCounter: 439177
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:31
	
Date and time: 2021-04-15 13:52:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentLeaderboard_Asia_Tbl] [_WA_Sys_00000002_34647873]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 43814, ModificationCounter: 439177
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:31
	
Date and time: 2021-04-15 13:52:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentLeaderboard_Asia_Tbl] [_WA_Sys_00000003_34647873]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 43814, ModificationCounter: 439177
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:31
	
Date and time: 2021-04-15 13:52:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentLeaderboard_Asia_Tbl] [_WA_Sys_00000004_34647873]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 43814, ModificationCounter: 439177
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:31
	
Date and time: 2021-04-15 13:52:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentLeaderboard_Asia_Tbl] [_WA_Sys_00000008_34647873]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 43886, ModificationCounter: 263755
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:31
	
Date and time: 2021-04-15 13:52:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentLeaderboard_Tbl] [IX_NN_PromotionPPP2020_AscentLeaderboard_DistributorID]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 223021, ModificationCounter: 2233155
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:31
	
Date and time: 2021-04-15 13:52:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentLeaderboard_Tbl] [_WA_Sys_00000002_35589CAC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 223021, ModificationCounter: 2233155
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:52:32
	
Date and time: 2021-04-15 13:52:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentLeaderboard_Tbl] [_WA_Sys_00000003_35589CAC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 223021, ModificationCounter: 2233155
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:32
	
Date and time: 2021-04-15 13:52:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentLeaderboard_Tbl] [_WA_Sys_00000004_35589CAC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 223021, ModificationCounter: 2233155
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:32
	
Date and time: 2021-04-15 13:52:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_AscentLeaderboard_Tbl] [_WA_Sys_00000008_35589CAC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 223168, ModificationCounter: 1786966
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:32
	
Date and time: 2021-04-15 13:52:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_DiamondSummit_PrizeCheck_Tbl] [_WA_Sys_00000001_5233F669]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 34, ModificationCounter: 68
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:32
	
Date and time: 2021-04-15 13:52:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_DiamondSummit_PrizeCheck_Tbl] [_WA_Sys_00000002_5233F669]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 34, ModificationCounter: 68
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:32
	
Date and time: 2021-04-15 13:52:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_DiamondSummit_PrizeCheck_Tbl] [_WA_Sys_00000006_5233F669]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 34, ModificationCounter: 68
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:32
	
Date and time: 2021-04-15 13:52:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_LegacyExperience_PrizeCheck_Tbl] [_WA_Sys_00000001_53281AA2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10, ModificationCounter: 20
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:32
	
Date and time: 2021-04-15 13:52:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_PaidAtRank_Tbl] [_WA_Sys_00000002_0D29B2A0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 9021667, ModificationCounter: 54090666
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:32
	
Date and time: 2021-04-15 13:52:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_PaidAtRank_Tbl] [_WA_Sys_00000004_0D29B2A0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 8765947, ModificationCounter: 178015730
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:32
	
Date and time: 2021-04-15 13:52:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_PaidAtRank_Tbl] [_WA_Sys_00000005_0D29B2A0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 8765947, ModificationCounter: 178015730
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:32
	
Date and time: 2021-04-15 13:52:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_PrizeLog_Tbl] [_WA_Sys_00000002_0883B53E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 811, ModificationCounter: 811
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:32
	
Date and time: 2021-04-15 13:52:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_PrizeLog_Tbl] [_WA_Sys_00000003_0883B53E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 811, ModificationCounter: 811
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:32
	
Date and time: 2021-04-15 13:52:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Promotion_PPP2020_PrizeLog_Tbl] [_WA_Sys_00000005_0883B53E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 811, ModificationCounter: 811
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:32
	
Date and time: 2021-04-15 13:52:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Recognition_Top10_AutoshipAllStars] [_WA_Sys_00000001_1E85E577]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 56129, ModificationCounter: 113216
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Recognition_Top10_EMPEarners] [_WA_Sys_00000001_206E2DE9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 172, ModificationCounter: 427
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Recognition_Top10_EMPEarners] [_WA_Sys_00000002_206E2DE9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 172, ModificationCounter: 427
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Recognition_Top10_EMPEarners] [_WA_Sys_00000003_206E2DE9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 172, ModificationCounter: 427
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AseaI_Recognition_Top10_EMPEarners] [_WA_Sys_00000004_206E2DE9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 172, ModificationCounter: 427
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AutoresponderLanguage_Market] [_WA_Sys_00000002_6AEF0AFB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 32, ModificationCounter: 38
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AutoresponderLanguage_Market] [_WA_Sys_00000003_6AEF0AFB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 32, ModificationCounter: 38
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AutoresponderLanguage_Market] [_WA_Sys_00000004_6AEF0AFB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 32, ModificationCounter: 38
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[AutoresponderLanguage_Market] [_WA_Sys_00000005_6AEF0AFB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 32, ModificationCounter: 38
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[BankAbbreviation] [PkBankAbbreviationId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 27, ModificationCounter: 54
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[BankAbbreviation] [_WA_Sys_00000003_6ED75F55]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 27, ModificationCounter: 54
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[BankAbbreviation] [_WA_Sys_00000004_6ED75F55]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 27, ModificationCounter: 54
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[BankCode] [Pk_BankCode]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 4788, ModificationCounter: 9576
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[BankCode] [_WA_Sys_00000002_532F44E0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4788, ModificationCounter: 9576
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[BankCode] [_WA_Sys_00000003_532F44E0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4788, ModificationCounter: 9576
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[BankCode] [_WA_Sys_00000004_532F44E0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4788, ModificationCounter: 9576
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[BankCode] [_WA_Sys_00000009_532F44E0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4788, ModificationCounter: 9576
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:33
	
Date and time: 2021-04-15 13:52:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Log_Global] [missing_index_14451_14450]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 25055836, ModificationCounter: 210465
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:52:34
	
Date and time: 2021-04-15 13:52:34
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Log_Global] [_WA_Sys_00000002_35B0C7CF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 25055836, ModificationCounter: 210465
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:34
	
Date and time: 2021-04-15 13:52:34
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Log_Global] [_WA_Sys_00000003_35B0C7CF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 25055836, ModificationCounter: 210465
Outcome: Succeeded
Duration: 00:00:02
Date and time: 2021-04-15 13:52:36
	
Date and time: 2021-04-15 13:52:36
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Log_Global] [_WA_Sys_00000004_35B0C7CF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 25055836, ModificationCounter: 210465
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:52:37
	
Date and time: 2021-04-15 13:52:37
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Log_Global] [_WA_Sys_00000005_35B0C7CF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 25055836, ModificationCounter: 210465
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:37
	
Date and time: 2021-04-15 13:52:37
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Log_Global] [_WA_Sys_00000007_35B0C7CF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 25055836, ModificationCounter: 210465
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:52:38
	
Date and time: 2021-04-15 13:52:38
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Log_Global] [_WA_Sys_00000008_35B0C7CF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 25055836, ModificationCounter: 210465
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:38
	
Date and time: 2021-04-15 13:52:38
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Log_Global] [_WA_Sys_00000009_35B0C7CF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 25055836, ModificationCounter: 210465
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:38
	
Date and time: 2021-04-15 13:52:38
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Log_Global] [_WA_Sys_0000000A_35B0C7CF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 25055836, ModificationCounter: 210465
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:38
	
Date and time: 2021-04-15 13:52:38
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Log_ProfileVerb] [PkLogProfileVerb_LogVerbId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 4870, ModificationCounter: 1508
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:38
	
Date and time: 2021-04-15 13:52:38
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[LosingActivity] [PK_LosingActivity]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 41884, ModificationCounter: 20550
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:38
	
Date and time: 2021-04-15 13:52:38
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[LosingActivity_Detail] [PK_LosingActivity_Detail]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 1614291, ModificationCounter: 864561
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[LosingActivity_Detail] [_WA_Sys_00000003_589628F8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1615145, ModificationCounter: 477737
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MarketPhoneCountryCode] [PK_MarketPhoneCountryCode]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 2427, ModificationCounter: 3605
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MarketPhoneCountryCode] [_WA_Sys_00000004_2B0E7528]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1100, ModificationCounter: 234
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MarketThreeDSecure] [PkMarketThreeDSecure_MarketThreeDSecureId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 22, ModificationCounter: 44
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MarketThreeDSecure] [_WA_Sys_00000003_4A60FC02]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 22, ModificationCounter: 44
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MarketThreeDSecure] [_WA_Sys_00000006_4A60FC02]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 22, ModificationCounter: 44
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MaxCallSupport_TimeStamps] [ix_NN_MaxCallSupport_TimeStamps_Maxcallsupportid_Incl_Comp]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 270506, ModificationCounter: 17786
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MaxCallSupport_TimeStamps] [_WA_Sys_00000001_0E58A65D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 270506, ModificationCounter: 17786
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MaxCallSupport_TimeStamps] [_WA_Sys_00000003_0E58A65D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 270506, ModificationCounter: 17786
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MaxCallSupport_TimeStamps] [_WA_Sys_00000005_0E58A65D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 270506, ModificationCounter: 17786
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant] [PK__Merchant__04416543F7A7398B]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 123, ModificationCounter: 243
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant] [_WA_Sys_00000002_4C494474]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 123, ModificationCounter: 260
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant] [_WA_Sys_00000004_4C494474]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 123, ModificationCounter: 260
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant] [_WA_Sys_00000005_4C494474]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 123, ModificationCounter: 243
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant] [_WA_Sys_00000006_4C494474]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 123, ModificationCounter: 243
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant] [_WA_Sys_0000000B_4C494474]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 123, ModificationCounter: 260
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Detail] [PK__Merchant__89A418E1DF414CDD]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 140, ModificationCounter: 279
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Detail] [_WA_Sys_00000002_4E318CE6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 139, ModificationCounter: 280
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Detail] [_WA_Sys_00000003_4E318CE6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 139, ModificationCounter: 342
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Detail] [_WA_Sys_00000004_4E318CE6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 139, ModificationCounter: 342
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Detail] [_WA_Sys_00000006_4E318CE6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 139, ModificationCounter: 342
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Detail] [_WA_Sys_00000007_4E318CE6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 139, ModificationCounter: 342
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Detail] [_WA_Sys_00000009_4E318CE6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 139, ModificationCounter: 342
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Detail] [_WA_Sys_0000000A_4E318CE6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 139, ModificationCounter: 342
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Detail] [_WA_Sys_0000000D_4E318CE6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 139, ModificationCounter: 342
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Detail] [_WA_Sys_00000014_4E318CE6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 139, ModificationCounter: 342
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Detail] [_WA_Sys_0000001A_4E318CE6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 139, ModificationCounter: 342
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Detail] [_WA_Sys_0000001B_4E318CE6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 139, ModificationCounter: 342
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Detail_Modules] [PK__Merchant__0196EF502A9B143F]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 1100, ModificationCounter: 2134
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_PaymentType] [_WA_Sys_00000003_52021DCA]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7, ModificationCounter: 1
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Provider] [PK__Merchant__B54C687D55C6C895]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 33, ModificationCounter: 66
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Provider] [_WA_Sys_00000002_53EA663C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 33, ModificationCounter: 66
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Provider] [_WA_Sys_00000003_53EA663C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 33, ModificationCounter: 66
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Provider] [_WA_Sys_00000006_53EA663C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 33, ModificationCounter: 66
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Merchant_Provider] [_WA_Sys_00000007_53EA663C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 33, ModificationCounter: 66
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:39
	
Date and time: 2021-04-15 13:52:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintree] [PkMerchantBraintree_BraintreeId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 812336, ModificationCounter: 33572
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:52:40
	
Date and time: 2021-04-15 13:52:40
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintree] [_WA_Sys_00000002_57BAF720]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 712499, ModificationCounter: 133409
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:40
	
Date and time: 2021-04-15 13:52:40
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintree] [_WA_Sys_00000003_57BAF720]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 712499, ModificationCounter: 133409
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:52:41
	
Date and time: 2021-04-15 13:52:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintree] [_WA_Sys_00000004_57BAF720]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 712499, ModificationCounter: 133409
Outcome: Succeeded
Duration: 00:00:14
Date and time: 2021-04-15 13:52:55
	
Date and time: 2021-04-15 13:52:55
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintree] [_WA_Sys_00000005_57BAF720]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 712499, ModificationCounter: 133409
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:55
	
Date and time: 2021-04-15 13:52:55
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintree] [_WA_Sys_00000006_57BAF720]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 754044, ModificationCounter: 91864
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:52:56
	
Date and time: 2021-04-15 13:52:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintree] [_WA_Sys_00000007_57BAF720]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 748807, ModificationCounter: 97101
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:56
	
Date and time: 2021-04-15 13:52:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintree] [_WA_Sys_00000008_57BAF720]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 712499, ModificationCounter: 133409
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:56
	
Date and time: 2021-04-15 13:52:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintree] [_WA_Sys_0000000A_57BAF720]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 712499, ModificationCounter: 133409
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:56
	
Date and time: 2021-04-15 13:52:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintreePayPal] [IDX_MerchantBraintreePayPal_OrdersId]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 471696, ModificationCounter: 39328
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:56
	
Date and time: 2021-04-15 13:52:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintreePayPal] [_WA_Sys_00000002_64EBCDFE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 441706, ModificationCounter: 69318
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:52:56
	
Date and time: 2021-04-15 13:52:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintreePayPal] [_WA_Sys_00000003_64EBCDFE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 441706, ModificationCounter: 69318
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:52:57
	
Date and time: 2021-04-15 13:52:57
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintreePayPal] [_WA_Sys_00000004_64EBCDFE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 441706, ModificationCounter: 69317
Outcome: Succeeded
Duration: 00:00:15
Date and time: 2021-04-15 13:53:12
	
Date and time: 2021-04-15 13:53:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintreePayPal] [_WA_Sys_00000005_64EBCDFE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 441707, ModificationCounter: 69317
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:12
	
Date and time: 2021-04-15 13:53:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintreePayPal] [_WA_Sys_00000006_64EBCDFE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 471503, ModificationCounter: 39518
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:12
	
Date and time: 2021-04-15 13:53:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintreePayPal] [_WA_Sys_00000007_64EBCDFE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 441707, ModificationCounter: 69317
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:12
	
Date and time: 2021-04-15 13:53:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantBraintreePayPal] [_WA_Sys_0000000A_64EBCDFE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 441707, ModificationCounter: 69317
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:12
	
Date and time: 2021-04-15 13:53:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantCyberSource] [PkMerchantCyberSource_CyberSourceId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 11, ModificationCounter: 23
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:12
	
Date and time: 2021-04-15 13:53:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantGlobalCollect] [PkMerchantGlobalCollect_GlobalCollectId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 12635, ModificationCounter: 1603
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:12
	
Date and time: 2021-04-15 13:53:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantGlobalCollect] [_WA_Sys_00000002_3160440E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 12635, ModificationCounter: 1603
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:12
	
Date and time: 2021-04-15 13:53:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantGlobalCollect] [_WA_Sys_00000003_3160440E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 12635, ModificationCounter: 1603
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:53:13
	
Date and time: 2021-04-15 13:53:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantGlobalCollect] [_WA_Sys_00000004_3160440E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 12635, ModificationCounter: 1603
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:13
	
Date and time: 2021-04-15 13:53:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantGlobalCollect] [_WA_Sys_00000005_3160440E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 12635, ModificationCounter: 1603
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:13
	
Date and time: 2021-04-15 13:53:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantGlobalCollect] [_WA_Sys_00000006_3160440E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 12635, ModificationCounter: 1603
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:13
	
Date and time: 2021-04-15 13:53:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantGlobalCollect] [_WA_Sys_00000007_3160440E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 12635, ModificationCounter: 1603
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:13
	
Date and time: 2021-04-15 13:53:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantWorldPay] [_WA_Sys_00000003_5E67F4AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 302151, ModificationCounter: 38215
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:13
	
Date and time: 2021-04-15 13:53:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantWorldPay] [_WA_Sys_00000004_5E67F4AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 302151, ModificationCounter: 38215
Outcome: Succeeded
Duration: 00:00:02
Date and time: 2021-04-15 13:53:15
	
Date and time: 2021-04-15 13:53:15
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantWorldPay] [_WA_Sys_00000005_5E67F4AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 302151, ModificationCounter: 38215
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantWorldPay] [_WA_Sys_00000007_5E67F4AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 302151, ModificationCounter: 38215
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[MerchantWorldPay] [_WA_Sys_00000008_5E67F4AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 302151, ModificationCounter: 38215
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Modules] [PkModules_Id]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 50, ModificationCounter: 101
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Modules] [_WA_Sys_00000002_0EAAD9F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 50, ModificationCounter: 101
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Modules] [_WA_Sys_00000003_0EAAD9F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 50, ModificationCounter: 101
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Modules] [_WA_Sys_00000004_0EAAD9F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 50, ModificationCounter: 101
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Modules] [_WA_Sys_0000000A_0EAAD9F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 50, ModificationCounter: 101
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Modules] [_WA_Sys_0000000B_0EAAD9F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 50, ModificationCounter: 101
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Modules] [_WA_Sys_0000000C_0EAAD9F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 50, ModificationCounter: 101
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Modules] [_WA_Sys_0000000D_0EAAD9F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 50, ModificationCounter: 101
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Modules] [_WA_Sys_0000000E_0EAAD9F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 50, ModificationCounter: 101
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Modules] [_WA_Sys_0000000F_0EAAD9F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 50, ModificationCounter: 101
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Modules] [_WA_Sys_00000010_0EAAD9F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 50, ModificationCounter: 101
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NavSettings_Exclusions] [_WA_Sys_00000002_2BBF5C33]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 40, ModificationCounter: 82
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NavSettings_Exclusions] [_WA_Sys_00000003_2BBF5C33]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 40, ModificationCounter: 82
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NavSettings_Exclusions] [_WA_Sys_00000004_2BBF5C33]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 40, ModificationCounter: 82
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NavSettings_Exclusions] [_WA_Sys_00000005_2BBF5C33]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 40, ModificationCounter: 82
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NavSettings_Exclusions] [_WA_Sys_0000000A_2BBF5C33]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 40, ModificationCounter: 82
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification] [PkNotification_NotificationId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 232, ModificationCounter: 431
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification] [Ix_Nn_Notification_NotificationStatus]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 232, ModificationCounter: 431
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification] [_WA_Sys_00000002_773E7292]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 232, ModificationCounter: 431
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification] [_WA_Sys_00000004_773E7292]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 232, ModificationCounter: 431
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification] [_WA_Sys_00000005_773E7292]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 232, ModificationCounter: 431
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification] [_WA_Sys_00000006_773E7292]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 232, ModificationCounter: 431
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification] [_WA_Sys_00000008_773E7292]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 232, ModificationCounter: 431
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification] [_WA_Sys_0000000F_773E7292]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 232, ModificationCounter: 431
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification] [_WA_Sys_00000012_773E7292]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 232, ModificationCounter: 431
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification] [_WA_Sys_00000013_773E7292]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 232, ModificationCounter: 431
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification] [_WA_Sys_00000014_773E7292]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 232, ModificationCounter: 431
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification] [_WA_Sys_00000015_773E7292]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 232, ModificationCounter: 431
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification] [_WA_Sys_00000017_773E7292]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 232, ModificationCounter: 431
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification] [_WA_Sys_00000018_773E7292]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 232, ModificationCounter: 431
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_Button] [PkNotificationButton_Id]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 2, ModificationCounter: 4
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_Button] [_WA_Sys_00000004_0A1003B0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2, ModificationCounter: 4
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_ButtonDetail] [PkNotificationButtonDetail_Id]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 41, ModificationCounter: 157
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:16
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_ButtonDetail] [_WA_Sys_00000002_0BF84C22]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 41, ModificationCounter: 157
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_ButtonDetail] [_WA_Sys_00000003_0BF84C22]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 41, ModificationCounter: 157
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_ButtonDetail] [_WA_Sys_00000006_0BF84C22]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 41, ModificationCounter: 157
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_Distributor] [PkNotification_Distributor_NotificationDistributorId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 7509, ModificationCounter: 8693
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_Filter] [PkNotificationFilter_NotificationFilterId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 5, ModificationCounter: 10
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_FilterPage] [PkNotificationFilterPage_NotificationFilterPAgeId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 153, ModificationCounter: 306
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_FilterPage] [_WA_Sys_00000002_0FC8DD06]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 153, ModificationCounter: 306
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_FilterPage] [_WA_Sys_00000003_0FC8DD06]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 153, ModificationCounter: 306
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_FilterPage] [_WA_Sys_00000004_0FC8DD06]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 153, ModificationCounter: 306
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_FilterPage] [_WA_Sys_00000005_0FC8DD06]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 153, ModificationCounter: 306
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_ReportFilter] [PkNotification_ReportFilter_NotificationReportFilterId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 1, ModificationCounter: 2
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_ReportFilterDetails] [_WA_Sys_00000001_148D9223]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 988, ModificationCounter: 1334
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_ReportFilterDetails] [_WA_Sys_00000002_148D9223]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 988, ModificationCounter: 1334
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_ReportFilterDetails] [_WA_Sys_00000003_148D9223]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 988, ModificationCounter: 1334
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_ReportFilterDetails] [_WA_Sys_00000006_148D9223]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 988, ModificationCounter: 1334
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_Type] [PkNotificationType_NotificationTypeId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 4, ModificationCounter: 8
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Notification_Type] [_WA_Sys_00000003_1581B65C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4, ModificationCounter: 8
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NotificationDetail] [PK__Notifica__96C8758451DDB9E1]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 80742, ModificationCounter: 119813
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NotificationDetail] [_WA_Sys_00000006_7B0F0376]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 80742, ModificationCounter: 119813
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NotificationFlagSetting] [_WA_Sys_00000001_7CF74BE8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 8, ModificationCounter: 45
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NotificationFlagSetting] [_WA_Sys_00000002_7CF74BE8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 8, ModificationCounter: 45
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NotificationFlagSetting] [_WA_Sys_00000003_7CF74BE8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 8, ModificationCounter: 45
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NotificationRole] [_WA_Sys_00000001_00C7DCCC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1, ModificationCounter: 2
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NotificationRole] [_WA_Sys_00000002_00C7DCCC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1, ModificationCounter: 2
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NotificationRole] [_WA_Sys_00000003_00C7DCCC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1, ModificationCounter: 2
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NotificationViewOption] [PkNotificationViewOption_NotificationViewOptionId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 4, ModificationCounter: 8
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NotificationViewOption] [_WA_Sys_00000002_01BC0105]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4, ModificationCounter: 8
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[NotificationViewOption] [_WA_Sys_00000003_01BC0105]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4, ModificationCounter: 8
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Om_Distributorranks] [_WA_Sys_0000000C_2293A7E4]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 175294, ModificationCounter: 29851106
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Orders_Header_Bonus] [_WA_Sys_00000007_0E6E2517]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 20162, ModificationCounter: 127122
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[OrderSource] [PK_OrderSource]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 48, ModificationCounter: 96
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[OrderSource] [_WA_Sys_00000002_5C1B4493]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 48, ModificationCounter: 96
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[OrderSource] [_WA_Sys_00000003_5C1B4493]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 48, ModificationCounter: 96
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[OrderSource] [_WA_Sys_00000004_5C1B4493]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 48, ModificationCounter: 96
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[OrderSource] [_WA_Sys_00000009_5C1B4493]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 48, ModificationCounter: 96
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[OrderSource] [_WA_Sys_0000000A_5C1B4493]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 48, ModificationCounter: 96
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[OrderSource] [_WA_Sys_0000000B_5C1B4493]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 48, ModificationCounter: 96
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PageControls] [_WA_Sys_00000002_70BC7F04]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 282, ModificationCounter: 568
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PageControls] [_WA_Sys_00000008_70BC7F04]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 282, ModificationCounter: 568
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PageControls] [_WA_Sys_0000000A_70BC7F04]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 282, ModificationCounter: 568
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PGVprojected] [PK_PGVProjected]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 5875, ModificationCounter: 3771
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PGVprojected] [_WA_Sys_00000005_3744B465]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4843, ModificationCounter: 29199
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PGVProjected_Detail] [_WA_Sys_00000002_392CFCD7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 79332, ModificationCounter: 925836
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PGVProjected_Detail_Temp] [_WA_Sys_00000002_3B154549]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 32399756, ModificationCounter: 497376
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:17
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Product_ForceAutoship_Market] [PK_Product_ForceAutoship_Market]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 11, ModificationCounter: 6
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Product_ForceAutoship_Market] [Ix_Nn_Product_Forceautoship_Market_Productid_Marketid]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 11, ModificationCounter: 6
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Product_ForceAutoship_Market] [_WA_Sys_00000003_02128454]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 11, ModificationCounter: 6
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Product_ForceAutoship_Market] [_WA_Sys_00000004_02128454]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 11, ModificationCounter: 14
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ProductModule] [PK_ProductModule]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 1909, ModificationCounter: 3831
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promo_AscentLeaderboard] [_WA_Sys_0000000A_763CA855]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 314, ModificationCounter: 314
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promocode_BogoTieredAccountType] [_WA_Sys_00000001_4BB4D8C6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 444, ModificationCounter: 315
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promocode_BogoTieredAccountType] [_WA_Sys_00000002_4BB4D8C6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 444, ModificationCounter: 315
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promocode_BogoTieredAccountType] [_WA_Sys_00000003_4BB4D8C6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 444, ModificationCounter: 389
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PromoCode_BogoTieredDetail] [_WA_Sys_0000000B_2E352831]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 368, ModificationCounter: 183
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promocode_BogoTieredMarket] [_WA_Sys_00000001_50798DE3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1121, ModificationCounter: 315
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promocode_BogoTieredMarket] [_WA_Sys_00000002_50798DE3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1121, ModificationCounter: 315
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promocode_BogoTieredMarket] [_WA_Sys_00000003_50798DE3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1436, ModificationCounter: 420
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promocode_LRPTieredAccountType] [_WA_Sys_00000001_32DCA327]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 17, ModificationCounter: 72
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promocode_LRPTieredAccountType] [_WA_Sys_00000002_32DCA327]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 17, ModificationCounter: 72
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promocode_LRPTieredAccountType] [_WA_Sys_00000003_32DCA327]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 17, ModificationCounter: 152
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PromoCode_LRPTieredDetail] [PkPromoCode_LRPTieredDetail_LRPTieredDetailId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 16, ModificationCounter: 18
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PromoCode_LRPTieredDetail] [_WA_Sys_00000002_2676CC42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 16, ModificationCounter: 18
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PromoCode_LRPTieredDetail] [_WA_Sys_0000000C_2676CC42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 16, ModificationCounter: 127
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promocode_LRPTieredMarket] [_WA_Sys_00000001_3000367C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 18, ModificationCounter: 18
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promocode_LRPTieredMarket] [_WA_Sys_00000002_3000367C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 18, ModificationCounter: 18
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promocode_LRPTieredMarket] [_WA_Sys_00000003_3000367C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 18, ModificationCounter: 38
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promocode_MarketTiered] [_WA_Sys_00000003_48D86C1B]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2958, ModificationCounter: 318
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PromoCode_ProductBogoTiered] [_WA_Sys_00000001_3B8F234F]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 946, ModificationCounter: 317
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PromoCode_ProductBogoTiered] [_WA_Sys_00000002_3B8F234F]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 946, ModificationCounter: 317
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PromoCode_ProductBogoTiered] [_WA_Sys_00000003_3B8F234F]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 946, ModificationCounter: 497
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PromoCode_TieredDetail] [_WA_Sys_0000000A_38A8316F]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 122, ModificationCounter: 24
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PromoCodeDetail] [_WA_Sys_00000009_5F0E5685]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1008098, ModificationCounter: 65079
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PromoCodeDetail] [_WA_Sys_0000000A_5F0E5685]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1008098, ModificationCounter: 65029
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PromoCodeDistributorType] [_WA_Sys_00000004_62DEE769]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 657, ModificationCounter: 191
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PromoCodeMarket] [_WA_Sys_00000004_66AF784D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3607, ModificationCounter: 989
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[PromoCodeModule] [_WA_Sys_00000004_6897C0BF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1446, ModificationCounter: 501
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promotions_Rank] [_WA_Sys_00000001_135F82D7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 463, ModificationCounter: 119
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promotions_Rank] [_WA_Sys_00000002_135F82D7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 463, ModificationCounter: 119
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Promotions_Rank] [_WA_Sys_00000003_135F82D7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 463, ModificationCounter: 119
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings] [_WA_Sys_00000001_1EA672A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4105, ModificationCounter: 8834
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings] [_WA_Sys_00000004_1EA672A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4105, ModificationCounter: 8834
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings] [_WA_Sys_00000006_1EA672A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4105, ModificationCounter: 8834
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings] [_WA_Sys_00000007_1EA672A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4105, ModificationCounter: 8835
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings] [_WA_Sys_00000008_1EA672A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4105, ModificationCounter: 8835
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings] [_WA_Sys_00000009_1EA672A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4105, ModificationCounter: 8834
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings] [_WA_Sys_0000000D_1EA672A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4105, ModificationCounter: 8834
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings] [_WA_Sys_0000000F_1EA672A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4105, ModificationCounter: 8834
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings] [_WA_Sys_00000010_1EA672A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4105, ModificationCounter: 8834
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings] [_WA_Sys_00000011_1EA672A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4105, ModificationCounter: 8834
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings] [_WA_Sys_00000012_1EA672A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4105, ModificationCounter: 8834
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings] [_WA_Sys_00000014_1EA672A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4105, ModificationCounter: 8834
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings] [_WA_Sys_00000018_1EA672A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4105, ModificationCounter: 8834
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings] [_WA_Sys_0000001A_1EA672A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4105, ModificationCounter: 8834
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings_MenuType] [PK_RightsManagement_NavSettings_MenuType]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 5, ModificationCounter: 10
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings_Users] [_WA_Sys_00000001_446CF42D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 116591, ModificationCounter: 232106
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:18
	
Date and time: 2021-04-15 13:53:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings_Users] [_WA_Sys_00000004_446CF42D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 116591, ModificationCounter: 232106
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings_Users] [_WA_Sys_00000008_446CF42D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 116591, ModificationCounter: 232106
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings_Users] [_WA_Sys_00000009_446CF42D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 116591, ModificationCounter: 232106
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings_Users] [_WA_Sys_0000000A_446CF42D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 116591, ModificationCounter: 232202
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_NavSettings_Users] [_WA_Sys_0000000B_446CF42D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 116591, ModificationCounter: 232202
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_User_Roles] [_WA_Sys_00000003_7F01C5FD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1210, ModificationCounter: 2098
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_Users] [_WA_Sys_00000002_5873ECDA]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 620, ModificationCounter: 1169
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_Users] [_WA_Sys_00000011_5873ECDA]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 620, ModificationCounter: 1193
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_Users] [_WA_Sys_00000015_5873ECDA]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 620, ModificationCounter: 1169
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_Users] [_WA_Sys_00000031_5873ECDA]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 220, ModificationCounter: 1075
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_Users] [_WA_Sys_00000035_5873ECDA]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 620, ModificationCounter: 1169
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_Users] [_WA_Sys_0000003C_5873ECDA]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 620, ModificationCounter: 1169
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_Users] [_WA_Sys_0000003F_5873ECDA]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 620, ModificationCounter: 1169
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[RightsManagement_Users] [_WA_Sys_0000004E_5873ECDA]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 620, ModificationCounter: 1172
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Roles_PageControls] [PK__tbl_cont__3213E83FB014430B]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 2553, ModificationCounter: 3961
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Roles_PageControls] [_WA_Sys_00000008_6ED43692]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2553, ModificationCounter: 3961
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[SettingGlobal] [PK_SettingGlobal]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 110, ModificationCounter: 271
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[SettingGlobal] [_WA_Sys_00000002_5C4A4B0C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 110, ModificationCounter: 271
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[SettingGlobal] [_WA_Sys_00000004_5C4A4B0C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 110, ModificationCounter: 271
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[SettingGlobal] [_WA_Sys_00000009_5C4A4B0C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 110, ModificationCounter: 271
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[SettingGlobal] [_WA_Sys_0000000A_5C4A4B0C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 110, ModificationCounter: 271
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[SettingSubCategory] [_WA_Sys_00000001_5E32937E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 16, ModificationCounter: 45
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[SettingSubCategory] [_WA_Sys_00000003_5E32937E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 16, ModificationCounter: 45
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ShippingByPostal] [idx_ShippingByPostal_01]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 185, ModificationCounter: 369
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ShippingByPostal] [PK__Shipping__3214EC26FD061DA9]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 185, ModificationCounter: 369
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ShippingByPostal] [_WA_Sys_00000002_79E45FDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 185, ModificationCounter: 369
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ShippingByPostal] [_WA_Sys_00000003_79E45FDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 185, ModificationCounter: 369
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ShippingByPostal] [_WA_Sys_00000004_79E45FDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 185, ModificationCounter: 369
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ShippingByPostal] [_WA_Sys_00000005_79E45FDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 185, ModificationCounter: 369
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ShippingByPostal] [_WA_Sys_00000006_79E45FDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 185, ModificationCounter: 369
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ShippingByPostal] [_WA_Sys_00000009_79E45FDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 185, ModificationCounter: 369
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ShippingByPostal] [_WA_Sys_0000000B_79E45FDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 185, ModificationCounter: 369
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ShippingByPostal] [_WA_Sys_0000000C_79E45FDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 185, ModificationCounter: 369
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ShippingByPostal] [_WA_Sys_0000000D_79E45FDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 185, ModificationCounter: 369
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ShippingByPostal] [_WA_Sys_0000000E_79E45FDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 185, ModificationCounter: 369
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[ShippingByPostal] [_WA_Sys_0000000F_79E45FDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 185, ModificationCounter: 369
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TaxAvalara] [Pk_TaxAvalara_AvalaraId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 2316594, ModificationCounter: 104042
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:53:19
	
Date and time: 2021-04-15 13:53:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TaxAvalara] [_WA_Sys_00000002_4C1D2D00]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2264236, ModificationCounter: 156397
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:53:20
	
Date and time: 2021-04-15 13:53:20
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TaxAvalara] [_WA_Sys_00000003_4C1D2D00]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2264239, ModificationCounter: 156386
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:53:21
	
Date and time: 2021-04-15 13:53:22
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TaxAvalara] [_WA_Sys_00000004_4C1D2D00]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2264251, ModificationCounter: 156248
Outcome: Succeeded
Duration: 00:00:40
Date and time: 2021-04-15 13:54:02
	
Date and time: 2021-04-15 13:54:02
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TaxAvalara] [_WA_Sys_00000005_4C1D2D00]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2264250, ModificationCounter: 156385
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:02
	
Date and time: 2021-04-15 13:54:02
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TaxAvalara] [_WA_Sys_00000006_4C1D2D00]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2264250, ModificationCounter: 156386
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:02
	
Date and time: 2021-04-15 13:54:02
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TaxAvalara] [_WA_Sys_00000007_4C1D2D00]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2264236, ModificationCounter: 156400
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:02
	
Date and time: 2021-04-15 13:54:02
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TaxAvalara] [_WA_Sys_00000009_4C1D2D00]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2264233, ModificationCounter: 156400
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:02
	
Date and time: 2021-04-15 13:54:02
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TaxXirect] [_WA_Sys_00000003_11376022]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1752660, ModificationCounter: 122836
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TaxXirect] [_WA_Sys_00000006_11376022]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1752660, ModificationCounter: 122836
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TaxXirect] [_WA_Sys_00000007_11376022]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1752660, ModificationCounter: 122836
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TaxXirect] [_WA_Sys_00000009_11376022]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1752660, ModificationCounter: 122836
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_ADJUSTMENTS_SUMMARY_V2] [_WA_Sys_00000002_515A78F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 51696, ModificationCounter: 51696
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_ADJUSTMENTS_SUMMARY_V2] [_WA_Sys_00000003_515A78F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 51696, ModificationCounter: 51696
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_ADJUSTMENTS_SUMMARY_V2] [_WA_Sys_00000004_515A78F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 51696, ModificationCounter: 51696
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_ADJUSTMENTS_SUMMARY_V2] [_WA_Sys_00000006_515A78F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 51696, ModificationCounter: 51696
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_ADJUSTMENTS_SUMMARY_V2] [_WA_Sys_00000007_515A78F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 51696, ModificationCounter: 51696
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_ADJUSTMENTS_SUMMARY_V2] [_WA_Sys_00000008_515A78F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 51696, ModificationCounter: 51696
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_ADJUSTMENTS_SUMMARY_V2] [_WA_Sys_0000000F_515A78F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 51696, ModificationCounter: 51696
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_ADJUSTMENTS_SUMMARY_V2] [_WA_Sys_00000010_515A78F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 51696, ModificationCounter: 51696
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_ADJUSTMENTS_SUMMARY_V2] [_WA_Sys_00000013_515A78F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 51696, ModificationCounter: 51696
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_ADJUSTMENTS_SUMMARY_V2] [_WA_Sys_00000024_515A78F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 51696, ModificationCounter: 51696
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_ADJUSTMENTS_SUMMARY_V2] [_WA_Sys_00000025_515A78F2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 51696, ModificationCounter: 51696
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:03
	
Date and time: 2021-04-15 13:54:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_ALERT_SYSTEM] [_WA_Sys_00000004_5C60809C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1315, ModificationCounter: 5271
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:04
	
Date and time: 2021-04-15 13:54:04
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Cancelled_Autoships] [Ix_Un_Tbl_Autoship_Projected_Cancelled_Autoships_Id]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 110459, ModificationCounter: 428001
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:04
	
Date and time: 2021-04-15 13:54:04
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Cancelled_Autoships] [_WA_Sys_00000003_4AAD7B63]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 426915, ModificationCounter: 111545
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:04
	
Date and time: 2021-04-15 13:54:04
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Cancelled_Autoships] [_WA_Sys_00000009_4AAD7B63]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 426915, ModificationCounter: 111545
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Cancelled_Autoships] [_WA_Sys_0000000D_4AAD7B63]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 110459, ModificationCounter: 428001
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Delayed_Orders] [Ix_Un_Tbl_Autoship_Projected_Delayed_Orders_Id]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 56019, ModificationCounter: 236113
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Delayed_Orders] [_WA_Sys_00000003_47D10EB8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 230866, ModificationCounter: 61266
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Delayed_Orders] [_WA_Sys_00000004_47D10EB8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 56019, ModificationCounter: 236113
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Delayed_Orders] [_WA_Sys_0000000B_47D10EB8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 56019, ModificationCounter: 236113
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Earned_Autoships] [Ix_Un_Tbl_Autoship_Projected_Earned_Autoships_Id]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 696159, ModificationCounter: 1517225
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Earned_Autoships] [_WA_Sys_00000004_44F4A20D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 696159, ModificationCounter: 1517225
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Earned_Autoships] [_WA_Sys_0000000D_44F4A20D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 696159, ModificationCounter: 1517225
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Failed_Orders] [Ix_Un_Tbl_Autoship_Projected_Failed_Orders_Id]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 38434, ModificationCounter: 87129
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Failed_Orders] [_WA_Sys_00000004_42183562]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 38434, ModificationCounter: 87129
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Failed_Orders] [_WA_Sys_0000000B_42183562]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 38434, ModificationCounter: 87129
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Failed_Orders] [_WA_Sys_0000000F_42183562]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 38434, ModificationCounter: 87129
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Other_Autoships] [_WA_Sys_00000003_41241129]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 34908, ModificationCounter: 9607
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Other_Autoships] [_WA_Sys_00000004_41241129]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 14291, ModificationCounter: 30224
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Other_Autoships] [_WA_Sys_0000000D_41241129]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 14291, ModificationCounter: 30224
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:05
	
Date and time: 2021-04-15 13:54:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Profiles] [Ix_Un_Tbl_Autoship_Projected_Profiles_Id]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 3728633, ModificationCounter: 3803634
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:06
	
Date and time: 2021-04-15 13:54:06
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Profiles] [_WA_Sys_00000004_3E47A47E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3728633, ModificationCounter: 3803634
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:06
	
Date and time: 2021-04-15 13:54:06
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Autoship_Projected_Profiles] [_WA_Sys_0000000D_3E47A47E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3728633, ModificationCounter: 3803634
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:06
	
Date and time: 2021-04-15 13:54:06
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_AUTOSHIPORDERS_DETAIL] [_WA_Sys_00000002_335592AB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 614914, ModificationCounter: 34986
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:06
	
Date and time: 2021-04-15 13:54:06
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_AUTOSHIPORDERS_DETAIL] [_WA_Sys_00000003_335592AB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 614914, ModificationCounter: 35021
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:06
	
Date and time: 2021-04-15 13:54:06
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_AUTOSHIPORDERS_DETAIL] [_WA_Sys_00000004_335592AB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 614914, ModificationCounter: 35021
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:06
	
Date and time: 2021-04-15 13:54:06
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_AUTOSHIPORDERS_DETAIL] [_WA_Sys_0000000B_335592AB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 614914, ModificationCounter: 34986
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:06
	
Date and time: 2021-04-15 13:54:06
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_AUTOSHIPORDERS_DETAIL] [_WA_Sys_0000000F_335592AB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 614914, ModificationCounter: 34986
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:06
	
Date and time: 2021-04-15 13:54:06
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_AUTOSHIPORDERS_DETAIL] [_WA_Sys_00000015_335592AB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 614914, ModificationCounter: 34986
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:06
	
Date and time: 2021-04-15 13:54:06
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_AUTOSHIPORDERS_DETAIL] [_WA_Sys_00000016_335592AB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 614914, ModificationCounter: 34986
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:06
	
Date and time: 2021-04-15 13:54:06
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_AUTOSHIPORDERS_DETAIL] [_WA_Sys_00000023_335592AB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 614914, ModificationCounter: 34986
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:06
	
Date and time: 2021-04-15 13:54:06
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_AUTOSHIPORDERS_DETAIL] [_WA_Sys_00000024_335592AB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 614914, ModificationCounter: 34986
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:06
	
Date and time: 2021-04-15 13:54:06
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_AutoshipOrders_Detail_Recalculate] [_WA_Sys_00000001_6C3B23F4]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2760, ModificationCounter: 53807
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_AutoshipOrders_Detail_Recalculate] [_WA_Sys_00000002_6C3B23F4]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2760, ModificationCounter: 53807
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_AUTOSHIPORDERS_HEADER] [_WA_Sys_00000035_59D8D28D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 536290, ModificationCounter: 534224
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_AutoshipOrders_Header_Recalculate] [_WA_Sys_00000001_6B46FFBB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2351, ModificationCounter: 45900
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_AutoshipOrders_Recalculate_Differences] [_WA_Sys_00000006_3D4B2AE1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2759, ModificationCounter: 53794
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_AutoshipOrders_Recalculate_Differences] [_WA_Sys_0000000B_3D4B2AE1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2759, ModificationCounter: 53794
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_AutoshipOrders_Recalculate_Differences] [_WA_Sys_00000013_3D4B2AE1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2759, ModificationCounter: 53794
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_AutoshipOrders_Recalculate_Differences] [_WA_Sys_00000015_3D4B2AE1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2759, ModificationCounter: 53794
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_AutoshipOrders_Recalculate_Differences_Notes] [Ix_Nc_Tbl_Autoshiporders_Recalculate_Differences_Notes_AutoshipID]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 2352, ModificationCounter: 2352
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_AutoshipOrders_Recalculate_Differences_Notes] [_WA_Sys_00000001_40AD792F]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2359, ModificationCounter: 48229
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_AutoshipOrders_Recalculate_Differences_Notes] [_WA_Sys_00000002_40AD792F]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2359, ModificationCounter: 48229
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_balance_temp_v2] [_WA_Sys_00000002_54F5FFAC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6094, ModificationCounter: 36956
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_balance_temp_v2] [_WA_Sys_00000003_54F5FFAC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6094, ModificationCounter: 36956
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_balance_temp_v2] [_WA_Sys_00000004_54F5FFAC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6094, ModificationCounter: 36956
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_balance_temp_v2] [_WA_Sys_00000005_54F5FFAC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6094, ModificationCounter: 36956
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_balance_temp_v2] [_WA_Sys_00000006_54F5FFAC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6094, ModificationCounter: 36956
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_balance_temp_v2] [_WA_Sys_00000009_54F5FFAC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6094, ModificationCounter: 36956
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_balance_temp_v2] [_WA_Sys_0000000A_54F5FFAC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6094, ModificationCounter: 36956
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_BANNER] [_WA_Sys_00000006_00D1548E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2044, ModificationCounter: 8201
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Fast_Start_Temp_v2] [_WA_Sys_00000004_0A92F64E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3027, ModificationCounter: 3027
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Fast_Start_Temp_v2] [_WA_Sys_00000008_0A92F64E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3027, ModificationCounter: 3027
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Fast_Start_Temp_v2] [_WA_Sys_00000009_0A92F64E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3027, ModificationCounter: 3027
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Fast_Start_Temp_v2] [_WA_Sys_0000000A_0A92F64E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3027, ModificationCounter: 3027
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Fast_Start_Temp_v2] [_WA_Sys_0000000D_0A92F64E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3027, ModificationCounter: 3027
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Matching_Temp_v2] [_WA_Sys_00000003_28235935]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62235, ModificationCounter: 62235
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Matching_Temp_v2] [_WA_Sys_00000004_28235935]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62235, ModificationCounter: 62235
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Matching_Temp_v2] [_WA_Sys_00000008_28235935]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62235, ModificationCounter: 62235
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Matching_Temp_v2] [_WA_Sys_0000000B_28235935]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62235, ModificationCounter: 62235
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Matching_Temp_v2] [_WA_Sys_0000000C_28235935]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62235, ModificationCounter: 62235
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Matching_Temp_v2] [_WA_Sys_00000013_28235935]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62235, ModificationCounter: 62235
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Matching_Temp_v2] [_WA_Sys_00000015_28235935]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62235, ModificationCounter: 62235
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Preferred_Temp_v2] [_WA_Sys_00000004_04DA1CF8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 8841, ModificationCounter: 8841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Preferred_Temp_v2] [_WA_Sys_00000008_04DA1CF8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 8841, ModificationCounter: 8841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Preferred_Temp_v2] [_WA_Sys_00000009_04DA1CF8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 8841, ModificationCounter: 8841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Preferred_Temp_v2] [_WA_Sys_0000000A_04DA1CF8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 8841, ModificationCounter: 8841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Preferred_Temp_v2] [_WA_Sys_0000000C_04DA1CF8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 8841, ModificationCounter: 8841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_summary_v2] [PK__tbl_Bonu_team_comm__3214EC2754188662]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 248648, ModificationCounter: 890728
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_summary_v2] [_WA_Sys_00000002_445CCEDB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 27592, ModificationCounter: 4508456
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_summary_v2] [_WA_Sys_00000004_445CCEDB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1018760, ModificationCounter: 3517288
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_summary_v2] [_WA_Sys_00000008_445CCEDB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1018760, ModificationCounter: 3517288
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:07
	
Date and time: 2021-04-15 13:54:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_summary_v2] [_WA_Sys_00000009_445CCEDB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1018760, ModificationCounter: 3517288
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_summary_v2] [_WA_Sys_0000000A_445CCEDB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1018760, ModificationCounter: 3517288
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_summary_v2] [_WA_Sys_0000000E_445CCEDB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1018760, ModificationCounter: 3517288
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_summary_v2] [_WA_Sys_0000000F_445CCEDB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 27592, ModificationCounter: 4551924
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_Temp_v2] [PK__tbl_Bonu__3214EC2754188662]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 1123, ModificationCounter: 3369
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_Temp_v2] [missing_index_19403_19402]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 2246, ModificationCounter: 2246
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_Temp_v2] [missing_index_19497_19496]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 2246, ModificationCounter: 2246
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_Temp_v2] [missing_index_19499_19498]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 2246, ModificationCounter: 2246
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_Temp_v2] [missing_index_19526_19525]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 2246, ModificationCounter: 2246
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_Temp_v2] [_WA_Sys_00000004_16F8CD33]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2246, ModificationCounter: 2246
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Bonus_Team_Commissions_Temp_v2] [_WA_Sys_0000000A_16F8CD33]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2246, ModificationCounter: 2246
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_BTB_DISTRIBUTOR] [PK_TBL_BTB_DISTRIBUTOR]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 245567, ModificationCounter: 245607
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_BTB_DISTRIBUTOR] [_WA_Sys_00000002_31DF6B94]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 245567, ModificationCounter: 245607
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_BTB_DISTRIBUTOR] [_WA_Sys_00000003_31DF6B94]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 245567, ModificationCounter: 245607
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_CAMPAIGNS] [PF_Tbl_Campaigns_ID]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 186, ModificationCounter: 375
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_CAMPAIGNS] [_WA_Sys_00000001_34BE3A44]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 186, ModificationCounter: 375
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_CAMPAIGNS] [_WA_Sys_00000002_34BE3A44]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 186, ModificationCounter: 375
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_CAMPAIGNS] [_WA_Sys_00000003_34BE3A44]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 186, ModificationCounter: 375
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_CAMPAIGNS] [_WA_Sys_00000004_34BE3A44]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 186, ModificationCounter: 375
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_CAMPAIGNSXTEMPLATES] [PK__TBL_CAMP__3214EC271121E9A7]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 14335, ModificationCounter: 28365
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_CAMPAIGNSXTEMPLATES] [_WA_Sys_00000003_1A0A4408]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 14335, ModificationCounter: 28452
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_COUNTRYPHONECODES] [PK_TBL_COUNTRYPHONECODES]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 78, ModificationCounter: 156
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_COUNTRYPHONECODES] [_WA_Sys_00000002_744D18C6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 78, ModificationCounter: 156
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_COUNTRYPHONECODES] [_WA_Sys_00000003_744D18C6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 78, ModificationCounter: 156
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_COUNTRYPHONECODES] [_WA_Sys_00000004_744D18C6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 78, ModificationCounter: 156
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_COUNTRYPHONECODES] [_WA_Sys_00000005_744D18C6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 78, ModificationCounter: 156
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_CUSTOMERSEARCH_TEMPLATE] [_WA_Sys_00000001_7B8C3CDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 483, ModificationCounter: 914
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_CUSTOMERSEARCH_TEMPLATE] [_WA_Sys_00000002_7B8C3CDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 483, ModificationCounter: 914
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_CUSTOMERSEARCH_TEMPLATE] [_WA_Sys_00000003_7B8C3CDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 483, ModificationCounter: 914
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_CUSTOMERSEARCH_TEMPLATE] [_WA_Sys_00000005_7B8C3CDD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 483, ModificationCounter: 921
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR] [_WA_Sys_0000001E_2B7F66B9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709080, ModificationCounter: 1095833
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR] [_WA_Sys_0000002A_2B7F66B9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 711636, ModificationCounter: 711504
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR] [_WA_Sys_0000002F_2B7F66B9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709080, ModificationCounter: 37526
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:08
	
Date and time: 2021-04-15 13:54:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR] [_WA_Sys_0000007D_2B7F66B9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709080, ModificationCounter: 96892
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:09
	
Date and time: 2021-04-15 13:54:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR] [_WA_Sys_000000CF_2B7F66B9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709080, ModificationCounter: 32337
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:09
	
Date and time: 2021-04-15 13:54:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR] [_WA_Sys_000000D0_2B7F66B9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709080, ModificationCounter: 32333
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:09
	
Date and time: 2021-04-15 13:54:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR] [_WA_Sys_000000DE_2B7F66B9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709080, ModificationCounter: 380742
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:09
	
Date and time: 2021-04-15 13:54:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR] [_WA_Sys_000000E2_2B7F66B9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709080, ModificationCounter: 43540
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:09
	
Date and time: 2021-04-15 13:54:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000005_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:10
	
Date and time: 2021-04-15 13:54:10
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000006_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:10
	
Date and time: 2021-04-15 13:54:10
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000007_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:10
	
Date and time: 2021-04-15 13:54:10
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000000A_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:11
	
Date and time: 2021-04-15 13:54:11
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000000C_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:11
	
Date and time: 2021-04-15 13:54:11
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000000D_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:11
	
Date and time: 2021-04-15 13:54:11
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000011_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:11
	
Date and time: 2021-04-15 13:54:11
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000012_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:12
	
Date and time: 2021-04-15 13:54:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000015_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:12
	
Date and time: 2021-04-15 13:54:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000019_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:12
	
Date and time: 2021-04-15 13:54:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000001E_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:13
	
Date and time: 2021-04-15 13:54:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000002C_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:13
	
Date and time: 2021-04-15 13:54:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000032_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 579707635
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:14
	
Date and time: 2021-04-15 13:54:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000033_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 579707635
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:14
	
Date and time: 2021-04-15 13:54:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000038_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:14
	
Date and time: 2021-04-15 13:54:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000040_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:14
	
Date and time: 2021-04-15 13:54:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000041_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:15
	
Date and time: 2021-04-15 13:54:15
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000042_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:15
	
Date and time: 2021-04-15 13:54:15
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000044_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:15
	
Date and time: 2021-04-15 13:54:15
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000004E_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:16
	
Date and time: 2021-04-15 13:54:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000004F_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:16
	
Date and time: 2021-04-15 13:54:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000051_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:16
	
Date and time: 2021-04-15 13:54:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000055_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:17
	
Date and time: 2021-04-15 13:54:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000056_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:17
	
Date and time: 2021-04-15 13:54:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000057_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:17
	
Date and time: 2021-04-15 13:54:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000005A_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:18
	
Date and time: 2021-04-15 13:54:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000005B_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:18
	
Date and time: 2021-04-15 13:54:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000005C_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:18
	
Date and time: 2021-04-15 13:54:18
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000005D_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:19
	
Date and time: 2021-04-15 13:54:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000063_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:19
	
Date and time: 2021-04-15 13:54:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000064_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:19
	
Date and time: 2021-04-15 13:54:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000065_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:19
	
Date and time: 2021-04-15 13:54:19
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000067_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:20
	
Date and time: 2021-04-15 13:54:20
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000006F_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371573712
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:20
	
Date and time: 2021-04-15 13:54:20
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000072_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:20
	
Date and time: 2021-04-15 13:54:20
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000074_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:21
	
Date and time: 2021-04-15 13:54:21
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000075_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:21
	
Date and time: 2021-04-15 13:54:21
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000007A_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:21
	
Date and time: 2021-04-15 13:54:21
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000007C_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:22
	
Date and time: 2021-04-15 13:54:22
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_00000096_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:22
	
Date and time: 2021-04-15 13:54:22
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000009A_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:22
	
Date and time: 2021-04-15 13:54:22
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000009B_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:22
	
Date and time: 2021-04-15 13:54:22
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_summary_v2] [_WA_Sys_0000009D_2393AE42]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1418173, ModificationCounter: 371528841
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:23
	
Date and time: 2021-04-15 13:54:23
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_00000005_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:23
	
Date and time: 2021-04-15 13:54:23
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_00000009_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 438702754
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:23
	
Date and time: 2021-04-15 13:54:23
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_0000000A_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:23
	
Date and time: 2021-04-15 13:54:23
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_0000000E_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 440768930
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:23
	
Date and time: 2021-04-15 13:54:23
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_00000011_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 437476088
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:23
	
Date and time: 2021-04-15 13:54:23
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_00000015_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:23
	
Date and time: 2021-04-15 13:54:23
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_00000016_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:23
	
Date and time: 2021-04-15 13:54:23
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_00000017_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:23
	
Date and time: 2021-04-15 13:54:23
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_00000019_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:23
	
Date and time: 2021-04-15 13:54:23
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_00000022_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:23
	
Date and time: 2021-04-15 13:54:23
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_0000002A_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:23
	
Date and time: 2021-04-15 13:54:23
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_0000002E_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 452696368
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_00000030_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 452696368
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_0000003F_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_00000043_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_0000004D_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_0000004E_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 711496, ModificationCounter: 52650766
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_00000066_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_0000006B_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_0000006E_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843449
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_00000071_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_0000008B_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_00000096_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_00000099_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 434843151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_000000B0_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 585947292
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_000000B1_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 585947292
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Commissions_Temp_v2] [_WA_Sys_000000B3_294C8798]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 709113, ModificationCounter: 585947292
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:24
	
Date and time: 2021-04-15 13:54:24
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000002_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:25
	
Date and time: 2021-04-15 13:54:25
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000003_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273637, ModificationCounter: 12228053
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:25
	
Date and time: 2021-04-15 13:54:25
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000009_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 100849679, ModificationCounter: 2867860
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:25
	
Date and time: 2021-04-15 13:54:25
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000000A_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273584, ModificationCounter: 41290871
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:26
	
Date and time: 2021-04-15 13:54:26
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000000C_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:26
	
Date and time: 2021-04-15 13:54:26
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000000D_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:26
	
Date and time: 2021-04-15 13:54:26
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000000F_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273637, ModificationCounter: 12095464
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:27
	
Date and time: 2021-04-15 13:54:27
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000010_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 101560630, ModificationCounter: 136541785
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:27
	
Date and time: 2021-04-15 13:54:27
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000011_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:27
	
Date and time: 2021-04-15 13:54:27
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000013_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:27
	
Date and time: 2021-04-15 13:54:27
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000014_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:28
	
Date and time: 2021-04-15 13:54:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000015_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:28
	
Date and time: 2021-04-15 13:54:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000016_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 100849842, ModificationCounter: 209018502
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:28
	
Date and time: 2021-04-15 13:54:28
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000019_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 100849842, ModificationCounter: 209018502
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:29
	
Date and time: 2021-04-15 13:54:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000001A_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 100849842, ModificationCounter: 209018502
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:29
	
Date and time: 2021-04-15 13:54:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000001B_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:29
	
Date and time: 2021-04-15 13:54:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000001C_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:29
	
Date and time: 2021-04-15 13:54:29
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000001D_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273604, ModificationCounter: 40579386
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:30
	
Date and time: 2021-04-15 13:54:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000001E_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273604, ModificationCounter: 40579386
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:30
	
Date and time: 2021-04-15 13:54:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000001F_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273637, ModificationCounter: 12095464
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:30
	
Date and time: 2021-04-15 13:54:30
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000023_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:31
	
Date and time: 2021-04-15 13:54:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000024_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273635, ModificationCounter: 28483971
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:31
	
Date and time: 2021-04-15 13:54:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000026_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:31
	
Date and time: 2021-04-15 13:54:31
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000029_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:32
	
Date and time: 2021-04-15 13:54:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000002A_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:32
	
Date and time: 2021-04-15 13:54:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000002B_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:32
	
Date and time: 2021-04-15 13:54:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000002D_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273604, ModificationCounter: 40579386
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:32
	
Date and time: 2021-04-15 13:54:32
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000002E_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:33
	
Date and time: 2021-04-15 13:54:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000032_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:33
	
Date and time: 2021-04-15 13:54:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000033_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:33
	
Date and time: 2021-04-15 13:54:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000034_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:33
	
Date and time: 2021-04-15 13:54:33
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000036_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:34
	
Date and time: 2021-04-15 13:54:34
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000003E_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273604, ModificationCounter: 40579386
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:34
	
Date and time: 2021-04-15 13:54:34
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000003F_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273604, ModificationCounter: 40579386
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:34
	
Date and time: 2021-04-15 13:54:34
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000056_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:35
	
Date and time: 2021-04-15 13:54:35
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000057_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:35
	
Date and time: 2021-04-15 13:54:35
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000058_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:35
	
Date and time: 2021-04-15 13:54:35
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000059_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:35
	
Date and time: 2021-04-15 13:54:35
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000005A_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:36
	
Date and time: 2021-04-15 13:54:36
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000005B_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:36
	
Date and time: 2021-04-15 13:54:36
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000005C_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:36
	
Date and time: 2021-04-15 13:54:36
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000005D_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:37
	
Date and time: 2021-04-15 13:54:37
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000005E_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:37
	
Date and time: 2021-04-15 13:54:37
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000005F_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:37
	
Date and time: 2021-04-15 13:54:37
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000006F_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 100849679, ModificationCounter: 2867860
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:37
	
Date and time: 2021-04-15 13:54:37
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000007D_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 100849842, ModificationCounter: 209018502
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:38
	
Date and time: 2021-04-15 13:54:38
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000090_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 100849842, ModificationCounter: 209018502
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:38
	
Date and time: 2021-04-15 13:54:38
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000095_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273523, ModificationCounter: 44136720
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:38
	
Date and time: 2021-04-15 13:54:38
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000096_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273604, ModificationCounter: 40579386
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:39
	
Date and time: 2021-04-15 13:54:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000097_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273604, ModificationCounter: 40579386
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:39
	
Date and time: 2021-04-15 13:54:39
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000098_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273584, ModificationCounter: 41290871
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:40
	
Date and time: 2021-04-15 13:54:40
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_00000099_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273584, ModificationCounter: 41290871
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:40
	
Date and time: 2021-04-15 13:54:40
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000009A_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:40
	
Date and time: 2021-04-15 13:54:40
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000009B_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:40
	
Date and time: 2021-04-15 13:54:40
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000009C_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_distributor_commissions_v2] [_WA_Sys_0000009D_7ACDD0DC]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 102273641, ModificationCounter: 711498
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_FANFARE] [PK_TBL_DISTRIBUTOR_FANFARE]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 3148, ModificationCounter: 6297
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_FANFARE] [_WA_Sys_00000004_1903D2A0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3139, ModificationCounter: 25132
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_FANFARE_PREVIEW] [_WA_Sys_00000001_219918A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3138, ModificationCounter: 25151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_FANFARE_PREVIEW] [_WA_Sys_00000004_219918A1]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3138, ModificationCounter: 25151
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS] [_WA_Sys_00000003_32C3A4A3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 956, ModificationCounter: 5566
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS] [_WA_Sys_00000004_32C3A4A3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 956, ModificationCounter: 5566
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS_PREVIEW] [_WA_Sys_00000001_3970A232]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 956, ModificationCounter: 7608
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS_PREVIEW] [_WA_Sys_00000002_3970A232]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 956, ModificationCounter: 7608
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS_PREVIEW] [_WA_Sys_00000003_3970A232]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 956, ModificationCounter: 7608
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS_PREVIEW] [_WA_Sys_00000004_3970A232]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 956, ModificationCounter: 7608
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS_PREVIEW] [_WA_Sys_00000005_3970A232]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 956, ModificationCounter: 7608
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS_PREVIEW] [_WA_Sys_00000006_3970A232]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 956, ModificationCounter: 7608
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS_PREVIEW] [_WA_Sys_00000007_3970A232]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 956, ModificationCounter: 7608
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS_PREVIEW] [_WA_Sys_00000008_3970A232]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 956, ModificationCounter: 7608
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS_PREVIEW] [_WA_Sys_00000009_3970A232]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 956, ModificationCounter: 7608
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS_PREVIEW] [_WA_Sys_0000000A_3970A232]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 956, ModificationCounter: 7608
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS_PREVIEW] [_WA_Sys_0000000B_3970A232]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 956, ModificationCounter: 7608
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS_PREVIEW] [_WA_Sys_0000000C_3970A232]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1021, ModificationCounter: 1897
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_00000003_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_00000007_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_00000009_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:41
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_0000000A_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:41
	
Date and time: 2021-04-15 13:54:42
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_0000000B_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:42
	
Date and time: 2021-04-15 13:54:42
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_0000000C_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:42
	
Date and time: 2021-04-15 13:54:42
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_0000000D_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:42
	
Date and time: 2021-04-15 13:54:42
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_0000000E_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:42
	
Date and time: 2021-04-15 13:54:42
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_0000000F_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:42
	
Date and time: 2021-04-15 13:54:42
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_00000010_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:42
	
Date and time: 2021-04-15 13:54:42
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_00000011_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:42
	
Date and time: 2021-04-15 13:54:42
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_00000012_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:42
	
Date and time: 2021-04-15 13:54:42
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_00000013_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:42
	
Date and time: 2021-04-15 13:54:42
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_00000018_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:42
	
Date and time: 2021-04-15 13:54:42
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_00000019_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:42
	
Date and time: 2021-04-15 13:54:42
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_0000001C_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:42
	
Date and time: 2021-04-15 13:54:42
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_0000001D_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:43
	
Date and time: 2021-04-15 13:54:43
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_00000021_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:43
	
Date and time: 2021-04-15 13:54:43
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_00000025_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:43
	
Date and time: 2021-04-15 13:54:43
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Distributor_Snapshot] [_WA_Sys_00000026_0B702E21]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7051393, ModificationCounter: 711636
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:43
	
Date and time: 2021-04-15 13:54:43
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_EMAILTEMPLATEMANAGMENT] [_WA_Sys_00000002_575DE8F7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1564, ModificationCounter: 2900
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:43
	
Date and time: 2021-04-15 13:54:43
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_EMAILTEMPLATEMANAGMENT] [_WA_Sys_00000003_575DE8F7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1564, ModificationCounter: 2900
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_EMAILTEMPLATEMANAGMENT] [_WA_Sys_00000004_575DE8F7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1564, ModificationCounter: 2873
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_EMAILTEMPLATEMANAGMENT] [_WA_Sys_0000000C_575DE8F7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1564, ModificationCounter: 2900
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_EMAILTEMPLATEMANAGMENT] [_WA_Sys_00000013_575DE8F7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1564, ModificationCounter: 2900
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_EMAILTEMPLATEMANAGMENTTAG] [PK_TBL_EMAILTEMPLATEMANAGMENT_TAG]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 203, ModificationCounter: 411
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_EMAILTEMPLATEMANAGMENTTAG] [_WA_Sys_00000002_59463169]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 203, ModificationCounter: 411
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_EMAILTEMPLATEMANAGMENTTAG] [_WA_Sys_00000003_59463169]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 203, ModificationCounter: 411
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_EMAILTEMPLATEMANAGMENTTAG] [_WA_Sys_00000004_59463169]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 203, ModificationCounter: 411
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_EMAILTEMPLATEMANAGMENTTAG] [_WA_Sys_00000005_59463169]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 203, ModificationCounter: 411
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_EMAILTEMPLATEMANAGMENTTAG] [_WA_Sys_00000006_59463169]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 203, ModificationCounter: 411
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_EMAILTEMPLATEMANAGMENTTAG] [_WA_Sys_00000007_59463169]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 203, ModificationCounter: 411
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_EVENTS] [_WA_Sys_00000033_62CF9BA3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 772, ModificationCounter: 705
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool] [_WA_Sys_00000005_2C131A53]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 644271, ModificationCounter: 215435
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool] [_WA_Sys_00000008_2C131A53]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 644271, ModificationCounter: 219352
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool] [_WA_Sys_0000000A_2C131A53]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 636430, ModificationCounter: 1114884
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool] [_WA_Sys_0000000C_2C131A53]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 644271, ModificationCounter: 219352
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool] [_WA_Sys_0000000E_2C131A53]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 644271, ModificationCounter: 219352
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool] [_WA_Sys_0000000F_2C131A53]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 644271, ModificationCounter: 219352
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool] [_WA_Sys_00000010_2C131A53]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 644271, ModificationCounter: 219352
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool] [_WA_Sys_00000011_2C131A53]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 644271, ModificationCounter: 219352
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool] [_WA_Sys_0000001F_2C131A53]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 644271, ModificationCounter: 219352
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool] [_WA_Sys_00000020_2C131A53]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 644271, ModificationCounter: 219352
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool] [_WA_Sys_00000021_2C131A53]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 644271, ModificationCounter: 219352
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool] [_WA_Sys_00000022_2C131A53]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 644271, ModificationCounter: 219352
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:44
	
Date and time: 2021-04-15 13:54:44
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool] [_WA_Sys_00000033_2C131A53]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 644271, ModificationCounter: 219352
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool] [_WA_Sys_00000037_2C131A53]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 640345, ModificationCounter: 786646
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_Master] [_WA_Sys_00000004_2D073E8C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3907, ModificationCounter: 1114900
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_Master] [_WA_Sys_00000005_2D073E8C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3907, ModificationCounter: 1114900
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_Master] [_WA_Sys_00000006_2D073E8C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3907, ModificationCounter: 1114900
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_Master] [_WA_Sys_00000007_2D073E8C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3923, ModificationCounter: 219352
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_Master] [_WA_Sys_00000011_2D073E8C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3907, ModificationCounter: 1115185
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_Master] [_WA_Sys_00000012_2D073E8C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3907, ModificationCounter: 1115185
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_Master] [_WA_Sys_00000013_2D073E8C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3907, ModificationCounter: 1115185
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_Master] [_WA_Sys_00000014_2D073E8C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3907, ModificationCounter: 1115185
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_Master] [_WA_Sys_00000017_2D073E8C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3907, ModificationCounter: 1114900
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_0000000E_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 15604, ModificationCounter: 2587046
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_00000014_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 15604, ModificationCounter: 1736262
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_00000015_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 15604, ModificationCounter: 1736262
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_00000016_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 15604, ModificationCounter: 1736262
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_00000017_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 15604, ModificationCounter: 1736262
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_00000018_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 15604, ModificationCounter: 1736262
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_00000019_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 15604, ModificationCounter: 1736262
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_0000001A_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 15604, ModificationCounter: 1736262
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_0000001B_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 15604, ModificationCounter: 1736262
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_00000025_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 317177, ModificationCounter: 191933
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_00000027_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 317177, ModificationCounter: 191933
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_00000029_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 317177, ModificationCounter: 191933
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_0000002B_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 317177, ModificationCounter: 191933
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_0000002C_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 15604, ModificationCounter: 3101180
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_00000034_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 15604, ModificationCounter: 1828658
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:45
	
Date and time: 2021-04-15 13:54:45
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Executive_Momentum_Pool_temp] [_WA_Sys_00000039_71923E5A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 15604, ModificationCounter: 1736262
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_FANFARE_DATA] [_WA_Sys_00000005_2751F1F7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1707, ModificationCounter: 13661
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_FANFARE_DATA] [_WA_Sys_00000007_2751F1F7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1707, ModificationCounter: 13661
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_FANFARE_DATA] [_WA_Sys_00000009_2751F1F7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1707, ModificationCounter: 13661
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_FANFARE_DATA] [_WA_Sys_0000000B_2751F1F7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1707, ModificationCounter: 13661
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_FANFARE_DATA] [_WA_Sys_0000000D_2751F1F7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1707, ModificationCounter: 13661
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool] [missing_index_13173_13172]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 10753, ModificationCounter: 1680
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool] [missing_index_13261_13260]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 10753, ModificationCounter: 1680
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool] [_WA_Sys_00000002_30D7CF70]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10667, ModificationCounter: 20278
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool] [_WA_Sys_00000006_30D7CF70]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10667, ModificationCounter: 20278
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool] [_WA_Sys_00000008_30D7CF70]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10667, ModificationCounter: 20278
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool] [_WA_Sys_0000000F_30D7CF70]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10739, ModificationCounter: 6104
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool] [_WA_Sys_00000012_30D7CF70]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10667, ModificationCounter: 20278
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool] [_WA_Sys_00000016_30D7CF70]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10667, ModificationCounter: 20278
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool] [_WA_Sys_00000017_30D7CF70]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10667, ModificationCounter: 20278
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool] [_WA_Sys_00000019_30D7CF70]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10667, ModificationCounter: 20278
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool] [_WA_Sys_0000001D_30D7CF70]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10667, ModificationCounter: 20278
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Downline] [ix_CN_tbl_Leadership_Development_Pool_Downline_Comp_4_13_2021]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 172774731, ModificationCounter: 1175622
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:46
	
Date and time: 2021-04-15 13:54:46
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Downline] [nci_wi_tbl_Leadership_Development_Pool_Downline_F82B02917E09CF59481A7FD13D26A933]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 172774731, ModificationCounter: 1175622
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:47
	
Date and time: 2021-04-15 13:54:47
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Downline] [_WA_Sys_00000001_33B43C1B]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 172774721, ModificationCounter: 45153094
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:48
	
Date and time: 2021-04-15 13:54:48
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Downline] [_WA_Sys_00000003_33B43C1B]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 172774721, ModificationCounter: 45153094
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:48
	
Date and time: 2021-04-15 13:54:48
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Downline] [_WA_Sys_00000006_33B43C1B]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 171378347, ModificationCounter: 330208486
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:48
	
Date and time: 2021-04-15 13:54:48
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Downline] [_WA_Sys_00000008_33B43C1B]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 171378347, ModificationCounter: 330208486
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:49
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] [_WA_Sys_00000005_394DE537]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 584963, ModificationCounter: 333697766
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:49
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds] [missing_index_13259_13258]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 23036, ModificationCounter: 8818
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:49
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds] [_WA_Sys_00000002_34A86054]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 22865, ModificationCounter: 43311
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:49
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds] [_WA_Sys_00000003_34A86054]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 22865, ModificationCounter: 43311
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:49
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds] [_WA_Sys_00000006_34A86054]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 22865, ModificationCounter: 43311
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:49
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds] [_WA_Sys_00000007_34A86054]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 22865, ModificationCounter: 43311
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:49
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds] [_WA_Sys_00000008_34A86054]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 22865, ModificationCounter: 43311
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:49
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds_Temp] [_WA_Sys_00000001_30B89F36]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 8276, ModificationCounter: 1192
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:49
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds_Temp] [_WA_Sys_00000002_30B89F36]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 8276, ModificationCounter: 1192
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:49
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds_Temp] [_WA_Sys_00000003_30B89F36]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 380, ModificationCounter: 31770
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:49
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds_Temp] [_WA_Sys_00000004_30B89F36]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 5128, ModificationCounter: 4340
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:49
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds_Temp] [_WA_Sys_00000005_30B89F36]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 8276, ModificationCounter: 1192
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:49
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds_Temp] [_WA_Sys_00000008_30B89F36]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 380, ModificationCounter: 31770
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:49
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds_Temp] [_WA_Sys_00000009_30B89F36]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 380, ModificationCounter: 31770
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:49
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds_Temp] [_WA_Sys_0000000A_30B89F36]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 8276, ModificationCounter: 1192
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Golds_Temp] [_WA_Sys_00000012_30B89F36]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 380, ModificationCounter: 31770
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Rank_Achievements] [_WA_Sys_00000001_359C848D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6515, ModificationCounter: 25228
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Rank_Achievements] [_WA_Sys_00000002_359C848D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6515, ModificationCounter: 25228
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Rank_Achievements] [_WA_Sys_00000003_359C848D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6515, ModificationCounter: 25228
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Rank_Achievements] [_WA_Sys_00000007_359C848D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6569, ModificationCounter: 1764
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Rank_Achievements] [_WA_Sys_0000000D_359C848D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6569, ModificationCounter: 1764
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit] [_WA_Sys_00000002_7D03F106]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 178773, ModificationCounter: 142584
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit] [_WA_Sys_00000003_7D03F106]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 176255, ModificationCounter: 778770
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit] [_WA_Sys_00000004_7D03F106]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 176255, ModificationCounter: 778770
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit] [_WA_Sys_00000009_7D03F106]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 176255, ModificationCounter: 778770
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit_Temp] [_WA_Sys_00000002_36A682B6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 52183, ModificationCounter: 39090
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit_Temp] [_WA_Sys_00000003_36A682B6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 52183, ModificationCounter: 39090
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit_Temp] [_WA_Sys_00000004_36A682B6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 52183, ModificationCounter: 39090
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit_Temp] [_WA_Sys_00000005_36A682B6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4184, ModificationCounter: 327183
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit_Temp] [_WA_Sys_00000006_36A682B6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4184, ModificationCounter: 327183
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit_Temp] [_WA_Sys_00000007_36A682B6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4184, ModificationCounter: 327183
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit_Temp] [_WA_Sys_00000008_36A682B6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4184, ModificationCounter: 327183
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit_Temp] [_WA_Sys_00000009_36A682B6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4184, ModificationCounter: 327183
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Audit_Temp] [_WA_Sys_0000000B_36A682B6]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 4184, ModificationCounter: 327183
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Details] [_WA_Sys_00000002_7C0FCCCD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10428, ModificationCounter: 8947
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Details] [_WA_Sys_00000003_7C0FCCCD]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10342, ModificationCounter: 44633
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Details_Temp] [IX_Leadership_Development_Pool_Ranks_Details_Temp_CommPeriodId_I]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 208, ModificationCounter: 17476
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Details_Temp] [_WA_Sys_00000002_35B25E7D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3933, ModificationCounter: 1069
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Details_Temp] [_WA_Sys_00000003_35B25E7D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3933, ModificationCounter: 1069
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Details_Temp] [_WA_Sys_00000004_35B25E7D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3933, ModificationCounter: 1069
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Leadership_Development_Pool_Ranks_Details_Temp] [_WA_Sys_00000005_35B25E7D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 208, ModificationCounter: 17476
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:50
	
Date and time: 2021-04-15 13:54:50
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOG_DISTRIBUTOR_V2] [_WA_Sys_00000002_7B0F24EE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7436455, ModificationCounter: 437332
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:51
	
Date and time: 2021-04-15 13:54:51
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOG_DISTRIBUTOR_V2] [_WA_Sys_00000003_7B0F24EE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7392917, ModificationCounter: 480877
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:52
	
Date and time: 2021-04-15 13:54:52
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOG_DISTRIBUTOR_V2] [_WA_Sys_00000004_7B0F24EE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7432936, ModificationCounter: 440857
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:52
	
Date and time: 2021-04-15 13:54:52
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOG_DISTRIBUTOR_V2] [_WA_Sys_00000005_7B0F24EE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7436455, ModificationCounter: 437332
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:52
	
Date and time: 2021-04-15 13:54:52
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOG_DISTRIBUTOR_V2] [_WA_Sys_00000009_7B0F24EE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7436455, ModificationCounter: 437332
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:53
	
Date and time: 2021-04-15 13:54:53
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOG_WEBSERVICE] [PK_TBL_LOG_WEBSERVICE]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 1879063, ModificationCounter: 48260
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:53
	
Date and time: 2021-04-15 13:54:53
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOG_WEBSERVICE] [_WA_Sys_00000002_7F6BDA51]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1879063, ModificationCounter: 48260
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:53
	
Date and time: 2021-04-15 13:54:53
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOG_WEBSERVICE] [_WA_Sys_00000003_7F6BDA51]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1879063, ModificationCounter: 48260
Outcome: Succeeded
Duration: 00:00:02
Date and time: 2021-04-15 13:54:55
	
Date and time: 2021-04-15 13:54:55
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOG_WEBSERVICE] [_WA_Sys_00000004_7F6BDA51]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1879063, ModificationCounter: 48260
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:55
	
Date and time: 2021-04-15 13:54:55
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOG_WEBSERVICE] [_WA_Sys_00000005_7F6BDA51]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1879063, ModificationCounter: 48260
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:56
	
Date and time: 2021-04-15 13:54:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOG_WEBSERVICE] [_WA_Sys_00000006_7F6BDA51]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1879063, ModificationCounter: 48260
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:56
	
Date and time: 2021-04-15 13:54:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOGS] [PK_TBL_LOGS]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 263, ModificationCounter: 41133
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:56
	
Date and time: 2021-04-15 13:54:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOGS] [_WA_Sys_00000002_015422C3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 64, ModificationCounter: 248886
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:56
	
Date and time: 2021-04-15 13:54:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOGS] [_WA_Sys_00000003_015422C3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 64, ModificationCounter: 248886
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:56
	
Date and time: 2021-04-15 13:54:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOGS] [_WA_Sys_00000004_015422C3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 64, ModificationCounter: 248886
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:56
	
Date and time: 2021-04-15 13:54:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOGS] [_WA_Sys_00000005_015422C3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 64, ModificationCounter: 248886
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:56
	
Date and time: 2021-04-15 13:54:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOGS] [_WA_Sys_00000006_015422C3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 64, ModificationCounter: 248886
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:56
	
Date and time: 2021-04-15 13:54:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_LOGS] [_WA_Sys_00000007_015422C3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 64, ModificationCounter: 248886
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:56
	
Date and time: 2021-04-15 13:54:56
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Loyalty_Rewards_Program_Autoship_Detail] [_WA_Sys_00000004_325B58C7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3070244, ModificationCounter: 144724
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:57
	
Date and time: 2021-04-15 13:54:57
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Loyalty_Rewards_Program_Autoship_Detail_Temp] [_WA_Sys_00000006_4385E4C9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1194530, ModificationCounter: 295864
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:57
	
Date and time: 2021-04-15 13:54:57
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Loyalty_Rewards_Program_Autoship_Detail_Temp] [_WA_Sys_00000009_4385E4C9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1194530, ModificationCounter: 295864
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:57
	
Date and time: 2021-04-15 13:54:57
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Loyalty_Rewards_Program_Autoship_Detail_Temp] [_WA_Sys_0000000A_4385E4C9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1194530, ModificationCounter: 295864
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:57
	
Date and time: 2021-04-15 13:54:57
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Loyalty_Rewards_Program_Exceptions] [_WA_Sys_00000003_5F2DFF3E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 17968, ModificationCounter: 1831
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:57
	
Date and time: 2021-04-15 13:54:57
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Loyalty_Rewards_Program_Main] [_WA_Sys_00000009_4FEBBBAE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 339932, ModificationCounter: 338476
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:57
	
Date and time: 2021-04-15 13:54:57
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Loyalty_Rewards_Program_Main] [_WA_Sys_0000000A_4FEBBBAE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 337261, ModificationCounter: 343554
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:57
	
Date and time: 2021-04-15 13:54:57
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Loyalty_Rewards_Program_Main] [_WA_Sys_0000000C_4FEBBBAE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 337261, ModificationCounter: 343554
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:57
	
Date and time: 2021-04-15 13:54:57
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Loyalty_Rewards_Program_Main] [_WA_Sys_00000011_4FEBBBAE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 339932, ModificationCounter: 338472
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:57
	
Date and time: 2021-04-15 13:54:57
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Loyalty_Rewards_Program_Main] [_WA_Sys_00000014_4FEBBBAE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 339932, ModificationCounter: 338474
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:57
	
Date and time: 2021-04-15 13:54:57
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Loyalty_Rewards_Program_Main] [_WA_Sys_00000015_4FEBBBAE]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 339932, ModificationCounter: 338476
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:57
	
Date and time: 2021-04-15 13:54:57
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Loyalty_Rewards_Program_Main_temp] [_WA_Sys_00000002_70588B40]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3711066, ModificationCounter: 1079890
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:57
	
Date and time: 2021-04-15 13:54:57
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Loyalty_Rewards_Program_Main_temp] [_WA_Sys_00000005_70588B40]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3775816, ModificationCounter: 1015140
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:57
	
Date and time: 2021-04-15 13:54:57
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Loyalty_Rewards_Program_Main_temp] [_WA_Sys_00000019_70588B40]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3711066, ModificationCounter: 1079890
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MARKETS] [idx_tbl_markets_1]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 72, ModificationCounter: 144
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MARKETS] [Ix_Nn_Tbl_Markets_Status_ountrycodetwochars]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 72, ModificationCounter: 144
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [PK_TBL_MERCHANT]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000002_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000003_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000004_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000005_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000006_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000007_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000008_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000009_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_0000000A_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_0000000F_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000010_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000011_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000012_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000013_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000014_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000015_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000016_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000017_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000018_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000019_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_0000001A_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_0000001B_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_0000001C_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_0000001D_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_0000001E_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_0000001F_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000020_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000021_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000024_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000027_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_0000002A_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_0000002B_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_0000002C_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_0000002D_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000030_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MERCHANT] [_WA_Sys_00000033_15C1847C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 90, ModificationCounter: 190
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [PK__Tbl_Merc__3214EC0790F7AE2D]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_00000002_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_00000004_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_00000005_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_0000000C_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_0000000D_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_0000000E_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_0000000F_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_00000010_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_00000011_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_00000012_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_00000013_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_00000014_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_00000015_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_00000016_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_00000017_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_00000018_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Merchant_Currency_Detail] [_WA_Sys_00000019_4D9523AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 62, ModificationCounter: 124
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MILLIONDOLLARCLUB] [_WA_Sys_00000001_70186254]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 40, ModificationCounter: 82
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MILLIONDOLLARCLUB] [_WA_Sys_00000002_70186254]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 40, ModificationCounter: 82
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MILLIONDOLLARCLUB] [_WA_Sys_00000009_70186254]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 40, ModificationCounter: 82
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_MILLIONDOLLARCLUB_PREVIEW] [_WA_Sys_0000000D_79A1CC8E]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 40, ModificationCounter: 44
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_NFR_AutoshipOrders_Recalculate_Differences_Notes] [_WA_Sys_00000001_6B82C89B]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 20, ModificationCounter: 396
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:58
	
Date and time: 2021-04-15 13:54:58
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Detail] [Ix_Nn_tbl_Orders_Detail_Id_Include]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 10014543, ModificationCounter: 163780
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:54:59
	
Date and time: 2021-04-15 13:54:59
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Detail] [_WA_Sys_00000022_00C66796]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10042052, ModificationCounter: 114231
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:54:59
	
Date and time: 2021-04-15 13:54:59
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header] [_WA_Sys_0000003E_337E1F7B]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7006082, ModificationCounter: 6588616
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:00
	
Date and time: 2021-04-15 13:55:00
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_summary_v2] [PK__tbl_Orde__3214EC279A8E8B9C]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 306112291, ModificationCounter: 567269
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:00
	
Date and time: 2021-04-15 13:55:00
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_summary_v2] [idx_tbl_Orders_Header_Commissions_summary_v2_rundate_sequence]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 303638348, ModificationCounter: 3041212
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:01
	
Date and time: 2021-04-15 13:55:01
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_summary_v2] [_WA_Sys_00000002_21AB65D0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 302179079, ModificationCounter: 4500481
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:02
	
Date and time: 2021-04-15 13:55:02
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_summary_v2] [_WA_Sys_00000003_21AB65D0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 303638348, ModificationCounter: 3041212
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:02
	
Date and time: 2021-04-15 13:55:02
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_summary_v2] [_WA_Sys_00000004_21AB65D0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 303638348, ModificationCounter: 3041212
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:03
	
Date and time: 2021-04-15 13:55:03
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_summary_v2] [_WA_Sys_00000007_21AB65D0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 302179079, ModificationCounter: 4500481
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:04
	
Date and time: 2021-04-15 13:55:04
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_summary_v2] [_WA_Sys_00000013_21AB65D0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 303689079, ModificationCounter: 2990481
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:05
	
Date and time: 2021-04-15 13:55:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_summary_v2] [_WA_Sys_00000030_21AB65D0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 303689079, ModificationCounter: 2990481
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:05
	
Date and time: 2021-04-15 13:55:05
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_summary_v2] [_WA_Sys_00000039_21AB65D0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 303689079, ModificationCounter: 2990481
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:06
	
Date and time: 2021-04-15 13:55:06
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_summary_v2] [_WA_Sys_00000046_21AB65D0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 302179079, ModificationCounter: 4500481
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:07
	
Date and time: 2021-04-15 13:55:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_summary_v2] [_WA_Sys_00000054_21AB65D0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 302179079, ModificationCounter: 4500481
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:07
	
Date and time: 2021-04-15 13:55:07
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_summary_v2] [_WA_Sys_0000005A_21AB65D0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 302179079, ModificationCounter: 4500481
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:08
	
Date and time: 2021-04-15 13:55:08
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_summary_v2] [_WA_Sys_0000005D_21AB65D0]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 302179079, ModificationCounter: 4500481
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_Temp_v2] [_WA_Sys_00000002_609CBC82]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 20649, ModificationCounter: 8738358
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_Temp_v2] [_WA_Sys_00000003_609CBC82]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 20649, ModificationCounter: 8738358
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_Temp_v2] [_WA_Sys_00000005_609CBC82]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 20649, ModificationCounter: 8738358
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_Temp_v2] [_WA_Sys_00000014_609CBC82]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 20649, ModificationCounter: 8738358
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_Temp_v2] [_WA_Sys_00000024_609CBC82]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 20649, ModificationCounter: 8738358
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_Temp_v2] [_WA_Sys_00000039_609CBC82]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10187, ModificationCounter: 5899066
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_Temp_v2] [_WA_Sys_00000046_609CBC82]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 20649, ModificationCounter: 8738358
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_Temp_v2] [_WA_Sys_00000049_609CBC82]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 20649, ModificationCounter: 8738358
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_Temp_v2] [_WA_Sys_0000004B_609CBC82]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 20649, ModificationCounter: 8738358
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Commissions_Temp_v2] [_WA_Sys_00000057_609CBC82]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 20649, ModificationCounter: 8738358
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Deleted] [_WA_Sys_0000003F_4161704D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 9039, ModificationCounter: 8966
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Snapshot] [_WA_Sys_0000001A_57135248]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3075834, ModificationCounter: 63904
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Snapshot] [_WA_Sys_0000001B_57135248]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3075834, ModificationCounter: 63904
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Snapshot] [_WA_Sys_0000001C_57135248]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3075834, ModificationCounter: 63904
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Snapshot] [_WA_Sys_0000001D_57135248]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3075834, ModificationCounter: 63904
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:09
	
Date and time: 2021-04-15 13:55:09
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Snapshot] [_WA_Sys_0000001E_57135248]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3075834, ModificationCounter: 63904
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:10
	
Date and time: 2021-04-15 13:55:10
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Snapshot] [_WA_Sys_0000001F_57135248]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3075834, ModificationCounter: 63904
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:10
	
Date and time: 2021-04-15 13:55:10
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Snapshot] [_WA_Sys_00000020_57135248]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3075834, ModificationCounter: 63904
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:10
	
Date and time: 2021-04-15 13:55:10
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Snapshot] [_WA_Sys_00000021_57135248]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3075834, ModificationCounter: 63904
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:10
	
Date and time: 2021-04-15 13:55:10
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Snapshot] [_WA_Sys_00000022_57135248]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3075834, ModificationCounter: 63904
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:10
	
Date and time: 2021-04-15 13:55:10
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Snapshot] [_WA_Sys_00000023_57135248]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3075834, ModificationCounter: 63904
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:10
	
Date and time: 2021-04-15 13:55:10
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Snapshot] [_WA_Sys_00000024_57135248]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3075834, ModificationCounter: 63904
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:10
	
Date and time: 2021-04-15 13:55:10
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Snapshot] [_WA_Sys_00000025_57135248]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3075834, ModificationCounter: 63904
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:10
	
Date and time: 2021-04-15 13:55:10
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Snapshot] [_WA_Sys_00000026_57135248]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3075834, ModificationCounter: 63904
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:10
	
Date and time: 2021-04-15 13:55:10
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Orders_Header_Snapshot] [_WA_Sys_00000027_57135248]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3075834, ModificationCounter: 63904
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:11
	
Date and time: 2021-04-15 13:55:11
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_OrderTracking] [IDX_OrderTracking_OrderNumber]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 4768136, ModificationCounter: 71189
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:11
	
Date and time: 2021-04-15 13:55:11
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_PHOENIX_LOG_IPADDRESS] [_WA_Sys_00000002_50418462]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 14807767, ModificationCounter: 124724
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Productchilditems] [_WA_Sys_00000001_3B95D149]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10860, ModificationCounter: 1508
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Productchilditems] [_WA_Sys_00000009_3B95D149]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10772, ModificationCounter: 1948
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Productchilditems] [_WA_Sys_0000000C_3B95D149]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10860, ModificationCounter: 1508
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Productchilditems] [_WA_Sys_0000000D_3B95D149]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10860, ModificationCounter: 1508
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Productchilditems] [_WA_Sys_00000012_3B95D149]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 10860, ModificationCounter: 1508
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_PRODUCTS] [missing_index_269_268]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 2871, ModificationCounter: 294
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_PRODUCTS] [_WA_Sys_0000000B_711A0FB2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2871, ModificationCounter: 321
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_PRODUCTS] [_WA_Sys_00000015_711A0FB2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2872, ModificationCounter: 38725
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_PRODUCTS] [_WA_Sys_00000045_711A0FB2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2871, ModificationCounter: 293
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_PRODUCTS] [_WA_Sys_0000007F_711A0FB2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2614, ModificationCounter: 262
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_PRODUCTS] [_WA_Sys_00000087_711A0FB2]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2871, ModificationCounter: 321
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_PRODUCTS_MARKETS] [missing_index_10_9]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 10068, ModificationCounter: 1057
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_PRODUCTS_MARKETS] [missing_index_104_103]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 10068, ModificationCounter: 1057
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_promotion_fastforward_main] [IDX_tbl_promotion_fastforward_main_Period]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 67671, ModificationCounter: 7159
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_promotion_fastforward_Qualified] [IDX_TBL_promotion_fastforward_Qualified_SponsorID]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 142062, ModificationCounter: 12138
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_promotion_fastforward_Qualified] [_WA_Sys_00000001_3F25EEC7]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 143282, ModificationCounter: 43891
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_PROMOTIONS] [_WA_Sys_0000000F_07B689A3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 338, ModificationCounter: 219
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_PROMOTIONS] [_WA_Sys_00000010_07B689A3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 338, ModificationCounter: 1373
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_PROMOTIONS_LANGUAGE] [_WA_Sys_00000003_06C2656A]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 2266, ModificationCounter: 238
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_RANKADVANCEMENTS_DATA] [_WA_Sys_00000002_3B58EAA4]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1597, ModificationCounter: 9582
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_RECOGNITION_CLASS] [PK__TBL_RECO__3214EC27E8C6B83B]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 9, ModificationCounter: 1
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_RECOGNITION_CLASS] [_WA_Sys_00000002_2FAD0A5F]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 9, ModificationCounter: 1
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_RECOGNITION_CLASS] [_WA_Sys_00000006_2FAD0A5F]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 9, ModificationCounter: 1
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Recognition_TopAutoships_preview] [_WA_Sys_00000002_04FCD9F3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 600, ModificationCounter: 4800
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Recognition_TopAutoships_preview] [_WA_Sys_00000003_04FCD9F3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 600, ModificationCounter: 4800
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Recognition_TopAutoships_preview] [_WA_Sys_00000004_04FCD9F3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 600, ModificationCounter: 4800
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:12
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Recognition_TopAutoships_preview] [_WA_Sys_00000005_04FCD9F3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 600, ModificationCounter: 4800
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:12
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Recognition_TopAutoships_preview] [_WA_Sys_00000008_04FCD9F3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 600, ModificationCounter: 4800
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Recognition_TopAutoships_preview] [_WA_Sys_0000000A_04FCD9F3]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 600, ModificationCounter: 4800
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Recognition_TopEmergingLeaders_preview] [_WA_Sys_00000007_1162B0D8]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 382, ModificationCounter: 3011
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Recognition_TopEnrollers_preview] [_WA_Sys_00000001_162765F5]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 600, ModificationCounter: 4800
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Recognition_TopEnrollers_preview] [_WA_Sys_0000000A_162765F5]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 600, ModificationCounter: 4800
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_refund_rates] [_WA_Sys_00000005_56288459]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 150, ModificationCounter: 289
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_REPORTS_FIELDS_DETAILS] [PK__TBL_REPO__3214EC276D45ECB9]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 69852, ModificationCounter: 142082
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_REPORTS_FIELDS_DETAILS] [IX_NN_Tbl_Reports_Fields_Detailt_DistributorIdStatusIdTemplateReportId]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 75111, ModificationCounter: 137860
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_REPORTS_FIELDS_DETAILS] [_WA_Sys_00000002_6EB5D1AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 76646, ModificationCounter: 135578
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_REPORTS_FIELDS_DETAILS] [_WA_Sys_00000003_6EB5D1AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 73051, ModificationCounter: 141692
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_REPORTS_FIELDS_DETAILS] [_WA_Sys_00000004_6EB5D1AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 73051, ModificationCounter: 141692
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_REPORTS_FIELDS_DETAILS] [_WA_Sys_00000006_6EB5D1AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 70676, ModificationCounter: 142285
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_REPORTS_FIELDS_DETAILS] [_WA_Sys_0000000C_6EB5D1AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 75505, ModificationCounter: 136429
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_REPORTS_FIELDS_DETAILS] [_WA_Sys_0000000D_6EB5D1AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 76646, ModificationCounter: 135578
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Tbl_Roles_NavSettings] [PK__Tbl_Role__3214EC07C3B6634B]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 244, ModificationCounter: 565
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_SHIPPINGCHARGESXPRODUCTS] [PK_TBL_SHIPPINGCHARGESXPRODUCTS]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 2901, ModificationCounter: 379
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_SHIPPINGRATES] [PK__TBL_SHIP__3214EC27072A992D]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 3682, ModificationCounter: 7495
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_SHIPPINGRATES] [_WA_Sys_00000006_3D7C06C9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3732, ModificationCounter: 7445
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_SHIPPINGRATES] [_WA_Sys_00000007_3D7C06C9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 3732, ModificationCounter: 7445
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_SHIPPINGRATES_NEW] [PK__TBL_SHIP__3214EC27CF2FEA5F]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 6060, ModificationCounter: 12120
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_SHIPPINGRATES_NEW] [_WA_Sys_00000004_33BD9265]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6060, ModificationCounter: 12120
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_SHIPPINGRATES_NEW] [_WA_Sys_00000005_33BD9265]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6060, ModificationCounter: 12120
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[TBL_SHIPPINGRATES_NEW] [_WA_Sys_00000013_33BD9265]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6060, ModificationCounter: 12120
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [PK_tbl_Warehouses]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 52, ModificationCounter: 119
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [Ix_Nn_Tbl_Warehouses_Warehouseid]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000002_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000003_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000008_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000009_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000010_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000012_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000013_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000015_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000016_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 180
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000017_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 180
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000018_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 180
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000019_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_0000001A_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_0000001B_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_0000001C_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_0000001D_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_0000001E_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:13
	
Date and time: 2021-04-15 13:55:13
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000020_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:14
	
Date and time: 2021-04-15 13:55:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000022_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:14
	
Date and time: 2021-04-15 13:55:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000023_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:14
	
Date and time: 2021-04-15 13:55:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000024_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 180
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:14
	
Date and time: 2021-04-15 13:55:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000025_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 118
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:14
	
Date and time: 2021-04-15 13:55:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000026_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:14
	
Date and time: 2021-04-15 13:55:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000027_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:14
	
Date and time: 2021-04-15 13:55:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_00000029_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:14
	
Date and time: 2021-04-15 13:55:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_0000002A_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:14
	
Date and time: 2021-04-15 13:55:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_0000002C_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:14
	
Date and time: 2021-04-15 13:55:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[tbl_Warehouses] [_WA_Sys_0000002D_286A449C]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 54, ModificationCounter: 117
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:14
	
Date and time: 2021-04-15 13:55:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Key_Module] [PK__Translat__3214EC27D71720D5]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 24399, ModificationCounter: 49359
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:14
	
Date and time: 2021-04-15 13:55:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Key_Module] [_WA_Sys_00000002_1A17FE8D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 22870, ModificationCounter: 51030
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:14
	
Date and time: 2021-04-15 13:55:14
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Key_Value_Log] [_WA_Sys_00000002_632D329D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 147161800, ModificationCounter: 467711
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:15
	
Date and time: 2021-04-15 13:55:15
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Key_Value_Log] [_WA_Sys_00000003_632D329D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 147161800, ModificationCounter: 467711
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:15
	
Date and time: 2021-04-15 13:55:15
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Key_Value_Log] [_WA_Sys_00000006_632D329D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 147161800, ModificationCounter: 467711
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Key_Value_Log] [_WA_Sys_00000008_632D329D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 147161800, ModificationCounter: 467711
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Server] [_WA_Sys_00000001_1276DCC5]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7, ModificationCounter: 10
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Server] [_WA_Sys_00000002_1276DCC5]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7, ModificationCounter: 10
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Server] [_WA_Sys_00000003_1276DCC5]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7, ModificationCounter: 10
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Server] [_WA_Sys_00000004_1276DCC5]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7, ModificationCounter: 236
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Server] [_WA_Sys_00000005_1276DCC5]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7, ModificationCounter: 10
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Server] [_WA_Sys_00000009_1276DCC5]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7, ModificationCounter: 367
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Term] [PK__Translat__410A21A5AA52B1BA]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 36, ModificationCounter: 72
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Term] [_WA_Sys_00000002_2589B139]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 36, ModificationCounter: 72
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Term] [_WA_Sys_00000003_2589B139]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 36, ModificationCounter: 72
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Term] [_WA_Sys_00000004_2589B139]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 36, ModificationCounter: 72
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Term] [_WA_Sys_00000009_2589B139]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 36, ModificationCounter: 72
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Term] [_WA_Sys_0000000B_2589B139]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 36, ModificationCounter: 72
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Term_Categories] [PK__Translat__19093A0B0A39989C]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 7, ModificationCounter: 14
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Term_Categories] [_WA_Sys_00000003_2771F9AB]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7, ModificationCounter: 14
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:16
	
Date and time: 2021-04-15 13:55:16
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Term_Detail] [_WA_Sys_00000003_295A421D]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 13258, ModificationCounter: 24280
Outcome: Succeeded
Duration: 00:00:01
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Term_Detail_Language] [_WA_Sys_00000003_2B428A8F]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 13091, ModificationCounter: 23955
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[Translation_Value] [IX_Translation_Value_TranslationKeyID]
Comment: ObjectType: Table, IndexType: Index, IndexType: NonClustered, Incremental: N, RowCount: 615163, ModificationCounter: 1297220
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[UserControlProcess] [_WA_Sys_00000002_33076244]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 243, ModificationCounter: 38
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[UserControlProcess] [_WA_Sys_00000003_33076244]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 243, ModificationCounter: 38
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[UserControlProcess] [_WA_Sys_00000004_33076244]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 243, ModificationCounter: 76
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [dbo].[UserControlProcess] [_WA_Sys_00000005_33076244]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 243, ModificationCounter: 76
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Dst].[Distributor_SingleSignOn] [_WA_Sys_00000002_1F51AC98]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6466, ModificationCounter: 723
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Dst].[Distributor_SingleSignOn] [_WA_Sys_00000003_1F51AC98]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 7017, ModificationCounter: 1589
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Dst].[Distributor_SingleSignOn] [_WA_Sys_00000006_1F51AC98]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 6466, ModificationCounter: 723
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[NavPermissions] [PkNavPermissions_NavPermissionsId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 70, ModificationCounter: 142
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[NavPermissions] [_WA_Sys_00000003_4862AC05]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 70, ModificationCounter: 142
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[NavPermissions] [_WA_Sys_00000004_4862AC05]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 70, ModificationCounter: 142
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[NavPermissions] [_WA_Sys_00000007_4862AC05]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 70, ModificationCounter: 142
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[NavSettings_NavPermissions] [PkNavSettings_NavPermissions_NavSettingsNavPermissionsId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 54, ModificationCounter: 116
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[NavSettings_NavPermissions] [_WA_Sys_00000002_4A4AF477]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 56, ModificationCounter: 114
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[NavSettings_NavPermissions] [_WA_Sys_00000003_4A4AF477]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 56, ModificationCounter: 114
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[NavSettings_NavPermissions] [_WA_Sys_00000004_4A4AF477]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 56, ModificationCounter: 114
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[PermissionControls] [PkPermissionControls_PermissionControlId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 1, ModificationCounter: 2
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[PermissionControls] [_WA_Sys_00000005_4C333CE9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1, ModificationCounter: 2
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[PermissionControls] [_WA_Sys_00000006_4C333CE9]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1, ModificationCounter: 2
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[Roles] [PkRoles_RolesId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 72, ModificationCounter: 114
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[Roles] [_WA_Sys_00000002_4E1B855B]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 72, ModificationCounter: 114
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[Roles] [_WA_Sys_00000003_4E1B855B]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 72, ModificationCounter: 114
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[Roles_NavPermissions] [PkRoles_NavPermissions_RolesNavPermissionsId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 1777, ModificationCounter: 2957
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[Roles_TranslationLanguages] [PkRolesTranslationLanguages_Id]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 180, ModificationCounter: 412
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[Roles_TranslationLanguages] [_WA_Sys_00000002_4FFADB17]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 180, ModificationCounter: 412
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Gbl].[Roles_TranslationLanguages] [_WA_Sys_00000003_4FFADB17]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 180, ModificationCounter: 412
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Prd].[Products_Tax] [PkProductsTax_ProductsTaxId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 1377, ModificationCounter: 5512
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Prd].[Tax_Integration] [PkTaxIntegration_TaxIntegrationId]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 82, ModificationCounter: 144
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Prd].[Tax_Integration] [_WA_Sys_00000002_6DFA5084]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 82, ModificationCounter: 144
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Prd].[Tax_Integration] [_WA_Sys_00000003_6DFA5084]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 82, ModificationCounter: 144
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Prd].[Tax_Integration] [_WA_Sys_00000004_6DFA5084]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 82, ModificationCounter: 144
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Prd].[Tax_Integration] [_WA_Sys_00000010_6DFA5084]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 82, ModificationCounter: 144
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Sec].[PasswordHistory] [PK__Password__0A9DD31DDE358517]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 82, ModificationCounter: 9
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Sec].[PasswordHistory] [_WA_Sys_00000004_7AB85222]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 82, ModificationCounter: 9
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Sec].[PasswordHistory] [_WA_Sys_00000006_7AB85222]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 82, ModificationCounter: 9
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Sec].[PasswordToken] [PK__Password__7366387BEA93F9E4]
Comment: ObjectType: Table, IndexType: Index, IndexType: Clustered, Incremental: N, RowCount: 18493, ModificationCounter: 2084
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Sec].[PasswordToken] [_WA_Sys_00000003_703AC3AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 18493, ModificationCounter: 2084
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Sec].[PasswordToken] [_WA_Sys_00000007_703AC3AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 18493, ModificationCounter: 2084
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Sec].[PasswordToken] [_WA_Sys_00000008_703AC3AF]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 18493, ModificationCounter: 2084
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Trf].[Transfers] [_WA_Sys_00000002_33491551]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1, ModificationCounter: 1
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Trf].[Transfers] [_WA_Sys_00000003_33491551]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1, ModificationCounter: 1
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Trf].[Transfers] [_WA_Sys_00000005_33491551]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1, ModificationCounter: 1
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Trf].[Transfers] [_WA_Sys_00000008_33491551]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1, ModificationCounter: 1
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Trf].[Transfers] [_WA_Sys_0000000D_33491551]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1, ModificationCounter: 3
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
Database context: [Asea_Stage]
Command: UPDATE STATISTICS [Trf].[Transfers] [_WA_Sys_00000012_33491551]
Comment: ObjectType: Table, IndexType: Column, Incremental: N, RowCount: 1, ModificationCounter: 1
Outcome: Succeeded
Duration: 00:00:00
Date and time: 2021-04-15 13:55:17
	
Date and time: 2021-04-15 13:55:17
	

Completion time: 2021-04-15T10:55:17.1102493-03:00
