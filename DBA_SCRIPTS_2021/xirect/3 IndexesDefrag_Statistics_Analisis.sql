EXECUTE [dba].[IndexOptimize]
						 @Databases = 'BodyLogic_Live', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE'
						 ,@FragmentationHigh = 'INDEX_REORGANIZE', @FragmentationLevel1 = 10, @FragmentationLevel2 = 99
						 , @MaxDOP = 4				
						 --,@MaxNumberOfPages=200000
						 --,@MinNumberOfPages=10000
						 ,@Execute='y'
						 --,@LogToTable='y'
						 --Commissions_Distributor_Temp
						 --,@Indexes = 'BodyLogic_Live.dbo.Commissions_Distributor_Temp'


--Actualizacion estadisticas.
EXECUTE dba.IndexOptimize
@Databases = 'BodyLogic_Live',
@FragmentationLow = NULL,
@FragmentationMedium = NULL,
@FragmentationHigh = NULL,
@UpdateStatistics = 'ALL',
@OnlyModifiedStatistics = 'Y'



-- ghost rows
--SELECT OBJECT_NAME(object_id) AS table_name, forwarded_record_count, avg_fragmentation_in_percent, page_count 
FROM sys.dm_db_index_physical_stats (DB_ID(), DEFAULT, DEFAULT, DEFAULT, 'DETAILED') 
WHERE index_id=0 --AND page_count < 10000 
--4:49 minutos y no terminó. CPU 100%
GO



/*
Tables heaps:
Versions
tbl_Query_Fields
tbl_Query_Filters
Resource_Language
tbl_ref_UPSZonesUtah
tbl_ref_ZipCodes
AccountType_Settings
Bl_Commissions_Bonus_CheckMatchBonus
Bl_Commissions_Bonus_CheckMatchBonusDetail
Bl_Commissions_Bonus_GlobalLeadershipBonusDetail
Bl_Commissions_Bonus_CheckMatchBonus_Temp
Bl_Commissions_Bonus_GlobalLeadershipBonusSummary
Bl_Commissions_Bonus_CheckMatchBonusDetail_Temp
Bl_Commissions_Bonus_InfinityBonus
Bl_Commissions_Bonus_ConsolidationBonus
TBL_REQUESTS_PROCESSING
tbl_orders_header_bk
SalesPromotion
Bl_Commissions_Bonus_InfinityBonusDetail
Bl_Commissions_Bonus_LeadersGrowthUpBonus
Bl_Commissions_Bonus_ConsolidationBonus_Temp
Bl_Commissions_Bonus_PoolEnrollmentBonusDetail
Bl_Commissions_Bonus_PoolEnrollmentBonusSummary
Bl_Commissions_Bonus_FastStartBonus_Temp
EmailTemplate
EmailTemplate
Bl_Commissions_Bonus_QuadruplicatorBonus
Bl_Commissions_Bonus_QuadruplicatorBonusDetail
Bl_Commissions_Bonus_GlobalLeadershipBonusSummary_Temp
Bl_Commissions_Bonus_SemiMonthlyInfinityBonus
Bl_Commissions_Bonus_GrowthUpBonus
Bl_Commissions_Bonus_SemiMonthlyInfinityBonusDetail
Bl_Commissions_Bonus_GrowthUpBonus_Temp
Bl_Commissions_Bonus_SemiMonthlyTeamBonus
Bl_Commissions_Bonus_InfinityBonus_Temp
Bl_Commissions_Bonus_SemiMonthlyTeamBonusDetail
Bl_Commissions_Bonus_InfinityBonusDetail_Temp
Bl_Commissions_Bonus_TeamBonus
SalesPromotion_Distributor
*/


