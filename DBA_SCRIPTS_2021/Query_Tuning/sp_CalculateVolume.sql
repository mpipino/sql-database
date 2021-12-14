--sp_CalculateVolume


--51:59 MINUTOS SIN MEMORY TABLE tbl_Orders_Header_Snapshot

EXEC [dba].sp_WhoIsActive
    @filter = '',
    @filter_type = 'session',
    @not_filter = '',
    @not_filter_type = 'session',
    @show_own_spid = 0,
    @show_system_spids = 0,
    @show_sleeping_spids = 1,
    @get_full_inner_text = 1,
    @get_plans = 1,
    @get_outer_command = 1,
    @get_transaction_info = 1,
    @get_task_info = 2,
    @get_locks = 1,
    @get_avg_time = 1,
    @get_additional_info = 1,
    @find_block_leaders = 1,
    @delta_interval = 1,
    @output_column_list = '[dd%][session_id][sql_text][sql_command][login_name][wait_info][tasks][tran_log%][cpu%][temp%][block%][reads%][writes%][context%][physical%][query_plan][locks][%]',
    @sort_order = '[start_time] ASC',
    @format_output = 1,    
    @return_schema = 0,
    @schema = NULL


-------------------------------------


[dba].sp_BlitzCache @StoredProcName = 'sp_CalculateVolume'
exec [dba].sp_BlitzCache @StoredProcName = 'commissions_Engine_CalculateDashboardVolumes'
[dba].sp_BlitzCache @StoredProcName = 'Sp_Generate_Periodsnapshot'
[dba].sp_BlitzCache @StoredProcName = 'Sp_Xc_Calculate_Commissions_V2'
[dba].sp_BlitzCache @StoredProcName = 'sp_Executive_Momentum_Calculate_Pool'

--ver logs de corridas
select * from tbl_Commission_Run_Logs where rundate = '2021-05-17'

--PARA VER SI ESTÁ CORRIENDO:
select top 100 * from [Commissions_Volumecalculationlog] 
where comments like '%Error while Running%'
order by id desc

select * from tbl_Commission_Run_Logs where rundate = '2021-05-20' --2955256
order by ID DESC

--[20:57] Graly Troncozo
    select * from tbl_Commission_Run_Logs where rundate = '2021-04-20' and id >= 2915522

EXEC dbo.sp_BlitzIndex @DatabaseName='Asea_Prod', @SchemaName='dbo', @TableName='tbl_distributor_commissions_v2';

-- NO SOPORTADO EN AZURE.EXEC sp_estimate_data_compression_savings 'dbo', 'tbl_distributor_commissions_v2', NULL, NULL, 'PAGE' ;  
--GO  

Declare @Database varchar(max)
Declare @Tabla varchar(max)
select  
                        GETDATE() AS SNAPSHOT_DATE,
                        S.[Name] as Tabla, 
             s.object_id,
             Si.[name] As Indice, SI.[index_id], SI.[type_desc] as Tipo_Indice,
             SIu.user_seeks,
             SIU.user_scans,
             SIU.user_lookups,
             SIU.user_updates,
             SIU.last_user_seek,
             SIU.last_user_scan,
             SIU.last_user_lookup,
             SIU.last_user_update
From sys.objects S 
Inner Join sys.indexes SI On S.object_id = SI.object_id
Inner Join sys.dm_db_index_usage_stats SIU On Siu.object_id = SI.object_id and SIU.index_id = SI.index_id
Where  S.[Name] = 'TBL_DISTRIBUTOR'
--(@Tabla is null or S.[name] = @Tabla)
and S.type = 'U'
--and SIU.database_id = DB_ID(@Database)
--Order by Tabla, Si.index_id
Order by SIu.user_seeks DESC

sp_helptext 'sp_CalculateVolume'


---Espacio ocupado
SELECT  getdate() as Run_Date
	,SCH.name AS SchemaName  
	,OBJ.name AS ObjName  
	,OBJ.type_desc AS ObjType  
	,INDX.name AS IndexName  
	,INDX.type_desc AS IndexType  
	,PART.partition_number AS PartitionNumber  
	,PART.rows AS PartitionRows  
	,STAT.row_count AS StatRowCount  
	,STAT.used_page_count * 8 AS UsedSizeKB  
	,STAT.reserved_page_count * 8 AS RevervedSizeKB  
FROM sys.partitions AS PART  
INNER JOIN sys.dm_db_partition_stats AS STAT  
	ON PART.partition_id = STAT.partition_id  AND PART.partition_number = STAT.partition_number  
INNER JOIN sys.objects AS OBJ  
	ON STAT.object_id = OBJ.object_id  
INNER JOIN sys.schemas AS SCH  
	ON OBJ.schema_id = SCH.schema_id  
INNER JOIN sys.indexes AS INDX  
	ON STAT.object_id = INDX.object_id  
AND STAT.index_id = INDX.index_id  
--WHERE OBJ.name = 'TBL_DISTRIBUTOR'
--ORDER BY SCH.name, OBJ.name, INDX.name, PART.partition_number  


-------------------------------------------------------------------
--TO DO:

--1)
/****** Object:  Index [UQ__tbl_Orde__858FAE712EE2CF90]    Script Date: 4/4/2021 10:39:42 AM ******/
-- Para evitar IndexLookUp.
--Parallel, Expensive Key Lookup, Expensive Sort, non-SARGables
--ALTER TABLE [dbo].[tbl_Orders_Header] DROP CONSTRAINT [UQ__tbl_Orde__858FAE712EE2CF90]
GO

/****** Object:  Index [UQ__tbl_Orde__858FAE712EE2CF90]    Script Date: 4/4/2021 10:39:43 AM ******/
--ALTER TABLE [dbo].[tbl_Orders_Header] ADD UNIQUE NONCLUSTERED 
(
	[LegacyNumber] ASC
)
INCLUDE (DistributorId,CreatedDate)
WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO

-----------------------------------------------------------

--2) Defragmentar índice por alto costo de UPDATES. Igualmente la tabla es muy ancha y los updates van a costar mucho. 
--No compromible tipos de datos numércios poco varchar.
--EXECUTE [dba].[IndexOptimize]
						 @Databases = 'Asea_Prod', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE'
						 ,@FragmentationHigh = 'INDEX_REORGANIZE', @FragmentationLevel1 = 10, @FragmentationLevel2 = 99
						 , @MaxDOP = 4				
						 --,@MaxNumberOfPages=200000
						 --,@MinNumberOfPages=10000
						 ,@Execute='n'
						 --,@LogToTable='y'
						 --Commissions_Distributor_Temp
						,@Indexes = 'Asea_Prod.dbo.tbl_Distributor_Commissions_summary_v2.PK__tbl_Dist__3213E83F804C112A'


3)
--Update [D]         Set             [D].[Paidasrank] = IsNull([C].[Paidasrank] , 0)         
--From [tbl_distributor_commissions_v2] [D]          
--Join [Dbo].[Tbl_Distributor] [C]             
--On [D].[commperiodid] = @commperiodidend                
--And [C].[Legacynumber] = [D].[Legacynumber]                
--And [C].[paidasrank] > [D].[Paidasrank]



SET NOCOUNT ON
SELECT 'ALTER INDEX '+ '[' + i.[name] + ']' + ' ON ' + '[' + s.[name] + ']' + '.' + '[' + o.[name] + ']' 
+ ' REBUILD WITH (DATA_COMPRESSION=PAGE);'
	, ps.[reserved_page_count],*
FROM sys.objects AS o WITH (NOLOCK)
INNER JOIN sys.indexes AS i WITH (NOLOCK)
ON o.[object_id] = i.[object_id]
INNER JOIN sys.schemas s WITH (NOLOCK)
ON o.[schema_id] = s.[schema_id]
INNER JOIN sys.dm_db_partition_stats AS ps WITH (NOLOCK)
ON i.[object_id] = ps.[object_id]
AND ps.[index_id] = i.[index_id]
WHERE o.type = 'U' AND i.[index_id] >0 and o.name='tbl_Distributor_Commissions_Temp_v2' 
AND i.[name]='idx_tbl_Distributor_Commissions_Temp_v2_Accounttype'
ORDER BY ps.[reserved_page_count] desc















  
  /*
   SP:
  */
-- =============================================         
-- Author: edelcastillo         
-- Create Date: 2020-08-24         
-- Dependencies: Commission Calculation         
-- Description:          
-- Notes:          
-- Modification:          
-- [Redmine Ticket]   50226, 52118       
--          
-- =============================================          
------CREATE Procedure [dbo].[sp_CalculateVolume]  
As  
Begin  
    Begin  
    Begin Try  
    Declare @execid [BigInt] = 0;  
    Insert Into [Commissions_Volumecalculationlog] (   
     [Comments] )   
    Values  
       (   
       'Calculation - Start'  
       );  
    Set @execid = ( Select   
         Scope_Identity() );  
    Declare @commperiodidstart Int = ( Select Top 1   
            [Id]  
           From [Tbl_Commperiods]  
           Where [Isclosed] = 0  
           Order By   
            [Id] );  
    Declare @commperiodidend Int= ( Select Top 1   
             [Id]  
            From [Tbl_Commperiods]  
            Where Convert(Date , [Dbo].[Getdatemst]()) Between Convert(Date , [Startdate]) And Convert(Date , [Enddate]) );  
    Update [Commissions_Volumecalculationlog]  
    Set   
   [Startcommperiodid] = @commperiodidstart  
     , [Endcommperiodid] = @commperiodidend  
    Where   
     [Id] = @execid;  
    Insert Into [Commissions_VolumeCalculationLog_Detail] (   
     [Commissions_VolumeCalculationLog_Id]  
   , [Comments]  
   , [CommPeriodId] )   
    Values  
       (   
       @execid  
     , 'update commperiods in [Commissions_Volumecalculationlog]'  
     , @commperiodidstart  
       );  
    Declare @Isexecuting SmallInt = 0;  
    While @commperiodidstart <= @commperiodidend  
    Begin                    
    --              
    Insert Into [Commissions_VolumeCalculationLog_Detail] (   
     [Commissions_VolumeCalculationLog_Id]  
       , [Comments]  
       , [CommPeriodId] )   
    Values  
       (   
       @execid  
     , 'execute [Sp_Generate_Periodsnapshot]'  
     , @commperiodidstart  
       );  
    Exec [Sp_Generate_Periodsnapshot]   
       @commperiodidstart  
     , @commperiodidend;                    
    --                
    Insert Into [Commissions_VolumeCalculationLog_Detail] (   
     [Commissions_VolumeCalculationLog_Id]  
       , [Comments]  
       , [CommPeriodId] )   
    Values  
       (   
       @execid  
     , 'execute [Sp_Xc_Calculate_Commissions_V2]'  
     , @commperiodidstart  
       );  
    Exec [Sp_Xc_Calculate_Commissions_V2]   
       1  
     , @commperiodidstart  
     , 0  
     , 1  
     , 0  
     , 0  
     , 0  
     , 0  
     , 0;                    
    --                    
    Set @Isexecuting = IsNull( ( Select Top 1   
          [Run]  
         From [Dbo].[Tbl_Commission_Execute]  
         Where [Type] = 1  
         Order By   
          [Id] Desc ) , 0);  
    If @Isexecuting != 1  
    Begin  
    Insert Into [Commissions_VolumeCalculationLog_Detail] (   
     [Commissions_VolumeCalculationLog_Id]  
       , [Comments]  
       , [CommPeriodId] )   
    Values  
       (   
       @execid  
     , 'execute [DiamondPoolReport_CalculateByPeriodId_Sp]'  
     , @commperiodidstart  
       );  
    Exec [DiamondPoolReport_CalculateByPeriodId_Sp]   
       @Periodid = @commperiodidstart;                   
    --,@showResult = 0            
    --EMP CALCULATION        
    If ( Select   
      Count(1)  
     From [TBL_COMMISSION_RUN_EMP_LOGS]  
     Where [commperiodid] = @commperiodidstart  
       And [applied] = 1  
       And [IsPayout] = 1 ) = 0  
    Begin  
        Insert Into [Commissions_VolumeCalculationLog_Detail] (   
         [Commissions_VolumeCalculationLog_Id]  
       , [Comments]  
       , [CommPeriodId] )   
        Values  
       (   
       @execid  
         , 'execute [sp_Executive_Momentum_Calculate_Pool] 0'  
         , @commperiodidstart  
       );  
        Exec [sp_Executive_Momentum_Calculate_Pool]   
       @commperiodidstart  
     , 0;  
        Insert Into [Commissions_VolumeCalculationLog_Detail] (   
         [Commissions_VolumeCalculationLog_Id]  
       , [Comments]  
       , [CommPeriodId] )   
        Values  
       (   
       @execid  
         , 'execute [sp_Executive_Momentum_Calculate_Pool] 1'  
         , @commperiodidstart  
       );  
        Exec [sp_Executive_Momentum_Calculate_Pool]   
       @commperiodidstart  
     , 1;  
    End;  
    End;  
    Set @commperiodidstart = @commperiodidstart + 1;  
    End;  
  
/*        
  RANK UPDATE AFTER VOLUME CALCULATION IS COMPLETE        
*/  
    Begin -- rank update after LDP             
    Insert Into [Commissions_VolumeCalculationLog_Detail] (   
     [Commissions_VolumeCalculationLog_Id]  
       , [Comments]  
       , [CommPeriodId] )   
    Values  
       (   
       @execid  
     , 'execute [rank update after LDP 1]'  
     , @commperiodidend  
       );  
  
    --update [Tbl_Distributor] .[Paidasrank] & .[Currenttitle]        
    Update [D]  
    Set   
       [D].[Paidasrank] = IsNull([C].[Original_Paidasrankid] , 0)  --this is the calculated paidasrank                       
     , [D].[Currenttitle] = IsNull([C].[Original_Paidasrankid] , 0)  
    From [Dbo].[Tbl_Distributor] [D]  
     Join [Tbl_Leadership_Development_Pool_Rank_Achievements] [C]  
      On [C].[commperiodid] = @commperiodidend  
         And [D].[Legacynumber] = [C].[Distributorid]  
         And [C].[Original_Paidasrankid] > 11;  
    Insert Into [Commissions_VolumeCalculationLog_Detail] (   
     [Commissions_VolumeCalculationLog_Id]  
       , [Comments]  
       , [CommPeriodId] )   
    Values  
       (   
       @execid  
     , 'execute [rank update after LDP 2]'  
     , @commperiodidend  
       );  
    Declare @rundate Date = ( Select   
           Max([rundate])  
          From [tbl_distributor_commissions_summary_v2] );  
    Declare @runsequence Int = ( Select   
          Max([runsequence])  
         From [tbl_distributor_commissions_summary_v2]  
         Where [rundate] = @rundate );  
  
    --paidasrank in summary, only updates the paid as rank that increased in LDP        
    Update [Dc]  
    Set   
       [Dc].[endrank] = IsNull([D].[Paidasrank] , 0)  
    From [Dbo].[Tbl_Distributor_commissions_summary_v2] [Dc]  
     Join [Tbl_Distributor] [D]  
      On [Dc].[rundate] = @rundate  
         And [Dc].[runsequence] = @runsequence  
         And [D].[Legacynumber] = [Dc].[Distributorid]  
         And IsNull([D].[Paidasrank] , 0) > IsNull([Dc].[endrank] , 0);  
  
    --lifetimerank in summary, only updates the paid as rank that increased in LDP        
    Update [Dc]  
    Set   
       [Dc].[Lifetimerankid] = IsNull([Dc].[EndRank] , 0)  
    From [Dbo].[Tbl_Distributor_commissions_summary_v2] [Dc]  
    Where   
     [Dc].[rundate] = @rundate  
     And [Dc].[runsequence] = @runsequence  
     And IsNull([Dc].[EndRank] , 0) > IsNull([Dc].[Lifetimerankid] , 0);  
    Insert Into [Commissions_VolumeCalculationLog_Detail] (   
     [Commissions_VolumeCalculationLog_Id]  
       , [Comments]  
       , [CommPeriodId] )   
    Values  
       (   
       @execid  
     , 'execute [rank update after LDP 3]'  
     , @commperiodidend  
       );  
  
    --paidasrank in Commissions table        
    Update [D]  
    Set   
       [D].[Paidasrank] = IsNull([C].[Paidasrank] , 0)  
    From [tbl_distributor_commissions_v2] [D]  
     Join [Dbo].[Tbl_Distributor] [C]  
      On [D].[commperiodid] = @commperiodidend  
         And [C].[Legacynumber] = [D].[Legacynumber]  
         And [C].[paidasrank] > [D].[Paidasrank];  
    End;  
  
    ----------------------------          
    Insert Into [Commissions_VolumeCalculationLog_Detail] (   
     [Commissions_VolumeCalculationLog_Id]  
   , [Comments]  
   , [CommPeriodId] )   
    Values  
       (   
       @execid  
     , 'execute [update lastorder values] '  
     , @commperiodidstart  
       );  
    With SuccessfullOrders  
     As (Select   
      [o].[distributorid]  
        , Max([o].[legacynumber]) As [orderNumber]  
     From [tbl_Orders_Header] As [o]  
      Join [tbl_orderstatus] As [s]  
       On [o].[orderstatus] = [s].[orderstatusid]  
          And [s].[Successful] = 1  
     Where [CommPeriodId] = @commperiodidstart  
     Group By   
      [o].[distributorid]) ,  
     OrderData  
     As (Select   
      [o].[distributorid]  
        , [o].[legacynumber]  
        , [o].[Ordertotal]  
        , IsNull([o].[Orderdate] , [o].[Createddate]) As [Orderdate]  
     From [tbl_Orders_Header] As [o]  
      Join [SuccessfullOrders] As [so]  
       On [o].[legacynumber] = [so].[orderNumber]) --select * from OrderData          
     Update [D]  
     Set   
    [D].[Lastorderdate] = [OD].[orderdate]  
      , [D].[Lastorderno] = [OD].[Legacynumber]  
      , [D].[Lastordertotal] = [OD].[Ordertotal]  
     From [Tbl_Distributor] [D]  
      Join [OrderData] [OD]  
       On [D].[Legacynumber] = [OD].[Distributorid];  
  
    --------------------------------------------------          
    Update [Commissions_Volumecalculationlog]  
    Set   
   [Run] = 0  
     , [Endtime] = Getdate()  
     , [Comments] = 'Calculation - Finish'  
    Where   
     [Id] = @execid;  
    End Try  
    Begin Catch  
    Update [Commissions_Volumecalculationlog]  
    Set   
   [Run] = 0  
     , [Endtime] = Getdate()  
     , [Comments] = 'Error while Running. Found In : ' + ( Select   
                Error_Procedure() ) + ' > ' + ( Select   
                         Error_Message() )  
     , [sendNotification] = 1  
    Where   
     [Id] = @execid;  
    Select   
     Error_Number() As [Errornumber]  
   , Error_Severity() As [Errorseverity]  
   , Error_State() As [Errorstate]  
   , Error_Procedure() As [Errorprocedure]  
   , Error_Line() As [Errorline]  
   , Error_Message() As [Errormessage];  
    End Catch;  
    End;  
End;  
 
 /*
 4/19/2021.

 ---Observations about WAITS: 
 Command: [dba].[sp_BlitzFirst] @expertmode=1
 WAIT TYPE:
 VDI_CLIENT_OTHER
 This wait type is when a thread is waiting for more work when seeding a new availability group replica
 , or in Azure when something triggers a database copy, like changing a service tier or setting up geo-replication.
 Number of WAITS:12
 avg ms per Wait: 4771.0

 Executon time: 1 hour:
	   command: [dba].sp_WhoIsActive
       Reads: 1,008,769,025 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	   Writes: 2,393,539
	   ContextSwitches: 76,343,189
	   -----------------------------------------------------
	   Reads: 964,884,977
	   Writes: 2,238,494
	   ContextSwitches: 78,312,411

	   RESULTS: NO MAYOR CHANGES OCCURRED USING PARALLELISM=1

	   VDI_CLIENT_OTHER is the most wait type using parallelism=0 and 1.
 */

/*
 TEST:
 
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 1;
GO

/*------------------------
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 1; 4/19/2021 18:21 executed by Deivi Gomez by Gastón Abalde Request.
------------------------*/
Msg 15247, Level 16, State 13, Line 470
User does not have permission to perform this action.

Completion time: 2021-04-19T18:09:41.2936740-03:00


GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
*/