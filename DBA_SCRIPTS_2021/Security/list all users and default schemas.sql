SELECT DB_NAME() AS [database] 
      ,[name]
      ,[type_desc]
      ,[default_schema_name]
FROM [sys].[database_principals]


SELECT DB_NAME() AS [database] 
      ,[name]
      ,[type_desc]
      ,[default_schema_name]
FROM [sys].[database_principals]
WHERE [type] IN ('U', 'G')