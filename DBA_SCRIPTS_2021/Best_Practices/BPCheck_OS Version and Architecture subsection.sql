SET NOCOUNT ON;
SET ANSI_WARNINGS ON;
SET QUOTED_IDENTIFIER ON;

DECLARE @sqlcmd NVARCHAR(max), @params NVARCHAR(600)
DECLARE @sqlmajorver int, @sqlminorver int, @sqlbuild int
DECLARE @ErrorMessage NVARCHAR(4000)
DECLARE @clustered bit, @osver VARCHAR(5), @ostype VARCHAR(10), @osdistro VARCHAR(20), @server VARCHAR(128), @instancename NVARCHAR(128)
DECLARE @arch smallint, @ossp VARCHAR(25), @SystemManufacturer VARCHAR(128)

SELECT @sqlmajorver = CONVERT(int, (@@microsoftversion / 0x1000000) & 0xff);
SELECT @sqlminorver = CONVERT(int, (@@microsoftversion / 0x10000) & 0xff);
SELECT @sqlbuild = CONVERT(int, @@microsoftversion & 0xffff);

IF (@sqlmajorver >= 11 AND @sqlmajorver < 14) OR (@sqlmajorver = 10 AND @sqlminorver = 50 AND @sqlbuild >= 2500)
BEGIN
	SET @sqlcmd = N'SELECT @ostypeOUT = ''Windows'', @osdistroOUT = ''Windows'', @osverOUT = CASE WHEN windows_release IN (''6.3'',''10.0'') AND (@@VERSION LIKE ''%Build 10586%'' OR @@VERSION LIKE ''%Build 14393%'') THEN ''10.0'' ELSE windows_release END, @osspOUT = windows_service_pack_level, @archOUT = CASE WHEN @@VERSION LIKE ''%<X64>%'' THEN 64 WHEN @@VERSION LIKE ''%<IA64>%'' THEN 128 ELSE 32 END FROM sys.dm_os_windows_info (NOLOCK)';
	SET @params = N'@osverOUT VARCHAR(5) OUTPUT, @ostypeOUT VARCHAR(10) OUTPUT, @osdistroOUT VARCHAR(20) OUTPUT, @osspOUT VARCHAR(25) OUTPUT, @archOUT smallint OUTPUT';
	EXECUTE sp_executesql @sqlcmd, @params, @osverOUT=@osver OUTPUT, @ostypeOUT=@ostype OUTPUT, @osdistroOUT=@osdistro OUTPUT, @osspOUT=@ossp OUTPUT, @archOUT=@arch OUTPUT;
END
ELSE IF @sqlmajorver >= 14
BEGIN
	SET @sqlcmd = N'SELECT @ostypeOUT = host_platform, @osdistroOUT = host_distribution, @osverOUT = CASE WHEN host_platform = ''Windows'' AND host_release IN (''6.3'',''10.0'') THEN ''10.0'' ELSE host_release END, @osspOUT = host_service_pack_level, @archOUT = CASE WHEN @@VERSION LIKE ''%<X64>%'' THEN 64 ELSE 32 END FROM sys.dm_os_host_info (NOLOCK)';
	SET @params = N'@osverOUT VARCHAR(5) OUTPUT, @ostypeOUT VARCHAR(10) OUTPUT, @osdistroOUT VARCHAR(20) OUTPUT, @osspOUT VARCHAR(25) OUTPUT, @archOUT smallint OUTPUT';
	EXECUTE sp_executesql @sqlcmd, @params, @osverOUT=@osver OUTPUT, @ostypeOUT=@ostype OUTPUT, @osdistroOUT=@osdistro OUTPUT, @osspOUT=@ossp OUTPUT, @archOUT=@arch OUTPUT;
END
ELSE
BEGIN
	BEGIN TRY
		DECLARE @str VARCHAR(500), @str2 VARCHAR(500), @str3 VARCHAR(500)
		DECLARE @sysinfo TABLE (id int, 
			[Name] NVARCHAR(256), 
			Internal_Value bigint, 
			Character_Value NVARCHAR(256));
			
		INSERT INTO @sysinfo
		EXEC xp_msver;
		
		SELECT @osver = LEFT(Character_Value, CHARINDEX(' ', Character_Value)-1) -- 5.2 is WS2003; 6.0 is WS2008; 6.1 is WS2008R2; 6.2 is WS2012, 6.3 is WS2012R2, 6.3 (14396) is WS2016
		FROM @sysinfo
		WHERE [Name] LIKE 'WindowsVersion%';
		
		SELECT @arch = CASE WHEN RTRIM(Character_Value) LIKE '%x64%' OR RTRIM(Character_Value) LIKE '%AMD64%' THEN 64
			WHEN RTRIM(Character_Value) LIKE '%x86%' OR RTRIM(Character_Value) LIKE '%32%' THEN 32
			WHEN RTRIM(Character_Value) LIKE '%IA64%' THEN 128 END
		FROM @sysinfo
		WHERE [Name] LIKE 'Platform%';
		
		SET @str = (SELECT @@VERSION)
		SELECT @str2 = RIGHT(@str, LEN(@str)-CHARINDEX('Windows',@str) + 1)
		SELECT @str3 = RIGHT(@str2, LEN(@str2)-CHARINDEX(': ',@str2))
		SELECT @ossp = LTRIM(LEFT(@str3, CHARINDEX(')',@str3) -1))
		SET @ostype = 'Windows'
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
		SELECT @ErrorMessage = 'Windows Version and Architecture subsection - Error raised in TRY block. ' + ERROR_MESSAGE()
		RAISERROR (@ErrorMessage, 16, 1);
	END CATCH
END;

DECLARE @machineinfo TABLE ([Value] NVARCHAR(256), [Data] NVARCHAR(256))

IF @ostype = 'Windows'
BEGIN
	INSERT INTO @machineinfo
	EXEC xp_instance_regread 'HKEY_LOCAL_MACHINE','HARDWARE\DESCRIPTION\System\BIOS','SystemManufacturer';
	INSERT INTO @machineinfo
	EXEC xp_instance_regread 'HKEY_LOCAL_MACHINE','HARDWARE\DESCRIPTION\System\BIOS','SystemProductName';
	INSERT INTO @machineinfo
	EXEC xp_instance_regread 'HKEY_LOCAL_MACHINE','HARDWARE\DESCRIPTION\System\BIOS','SystemFamily';
	INSERT INTO @machineinfo
	EXEC xp_instance_regread 'HKEY_LOCAL_MACHINE','HARDWARE\DESCRIPTION\System\BIOS','BIOSVendor';
	INSERT INTO @machineinfo
	EXEC xp_instance_regread 'HKEY_LOCAL_MACHINE','HARDWARE\DESCRIPTION\System\BIOS','BIOSVersion';
	INSERT INTO @machineinfo
	EXEC xp_instance_regread 'HKEY_LOCAL_MACHINE','HARDWARE\DESCRIPTION\System\BIOS','BIOSReleaseDate';
	INSERT INTO @machineinfo
	EXEC xp_instance_regread 'HKEY_LOCAL_MACHINE','HARDWARE\DESCRIPTION\System\CentralProcessor\0','ProcessorNameString';
END

SELECT @SystemManufacturer = [Data] FROM @machineinfo WHERE [Value] = 'SystemManufacturer';

SELECT 'Information' AS [Category], 'Machine' AS [Information], 
	CASE @osver WHEN '5.2' THEN 'XP/WS2003'
		WHEN '6.0' THEN 'Vista/WS2008'
		WHEN '6.1' THEN 'W7/WS2008R2'
		WHEN '6.2' THEN 'W8/WS2012'
		WHEN '6.3' THEN 'W8.1/WS2012R2'
		WHEN '10.0' THEN 'W10/WS2016'
		ELSE @ostype + ' ' + @osdistro
	END AS [OS_Version],
	CASE WHEN @ostype = 'Windows' THEN @ossp ELSE @osver END AS [Service_Pack_Level],
	@arch AS [Architecture],
	SERVERPROPERTY('MachineName') AS [Machine_Name],
	SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS [NetBIOS_Name],
	@SystemManufacturer AS [System_Manufacturer],
	(SELECT [Data] FROM @machineinfo WHERE [Value] = 'SystemFamily') AS [System_Family],
	(SELECT [Data] FROM @machineinfo WHERE [Value] = 'SystemProductName') AS [System_ProductName],
	(SELECT [Data] FROM @machineinfo WHERE [Value] = 'BIOSVendor') AS [BIOS_Vendor],
	(SELECT [Data] FROM @machineinfo WHERE [Value] = 'BIOSVersion') AS [BIOS_Version],
	(SELECT [Data] FROM @machineinfo WHERE [Value] = 'BIOSReleaseDate') AS [BIOS_Release_Date],
	(SELECT [Data] FROM @machineinfo WHERE [Value] = 'ProcessorNameString') AS [Processor_Name];