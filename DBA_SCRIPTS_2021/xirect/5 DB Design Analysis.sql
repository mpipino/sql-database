SELECT SCHEMA_NAME(schema_id) AS [Schema Name], name AS [Table Name]
FROM sys.tables
WHERE OBJECTPROPERTY(OBJECT_ID,'TableHasPrimaryKey') = 0
Order by name
GO