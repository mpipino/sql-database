SET NOCOUNT ON;
SET ANSI_WARNINGS ON;
SET QUOTED_IDENTIFIER ON;

IF (SELECT COUNT([name]) FROM sys.server_triggers WHERE is_disabled = 0 AND is_ms_shipped = 0) > 0
BEGIN
	SELECT 'Information' AS [Category], 'Logon_Triggers' AS [Information], name AS [Trigger_Name], type_desc AS [Trigger_Type],create_date, modify_date
	FROM sys.server_triggers WHERE is_disabled = 0 AND is_ms_shipped = 0
	ORDER BY name;
END
ELSE
BEGIN
	SELECT 'Information' AS [Category], 'Logon_Triggers' AS [Information], 'NA' AS [Comment]
END;