/*
ALTER TABLE [dbo].[TBL_LOGEMAIL] REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = PAGE
)
--22 segundos, 5GB!
*/

/*
ALTER TABLE [dbo].[Commissions_Distributor_Temp] REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = PAGE
)
--8:57 y lo paré. Demoró mucho porque era un heap con dos índices noncluster! (movimiento físico de páginas, cambia el 
-- RID
*/

/*
ALTER INDEX [Ix_01_Commissions_Distributor_Temp_ExportSummaryTemp] ON [dbo].[Commissions_Distributor_Temp]
REBUILD PARTITION = ALL WITH (STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, DATA_COMPRESSION = PAGE)
-- 1h:29 minutos

ALTER INDEX [ix_1_performance_tbl_Distributor] ON [dbo].[tbl_Distributor] REBUILD PARTITION = ALL 
WITH (fillfactor=90,STATISTICS_NORECOMPUTE = OFF, ONLINE = ON, DATA_COMPRESSION = PAGE)

ALTER INDEX [PK_TBL_DISTRIBUITOR] ON [dbo].[tbl_Distributor] 
REBUILD PARTITION = ALL WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 90)

ALTER INDEX [Ix_Nc_Distributor_UserStatus_EnrollerId_MarketId_BinarySponsorId_PinRankId] ON [dbo].[tbl_Distributor] REBUILD PARTITION = ALL 
WITH (fillfactor=90,STATISTICS_NORECOMPUTE = OFF, ONLINE = ON, DATA_COMPRESSION = PAGE)

ALTER INDEX [Ix_Nn_tbl_Distributor_EnrollerId_AccountType] ON [dbo].[tbl_Distributor] REBUILD PARTITION = ALL 
WITH (fillfactor=90,STATISTICS_NORECOMPUTE = OFF, ONLINE = ON, DATA_COMPRESSION = PAGE)

ALTER INDEX [Ix_Nn_tbl_Distributor_EnrollerId_AccountType] ON [dbo].[tbl_Distributor] REBUILD PARTITION = ALL 
WITH (fillfactor=90,STATISTICS_NORECOMPUTE = OFF, ONLINE = ON, DATA_COMPRESSION = PAGE)

ALTER INDEX [Ix_Nn_tbl_Distributor_EnrollerId_LegacyNumber_Joindate_3_4_2021] ON [dbo].[tbl_Distributor] REBUILD PARTITION = ALL 
WITH (fillfactor=90,STATISTICS_NORECOMPUTE = OFF, ONLINE = ON, DATA_COMPRESSION = PAGE)

*/


/*
	3/22/2021
*/

--ALTER INDEX [IX_NN_Commissions_Distributor_CommissionsPeriodId_EndRank_Incl_3_10_2021] ON [dbo].[Commissions_Distributor] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [Ix_01_Azure_Nc_Commissions_Distributor] ON [dbo].[Commissions_Distributor] REBUILD WITH (DATA_COMPRESSION=PAGE); --34523 a 11276.
--ALTER INDEX [Ix_01_Commissions_Distributor_CommissionsPeriodId_DistributorId] ON [dbo].[Commissions_Distributor] REBUILD WITH (DATA_COMPRESSION=PAGE); --16983 --9420
--ALTER INDEX [IX_NN_Commissions_Distributor_CommissionsPeriodId_EndRank_Incl_3_10_2021] ON [dbo].[Commissions_Distributor] REBUILD WITH (DATA_COMPRESSION=PAGE);
--ALTER INDEX [In_Nn_Comp_Commissions_Distributor_CommissionsPeriodId_DistributorIdHigestRankLeg] ON [dbo].[Commissions_Distributor] REBUILD WITH (DATA_COMPRESSION=none); --42074 --32 segundos.
--ALTER INDEX [Ix_02_Azure_Nc_Commissions_Distributor] ON [dbo].[Commissions_Distributor] REBUILD WITH (DATA_COMPRESSION=PAGE); --116743 a 36348 --28 segundos.

--CREATE NONCLUSTERED INDEX [In_Nn_Bl_Commissions_Distributor_SemiMonthly_RunDate_RunSequence_Comp_3_22_2021]
--ON [dbo].[Bl_Commissions_Distributor_SemiMonthly] ([RunDate],[RunSequence])
--WITH (DATA_COMPRESSION=PAGE); --16 segundos
--GO

/*
	END 3/22/2021
*/


/*
	3/23/2021
*/

--CREATE NONCLUSTERED INDEX [In_Nn_Bl_Commissions_Distributor_SemiMonthly_CommissionsPeriodId_AccountType_Incl_Comp_3_23_2021]
--ON [dbo].[Bl_Commissions_Distributor_SemiMonthly] ([CommissionsPeriodId],[AccountType])
--include(DistributorId,EndRank)
--WITH (DATA_COMPRESSION=PAGE); -- 7 segundos
--GO

--CREATE NONCLUSTERED INDEX [IX_NC_Bl_Commissions_Distributor_SemiMonthly_CommissionsPeriodId_AccountType_Comp_3_23_2021]
--ON [dbo].TBL_LOGEMAIL (id desc)
--WITH (DATA_COMPRESSION=PAGE); -- 0 segundos
--GO

--CREATE NONCLUSTERED INDEX [IX_NN_OrderType_OrderType_Incl_Comp_3_23_2021]
--ON [dbo].[tbl_Orders_Header] ([OrderType])
--INCLUDE ([OrderDate],[SubTotal],[OrderStatus],[MarketID])
--WITH (DATA_COMPRESSION=PAGE); -- 2 segundos
--GO


/*
	END 3/22/2021
*/
