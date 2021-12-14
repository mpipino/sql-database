SET NOCOUNT ON;
SET ANSI_WARNINGS ON;
SET QUOTED_IDENTIFIER ON;

DECLARE @sqlcmd NVARCHAR(max), @params NVARCHAR(600), @sqlmajorver int
DECLARE @UpTime VARCHAR(12),@StartDate DATETIME

SELECT @sqlmajorver = CONVERT(int, (@@microsoftversion / 0x1000000) & 0xff);

IF @sqlmajorver < 10
BEGIN
	SET @sqlcmd = N'SELECT @UpTimeOUT = DATEDIFF(mi, login_time, GETDATE()), @StartDateOUT = login_time FROM master..sysprocesses (NOLOCK) WHERE spid = 1';
END
ELSE
BEGIN
	SET @sqlcmd = N'SELECT @UpTimeOUT = DATEDIFF(mi,sqlserver_start_time,GETDATE()), @StartDateOUT = sqlserver_start_time FROM sys.dm_os_sys_info (NOLOCK)';
END

SET @params = N'@UpTimeOUT VARCHAR(12) OUTPUT, @StartDateOUT DATETIME OUTPUT';

EXECUTE sp_executesql @sqlcmd, @params, @UpTimeOUT=@UpTime OUTPUT, @StartDateOUT=@StartDate OUTPUT;

SELECT 'Information' AS [Category], 'Uptime' AS [Information], GETDATE() AS [Current_Time], @StartDate AS Last_Startup, CONVERT(VARCHAR(4),@UpTime/60/24) + 'd ' + CONVERT(VARCHAR(4),@UpTime/60%24) + 'hr ' + CONVERT(VARCHAR(4),@UpTime%60) + 'min' AS Uptime