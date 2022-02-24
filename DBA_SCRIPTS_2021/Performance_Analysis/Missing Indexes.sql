-- Este esta bueno porque da el ultimo index seek asi vemos de crear indices que sean usados  
-- Missing indexes with CREATE statement for it  
SELECT    MID.[statement] AS ObjectName  
	,MID.equality_columns AS EqualityColumns  
	,MID.inequality_columns AS InequalityColms  
	,MID.included_columns AS IncludedColumns  
	,MIGS.last_user_seek AS LastUserSeek  
	,MIGS.avg_total_user_cost  
	* MIGS.avg_user_impact  * (MIGS.user_seeks + MIGS.user_scans) AS Impact  
	,N'CREATE NONCLUSTERED INDEX ix_NN_' + REPLACE(REPLACE(REPLACE(MID.equality_columns, ']', '_'),'[',''), ',','_') + '_Incl_Comp_21_1_2021 ' +
	N'ON ' + MID.[statement] +  
	N' (' + MID.equality_columns  
	+ ISNULL(', ' + MID.inequality_columns, N'') +  
	N') ' + ISNULL(N'INCLUDE (' + MID.included_columns + N')', ' ') + 'WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs'
	AS CreateStatement   
FROM sys.dm_db_missing_index_group_stats AS MIGS  
 INNER JOIN sys.dm_db_missing_index_groups AS MIG  
	 ON MIGS.group_handle = MIG.index_group_handle  
INNER JOIN sys.dm_db_missing_index_details AS MID  
	 ON MIG.index_handle = MID.index_handle  
WHERE database_id = DB_ID()  
	 AND MIGS.last_user_seek >= DATEDIFF(month, GetDate(), -1)  
ORDER BY Impact DESC;
--ORDER BY LastUserSeek desc, Impact DESC;
go

/*
CREATE NONCLUSTERED INDEX ix_NN_DistLegacyNumber__ Month__ LoyaltyDiscountType__Incl_Comp_21_1_2021 
ON [BodyLogic_Live].[dbo].[Distributor_LoyaltyDiscount] ([DistLegacyNumber], [Month], [LoyaltyDiscountType])  
WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_DistLegacyNumber__ LoyaltyDiscountType__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[Distributor_LoyaltyDiscount] 
([DistLegacyNumber], [LoyaltyDiscountType])  
WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_DistAccountType__ CommissionsPeriodId__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[Distributor_LoyaltyDiscount] ([DistAccountType], [CommissionsPeriodId], [LoyaltyDiscountType]) INCLUDE ([DistLegacyNumber], [Discount])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_LegacyNumber__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[tbl_Distributor] ([LegacyNumber]) INCLUDE ([LastName], [EmailAddress], [UserStatus])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_CountryRegionId__ MarketId__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[tbl_Addresses] ([CountryRegionId], [MarketId]) INCLUDE ([Id])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_IsUpload__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[Resource] ([IsUpload]) INCLUDE ([URL])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_DistLegacyNumber__ CommissionsPeriodId__ LoyaltyDiscountType__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[Distributor_LoyaltyDiscount] ([DistLegacyNumber], [CommissionsPeriodId], [LoyaltyDiscountType]) INCLUDE ([Discount])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_CommissionsPeriodId__ LoyaltyDiscountType__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[Distributor_LoyaltyDiscount] ([CommissionsPeriodId], [LoyaltyDiscountType]) INCLUDE ([DistLegacyNumber], [Discount])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_AccountType__ BillingAddressID__ UserStatus__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[tbl_Distributor] ([AccountType], [BillingAddressID], [UserStatus]) INCLUDE ([JoinDate])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_AccountType__ UserStatus__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[tbl_Distributor] ([AccountType], [UserStatus]) INCLUDE ([BillingAddressID], [JoinDate])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_CommissionsPeriodId__ DistributorIdEarning__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[Bl_Commissions_Bonus_TeamBonusDetail] ([CommissionsPeriodId], [DistributorIdEarning]) INCLUDE ([DistributorIdChild], [CompressLevel], [ActiveTotalCv], [TeamBonusPercent], [TeamBonusValue])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_DistLegacyNumber__ DistAccountType__ CommissionsPeriodId__ LoyaltyDiscountType__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[Distributor_LoyaltyDiscount] ([DistLegacyNumber], [DistAccountType], [CommissionsPeriodId], [LoyaltyDiscountType])  WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_UserId__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[Lgt].[Warehouse_User_Details] ([UserId])  WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_DistLegacyNumber__ CommissionsPeriodId__ LoyaltyDiscountType__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[Distributor_LoyaltyDiscount] ([DistLegacyNumber], [CommissionsPeriodId], [LoyaltyDiscountType])  WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_DistLegacyNumber__ LoyaltyDiscountType__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[Distributor_LoyaltyDiscount] ([DistLegacyNumber], [LoyaltyDiscountType], [CommissionsPeriodId], [Discount])  WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_CommissionsPeriodId__ LoyaltyDiscountType__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[Distributor_LoyaltyDiscount] ([CommissionsPeriodId], [LoyaltyDiscountType]) INCLUDE ([DistLegacyNumber])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_DistAccountType__ CommissionsPeriodId__ Discount__ LoyaltyDiscountType__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[Distributor_LoyaltyDiscount] ([DistAccountType], [CommissionsPeriodId], [Discount], [LoyaltyDiscountType]) INCLUDE ([DistLegacyNumber])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_LoyaltyDiscountType__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[dbo].[Distributor_LoyaltyDiscount] ([LoyaltyDiscountType], [CommissionsPeriodId], [Discount]) INCLUDE ([DistLegacyNumber])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs

CREATE NONCLUSTERED INDEX ix_NN_MarketId__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[Lgt].[Warehouse_Folio_Details] ([MarketId], [WarehouseFolioDetailRequestType]) INCLUDE ([FolioId], [WarehouseId])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs
CREATE NONCLUSTERED INDEX ix_NN_MarketId__Incl_Comp_21_1_2021 ON [BodyLogic_Live].[Lgt].[Warehouse_Folio_Details] ([MarketId], [WarehouseFolioDetailRequestType]) INCLUDE ([FolioId], [WarehouseId])WITH (ONLINE=ON,DATA_COMPRESSION=PAGE); -- 0 secs































*/