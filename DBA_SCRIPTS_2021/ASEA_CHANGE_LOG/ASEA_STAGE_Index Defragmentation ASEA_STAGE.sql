EXECUTE [dba].[IndexOptimize]
						 @Databases = 'Asea_stage', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE'
						 ,@FragmentationHigh = 'INDEX_REORGANIZE', @FragmentationLevel1 = 20, @FragmentationLevel2 = 40
						 --,@FragmentationHigh = 'INDEX_REORGANIZE', @FragmentationLevel1 = 40, @FragmentationLevel2 = 80
						 , @MaxDOP = 4				
						 --,@MaxNumberOfPages=10000
						 --,@MinNumberOfPages=10000
						 ,@Execute='y'
						 ,@LogToTable='y'
						 --Commissions_Distributor_Temp
						 --,@Indexes = 'BodyLogic_Live.dbo.Commissions_Distributor_Temp'
						 --,@Indexes = 'Asea_Prod.dbo.tbl_distributor_commissions_v2.PK__tbl_dist__3214EC275D93B669'

SELECT sum(datediff(mi,StartTime,Endtime))
  FROM [dba].[tbl_Command_Log]
  WHERE CommandType='ALTER_INDEX'

