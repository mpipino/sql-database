

DROP INDEX  ix_NN_tbl_Orders_Header_InvoiceNo_LegacyNumber_Incl_Comp_4_12_2021 
--ON [dbo].[tbl_Orders_Header] --(InvoiceNo,LegacyNumber)
--INCLUDE --(ID,OrderDate,DistributorId,SubTotal,OrderTotal,OrderStatus)
--WITH --(ONLINE = ON,DATA_COMPRESSION=PAGE) -- 50 secs
--GO --https://tickets.xirect.com/issues/55579?issue_count=31&issue_position=16&next_issue_id=55576&prev_issue_id=55694

--4/16/2021
DROP INDEX  ix_NN_NotificationId_NotificationDetailClicked_NotificationDetailDistributorId__Incl_Comp_4_16_2021 
--ON [dbo].[NotificationDetail] --([NotificationId], [NotificationDetailClicked], [NotificationDetailDistributorId])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs


-- 8m 31s
DROP INDEX  ix_NN_LegacyNumber_Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([LegacyNumber], [CommPeriodId]) INCLUDE --([Custom3], [TotalPV])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_PromoCodeID_Status__Incl_Comp_4_16_2021 ON [dbo].[PromoCodeDetail] --([PromoCodeID], [Status])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RMAOrder_Incl_Comp_4_16_2021 ON [dbo].[tbl_Orders_Header] --([RMAOrder]) INCLUDE --([LegacyNumber], [OrderType], [OrderStatus])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
--DROP INDEX  ix_NN_RMAOrder_Incl_Comp_4_16_2021 ON [dbo].[tbl_Orders_Header] --([RMAOrder]) INCLUDE --([OrderType], [OrderTotal], [OrderStatus])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RMAOrder_Incl_Comp_4_16_2021 ON [dbo].[tbl_Orders_Header] --([RMAOrder]) INCLUDE --([OrderType], [TotlShippingCharged], [OrderStatus])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LegacyNumber__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([LegacyNumber]) INCLUDE --([Custom1], [Custom2], [Custom6], [ActiveTotalPV], [CommPeriodId], [TotalPV], [custom9], [custom10])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LANGUAGEID_ALERTID_STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_ALERTSYSTEM_LANGUAGE] --([LANGUAGEID], [ALERTID], [STATUS])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_NotificationViewOptionId__Incl_Comp_4_16_2021 ON [dbo].[Notification] --([NotificationViewOptionId]) INCLUDE --([NotificationPriority])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_PARENTID_APPID_STATUS__Incl_Comp_4_16_2021 ON [dbo].[RightsManagement_NavSettings] --([PARENTID], [APPID], [STATUS])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_APPID__Incl_Comp_4_16_2021 ON [dbo].[RightsManagement_NavSettings] --([APPID], [URL])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS_ISTOPEVENT_CREATEDBYTYPE__Incl_Comp_4_16_2021 ON [dbo].[TBL_EVENTS] --([STATUS], [ISTOPEVENT], [CREATEDBYTYPE]) INCLUDE --([EVENTTITLE], [CREATEDBY], [STARTDATE], [HOMEPOSITIONID], [FILEPUBLICNAME], [ATTACHMENTRESOURCE2])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_DISTRIBUTORID_OrderStatus__Incl_Comp_4_16_2021 ON [dbo].[TBL_AUTOSHIPORDERS_HEADER] --([DISTRIBUTORID], [OrderStatus])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_Sponsor_Dist_ID__Incl_Comp_4_16_2021 ON [dbo].[tbl_dthed_challengelist_detail] --([Sponsor-Dist-ID])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

--6m 56s
DROP INDEX  ix_NN_DISPLAYINSHOPPINGCART_STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_PRODUCTS] --([DISPLAYINSHOPPINGCART], [STATUS], [ForceAutoship]) INCLUDE --([ISASSOCIATE], [ISPREFERREDCUSTOMER], [ISRETAILCUSTOMER], [MAXDAYSAFTERENROLLMENT], [EXTENDEDFASTSTART])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderBackOrderStatus__Incl_Comp_4_16_2021 ON [dbo].[Order_BackOrders] --([OrderBackOrderStatus]) INCLUDE --([OrderId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderId_OrderBackOrderStatus__Incl_Comp_4_16_2021 ON [dbo].[Order_BackOrders] --([OrderId], [OrderBackOrderStatus])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS_IS_FOR_VIRTUAL_OFFICE__Incl_Comp_4_16_2021 ON [dbo].[TBL_FILE_MASTER] --([STATUS], [IS_FOR_VIRTUAL_OFFICE], [TAGS]) INCLUDE --([NAME], [DESCRIPTION], [VIRTUAL_LOCATION], [TYPE], [PRIMARYTITLE], [EXTERNALURL])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LegacyNumber__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([LegacyNumber]) INCLUDE --([PaidAsRank], [Custom1], [Custom2], [Incoming_Left_Vol], [Incoming_Right_Vol], [CommPeriodId], [TotalPV], [PGV3], [pgv])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderSource_isorder__Incl_Comp_4_16_2021 ON [dbo].[TBL_AUTOSHIPORDERS_HEADER] --([OrderSource], [isorder]) INCLUDE --([DISTRIBUTORID])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LegacyNumber__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([LegacyNumber], [CommPeriodId]) INCLUDE --([TotalDownlineLeft], [TotalDownlineRight], [newEnrollLeft], [newEnrollRight], [activeLeft], [activeRight], [autoshipLeft], [autoshipRight], [BinaryLeftPrefCustomers], [BinaryRightPrefCustomers], [EnrollmentPrefCustomers])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LegacyNumber__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([LegacyNumber], [CommPeriodId]) INCLUDE --([Custom1], [Custom2], [Incoming_Left_Vol], [Incoming_Right_Vol], [TotalPV], [WEEKGV], [PGV3], [pgv], [avg2WeekLeft], [avg2WeekRight], [avg3WeekLeft], [avg3WeekRight])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LegacyNumber__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([LegacyNumber], [CommPeriodId]) INCLUDE --([PaidAsRank], [EndRank], [Dir300_1_Count], [TotalDownlineLeft], [TotalDownlineRight], [newPersonalEnrollments], [newEnrollLeft], [newEnrollRight])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_FILEID_STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_FILE_LANGUAGE] --([FILEID], [STATUS]) INCLUDE --([LANGUAGEID])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_FILE_LANGUAGE] --([STATUS]) INCLUDE --([LANGUAGEID], [FILEID])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS_IS_FOR_VIRTUAL_OFFICE__Incl_Comp_4_16_2021 ON [dbo].[TBL_FILE_MASTER] --([STATUS], [IS_FOR_VIRTUAL_OFFICE]) INCLUDE --([EXTENSION], [DESCRIPTION], [VIRTUAL_LOCATION], [TYPE], [PRIMARYTITLE], [EXTERNALURL], [IS_PREFERRED_CUSTOMER], [SECONDARYTITLE])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_NotificationId__Incl_Comp_4_16_2021 ON [dbo].[NotificationDetail] --([NotificationId]) INCLUDE --([NotificationDetailUserId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_ID__Incl_Comp_4_16_2021 ON [dbo].[Tbl_Productchilditems] --([ID])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_PRODUCTCHILDITEMID__Incl_Comp_4_16_2021 ON [dbo].[Tbl_Productchilditems] --([PRODUCTCHILDITEMID])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_PARENTID_APPID__Incl_Comp_4_16_2021 ON [dbo].[RightsManagement_NavSettings] --([PARENTID], [APPID])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderSource_isorder__Incl_Comp_4_16_2021 ON [dbo].[TBL_AUTOSHIPORDERS_HEADER] --([OrderSource], [isorder]) INCLUDE --([DISTRIBUTORID], [Price2])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_AccountType_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([AccountType], [CommPeriodId]) INCLUDE --([LegacyNumber], [rank9gv], [rank10gv], [rank11gv], [Rank8Gv], [Rank9Gv_1], [Rank10Gv_1], [Rank11Gv_1], [Rank8Gv_1])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

-- 13 minutes.
DROP INDEX  ix_NN_OrderStatus_WarehouseId_SentTo__Incl_Comp_4_16_2021 ON [dbo].[tbl_Orders_Header] --([OrderStatus], [WarehouseId], [SentTo], [DATEPRINTED]) INCLUDE --([LegacyNumber])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS_CAMPAIGNSID__Incl_Comp_4_16_2021 ON [dbo].[TBL_EMAILTEMPLATEMANAGMENT] --([STATUS], [CAMPAIGNSID])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_DistributorLegacyNumber_SingleSignOn_Status__Incl_Comp_4_16_2021 ON [Dst].[Distributor_SingleSignOn] --([DistributorLegacyNumber], [SingleSignOn], [Status])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_AccountType_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([AccountType], [CommPeriodId]) INCLUDE --([LegacyNumber], [EnrollerId], [BinarySponsorId], [SponsorSequence])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderStatus__BILLINGADDRESSID__Incl_Comp_4_16_2021 ON [dbo].[TBL_AUTOSHIPORDERS_HEADER] --([OrderStatus], [BILLINGADDRESSID], [ID])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderId__Status__Incl_Comp_4_16_2021 ON [dbo].[Events_Ticket_OrderDetail] --([OrderId], [Status], [EventTicketUnassigned])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_AccountType__Incl_Comp_4_16_2021 ON [dbo].[tbl_Distributor_Commissions_Temp_v2] --([AccountType]) INCLUDE --([DistributorId], [EnrollerId], [BinarySponsorId], [Custom4], [SponsorSequence], [IsPvActive])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_AccountType__IsPvActive__Incl_Comp_4_16_2021 ON [dbo].[tbl_Distributor_Commissions_Temp_v2] --([AccountType], [IsPvActive]) INCLUDE --([EnrollerId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CustomerId_LegacyNumber_MerchantAccount__Incl_Comp_4_16_2021 ON [dbo].[Log_Api_BraintreeCustomer] --([CustomerId], [LegacyNumber], [MerchantAccount])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_DistributorStatus_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([DistributorStatus], [CommPeriodId]) INCLUDE --([LegacyNumber], [MARKETID], [DIRECTOR_BONUS])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_AccountType__Incl_Comp_4_16_2021 ON [dbo].[tbl_Distributor_Commissions_Temp_v2] --([AccountType]) INCLUDE --([ActiveTotalPV], [TotalPV], [TotalPV4Weeks], [TotalPV3Weeks], [TotalPV2Weeks], [ActiveMinPv])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_MarketId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Orders_Header] --([MarketId], [OrderTotal], [OrderStatus], [ReleasedDate]) INCLUDE --([CountryCode])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_AccountType__Incl_Comp_4_16_2021 ON [dbo].[tbl_Distributor_Commissions_Temp_v2] --([AccountType]) INCLUDE --([DistributorId], [TotalCV])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_ActionID_STATUS__Incl_Comp_4_16_2021 ON [dbo].[tbl_AdjustmentsCQT] --([ActionID], [STATUS], [BeginCommPeriodId]) INCLUDE --([DISTRIBUTORID], [EndCommPeriodId], [ActionValue])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_MarketId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Orders_Header] --([MarketId], [OrderTotal], [OrderStatus], [ReleasedDate]) INCLUDE --([CommValue], [CreatedDate], [CountryCode])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS__Incl_Comp_4_16_2021 ON [dbo].[RightsManagement_NavSettings] --([STATUS]) INCLUDE --([PARENTID])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS__Incl_Comp_4_16_2021 ON [dbo].[RightsManagement_NavSettings_Users] --([STATUS]) INCLUDE --([NAVSETTINGID], [RolesNavSettingsAccessView], [RolesNavSettingsAccessEdit], [RolesId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_MARKETID_STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_ALERTSYSTEM_MARKET] --([MARKETID], [STATUS]) INCLUDE --([ALERTID])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_DistributorId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Loyalty_Rewards_Program_Redemption] --([DistributorId])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_DistributorId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Loyalty_Rewards_Program_Redemption] --([DistributorId]) INCLUDE --([orderId], [LoyaltyPoint_Redemption], [order-date], [CreatedDate], [ordernumber])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs



DROP INDEX  ix_NN_STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_EMAILTEMPLATEMANAGMENT] --([STATUS]) INCLUDE --([CAMPAIGNSID])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_DistributorID__Incl_Comp_4_16_2021 ON [dbo].[AseaI_Promotion_PPP2020_PGV3_Tbl] --([DistributorID]) INCLUDE --([PerkLevelEarned_LE], [BasisPGV3_LE], [PromoPGV3_LE])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_DistributorID__Incl_Comp_4_16_2021 ON [dbo].[AseaI_Promotion_PPP2020_PaidAtRank_Tbl] --([DistributorID], [CommPeriodID])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CURRENCYCODE_PEGRATE__Incl_Comp_4_16_2021 ON [dbo].[tbl_Distributor_Commissions_Temp_v2] --([CURRENCYCODE], [PEGRATE])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CountryCodeSession__Incl_Comp_4_16_2021 ON [dbo].[tbl_promotion_fastforward_history] --([Country-Code-Session]) INCLUDE --([Dist-ID-Session], [Session], [Dist-ID], [PV-Amount])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommperiodID_RunSequence__Incl_Comp_4_16_2021 ON [dbo].[LosingActivity_Detail_Temp] --([CommperiodID], [RunSequence]) INCLUDE --([Maindistributorid], [DisqualificationDate], [DistributorID], [Name], [LifetimeRankID], [Email], [Mobile], [LastOrderDate], [LastActivityOrderPV], [LoyaltyRewardsPoints], [ResponsibleLeader], [LeaderID], [LeaderEmail], [LeaderMobile])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommperiodId_Runsequence__Incl_Comp_4_16_2021 ON [dbo].[LosingActivity_Temp] --([CommperiodId], [Runsequence]) INCLUDE --([DistributorId], [EnrollerId], [PVAmount])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommperiodId__Incl_Comp_4_16_2021 ON [dbo].[LosingActivity_Temp] --([CommperiodId]) INCLUDE --([Runsequence])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommperiodID__Incl_Comp_4_16_2021 ON [dbo].[LosingActivity_Detail] --([CommperiodID])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommperiodID_RunSequence_Maindistributorid__Incl_Comp_4_16_2021 ON [dbo].[LosingActivity_Detail_Temp] --([CommperiodID], [RunSequence], [Maindistributorid]) INCLUDE --([LastActivityOrderPV])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_DISTRIBUTORID__Incl_Comp_4_16_2021 ON [dbo].[TBL_FANFARE_DATA] --([DISTRIBUTORID]) INCLUDE --([IMAGE], [STORY], [STORYFULL], [TITLE], [FileId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_FANFARE_STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_EXCLUSSIONS] --([FANFARE], [STATUS], [FROMDATE], [TODATE]) INCLUDE --([DISTRIBUTORID])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
-- IMPORTANTE ESTE MEJORARIA Sp_Xc_Calculate_Commissions_V2 EN UN 95% DROP INDEX  ix_NN_CommPeriodId_DirectorBonusPaid__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([CommPeriodId], [DirectorBonusPaid]) INCLUDE --([LegacyNumber])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_BinarySponsorId__CommPeriodId_SponsorSequence__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([BinarySponsorId], [CommPeriodId], [SponsorSequence]) INCLUDE --([LegacyNumber])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([CommPeriodId]) INCLUDE --([AccountType], [LegacyNumber], [EnrollerId], [DistributorStatus], [BinarySponsorId], [SponsorSequence])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([CommPeriodId]) INCLUDE --([LegacyNumber], [Custom1], [Custom2], [Custom4], [Custom6], [ActiveTotalPV], [Incoming_Left_Vol], [Incoming_Right_Vol], [PGV3], [total_left_leg], [total_right_leg], [UplineBronze], [UplineGold], [UplineDiamond])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs


--11 minutes.
DROP INDEX  ix_NN_AccountType__CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([AccountType], [CommPeriodId]) INCLUDE --([LegacyNumber], [EnrollerId], [PaidAsRank], [LifetimeRankId], [ActiveTotalPV], [ovr_ActiveTotalPV])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_WareTwoGoMethod_OrdersId__Incl_Comp_4_16_2021 ON [dbo].[ShippingWareTwoGo] --([WareTwoGoMethod], [OrdersId])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_WareTwoGoMethod__Incl_Comp_4_16_2021 ON [dbo].[ShippingWareTwoGo] --([WareTwoGoMethod]) INCLUDE --([OrdersId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_ReadyShipperMethod_OrdersId__Incl_Comp_4_16_2021 ON [dbo].[ShippingReadyShipper] --([ReadyShipperMethod], [OrdersId])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_ReadyShipperMethod__Incl_Comp_4_16_2021 ON [dbo].[ShippingReadyShipper] --([ReadyShipperMethod]) INCLUDE --([OrdersId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_ApiLandmarkWebService_OrderId__Incl_Comp_4_16_2021 ON [dbo].[ApiLandmark] --([ApiLandmarkWebService], [OrderId])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_ApiLandmarkWebService__Incl_Comp_4_16_2021 ON [dbo].[ApiLandmark] --([ApiLandmarkWebService]) INCLUDE --([OrderId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_AccountType_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([AccountType], [CommPeriodId]) INCLUDE --([LegacyNumber], [EnrollerId], [PaidAsRank], [ActiveTotalPV], [ovr_ActiveTotalPV])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderNumber__Incl_Comp_4_16_2021 ON [dbo].[Tbl_Invoice_PayNow] --([OrderNumber])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

select    
      sum--(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats

--
DROP INDEX  ix_NN_CommPeriodId__BonusRecipientId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Bonus_Promo_1_v2] --([CommPeriodId], [BonusRecipientId])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_BonusRecipientId_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Bonus_Matching_v2] --([BonusRecipientId], [CommPeriodId]) INCLUDE --([DISTRIBUTORID], [cmadjustment], [BonusAmount], [CHECKMATCHPOOL], [pegrate], [bonusAmountValue], [generation])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId_BonusRecipientId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Bonus_Fast_Start_Italy_v2] --([CommPeriodId], [BonusRecipientId])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderId__Incl_Comp_4_16_2021 ON [dbo].[Events_Ticket_OrderDetail] --([OrderId], [EventTicketUnassigned])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderStatus_BILLINGADDRESSID__Incl_Comp_4_16_2021 ON [dbo].[TBL_AUTOSHIPORDERS_HEADER] --([OrderStatus], [BILLINGADDRESSID])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_DIST_ID__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_temp] --([DIST_ID]) INCLUDE --([Normal_Bronze_End_PeriodId], [Normal_Silver_End_PeriodId], [Normal_Gold_End_PeriodId], [Normal_Platinum_End_PeriodId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS__Incl_Comp_4_16_2021 ON [dbo].[tbl_AdjustmentsCQT] --([STATUS], [ActionID]) INCLUDE --([DISTRIBUTORID], [EndCommPeriodId], [BeginCommPeriodId], [Retired])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate__RunSequence__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_temp] --([RunDate], [RunSequence]) INCLUDE --([DIST_ID], [Normal_Bronze_Start_PeriodId], [Normal_Silver_Start_PeriodId], [Normal_Gold_Start_PeriodId], [Normal_Platinum_Start_PeriodId], [Normal_Bronze_End_PeriodId], [Normal_Silver_End_PeriodId], [Normal_Gold_End_PeriodId], [Normal_Platinum_End_PeriodId], [terminated])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool] --([CommPeriodId]) INCLUDE --([PV_DATE], [DIST_ID], [PaidPeriod_Rank], [Fast_Track_Bronze_Start_PeriodId], [Fast_Track_Silver_Start_PeriodId], [Fast_Track_Gold_Start_PeriodId], [Fast_Track_Platinum_Start_PeriodId], [Fast_Track_Bronze_End_PeriodId], [Fast_Track_Silver_End_PeriodId], [Fast_Track_Gold_End_PeriodId], [Fast_Track_Platinum_End_PeriodId], [Company_Period_Final_Weekly_ShareValue], [Normal_Bronze_Unlocked], [Normal_Silver_Unlocked], [Normal_Gold_Unlocked], [Normal_Platinum_Unlocked], [Fast_Bronze_Unlocked], [Fast_Silver_Unlocked], [Fast_Gold_Unlocked], [Fast_Platinum_Unlocked], [Normal_Platinum_Qualified], [Fast_Bronze_Qualified], [Fast_Silver_Qualified], [Fast_Gold_Qualified], [Fast_Platinum_Qualified], [Fast_Qualifying_Perc], [CreatedDate])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate_RunSequence_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_temp] --([RunDate], [RunSequence], [CommPeriodId]) INCLUDE --([PV_DATE], [DIST_ID], [Entry-Date], [Lifetime_Rank], [PaidPeriod_Rank], [LesserLeg_Vol], [Weekly_PGV3], [Total_PGV3], [Weekly_PGV3_XSS], [Weekly_PGV3_Total], [Weekly_Shares], [Total_Shares], [Normal_Bronze_Start_PeriodId], [Normal_Silver_Start_PeriodId], [Normal_Gold_Start_PeriodId], [Normal_Platinum_Start_PeriodId], [Company_Period_Weekly_GV], [Company_Period_Weekly_3Perc], [Company_Period_Weekly_Shares], [Company_Period_Weekly_ShareValue], [Normal_Bronze_End_PeriodId], [Normal_Silver_End_PeriodId], [Normal_Gold_End_PeriodId], [Normal_Platinum_End_PeriodId], [Normal_Bronze_Unlocked], [Normal_Silver_Unlocked], [Normal_Gold_Unlocked], [Normal_Platinum_Unlocked], [Normal_Bronze_Qualified], [Normal_Silver_Qualified], [Normal_Gold_Qualified], [Normal_Platinum_Qualified], [Normal_Qualifying_Perc], [Weekly_PGV3_IFTX], [Weekly_Shares_IFTX], [terminated])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS__Incl_Comp_4_16_2021 ON [dbo].[tbl_AdjustmentsCQT] --([STATUS], [ActionID]) INCLUDE --([DISTRIBUTORID], [EndCommPeriodId], [BeginCommPeriodId], [Retired], [ActionField], [ActionValue])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate_RunSequence_Lifetime_Rank__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_temp] --([RunDate], [RunSequence], [Lifetime_Rank]) INCLUDE --([PV_DATE], [CommPeriodId], [DIST_ID], [Entry-Date], [PaidPeriod_Rank], [LesserLeg_Vol], [Weekly_PGV3], [Weekly_PGV3_XSS], [Weekly_Shares], [Normal_Bronze_Start_PeriodId], [Normal_Silver_Start_PeriodId], [Normal_Gold_Start_PeriodId], [Normal_Platinum_Start_PeriodId], [Fast_Track_Bronze_Start_PeriodId], [Fast_Track_Silver_Start_PeriodId], [Fast_Track_Gold_Start_PeriodId], [Fast_Track_Platinum_Start_PeriodId], [Fast_Track_Bronze_End_PeriodId], [Fast_Track_Silver_End_PeriodId], [Fast_Track_Gold_End_PeriodId], [Fast_Track_Platinum_End_PeriodId], [Company_Period_Weekly_GV], [Company_Period_Weekly_3Perc], [Company_Period_Weekly_Shares], [Company_Period_Weekly_ShareValue], [Normal_Bronze_End_PeriodId], [Normal_Silver_End_PeriodId], [Normal_Gold_End_PeriodId], [Normal_Platinum_End_PeriodId], [Normal_Bronze_Unlocked], [Fast_Bronze_Unlocked], [Normal_Silver_Unlocked], [Fast_Silver_Unlocked], [Normal_Gold_Unlocked], [Fast_Gold_Unlocked], [Normal_Platinum_Unlocked], [Fast_Platinum_Unlocked], [Normal_Bronze_Qualified], [Normal_Silver_Qualified], [Normal_Gold_Qualified], [Normal_Platinum_Qualified], [Fast_Bronze_Qualified], [Fast_Silver_Qualified], [Fast_Gold_Qualified], [Fast_Platinum_Qualified], [Normal_Qualifying_Perc], [Fast_Qualifying_Perc], [Weekly_PGV3_IFTX], [Weekly_Shares_IFTX])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate_RunSequence__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_temp] --([RunDate], [RunSequence]) INCLUDE --([PV_DATE], [CommPeriodId], [DIST_ID], [Entry-Date], [Lifetime_Rank], [PaidPeriod_Rank], [LesserLeg_Vol], [Weekly_PGV3], [Weekly_PGV3_XSS], [Weekly_Shares], [Normal_Bronze_Start_PeriodId], [Normal_Silver_Start_PeriodId], [Normal_Gold_Start_PeriodId], [Normal_Platinum_Start_PeriodId], [Fast_Track_Bronze_Start_PeriodId], [Fast_Track_Silver_Start_PeriodId], [Fast_Track_Gold_Start_PeriodId], [Fast_Track_Platinum_Start_PeriodId], [Fast_Track_Bronze_End_PeriodId], [Fast_Track_Silver_End_PeriodId], [Fast_Track_Gold_End_PeriodId], [Fast_Track_Platinum_End_PeriodId], [Company_Period_Weekly_GV], [Company_Period_Weekly_3Perc], [Company_Period_Weekly_Shares], [Company_Period_Weekly_ShareValue], [Normal_Bronze_End_PeriodId], [Normal_Silver_End_PeriodId], [Normal_Gold_End_PeriodId], [Normal_Platinum_End_PeriodId], [Normal_Bronze_Unlocked], [Fast_Bronze_Unlocked], [Normal_Silver_Unlocked], [Fast_Silver_Unlocked], [Normal_Gold_Unlocked], [Fast_Gold_Unlocked], [Normal_Platinum_Unlocked], [Fast_Platinum_Unlocked], [Normal_Bronze_Qualified], [Normal_Silver_Qualified], [Normal_Gold_Qualified], [Normal_Platinum_Qualified], [Fast_Bronze_Qualified], [Fast_Silver_Qualified], [Fast_Gold_Qualified], [Fast_Platinum_Qualified], [Normal_Qualifying_Perc], [Fast_Qualifying_Perc], [Weekly_PGV3_IFTX], [Weekly_Shares_IFTX])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate_RunSequence__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_temp] --([RunDate], [RunSequence]) INCLUDE --([Weekly_Shares])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate_RunSequence__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_temp] --([RunDate], [RunSequence], [DIST_ID]) INCLUDE --([Weekly_PGV3_XSS], [Normal_Qualifying_Perc], [terminated])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate_RunSequence_CommPeriodId_PaidPeriod_Rank__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_temp] --([RunDate], [RunSequence], [CommPeriodId], [PaidPeriod_Rank])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Orders_Header] --([CommPeriodId], [OrderStatus]) INCLUDE --([Custom4])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate_RunSequence__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_temp] --([RunDate], [RunSequence]) INCLUDE --([Normal_Gold_Start_PeriodId], [Normal_Platinum_Start_PeriodId], [Normal_Gold_End_PeriodId], [Normal_Platinum_End_PeriodId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate_RunSequence__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_temp] --([RunDate], [RunSequence]) INCLUDE --([Normal_Silver_Start_PeriodId], [Normal_Gold_Start_PeriodId], [Normal_Silver_End_PeriodId], [Normal_Gold_End_PeriodId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate_RunSequence__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_temp] --([RunDate], [RunSequence]) INCLUDE --([Normal_Bronze_Start_PeriodId], [Normal_Silver_Start_PeriodId], [Normal_Bronze_End_PeriodId], [Normal_Silver_End_PeriodId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate_RunSequence__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_temp] --([RunDate], [RunSequence]) INCLUDE --([DIST_ID], [PaidPeriod_Rank], [Normal_Bronze_Start_PeriodId], [Normal_Silver_Start_PeriodId], [Normal_Gold_Start_PeriodId], [Normal_Platinum_Start_PeriodId], [Normal_Bronze_End_PeriodId], [Normal_Silver_End_PeriodId], [Normal_Gold_End_PeriodId], [Normal_Platinum_End_PeriodId], [terminated])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate_RunSequence__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_temp] --([RunDate], [RunSequence]) INCLUDE --([DIST_ID], [Entry-Date], [LesserLeg_Vol], [Weekly_Shares], [Total_Shares], [Normal_Bronze_Start_PeriodId], [Normal_Silver_Start_PeriodId], [Normal_Gold_Start_PeriodId], [Normal_Platinum_Start_PeriodId], [Fast_Track_Bronze_Start_PeriodId], [Fast_Track_Silver_Start_PeriodId], [Fast_Track_Gold_Start_PeriodId], [Fast_Track_Platinum_Start_PeriodId], [Fast_Track_Bronze_End_PeriodId], [Fast_Track_Silver_End_PeriodId], [Fast_Track_Gold_End_PeriodId], [Fast_Track_Platinum_End_PeriodId], [Company_Period_Weekly_GV], [Company_Period_Weekly_3Perc], [Company_Period_Weekly_Shares], [Company_Period_Weekly_ShareValue], [Normal_Bronze_End_PeriodId], [Normal_Silver_End_PeriodId], [Normal_Gold_End_PeriodId], [Normal_Platinum_End_PeriodId], [Normal_Bronze_Unlocked], [Fast_Bronze_Unlocked], [Normal_Silver_Unlocked], [Fast_Silver_Unlocked], [Normal_Gold_Unlocked], [Fast_Gold_Unlocked], [Normal_Platinum_Unlocked], [Fast_Platinum_Unlocked], [Normal_Bronze_Qualified], [Normal_Silver_Qualified], [Normal_Gold_Qualified], [Normal_Platinum_Qualified], [Fast_Bronze_Qualified], [Fast_Silver_Qualified], [Fast_Gold_Qualified], [Fast_Platinum_Qualified], [Fast_Qualifying_Perc], [Weekly_Shares_IFTX], [terminated], [init_lifetimerank_rank])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([CommPeriodId], [LegacyNumber], [EnrollerId], [PaidAsRank]) INCLUDE --([StartRank], [EndRank], [PGV3])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId_RunDate_RunSequence__DistributorId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Leadership_Development_Pool_Rank_Achievements_Temp] --([CommPeriodId], [RunDate], [RunSequence], [DistributorId]) INCLUDE --([NewRankId], [ConsecutiveWeeks], [ConsecutiveWeeks_13], [ConsecutiveWeeks_14], [ConsecutiveWeeks_15], [ConsecutiveWeeks_16], [ConsecutiveWeeks_17])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__RunDate__RunSequence__DistributorId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Leadership_Development_Pool_Rank_Achievements_Temp] --([CommPeriodId], [RunDate], [RunSequence], [DistributorId]) INCLUDE --([CurrentPGV], [CurrentPGV_Capped], [CurrentPGV_Capped_12], [CurrentPGV_Capped_13], [CurrentPGV_Capped_14], [CurrentPGV_Capped_15], [CurrentPGV_Capped_16], [CurrentPGV_Capped_17])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool] --([CommPeriodId], [Weekly_Shares])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__RunDate__RunSequence__Incl_Comp_4_16_2021 ON [dbo].[tbl_Leadership_Development_Pool_Rank_Achievements_Temp] --([CommPeriodId], [RunDate], [RunSequence]) INCLUDE --([DistributorId], [CurrentPGV], [CappedAmount], [CurrentPGV_Capped], [NewRankId], [ConsecutiveWeeks], [OriginalPGV], [Expiration_CommPeriodId], [Original_PaidAsRankId], [ConsecutiveWeeks_13], [ConsecutiveWeeks_14], [ConsecutiveWeeks_15], [ConsecutiveWeeks_16], [ConsecutiveWeeks_17], [CurrentPGV_Capped_12], [CurrentPGV_Capped_13], [CurrentPGV_Capped_14], [CurrentPGV_Capped_15], [CurrentPGV_Capped_16], [CurrentPGV_Capped_17])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs


--20 minutes
DROP INDEX  ix_NN_EnrollerId__CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([EnrollerId], [CommPeriodId]) INCLUDE --([LegacyNumber], [FirstName], [LastName], [PaidAsRank], [pgv])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([CommPeriodId], [PaidAsRank]) INCLUDE --([LegacyNumber], [EnrollerId], [EndRank])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__RunDate__RunSequence_ConsecutiveWeeks__Incl_Comp_4_16_2021 ON [dbo].[tbl_Leadership_Development_Pool_Rank_Achievements_Temp] --([CommPeriodId], [RunDate], [RunSequence], [ConsecutiveWeeks])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__RunDate__RunSequence__Incl_Comp_4_16_2021 ON [dbo].[tbl_Leadership_Development_Pool_Rank_Achievements_Temp] --([CommPeriodId], [RunDate], [RunSequence]) INCLUDE --([DistributorId], [CurrentPGV], [CurrentPGV_Capped], [NewRankId], [ConsecutiveWeeks], [OriginalPGV], [Original_PaidAsRankId], [ConsecutiveWeeks_13], [ConsecutiveWeeks_14], [ConsecutiveWeeks_15], [ConsecutiveWeeks_16], [ConsecutiveWeeks_17], [CurrentPGV_Capped_12], [CurrentPGV_Capped_13], [CurrentPGV_Capped_14], [CurrentPGV_Capped_15], [CurrentPGV_Capped_16], [CurrentPGV_Capped_17])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__RunDate__RunSequence__Incl_Comp_4_16_2021_2 ON [dbo].[tbl_Leadership_Development_Pool_Rank_Achievements_Temp] --([CommPeriodId], [RunDate], [RunSequence]) INCLUDE --([NewRankId], [ConsecutiveWeeks], [Original_PaidAsRankId], [ConsecutiveWeeks_13], [ConsecutiveWeeks_14], [ConsecutiveWeeks_15], [ConsecutiveWeeks_16], [ConsecutiveWeeks_17])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__RunDate__RunSequence__NewRankId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Leadership_Development_Pool_Rank_Achievements_Temp] --([CommPeriodId], [RunDate], [RunSequence], [NewRankId]) INCLUDE --([DistributorId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([CommPeriodId], [PaidAsRank]) INCLUDE --([LegacyNumber], [pgv])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([CommPeriodId]) INCLUDE --([AccountType], [LegacyNumber], [IsTaxExempt], [CurrencyCode], [EnrollerId], [JoinDate], [PaidAsRank], [LifetimeRankId], [CREATEDDATE], [MARKETID], [BinarySponsorId], [JoinCommPeriodId], [TotalCV], [Custom1], [Custom2], [Custom6], [ActiveTotalPV], [TotalPV], [EndRank], [Dir300_1_Count], [WEEKGV], [PGV50], [custom9], [custom10], [SponsorSequence], [RETAIL_COMMISSIONS], [PREF_CUST_BONUS], [FAST_START_BONUS], [FAST_START_GBR_IRL_BONUS], [FAST_START_ITALY_BONUS], [CHECK_MATCH], [TOTAL_COMMISSIONS], [RETAIL_COMMISSIONS_VALUE], [PREF_CUST_BONUS_VALUE], [FAST_START_BONUS_VALUE], [FAST_START_GBR_IRL_BONUS_VALUE], [FAST_START_ITALY_BONUS_VALUE], [CHECK_MATCH_VALUE], [TOTAL_COMMISSIONS_VALUE], [DiamPool_Bonus], [DiamPool_Bonus_value], [AccountAdjustment_bonus], [AccountAdjustment_bonus_value], [POOL_COMMISSIONS], [POOL_COMMISSIONS_Value], [Entrep_Bonus], [Entrep_Bonus_value], [EMP_bonus], [EMP_bonus_value], [Weak-2-weeks], [Weak-3-weeks], [Rnk9-gv-2weeks], [Rnk10-gv-3weeks], [Rnk11-gv-3weeks], [rank9gv], [rank10gv], [rank11gv], [Rank8Gv], [Rank8Gv_1], [forcedrank], [PERIOD_LEFT_VOL], [PERIOD_RIGHT_VOL], [STATUS], [promo_bonus], [promo_bonus_value], [d700_count], [gold_count], [achievedrankdate], [hold_bonus], [GROSS_COMMISSIONS], [GROSS_COMMISSIONS_VALUE], [EnrollerOrgWeak300], [IsPvActive])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_REPLICATEDSITE__Incl_Comp_4_16_2021 ON [dbo].[TBL_DISTRIBUTOR] --([REPLICATEDSITE]) INCLUDE --([LEGACYNUMBER], [FIRSTNAME], [MIDDLENAME], [LASTNAME], [CompanyName], [LifetimeRankId], [RECOGNITIONNAME], [DISPLAYNAME])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_Year_Next_Month_Next_Day_Next__Incl_Comp_4_16_2021 ON [dbo].[tbl_Autoship_Projected_Other_Autoships] --([Year_Next], [Month_Next], [Day_Next]) INCLUDE --([RunSequence])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_ACCOUNTTYPE__Incl_Comp_4_16_2021 ON [dbo].[TBL_DISTRIBUTOR] --([ACCOUNTTYPE]) INCLUDE --([LEGACYNUMBER], [USERSTATUS])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_Dir300leg__Incl_Comp_4_16_2021 ON [dbo].[Om_Distributorranks] --([Dir300leg])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_Applied__Incl_Comp_4_16_2021 ON [dbo].[tbl_Commission_Run_EMP_Logs] --([Applied]) INCLUDE --([CommPeriodId], [CreatedDate])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId_Dist_ID__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_Payouts] --([CommPeriodId], [Dist_ID]) INCLUDE --([Weekly_Shares], [Value_Per_Share], [Week_Payout])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_Dist_ID__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_Payouts] --([Dist_ID])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([CommPeriodId]) INCLUDE --([LegacyNumber], [EnrollerId], [PaidAsRank], [TotalCV], [pgv])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_DistributorId_Status__Incl_Comp_4_16_2021 ON [dbo].[PromoCode_FutureDistributor] --([DistributorId], [Status])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommperiodId__Runsequence__Incl_Comp_4_16_2021 ON [dbo].[PGVProjected_Detail_Temp] --([CommperiodId], [Runsequence]) INCLUDE --([MainDistributorId], [DistributorId], [EnrollerId], [DistStatus], [OrderNumber], [PVAmount], [NextRunDate], [DateLastGen], [CountryCode])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommperiodId__Runsequence__Incl_Comp_4_16_2021 ON [dbo].[PGVProjected_Temp] --([CommperiodId], [Runsequence]) INCLUDE --([DistributorId], [EnrollerId], [PVAmount])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_NOTETYPE__Incl_Comp_4_16_2021 ON [dbo].[TBL_DISTRIBUTORS_NOTES] --([NOTETYPE]) INCLUDE --([ID], [DISTRIBUTORID], [NOTE], [CREATEDDATE], [CREATEDBY], [UPDATEDDATE], [UPDATEDBY], [COMPLETEDATE], [OVERDUEDATE], [STATUS], [RESOLVED], [DATERESOLVED])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderStatus__Incl_Comp_4_16_2021 ON [dbo].[tbl_Orders_Header] --([OrderStatus]) INCLUDE --([LegacyNumber], [DistributorId], [DateCompleted], [ReleasedDate])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderStatus__Incl_Comp_4_16_2021 ON [dbo].[TBL_AUTOSHIPORDERS_HEADER] --([OrderStatus], [MARKETID], [NextRunDate], [OrderSource], [Price2]) INCLUDE --([DISTRIBUTORID], [LegacyNumber], [DateLastOrder], [LastOrderNo], [CountryCode], [isorder])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderStatus__Incl_Comp_4_16_2021 ON [dbo].[TBL_AUTOSHIPORDERS_HEADER] --([OrderStatus]) INCLUDE --([ORDERDATE], [DISTRIBUTORID], [LegacyNumber], [StartDate], [LastOrderNo], [NextRunDate], [CountryCode])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderStatus__Incl_Comp_4_16_2021 ON [dbo].[TBL_AUTOSHIPORDERS_HEADER] --([OrderStatus], [NextRunDate], [OrderSource], [Price2]) INCLUDE --([DISTRIBUTORID], [MARKETID], [LegacyNumber], [DateLastOrder], [LastOrderNo], [CountryCode], [isorder])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodID__Incl_Comp_4_16_2021 ON [dbo].[TBL_LOG_RANKADVANCEMENT] --([CommPeriodID], [DateAchived]) INCLUDE --([DistributorID], [PreviousRankID], [NewRankID], [Note], [UpdatedBy])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_AccountType__CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([AccountType], [CommPeriodId]) INCLUDE --([LegacyNumber], [EnrollerId], [DistributorStatus], [LifetimeRankId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_ORDERID__STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_LOG_AUTOSHIPS] --([ORDERID], [STATUS], [TRANSACTIONDATE], [APP])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([CommPeriodId]) INCLUDE --([LegacyNumber], [EnrollerId], [PaidAsRank])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LegacyNumber__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([LegacyNumber], [CommPeriodId]) INCLUDE --([CurrencyCode], [MARKETID])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
-- DROP INDEX  ix_NN_PV_DATE__Incl_Comp_4_16_2021 ON [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS] --([PV_DATE])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

-- 36 seconds
DROP INDEX  ix_NN_MARKETID__Incl_Comp_4_16_2021 ON [dbo].[TBL_DISTRIBUTOR] --([MARKETID]) INCLUDE --([ACCOUNTTYPE], [LEGACYNUMBER], [FIRSTNAME], [MIDDLENAME], [LASTNAME], [USERNAME], [PREFERREDLANGUAGE], [CompanyName], [HOMEPHONE], [WorkPhone], [CellPhone], [FAXNUMBER], [EmailAddress], [HOMEADDRESSID], [ENROLLERID], [PLACEMENTID], [JOINDATE], [USERSTATUS], [BIRTHDATE], [LifetimeRankId], [BinarySponsorId], [HomeAdress], [HomeAdress1], [HomeCity], [HomeState], [HomeZip], [TerminationDate], [NextRenewDate], [LastRenewDate], [CoApplicant_FirstName], [CoApplicant_LastName], [Phone1], [CUSTOM1], [SPOUSENAME], [flag_11], [flag_12], [flag_15], [flag_17], [flag_19], [flag_20], [flag_21], [flag_22], [flag_23], [flag_25], [flag_26], [flag_27], [flag_29], [flag_37], [flag_61], [flag_10], [flag_51], [flag_52], [flag_53], [flag_54], [flag_55], [flag_56], [VATID], [USVALIDTAX], [SponsorSequence], [TERMINATEDDATE], [emailaddress_alternative], [SpouseLastName], [LastOrderDate], [flag_1], [flag_2], [flag_3], [flag_4], [flag_5], [flag_6], [flag_7], [flag_8], [flag_9], [flag_13], [flag_14], [flag_16], [flag_18], [flag_24], [flag_28], [flag_30], [flag_31], [flag_32], [flag_33], [flag_34], [flag_35], [flag_36], [flag_38], [flag_39], [flag_40], [flag_41], [flag_42], [flag_43], [flag_44], [flag_45], [flag_46], [flag_47], [flag_48], [flag_49], [flag_50], [flag_57], [flag_58], [flag_59], [flag_60], [flag_62], [flag_63], [flag_64], [flag_65], [flag_66], [flag_67], [flag_68], [flag_69], [flag_70], [flag_71], [flag_72], [flag_73], [flag_74], [flag_75], [flag_76], [flag_77], [flag_78], [flag_79], [flag_80], [flag_81], [flag_82], [flag_83], [flag_84], [flag_85], [flag_86], [flag_87], [flag_88], [flag_89], [flag_90], [flag_91], [flag_92], [flag_93], [flag_94], [flag_95], [flag_96], [flag_97], [flag_98], [flag_99], [flag_100])
--WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

--8 seconds
DROP INDEX  ix_NN_ACCOUNTTYPE__Incl_Comp_4_16_2021 ON [dbo].[TBL_DISTRIBUTOR] --([ACCOUNTTYPE], [USERSTATUS], [CURRENTTITLE], [LifetimeRankId]) INCLUDE --([LEGACYNUMBER], [FIRSTNAME], [LASTNAME])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

--1m 33s
DROP INDEX  ix_NN_distributorid__Incl_Comp_4_16_2021 ON [dbo].[tbl_PicknPlay_reconectRedox] --([distributorid])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderStatus_MARKETID__Incl_Comp_4_16_2021 ON [dbo].[TBL_AUTOSHIPORDERS_HEADER] --([OrderStatus], [MARKETID], [NextRunDate], [OrderSource]) INCLUDE --([ORDERDATE], [DISTRIBUTORID], [DAYTORUN], [SUBTOTAL], [DISCOUNTS], [CITYTAXES], [COUNTYTAXES], [STATETAXES], [TOTALTAX], [TOTALSHIPPING], [TOTALSHIPPINGTAX], [ORDERTOTAL], [COMMVALUE], [QUALIFYINGVOLUME], [SHIPPINGADDRESSID], [BILLINGADDRESSID], [CREDITCARDID], [LegacyNumber], [ShipToName], [ShipToAddress], [ShipToAddress1], [ShipToCity], [ShipToState], [ShipToZip], [ShipToCountry], [ShipToGeo], [ShipToPhone], [ShipToSpouse], [ShippingProviderId], [ShippingProviderName], [WarehouseId], [EmailAddress], [LastOrderNo], [CountryCode], [Infotrax_OrderId], [CARDLAST4], [PAYMENTTYPE], [ShipToCountryID], [FREIGHTCATEGORY], [ShipViaId], [TaxTransactionId], [TaxProviderId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderStatus_NextRunDate__Incl_Comp_4_16_2021 ON [dbo].[TBL_AUTOSHIPORDERS_HEADER] --([OrderStatus], [NextRunDate], [MARKETID], [OrderSource]) INCLUDE --([ORDERDATE], [DISTRIBUTORID], [DAYTORUN], [SUBTOTAL], [DISCOUNTS], [CITYTAXES], [COUNTYTAXES], [STATETAXES], [TOTALTAX], [TOTALSHIPPING], [TOTALSHIPPINGTAX], [ORDERTOTAL], [COMMVALUE], [QUALIFYINGVOLUME], [SHIPPINGADDRESSID], [BILLINGADDRESSID], [CREDITCARDID], [LegacyNumber], [ShipToName], [ShipToAddress], [ShipToAddress1], [ShipToCity], [ShipToState], [ShipToZip], [ShipToCountry], [ShipToGeo], [ShipToPhone], [ShipToSpouse], [ShippingProviderId], [ShippingProviderName], [WarehouseId], [EmailAddress], [LastOrderNo], [CountryCode], [Infotrax_OrderId], [CARDLAST4], [PAYMENTTYPE], [ShipToCountryID], [FREIGHTCATEGORY], [ShipViaId], [TaxTransactionId], [TaxProviderId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS_ISASSOCIATE__Incl_Comp_4_16_2021 ON [dbo].[TBL_PRODUCTS] --([STATUS], [ISASSOCIATE]) INCLUDE --([DISPLAYINSHOPPINGCART], [EXTENDEDFASTSTART], [ISOFFICENFRORDER], [ForceAutoship])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS_ISASSOCIATE__Incl_Comp_4_16_2021_2 ON [dbo].[TBL_PRODUCTS] --([STATUS], [ISASSOCIATE], [ForceAutoship]) INCLUDE --([DISPLAYINSHOPPINGCART], [EXTENDEDFASTSTART], [ISOFFICENFRORDER])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderStatus__Incl_Comp_4_16_2021 ON [dbo].[tbl_Orders_Header] --([OrderStatus], [DATEPRINTED]) INCLUDE --([LegacyNumber], [DistributorId], [ShppingMethod], [CountryCode], [WarehouseId], [SHIPVIAID])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Orders_TaxDetail] --([OrderId]) INCLUDE --([Taxable], [Rate], [Tax], [Jurisname], [Taxname], [Skuid], [Exempt])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LegacyNumber__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([LegacyNumber], [CommPeriodId]) INCLUDE --([PaidAsRank], [MARKETID], [TOTAL_COMMISSIONS_VALUE], [AccountAdjustment_bonus])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LegacyNumber__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([LegacyNumber], [TOTAL_COMMISSIONS]) INCLUDE --([CommPeriodId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_ReportType__RunSequence__Incl_Comp_4_16_2021 ON [dbo].[ReportJob] --([ReportType], [RunSequence])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_Entry_Date__FlagEnrollment__Incl_Comp_4_16_2021 ON [dbo].[tbl_Loyalty_Rewards_Program_Main] --([Entry-Date], [FlagEnrollment])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_CAMPAIGNSXTEMPLATES] --([STATUS]) INCLUDE --([EMAILTEMPLATEID], [MARKETID])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LoyaltyPoint_Status__Entry_Date__FlagEnrollment__EmailSend__Incl_Comp_4_16_2021 ON [dbo].[tbl_Loyalty_Rewards_Program_Main] --([LoyaltyPoint_Status], [Entry-Date], [FlagEnrollment], [EmailSend])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LoyaltyPoint_Status__Entry_Date__FlagEnrollment_EmailSend__Incl_Comp_4_16_2021_2 ON [dbo].[tbl_Loyalty_Rewards_Program_Main] --([LoyaltyPoint_Status], [Entry-Date], [FlagEnrollment], [EmailSend]) INCLUDE --([DistributorId], [CountryCode])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LegacyNumber__Incl_Comp_4_16_2021 ON [dbo].[tbl_Orders_Detail] --([LegacyNumber], [SKUID], [QualifyingVolume])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs


---- 35 m
DROP INDEX  ix_NN_PRODUCT_TYPE__Incl_Comp_4_16_2021 ON [dbo].[ASEAI_RECENT_PURCHASES_PRODUCT_CATEGORIES] --([PRODUCT_TYPE]) INCLUDE --([DIST_ID], [MOST_RECENT_PURCHASE])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_PRODUCT_TYPE__PACK_INFO__Incl_Comp_4_16_2021 ON [dbo].[ASEAI_RECENT_PURCHASES_PRODUCT_CATEGORIES] --([PRODUCT_TYPE], [PACK_INFO]) INCLUDE --([DIST_ID], [MOST_RECENT_PURCHASE])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_PRODUCT_TYPE__Incl_Comp_4_16_2021_2 ON [dbo].[ASEAI_RECENT_PURCHASES_PRODUCT_CATEGORIES] --([PRODUCT_TYPE], [PACK_INFO]) INCLUDE --([DIST_ID], [MOST_RECENT_PURCHASE])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_MARKETID__CATEGORYID__FILEID__LANGUAGEID__Incl_Comp_4_16_2021 ON [dbo].[TBL_FILEORDER] --([MARKETID], [CATEGORYID], [FILEID], [LANGUAGEID])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_MARKETID__CATEGORYID__LANGUAGEID__Incl_Comp_4_16_2021 ON [dbo].[TBL_FILEORDER] --([MARKETID], [CATEGORYID], [LANGUAGEID]) INCLUDE --([POSITION])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS__RolesId__Incl_Comp_4_16_2021 ON [dbo].[RightsManagement_NavSettings_Users] --([STATUS], [RolesId]) INCLUDE --([NAVSETTINGID], [RolesNavSettingsAccessView], [RolesNavSettingsAccessEdit])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([CommPeriodId]) INCLUDE --([LegacyNumber], [EnrollerId], [TotalCV], [pgv])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_Type__Incl_Comp_4_16_2021 ON [dbo].[TBL_LOG_WEBSERVICE_PAYNOW] --([Type]) INCLUDE --([CREATEDDATE], [OrderId], [Legacynumber], [Message])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_Legacynumber__Incl_Comp_4_16_2021 ON [dbo].[TBL_LOG_WEBSERVICE_PAYNOW] --([Legacynumber], [Type])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_NotificationId__NotificationDetailClicked__Incl_Comp_4_16_2021 ON [dbo].[NotificationDetail] --([NotificationId], [NotificationDetailClicked])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_AUTOSHIP__Incl_Comp_4_16_2021 ON [dbo].[TBL_PRODUCTS] --([AUTOSHIP]) INCLUDE --([SKUID], [STATUS], [SHIPPINGEXEMPTION], [ForceAutoship])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_AUTOSHIP__Incl_Comp_4_16_2021 ON [dbo].[TBL_PRODUCTS] --([AUTOSHIP]) INCLUDE --([SKUID], [STATUS], [SKUSHIPPINGEXCEPTION], [ForceAutoship])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([CommPeriodId], [LifetimeRankId]) INCLUDE --([LegacyNumber])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_distributor_commissions_v2] --([CommPeriodId]) INCLUDE --([LegacyNumber], [PGV3])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_WareTwoGoMethod__WareTwoGoResultcode__Incl_Comp_4_16_2021 ON [dbo].[ShippingWareTwoGo] --([WareTwoGoMethod], [WareTwoGoResultcode]) INCLUDE --([OrdersId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_WareTwoGoMethod__WareTwoGoResultcode__OrdersId__Incl_Comp_4_16_2021 ON [dbo].[ShippingWareTwoGo] --([WareTwoGoMethod], [WareTwoGoResultcode], [OrdersId]) INCLUDE --([WareTwoGoRequest], [WareTwoGoResponse], [CreatedDate])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_ReadyShipperMethod__ReadyShipperResultcode__Incl_Comp_4_16_2021 ON [dbo].[ShippingReadyShipper] --([ReadyShipperMethod], [ReadyShipperResultcode]) INCLUDE --([OrdersId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_ReadyShipperMethod__ReadyShipperResultcode__OrdersId__Incl_Comp_4_16_2021 ON [dbo].[ShippingReadyShipper] --([ReadyShipperMethod], [ReadyShipperResultcode], [OrdersId]) INCLUDE --([ReadyShipperRequest], [ReadyShipperResponse], [CreatedDate])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_SHIPPINGRATES_NEW] --([STATUS], [PRICE_NEW], [PRICE_NONAUTOSHIP_NEW], [SHIPVIA]) INCLUDE --([COUNTRYCODE], [RANGE_START], [RANGE_END], [ISNFRSHIPPING], [MARKETID])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_Rank__Incl_Comp_4_16_2021 ON [dbo].[TBL_DISTRIBUTOR_FANFARE_PREVIEW] --([Rank], [Status]) INCLUDE --([ID], [Order], [Associate ID], [FullName], [Market])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_DISTRIBUTORID__Incl_Comp_4_16_2021 ON [dbo].[TBL_FANFARE_DATA_PREVIEW] --([DISTRIBUTORID]) INCLUDE --([STORY], [IMAGEURL], [FileId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LANGUAGEID__APPID__Incl_Comp_4_16_2021 ON [dbo].[RightsManagement_NavSettings] --([LANGUAGEID], [APPID], [STATUS]) INCLUDE --([PARENTID], [URL], [MenuName], [ISONMENU], [SortOrder])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_DISTRIBUTORID__Incl_Comp_4_16_2021 ON [dbo].[TBL_PHOENIX_LOG_IPADDRESS] --([DISTRIBUTORID]) INCLUDE --([IPADDRESS], [ORDERSOURCE], [CREATEDDATE], [COUNTRYNAME])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_DISTRIBUTORID__Incl_Comp_4_16_2021 ON [dbo].[TBL_PHOENIX_LOG_IPADDRESS] --([DISTRIBUTORID], [ORDERSOURCE]) INCLUDE --([IPADDRESS], [CREATEDDATE], [COUNTRYNAME])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderId__Incl_Comp_4_16_2021 ON [dbo].[Order_BackOrders] --([OrderId])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_EventId__Incl_Comp_4_16_2021 ON [dbo].[Events_Ticket_OrderDetail] --([EventId]) INCLUDE --([AssignedId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_EventId_AssignedId_IsGuest__Incl_Comp_4_16_2021 ON [dbo].[Events_Ticket_OrderDetail] --([EventId], [AssignedId], [IsGuest], [EventTicketUnassigned])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_Commperiodid__Incl_Comp_4_16_2021 ON [dbo].[Distributor_Commissions_Bonus] --([Commperiodid]) INCLUDE --([Distributorid], [Enrollerid], [Totalcv], [Accounttype], [Endrank])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_ID__Incl_Comp_4_16_2021 ON [dbo].[TBL_DISTRIBUTORS_NOTES] --([ID])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate_RunSequence_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Orders_Header_Commissions_summary_v2] --([RunDate], [RunSequence], [CommPeriodId], [OrderStatus], [DistributorStatus]) INCLUDE --([Custom4])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs


-- 25 s
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Bonus_Matching_v2] --([CommPeriodId], [BonusAmount]) INCLUDE --([BonusRecipientId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_type__Incl_Comp_4_16_2021 ON [dbo].[tbl_commission_execute] --([type]) INCLUDE --([commperiodid], [rundate], [runsequence], [Applied], [createdby])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_Rank_PV_DATE__Incl_Comp_4_16_2021 ON [dbo].[TBL_DISTRIBUTOR_RANKADVANCEMENTS_PREVIEW] --([Rank], [PV_DATE]) INCLUDE --([ID], [Order], [Associate ID], [FullName], [Market])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs


----50 s
DROP INDEX  ix_NN_LANGUAGEID__POSITION__BANNERSOURCE__Incl_Comp_4_16_2021 ON [dbo].[TBL_BANNER] --([LANGUAGEID], [POSITION], [BANNERSOURCE], [STATUS]) INCLUDE --([NUMBER])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_WAREHOUSEID__CARRIER__STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_SHIPPINGRATES] --([WAREHOUSEID], [CARRIER], [STATUS]) INCLUDE --([TYPE], [MARKETID], [RANGE_START], [RANGE_END], [PRICE], [PRICE_NONAUTOSHIP], [REGION], [ISNFRSHIPPING])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LANGUAGEID__STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_ALERTSYSTEM_LANGUAGE] --([LANGUAGEID], [STATUS]) INCLUDE --([ALERTID])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_TranslationKeyID__Incl_Comp_4_16_2021 ON [dbo].[Translation_Key_Module] --([TranslationKeyID]) INCLUDE --([ModuleID])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodID__Incl_Comp_4_16_2021 ON [dbo].[TBL_LOG_RANKADVANCEMENT] --([CommPeriodID], [NewRankID]) INCLUDE --([DistributorID], [DateAchived])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_URL__Incl_Comp_4_16_2021 ON [dbo].[RightsManagement_NavSettings] --([URL])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021_1 ON [dbo].[tbl_Bonus_Matching_v2] --([CommPeriodId]) INCLUDE --([BonusAmount])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_EventId__Status__Incl_Comp_4_16_2021 ON [dbo].[Events_Ticket_OrderDetail] --([EventId], [Status], [EventTicketUnassigned]) INCLUDE --([OrderId], [TicketId], [AssignedId], [CreatedDate], [CreatedBy], [UpdatedDate], [UpdatedBy], [IsGuest], [IsInDownline])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_EventId__AssignedId__Status__Incl_Comp_4_16_2021 ON [dbo].[Events_Ticket_OrderDetail] --([EventId], [AssignedId], [Status]) INCLUDE --([OrderId], [TicketId], [EventTicketUnassigned])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_PRODUCTS] --([STATUS]) INCLUDE --([NAME], [SHORTDESCRIPTION], [SKUID], [IMAGETHUMBNAIL])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs



DROP INDEX  ix_NN_OrdersId__Incl_Comp_4_16_2021 ON [dbo].[ShippingReadyShipper] --([OrdersId])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 5 secs
DROP INDEX  ix_NN_EventId__Incl_Comp_4_16_2021_2 ON [dbo].[Events_Ticket_OrderDetail] --([EventId]) INCLUDE --([TicketId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 3 secs
DROP INDEX  ix_NN_CommperiodId__MainDistributorId__Runsequence__Incl_Comp_4_16_2021 ON [dbo].[PGVProjected_Detail_Temp] --([CommperiodId], [MainDistributorId], [Runsequence]) INCLUDE --([PVAmount])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_ID_DISTRIBUTOR__ ID_SESSIONS__ ID_CLASS__ ID_ACTIVITY__ STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_RECOGNITION_BASECAMP_DETAIL] --([ID_DISTRIBUTOR], [ID_SESSIONS], [ID_CLASS], [ID_ACTIVITY], [STATUS])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 3 m
DROP INDEX  ix_NN_CommPeriodId_BonusRecipientId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Bonus_EMP_v2] --([CommPeriodId], [BonusRecipientId], [bonusAmountValue])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommperiodID_Maindistributorid__Incl_Comp_4_16_2021 ON [dbo].[LosingActivity_Detail] --([CommperiodID], [Maindistributorid]) INCLUDE --([DisqualificationDate], [DistributorID], [Name], [LifetimeRankID], [Email], [Mobile], [LastOrderDate], [LastActivityOrderPV], [LoyaltyRewardsPoints], [ResponsibleLeader], [LeaderID], [LeaderEmail], [LeaderMobile])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 11 secs
DROP INDEX  ix_NN_InvoiceNumberTemplateId__Incl_Comp_4_16_2021 ON [dbo].[InvoiceNumber] --([InvoiceNumberTemplateId]) INCLUDE --([InvoiceNumberDescription], [Sequential])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 10 secs
DROP INDEX  ix_NN_OrdersId__Incl_Comp_4_16_2021 ON [dbo].[MerchantWorldPay] --([OrdersId])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_commperiodid_Applied__Incl_Comp_4_16_2021 ON [dbo].[tbl_commission_execute] --([commperiodid], [Applied]) INCLUDE --([rundate], [runsequence])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_CommPeriodId_BonusRecipientId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Bonus_AccountAdjustment_v2] --([CommPeriodId], [BonusRecipientId], [bonusAmountValue])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

DROP INDEX  ix_NN_Rundate_Runsequence_Commperiodid__Incl_Comp_4_16_2021 ON [dbo].[Distributor_Commissions_Bonus] --([Rundate], [Runsequence], [Commperiodid], [Distributorstatus], [Marketid]) INCLUDE --([Distributorid], [Total_Commissions], [Total_Commissions_Value], [Hold_Bonus], [Payoutpegrate])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 33 secs
DROP INDEX  ix_NN_Rundate_Runsequence_Commperiodid_Marketid__Incl_Comp_4_16_2021 ON [dbo].[Distributor_Commissions_Bonus] --([Rundate], [Runsequence], [Commperiodid], [Marketid], [Distributorstatus]) INCLUDE --([Distributorid], [Total_Commissions], [Total_Commissions_Value], [Hold_Bonus], [Payoutpegrate])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 7 secs
DROP INDEX  ix_NN_commperiodid__Incl_Comp_4_16_2021 ON [dbo].[tbl_balance] --([commperiodid]) INCLUDE --([distributorid], [marketid], [payoutPegrate], [incomeBalanceUSD], [currentEarningUSD], [balanceValue], [holdBonus], [outcomeBalanceUSD])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

DROP INDEX  ix_NN_Accounttype__Incl_Comp_4_16_2021 ON [dbo].[Distributor_Commissions_Bonus] --([Accounttype]) INCLUDE --([Total_Commissions], [Total_Commissions_Value], [Accountadjustment_Bonus], [Accountadjustment_Bonus_Value])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 3 secs

DROP INDEX  ix_NN_ORDERSOURCE__Incl_Comp_4_16_2021 ON [dbo].[TBL_PHOENIX_LOG_IPADDRESS] --([ORDERSOURCE])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_DISTRIBUTORID__Incl_Comp_4_16_2021 ON [dbo].[TBL_PHOENIX_LOG_IPADDRESS] --([DISTRIBUTORID]) INCLUDE --([ID], [IPADDRESS], [ORDERSOURCE], [CREATEDDATE], [CREATEDBY], [UPDATEDDATE], [UPDATEDBY], [COUNTRYNAME])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 2m
DROP INDEX  ix_NN_STATUS_IS_FOR_VIRTUAL_OFFICE_IS_PREFERRED_CUSTOMER__Incl_Comp_4_16_2021 ON [dbo].[TBL_FILE_MASTER] --([STATUS], [IS_FOR_VIRTUAL_OFFICE], [IS_PREFERRED_CUSTOMER]) INCLUDE --([EXTENSION], [DESCRIPTION], [VIRTUAL_LOCATION], [TYPE], [PRIMARYTITLE], [EXTERNALURL], [SECONDARYTITLE])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

--1m
DROP INDEX  ix_NN_RunDate__RunSequence__PeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Loyalty_Rewards_Program_Main_temp] --([RunDate], [RunSequence], [PeriodId]) INCLUDE --([DistributorId], [LoyaltyPoints], [orderexception])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate__RunSequence__PeriodId__Incl_Comp_4_16_2021_2 ON [dbo].[tbl_Loyalty_Rewards_Program_Main_temp] --([RunDate], [RunSequence], [PeriodId]) INCLUDE --([DistributorId], [CountryCode], [Name], [LoyaltyPoints], [LoyaltyPoint_Status], [Month], [LoyaltyRewardProgram_Start], [LoyaltyPoint_Rate], [GracePeriod_Active], [GracePeriod_StartDate], [GracePeriod_EndDate], [MonthHold_EndDate], [Entry-Date], [FlagEnrollment], [FirstAutoship], [orderexception], [LRP_boost], [LRP_boost_value]) WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

select    
      sum--(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats -- 431.06430053710

-- 35s
DROP INDEX  ix_NN_distributorid_Month__Incl_Comp_4_16_2021 ON [dbo].[tbl_PicknPlay_DoubleLoyaltyRewards] --([distributorid], [Month])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RunDate_RunSequence__Incl_Comp_4_16_2021 ON [dbo].[tbl_Loyalty_Rewards_Program_Main_temp] --([RunDate], [RunSequence]) INCLUDE --([DistributorId], [PeriodId], [CountryCode], [Name], [LoyaltyPoints], [LoyaltyPoint_Status], [Month], [LoyaltyRewardProgram_Start], [LoyaltyPoint_Rate], [GracePeriod_Active], [GracePeriod_StartDate], [GracePeriod_EndDate], [MonthHold_EndDate], [Entry-Date], [FlagEnrollment], [CreatedDate], [FirstAutoship], [orderexception], [orderexceptionactive], [LRP_boost], [LRP_boost_value], [NewSubscription])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

DROP INDEX  ix_NN_TRANSACTIONID__Incl_Comp_4_16_2021 ON [dbo].[TBL_LOG_TRANSACTIONDETAILS] --([TRANSACTIONID]) INCLUDE --([REFERENCEID], [CODERESP], [DESCRIPTION], [RESPONSE], [AUTH], [APROVED], [AVSRESP], [WEBRESPONSE], [CREATEDDATE], [CREATEDBY], [DISTRIBUTORID], [WEBREQUEST], [TYPEGATEWAY], [TRANSACTIONTYPE], [OrderDetailId])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 3 m

DROP INDEX  ix_NN_ADJUSTMENTID__Incl_Comp_4_16_2021 ON [dbo].[TBL_ADJUSTMENTXCATEGORY] --([ADJUSTMENTID])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_MARKETID_ALERTID_STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_ALERTSYSTEM_MARKET] --([MARKETID], [ALERTID], [STATUS])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_RECOGNITIONREPORT_STATUS__Incl_Comp_4_16_2021 ON [dbo].[TBL_EXCLUSSIONS] --([RECOGNITIONREPORT], [STATUS], [FROMDATE], [TODATE]) INCLUDE --([DISTRIBUTORID])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrdersId__Incl_Comp_4_16_2021 ON [dbo].[MerchantBraintree] --([OrdersId])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 14 secs

--The table has rows with 8073 max size!!!!!!!!!!!
DROP INDEX  ix_NN_ModuleId__Incl_Comp_4_16_2021 ON [dbo].[MerchantBraintree] --([ModuleId]) INCLUDE --([BraintreeMethod], [BraintreeRequest], [BraintreeResponse], [BraintreeResultCode], [OrdersId], [CreatedBy], [CreatedDate], [CreatedRecord]) WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 11 m
--ALTER INDEX PkMerchantBraintree_BraintreeId ON [dbo].MerchantBraintree REBUILD PARTITION = ALL WITH --(DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB=ON) --2m

DROP INDEX  ix_NN_OrderId__Incl_Comp_4_16_2021 ON [dbo].[ApiLandmark] --([OrderId], [ApiLandmarkType]) INCLUDE --([ApiLandmarkWebService], [ApiLandmarkRequest], [ApiLandmarkResponse], [ApiLandmarkMessage], [CreatedDate])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_OrderID__Incl_Comp_4_16_2021 ON [dbo].[Log_Api_ProStartFulfillment] --([OrderID])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 8 secs

select    
      sum--(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats -- 452.97377014160



DROP INDEX  ix_NN_OrderNo__Incl_Comp_4_16_2021 ON [dbo].[tbl_Bonus_Preferred_v2] --([OrderNo]) INCLUDE --([CommPeriodId], [DistributorId], [BonusAmount], [EnrollerId], [BonusRecipientId], [OrderDate], [pegrate],
[bonusAmountValue], [PinRank], [PercentContribted], [CV], [Lvl], [PLvl], [QV], [BonusLevel], [Level])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_LegacyNumber__Incl_Comp_4_16_2021 ON [dbo].[tbl_Orders_Header_Commissions_summary_v2] --([LegacyNumber]) INCLUDE --([RunDate], [RunSequence], [OrderDate], [OrderType], [DistributorId], [SubTotal], [OrderTotal], 
[CommValue], [QualVolume], [OrderStatus], [MarketId], [AutoshipOrderNo], [OrderSource], [DistributorStatus], [IsInitialOrder], [CountryCode], [CurrencyCode], [CommPeriodId], [Custom1], [Custom2], [Custom3], [Custom4], [Custom5], 
[IsRetail], [Custom6], [Custom7], [Custom8], [Custom9], [RMAOrder], [ConversionRate], [RetailSponsorCV], [RetailBonus], [PreferredBonus], [PreferredSponsorCV], [FastStartBonus], [FastStartCV], [IsPreferred], [EnrollerId], [BinarySponsorId], 
[accounttype], [orderpegrate], [pegrate])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs


DROP INDEX  ix_NN_Legacynumber__Incl_Comp_4_16_2021 
--ON [dbo].[TBL_LOG_WEBSERVICE_PAYNOW] --([Legacynumber]) INCLUDE --([WEBSERVICE], [DESCRIPTION], [RESPONSE], [CREATEDDATE], [OrderId], [Message], [Type], [CreatedBy])
--WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE, drop_existing=on); -- 34 minutos, cancelled. After Rebuild the main table: 1m 24 s. But actually already exist. I don't know waht happened.

--ALTER INDEX PK__tmp_ms_x__3214EC27BBF22E9E ON [dbo].TBL_LOG_WEBSERVICE_PAYNOW REBUILD PARTITION = ALL WITH --(DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB=ON) --38 s
--The table has rows with 8062 max size!!!!!!!!!!!
--247066 pages 1gb y tarda tanto el non cluster "ix_NN_Legacynumber__Incl_Comp_4_16_2021"? --Extend Fragmentation?


DROP INDEX  ix_NN_Legacynumber__Incl_Comp_4_16_2021_2 ON [dbo].[TBL_LOG_WEBSERVICE_PAYNOW] --([Legacynumber])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_ModuleId__Incl_Comp_4_16_2021 ON [dbo].[MerchantBraintreePayPal] --([ModuleId]) INCLUDE --([BraintreePayPalMethod], [BraintreePayPalRequest], 
--[BraintreePayPalResponse], [BraintreePayPalResultCode], [OrdersId], [CreatedBy], [CreatedDate], [CreatedRecord])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 3m 22s

DROP INDEX  ix_NN_CommPeriodId__Incl_Comp_4_16_2021 ON [dbo].[tbl_Executive_Momentum_Pool_Payouts] --([CommPeriodId]) INCLUDE --([Value_Per_Share])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

DROP INDEX  ix_NN_BraintreeMethod__BraintreeResultCode__Incl_Comp_4_16_2021 ON [dbo].[MerchantBraintree] --([BraintreeMethod], [BraintreeResultCode], [ModuleId]) 
--INCLUDE --([BraintreeRequest], [BraintreeResponse], [OrdersId], [CreatedBy], [CreatedDate], [CreatedRecord])WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 9m 32s

DROP INDEX  ix_NN_ReadyShipperMethod_ReadyShipperResultcode_OrdersId__Incl_Comp_4_16_2021 ON [dbo].[ShippingReadyShipper] --([ReadyShipperMethod], [ReadyShipperResultcode], [OrdersId])  WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
DROP INDEX  ix_NN_BraintreeMethod_ModuleId__Incl_Comp_4_16_2021 ON [dbo].[MerchantBraintree] --([BraintreeMethod], [ModuleId]) 
--INCLUDE --([BraintreeRequest], [BraintreeResponse], [BraintreeResultCode], [OrdersId], [CreatedBy], [CreatedDate], [CreatedRecord]) WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 9m 30s

select    
      sum--(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats -- 498.13536071777

DROP INDEX  ix_NN_BraintreeMethod_BraintreeResultCode__Incl_Comp_4_16_2021 
--ON [dbo].[MerchantBraintree] --([BraintreeMethod], [BraintreeResultCode]) INCLUDE --([BraintreeRequest], [BraintreeResponse], [OrdersId], [ModuleId], [CreatedBy], [CreatedDate], [CreatedRecord])
--WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 9m 30s. A LOT!!!!!!!!!!!!
--Base Table: 581650 pages. Max row size: 8043. Min Row Size:9. Avg RowSize:3815. Depth: 4. Total Fragmentation: 0.01%. Page fullness: 71.88%
--Reads: 94. Writes: 5. Context Switches: 130,511. Physical IO: 67,144. THE EXECUTION PLAN HAVE HAD A SORT OPERATION WHICH HAS CAUSED A SPILL TO TEMPDB.

DROP INDEX  ix_NN_OrdersId__Incl_Comp_4_16_2021 ON [dbo].[TaxAvalara] --([OrdersId]) 
--INCLUDE --([AvalaraMethod], [AvalaraRequest], [AvalaraResponse], [AvalaraResultCode], [OrderSourceId], [CreatedBy], [CreatedDate])
--WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 13m cancelled. 13 minutes, cancelled. EXECUTION PLAN: HIGH COST INSERTING ON BASE TABLE!!!!!!!!!!!!!--(76%) -- may because hugh row size.�
-- although these problems the index has been created:
-- Trying to repeate the "failded" command: The operation failed because an index or statistics with name 'ix_NN_OrdersId__Incl_Comp_4_16_2021' already exists on table 'dbo.TaxAvalara'.

--ALTER INDEX Pk_TaxAvalara_AvalaraId ON [dbo].[TaxAvalara] REBUILD PARTITION = ALL WITH --(DATA_COMPRESSION = PAGE, ONLINE = ON, SORT_IN_TEMPDB=ON)  --2 minutes.
--base table: 498395 pages. 1132 4142 1495 --(rowsize). Depth:4. 2% FRAGMENTATION.90% PAGE FULLNESS. 


DROP INDEX  ix_NN_BraintreePayPalMethod_ModuleId__Incl_Comp_4_16_2021 ON [dbo].[MerchantBraintreePayPal] --([BraintreePayPalMethod], [ModuleId]) 
--INCLUDE --([BraintreePayPalRequest], [BraintreePayPalResponse], [BraintreePayPalResultCode], [OrdersId], [CreatedBy], [CreatedDate], [CreatedRecord])
--WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 6m 56s

DROP INDEX  ix_NN_BraintreePayPalMethod__Incl_Comp_4_16_2021 ON [dbo].[MerchantBraintreePayPal] --([BraintreePayPalMethod]) 
--INCLUDE --([BraintreePayPalRequest], [BraintreePayPalResponse], [BraintreePayPalResultCode], [OrdersId], [ModuleId], [CreatedBy], [CreatedDate], [CreatedRecord])
--WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 3m 17s

DROP INDEX  ix_NN_ModuleId__Incl_Comp_4_16_2021_2 ON [dbo].[MerchantBraintreePayPal] --([ModuleId], [BraintreePayPalMethod]) 
--INCLUDE --([BraintreePayPalRequest], [BraintreePayPalResponse], [BraintreePayPalResultCode], [OrdersId], [CreatedBy], [CreatedDate], [CreatedRecord])
--WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 4m 35s

DROP INDEX  ix_NN_ReadyShipperMethod_OrdersId__Incl_Comp_4_19_2021 ON [dbo].[ShippingReadyShipper] --([ReadyShipperMethod], [OrdersId]) 
--INCLUDE --([ReadyShipperRequest], [ReadyShipperResponse], [ReadyShipperResultcode], [OrderSourceId], [CreatedBy], [CreatedDate])
--WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 1m 5s

DROP INDEX  ix_NN_BraintreeMethod__Incl_Comp_4_16_2021 ON [dbo].[MerchantBraintree] --([BraintreeMethod]) 
--INCLUDE --([BraintreeRequest], [BraintreeResponse], [BraintreeResultCode], [OrdersId], [ModuleId], [CreatedBy], [CreatedDate], [CreatedRecord])
--WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 9, 37s

DROP INDEX  ix_NN_OrdersId__Incl_Comp_4_17_2021 ON [dbo].[ShippingWareTwoGo] --([OrdersId]) 
--INCLUDE --([WareTwoGoMethod], [WareTwoGoRequest], [WareTwoGoResponse], [WareTwoGoResultcode], [OrderSourceId], [CreatedBy], [CreatedDate])
--WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); -- 46 secs

select    
      sum--(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats -- 639.70579528808


--USE [Asea_Stage]
--GO
DROP INDEX  ix_NN_tbl_Distributor_Commissions_summary_v2_Incl_Comp_4_20_2021
--ON [dbo].[tbl_Distributor_Commissions_summary_v2] --([RunDate],[RunSequence])
--INCLUDE --([EndRank],[LifetimeRankId])
--WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); --To improve performance on [dbo].[sp_CalculateVolume] --8m 43s.
--GO


--JUST IN CASO OF ROLLBACK:
--/****** Object:  Index [idx_dctempv20002]    Script Date: 4/20/2021 6:33:13 PM ******/
DROP INDEX  [idx_dctempv20002] ON [dbo].[tbl_Distributor_Commissions_Temp_v2]
----(
--	[RunDate] ASC,
--	[RunSequence] ASC
--)
--INCLUDE--([AccountType],[ActiveEnrollerId],[ActiveTotalPV],[ActiveUplineLevel1],[ActiveUplineLevel2],[ActiveUplineLevel3],[BinarySponsorId],[BIWEEKGV],[BIWEEKPGV],[biweeksidegv]
--,[CHECK_MATCH],[CHECK_MATCH_VALUE],[CountryCode],[CURRENCYCODE],[Custom1],[custom10],[Custom2],[Custom3],[Custom4],[Custom5],[Custom6],[Custom7],[Custom8],[custom9],[CustomerPE_Volume]
--,[DIRECTOR_BONUS],[DIRECTOR_BONUS_VALUE],[DistributorId],[EndRank],[EnrollerId],[FAST_START_BONUS],[FAST_START_BONUS_VALUE],[FAST_START_GBR_IRL_BONUS],[FAST_START_GBR_IRL_BONUS_VALUE]
--,[Incoming_Left_Vol],[Incoming_Right_Vol],[Outgoing_Left_Vol],[Outgoing_Right_Vol],[PEGRATE],[PGV3],[PGV50],[PGV7],[PlacementId],[PREF_CUST_BONUS],[PREF_CUST_BONUS_VALUE],[realcustom1]
--,[realcustom2],[RETAIL_COMMISSIONS],[RETAIL_COMMISSIONS_VALUE],[SponsorSequence],[StartRank],[TEAM_COMMISSIONS],[TEAM_COMMISSIONS_VALUE],[TOTAL_COMMISSIONS],[TOTAL_COMMISSIONS_VALUE],[TotalCV]
--,[TotalPV],[TRIWEEKGV],[TRIWEEKPGV],[triweeksidegv],[WEEKGV],[WEEKPGV]) WITH --(STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO 

--INDEX CAUSING HIGH COST ON SORT, EXECUTING THIS SENTENCE:
/*
Update [D]  with --(tablock)        
    Set         
         [D].[Endrank] = 1        
    From [Dbo].[Tbl_Distributor_Commissions_Temp_V2] [D]       
    Where         
     [D].[Endrank] Is Null
*/ 

-************************************
--query id on query store: 91678988 *
-************************************

--This index is not used on ASEA_PRODUCTION according to documentation on "ASEA_STAGE_BBDD_Analysis_Snapshot04082021.xlsx"
----user_scans	user_lookups	user_updates
---- 0				0					72

--/****** Object:  Index [idx_dctempv20002]    Script Date: 4/20/2021 6:36:36 PM ******/
--DROP INDEX [idx_dctempv20002] ON [dbo].[tbl_Distributor_Commissions_Temp_v2]
--GO

----------------------------

--USE [Asea_Stage]

--GO

DROP INDEX  [missing_index_19557_19556] ON [dbo].[tbl_Distributor_Commissions_summary_v2]
----(
--	[RunDate] ASC,
--	[RunSequence] ASC
--)
--INCLUDE--([DistributorId],[EndRank]) WITH --(data_compression=page,STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = ON, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO 
----Covered index To improve performance on [sp_CalculateVolume]. Column [EndRank]  added.
----Completion time: 2021-04-20T18:54:11.7229672-03:00
----2m 35s

---improved statement: 1541.95 cost
 ------lifetimerank in summary, only updates the paid as rank that increased in LDP    
 ----Update [Dc]                
 ----Set                   
 ---- [Dc].[Lifetimerankid] = IsNull--([Dc].[EndRank] , 0)              
 ----From [Dbo].[Tbl_Distributor_commissions_summary_v2] [Dc]          
 ----Where [Dc].rundate = @rundate    
 ---- And [Dc].runsequence = @runsequence      
 ---- And IsNull--([Dc].[EndRank] , 0) > IsNull--([Dc].[Lifetimerankid] , 0)

----------------------------------------------------------------------------------------

--To optimize: CREATE Procedure [dbo].[sp_generate_periodSnapshot] called by sp_CalculateVolume.
-- MERGE WITH A COST OF 43,974.9355.
--https://onedrive.live.com/view.aspx?resid=C6FA59824AB3963E%21115377&id=documents&wd=target%28LOG%20DE%20OPTIMIZACION.one%7CA6546222-B86D-4AE2-A63E-AA60D8D77127%2FMERGE%20CON%20COSTO%2043000%7C3D5C580F-3800-4B55-8BC6-2D1EA702EF04%2F%29
--onenote:--https://d.docs.live.net/c6fa59824ab3963e/NOTAS/xirectds/LOG%20DE%20OPTIMIZACION.one#MERGE%20CON%20COSTO%2043000&section-id={A6546222-B86D-4AE2-A63E-AA60D8D77127}&page-id={3D5C580F-3800-4B55-8BC6-2D1EA702EF04}&end

/****** Object:  Index [idx_distributor_snapshot_commperiod_legacynumber]    Script Date: 4/20/2021 7:13:53 PM ******/
DROP INDEX [idx_distributor_snapshot_commperiod_legacynumber] ON [dbo].[tbl_Distributor_Snapshot]
--GO
--user_seeks	user_scans	user_lookups	user_updates
--	238				0			0				22
--Completion time: 2021-04-20


/****** Object:  Index [idx_tbl_Distributor_Snapshot_1]    Script Date: 4/20/2021 7:14:18 PM ******/
DROP INDEX [idx_tbl_Distributor_Snapshot_1] ON [dbo].[tbl_Distributor_Snapshot]
--GO
--user_seeks	user_scans	user_lookups	user_updates
--	0				0			0				22
--Completion time: 2021-04-20

/****** Object:  Index [idx_tbl_Distributor_Snapshot_2]    Script Date: 4/20/2021 7:15:10 PM ******/
DROP INDEX [idx_tbl_Distributor_Snapshot_2] ON [dbo].[tbl_Distributor_Snapshot]
--GO 
--Completion time: 2021-04-20T19:26:09.9030067-03:00
--user_seeks	user_scans	user_lookups	user_updates
--	2				0			0				22


/****** Object:  Index [Ix_Nn_tbl_Distributor_Snapshot_SnapshotCommPeriodId_Include]    Script Date: 4/20/2021 7:15:55 PM ******/
DROP INDEX [Ix_Nn_tbl_Distributor_Snapshot_SnapshotCommPeriodId_Include] ON [dbo].[tbl_Distributor_Snapshot]
--GO
--Completion time: 2021-04-20T19:27:22.7078653-03:00
--user_seeks	user_scans	user_lookups	user_updates
--	2				0			0				22

/****** Object:  Index [missing_index_5650_5649]    Script Date: 4/20/2021 7:16:37 PM ******/
DROP INDEX [missing_index_5650_5649] ON [dbo].[tbl_Distributor_Snapshot]
--GO
--user_seeks	user_scans	user_lookups	user_updates
--	12				0			0				22


-- Just for RollBack:
--/****** Object:  Index [idx_distributor_snapshot_commperiod_legacynumber]    Script Date: 4/20/2021 7:12:27 PM ******/
DROP INDEX  [idx_distributor_snapshot_commperiod_legacynumber] ON [dbo].[tbl_Distributor_Snapshot]
----(
--	[SnapshotCommPeriodId] ASC,
--	[LegacyNumber] ASC
--)
--INCLUDE--([AccountType],[AssociateType],[Entity],[FirstName],[LastName],[EnrollerId],[PlacementId],[BinarySponsorId],[SponsorSequence],[PREFERREDPLACEMENTID]
--,[PlacementLeg],[JoinDate],[USERSTATUS],[CURRENTTITLE],[PERIODTITLE],[PaidAsRank],[LifetimeRankId],[LifeTimeRankDate],[PaidAsRankDate],[ForceRank]
--,[COUNTRYID],[MARKETID],[CURRENCYCODE],[CountryCode],[JoinCommPeriodId],[USVALIDTAX],[birthdate]) 
--WITH --(STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO

--/****** Object:  Index [idx_tbl_Distributor_Snapshot_1]    Script Date: 4/20/2021 7:14:18 PM ******/
DROP INDEX  [idx_tbl_Distributor_Snapshot_1] ON [dbo].[tbl_Distributor_Snapshot]
----(
--	[ID] ASC,
--	[MARKETID] ASC,
--	[SnapshotCommPeriodId] ASC
--)
--INCLUDE--([PERIODTITLE],[PlacementId],[PlacementLeg],[PREFERREDPLACEMENTID],[SequenceId],[SponsorSequence],[TERMINATEDDATE],[USERSTATUS],[USVALIDTAX],[EmailAddress],[CompanyName],[TotalLeftVol_PersonalEnrollee],[TotalRightVol_PersonalEnrollee],[AccountType],[AssociateType],[BinarySponsorId],[birthdate],[CountryCode],[COUNTRYID],[CURRENCYCODE],[CURRENTTITLE],[EnrollerId],[Entity],[FirstName],[ForceRank],[JoinCommPeriodId],[JoinDate],[LastName],[LegacyNumber],[LifeTimeRankDate],[LifetimeRankId],[PaidAsRank],[PaidAsRankDate]) WITH --(STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO


--/****** Object:  Index [idx_tbl_Distributor_Snapshot_2]    Script Date: 4/20/2021 7:15:10 PM ******/
DROP INDEX  [idx_tbl_Distributor_Snapshot_2] ON [dbo].[tbl_Distributor_Snapshot]
----(
--	[SnapshotCommPeriodId] ASC
--)
--INCLUDE--([AccountType],[LegacyNumber],[FirstName],[LastName],[EnrollerId],[PlacementId],[JoinDate],[USERSTATUS],[CURRENTTITLE],[PERIODTITLE],[COUNTRYID],[MARKETID],[PaidAsRank],[LifetimeRankId],[CountryCode],[BinarySponsorId],[JoinCommPeriodId],[AssociateType],[Entity],[LifeTimeRankDate],[PaidAsRankDate],[ForceRank],[PREFERREDPLACEMENTID],[PlacementLeg],[SequenceId],[SponsorSequence],[CURRENCYCODE],[TERMINATEDDATE],[USVALIDTAX],[birthdate],[EmailAddress],[CompanyName],[TotalLeftVol_PersonalEnrollee],[TotalRightVol_PersonalEnrollee]) WITH --(STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO



--/****** Object:  Index [Ix_Nn_tbl_Distributor_Snapshot_SnapshotCommPeriodId_Include]    Script Date: 4/20/2021 7:15:55 PM ******/
DROP INDEX  [Ix_Nn_tbl_Distributor_Snapshot_SnapshotCommPeriodId_Include] ON [dbo].[tbl_Distributor_Snapshot]
----(
--	[SnapshotCommPeriodId] ASC
--)
--INCLUDE--([AccountType],[LegacyNumber],[FirstName],[LastName],[EnrollerId],[PlacementId],[JoinDate],[USERSTATUS],[CURRENTTITLE],[PERIODTITLE],[COUNTRYID],[MARKETID],[PaidAsRank],[LifetimeRankId],[CountryCode],[BinarySponsorId],[JoinCommPeriodId],[AssociateType],[Entity],[LifeTimeRankDate],[PaidAsRankDate],[ForceRank],[PREFERREDPLACEMENTID],[PlacementLeg],[SequenceId],[SponsorSequence],[CURRENCYCODE],[TERMINATEDDATE],[USVALIDTAX],[birthdate],[EmailAddress],[CompanyName],[TotalLeftVol_PersonalEnrollee],[TotalRightVol_PersonalEnrollee],[Init_LifeTimeRank]) WITH --(STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO

--/****** Object:  Index [missing_index_5650_5649]    Script Date: 4/20/2021 7:16:37 PM ******/
DROP INDEX  [missing_index_5650_5649] ON [dbo].[tbl_Distributor_Snapshot]
----(
--	[SnapshotCommPeriodId] ASC,
--	[MARKETID] ASC
--)
--INCLUDE--([AccountType],[AssociateType],[BinarySponsorId],[birthdate],[CountryCode],[COUNTRYID],[CURRENCYCODE],[CURRENTTITLE],[EnrollerId],[Entity],[FirstName],[ForceRank],[JoinCommPeriodId],[JoinDate],[LastName],[LegacyNumber],[LifeTimeRankDate],[LifetimeRankId],[PaidAsRank],[PaidAsRankDate],[PERIODTITLE],[PlacementId],[PlacementLeg],[PREFERREDPLACEMENTID],[SequenceId],[SponsorSequence],[TERMINATEDDATE],[UPDATEDBY],[UPDATEDDATE],[USERSTATUS],[USVALIDTAX]) WITH --(STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--GO

DROPPING MISSING INDEXES CREATED ON ASEA_STAGE JUST FOR TESTING PURPOSES. 
--THE REASON TO DROP THESE INDEXES IS TO OPTIMIZE SP_CALCULATEVOLUME WHICH CALL A SP WHICH USES A HIGH COST MERGE --(MORE INDEXES RESULTS ON MORE COST)
/****** Object:  Index [ix_NN_AccountType__CommPeriodId__Incl_Comp_4_16_2021]    Script Date: 4/21/2021 10:25:36 AM ******/
DROP INDEX [ix_NN_AccountType__CommPeriodId__Incl_Comp_4_16_2021] ON [dbo].[tbl_distributor_commissions_v2]
--GO
--/****** Object:  Index [ix_NN_AccountType_CommPeriodId__Incl_Comp_4_16_2021]    Script Date: 4/21/2021 10:25:55 AM ******/
DROP INDEX [ix_NN_AccountType_CommPeriodId__Incl_Comp_4_16_2021] ON [dbo].[tbl_distributor_commissions_v2]
--GO
--/****** Object:  Index [ix_NN_CommPeriodId__Incl_Comp_4_16_2021]    Script Date: 4/21/2021 10:26:13 AM ******/
DROP INDEX [ix_NN_CommPeriodId__Incl_Comp_4_16_2021] ON [dbo].[tbl_distributor_commissions_v2]
--GO
--/****** Object:  Index [ix_NN_EnrollerId__CommPeriodId__Incl_Comp_4_16_2021]    Script Date: 4/21/2021 10:26:35 AM ******/
DROP INDEX [ix_NN_EnrollerId__CommPeriodId__Incl_Comp_4_16_2021] ON [dbo].[tbl_distributor_commissions_v2]
--GO
--/****** Object:  Index [ix_NN_LegacyNumber__Incl_Comp_4_16_2021]    Script Date: 4/21/2021 10:26:54 AM ******/
DROP INDEX [ix_NN_LegacyNumber__Incl_Comp_4_16_2021] ON [dbo].[tbl_distributor_commissions_v2]
--GO
--/****** Object:  Index [ix_NN_LegacyNumber_Incl_Comp_4_16_2021]    Script Date: 4/21/2021 10:30:33 AM ******/
DROP INDEX [ix_NN_LegacyNumber_Incl_Comp_4_16_2021] ON [dbo].[tbl_distributor_commissions_v2]
--GO


--USE [Asea_Stage]
--GO
DROP INDEX  ix_NN_tbl_Distributor_Snapshot_SnapshotCommPeriodId_Incl_Comp_4_21_2021
--ON [dbo].[tbl_Distributor_Snapshot] --([SnapshotCommPeriodId])
--INCLUDE --([LegacyNumber])
--WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); 25s
----To Optimize: [sp_generate_periodSnapshot] 502,503
---query used to analize: --Execution Plan by Cost and STMT

DROP INDEX  ix_NN_tbl_Distributor_Commissions_Temp_v2_AccountType_Incl_Comp_4_21_2021
--ON [dbo].[tbl_Distributor_Commissions_Temp_v2] --([AccountType])
--INCLUDE --([DistributorId],[TotalCV])
--WITH --(ONLINE=ON,DATA_COMPRESSION=PAGE); --39
----[dba].sp_BlitzCache: 15654.267185107 cost. 59% improvement with this new index.


/*
DUPLICATED INDEXES
*/

-- DROP INDEX ix_NN_CURRENCYCODE_PEGRATE__Incl_Comp_4_16_2021 ON [dbo].tbl_Distributor_Commissions_Temp_v2

-- DROP INDEX idx_tbl_Orders_Header_Commissions_summary_v2_rundate_sequence ON [dbo].tbl_Orders_Header_Commissions_summary_v2

DROP INDEX IX_NN_tbldistributorcommissionsv2_CommPeriodId
--ON tbl_distributor_commissions_v2

/*
DROP INDEX IX_DistributorCommissions_LegacyCommperioID_ITotalCv
ON tbl_distributor_commissions_v2

DROP INDEX  [IX_DistributorCommissions_LegacyCommperioID_I] ON [dbo].[tbl_distributor_commissions_v2]
--(
	[LegacyNumber] ASC,
	[CommPeriodId] ASC
)
INCLUDE--([PaidAsRank],[ActiveTotalPV],[Dir300_1_Count],[WEEKGV],[PGV50],[custom9],[custom10],[Rnk9-gv-2weeks],[Rnk10-gv-3weeks],[Rnk11-gv-3weeks],[LesserBinaryVol],[LastLesserBinaryVol],[beforelastlesserbinaryvol],[TotalCV]) 
WITH --(STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = ON, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO --2M 39S
*/


DROP INDEX Ix_Nn_tbl_distributor_commissions_v2_CommPeriodId_DirectorBonusPaid
--ON tbl_distributor_commissions_v2


DROP INDEX IX_NN_tbldistributorcommissionsv2_CommPeriodId_I
--ON tbl_distributor_commissions_v2

DROP INDEX  [Ix_Nn_tbl_Distributor_Commissions_Temp_v2_CommPeriodId_Include] ON [dbo].[tbl_distributor_commissions_v2]
----(
--	[CommPeriodId] ASC
--)
--INCLUDE--([LegacyNumber],[EndRank],[WEEKGV],[Outgoing_Left_Vol],[Outgoing_Right_Vol],[BIWEEKGV],[Weak-2-weeks],[Qual-until-date],[DirectorBonusPaid],[LesserBinaryVol],[LastLesserBinaryVol],[PaidAsRank]) 
--WITH --(STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = ON, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
------2M 23S

DROP INDEX IX_NN_tbldistributorcommissionsv2_LegacyNumber
--ON tbl_distributor_commissions_v2

DROP INDEX IX_NN_tbldistributorcommissionsv2_CommPeriodId_ITotalCV
--ON tbl_distributor_commissions_v2

DROP INDEX IX_NN_tbldistributorcommissionsv2_LegacyNumber
--ON tbl_distributor_commissions_v2

DROP INDEX IX_DistributorCommissions_LegacyCommperioID_ITotalCv
--ON tbl_distributor_commissions_v2

DROP INDEX IX_NN_tbldistributorcommissionsv2_LegacyNumberCommPeriodId_ICustom
--ON tbl_distributor_commissions_v2

--After applying de DROP Index above, the performance on sp_CalculateVolume and its the depedent Stored procedures has not be improved.









