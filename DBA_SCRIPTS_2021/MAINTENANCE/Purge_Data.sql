-- =============================================                        
-- Redmine Ticket: #34295                        
-- Author: Graly Troncozo                        
-- Create Date: 2018-08-09                        
-- Process: Clean Data - Run in a Job                        
-- Modification:                         
--  Andrez Otiniano [24/08/2018] add 4 last periods of autoship projection - Ticket 35411                    
--  Jefferson Escudero [21/09/2018] Remove "Truncate Table TBL_ASEA_ASCENT_SUMMARY"                  
--  Andrez Otiniano [18/02/2019] ticket 35411 was not published, set all @4PreviousWeek to 0                
--  Andrez Otiniano [22/02/2019] change removed by truncate :Tbl_Autoship_Projected_Profiles                
--  Graly Troncozo [30/07/2019] Ticket [#45835] change truncate by 2 weeks: Tbl_Logs_Autdit              
--  Graly Troncozo [24/09/2019] Ticket [#46415] Change physical table to temporary table Tbl_Autoship_Projected_Profiles_Cleandata            
--  Graly Troncozo [03/06/2020] Ticket [#50319] add by 6 weeks: Taxavalara         
--  Graly Troncozo [30/06/2020] Ticket [#50319] add by 2 months: ApiLandmark       
-- =============================================                        
    
CREATE   Procedure [Dbo].[Table_Cleandata_Sp]    
As    
Begin    
    Declare @maxRunSequence Int;    
    Declare @rowNumber Int;    
    Declare @deleteTypeLog SmallInt = 4;    
    Declare @processId SmallInt = 99;    
    Declare @finishTime VarChar(50);    
    Declare @startTime VarChar(50)= 'Start time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Process: Starting Clean Data'    
 , @startTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';    
    
    /*-----------------Truncate Table-----------------*/    
    Truncate Table [Tbl_Distributor_Commissions_Summary_V2];    
    Truncate Table [Tbl_Leadership_Development_Pool_Ranks_Audit_Temp];    
    Truncate Table [Tbl_Logs];    
    Truncate Table [Tbl_Bonus_Matching_Temp_V2];    
    Truncate Table [Tbl_Leadership_Development_Pool_Downline_Temp];    
    Truncate Table [Tbl_Adjustments_Summary_V2];    
    Truncate Table [Tbl_Bonus_Team_Commissions_Summary_V2];    
    Truncate Table [Tbl_Executive_Momentum_Pool_Temp];    
    Truncate Table [Tbl_Leadership_Development_Pool_Golds_Temp];    
    Truncate Table [Tbl_Bonus_Preferred_Temp_V2];    
    Truncate Table [Tbl_Leadership_Development_Pool_Ranks_Details_Temp];    
    Truncate Table [Tbl_Leadership_Development_Pool_Distributorperiods_Temp];    
    Truncate Table [Tbl_Balance_Summary_V2];    
    Truncate Table [Tbl_Bonus_Fast_Start_Temp_V2];    
    Truncate Table [Distributor_Commissions_Bonus_Summary];    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Truncate tables'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';    
    Alter Table [Tbl_Distributor_Commissions_temp_V2] Rebuild    
    With(Data_Compression = Page);    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Sql page Compression on [Tbl_Distributor_Commissions_temp_V2]'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';    
    
    /*-----------------Delete history Data-----------------*/      
    /*----------------------------------------------------------*/      
    /*-------------tbl_Autoship_Projected_Profiles--------------*/      
    /*---------------Last run sequence applied------------------*/    
    Declare @enddate DateTime;    
    Declare @4PreviousWeek Int;    
    Create Table [#Maxrunsequence] (     
     [Runsequence] Int );    
    Create Table [#Commperiodhistory] (     
     [Periodid] Int );    
    Declare @getdateNow DateTime = [Dbo].[Fn_Get_Cstdate]();    
    Declare @currentPeriodid Int= ( ( Select Top 1     
           [Pv].[Periodid]    
          From [Tbl_Commperiods] As [Pv]    
          Where Convert(Date , @getdateNow) Between Convert(Date , [Startdate]) And Convert(Date , [Enddate]) ) );    
    Insert Into [#Maxrunsequence]    
    Select     
     Max([A].[Runsequence])    
    From [Dbo].[Tbl_Autoship_Projected_Profiles] As [A](Nolock)    
    Where [A].[Runsequence] In ( Select     
          [S].[Runsequence]    
         From [Tbl_Autoship_Projected_Sequences] As [S](Nolock) );    
    Select     
     [Id]    
   , [Maindistributorid]    
   , [Distributorid]    
   , [Binarysponsorid]    
   , [Dist_Status]    
   , [Year_Next]    
   , [Month_Next]    
   , [Day_Next]    
   , [Order_Number]    
   , [Pv_Amount]    
   , [Next_Run_Date]    
   , [Date_Last_Gen]    
   , [Createddate]    
   , [Runsequence]    
   , [Source]    
   , [Country_Code]    
   , [Sponsorsequence]    
   , [Email]    
   , [Phone]    
    Into     
     [#Tbl_Autoship_Projected_Profiles_Cleandata]    
    From [Dbo].[Tbl_Autoship_Projected_Profiles];    
    Truncate Table [Tbl_Autoship_Projected_Profiles];    
    Insert Into [Tbl_Autoship_Projected_Profiles] (     
     [Maindistributorid]    
   , [Distributorid]    
   , [Binarysponsorid]    
   , [Dist_Status]    
   , [Year_Next]    
   , [Month_Next]    
   , [Day_Next]    
   , [Order_Number]    
   , [Pv_Amount]    
   , [Next_Run_Date]    
   , [Date_Last_Gen]    
   , [Createddate]    
   , [Runsequence]    
   , [Source]    
   , [Country_Code]    
   , [Sponsorsequence]    
   , [Email]    
   , [Phone] )     
    Select     
     [Maindistributorid]    
   , [Distributorid]    
   , [Binarysponsorid]    
   , [Dist_Status]    
   , [Year_Next]    
   , [Month_Next]    
   , [Day_Next]    
   , [Order_Number]    
   , [Pv_Amount]    
   , [Next_Run_Date]    
   , [Date_Last_Gen]    
   , [Createddate]    
   , [Runsequence]    
   , [Source]    
   , [Country_Code]    
   , [Sponsorsequence]    
   , [Email]    
   , [Phone]    
    From [#Tbl_Autoship_Projected_Profiles_Cleandata]    
    Where [Runsequence] In ( Select     
          [Runsequence]    
         From [#Maxrunsequence] );    
    Drop Table [#Tbl_Autoship_Projected_Profiles_Cleandata];    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Autoship_Projected_Profiles'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';    
    Update Statistics [Tbl_Autoship_Projected_Profiles];    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Update Statistics: Tbl_Autoship_Projected_Profiles'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Autoship_Projected_Profiles';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Xirect_Defragindexes: Tbl_Autoship_Projected_Profiles'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*----------------------------------------------------------*/      
    /*----------Tbl_Autoship_Projected_Earned_Autoships---------*/      
    /*---------------Last run sequence applied------------------*/    
    Set @4PreviousWeek = 0;    
    Truncate Table [#Maxrunsequence];    
    While @4PreviousWeek >= 0    
    Begin    
    Set @enddate = ( Select     
      Convert(Date , [Enddate])    
     From [Tbl_Commperiods] As [Pv]    
     Where [Pv].[Periodid] = @currentPeriodid - @4PreviousWeek );    
    Insert Into [#Maxrunsequence]    
    Select     
     IsNull(Max([A].[Runsequence]) , 0)    
    From [Tbl_Autoship_Projected_Earned_Autoships] As [A](Nolock)    
    Where [A].[Runsequence] In ( Select Distinct     
          [S].[Runsequence]    
         From [Tbl_Autoship_Projected_Sequences] As [S](Nolock)    
         Where Convert(Date , [Createddate]) <= Convert(Date , @enddate) );    
    Set @4PreviousWeek = @4PreviousWeek - 1;    
    End;    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (1000000)    
    From [Tbl_Autoship_Projected_Earned_Autoships]    
    Where     
     [Runsequence] Not In ( Select     
         [Runsequence]    
        From [#Maxrunsequence] );    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Autoship_Projected_Earned_Autoships];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Autoship_Projected_Earned_Autoships';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Autoship_Projected_Earned_Autoships'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*----------------------------------------------------------*/      
    /*--------Tbl_Autoship_Projected_Cancelled_Autoships--------*/      
    /*---------------Last run sequence applied------------------*/    
    Set @4PreviousWeek = 0;    
    Truncate Table [#Maxrunsequence];    
    While @4PreviousWeek >= 0    
    Begin    
    Set @enddate = ( Select     
      Convert(Date , [Enddate])    
     From [Tbl_Commperiods] As [Pv]    
     Where [Pv].[Periodid] = @currentPeriodid - @4PreviousWeek );    
    Insert Into [#Maxrunsequence]    
    Select     
     IsNull(Max([A].[Runsequence]) , 0)    
    From [Tbl_Autoship_Projected_Cancelled_Autoships] As [A](Nolock)    
    Where [A].[Runsequence] In ( Select Distinct     
          [S].[Runsequence]    
         From [Tbl_Autoship_Projected_Sequences] As [S](Nolock)    
         Where Convert(Date , [Createddate]) <= Convert(Date , @enddate) );    
    Set @4PreviousWeek = @4PreviousWeek - 1;    
    End;    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (1000000)    
    From [Tbl_Autoship_Projected_Cancelled_Autoships]    
    Where     
     [Runsequence] Not In ( Select     
         [Runsequence]    
        From [#Maxrunsequence] );    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Autoship_Projected_Cancelled_Autoships];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Autoship_Projected_Cancelled_Autoships';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Autoship_Projected_Cancelled_Autoships'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*----------------------------------------------------------*/      
    /*----------Tbl_Autoship_Projected_Delayed_Orders-----------*/      
    /*---------------Last run sequence applied------------------*/    
    
    Set @4PreviousWeek = 0;    
    Truncate Table [#Maxrunsequence];    
    While @4PreviousWeek >= 0    
    Begin    
    Set @enddate = ( Select     
      Convert(Date , [Enddate])    
     From [Tbl_Commperiods] As [Pv]    
     Where [Pv].[Periodid] = @currentPeriodid - @4PreviousWeek );    
    Insert Into [#Maxrunsequence]    
    Select     
     IsNull(Max([A].[Runsequence]) , 0)    
    From [Tbl_Autoship_Projected_Delayed_Orders] As [A](Nolock)    
    Where [A].[Runsequence] In ( Select Distinct     
          [S].[Runsequence]    
         From [Tbl_Autoship_Projected_Sequences] As [S](Nolock)    
         Where Convert(Date , [Createddate]) <= Convert(Date , @enddate) );    
    Set @4PreviousWeek = @4PreviousWeek - 1;    
    End;    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (1000000)    
    From [Tbl_Autoship_Projected_Delayed_Orders]    
    Where     
     [Runsequence] Not In ( Select     
         [Runsequence]    
        From [#Maxrunsequence] );    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Autoship_Projected_Delayed_Orders];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Autoship_Projected_Delayed_Orders';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Autoship_Projected_Delayed_Orders'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*----------------------------------------------------------*/      
    /*----------Tbl_Autoship_Projected_Failed_Orders------------*/      
    /*---------------Last run sequence applied------------------*/    
    Set @4PreviousWeek = 0;    
    Truncate Table [#Maxrunsequence];    
  While @4PreviousWeek >= 0    
    Begin    
    Set @enddate = ( Select     
      Convert(Date , [Enddate])    
     From [Tbl_Commperiods] As [Pv]    
     Where [Pv].[Periodid] = @currentPeriodid - @4PreviousWeek );    
    Insert Into [#Maxrunsequence]    
    Select     
     IsNull(Max([A].[Runsequence]) , 0)    
    From [Tbl_Autoship_Projected_Failed_Orders] As [A](Nolock)    
    Where [A].[Runsequence] In ( Select Distinct     
          [S].[Runsequence]    
         From [Tbl_Autoship_Projected_Sequences] As [S](Nolock)    
         Where Convert(Date , [Createddate]) <= Convert(Date , @enddate) );    
    Set @4PreviousWeek = @4PreviousWeek - 1;    
    End;    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Autoship_Projected_Failed_Orders]    
    Where     
     [Runsequence] Not In ( Select     
         [Runsequence]    
        From [#Maxrunsequence] );    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Autoship_Projected_Failed_Orders];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Autoship_Projected_Failed_Orders';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Autoship_Projected_Failed_Orders'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*----------------------------------------------------------*/      
    /*----------Tbl_Autoship_Projected_Other_Autoships----------*/      
    /*---------------Last run sequence applied------------------*/    
    Set @4PreviousWeek = 0;    
    Truncate Table [#Maxrunsequence];    
    While @4PreviousWeek >= 0    
    Begin    
    Set @enddate = ( Select     
      Convert(Date , [Enddate])    
     From [Tbl_Commperiods] As [Pv]    
     Where [Pv].[Periodid] = @currentPeriodid - @4PreviousWeek );    
    Insert Into [#Maxrunsequence]    
    Select     
     IsNull(Max([A].[Runsequence]) , 0)    
    From [Tbl_Autoship_Projected_Other_Autoships] As [A](Nolock)    
    Where [A].[Runsequence] In ( Select Distinct     
          [S].[Runsequence]    
         From [Tbl_Autoship_Projected_Sequences] As [S](Nolock)    
         Where Convert(Date , [Createddate]) <= Convert(Date , @enddate) );    
    Set @4PreviousWeek = @4PreviousWeek - 1;    
    End;    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (1000000)    
    From [Tbl_Autoship_Projected_Other_Autoships]    
    Where     
     [Runsequence] Not In ( Select     
         [Runsequence]    
        From [#Maxrunsequence] );    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Autoship_Projected_Other_Autoships];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Autoship_Projected_Other_Autoships';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Autoship_Projected_Other_Autoships'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*-------------Tbl_Log_Webservice--------------*/      
    /*------------Approved/4 months----------------*/    
    Declare @limitDate DateTime = Dateadd([Mm] , -4 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Log_Webservice]    
    Where     
     [Createddate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Log_Webservice];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Log_Webservice';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Log_Webservice'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*----------Tbl_Log_Webservice_Avalara---------*/      
    /*------------Approved/6 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -6 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Log_Webservice_Avalara]    
    Where     
     [Createddate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Log_Webservice_Avalara];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Log_Webservice_Avalara';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Log_Webservice_Avalara'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*--------------Tbl_Tf_LogEmail----------------*/      
    /*------------Approved/6 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -6 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Tf_Logemail]    
    Where     
     [Createddate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Tf_Logemail];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Tf_LogEmail';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Tf_LogEmail'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*----------Tbl_Log_ShipmentProcess------------*/      
    /*------------Approved/6 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -6 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Log_Shipmentprocess]    
    Where     
     [Createddate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Log_Shipmentprocess];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Log_ShipmentProcess';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Log_ShipmentProcess'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*---------------Tbl_Jixiti_Logs---------------*/      
    /*------------Approved/6 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -6 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Jixiti_Logs]    
    Where     
     [Createddate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Jixiti_Logs];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Jixiti_Logs';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Jixiti_Logs'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*-----------Tbl_Log_Webservice_Btb------------*/      
    /*------------Approved/6 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -6 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Log_Webservice_Btb]    
    Where     
     [Createddate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Log_Webservice_Btb];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Log_Webservice_Btb';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Log_Webservice_Btb'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*--------------Tbl_Log_Autoships--------------*/      
  /*------------Approved/6 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -6 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Log_Autoships]    
    Where     
     [Createddate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Log_Autoships];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Log_Autoships';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Log_Autoships'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*-----Tbl_Leadership_Development_Pool_Logs----*/      
    /*------------Approved/6 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -6 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Leadership_Development_Pool_Logs]    
    Where     
     [Createddate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Leadership_Development_Pool_Logs];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Leadership_Development_Pool_Logs';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Leadership_Development_Pool_Logs'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*-------Tbl_Log_RecalculateAutoshipAll--------*/      
    /*------------Approved/6 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -6 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Log_Recalculateautoshipall]    
    Where     
     [Createddate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Log_Recalculateautoshipall];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Log_RecalculateAutoshipAll';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Log_RecalculateAutoshipAll'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*------------Tbl_Asea_Ascent_Log-------------*/      
    /*------------Approved/6 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -6 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Asea_Ascent_Log]    
    Where     
     [Createddate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Asea_Ascent_Log];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Asea_Ascent_Log';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Asea_Ascent_Log'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*----Tbl_Loyalty_Rewards_Program_Main_Temp----*/      
    /*------------Approved/6 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -6 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Loyalty_Rewards_Program_Main_Temp]    
    Where     
     [Rundate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Loyalty_Rewards_Program_Main_Temp];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Loyalty_Rewards_Program_Main_Temp';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Loyalty_Rewards_Program_Main_Temp'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*--Tbl_Loyalty_Rewards_Program_Autoship_Detail_Temp--*/      
    /*------------Approved/6 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -6 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Loyalty_Rewards_Program_Autoship_Detail_Temp]    
    Where     
     [Rundate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Loyalty_Rewards_Program_Autoship_Detail_Temp];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Loyalty_Rewards_Program_Autoship_Detail_Temp';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Loyalty_Rewards_Program_Autoship_Detail_Temp'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*-----Tbl_Leadership_Development_Pool_Temp----*/      
    /*------------Approved/6 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -6 , Getdate());    
    Declare @limitCommPeriod Int = ( Select Top 1     
          [C].[Id]    
         From [Tbl_Commperiods] As [C]    
         Where @limitDate Between [C].[Startdate] And [C].[Enddate] );    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Leadership_Development_Pool_Temp]    
    Where     
     [Commperiodid] < @limitCommPeriod;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Leadership_Development_Pool_Temp];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Leadership_Development_Pool_Temp';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Leadership_Development_Pool_Temp'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*----Tbl_Distributor_Commissions_ApplyHistory_v2----*/      
    /*------------Approved/6 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -6 , Getdate());    
    Set @limitCommPeriod = ( Select Top 1     
          [C].[Id]    
         From [Tbl_Commperiods] As [C]    
         Where @limitDate Between [C].[Startdate] And [C].[Enddate] );    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Distributor_Commissions_Applyhistory_V2]    
    Where     
     [Commperiodid] < @limitCommPeriod;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Distributor_Commissions_Applyhistory_V2];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Distributor_Commissions_ApplyHistory_v2'    
 , '-';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Distributor_Commissions_ApplyHistory_v2'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*----------Tbl_Distributor_Snapshot-----------*/      
    /*------------Approved/2 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -2 , Getdate());    
    Set @limitCommPeriod = ( Select Top 1     
          [C].[Id]    
         From [Tbl_Commperiods] As [C]    
         Where @limitDate Between [C].[Startdate] And [C].[Enddate] );    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Distributor_Snapshot]    
    Where     
     [Snapshotcommperiodid] < @limitCommPeriod;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Distributor_Snapshot];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Distributor_Snapshot';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Distributor_Snapshot'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';                        
    /*---------------------------------------------*/      
    /*----------Tbl_Commission_Run_Logs-----------*/      
    /*------------Approved/6 months----------------*/    
    Set @limitDate = Dateadd([Mm] , -6 , Getdate());    
    Set @limitCommPeriod = ( Select Top 1     
          [C].[Id]    
         From [Tbl_Commperiods] As [C]    
         Where @limitDate Between [C].[Startdate] And [C].[Enddate] );    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Commission_Run_Logs]    
    Where     
     [Commperiodid] < @limitCommPeriod;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Commission_Run_Logs];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Commission_Run_Logs';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Commission_Run_Logs'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';    
    
    /*---------------------------------------------*/      
    /*----Tbl_Logs_Autdit----*/      
    /*------------Approved/2 weeks----------------*/    
    Set @limitDate = Dateadd([wk] , -2 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [Tbl_Logs_Autdit]    
    Where     
     [CreatedDate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [Tbl_Logs_Autdit];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'Tbl_Logs_Autdit';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: Tbl_Logs_Autdit'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';              
    /*---------------------------------------------*/      
    /*---------------------------------------------*/      
    /*----TaxAvalara----*/      
    /*------------Approved/6 weeks----------------*/    
    Set @limitDate = Dateadd([wk] , -6 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [TaxAvalara]    
    Where     
     [CreatedDate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [TaxAvalara];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'TaxAvalara';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: TaxAvalara'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';              
    /*---------------------------------------------*/      
    /*---------------------------------------------*/      
    /*---------------------------------------------*/      
    /*----ApiLandmark----*/      
    /*------------Approved/6 weeks----------------*/    
    Set @limitDate = Dateadd([Mm] , -2 , Getdate());    
    Set @rowNumber = 1;    
    While @rowNumber > 0    
    Begin    
    Delete Top (100000)    
    From [ApiLandmark]    
    Where     
     [CreatedDate] < @limitDate;    
    Set @rowNumber = @@rowCount;    
    End;    
    Update Statistics [ApiLandmark];    
    Exec [Xirect_Defragindexes]     
   1    
 , 'ApiLandmark';    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Data deleted: ApiLandmark'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';              
    /*---------------------------------------------*/      
    /*----Finish----*/    
    
    Exec [Xirect_Defragindexes]     
   1;    
    Set @finishTime = 'Finished time: ' + Convert(VarChar , Getdate() , 121);    
    Exec [Sp_Log_Master]     
   @processId    
 , 'Process: Finished Clean Data'    
 , @finishTime    
 , @deleteTypeLog    
 , @processId    
 , @processId    
 , 'Log_Global';    
End;