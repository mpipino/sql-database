exec dba.sp_BlitzIndex

EXEC dbo.sp_BlitzIndex @DatabaseName='Asea_Prod', @SchemaName='dbo', @TableName='tbl_distributor_commissions_v2';
EXEC dbo.sp_BlitzIndex @DatabaseName='Asea_Prod', @SchemaName='dbo', @TableName='tbl_Orders_Header';