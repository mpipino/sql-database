/****** Object:  Index [Ix_01_Commissions_Distributor_Temp_ExportSummaryTemp]    Script Date: 2/24/2021 6:06:27 PM ******/
--DROP INDEX Ix_02_Commissions_Distributor_Temp ON [dbo].[Commissions_Distributor_Temp]
GO
--DROP INDEX Ix_02_Commissions_Distributor_Temp_ExportSummaryTem ON [dbo].[Commissions_Distributor_Temp]

--Rollback Plan:

/*
/****** Object:  Index [Ix_01_Commissions_Distributor_Temp_ExportSummaryTemp]    Script Date: 2/24/2021 6:03:06 PM ******/
CREATE NONCLUSTERED INDEX [Ix_01_Commissions_Distributor_Temp_ExportSummaryTemp] ON [dbo].[Commissions_Distributor_Temp]
(
	[RunDate] ASC,
	[RunSequence] ASC
)
INCLUDE([CommissionsPeriodId],[DistributorId],[AccountType],[FirstName],[LastName],[JoinDate],[MarketId],[UserStatus],[EnrollerId],[TotalTeamVolumenCv],[TotalTeamVolumenQv],[CustomerVolumeCv],[TotalPersonalCv],[ActiveTotalCv],[CustomerVolumeQv],[TotalPersonalQv],[ActiveTotalQv],[EndRank],[EarnedRank],[ForcedRank],[Qualified],[TotalCommissions]) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/****** Object:  Index [Ix_02_Commissions_Distributor_Temp]    Script Date: 2/24/2021 6:04:01 PM ******/
CREATE NONCLUSTERED INDEX [Ix_02_Commissions_Distributor_Temp] ON [dbo].[Commissions_Distributor_Temp]
(
	[RunDate] ASC,
	[RunSequence] ASC,
	[EndRank] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
*/

