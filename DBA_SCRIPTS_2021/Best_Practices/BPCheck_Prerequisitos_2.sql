SET NOCOUNT ON;
SET ANSI_WARNINGS ON;
SET QUOTED_IDENTIFIER ON;

DECLARE @src VARCHAR(255), @desc VARCHAR(255), @psavail VARCHAR(20), @psver tinyint, @masterpid int
DECLARE @agt smallint, @ole smallint, @sao smallint, @xcmd smallint
DECLARE @ErrorMessage NVARCHAR(4000)
DECLARE @permstbl TABLE ([name] sysname);

SELECT @masterpid = principal_id FROM master.sys.database_principals (NOLOCK) WHERE sid = SUSER_SID()

INSERT INTO @permstbl
SELECT a.name
FROM master.sys.all_objects a (NOLOCK) INNER JOIN master.sys.database_permissions b (NOLOCK) ON a.[OBJECT_ID] = b.major_id
WHERE a.type IN ('P', 'X') AND b.grantee_principal_id <>0 
AND b.grantee_principal_id <> 2
AND b.grantee_principal_id = @masterpid;

IF ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0) = 1 -- Is sysadmin
    OR ((ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0) <> 1 
        AND (SELECT COUNT(credential_id) FROM sys.credentials WHERE name = '##xp_cmdshell_proxy_account##') > 0) -- Is not sysadmin but proxy account exists
        AND (SELECT COUNT(l.name)
        FROM sys.server_permissions p JOIN sys.server_principals l 
        ON p.grantee_principal_id = l.principal_id
            AND p.class = 100 -- Server
            AND p.state IN ('G', 'W') -- Granted or Granted with Grant
            AND l.is_disabled = 0
            AND p.permission_name = 'ALTER SETTINGS'
            AND QUOTENAME(l.name) = QUOTENAME(USER_NAME())) = 0) -- Is not sysadmin but has alter settings permission
    OR ((ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0) <> 1 
        AND ((SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'xp_regread') > 0 AND
        (SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'xp_cmdshell') > 0)))
BEGIN
    DECLARE @pstbl_avail TABLE ([KeyExist] int)
    BEGIN TRY
        INSERT INTO @pstbl_avail
        EXEC master.sys.xp_regread N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\PowerShell\1' -- check if Powershell is installed
    END TRY
    BEGIN CATCH
        SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
        SELECT @ErrorMessage = 'Could not determine if Powershell is installed - Error raised in TRY block. ' + ERROR_MESSAGE()
        RAISERROR (@ErrorMessage, 16, 1);
    END CATCH

    SELECT @sao = CAST([value] AS smallint) FROM sys.configurations (NOLOCK) WHERE [name] = 'show advanced options'
    SELECT @xcmd = CAST([value] AS smallint) FROM sys.configurations (NOLOCK) WHERE [name] = 'xp_cmdshell'
    SELECT @ole = CAST([value] AS smallint) FROM sys.configurations (NOLOCK) WHERE [name] = 'Ole Automation Procedures'

    RAISERROR ('Configuration options set for Powershell enablement verification', 10, 1) WITH NOWAIT
    IF @sao = 0
    BEGIN
        EXEC sp_configure 'show advanced options', 1; RECONFIGURE WITH OVERRIDE;
    END
    IF @xcmd = 0
    BEGIN
        EXEC sp_configure 'xp_cmdshell', 1; RECONFIGURE WITH OVERRIDE;
    END
    IF @ole = 0
    BEGIN
        EXEC sp_configure 'Ole Automation Procedures', 1; RECONFIGURE WITH OVERRIDE;
    END
    
    IF (SELECT [KeyExist] FROM @pstbl_avail) = 1
    BEGIN
        DECLARE @psavail_output TABLE ([PS_OUTPUT] VARCHAR(2048));
        INSERT INTO @psavail_output
        EXEC master.dbo.xp_cmdshell N'%WINDIR%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Get-ExecutionPolicy"'
    
        SELECT @psavail = [PS_OUTPUT] FROM @psavail_output WHERE [PS_OUTPUT] IS NOT NULL;
    END
    ELSE
    BEGIN
        RAISERROR ('WARNING: Powershell is not installed. Install WinRM to proceed with PS based checks',16,1);
    END
            
    IF (@psavail IS NOT NULL AND @psavail NOT IN ('RemoteSigned','Unrestricted'))
    RAISERROR ('WARNING: Execution of Powershell scripts is disabled on this system.
To change the execution policy, type the following command in Powershell console: Set-ExecutionPolicy RemoteSigned
The Set-ExecutionPolicy cmdlet enables you to determine which Windows PowerShell scripts (if any) will be allowed to run on your computer. Windows PowerShell has four different execution policies:
Restricted - No scripts can be run. Windows PowerShell can be used only in interactive mode.
AllSigned - Only scripts signed by a trusted publisher can be run.
RemoteSigned - Downloaded scripts must be signed by a trusted publisher before they can be run.
Unrestricted - No restrictions; all Windows PowerShell scripts can be run; REQUIRED by BP Check.',16,1);

    IF (@psavail IS NOT NULL AND @psavail IN ('RemoteSigned','Unrestricted'))
    BEGIN
        RAISERROR ('INFORMATION: Powershell is installed and enabled for script execution', 10, 1) WITH NOWAIT
        
        DECLARE @psver_output TABLE ([PS_OUTPUT] VARCHAR(1024));
        INSERT INTO @psver_output
        EXEC master.dbo.xp_cmdshell N'%WINDIR%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Get-Host | Format-Table -Property Version"'
    
        -- Gets PS version, as commands issued to PS v1 do not support -File
        SELECT @psver = ISNULL(LEFT([PS_OUTPUT],1),2) FROM @psver_output WHERE [PS_OUTPUT] IS NOT NULL AND ISNUMERIC(LEFT([PS_OUTPUT],1)) = 1;
        
        SET @ErrorMessage = 'INFORMATION: Installed Powershell is version ' + CONVERT(CHAR(1), @psver) + ''
        PRINT @ErrorMessage
    END;
    
    IF @xcmd = 0
    BEGIN
        EXEC sp_configure 'xp_cmdshell', 0; RECONFIGURE WITH OVERRIDE;
    END
    IF @ole = 0
    BEGIN
        EXEC sp_configure 'Ole Automation Procedures', 0; RECONFIGURE WITH OVERRIDE;
    END
    IF @sao = 0
    BEGIN
        EXEC sp_configure 'show advanced options', 0; RECONFIGURE WITH OVERRIDE;
    END;
END
ELSE
BEGIN
    RAISERROR ('WARNING: Missing permissions for Powershell enablement verification', 16, 1) WITH NOWAIT
END;