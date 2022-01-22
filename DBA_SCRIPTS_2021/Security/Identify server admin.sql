--Identify server admin and Active Directory Admin using TSQL
;WITH 
 [explicit] AS (
    SELECT [p].[principal_id], [p].[name], [p].[type_desc], [p].[create_date],
          [dbp].[permission_name] COLLATE SQL_Latin1_General_CP1_CI_AS [permission],
          CAST('' AS SYSNAME) [grant_through]
    FROM [sys].[database_permissions] [dbp]
    INNER JOIN [sys].[database_principals] [p] ON [dbp].[grantee_principal_id] = [p].[principal_id]
    WHERE ([dbp].[type] IN ('IN','UP','DL','CL','DABO','IM','SL','TO') OR [dbp].[type] LIKE 'AL%' OR [dbp].[type] LIKE 'CR%')
      AND [dbp].[state] IN ('G','W')
    UNION ALL
    SELECT [dp].[principal_id], [dp].[name], [dp].[type_desc], [dp].[create_date], [p].[permission], [p].[name] [grant_through]
    FROM [sys].[database_principals] [dp]
    INNER JOIN [sys].[database_role_members] [rm] ON [rm].[member_principal_id] = [dp].[principal_id]
    INNER JOIN [explicit] [p] ON [p].[principal_id] = [rm].[role_principal_id]
    ),
 [fixed] AS (
    SELECT [dp].[principal_id], [dp].[name], [dp].[type_desc], [dp].[create_date], [p].[name] [permission], CAST('' AS SYSNAME) [grant_through]
    FROM [sys].[database_principals] [dp]
    INNER JOIN [sys].[database_role_members] [rm] ON [rm].[member_principal_id] = [dp].[principal_id]
    INNER JOIN [sys].[database_principals] [p] ON [p].[principal_id] = [rm].[role_principal_id]
    WHERE [p].[name] IN ('dbmanager','loginmanager')
    UNION ALL
    SELECT [dp].[principal_id], [dp].[name], [dp].[type_desc], [dp].[create_date], [p].[permission], [p].[name] [grant_through]
    FROM [sys].[database_principals] [dp]
    INNER JOIN [sys].[database_role_members] [rm] ON [rm].[member_principal_id] = [dp].[principal_id]
    INNER JOIN [fixed] [p] ON [p].[principal_id] = [rm].[role_principal_id]
    )
 SELECT DISTINCT DB_NAME() [database], [name] [username], [type_desc], [create_date], [permission], [grant_through]
   FROM [explicit]
  WHERE [type_desc] NOT IN ('DATABASE_ROLE')
 UNION ALL
 SELECT DISTINCT DB_NAME(), [name], [type_desc], [create_date], [permission], [grant_through]
   FROM [fixed]
  WHERE [type_desc] NOT IN ('DATABASE_ROLE')
 ORDER BY 1, 2
 OPTION(MAXRECURSION 10);