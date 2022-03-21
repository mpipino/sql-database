--hacerlo en BodyLogic.
Select count(*) FROM Log_WebService --3.459.394
where CreatedDate < DATEADD(day, -30, GETDATE()) 
--3.459.394
--3.409.508
--3.060.189
--2.796.067
--1.763.513
--1.115.179
--815.942
--716.727
--718.117

DELETE TOP (50000) FROM Log_WebService
where CreatedDate < DATEADD(day, -30, GETDATE())
Select 'Proximo'
WAITFOR DELAY '00:00:5'
go 100

--DROP PROC  [##IndexOptimize]
EXECUTE [dbo].[##IndexOptimize] --requiere crear antes el command execute
						 @Databases = 'BodyLogic_Live', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE'
						 --,@FragmentationHigh = 'INDEX_REBUILD_ONLINE', @FragmentationLevel1 = 10, @FragmentationLevel2 = 40
						 ,@FragmentationHigh = 'INDEX_REORGANIZE', @FragmentationLevel1 = 40, @FragmentationLevel2 = 80
						 , @MaxDOP = 4				
						 --,@MaxNumberOfPages=5000
						 --,@MinNumberOfPages=1000
						 ,@Execute='y'
						 --,@LogToTable='y'
						 --Commissions_Distributor_Temp
						 --,@Indexes = 'asea_Stage.dbo.tbl_distributor_commissions_v2'
						 --,@Indexes = 'Asea_Prod.dbo.tbl_distributor_commissions_v2.PK__tbl_dist__3214EC275D93B669'
