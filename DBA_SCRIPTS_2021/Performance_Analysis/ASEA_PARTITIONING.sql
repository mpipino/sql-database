/*
USE [Asea_Stage]
GO
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
ON [dbo].[tbl_distributor_commissions_v2] ([CommPeriodId])
INCLUDE ([AccountType],[LegacyNumber],[FirstName],[LastName],[IsTaxExempt],[CurrencyCode],[EnrollerId],[JoinDate],[DistributorStatus],[PaidAsRank],[LifetimeRankId],[CREATEDDATE],[CREATEDBY],[MARKETID],[CountryCode],[BinarySponsorId],[JoinCommPeriodId],[TotalCV],[Custom1],[Custom2],[Custom3],[Custom4],[Custom5],[Custom7],[Custom8],[Custom6],[ActiveTotalPV],[Incoming_Left_Vol],[Incoming_Right_Vol],[ActiveUplineLevel1],[ActiveUplineLevel2],[ActiveUplineLevel3],[TotalPV],[StartRank],[EndRank],[Dir300_1_Count],[ActiveEnrollerId],[WEEKPGV],[WEEKGV],[Outgoing_Left_Vol],[Outgoing_Right_Vol],[PGV7],[PGV3],[BIWEEKGV],[TRIWEEKGV],[triweeksidegv],[biweeksidegv],[PGV50],[custom9],[custom10],[CustomerPE_Volume],[SponsorSequence],[realcustom1],[realcustom2],[RETAIL_COMMISSIONS],[PREF_CUST_BONUS],[FAST_START_BONUS],[FAST_START_GBR_IRL_BONUS],[FAST_START_ITALY_BONUS],[DIRECTOR_BONUS],[TEAM_COMMISSIONS],[CHECK_MATCH],[TOTAL_COMMISSIONS],[PEGRATE],[RETAIL_COMMISSIONS_VALUE],[PREF_CUST_BONUS_VALUE],[FAST_START_BONUS_VALUE],[FAST_START_GBR_IRL_BONUS_VALUE],[FAST_START_ITALY_BONUS_VALUE],[DIRECTOR_BONUS_VALUE],[TEAM_COMMISSIONS_VALUE],[CHECK_MATCH_VALUE],[TOTAL_COMMISSIONS_VALUE],[DiamPool_Bonus],[DiamPool_Bonus_value],[AccountAdjustment_bonus],[AccountAdjustment_bonus_value],[POOL_COMMISSIONS],[POOL_COMMISSIONS_Value],[Entrep_Bonus],[Entrep_Bonus_value],[EMP_bonus],[EMP_bonus_value],[Weak-2-weeks],[Weak-3-weeks],[Qual-until-date],[Rnk9-gv-2weeks],[Rnk10-gv-3weeks],[Rnk11-gv-3weeks],[rank9gv],[rank10gv],[rank11gv],[Rank8Gv],[Rank9Gv_1],[Rank10Gv_1],[Rank10Gv_2],[Rank11Gv_1],[Rank11Gv_2],[pgv],[gv],[TotalVolume],[Rank8Gv_1],[DirectorBonusPaid],[Pv7Gen],[forcedrank],[isforced],[PERIOD_LEFT_VOL],[PERIOD_RIGHT_VOL],[STATUS],[TotalDownlineLeft],[TotalDownlineRight],[newPersonalEnrollments],[newEnrollLeft],[newEnrollRight],[activeLeft],[activeRight],[autoshipLeft],[autoshipRight],[avg2WeekLeft],[avg2WeekRight],[avg3WeekLeft],[avg3WeekRight],[ovr_ActiveTotalPV],[pv6gen],[TeamCommissionCapped],[promo_bonus],[promo_bonus_value],[EnrollerOrgWeak50],[EnrollerOrgWeak100],[EnrollerOrgWeak150],[EnrollerOrgWeak200],[EnrollerOrgWeak250],[d700_count],[gold_count],[country_code],[achievedrankdate],[total_left_leg],[total_right_leg],[hold_bonus],[GROSS_COMMISSIONS],[GROSS_COMMISSIONS_VALUE],[dir300leg],[EnrollerOrgWeak],[EnrollerOrgWeak300],[UplineBronze],[UplineGold],[UplineDiamond],[TotalLeftVol_PersonalEnrollee],[TotalRightVol_PersonalEnrollee],[Pgv1],[Pgv2],[IsPvActive],[LesserBinaryVol],[LastLesserBinaryVol],[beforelastlesserbinaryvol],[PersonalPrefCustomers],[BinaryLeftPrefCustomers],[BinaryRightPrefCustomers],[TotalBinaryPrefCustomers],[EnrollmentPrefCustomers],[RightCount_EnrolledPreferredCustomers],[LeftCount_EnrolledPreferredCustomers],[RightCount_EnrolledRetailCustomers],[LeftCount_EnrolledRetailCustomers])
with (data_compression=page)
GO
*/

--Script de carga:
/****** Object:  PartitionScheme [PS_PARTITION_1_105]    Script Date: 12/16/2021 7:29:34 PM ******/
--DROP PARTITION SCHEME [PS_PARTITION_1_105]
CREATE PARTITION SCHEME [PS_PARTITION_1_160] AS PARTITION [PF_PARTITION_1_160] 
ALL TO ([PRIMARY])

/****** Object:  PartitionFunction [PF_PARTITION_1_105]    Script Date: 12/16/2021 7:31:22 PM ******/
--DROP PARTITION FUNCTION [PF_PARTITION_1_105]
CREATE PARTITION FUNCTION [PF_PARTITION_1_160](int) AS RANGE LEFT 
FOR VALUES (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118
, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147,148, 149
,150,151,152,153,154,155,156,157,158,159,160)
GO

/****** Object:  Table [dbo].[tbl_distributor_commissions_v2_PART]    Script Date: 12/17/2021 7:37:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--DROP TABLE [tbl_distributor_commissions_v2_PART]
CREATE TABLE [dbo].[tbl_distributor_commissions_v2_PART](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[AccountType] [smallint] NULL,
	[LegacyNumber] [bigint] NULL,
	[FirstName] [nvarchar](250) NULL,
	[LastName] [nvarchar](250) NULL,
	[IsTaxExempt] [smallint] NULL,
	[CurrencyCode] [char](10) NULL,
	[EnrollerId] [bigint] NULL,
	[JoinDate] [datetime] NULL,
	[DistributorStatus] [int] NULL,
	[PaidAsRank] [int] NULL,
	[LifetimeRankId] [smallint] NULL,
	[CREATEDDATE] [datetime] NULL,
	[CREATEDBY] [int] NULL,
	[MARKETID] [int] NULL,
	[CountryCode] [varchar](50) NULL,
	[BinarySponsorId] [bigint] NULL,
	[JoinCommPeriodId] [int] NULL,
	[TotalCV] [float] NULL,
	[Custom1] [float] NULL,
	[Custom2] [float] NULL,
	[Custom3] [float] NULL,
	[Custom4] [float] NULL,
	[Custom5] [float] NULL,
	[Custom7] [float] NULL,
	[Custom8] [float] NULL,
	[Custom6] [float] NULL,
	[ActiveTotalPV] [float] NULL,
	[Incoming_Left_Vol] [float] NULL,
	[Incoming_Right_Vol] [float] NULL,
	[CommPeriodId] [int] NULL,
	[ActiveUplineLevel1] [bigint] NULL,
	[ActiveUplineLevel2] [bigint] NULL,
	[ActiveUplineLevel3] [bigint] NULL,
	[TotalPV] [float] NULL,
	[StartRank] [int] NULL,
	[EndRank] [int] NULL,
	[Dir300_1_Count] [int] NULL,
	[ActiveEnrollerId] [bigint] NULL,
	[WEEKPGV] [decimal](18, 2) NULL,
	[WEEKGV] [decimal](18, 2) NULL,
	[Outgoing_Left_Vol] [decimal](18, 2) NULL,
	[Outgoing_Right_Vol] [decimal](18, 2) NULL,
	[PGV7] [decimal](18, 2) NULL,
	[PGV3] [decimal](18, 2) NULL,
	[BIWEEKGV] [decimal](18, 2) NULL,
	[TRIWEEKGV] [decimal](18, 2) NULL,
	[triweeksidegv] [float] NULL,
	[biweeksidegv] [float] NULL,
	[PGV50] [float] NULL,
	[custom9] [int] NULL,
	[custom10] [int] NULL,
	[CustomerPE_Volume] [float] NULL,
	[SponsorSequence] [int] NULL,
	[realcustom1] [float] NULL,
	[realcustom2] [float] NULL,
	[RETAIL_COMMISSIONS] [float] NULL,
	[PREF_CUST_BONUS] [float] NULL,
	[FAST_START_BONUS] [float] NULL,
	[FAST_START_GBR_IRL_BONUS] [float] NULL,
	[FAST_START_ITALY_BONUS] [float] NULL,
	[DIRECTOR_BONUS] [float] NULL,
	[TEAM_COMMISSIONS] [float] NULL,
	[CHECK_MATCH] [float] NULL,
	[TOTAL_COMMISSIONS] [float] NULL,
	[PEGRATE] [float] NULL,
	[RETAIL_COMMISSIONS_VALUE] [float] NULL,
	[PREF_CUST_BONUS_VALUE] [float] NULL,
	[FAST_START_BONUS_VALUE] [float] NULL,
	[FAST_START_GBR_IRL_BONUS_VALUE] [float] NULL,
	[FAST_START_ITALY_BONUS_VALUE] [float] NULL,
	[DIRECTOR_BONUS_VALUE] [float] NULL,
	[TEAM_COMMISSIONS_VALUE] [float] NULL,
	[CHECK_MATCH_VALUE] [float] NULL,
	[TOTAL_COMMISSIONS_VALUE] [float] NULL,
	[DiamPool_Bonus] [float] NULL,
	[DiamPool_Bonus_value] [float] NULL,
	[AccountAdjustment_bonus] [float] NULL,
	[AccountAdjustment_bonus_value] [money] NULL,
	[POOL_COMMISSIONS] [float] NULL,
	[POOL_COMMISSIONS_Value] [money] NULL,
	[Entrep_Bonus] [float] NULL,
	[Entrep_Bonus_value] [money] NULL,
	[EMP_bonus] [float] NULL,
	[EMP_bonus_value] [float] NULL,
	[Weak-2-weeks] [float] NULL,
	[Weak-3-weeks] [float] NULL,
	[Qual-until-date] [date] NULL,
	[Rnk9-gv-2weeks] [float] NULL,
	[Rnk10-gv-3weeks] [float] NULL,
	[Rnk11-gv-3weeks] [float] NULL,
	[rank9gv] [float] NULL,
	[rank10gv] [float] NULL,
	[rank11gv] [float] NULL,
	[Rank8Gv] [float] NULL,
	[Rank9Gv_1] [float] NULL,
	[Rank10Gv_1] [float] NULL,
	[Rank10Gv_2] [float] NULL,
	[Rank11Gv_1] [float] NULL,
	[Rank11Gv_2] [float] NULL,
	[pgv] [float] NULL,
	[gv] [float] NULL,
	[TotalVolume] [float] NULL,
	[Rank8Gv_1] [int] NULL,
	[DirectorBonusPaid] [smallint] NULL,
	[Pv7Gen] [float] NULL,
	[forcedrank] [int] NULL,
	[isforced] [smallint] NULL,
	[PERIOD_LEFT_VOL] [money] NULL,
	[PERIOD_RIGHT_VOL] [money] NULL,
	[STATUS] [varchar](50) NULL,
	[TotalDownlineLeft] [float] NULL,
	[TotalDownlineRight] [float] NULL,
	[newPersonalEnrollments] [float] NULL,
	[newEnrollLeft] [float] NULL,
	[newEnrollRight] [float] NULL,
	[activeLeft] [float] NULL,
	[activeRight] [float] NULL,
	[autoshipLeft] [float] NULL,
	[autoshipRight] [float] NULL,
	[avg2WeekLeft] [float] NULL,
	[avg2WeekRight] [float] NULL,
	[avg3WeekLeft] [float] NULL,
	[avg3WeekRight] [float] NULL,
	[ovr_ActiveTotalPV] [float] NULL,
	[pv6gen] [float] NULL,
	[TeamCommissionCapped] [smallint] NULL,
	[promo_bonus] [float] NULL,
	[promo_bonus_value] [float] NULL,
	[EnrollerOrgWeak50] [int] NULL,
	[EnrollerOrgWeak100] [int] NULL,
	[EnrollerOrgWeak150] [int] NULL,
	[EnrollerOrgWeak200] [int] NULL,
	[EnrollerOrgWeak250] [int] NULL,
	[d700_count] [int] NULL,
	[gold_count] [int] NULL,
	[country_code] [nvarchar](5) NULL,
	[achievedrankdate] [datetime] NULL,
	[total_left_leg] [float] NULL,
	[total_right_leg] [float] NULL,
	[hold_bonus] [smallint] NULL,
	[GROSS_COMMISSIONS] [float] NULL,
	[GROSS_COMMISSIONS_VALUE] [float] NULL,
	[dir300leg] [int] NULL,
	[EnrollerOrgWeak] [int] NULL,
	[EnrollerOrgWeak300] [int] NULL,
	[UplineBronze] [bigint] NULL,
	[UplineGold] [bigint] NULL,
	[UplineDiamond] [bigint] NULL,
	[TotalLeftVol_PersonalEnrollee] [int] NULL,
	[TotalRightVol_PersonalEnrollee] [int] NULL,
	[Pgv1] [float] NULL,
	[Pgv2] [float] NULL,
	[IsPvActive] [tinyint] NULL,
	[LesserBinaryVol] [float] NULL,
	[LastLesserBinaryVol] [float] NULL,
	[beforelastlesserbinaryvol] [float] NULL,
	[PersonalPrefCustomers] [int] NULL,
	[BinaryLeftPrefCustomers] [int] NULL,
	[BinaryRightPrefCustomers] [int] NULL,
	[TotalBinaryPrefCustomers] [int] NULL,
	[EnrollmentPrefCustomers] [int] NULL,
	[RightCount_EnrolledPreferredCustomers] [smallint] NOT NULL,
	[LeftCount_EnrolledPreferredCustomers] [smallint] NOT NULL,
	[RightCount_EnrolledRetailCustomers] [smallint] NOT NULL,
	[LeftCount_EnrolledRetailCustomers] [smallint] NOT NULL,
	[partition] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PS_PARTITION_1_160]([partition])
GO

ALTER TABLE [dbo].[tbl_distributor_commissions_v2_PART] ADD  DEFAULT ((0)) FOR [PersonalPrefCustomers]
GO

ALTER TABLE [dbo].[tbl_distributor_commissions_v2_PART] ADD  DEFAULT ((0)) FOR [BinaryLeftPrefCustomers]
GO

ALTER TABLE [dbo].[tbl_distributor_commissions_v2_PART] ADD  DEFAULT ((0)) FOR [BinaryRightPrefCustomers]
GO

ALTER TABLE [dbo].[tbl_distributor_commissions_v2_PART] ADD  DEFAULT ((0)) FOR [TotalBinaryPrefCustomers]
GO

ALTER TABLE [dbo].[tbl_distributor_commissions_v2_PART] ADD  DEFAULT ((0)) FOR [EnrollmentPrefCustomers]
GO

ALTER TABLE [dbo].[tbl_distributor_commissions_v2_PART] ADD  CONSTRAINT [Dftbl_distributor_commissions_v2_PART_RightCountEnrolledPreferredCustomers]  DEFAULT ((0)) FOR [RightCount_EnrolledPreferredCustomers]
GO

ALTER TABLE [dbo].[tbl_distributor_commissions_v2_PART] ADD  CONSTRAINT [Dftbl_distributor_commissions_v2_PART_LeftCount_EnrolledPreferredCustomers]  DEFAULT ((0)) FOR [LeftCount_EnrolledPreferredCustomers]
GO

ALTER TABLE [dbo].[tbl_distributor_commissions_v2_PART] ADD  CONSTRAINT [Dftbl_distributor_commissions_v2_PART_RightCount_EnrolledRetailCustomers]  DEFAULT ((0)) FOR [RightCount_EnrolledRetailCustomers]
GO

ALTER TABLE [dbo].[tbl_distributor_commissions_v2_PART] ADD  CONSTRAINT [Dftbl_distributor_commissions_v2_PART_LeftCount_EnrolledRetailCustomers]  DEFAULT ((0)) FOR [LeftCount_EnrolledRetailCustomers]
GO



SELECT MAX ([CommPeriodId]) --MIN 450. MAX 701
FROM tbl_distributor_commissions_v2
--ORDER BY [CommPeriodId] DESC

SELECT DISTINCT TOP 150 [CommPeriodId] --MIN 450. MAX 701
FROM tbl_distributor_commissions_v2
ORDER BY [CommPeriodId] DESC


--TRUNCATE TABLE tbl_distributor_commissions_v2_PART
SET IDENTITY_INSERT tbl_distributor_commissions_v2_PART ON
INSERT INTO tbl_distributor_commissions_v2_PART ([ID], [AccountType], [LegacyNumber], [FirstName], [LastName], [IsTaxExempt], [CurrencyCode], [EnrollerId], [JoinDate], [DistributorStatus], [PaidAsRank], [LifetimeRankId], [CREATEDDATE], [CREATEDBY], [MARKETID], [CountryCode], [BinarySponsorId], [JoinCommPeriodId], [TotalCV], [Custom1], [Custom2], [Custom3], [Custom4], [Custom5], [Custom7], [Custom8], [Custom6], [ActiveTotalPV], [Incoming_Left_Vol], [Incoming_Right_Vol], DC.[CommPeriodId], [ActiveUplineLevel1], [ActiveUplineLevel2], [ActiveUplineLevel3], [TotalPV], [StartRank], [EndRank], [Dir300_1_Count], [ActiveEnrollerId], [WEEKPGV], [WEEKGV], [Outgoing_Left_Vol], [Outgoing_Right_Vol], [PGV7], [PGV3], [BIWEEKGV], [TRIWEEKGV], [triweeksidegv], [biweeksidegv], [PGV50], [custom9], [custom10], [CustomerPE_Volume], [SponsorSequence], [realcustom1], [realcustom2], [RETAIL_COMMISSIONS], [PREF_CUST_BONUS], [FAST_START_BONUS], [FAST_START_GBR_IRL_BONUS], [FAST_START_ITALY_BONUS], [DIRECTOR_BONUS], [TEAM_COMMISSIONS], [CHECK_MATCH], [TOTAL_COMMISSIONS], [PEGRATE], [RETAIL_COMMISSIONS_VALUE], [PREF_CUST_BONUS_VALUE], [FAST_START_BONUS_VALUE], [FAST_START_GBR_IRL_BONUS_VALUE], [FAST_START_ITALY_BONUS_VALUE], [DIRECTOR_BONUS_VALUE], [TEAM_COMMISSIONS_VALUE], [CHECK_MATCH_VALUE], [TOTAL_COMMISSIONS_VALUE], [DiamPool_Bonus], [DiamPool_Bonus_value], [AccountAdjustment_bonus], [AccountAdjustment_bonus_value], [POOL_COMMISSIONS], [POOL_COMMISSIONS_Value], [Entrep_Bonus], [Entrep_Bonus_value], [EMP_bonus], [EMP_bonus_value], [Weak-2-weeks], [Weak-3-weeks], [Qual-until-date], [Rnk9-gv-2weeks], [Rnk10-gv-3weeks], [Rnk11-gv-3weeks], [rank9gv], [rank10gv], [rank11gv], [Rank8Gv], [Rank9Gv_1], [Rank10Gv_1], [Rank10Gv_2], [Rank11Gv_1], [Rank11Gv_2], [pgv], [gv], [TotalVolume], [Rank8Gv_1], [DirectorBonusPaid], [Pv7Gen], [forcedrank], [isforced], [PERIOD_LEFT_VOL], [PERIOD_RIGHT_VOL], [STATUS], [TotalDownlineLeft], [TotalDownlineRight], [newPersonalEnrollments], [newEnrollLeft], [newEnrollRight], [activeLeft], [activeRight], [autoshipLeft], [autoshipRight], [avg2WeekLeft], [avg2WeekRight], [avg3WeekLeft], [avg3WeekRight], [ovr_ActiveTotalPV], [pv6gen], [TeamCommissionCapped], [promo_bonus], [promo_bonus_value], [EnrollerOrgWeak50], [EnrollerOrgWeak100], [EnrollerOrgWeak150], [EnrollerOrgWeak200], [EnrollerOrgWeak250], [d700_count], [gold_count], [country_code], [achievedrankdate], [total_left_leg], [total_right_leg], [hold_bonus], [GROSS_COMMISSIONS], [GROSS_COMMISSIONS_VALUE], [dir300leg], [EnrollerOrgWeak], [EnrollerOrgWeak300], [UplineBronze], [UplineGold], [UplineDiamond], [TotalLeftVol_PersonalEnrollee], [TotalRightVol_PersonalEnrollee], [Pgv1], [Pgv2], [IsPvActive], [LesserBinaryVol], [LastLesserBinaryVol], [beforelastlesserbinaryvol], [PersonalPrefCustomers], [BinaryLeftPrefCustomers], [BinaryRightPrefCustomers], [TotalBinaryPrefCustomers], [EnrollmentPrefCustomers], [RightCount_EnrolledPreferredCustomers], [LeftCount_EnrolledPreferredCustomers], [RightCount_EnrolledRetailCustomers], [LeftCount_EnrolledRetailCustomers], [partition])
SELECT [ID], [AccountType], [LegacyNumber], [FirstName], [LastName], [IsTaxExempt], [CurrencyCode], [EnrollerId], [JoinDate], [DistributorStatus], [PaidAsRank], [LifetimeRankId], [CREATEDDATE], [CREATEDBY], [MARKETID], [CountryCode], [BinarySponsorId], [JoinCommPeriodId], [TotalCV], [Custom1], [Custom2], [Custom3], [Custom4], [Custom5], [Custom7], [Custom8], [Custom6], [ActiveTotalPV], [Incoming_Left_Vol], [Incoming_Right_Vol], DC.[CommPeriodId], [ActiveUplineLevel1], [ActiveUplineLevel2], [ActiveUplineLevel3], [TotalPV], [StartRank], [EndRank], [Dir300_1_Count], [ActiveEnrollerId], [WEEKPGV], [WEEKGV], [Outgoing_Left_Vol], [Outgoing_Right_Vol], [PGV7], [PGV3], [BIWEEKGV], [TRIWEEKGV], [triweeksidegv], [biweeksidegv], [PGV50], [custom9], [custom10], [CustomerPE_Volume], [SponsorSequence], [realcustom1], [realcustom2], [RETAIL_COMMISSIONS], [PREF_CUST_BONUS], [FAST_START_BONUS], [FAST_START_GBR_IRL_BONUS], [FAST_START_ITALY_BONUS], [DIRECTOR_BONUS], [TEAM_COMMISSIONS], [CHECK_MATCH], [TOTAL_COMMISSIONS], [PEGRATE], [RETAIL_COMMISSIONS_VALUE], [PREF_CUST_BONUS_VALUE], [FAST_START_BONUS_VALUE], [FAST_START_GBR_IRL_BONUS_VALUE], [FAST_START_ITALY_BONUS_VALUE], [DIRECTOR_BONUS_VALUE], [TEAM_COMMISSIONS_VALUE], [CHECK_MATCH_VALUE], [TOTAL_COMMISSIONS_VALUE], [DiamPool_Bonus], [DiamPool_Bonus_value], [AccountAdjustment_bonus], [AccountAdjustment_bonus_value], [POOL_COMMISSIONS], [POOL_COMMISSIONS_Value], [Entrep_Bonus], [Entrep_Bonus_value], [EMP_bonus], [EMP_bonus_value], [Weak-2-weeks], [Weak-3-weeks], [Qual-until-date], [Rnk9-gv-2weeks], [Rnk10-gv-3weeks], [Rnk11-gv-3weeks], [rank9gv], [rank10gv], [rank11gv], [Rank8Gv], [Rank9Gv_1], [Rank10Gv_1], [Rank10Gv_2], [Rank11Gv_1], [Rank11Gv_2], [pgv], [gv], [TotalVolume], [Rank8Gv_1], [DirectorBonusPaid], [Pv7Gen], [forcedrank], [isforced], [PERIOD_LEFT_VOL], [PERIOD_RIGHT_VOL], [STATUS], [TotalDownlineLeft], [TotalDownlineRight], [newPersonalEnrollments], [newEnrollLeft], [newEnrollRight], [activeLeft], [activeRight], [autoshipLeft], [autoshipRight], [avg2WeekLeft], [avg2WeekRight], [avg3WeekLeft], [avg3WeekRight], [ovr_ActiveTotalPV], [pv6gen], [TeamCommissionCapped], [promo_bonus], [promo_bonus_value], [EnrollerOrgWeak50], [EnrollerOrgWeak100], [EnrollerOrgWeak150], [EnrollerOrgWeak200], [EnrollerOrgWeak250], [d700_count], [gold_count], [country_code], [achievedrankdate], [total_left_leg], [total_right_leg], [hold_bonus], [GROSS_COMMISSIONS], [GROSS_COMMISSIONS_VALUE], [dir300leg], [EnrollerOrgWeak], [EnrollerOrgWeak300], [UplineBronze], [UplineGold], [UplineDiamond], [TotalLeftVol_PersonalEnrollee], [TotalRightVol_PersonalEnrollee], [Pgv1], [Pgv2], [IsPvActive], [LesserBinaryVol], [LastLesserBinaryVol], [beforelastlesserbinaryvol], [PersonalPrefCustomers], [BinaryLeftPrefCustomers], [BinaryRightPrefCustomers], [TotalBinaryPrefCustomers], [EnrollmentPrefCustomers], [RightCount_EnrolledPreferredCustomers], [LeftCount_EnrolledPreferredCustomers], [RightCount_EnrolledRetailCustomers], [LeftCount_EnrolledRetailCustomers]
,DP.[PartitionNumber] AS PARTITION
FROM tbl_distributor_commissions_v2 DC
INNER JOIN tbl_distributor_commissions_Partition DP ON DP.CommPeriodId=DC.CommPeriodId AND FREE=1                              
--WHERE [CommPeriodId] IN (SELECT TOP 1 [CommPeriodId] FROM [tbl_distributor_commissions_Partition] WHERE FREE=1)
SET IDENTITY_INSERT tbl_distributor_commissions_v2_PART OFF

--select * from tbl_distributor_commissions_Partition

SELECT $PARTITION.PF_PARTITION_1_160(PARTITION),PARTITION,* FROM tbl_distributor_commissions_v2_part with (nolock)
WHERE [CommPeriodId]=701

TRUNCATE TABLE [tbl_distributor_commissions_Partition]
DECLARE @NUMPART INT
DECLARE @CommPeriodId int
SET @NUMPART=1
SET @CommPeriodId=552

WHILE @CommPeriodId < 702
BEGIN
	INSERT INTO [tbl_distributor_commissions_Partition]
	VALUES (@CommPeriodId,@NUMPART,1)
	SET @CommPeriodId=@CommPeriodId+1
	SET @NUMPART=@NUMPART+1
END

--INSERT INTO [tbl_distributor_commissions_Partition]
--VALUES (701,2,0)

SELECT [CommPeriodId]
      ,[PartitionNumber]
      ,[free]
  FROM [dbo].[tbl_distributor_commissions_Partition]



--REBUILD:
Command: ALTER INDEX [PK__tbl_dist__3214EC275D93B669] ON [dbo].[tbl_distributor_commissions_v2] 
REBUILD WITH (SORT_IN_TEMPDB = OFF, ONLINE = ON, MAXDOP = 4, RESUMABLE = OFF)

DBCC SHRINKDATABASE ([Asea_Stage])

truncate table tbl_distributor_commissions_v2_part
--Commands completed successfully. Completion time: 2022-01-05T06:21:59.6788771-03:00