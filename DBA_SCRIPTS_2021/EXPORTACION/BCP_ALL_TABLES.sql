--USE AdventureWorksDW
--go

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Enable xp_cmdshell --> One time activity

--EXECUTE sp_configure 'show advanced options', 1;  
--GO  
---- To update the currently configured value for advanced options.  
--RECONFIGURE;  
--GO  
---- To enable the feature.  
--EXECUTE sp_configure 'xp_cmdshell', 1;  
--GO  
---- To update the currently configured value for this feature.  
--RECONFIGURE;  
--GO  




---------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*Script Start*/


--Global Variables used for different purpose in script
DECLARE @table_name VARCHAR(1000)
DECLARE @Schema_id  int
DECLARE @Filename VARCHAR(1000)
DECLARE @FilePath VARCHAR(1000)='F:\SQL\\AdventureWorksDW_Export\' --path where flat file, log file will be created, this path should pre exist
DECLARE @BCPCommand varchar(8000)
DECLARE @columnHeader VARCHAR(max)
DECLARE @columnHeaderCmdShell VARCHAR(max)
DECLARE @ColumnList VARCHAR(max)
DECLARE @tempRaw_sql nvarchar(max)
DECLARE @tempRaw_sql_xpcmdshell  nvarchar(max)
DECLARE @tempRaw_sql_xpcmdshell1  nvarchar(max)
DECLARE @query nvarchar(max)
DECLARE @query_xpcmdshell varchar(8000)
DECLARE @BCPPara varchar(1000)

DECLARE @ComputerName VARCHAR(1000) ='.\sql_2019_dev' --instance/machine name
DECLARE @UserName VARCHAR(1000)='desktop-lv6d4g3\abald' --user name, used AD user added in MS SQL server and its domain name



--Cursor to build bcp command to combine header row with table resultset for all tables and run with windows command shell utility

DECLARE cursor_CSVtables CURSOR
FOR SELECT DISTINCT  st.NAME,st.schema_id  FROM sys.tables st where is_ms_shipped !=1;
OPEN cursor_CSVtables;
FETCH NEXT FROM cursor_CSVtables INTO   @table_name, @Schema_id;
WHILE @@FETCH_STATUS = 0
    BEGIN
      		set @columnHeader='';
			set @columnHeaderCmdShell='';
			set @ColumnList=''
			set @tempRaw_sql=''
			set @query=''
			set @query_xpcmdshell=''
			set @BCPPara=''

			DECLARE @Ctable_name varchar(max)=@table_name--which needs to be exported
			DECLARE @CSchema_Id Int= @Schema_Id
			
			SET @Filename =@table_name --Tablename would be file name
			SELECT @columnHeader = COALESCE(@columnHeader+',' ,'') + '''' +'[' +column_name +']' +''''  FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @Ctable_name
		   
		    --SELECT @columnHeaderCmdShell = COALESCE(@columnHeaderCmdShell+',' ,'') + '''' +'''[' +column_name +']''' +''''  FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @Ctable_name
		    SELECT @columnHeaderCmdShell = COALESCE(@columnHeaderCmdShell+',' ,'') + '' +'CAST(''' +column_name +''' as NVARCHAR(100))' +''  FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @Ctable_name	 
			--print  @columnHeaderCmdShell			
			

			--SELECT @ColumnList = COALESCE(@ColumnList+',' ,'')+ 'CAST((['+column_name +'] )  AS NVARCHAR(max)) as [' + column_name +']' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @Ctable_name
			SELECT @ColumnList = COALESCE(@ColumnList+',' ,'')+ 'CAST(('+column_name +' )  AS NVARCHAR(max)) as ' + column_name +'' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @Ctable_name
			--print @ColumnList
			
			
			--SELECT @tempRaw_sql = 'SELECT  '+  SUBSTRING(@columnHeader, 2, len(@columnHeader))   +' UNION ALL SELECT '+SUBSTRING(@ColumnList, 2, len(@ColumnList))  +' FROM '  + '['+SCHEMA_NAME(@CSchema_Id)+'].['+@Ctable_name +']' 
			SELECT @tempRaw_sql = 'SELECT  '+  SUBSTRING(@columnHeader, 2, len(@columnHeader))   +' UNION ALL SELECT '+SUBSTRING(@ColumnList, 2, len(@ColumnList))  +' FROM '  + '['+SCHEMA_NAME(@CSchema_Id)+'].['+@Ctable_name +']' 
			
			set @tempRaw_sql_xpcmdshell = 'SELECT  '+  SUBSTRING(@columnHeaderCmdShell, 2, len(@columnHeaderCmdShell))   +' UNION ALL SELECT '+SUBSTRING(@ColumnList, 2, len(@ColumnList))  +' FROM '  + '['+SCHEMA_NAME(@CSchema_Id)+'].['+@Ctable_name +']' 
			--print  @tempRaw_sql_xpcmdshell
			
			
			-- Combining all paramters required for BCP command	
			set @BCPPara = '"'+ @FilePath +  @Filename+'.csv"'+' -S  ' +@ComputerName +' -e  "' + @FilePath +'error.log"'+'  -U '+ @UserName +' -t, -T -c -C 65001 -d ' +DB_NAME() +'';
		
		
		    --	print @BCPPara
			
			-- We are preparing two different queries with differnt syntax to run from different location
			-- @query will be used as argument in SSIS process execution task to run along with bcp, let us store it in AllBCPCommands
			
			SET @query= '"'+ @tempRaw_sql+'" queryout "'+ @FilePath +  @Filename+'.csv"'+' -S  ' +@ComputerName +' -e  "' + @FilePath +'error.log"'+'  -U "'+ @UserName +'" -t"," -T -c -d ' +DB_NAME() +'"'
			--  SET @query= 'bcp "'+ @tempRaw_sql+'" queryout "'+ @FilePath +  @Filename+'.csv"'+' -S  ' +@ComputerName +' -e  "' + @FilePath +'error.log"'+'  -U '+ @UserName +' -t, -T -c -d ' +DB_NAME() +''
			

			--@query_xpcmdshell has little bit different syntax requirement to run with xp_cmdshell utility
			SET @query_xpcmdshell= 'bcp "' + convert(varchar(8000),@tempRaw_sql_xpcmdshell) + '" queryout '+ @BCPPara 
			--print @query_xpcmdshell 
			 

			--@query store in AllBCPCommands, which can be used in SSIS
			--insert into AllBCPCommands values (@query)
			
			
			
		 
		 --Run bcp command using xp_cmdshell
		Exec master..xp_cmdshell   @query_xpcmdshell 
		--print @query_xpcmdshell 
		
		FETCH NEXT FROM cursor_CSVtables INTO   @table_name,@Schema_Id;
    END;


CLOSE cursor_CSVtables;
DEALLOCATE cursor_CSVtables;

/*Script End*/
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Debugging and testing
-- select * from AllBCPCommands
--Exec master..xp_cmdshell  'bcp "SELECT  ''DBVersion'',''VersionDate'' UNION ALL SELECT CAST(DBVersion AS VARCHAR)DBVersion,CAST(VersionDate AS VARCHAR)VersionDate FROM AdventureWorksDWBuildVersion"  queryout  "D:\Data\AdventureWorksDWBuildVersion.csv" -S mohmmedmubins-w10 -U cybage\mohmmedmubins -t^| -T -c -d AdventureWorksDW'
--EXEC xp_cmdshell 'bcp "SELECT CountryRegionCode, Name FROM [AdventureWorks].[Person].[CountryRegion]" queryout "D:\data\CountryRegion.txt" -T -c -t, -S mohmmedmubins-w10\mssql2017'

--declare @user varchar(50)='cybage\mohmmedmubins' 
--declare @x varchar(8000) ='bcp "SELECT  ''[Name]'',''[Address]'' UNION ALL SELECT CAST(([Name] COLLATE DATABASE_DEFAULT)  AS NVARCHAR(max)) as [Name],CAST(([Address] COLLATE DATABASE_DEFAULT)  AS NVARCHAR(max)) as [Address] FROM [dbo].[TestCustomers]" queryout "D:\Data\TestCustomers.csv" -S  mohmmedmubins-w10 -e  "D:\Data\error.log"  -U cybage\mohmmedmubins  -T -c -d AdventureWorksDW'
--print @x
--EXEC xp_cmdshell @x


--DECLARE @cmd VARCHAR(32)= 'dir';
--EXEC xp_cmdshell @cmd;
