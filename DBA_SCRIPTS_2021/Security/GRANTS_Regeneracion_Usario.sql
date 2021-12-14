EXECUTE AS user = 'Ambrosia_Test ReadExecute'
GO
SELECT 
    USER_NAME() AS 'user_name'
    ,SUSER_NAME() AS 'suser_name'
    ,SUSER_SNAME() AS 'suser_sname'
    ,SYSTEM_USER AS 'system_user'
GO
REVERT
GO


/****** Object:  User [Ambrosia_Test ReadExecute]    Script Date: 7/7/2021 2:28:42 PM ******/
DROP USER [Ambrosia_Test ReadExecute]
GO


DECLARE @RoleName sysname
set @RoleName = N'ReadExecute'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    DECLARE @RoleMemberName sysname
    DECLARE Member_Cursor CURSOR FOR
    select [name]
    from sys.database_principals 
    where principal_id in ( 
        select member_principal_id
        from sys.database_role_members
        where role_principal_id in (
            select principal_id
            FROM sys.database_principals where [name] = 'ReadExecute' AND type = 'R'))

    OPEN Member_Cursor;

    FETCH NEXT FROM Member_Cursor
    into @RoleMemberName
    
    DECLARE @SQL NVARCHAR(4000)

    WHILE @@FETCH_STATUS = 0
    BEGIN
        
        SET @SQL = 'ALTER ROLE '+ QUOTENAME(@RoleName,'[') +' DROP MEMBER '+ QUOTENAME(@RoleMemberName,'[')
        EXEC(@SQL)
        
        FETCH NEXT FROM Member_Cursor
        into @RoleMemberName
    END;

    CLOSE Member_Cursor;
    DEALLOCATE Member_Cursor;
END

/****** Object:  DatabaseRole [ReadExecute]    Script Date: 7/7/2021 2:57:20 PM ******/
DROP ROLE [ReadExecute]
GO

/****** Object:  DatabaseRole [ReadExecute]    Script Date: 7/7/2021 2:57:20 PM ******/
CREATE ROLE [ReadExecute]
GO


grant alter on schema::DBO to ReadExecute WITH GRANT OPTION; 
grant CONTROL on schema::DBO to ReadExecute WITH GRANT OPTION; 
grant EXECUTE on schema::DBO to ReadExecute WITH GRANT OPTION; 
grant SELECT on schema::DBO to ReadExecute WITH GRANT OPTION; 



/****** Object:  User [Ambrosia_Test ReadExecute]    Script Date: 7/7/2021 2:28:45 PM ******/
CREATE USER [Ambrosia_Test ReadExecute] FROM  EXTERNAL PROVIDER 
GO

EXEC sp_addrolemember 'ReadExecute', 'Ambrosia_Test ReadExecute';  


