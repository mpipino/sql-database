SET NOCOUNT ON;
SET ANSI_WARNINGS ON;
SET QUOTED_IDENTIFIER ON;

DECLARE @sqlcmd NVARCHAR(max), @params NVARCHAR(600), @sqlmajorver int

SELECT @sqlmajorver = CONVERT(int, (@@microsoftversion / 0x1000000) & 0xff);

IF (ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0) = 0)
BEGIN
	PRINT 'WARNING: Only a sysadmin can run ALL the checks'
END
ELSE
BEGIN
    PRINT 'No issues found while checking pre-requisites to run checks: user is sysadmin'
END;

IF (ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0) = 0)
BEGIN
	DECLARE @pid int, @pname sysname, @msdbpid int, @masterpid int
	DECLARE @permstbl TABLE ([name] sysname);
	DECLARE @permstbl_msdb TABLE ([id] tinyint IDENTITY(1,1), [perm] tinyint)
	
	SET @params = '@msdbpid_in int'

	SELECT @pid = principal_id, @pname=name FROM master.sys.server_principals (NOLOCK) WHERE sid = SUSER_SID();

	SELECT @masterpid = principal_id FROM master.sys.database_principals (NOLOCK) WHERE sid = SUSER_SID();

	SELECT @msdbpid = principal_id FROM msdb.sys.database_principals (NOLOCK) WHERE sid = SUSER_SID();

	-- Perms 1
	IF (ISNULL(IS_SRVROLEMEMBER(N'serveradmin'), 0) <> 1) AND ((SELECT COUNT(l.name)
		FROM master.sys.server_permissions p (NOLOCK) INNER JOIN master.sys.server_principals l (NOLOCK)
		ON p.grantee_principal_id = l.principal_id
			AND p.class = 100 -- Server
			AND p.state IN ('G', 'W') -- Granted or Granted with Grant
			AND l.is_disabled = 0
			AND p.permission_name = 'ALTER SETTINGS'
			AND QUOTENAME(l.name) = QUOTENAME(@pname)) = 0)
	BEGIN
		RAISERROR('WARNING: If not sysadmin, then you must be a member of serveradmin server role or have the ALTER SETTINGS server permission. Exiting...', 16, 1, N'serveradmin')
		RETURN
	END
	ELSE IF (ISNULL(IS_SRVROLEMEMBER(N'serveradmin'), 0) <> 1) AND ((SELECT COUNT(l.name)
		FROM master.sys.server_permissions p (NOLOCK) INNER JOIN sys.server_principals l (NOLOCK)
		ON p.grantee_principal_id = l.principal_id
			AND p.class = 100 -- Server
			AND p.state IN ('G', 'W') -- Granted or Granted with Grant
			AND l.is_disabled = 0
			AND p.permission_name = 'VIEW SERVER STATE'
			AND QUOTENAME(l.name) = QUOTENAME(@pname)) = 0)
	BEGIN
		RAISERROR('WARNING: If not sysadmin, then you must be a member of serveradmin server role or granted the VIEW SERVER STATE permission. Exiting...', 16, 1, N'serveradmin')
		RETURN
	END
    ELSE
    BEGIN
        RAISERROR('INFORMATION: No issues found while checking for sysadmin pre-requisites to run checks', 10, 1, N'serveradmin')
    END;

	-- Perms 2
	INSERT INTO @permstbl
	SELECT a.name
	FROM master.sys.all_objects a (NOLOCK) INNER JOIN master.sys.database_permissions b (NOLOCK) ON a.[OBJECT_ID] = b.major_id
	WHERE a.type IN ('P', 'X') AND b.grantee_principal_id <>0 
	AND b.grantee_principal_id <> 2
	AND b.grantee_principal_id = @masterpid;

	INSERT INTO @permstbl_msdb ([perm])
	EXECUTE sp_executesql N'USE msdb; SELECT COUNT([name]) 
FROM msdb.sys.sysusers (NOLOCK) WHERE [uid] IN (SELECT [groupuid] 
	FROM msdb.sys.sysmembers (NOLOCK) WHERE [memberuid] = @msdbpid_in) 
AND [name] = ''SQLAgentOperatorRole''', @params, @msdbpid_in = @msdbpid;

	INSERT INTO @permstbl_msdb ([perm])
	EXECUTE sp_executesql N'USE msdb; SELECT COUNT(dp.grantee_principal_id)
FROM msdb.sys.tables AS tbl (NOLOCK)
INNER JOIN msdb.sys.database_permissions AS dp (NOLOCK) ON dp.major_id=tbl.object_id AND dp.class=1
INNER JOIN msdb.sys.database_principals AS grantor_principal (NOLOCK) ON grantor_principal.principal_id = dp.grantor_principal_id
INNER JOIN msdb.sys.database_principals AS grantee_principal (NOLOCK) ON grantee_principal.principal_id = dp.grantee_principal_id
WHERE dp.state = ''G''
	AND dp.grantee_principal_id = @msdbpid_in
	AND dp.type = ''SL''', @params, @msdbpid_in = @msdbpid;

	IF (SELECT [perm] FROM @permstbl_msdb WHERE [id] = 1) = 0 AND (SELECT [perm] FROM @permstbl_msdb WHERE [id] = 2) = 0
	BEGIN
		RAISERROR('WARNING: If not sysadmin, then you must be a member of MSDB SQLAgentOperatorRole role, or have SELECT permission on the sysalerts table in MSDB to run full scope of checks', 16, 1, N'msdbperms')
		--RETURN
    END
	ELSE IF (ISNULL(IS_SRVROLEMEMBER(N'securityadmin'), 0) <> 1) AND ((SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'xp_enumerrorlogs') = 0 OR (SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'sp_readerrorlog') = 0 OR (SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'xp_readerrorlog') = 0)
	BEGIN
		RAISERROR('WARNING: If not sysadmin, then you must be a member of the securityadmin server role, or have EXECUTE permission on the following extended sprocs to run full scope of checks: xp_enumerrorlogs, xp_readerrorlog, sp_readerrorlog', 16, 1, N'secperms')
		--RETURN
	END
	ELSE IF (SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'xp_cmdshell') = 0 OR (SELECT COUNT(credential_id) FROM master.sys.credentials WHERE name = '##xp_cmdshell_proxy_account##') = 0
	BEGIN
		RAISERROR('WARNING: If not sysadmin, then you must be granted EXECUTE permissions on xp_cmdshell and a xp_cmdshell proxy account should exist to run full scope of checks', 16, 1, N'xp_cmdshellproxy')
		--RETURN
	END
	ELSE IF (SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'xp_fileexist') = 0 OR
		(SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'sp_OAGetErrorInfo') = 0 OR
		(SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'sp_OACreate') = 0 OR
		(SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'sp_OADestroy') = 0 OR
		(SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'xp_regenumvalues') = 0 OR
		(SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'xp_regread') = 0 OR 
		(SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'xp_instance_regread') = 0 OR
		(SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'xp_servicecontrol') = 0 
	BEGIN
		RAISERROR('WARNING: Must be a granted EXECUTE permissions on the following extended sprocs to run full scope of checks: sp_OACreate, sp_OADestroy, sp_OAGetErrorInfo, xp_fileexist, xp_regread, xp_instance_regread, xp_servicecontrol and xp_regenumvalues', 16, 1, N'extended_sprocs')
		--RETURN
	END
	ELSE IF (SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'xp_msver') = 0 AND @sqlmajorver < 11
	BEGIN
		RAISERROR('WARNING: Must be granted EXECUTE permissions on xp_msver to run full scope of checks', 16, 1, N'extended_sprocs')
		--RETURN
	END
    ELSE
    BEGIN
        RAISERROR('INFORMATION: No issues found while checking for granular pre-requisites to run checks', 10, 1, N'extended_sprocs')
		--RETURN
    END
END;