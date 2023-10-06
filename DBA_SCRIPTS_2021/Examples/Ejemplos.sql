--Scripts de Ejemplos.


/*
Ticket:

Description:

Add this to Express and to BL. Please limit the results to: one year or less and one market (not a select all) in order to avoid too much data being pulled. 
Also, add an account status option so that it defaults to open accounts but allows them to select other statuses (single select). This is similar to ticket #55429
--https://tickets.xirect.com/issues/55454?tab=time_entries

Query optimization. Page Reads was reduced from 30,000 to less than 3,000. Execution time was reduced from 30 seconds to less than 8 seconds.

*/
/* =============================================  
Author: clorenzo    
Create Date: 2021-03-25  
Dependencies: Commissions - xCorporate    
Description: Report   
Notes:   
Modification:    [Redmine Ticket #55454]  Create Store Procedure    

Test:   
--set statistics io on
DECLARE @WeekStart INT=100   
DECLARE @WeekEnd INT=164 DECLARE @p5 dbo.ty_BaseId   insert into @p5(id) values(154), (161)  
exec Distributor_CalculateBinaryVolume_ByMarketsAndCommissionsPeriods_Sp @WeekStart, @WeekEnd,@p5
============================================= */


Create or alter Procedure [Distributor_Calculatebinaryvolume_Bymarketsandcommissionsperiods_Sp] 
			  @weekstart   Int
			, @weekend     Int
			, @type_baseid As [dbo].[Ty_BaseId] ReadOnly
As
Begin
    Set NoCount On;
    Set Transaction Isolation Level Read UnCommitted;
    Declare @week Int;
    Declare @leftmarkeid NVarChar(10)
		, @cadena      NVarChar(Max)
		, @columns     NVarChar(Max)
		, @columns2    NVarChar(Max)
		, @sql         NVarChar(Max);
    Drop Table If Exists 
	    [#Temp_Week];
    Drop Table If Exists 
	    [#Temp_Tbl_Distributor_V2];
    Drop Table If Exists 
	    [#Temp_Tbl_Distributor_Commissions_V2];
    Create Table [#Temp_Week] ( 
			  [Columna]        VarChar(100)
			, [Commperiodid]   Int
			, [Binaryposition] Int );
    Create Clustered Index [Ix_Temp_Week_Commperiodid_Binaryposition]
	On [#Temp_Week] ( [Commperiodid] , [Binaryposition] );
    Create Table [#Temp_Tbl_Distributor_V2] ( 
			  [Distributorid] Int );
    Create Clustered Index [Ix_Temp_Tbl_Distributor_V2_Distributorid]
	On [#Temp_Tbl_Distributor_V2] ( [Distributorid] );
    Create Table [#Temp_Tbl_Distributor_Commissions_V2] ( 
			  [Distributorid]            Int
			, [Columna]                  VarChar(100)
			, [Currentteambinaryvolumen] Decimal(18 , 2)
			, [Commperiodid]             Int
			, [Binaryposition]           Int );
    Insert Into [#Temp_Tbl_Distributor_V2] ( 
	    [Distributorid] ) 
    Select Distinct 
	    [A].[Distributorid]
    From [Tbl_Distributor_Commissions_V2] As [A]
    Where [Commperiodid] Between @weekstart And @weekend
		And Exists ( Select 
					   1
				   From @type_baseid As [B]
				   Where [B].[Id] = [A].[Marketid] );


    Insert Into [#Temp_Tbl_Distributor_Commissions_V2]
    Select 
	    [A].[Distributorid]
	  , Case When [B].[Binaryposition] = 1 Then 'New_Week_' + Convert(VarChar , [B].[Commperiodid]) + '_Left' Else 'New_Week_' + Convert(VarChar , [B].[Commperiodid]) + '_Right' End
	  , [B].[Currentteambinaryvolumen]
	  , [B].[Commperiodid] As Int
	  , [B].[Binaryposition] As Int
    From [Tbl_Distributor_Commissions_V2] As [B]
	    Join [#Temp_Tbl_Distributor_V2] As [A]
		    On [B].[Binarysponsorid] = [A].[Distributorid]
			  And [B].[Commperiodid] Between @weekstart And @weekend;

    Insert Into [#Temp_Week]
    Select Distinct 
	    [Columna]
	  , [Commperiodid]
	  , [Binaryposition]
    From [#Temp_Tbl_Distributor_Commissions_V2];
    Set @columns = ( Select 
					 STRING_AGG(Quotename(Ltrim([Columna])) , ', ') Within Group(Order By [Commperiodid]
																		   , [Binaryposition])
				 From [#Temp_Week] );
    Set @columns2 = ( Select 
					  STRING_AGG(Cast( ( 'ISNULL(' + Quotename([Columna]) + ', 0) ' + Quotename([Columna]) ) As NVarChar(Max)) , ', ') Within Group(Order By [Commperiodid]
																																, [Binaryposition])
				  From [#Temp_Week] );

    Set @sql = N'SELECT DistributorID, ' 
    + @columns2 + ' from (  select DistributorID,Columna,CurrentTeamBinaryVolumen from #Temp_tbl_Distributor_Commissions_v2 ) 
    x  pivot ( SUM(CurrentTeamBinaryVolumen)     
    for columna in (' + @columns + N')     )
    p  order by DistributorId ;';

    Exec [Sp_Executesql] 
	  @sql;
    Drop Table If Exists 
	    [#Temp_Week];
    Drop Table If Exists 
	    [#Temp_Tbl_Distributor_V2];
    Drop Table If Exists 
	    [#Temp_Tbl_Distributor_Commissions_V2];
End;

