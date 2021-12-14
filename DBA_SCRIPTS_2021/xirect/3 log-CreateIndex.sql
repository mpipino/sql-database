/*
3 de marzo 2021
*/
/*
/****** Object:  Index [Ix_04_Bl_Commissions_Distributor_SemiMonthly_Temp]    Script Date: 3/4/2021 8:39:43 PM ******/
CREATE NONCLUSTERED INDEX [Ix_04_Comp_Bl_Commissions_Distributor_SemiMonthly_Temp] ON [dbo].[Bl_Commissions_Distributor_SemiMonthly_Temp]
(
	[RunDate] ASC,
	[RunSequence] ASC,
	[EnrollerId] ASC
)
INCLUDE([DistributorId],[TotalTeamVolumenQv],[ActiveTotalCv],[ActiveTotalQv],[EndRank],[Qualified]) 
WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION=PAGE) ON [PRIMARY]
GO --19 segundos!!!!!!!!!!!
*/

/*
/****** Object:  Index [Ix_03_Bl_Commissions_Distributor_SemiMonthly_Temp]    Script Date: 3/4/2021 10:14:38 PM ******/
CREATE NONCLUSTERED INDEX [Ix_03_Comp_Bl_Commissions_Distributor_SemiMonthly_Temp] ON [dbo].[Bl_Commissions_Distributor_SemiMonthly_Temp]
(
	[RunDate] ASC,
	[RunSequence] ASC
)
INCLUDE([CommissionsPeriodId],[DistributorId],[AccountType],[FirstName],[LastName],[JoinDate],[MarketId],[UserStatus],[EnrollerId],[PlacementId],[BinarySponsorID],[BinaryPosition],[TotalTeamVolumenCv],[TotalTeamVolumenQv],[CurrentTeamVolumenCv],[CurrentTeamVolumenQv],[CustomerVolumeCv],[TotalPersonalCv],[ActiveTotalCv],[CustomerVolumeQv],[TotalPersonalQv],[ActiveTotalQv],[ProjectedPersonalCv],[ProjectedTeamVolumeCv],[ProjectedPersonalQv],[ProjectedTeamVolumeQv],[TransferVolumeCv],[TransferVolumeQv],[LifetimeRankId],[StartRank],[EndRank],[EarnedRank],[ForcedRank],[SyncDate],[Qualified],[BinaryQualified],[TotalCommissions],[Custom01],[Custom02],[Custom03],[Custom04],[Custom05],[Custom06],[Custom07],[Custom08],[Custom09],[Custom10],[Custom11],[Custom12],[Custom13],[Custom14],[Custom15],[Custom16],[Custom17],[Custom18],[Custom19],[Custom20],[DistributorIdHigestRankLeg],[ProgressNextRank],[Status],[CreatedDate],[CreatedBy],[UpdatedDate],[UpdatedBy]) 
WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION=PAGE) ON [PRIMARY]
GO --1:03 SEGUNDOS.
*/

/*
/****** Object:  Index [Ix_02_Bl_Commissions_Distributor_SemiMonthly_Temp]    Script Date: 3/4/2021 10:20:52 PM ******/
CREATE NONCLUSTERED INDEX [Ix_02_Comp_Bl_Commissions_Distributor_SemiMonthly_Temp] ON [dbo].[Bl_Commissions_Distributor_SemiMonthly_Temp]
(
	[RunDate] ASC,
	[RunSequence] ASC,
	[EndRank] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION=PAGE) ON [PRIMARY]
GO
*/

/*
/****** Object:  Index [In_Nn_Commissions_Distributor_CommissionsPeriodId_DistributorIdHigestRankLeg]    Script Date: 3/4/2021 10:31:08 PM ******/
CREATE NONCLUSTERED INDEX [In_Nn_Comp_Commissions_Distributor_CommissionsPeriodId_DistributorIdHigestRankLeg] ON [dbo].[Commissions_Distributor]
(
	[CommissionsPeriodId] ASC,
	[DistributorIdHigestRankLeg] ASC
)
INCLUDE([AccountType],[ActiveTotalCv],[ActiveTotalQv],[CommissionsDistributorId],[CustomerVolumeCv],[CustomerVolumeQv],[DistributorId],[EndRank],[EnrollerId],[FirstName],[JoinDate],[LastName],[MarketId],[Qualified],[TotalCommissions],[TotalPersonalCv],[TotalPersonalQv],[TotalTeamVolumenQv]) 
WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION=PAGE) ON [PRIMARY]
GO -- 1:21 un minuto 21 segundos
*/

/*
CREATE NONCLUSTERED INDEX [nci_wi_Comp_OrderDiscountsDetail_3EC513BF433E5299C813D710022EBF36] --"Performance recommendations" DE AZURE.
ON [dbo].[OrderDiscountsDetail] ([OrderLegacyNumber], [DiscountTypeId]) WITH (ONLINE = ON, DATA_COMPRESSION=PAGE) --3 segundos!!!!!!
*/ --6300 pages

/*
CREATE NONCLUSTERED INDEX [nci_wi_tbl_Orders_Detail_Child_A725FF24797EB49324610035AD9CBF90] --"Performance recommendations" DE AZURE
ON [dbo].[tbl_Orders_Detail_Child] ([DetailID]) INCLUDE ([CHILDDETAILID], [PRODUCTCHILDID], [ProductID], [Quantity], [SKUID]) 
WITH (ONLINE = ON, DATA_COMPRESSION=PAGE) --0 segundos.
*/
/*
-- =================================================================================
-- Create index template for Azure SQL Database and Azure Synapse Analytics Database 
-- =================================================================================

CREATE INDEX Ix_Nn_tbl_Distributor_EnrollerId_LegacyNumber_Joindate_3_4_2021
ON DBO.tbl_Distributor
(
	EnrollerId
)
INCLUDE(LegacyNumber,Joindate)
WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION=PAGE) ON [PRIMARY]
GO -- 2 segundos
*/

/*
Missing Index Details from ExecutionPlan1.sqlplan
The Query Processor estimates that implementing the following index could improve the query cost by 55.75%.
*/

----------------PASADOS A EXPRESS DESDE ACA PARA ABAJO
/*
USE [BodyLogic_Live]
GO
CREATE NONCLUSTERED INDEX Ix_Nn_Commissions_Periods_StartDate_EndDate_3_5_2021
ON [dbo].[Commissions_Periods] ([CommissionsPeriodsFrequencyId],[CommissionsPeriodsStatus],[CommissionsPeriodId])
INCLUDE ([StartDate],[EndDate],[IsClosed])
WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION=PAGE) ON [PRIMARY]
GO --A EXPRESS
*/
/*
USE [BodyLogic_Live]
GO
CREATE NONCLUSTERED INDEX idx_autoships_distributor_CreditCardID_OrderStatus_3_5_2021
ON [dbo].[tbl_AutoshipOrders_Header] ([CreditCardID],[OrderStatus])
GO --A EXPRESS
*/


/*
CREATE NONCLUSTERED INDEX Ix_Nn_Commissions_Distributor_Temp_RunDate_RunSequence_3_6_2021
ON [dbo].[Commissions_Distributor_Temp] ([RunDate],[RunSequence])
INCLUDE ([DistributorId],[Custom10])
WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION=PAGE) ON [PRIMARY]
GO --LISTO! 11:28 segundos. 40% TLog de 6 gb. --NO A EXPRESS

--Recordar que esta tabla NO tenia indices en Live. Tiene un HEAP MUY FRAGMENTADO IMPOSIBLE DE TRABAJAR CON EL.
--
CREATE CLUSTERED INDEX Ix_Commissions_Distributor_Temp_CommissionsDistributorId_3_6_2021
ON [dbo].[Commissions_Distributor_Temp] (CommissionsDistributorId)
WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION=none) ON [PRIMARY]
GO --65% TLOG 91% tuve que cortar. --NO A EXPRESS

--select count(CommissionsDistributorId) from Commissions_Distributor_Temp

/****** Object:  Index [Ix_01_Azure_Nc_Tbl_Orders_Header]    Script Date: 3/5/2021 5:42:22 PM ******/
CREATE NONCLUSTERED INDEX [Ix_01_Azure_Nc_Tbl_Orders_Header] ON [dbo].[tbl_Orders_Header]
(
	[LegacyNumber] ASC
)
INCLUDE([MarketID],orderstatus) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = on, ONLINE = on, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO --A EXPRESS pero reusando otro indice.


--Amazing:
--ALTER TABLE tbl_Balance_Account_Ledger REBUILD
--55 % AVERAGE FRAGMENTATION. 3218 PAGE COUNT. ONE NONCLUSTER INDEX.
--2% uso de TLOG. No blocking. No high duration con common queries.
-- 22:19 minutes, stopped.
--113.00 rows (lead pages, nonclusterindex)

/****** Object:  Index [Ix_Nn_tbl_Balance_Account_Ledger_DistributorID_Status]    Script Date: 3/5/2021 11:04:20 PM ******/
--DROP INDEX [Ix_Nn_tbl_Balance_Account_Ledger_DistributorID_Status] ON [dbo].[tbl_Balance_Account_Ledger]
--GO

/****** Object:  Index [Ix_Nn_tbl_Balance_Account_Ledger_DistributorID_Status]    Script Date: 3/5/2021 11:04:20 PM ******/
CREATE nonCLUSTERED INDEX [Ix_Nn_tbl_Balance_Account_Ledger_DistributorID_Status] ON [dbo].[tbl_Balance_Account_Ledger]
(
	[DistributorID] ASC,
	[Status] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO --16 seconds. --A EXPRESS

CREATE CLUSTERED INDEX Ix_tbl_Balance_Account_Ledger_ID 
    ON dbo.tbl_Balance_Account_Ledger (id);   
GO --2 secs. pero rebuild del heap: 22:19 minutes, stopped. -- NO A EXPRESS

/*
FIN 3 de marzo 2021
*/

/*
3/6/2021
*/

/*
USE [BodyLogic_Live]
GO
CREATE NONCLUSTERED INDEX IX_NN_PromoCode_ApplyDiscountContinue_incl_3_6_2021
ON [dbo].[PromoCode] ([ApplyDiscountContinue])
INCLUDE ([NumberDiscountContinue])
WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION=PAGE) ON [PRIMARY]
GO --NO A EXPRESS

USE [BodyLogic_Live]
GO
CREATE NONCLUSTERED INDEX IX_NN_Commissions_Settingsincl_3_6_2021
ON [dbo].[Commissions_Settings] ([MarketId],[CommissionsSettingName],[CommissionsSettingsVersionId])
INCLUDE ([CommissionsSettingValue])
WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION=PAGE) ON [PRIMARY]
GO  --A EXPRESS
Commands completed successfully.
Completion time: 2021-03-06T08:27:14.6616992-03:00


*/

/*
END 3/6/2021
*/
*/

/*
3/8/2021
*/
--CREATE NONCLUSTERED INDEX Ix_Nn_Commissions_Distributor_BonusEarned_Summary_DistributorId_CommissionsPeriodId_Incl_3_8_2021 
--ON [BodyLogic_Live].[dbo].[Commissions_Distributor_BonusEarned_Summary] 
--([DistributorId], [CommissionsPeriodId]) INCLUDE ([CommissionsDistributorBonusEarnedSummaryAmount]);  --A EXPRESS

/*
END 3/8/2021
*/

/*
3/9/2021
*/
/*
/*
Missing Index Details from ExecutionPlan1.sqlplan
The Query Processor estimates that implementing the following index could improve the query cost by 95.8989%.
*/

/*
USE [BodyLogic_Live]
GO
CREATE NONCLUSTERED INDEX IX_NN_SalesPromotion_ConventionTravel_Distributor_Summary_DistributorId_CommissionsPeriodId_Comp_3_9_2021
ON [dbo].[SalesPromotion_ConventionTravel_Distributor_Summary] ([DistributorId],[CommissionsPeriodId])
 WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100)
GO --NO A EXPRESS no está la tabla.

/*
Missing Index Details from ExecutionPlan1.sqlplan
The Query Processor estimates that implementing the following index could improve the query cost by 92.5271%.
*/

/*
USE [BodyLogic_Live]
GO
CREATE NONCLUSTERED INDEX IX_NN_tbl_Payouts_Credentials_DistributorID_Status_Incl_Comp_3_9_2021
ON [dbo].[tbl_Payouts_Credentials] ([DistributorID],[Status])
INCLUDE ([NumberAccount],[passAccount],[Email],[CreatedDate],[IsDefault],[PayoutAccountID])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100)
GO --A EXPRESS 
*/


/*
Missing Index Details from ExecutionPlan1.sqlplan
The Query Processor estimates that implementing the following index could improve the query cost by 93.6182%.
*/

/*
USE [BodyLogic_Live]
GO
CREATE NONCLUSTERED INDEX IX_NN_tbl_Products_SKUID_Incl_Comp_3_9_2021
ON [dbo].[tbl_Products] ([SKUID])
INCLUDE ([SubscriptionTypeId])
GO --A EXPRESS 
*/

CREATE NONCLUSTERED INDEX IX_NN_PromoCodeDetail_Comp_3_9_2021
ON [dbo].[PromoCodeDetail] ([OrderHeaderLegacyNumber],[Status])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100) -A EXPRESS 


/*
Missing Index Details from ExecutionPlan1.sqlplan
The Query Processor estimates that implementing the following index could improve the query cost by 94.6818%.
*/

/*
USE [BodyLogic_Live]
GO
CREATE NONCLUSTERED INDEX IX_NN_Commissions_Settings_CommissionsSettingName_CommissionsPeriodsFrequencyId_Incl_Comp_3_9_2021
ON [dbo].[Commissions_Settings] ([CommissionsSettingName],[CommissionsPeriodsFrequencyId])
INCLUDE ([CommissionsPeriodId],[MarketId],[CommissionsSettingValue])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100)
GO  --A EXPRESS 
*/

/*
Missing Index Details from ExecutionPlan1.sqlplan
The Query Processor estimates that implementing the following index could improve the query cost by 96.9745%.
*/

/*
USE [BodyLogic_Live]
GO
CREATE NONCLUSTERED INDEX  IX_NN_Commissions_Invoices_MarketId_Year_Incl_Comp_3_9_2021
ON [dbo].[Commissions_Invoices] ([MarketId],[Year])
INCLUDE ([Sequence])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100)

*/


*/
end 3/9/2021
*/



/*
Missing Index Details from ExecutionPlan1.sqlplan
The Query Processor estimates that implementing the following index could improve the query cost by 39.2633%.
*/

/*
/*
 3/10/2021
*/
USE [BodyLogic_Live]
GO
CREATE NONCLUSTERED INDEX  IX_NN_Commissions_Periods_IsFinalized_CommissionsPeriodsFrequencyId_CommissionsPeriodId_Incl_Comp_3_9_2021
ON [dbo].[Commissions_Periods] ([IsFinalized],[CommissionsPeriodsFrequencyId],[CommissionsPeriodId])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100)
GO --A EXPRESS

/*
Missing Index Details from ExecutionPlan1.sqlplan
The Query Processor estimates that implementing the following index could improve the query cost by 62.2502%.
*/

/*
USE [BodyLogic_Live]
GO
CREATE NONCLUSTERED INDEX  IX_NN_Product_Module_AccountType_ProductId_Comp_3_10_2021
ON [Prd].[Product_Module_AccountType] ([ProductId])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100)
GO
*/

CREATE NONCLUSTERED INDEX IX_NN_tbl_Orders_Header_LegacyNumber_Incl_3_10_2021
ON [dbo].[tbl_Orders_Header] ([LegacyNumber])
INCLUDE ([Orderstatus])
WITH (data_compression=none,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100) --NO A EXPRESS ya hay otro índice.


CREATE NONCLUSTERED INDEX <Add Index Name here> ON [BodyLogic_Live].[dbo].[tbl_Distributor] ([PaidAsRank]) INCLUDE ([LegacyNumber]);
WITH (data_compression=none,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100)

CREATE NONCLUSTERED INDEX <Add Index Name here> ON [BodyLogic_Live].[dbo].[tbl_Distributor] ([LifeTimeRankID]) INCLUDE ([LegacyNumber]);
CREATE NONCLUSTERED INDEX <Add Index Name here> ON [BodyLogic_Live].[dbo].[tbl_Orders_Header] ([IsMigration], [OrderDate], [OrderStatus], [SentToXipix]) INCLUDE ([LegacyNumber], [DistributorID]);


CREATE NONCLUSTERED INDEX IX_NNBodyLogic_Live_3_10_2021 ON [BodyLogic_Live].[Dst].[Distributor_ContactInfo] ([DistributorID])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100) -- 0 segundos --no A EXPRESS, no está la tabla.

CREATE NONCLUSTERED INDEX IX_N_tbl_Distributor_AccountType_UserStatus_JoinDate_Comp_Incl_3_10_2021 
ON [BodyLogic_Live].[dbo].[tbl_Distributor] ([AccountType], [UserStatus]) INCLUDE ([JoinDate])
WITH (data_compression=none,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100) -- 2 secs --no A EXPRESS, MUCHOS INDICES.

CREATE NONCLUSTERED INDEX IX_N_tbl_Distributor_PaidAsRank_Comp_Incl_3_10_2021  ON [BodyLogic_Live].[dbo].[tbl_Distributor] ([PaidAsRank]) INCLUDE ([LegacyNumber])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100) -- 2 secs --no A EXPRESS, MUCHOS INDICES.

CREATE NONCLUSTERED INDEX IX_N_tbl_Distributor_LifeTimeRankID_Comp_Incl_3_10_2021 ON [BodyLogic_Live].[dbo].[tbl_Distributor] 
([LifeTimeRankID]) INCLUDE ([LegacyNumber]); --no A EXPRESS, MUCHOS INDICES.

CREATE NONCLUSTERED INDEX IX_NN_Cashier_Closing_PaymentType_Detail_CashierClosingPaymentType 
ON [BodyLogic_Live].[dbo].[Cashier_Closing_PaymentType_Detail] ([CashierClosingPaymentType]) INCLUDE ([OrderId])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100) -- 1 secs


CREATE NONCLUSTERED INDEX  IX_NN_tbl_Orders_Header_Incl_3_10_2021 ON [BodyLogic_Live].[dbo].[tbl_Orders_Header] ([OrderStatus]) INCLUDE ([LegacyNumber], [OrderDate])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100) -- 5 secs --no A EXPRESS, ya hay un indice parecido.

CREATE NONCLUSTERED INDEX IX_NN_Commissions_Settings_CommissionsSettingName_Incl_3_10_2021 ON [BodyLogic_Live].[dbo].[Commissions_Settings] 
([CommissionsSettingName]) INCLUDE ([MarketId], [PinRankId], [CommissionsSettingValue]) -- A EXPRESS,
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100) -- 0 secs

CREATE NONCLUSTERED INDEX IX_NN_Commissions_Distributor_CommissionsPeriodId_EndRank_Incl_3_10_2021 
ON [BodyLogic_Live].[dbo].[Commissions_Distributor] ([CommissionsPeriodId], [EndRank]) INCLUDE ([DistributorId])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100) -- 59 secs  -- A EXPRESS

CREATE NONCLUSTERED INDEX Bl_Commissions_Bonus_FastStartBonus_DistributorId_CommissionsPeriodId_Incl_3_10_2021 
ON [BodyLogic_Live].[dbo].[Bl_Commissions_Bonus_FastStartBonus] ([DistributorId], [CommissionsPeriodId]) 
INCLUDE ([OrderNumber], [OrderPinRankId], [OrderDistributorId], [FastStartBonus]) -- A EXPRESS no está la tabla.
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100) -- 0 secs
/*
END 3/10/2021
*/

/*
3/12/2021
*/
CREATE NONCLUSTERED INDEX IX_NN_tbl_DetailPayment_Orders_PaymenType_MerchantProcessorId_Incl ON [BodyLogic_Live].[dbo].[tbl_DetailPayment_Orders] 
([PaymenType], [MerchantProcessorId]) INCLUDE ([OrderID]);

CREATE NONCLUSTERED INDEX IX_NN_tbl_Distributor_EmailAddress_JoinDate_Incl_3_12_2021 
ON [BodyLogic_Live].[dbo].[tbl_Distributor] ([PreferredLanguage], [UserStatus], [AccountType]) INCLUDE ([EmailAddress], [JoinDate]);

CREATE NONCLUSTERED INDEX IX_NN_tbl_Distributo_UserStatus_AccountType_Incl_3_12_2021 ON [BodyLogic_Live].[dbo].[tbl_Distributor] ([UserStatus], [AccountType]) INCLUDE ([PreferredLanguage], [EmailAddress], [JoinDate]);

CREATE NONCLUSTERED INDEX IX_NN_tbl_Distributor_PreferredLanguage_UserStatus_3_12_2021 ON [BodyLogic_Live].[dbo].[tbl_Distributor] ([PreferredLanguage], [UserStatus]) INCLUDE ([EmailAddress], [BirthDate]);
CREATE NONCLUSTERED INDEX IX_NN_tbl_Distributor_UserStatus_Incl_3_12_2021 ON [BodyLogic_Live].[dbo].[tbl_Distributor] ([UserStatus]) INCLUDE ([PreferredLanguage], [EmailAddress], [BirthDate]);

CREATE NONCLUSTERED INDEX IX_NN_Bl_Commissions_Bonus_TeamBonus_Temp_RunDate_RunSequence_Incl_3_12_2021 
ON [BodyLogic_Live].[dbo].[Bl_Commissions_Bonus_TeamBonus_Temp] ([RunDate], [RunSequence]) INCLUDE ([CommissionsPeriodId], [DistributorId], [TeamBonus], [RankId])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100) -- 0 secs; -- no A EXPRESS, no esta la tabla.

CREATE NONCLUSTERED INDEX IX_NN_PromoCodeProduct_PromoCodeID_Status_Incl_3_12_2021 ON [BodyLogic_Live].[dbo].[PromoCodeProduct] ([PromoCodeID], [Status]) INCLUDE ([ProductID])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100) -- 0 secs;; -- A EXPRESS

CREATE NONCLUSTERED INDEX IX_NN_Translation_Value_Incl_3_12_2021 
ON [BodyLogic_Live].[dbo].[Translation_Value] ([TranslationKeyId]) INCLUDE ([LanguageId], [TranslationValue])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100) -- 0 secs; -- A EXPRESS reusando un indice.

CREATE NONCLUSTERED INDEX IX_NN_Bl_Autoship_Distributor_Discounts_Incl_3_12_2021 
ON [BodyLogic_Live].[dbo].[Bl_Autoship_Distributor_Discounts] ([Status]) INCLUDE ([DistLegacyNumber])
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, ONLINE = on, FILLFACTOR = 100) -- 0 secs;

/*
END 3/12/2021
*/


*/


/*
	3/22/2021
*/

/*
Missing Index Details from ExecutionPlan1.sqlplan
The Query Processor estimates that implementing the following index could improve the query cost by 91.2934%.
*/

/* PARA EL FIN DE SEMANA:
USE [BodyLogic_Live]
GO
CREATE NONCLUSTERED INDEX X_NN_Commissions_Distributor_Temp_RunDate_RunSequence_AccountType_Incl_Comp_3_22_2021 
ON [dbo].[Commissions_Distributor_Temp] ([RunDate],[RunSequence],[AccountType])
INCLUDE ([DistributorId],[FirstName],[LastName],[MarketId],[ActiveTotalQv])
with(data_compression=page, online=on) --cpu al 100% 76 minutos. Ejecutarlo el fin de semana.
GO
*/

/*
	END	3/22/2021
*/


/*
	3/23/2021
*/

--CREATE NONCLUSTERED INDEX IX_NN_tbl_Orders_Header_Id_Incl_Comp_3_22_2021 
--ON [dbo].[tbl_Orders_Header] (ID)
--INCLUDE (DistributorID,LegacyNumber)
--with(data_compression=page, online=on) --5 segundos.


/*
	END 3/23/2021
*/


/*
	3/27/2021
*/
CREATE NONCLUSTERED INDEX [ix_nn_Folios_FolioNumber_Comp] 
ON [Lgt].[Folios] ([FolioNumber]) WITH (data_compression=page,ONLINE = ON) --1 segundo

/*
	END 3/23/2021
*/


/*
	3/28/2021
*/
--Appresource_Fix_Update_Sp --14.000 executions.
/*
Missing Index Details from ExecutionPlan1.sqlplan
The Query Processor estimates that implementing the following index could improve the query cost by 83.0189%.
*/

/*
CREATE NONCLUSTERED INDEX ix_nn_Resource_IsUpload_AplicationID_Incl_Comp_3_28_2021
ON [dbo].[Resource] ([IsUpload],[AplicationID])
INCLUDE ([FileExtension],[FilePublicName])
WITH (data_compression=page,ONLINE = ON) --segundos
GO
*/


/*
Missing Index Details from ExecutionPlan1.sqlplan
The Query Processor estimates that implementing the following index could improve the query cost by 66.232%.
*/

/*
USE [BodyLogic_Live]
GO
CREATE NONCLUSTERED INDEX ix_nn_tbl_Orders_Header_IsMigration_OrderDate_OrderStatus_SentToXipix_Incl_Comp_3_28_2021
ON [dbo].[tbl_Orders_Header] ([IsMigration],[OrderDate],[OrderStatus],[SentToXipix])
INCLUDE ([LegacyNumber],[DistributorID]) --2 segundos
GO
*/

CREATE NONCLUSTERED INDEX ix_nn_LoginHistory_SuccesLogin_UserId_SourceTableId_Incl_Comp_3_28_2021
ON [Sec].[LoginHistory] ([SuccesLogin],[UserId],[SourceTableId])
INCLUDE ([LoggedOnDate])
WITH (data_compression=page,ONLINE = ON) 
GO

CREATE NONCLUSTERED INDEX ix_nn_tbl_Distributor_EmailAddress_Comp_3_28_2021
ON [dbo].[tbl_Distributor] ([EmailAddress])
WITH (data_compression=page,ONLINE = ON)  --2 secs

CREATE NONCLUSTERED INDEX ix_nn_tbl_Log_Order_OrderID_Comp_3_28_2021
ON [dbo].[tbl_Log_Order] ([OrderID])
WITH (data_compression=page,ONLINE = ON)  --4 secs


CREATE NONCLUSTERED INDEX ix_nn_Commissions_Orders_Header_RunSequence_CommissionsPeriodId_Comp_Incl_3_28_2021
ON [dbo].[Commissions_Orders_Header] ([RunSequence],[CommissionsPeriodId])
INCLUDE ([OrderType],[DistributorId],[Cv],[OrderStatus],[MarketId])
WITH (data_compression=page,ONLINE = ON)  --5 secs
GO

CREATE NONCLUSTERED INDEX [Ix_tbl_Orders_Header_OrderDate_Incl_Comp_3_28_2021] ON [dbo].[tbl_Orders_Header]
(
	[OrderDate] DESC
)
INCLUDE([DistributorID]) 
WITH (data_compression=page,STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

/*
 end 3/28/2021
*/


