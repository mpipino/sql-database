--hacerlo en BodyLogic.
Select count(*) FROM Log_WebService with (nolock)--3.459.394
where CreatedDate < DATEADD(day, -30, GETDATE()) 
--BodyLogic:
--3.459.394
--3.409.508
--3.060.189
--2.796.067
--1.763.513
--1.115.179
--815.942
--716.727
--718.117

--MODBALLS:
--285.529

DELETE TOP (5000) FROM Log_WebService
where CreatedDate < DATEADD(day, -30, GETDATE())
Select 'Proximo'
WAITFOR DELAY '00:00:30'
go 100

--DROP PROC  [##IndexOptimize]
EXECUTE [dbo].[##IndexOptimize] --requiere crear antes el command execute
						 @Databases = 'BodyLogic_Live', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE'
						 --,@FragmentationHigh = 'INDEX_REBUILD_ONLINE', @FragmentationLevel1 = 10, @FragmentationLevel2 = 40
						 ,@FragmentationHigh = 'INDEX_REORGANIZE', @FragmentationLevel1 = 1, @FragmentationLevel2 = 80
						 , @MaxDOP = 4				
						 --,@MaxNumberOfPages=5000
						 --,@MinNumberOfPages=1000
						 ,@Execute='n'
						 --,@LogToTable='y'
						 --Commissions_Distributor_Temp
						 ,@Indexes = 'bodylogic_live.dbo.Log_WebService'
						 --,@Indexes = 'Asea_Prod.dbo.tbl_distributor_commissions_v2.PK__tbl_dist__3214EC275D93B669'
