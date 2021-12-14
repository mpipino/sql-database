----APLICAR CUANDO MEJORE MAS LA PERFORMANCE
----CREATE NONCLUSTERED INDEX ix_NN_tbl_distributor_commissions_v2_LegacyNumber_Incl_Comp_4_X_2021
----ON [Asea_Prod].[dbo].[tbl_distributor_commissions_v2] ([LegacyNumber]) 
----INCLUDE ([Custom1], [Custom2], [Custom6], [ActiveTotalPV], [CommPeriodId], [TotalPV], [custom9], [custom10])
----WITH (ONLINE=ON,DATA_COMPRESSION=PAGE)

--CREATE NONCLUSTERED INDEX ix_NN_MaxCallSupport_TimeStamps_Maxcallsupportid_Incl_Comp ON [MaxCallSupport_TimeStamps] 
--([Maxcallsupportid]) 
--INCLUDE ([MaxCallSupportTimeStampsNote], [CreatedDate])
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); --2 secs

--CREATE NONCLUSTERED INDEX ix_NN_TBL_SVY_EMAILSURVEYLIST_DISTRIBUTORID_Incl_Comp_4_1_2021 
--ON [Asea_Prod].[dbo].[TBL_SVY_EMAILSURVEYLIST] ([DISTRIBUTORID]) 
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs


--CREATE NONCLUSTERED INDEX ix_NN_Notification_Distributor_NotificationId_Incl_Comp_4_1_2021 
--ON [Asea_Prod].[dbo].[Notification_Distributor] ([NotificationId], [DistributorId]) 
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

--CREATE NONCLUSTERED INDEX ix_NN_TBL_AUTOSHIPORDERS_HEADER_OrderStatus_SHIPPINGADDRESSID_Incl_Comp_4_1_2021 
--ON [Asea_Prod].[dbo].[TBL_AUTOSHIPORDERS_HEADER] ([OrderStatus], [SHIPPINGADDRESSID])  
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs


--CREATE NONCLUSTERED INDEX ix_NN_LoginHistory_LoginHistoryUsername_Comp_4_1_2021 
--ON [Asea_Prod].[Sec].[LoginHistory] ([LoginHistoryUsername], [LoggedOnDate])  
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 3 secs

--CREATE NONCLUSTERED INDEX ix_NN_LoginHistoryUsername__Incl_Comp_4_1_2021 
--ON [Asea_Prod].[Sec].[LoginHistory] ([LoginHistoryUsername], [LoggedOnDate])  
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 4 secs


--CREATE NONCLUSTERED INDEX ix_NN_TYPE_WAREHOUSEID_MARKETID_CARRIER_STATUS__PRICE_PRICE_NONAUTOSHIP_Incl_Comp_4_1_2021 
--ON [Asea_Prod].[dbo].[TBL_SHIPPINGRATES] ([TYPE], [WAREHOUSEID], [MARKETID], [CARRIER], [STATUS], [PRICE], [PRICE_NONAUTOSHIP]) 
--INCLUDE ([RANGE_END], [REGION], [ISNFRSHIPPING])
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs


--CREATE NONCLUSTERED INDEX ix_NN_MARKETID_STATUS_REGION_Incl_Comp_4_1_2021 
--ON [Asea_Prod].[dbo].[TBL_SHIPPINGRATES] ([MARKETID], [STATUS], [REGION]) 
--INCLUDE ([TYPE])
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs


--CREATE NONCLUSTERED INDEX ix_NN_EMAILTEMPLATEID_STATUS__Incl_Comp_4_1_2021 
--ON [Asea_Prod].[dbo].[TBL_LANGUAXTEMPLATES] ([EMAILTEMPLATEID], [STATUS], [LANGUAGEID])  
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

--CREATE NONCLUSTERED INDEX ix_NN_STATUS_Incl_Comp_4_1_2021 
--ON [Asea_Prod].[dbo].[TBL_LANGUAXTEMPLATES] ([STATUS], [LANGUAGEID]) 
--INCLUDE ([EMAILTEMPLATEID])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

--CREATE NONCLUSTERED INDEX ix_NN_LANGUAGEID_STATUS__Incl_Comp_4_1_2021 
--ON [Asea_Prod].[dbo].[TBL_LANGUAXTEMPLATES] ([LANGUAGEID], [STATUS]) 
--INCLUDE ([EMAILTEMPLATEID])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

--CREATE NONCLUSTERED INDEX ix_NN_EMAILTEMPLATEID_LANGUAGEID_STATUS_Incl_Comp_4_1_2021 
--ON [Asea_Prod].[dbo].[TBL_LANGUAXTEMPLATES] ([EMAILTEMPLATEID], [LANGUAGEID], [STATUS])  
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs


------------------
--/*
--USE [Asea_Prod]
--GO
--CREATE NONCLUSTERED INDEX ix_NN_PromoCodeProduct_ProductID_Incl_Comp_4_1_2021 
--ON [dbo].[PromoCodeProduct] ([PromoCodeID],[Status])
--INCLUDE ([ProductID])
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
--GO
--*/

--CREATE NONCLUSTERED INDEX ix_NN_Translation_Term_Detail_Language_TermDetailId_LanguageId_Incl_Comp_4_1_2021 
--ON [dbo].[Translation_Term_Detail_Language] ([TermDetailId],[LanguageId])
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
--GO

--CREATE NONCLUSTERED INDEX ix_NN_TBL_EVENTS_EVENTTYPE_STATUS_Incl_Comp_4_1_2021 
--ON [dbo].[TBL_EVENTS] ([EVENTTYPE],[STATUS])
--INCLUDE ([EVENTTITLE])
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
--GO

--CREATE NONCLUSTERED INDEX ix_NN_TBL_DISTRIBUTORS_NOTES_DISTRIBUTORID_STATUS_Comp_4_1_2021 
--ON [dbo].[TBL_DISTRIBUTORS_NOTES] ([DISTRIBUTORID],[STATUS])
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 3 secs

--CREATE NONCLUSTERED INDEX ix_NN_Distributor_TaxExempt_DistributorId_DistributorTaxStatus_Comp_4_1_2021 
--ON [Dst].[Distributor_TaxExempt] ([DistributorId],[DistributorTaxStatus])
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

--CREATE NONCLUSTERED INDEX ix_NN_TBL_CAMPAIGNSXTEMPLATES_MARKETID_Comp_4_1_2021 
--ON [dbo].[TBL_CAMPAIGNSXTEMPLATES] ([MARKETID])
--INCLUDE ([EMAILTEMPLATEID])
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

----APLICAR CUANDO MEJORE MAS LA PERFORMANCE
----CREATE NONCLUSTERED INDEX ix_NN_TBL_CAMPAIGNSXTEMPLATES_LegacyNumber_CommPeriodId_Incl_Comp_4_1_2021 
----ON [dbo].[tbl_distributor_commissions_v2] ([LegacyNumber],[CommPeriodId])
----INCLUDE ([Custom3],[TotalPV])
----WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); --  secs 47224 ejecuciones necesitaron este índice en los últimos 14 días.

--------


--CREATE NONCLUSTERED INDEX ix_NN_PegRate_Historic_CommPeriodId_marketid_currencycode_payout_Comp_4_1_2021 
--ON [dbo].[PegRate_Historic] ([CommPeriodId],[marketid],[currencycode],[payout])
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE);

--CREATE NONCLUSTERED INDEX ix_NN_TBL_SHIPPINGRATES_NEW_COUNTRYCODE_REGION_Incl_Comp_4_1_2021 
--ON [dbo].[TBL_SHIPPINGRATES_NEW] ([COUNTRYCODE],[REGION])
--INCLUDE ([ISNFRSHIPPING]) -- 0 secs

--CREATE NONCLUSTERED INDEX ix_NN_TBL_ADDRESSES_DISTRIBUTORID_STATUS_Incl_Comp_4_1_2021 
--ON [dbo].[TBL_ADDRESSES] ([DISTRIBUTORID],[STATUS])
--INCLUDE ([ADDRESSTYPE],[ADDRESS],[ADDRESS1],[CITY],[STATE],[ZIP],[COUNTY],[COUNTRY],[ADDRESS2],[ShipToName])
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); --53 secs mejora en un 90% mas de 17000 ejecuciones.
--GO


--CREATE NONCLUSTERED INDEX ix_NU_TBL_ORDERS_TRANSACTIONDETAILS_TRANSACTIONID_Comp_4_1_2021 
--ON [dbo].[TBL_ADDRESSES] ([DISTRIBUTORID],[STATUS])
--INCLUDE ([ADDRESSTYPE],[ADDRESS],[ADDRESS1],[CITY],[STATE],[ZIP],[COUNTY],[COUNTRY],[ADDRESS2],[ShipToName])
--WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); --13 secs mejora en un 90% [Sp_Orderheader_Getbyid_Xcorp_V2] con mas de 16000 ejecuciones. 658788.403 gross cost
--GO

--CREATE NONCLUSTERED INDEX ix_NN_PegRate_Historic_marketid_payout_CommPeriodId_currencycode_Comp_4_1_2021 
--ON [dbo].[PegRate_Historic] ([marketid], [payout], [CommPeriodId], [currencycode]) 
--WITH (ONLINE = ON,DATA_COMPRESSION=PAGE) -- Azure recomentation


--CREATE NONCLUSTERED INDEX ix_NN_PGVProjected_Detail_CommPeriodId_DistributorId_Comp_4_1_2021 
--ON [dbo].[PGVProjected_Detail] ([CommPeriodId], [DistributorId]) 
--WITH (ONLINE = ON,DATA_COMPRESSION=PAGE)  -- Azure recomentation. 0 Seconds


--CREATE NONCLUSTERED INDEX ix_NN_tbl_Leadership_Development_Pool_Downline_Temp_Incl_Comp_4_1_2021 
--ON [dbo].[tbl_Leadership_Development_Pool_Downline_Temp] ([PoolEnrollerId], [RunDate], [RunSequence], [DownlineLevel]) 
--INCLUDE ([CurrentPV]) WITH (ONLINE = ON,DATA_COMPRESSION=PAGE) -- 2 secs



--CREATE NONCLUSTERED INDEX ix_NN_MaxCallSupport_MaxCallSupportLegacynumber_Status_Comp_4_1_2021 
--ON [dbo].[MaxCallSupport] ([MaxCallSupportLegacynumber],[Status])
--WITH (ONLINE = ON,DATA_COMPRESSION=PAGE) -- 2 secs


--ALTER INDEX [IDX_Autoship_Projected_Profiles_MainDistributorId_RunSequence] 
--ON dbo.[tbl_Autoship_Projected_Profiles] REBUILD PARTITION = ALL WITH (online=on,FILLFACTOR = 100) 

--ALTER INDEX [IDX_Autoship_Projected_Profiles_MainRunsequence] ON dbo.[tbl_Autoship_Projected_Profiles] 
--REBUILD PARTITION = ALL WITH (online=on,FILLFACTOR = 100)  --160000 pages 47 secs



--CREATE NONCLUSTERED INDEX IDX_tbl_Orders_Header_OrderTotal_OrderStatus_ReleasedDate_Comp_4_1_2021 
--ON [dbo].[tbl_Orders_Header] ([OrderTotal],[OrderStatus],[ReleasedDate])
--INCLUDE ([CommValue],[MarketId],[CreatedDate],[CountryCode])
--WITH (ONLINE = ON,DATA_COMPRESSION=PAGE) -- 43 secs
--GO

--CREATE NONCLUSTERED INDEX ix_NN_tbl_Orders_HeaderOrderType_OrderType_Incl_Comp_4_1_2021 
--ON [dbo].[tbl_Orders_Header] ([OrderType])
--INCLUDE ([DistributorId],[QualVolume])
--WITH (ONLINE = ON,DATA_COMPRESSION=PAGE) -- 27 secs
--GO


--Ejecutar cuando se pueda
CREATE NONCLUSTERED INDEX ix_NN_tbl_distributor_commissions_v2_AccountType_CommPeriodId_Incl_Comp
 ON [dbo].[tbl_distributor_commissions_v2] ([AccountType], [CommPeriodId])
INCLUDE ([LegacyNumber], [rank10gv], [Rank10Gv_1], [rank11gv], [Rank11Gv_1], [Rank8Gv], [Rank8Gv_1], [rank9gv], [Rank9Gv_1]) 
WITH (FILLFACTOR=100, ONLINE=on, DATA_COMPRESSION=page); -- seconds
/*
The Query Processor estimates that implementing the following index could improve query cost (2.12257)
by 97.2066% for 291,238,423 executions of the query over the last 23 days.
*/
GO
