--Renombré sp_XC_Calculate_Commissions_v2 a sp_XC_Calculate_Commissions_v2_old
--Le saqué referencia a un índice porque tiene 41 columnas! y al crear el ínidce hash en memorua daba error!:
--Index 'Missing_Index_19230_19229' on table 'Tbl_Orders_Header_Snapshot' (specified in the FROM clause) does not exist.


EXEC dbo.sp_rename @objname = N'[dbo].[tbl_Orders_Header_Snapshot]', @newname = N'tbl_Orders_Header_Snapshot_old', @objtype = N'OBJECT'
GO

SET ANSI_NULLS ON
GO

CREATE TABLE [dbo].[tbl_Orders_Header_Snapshot]
(
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SnapshotCommPeriodId] [int] NULL,
	[LegacyNumber] [bigint] NULL,
	[OrderDate] [datetime] NULL,
	[OrderType] [int] NULL,
	[DistributorId] [bigint] NULL,
	[OrderStatus] [smallint] NULL,
	[CountryCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderSource] [int] NULL,
	[DistributorStatus] [int] NULL,
	[CommPeriodId] [int] NULL,
	[WarehouseId] [int] NULL,
	[MarketId] [int] NULL,
	[SubTotal] [decimal](18, 2) NULL,
	[TotalTaxCharged] [decimal](18, 2) NULL,
	[TotlShippingCharged] [decimal](18, 2) NULL,
	[TotalShippingTax] [decimal](18, 2) NULL,
	[OrderTotal] [decimal](18, 2) NULL,
	[TaxableAmount] [float](53) NULL,
	[TaxPercent] [float](53) NULL,
	[AutoshipOrderNo] [int] NULL,
	[DateCompleted] [datetime] NULL,
	[IsInitialOrder] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DeletedDate] [date] NULL,
	[CommValue] [decimal](18, 2) NULL,
	[QualVolume] [decimal](18, 2) NULL,
	[QUALIFYINGVOLUME] [decimal](18, 2) NULL,
	[Custom1] [float](53) NULL,
	[Custom2] [float](53) NULL,
	[Custom3] [float](53) NULL,
	[Custom4] [float](53) NULL,
	[Custom5] [float](53) NULL,
	[IsRetail] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Custom6] [float](53) NULL,
	[Custom7] [float](53) NULL,
	[Custom8] [float](53) NULL,
	[Custom9] [float](53) NULL,
	[RMAOrder] [bigint] NULL,
	[UPDATEDBY] [int] NULL,
	[UPDATEDDATE] [datetime] NULL,
	[DateShipped] [datetime] NULL,

INDEX [missing_index_13746_13745] NONCLUSTERED HASH 
(
	[LegacyNumber]
)WITH ( BUCKET_COUNT = 4194304),
 CONSTRAINT [tbl_Orders_Header_Snapshot_primaryKey]  PRIMARY KEY NONCLUSTERED HASH 
(
	[ID]
)WITH ( BUCKET_COUNT = 4194304)
)WITH ( MEMORY_OPTIMIZED = ON , DURABILITY = SCHEMA_ONLY )

GO

SET IDENTITY_INSERT [Asea_Stage].[dbo].[tbl_Orders_Header_Snapshot] ON 

GO

INSERT INTO [Asea_Stage].[dbo].[tbl_Orders_Header_Snapshot] ([ID], [SnapshotCommPeriodId], [LegacyNumber], [OrderDate], [OrderType], [DistributorId], [OrderStatus], [CountryCode], [CurrencyCode], [OrderSource], [DistributorStatus], [CommPeriodId], [WarehouseId], [MarketId], [SubTotal], [TotalTaxCharged], [TotlShippingCharged], [TotalShippingTax], [OrderTotal], [TaxableAmount], [TaxPercent], [AutoshipOrderNo], [DateCompleted], [IsInitialOrder], [DeletedDate], [CommValue], [QualVolume], [QUALIFYINGVOLUME], [Custom1], [Custom2], [Custom3], [Custom4], [Custom5], [IsRetail], [Custom6], [Custom7], [Custom8], [Custom9], [RMAOrder], [UPDATEDBY], [UPDATEDDATE], [DateShipped]) SELECT [ID], [SnapshotCommPeriodId], [LegacyNumber], [OrderDate], [OrderType], [DistributorId], [OrderStatus], [CountryCode], [CurrencyCode], [OrderSource], [DistributorStatus], [CommPeriodId], [WarehouseId], [MarketId], [SubTotal], [TotalTaxCharged], [TotlShippingCharged], [TotalShippingTax], [OrderTotal], [TaxableAmount], [TaxPercent], [AutoshipOrderNo], [DateCompleted], [IsInitialOrder], [DeletedDate], [CommValue], [QualVolume], [QUALIFYINGVOLUME], [Custom1], [Custom2], [Custom3], [Custom4], [Custom5], [IsRetail], [Custom6], [Custom7], [Custom8], [Custom9], [RMAOrder], [UPDATEDBY], [UPDATEDDATE], [DateShipped] FROM [Asea_Stage].[dbo].[tbl_Orders_Header_Snapshot_old] 

GO

SET IDENTITY_INSERT [Asea_Stage].[dbo].[tbl_Orders_Header_Snapshot] OFF 

GO


