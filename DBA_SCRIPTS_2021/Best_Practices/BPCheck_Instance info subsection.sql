SET NOCOUNT ON;
SET ANSI_WARNINGS ON;
SET QUOTED_IDENTIFIER ON;

DECLARE @sqlcmd NVARCHAR(max), @params NVARCHAR(600)
DECLARE @ErrorMessage NVARCHAR(4000)
DECLARE @sqlmajorver int, @sqlminorver int, @sqlbuild int, @masterpid int
DECLARE @port VARCHAR(15), @replication int, @RegKey NVARCHAR(255), @cpuaffin VARCHAR(255), @cpucount int, @numa int
DECLARE @i int, @cpuaffin_fixed VARCHAR(300), @affinitymask NVARCHAR(64), @affinity64mask NVARCHAR(1024)--, @cpuover32 int
DECLARE @permstbl TABLE ([name] sysname);

SELECT @masterpid = principal_id FROM master.sys.database_principals (NOLOCK) WHERE sid = SUSER_SID()

INSERT INTO @permstbl
SELECT a.name
FROM master.sys.all_objects a (NOLOCK) INNER JOIN master.sys.database_permissions b (NOLOCK) ON a.[OBJECT_ID] = b.major_id
WHERE a.type IN ('P', 'X') AND b.grantee_principal_id <>0 
AND b.grantee_principal_id <> 2
AND b.grantee_principal_id = @masterpid;

SELECT @sqlmajorver = CONVERT(int, (@@microsoftversion / 0x1000000) & 0xff);
SELECT @sqlminorver = CONVERT(int, (@@microsoftversion / 0x10000) & 0xff);
SELECT @sqlbuild = CONVERT(int, @@microsoftversion & 0xffff);

IF @sqlmajorver < 11 OR (@sqlmajorver = 10 AND @sqlminorver = 50 AND @sqlbuild < 2500)
BEGIN
	IF (ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0) = 1) OR ((SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'xp_regread') = 1)
	BEGIN
		BEGIN TRY
			SELECT @RegKey = CASE WHEN CONVERT(VARCHAR(128), SERVERPROPERTY('InstanceName')) IS NULL THEN N'Software\Microsoft\MSSQLServer\MSSQLServer\SuperSocketNetLib\Tcp'
				ELSE N'Software\Microsoft\Microsoft SQL Server\' + CAST(SERVERPROPERTY('InstanceName') AS NVARCHAR(128)) + N'\MSSQLServer\SuperSocketNetLib\Tcp' END
			EXEC master.sys.xp_regread N'HKEY_LOCAL_MACHINE', @RegKey, N'TcpPort', @port OUTPUT, NO_OUTPUT
		END TRY
		BEGIN CATCH
			SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
			SELECT @ErrorMessage = 'Instance info subsection - Error raised in TRY block 1. ' + ERROR_MESSAGE()
			RAISERROR (@ErrorMessage, 16, 1);
		END CATCH
	END
	ELSE
	BEGIN
		RAISERROR('WARNING: Missing permissions for full "Instance info" checks. Bypassing TCP port check', 16, 1, N'sysadmin')
		--RETURN
	END
END
ELSE
BEGIN
	BEGIN TRY
		/*
		SET @sqlcmd = N'SELECT @portOUT = MAX(CONVERT(VARCHAR(15),value_data)) FROM sys.dm_server_registry WHERE registry_key LIKE ''%MSSQLServer\SuperSocketNetLib\Tcp\%'' AND value_name LIKE N''%TcpPort%'' AND CONVERT(float,value_data) > 0;';
		SET @params = N'@portOUT VARCHAR(15) OUTPUT';
		EXECUTE sp_executesql @sqlcmd, @params, @portOUT = @port OUTPUT;
		IF @port IS NULL
		BEGIN
			SET @sqlcmd = N'SELECT @portOUT = CONVERT(VARCHAR(15),value_data) FROM sys.dm_server_registry WHERE registry_key LIKE ''%MSSQLServer\SuperSocketNetLib\Tcp\%'' AND value_name LIKE N''%TcpDynamicPort%'' AND CONVERT(float,value_data) > 0;';
			SET @params = N'@portOUT VARCHAR(15) OUTPUT';
			EXECUTE sp_executesql @sqlcmd, @params, @portOUT = @port OUTPUT;
		END
		*/
		SET @sqlcmd = N'SELECT @portOUT = MAX(CONVERT(VARCHAR(15),port)) FROM sys.dm_tcp_listener_states WHERE is_ipv4 = 1 AND [type] = 0 AND ip_address <> ''127.0.0.1'';';
		SET @params = N'@portOUT VARCHAR(15) OUTPUT';
		EXECUTE sp_executesql @sqlcmd, @params, @portOUT = @port OUTPUT;
		IF @port IS NULL
		BEGIN
			SET @sqlcmd = N'SELECT @portOUT = MAX(CONVERT(VARCHAR(15),port)) FROM sys.dm_tcp_listener_states WHERE is_ipv4 = 0 AND [type] = 0 AND ip_address <> ''127.0.0.1'';';
			SET @params = N'@portOUT VARCHAR(15) OUTPUT';
			EXECUTE sp_executesql @sqlcmd, @params, @portOUT = @port OUTPUT;
		END
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
		SELECT @ErrorMessage = 'Instance info subsection - Error raised in TRY block 2. ' + ERROR_MESSAGE()
		RAISERROR (@ErrorMessage, 16, 1);
	END CATCH
END

IF (ISNULL(IS_SRVROLEMEMBER(N'sysadmin'), 0) = 1) OR ((SELECT COUNT([name]) FROM @permstbl WHERE [name] = 'xp_instance_regread') = 1)
BEGIN
	BEGIN TRY
		EXEC master..xp_instance_regread N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\Replication', N'IsInstalled', @replication OUTPUT, NO_OUTPUT
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
		SELECT @ErrorMessage = 'Instance info subsection - Error raised in TRY block 3. ' + ERROR_MESSAGE()
		RAISERROR (@ErrorMessage, 16, 1);
	END CATCH
END
ELSE
BEGIN
	RAISERROR('WARNING: Missing permissions for full "Instance info" checks. Bypassing replication check', 16, 1, N'sysadmin')
	--RETURN
END

SELECT @cpucount = COUNT(cpu_id) FROM sys.dm_os_schedulers WHERE scheduler_id < 255 AND parent_node_id < 64
SELECT @numa = COUNT(DISTINCT parent_node_id) FROM sys.dm_os_schedulers WHERE scheduler_id < 255 AND parent_node_id < 64;

;WITH bits AS 
(SELECT 7 AS N, 128 AS E UNION ALL SELECT 6, 64 UNION ALL 
SELECT 5, 32 UNION ALL SELECT 4, 16 UNION ALL SELECT 3, 8 UNION ALL 
SELECT 2, 4 UNION ALL SELECT 1, 2 UNION ALL SELECT 0, 1), 
bytes AS 
(SELECT 1 M UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL 
SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL 
SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9)
-- CPU Affinity is shown highest to lowest CPU ID
SELECT @affinitymask = CASE WHEN [value] = 0 THEN REPLICATE('1', @cpucount)
	ELSE RIGHT((SELECT ((CONVERT(tinyint, SUBSTRING(CONVERT(binary(9), [value]), M, 1)) & E) / E) AS [text()] 
		FROM bits CROSS JOIN bytes
		ORDER BY M, N DESC
		FOR XML PATH('')), @cpucount) END
FROM sys.configurations (NOLOCK)
WHERE name = 'affinity mask';

IF @cpucount > 32
BEGIN
	;WITH bits AS 
	(SELECT 7 AS N, 128 AS E UNION ALL SELECT 6, 64 UNION ALL 
	SELECT 5, 32 UNION ALL SELECT 4, 16 UNION ALL SELECT 3, 8 UNION ALL 
	SELECT 2, 4 UNION ALL SELECT 1, 2 UNION ALL SELECT 0, 1), 
	bytes AS 
	(SELECT 1 M UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL 
	SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL 
	SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9)
	-- CPU Affinity is shown highest to lowest CPU ID
	SELECT @affinity64mask = CASE WHEN [value] = 0 THEN REPLICATE('1', @cpucount)
		ELSE RIGHT((SELECT ((CONVERT(tinyint, SUBSTRING(CONVERT(binary(9), [value]), M, 1)) & E) / E) AS [text()] 
			FROM bits CROSS JOIN bytes
			ORDER BY M, N DESC
			FOR XML PATH('')), @cpucount) END
	FROM sys.configurations (NOLOCK)
	WHERE name = 'affinity64 mask';
END;

/*
IF @cpucount > 32
SELECT @cpuover32 = ABS(LEN(@affinity64mask) - (@cpucount-32))

SELECT @cpuaffin = CASE WHEN @cpucount > 32 THEN REVERSE(LEFT(REVERSE(@affinity64mask),@cpuover32)) + RIGHT(@affinitymask,32) ELSE RIGHT(@affinitymask,@cpucount) END
*/

SELECT @cpuaffin = CASE WHEN @cpucount > 32 THEN @affinity64mask ELSE @affinitymask END

SET @cpuaffin_fixed = @cpuaffin

IF @numa > 1
BEGIN
	-- format binary mask by node for better reading
	SET @i = CEILING(@cpucount*1.00/@numa) + 1
	WHILE @i < @cpucount + @numa
	BEGIN
		IF (@cpucount + @numa) - @i >= SQRT(CEILING(@cpucount*1.00/@numa))
		BEGIN
			SELECT @cpuaffin_fixed = STUFF(@cpuaffin_fixed, @i, 1, '_' + SUBSTRING(@cpuaffin_fixed, @i, 1))
		END
		ELSE
		BEGIN
			SELECT @cpuaffin_fixed = STUFF(@cpuaffin_fixed, @i, CEILING(@cpucount*1.00/@numa), SUBSTRING(@cpuaffin_fixed, @i, CEILING(@cpucount*1.00/@numa)))
		END

		SET @i = @i + CEILING(@cpucount*1.00/@numa) + 1
	END
END

SELECT 'Information' AS [Category], 'Instance' AS [Information],
	(CASE WHEN CONVERT(VARCHAR(128), SERVERPROPERTY('InstanceName')) IS NULL THEN 'DEFAULT_INSTANCE'
		ELSE CONVERT(VARCHAR(128), SERVERPROPERTY('InstanceName')) END) AS Instance_Name,
	(CASE WHEN SERVERPROPERTY('IsClustered') = 1 THEN 'CLUSTERED' 
		WHEN SERVERPROPERTY('IsClustered') = 0 THEN 'NOT_CLUSTERED'
		ELSE 'INVALID INPUT/ERROR' END) AS Failover_Clustered,
	/*The version of SQL Server instance in the form: major.minor.build*/	
	CONVERT(VARCHAR(128), SERVERPROPERTY('ProductVersion')) AS Product_Version,
	/*Level of the version of SQL Server Instance*/
	CASE WHEN (@sqlmajorver = 11 AND @sqlminorver >= 6020) OR (@sqlmajorver = 12 AND @sqlminorver BETWEEN 2556 AND 2569) OR (@sqlmajorver = 12 AND @sqlminorver >= 4427) OR @sqlmajorver >= 13 THEN 
		CONVERT(VARCHAR(128), SERVERPROPERTY('ProductBuildType'))
	ELSE 'NA' END AS Product_Build_Type,
	CONVERT(VARCHAR(128), SERVERPROPERTY('ProductLevel')) AS Product_Level,
	CASE WHEN (@sqlmajorver = 11 AND @sqlminorver >= 6020) OR (@sqlmajorver = 12 AND @sqlminorver BETWEEN 2556 AND 2569) OR (@sqlmajorver = 12 AND @sqlminorver >= 4427) OR @sqlmajorver >= 13 THEN 
		CONVERT(VARCHAR(128), SERVERPROPERTY('ProductUpdateLevel'))
	ELSE 'NA' END AS Product_Update_Level,
	CASE WHEN (@sqlmajorver = 11 AND @sqlminorver >= 6020) OR (@sqlmajorver = 12 AND @sqlminorver BETWEEN 2556 AND 2569) OR (@sqlmajorver = 12 AND @sqlminorver >= 4427) OR @sqlmajorver >= 13 THEN 
		CONVERT(VARCHAR(128), SERVERPROPERTY('ProductUpdateReference'))
	ELSE 'NA' END AS Product_Update_Ref_KB,
	CONVERT(VARCHAR(128), SERVERPROPERTY('Edition')) AS Edition,
	CONVERT(VARCHAR(128), SERVERPROPERTY('MachineName')) AS Machine_Name,
	RTRIM(@port) AS TCP_Port,
	@@SERVICENAME AS Service_Name,
	/*To identify which sqlservr.exe belongs to this instance*/
	SERVERPROPERTY('ProcessID') AS Process_ID, 
	CONVERT(VARCHAR(128), SERVERPROPERTY('ServerName')) AS Server_Name,
	@cpuaffin_fixed AS Affinity_Mask_Bitmask,
	CONVERT(VARCHAR(128), SERVERPROPERTY('Collation')) AS [Server_Collation],
	(CASE WHEN @replication = 1 THEN 'Installed' 
		WHEN @replication = 0 THEN 'Not_Installed' 
		ELSE 'INVALID INPUT/ERROR' END) AS Replication_Components_Installation,
	(CASE WHEN SERVERPROPERTY('IsFullTextInstalled') = 1 THEN 'Installed' 
		WHEN SERVERPROPERTY('IsFulltextInstalled') = 0 THEN 'Not_Installed' 
		ELSE 'INVALID INPUT/ERROR' END) AS Full_Text_Installation,
	(CASE WHEN SERVERPROPERTY('IsIntegratedSecurityOnly') = 1 THEN 'Integrated_Security' 
		WHEN SERVERPROPERTY('IsIntegratedSecurityOnly') = 0 THEN 'SQL_Server_Security' 
		ELSE 'INVALID INPUT/ERROR' END) AS [Security],
	(CASE WHEN SERVERPROPERTY('IsSingleUser') = 1 THEN 'Single_User' 
		WHEN SERVERPROPERTY('IsSingleUser') = 0	THEN 'Multi_User' 
		ELSE 'INVALID INPUT/ERROR' END) AS [Single_User],
	(CASE WHEN CONVERT(VARCHAR(128), SERVERPROPERTY('LicenseType')) = 'PER_SEAT' THEN 'Per_Seat_Mode' 
		WHEN CONVERT(VARCHAR(128), SERVERPROPERTY('LicenseType')) = 'PER_PROCESSOR' THEN 'Per_Processor_Mode' 
		ELSE 'Disabled' END) AS License_Type, -- From SQL Server 2008R2 always returns DISABLED.
	CONVERT(NVARCHAR(128), SERVERPROPERTY('BuildClrVersion')) AS CLR_Version,
	CASE WHEN @sqlmajorver >= 10 THEN 
		CASE WHEN SERVERPROPERTY('FilestreamConfiguredLevel') = 0 THEN 'Disabled'
			WHEN SERVERPROPERTY('FilestreamConfiguredLevel') = 1 THEN 'Enabled_for_TSQL'
			ELSE 'Enabled for TSQL and Win32' END
	ELSE 'Not compatible' END AS Filestream_Configured_Level,
	CASE WHEN @sqlmajorver >= 10 THEN 
		CASE WHEN SERVERPROPERTY('FilestreamEffectiveLevel') = 0 THEN 'Disabled'
			WHEN SERVERPROPERTY('FilestreamEffectiveLevel') = 1 THEN 'Enabled_for_TSQL'
			ELSE 'Enabled for TSQL and Win32' END
	ELSE 'Not compatible' END AS Filestream_Effective_Level,
	CASE WHEN @sqlmajorver >= 10 THEN 
		SERVERPROPERTY('FilestreamShareName')
	ELSE 'Not compatible' END AS Filestream_Share_Name,
	CASE WHEN @sqlmajorver >= 12 THEN 
		SERVERPROPERTY('IsXTPSupported')
	ELSE 'Not compatible' END AS XTP_Compatible,
	CASE WHEN @sqlmajorver >= 13 THEN 
		SERVERPROPERTY('IsPolybaseInstalled')
	ELSE 'Not compatible' END AS Polybase_Installed,
	CASE WHEN @sqlmajorver >= 13 THEN 
		SERVERPROPERTY('IsAdvancedAnalyticsInstalled')
	ELSE 'Not compatible' END AS R_Services_Installed;