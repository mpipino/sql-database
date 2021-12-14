SET NOCOUNT ON;
SET ANSI_WARNINGS ON;
SET QUOTED_IDENTIFIER ON;

DECLARE @sqlcmd NVARCHAR(max), @params NVARCHAR(600)
DECLARE @sqlmajorver int

SELECT @sqlmajorver = CONVERT(int, (@@microsoftversion / 0x1000000) & 0xff);

IF (SELECT COUNT(*) FROM sys.servers AS s INNER JOIN sys.linked_logins AS l (NOLOCK) ON s.server_id = l.server_id INNER JOIN sys.server_principals AS p (NOLOCK) ON p.principal_id = l.local_principal_id WHERE s.is_linked = 1) > 0
BEGIN
	SET @sqlcmd = 'SELECT ''Information'' AS [Category], ''Linked_servers'' AS [Information], s.name, s.product, 
	s.provider, s.data_source, s.location, s.provider_string, s.catalog, s.connect_timeout, 
	s.query_timeout, s.is_linked, s.is_remote_login_enabled, s.is_rpc_out_enabled, 
	s.is_data_access_enabled, s.is_collation_compatible, s.uses_remote_collation, s.collation_name, 
	s.lazy_schema_validation, s.is_system, s.is_publisher, s.is_subscriber, s.is_distributor, 
	s.is_nonsql_subscriber' + CASE WHEN @sqlmajorver > 9 THEN ', s.is_remote_proc_transaction_promotion_enabled' ELSE '' END + ',
	s.modify_date, CASE WHEN l.local_principal_id = 0 THEN ''local or wildcard'' ELSE p.name END AS [local_principal], 
	CASE WHEN l.uses_self_credential = 0 THEN ''use own credentials'' ELSE ''use supplied username and pwd'' END AS uses_self_credential, 
	l.remote_name, l.modify_date AS [linked_login_modify_date]
FROM sys.servers AS s (NOLOCK)
INNER JOIN sys.linked_logins AS l (NOLOCK) ON s.server_id = l.server_id
INNER JOIN sys.server_principals AS p (NOLOCK) ON p.principal_id = l.local_principal_id
WHERE s.is_linked = 1'
	EXECUTE sp_executesql @sqlcmd
END
ELSE
BEGIN
	SELECT 'Information' AS [Category], 'Linked_servers' AS [Information], 'None' AS [Status]
END;