/*
--Distributor_EnrollmentTree_Sp
--A pedido de Verney por Teams
SOLUCION: NUEVO INDICE EN TABLA TEMPORAL PORQUE UN HAS JOIN NO ESTABA CALCULANDO BIEN LA CARDINALIDAD

*/

/*
Links:

--https://onedrive.live.com/view.aspx?resid=C6FA59824AB3963E%21115377&id=documents&wd=target%28LOG%20DE%20OPTIMIZACION.one%7CA6546222-B86D-4AE2-A63E-AA60D8D77127%2FDistributor_EnrollmentTree_Sp%7C23AE88A2-735B-44BA-BFE0-F72052DF5376%2F%29
--onenote:https://d.docs.live.net/c6fa59824ab3963e/NOTAS/xirectds/LOG%20DE%20OPTIMIZACION.one#Distributor_EnrollmentTree_Sp&section-id={A6546222-B86D-4AE2-A63E-AA60D8D77127}&page-id={23AE88A2-735B-44BA-BFE0-F72052DF5376}&end

--https://onedrive.live.com/view.aspx?resid=C6FA59824AB3963E%21115377&id=documents&wd=target%28LOG%20DE%20OPTIMIZACION.one%7CA6546222-B86D-4AE2-A63E-AA60D8D77127%2FDistributor_EnrollmentTree_Sp%7CD8416BE6-C41D-4C34-8FF7-C5F579994EF0%2F%29
--onenote:https://d.docs.live.net/c6fa59824ab3963e/NOTAS/xirectds/LOG%20DE%20OPTIMIZACION.one#Distributor_EnrollmentTree_Sp&section-id={A6546222-B86D-4AE2-A63E-AA60D8D77127}&page-id={D8416BE6-C41D-4C34-8FF7-C5F579994EF0}&end

*/

[dba].sp_BlitzCache @StoredProcName = 'Distributor_EnrollmentTree_Sp'
DBCC FREEPROCCACHE (0x050005008137A564509FBC69E201000001000000000000000000000000000000000000000000000000000000);


EXEC dbo.sp_BlitzIndex @DatabaseName='Asea_Prod', @SchemaName='dbo', @TableName='tbl_distributor_commissions_v2';

Declare @ty_DistributorStatus as Ty_BaseId         
Insert Into @ty_DistributorStatus(Id)        
Select 1 Union All Select 2 Union All Select 4 Union All Select 10      
--declare @distributorId bigint =823718     
--declare @distributorId bigint =500
--declare @distributorIdDownline bigint =823718   
declare @distributorId bigint =14441
declare @distributorIdDownline bigint=14441
declare @level Int =1      
     
--Exec Distributor_EnrollmentTree_Sp_gma @distributorId, @distributorIdDownline, @level, @ty_DistributorStatus; --1 MINUTE 28 SECONDS. With new index: 1 second.
Exec Distributor_EnrollmentTree_Sp @distributorId, @distributorIdDownline, @level, @ty_DistributorStatus; --2 MINUTES 29 SECONDS.
-------------------------

exec Distributor_EnrollmentTree_Sp @distributorId=500

EXEC dbo.sp_BlitzIndex @DatabaseName='Asea_Prod', @SchemaName='dbo', @TableName='tbl_distributor_commissions_v2';

sp_help 'Distributor_EnrollmentTree_Sp'


----RESOLUCION EN xpress y bodylogic:
--Le agregué el OPTIMIZE FOR:
--    Update [Tet]      
--    Set      
--   [Tet].[Totalsponsor] = [Tet2].[Totalsponsor]      
--    From [#Temp_Enrollmenttree] [Tet]      
--     Inner Join ( Select      
--       [Tet].[Enrollerid] As [Distributorid]      
--     , Count(1) As [Totalsponsor]      
--      From [#Temp_Enrollmenttree] As [Tet]      
--      Group By      
--       [Tet].[Enrollerid] ) [Tet2]      
--      On [Tet2].[Distributorid] = [Tet].[Distributorid]      
--    Where      
--     [Tet].[Level] <= @level      
--     Or @level = -1
-- OPTION(OPTIMIZE FOR UNKNOWN);

--Para bodylogic agregué este índice:
--CREATE NONCLUSTERED INDEX IX_NN_Commissions_Distributor_DistributorId_Incl_Comp_4_9_2021
--ON [dbo].[Commissions_Distributor] ([DistributorId])
--INCLUDE ([CommissionsPeriodId],[Qualified],[BinaryQualified])
--WITH (DATA_COMPRESSION=PAGE)
--GO --29 seconds on live


/****** Object:  StoredProcedure [dbo].[Distributor_EnrollmentTree_Sp]    Script Date: 4/8/2021 8:03:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* =============================================            
Author: Decheverria            
Create Date: 2019-02-06            
Dependencies: Genealogy - xBo            
Description: This procedure load genealogy enrollment tree            
Notes:            
[Redmine Ticket #40184]  Create Store Procedure            
Modification:            
[Redmine Ticket]            
            
Declare @ty_DistributorStatus as Ty_BaseId         
Insert Into @ty_DistributorStatus(Id)        
Select 1 Union All Select 2 Union All Select 4 Union All Select 10      
declare @distributorId bigint =823718     
declare @distributorIdDownline bigint =823718     
declare @level Int =1         
    
    
--Exec Distributor_EnrollmentTree_Sp_gma @distributorId, @distributorIdDownline, @level, @ty_DistributorStatus            
Exec Distributor_EnrollmentTree_Sp @distributorId, @distributorIdDownline, @level, @ty_DistributorStatus            
=============================================*/

	alter Procedure [dbo].[Distributor_EnrollmentTree_Sp_gma] 
				  @distributorId         BigInt            = 0
				, @distributorIdDownline BigInt            = 0
				, @level                 Int               = -1
				, @ty_DistributorStatus As  [dbo].[Ty_Baseid] ReadOnly	
			
	As
	Begin
		Set NoCount On;
		Set Transaction Isolation Level Read UnCommitted; 
		--hola
		If Object_Id('tempdb..#Temp_EnrollmentTree') Is Not Null
		Begin
		   Drop Table [#Temp_Enrollmenttree];
		End;
		If Object_Id('tempdb..#Temp_Distributorstatus') Is Not Null
		Begin
		   Drop Table [#Temp_Distributorstatus];
		End;
		If Object_Id('tempdb..#Temp_EnrollmentTree2') Is Not Null
		Begin
		   Drop Table [#Temp_Enrollmenttree2];
		End;
		Declare @paymentTypeBitcoin Int = 8;
		Declare @userStatusPending Int = 6;
		Declare @timeZoneOffSet Int = ( Select 
									 [Dbo].[Fn_Gettimezoneoffset]() );
		Declare @currentDate DateTime = Dateadd([Hh] , @timeZoneOffSet , Getdate());
		Declare @frequencyMain Int = ( Select 
									[cpf].[CommissionsPeriodsFrequencyId]
								From [Commissions_Periods_Frequency] As [cpf]
								Where [cpf].[FrequencyMain] = 1 );
		Declare @currentPeriodId Int = ( Select Top 1 
									  [CommissionsPeriodId]
								  From [Commissions_Periods] As [cp]
								  Where @currentDate Between [Startdate] And [Enddate]
									   And [cp].[CommissionsPeriodsFrequencyId] = @frequencyMain );
		Create Table [#Temp_Enrollmenttree] ( 
				  [Distributorid]        BigInt
				, [Enrollerid]           BigInt
				, [Ispersonallyenrolled] Bit Default(0)
				, [Isautoship]           Bit Default(0)
				, [Qualified]            Bit Default(0)
				, [Binaryqualified]      Bit Default(0)
				, [Totalsponsor]         Int Default(0)
				, [Level]                Int );
		Create Table [#Temp_Distributorstatus] ( 
				  [Statusid] Int );	

		Insert Into [#Temp_Distributorstatus] ( 
			[Statusid] ) 
		Select 
			[Ds].[Id]
		From @ty_DistributorStatus As [Ds];
		With Enrollmenttree_Cte
			As (Select 
				   [D].[Legacynumber]
				 , [D].[Enrollerid]
				 , 0 As [Level]
			   From [Tbl_Distributor] As [D]
			   Where [D].[Legacynumber] = @distributorId
			   Union All
			   Select 
				   [D2].[Legacynumber]
				 , [D2].[Enrollerid]
				 , ( [Et].[Level] + 1 )
			   From [Tbl_Distributor] As [D2]
				   Inner Join [Enrollmenttree_Cte] As [Et]
					   On [Et].[Legacynumber] = [D2].[Enrollerid])
			Insert Into [#Temp_Enrollmenttree] ( 
				[Distributorid]
			  , [Enrollerid]
			  , [Level] ) 
			Select 
				[Et].[Legacynumber]
			  , [Et].[Enrollerid]
			  , [Et].[Level]
			From [Enrollmenttree_Cte] As [Et] Option(
				MaxRecursion 0);
		If ( @distributorId <> @distributorIdDownline ) 
		Begin
		   If Exists ( Select 
						[Distributorid]
					From [#Temp_Enrollmenttree]
					Where [Distributorid] = @distributorIdDownline ) 
		   Begin
			  Select 
				  *
			  Into 
				  [#Temp_Enrollmenttree2]
			  From [#Temp_Enrollmenttree];

			  CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>]
					ON [dbo].[#Temp_Enrollmenttree2] ([Enrollerid])
					INCLUDE ([Distributorid])			

			  Truncate Table [#Temp_Enrollmenttree];
			  With Enrollmenttree2_Cte
				  As (Select 
						 [Tet].[Distributorid]
						, [Tet].[Enrollerid]
						, 0 As [Level]
					 From [#Temp_Enrollmenttree2] As [Tet]
					 Where [Tet].[Distributorid] = @distributorIdDownline
					 Union All
					 Select 
						 [Tet2].[Distributorid]
						, [Tet2].[Enrollerid]
						, ( [Et].[Level] + 1 ) As [Level]
					 From [#Temp_Enrollmenttree2] As [Tet2]
						 Inner Join [Enrollmenttree2_Cte] As [Et]
							 On [Et].[Distributorid] = [Tet2].[Enrollerid]
					 Where ( [Et].[Level] + 1 ) <= @level
						  Or @level = -1)
				  Insert Into [#Temp_Enrollmenttree] ( 
					  [Distributorid]
					, [Enrollerid]
					, [Level] ) 
				  Select 
					  [Et].[Distributorid]
					, [Et].[Enrollerid]
					, [Et].[Level]
				  From [Enrollmenttree2_Cte] As [Et] Option(
					  MaxRecursion 0);
		   End;
		   Else
		   Begin
			  Truncate Table [#Temp_Enrollmenttree];
		   End;
		End;
		Update [#Temp_Enrollmenttree]
		Set 
		  [Ispersonallyenrolled] = 1
		Where 
			[Enrollerid] = @distributorId;
		Update [Tet]
		Set 
		  [Tet].[Isautoship] = [Aoh2].[Isautoship]
		From [#Temp_Enrollmenttree] [Tet]
			Inner Join ( Select 
						  1 As [Isautoship]
						, [Aoh].[DistLegacyNumber]
					  From [Autoship_Header] As [Aoh]
					  Where [Aoh].[AutoshipStatusId] = 20
					  Group By 
						  [Aoh].[DistLegacyNumber] ) [Aoh2]
				On [Aoh2].[DistLegacyNumber] = [Tet].[Distributorid]
		Where 
			[Tet].[Level] <= @level
			Or @level = -1;
		Update [Tet]
		Set 
		  [Tet].[Qualified] = [Cd].[Qualified]
		, [Tet].[Binaryqualified] = [Cd].[Binaryqualified]
		From [#Temp_Enrollmenttree] [Tet]
			Inner Join [Commissions_Distributor] [Cd]
				On [Cd].[Distributorid] = [Tet].[Distributorid]
		Where 
			[Cd].[CommissionsPeriodId] = @currentPeriodId
			And [Tet].[Level] <= @level
			Or @level = -1;
	
		--CREATE NONCLUSTERED INDEX [Temp_Enrollmenttree_Distributorid]
		--	ON [#Temp_Enrollmenttree] ([Distributorid])
		--	INCLUDE ([Level])	
	
		Update [Tet]
		Set 
		  [Tet].[Totalsponsor] = [Tet2].[Totalsponsor]
		From [#Temp_Enrollmenttree] [Tet]
			Inner Join ( Select 
						  [Tet].[Enrollerid] As [Distributorid]
						, Count(1) As [Totalsponsor]
					  From [#Temp_Enrollmenttree] As [Tet]
					  Group By 
						  [Tet].[Enrollerid] ) [Tet2]
				On [Tet2].[Distributorid] = [Tet].[Distributorid]
		Where 
			[Tet].[Level] <= @level
			Or @level = -1
		OPTION(OPTIMIZE FOR UNKNOWN);

		Select 
			[Tet].[Distributorid] As [Distributorid]
		  , [Tet].[Enrollerid] As [Enrollerid]
		  , [Dbo].[Distributor_Getdefaultname_Fn]
										  ( [D].[Companyname] , [D].[Firstname] , [D].[Lastname]
										  ) As [Name]
		  , [D].[Username] As [Username]
		  , [Aty].[Accounttypename] As [Accounttype]
		  , [Aty].[Translationkey] As [Accounttypekeyname]
		  , [R].[CommissionsRankName] As [Rankname]
		  , [R].[CommissionsRankKeyName] As [Ranknamekey]
		  , [Lr].[CommissionsRankName] As [Lifetimerankname]
		  , [Lr].[CommissionsRankKeyName] As [Lifetimeranknamekey]
		  , IsNull([R].[Color] , '#fff') As [Rankcolor]
		  , [D].[Userstatus] As [UserStatus]
		  , [Tet].[Ispersonallyenrolled] As [Personalenrolled]
		  , [Tet].[Isautoship] As [Isautoship]
		  , [Tet].[Qualified] As [Active]
		  , [Tet].[Binaryqualified] As [Binaryqualified]
		  , [Tet].[Totalsponsor] As [Totalsponsor]
		  , [Lc].[Flag] As [Flag]
		  , [Tet].[Level] As [Level]
		From [#Temp_Enrollmenttree] As [Tet]
			Inner Join [Tbl_Distributor] As [D]
				On [D].[Legacynumber] = [Tet].[Distributorid]
			Inner Join [Dst].[Distributor_AccountTypes] As [Aty]
				On [Aty].[Accounttypeid] = [D].[Accounttype]
			Inner Join [Commissions_Ranks] As [R]
				On [R].[CommissionsRankId] = IsNull([D].[Paidasrank] , 0)
			Inner Join [Commissions_Ranks] As [Lr]
				On [Lr].[CommissionsRankId] = IsNull([D].[Lifetimerankid] , 0)
			Inner Join [tbl_Markets] As [M]
				On [M].[ID] = [D].[MarketID]
			Inner Join [Country] As [Lc]
				On [Lc].[Countryid] = [M].[CountryID]
		Where [Tet].[Level] <= @level
			Or @level = -1
		Order By 
			[Tet].[Level];
		Drop Table [#Temp_Enrollmenttree];
		Drop Table [#Temp_Distributorstatus];
		If Object_Id('tempdb..#Temp_EnrollmentTree2') Is Not Null
		Begin
		   Drop Table [#Temp_Enrollmenttree2];
		End;
	End;