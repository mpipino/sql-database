--Compresion y particionamiento de Commissions_Distributor_Temp
--ALTER TABLE [dbo].[Commissions_Distributor_Temp] REBUILD PARTITION = ALL
WITH 
(DATA_COMPRESSION = PAGE
)


--SELECT COUNT(*) FROM [dbo].[Commissions_Distributor_Temp]

