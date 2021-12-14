/***********************************************************************
Copyright 2016, Kendra Little - LittleKendra.com
MIT License, http://www.opensource.org/licenses/mit-license.php
***********************************************************************/

USE WideWorldImporters;
GO

IF (select count(*) from sys.schemas where name='ddl')=0
	exec ('CREATE SCHEMA ddl AUTHORIZATION dbo;');
GO

IF (select count(*) from sys.objects as so 
	join sys.schemas as sc on so.schema_id=so.schema_id
	where sc.name='ddl' and so.name='table_index_create_alter')=0
CREATE TABLE ddl.table_index_create_alter (
	table_index_create_alter_id BIGINT IDENTITY NOT NULL,
	UTCDatetime DATETIME2(7),
	login_name NVARCHAR(128),
	schema_name NVARCHAR(128),
	target_object_name NVARCHAR(128),
	object_name NVARCHAR(128),
	new_object_name NVARCHAR(128),
	TSQL nvarchar(MAX)
)
GO

IF (select count(*) from sys.objects WHERE name='pk_table_index_create_alter')=0
ALTER TABLE ddl.table_index_create_alter ADD CONSTRAINT pk_table_index_create_alter
	PRIMARY KEY CLUSTERED ( table_index_create_alter_id )
	WITH (DATA_COMPRESSION =  ROW);
GO


IF EXISTS ( SELECT 1 FROM sys.triggers
	WHERE name = N'ddl_trigger_table_index_create_alter'
	AND parent_class_desc = N'DATABASE' )
	DROP TRIGGER ddl_trigger_table_index_create_alter ON DATABASE
GO

CREATE TRIGGER ddl_trigger_table_index_create_alter ON DATABASE 
WITH EXECUTE AS 'dbo'
	FOR 
	CREATE_INDEX, ALTER_INDEX, DROP_INDEX, 
	CREATE_FULLTEXT_INDEX, ALTER_FULLTEXT_INDEX, DROP_FULLTEXT_INDEX, 
	CREATE_SPATIAL_INDEX,
	CREATE_XML_INDEX, 
	CREATE_TABLE, ALTER_TABLE, DROP_TABLE,
	RENAME
AS 
	SET NOCOUNT ON;

	DECLARE @ddltriggerxml  XML;
	SELECT @ddltriggerxml  = EVENTDATA();

	INSERT ddl.table_index_create_alter ( 
		UTCDatetime, login_name, schema_name, target_object_name, object_name, new_object_name, TSQL)
	SELECT 
		SYSUTCDATETIME(),
		ORIGINAL_LOGIN(),
		@ddltriggerxml.value('(/EVENT_INSTANCE/SchemaName)[1]', 'nvarchar(128)'),
		@ddltriggerxml.value('(/EVENT_INSTANCE/TargetObjectName)[1]', 'nvarchar(128)'),
		@ddltriggerxml.value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(128)'),
		@ddltriggerxml.value('(/EVENT_INSTANCE/NewObjectName)[1]', 'nvarchar(128)'),
		@ddltriggerxml.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(MAX)');

GO



/* Test it! */

CREATE INDEX ix_testindexcreate on Sales.Invoices (RunPosition);
GO

exec sp_rename 'Sales.Invoices.ix_testindexcreate', 'ix_Sales_Invoices_RunPosition';
GO

DROP INDEX ix_Sales_Invoices_RunPosition on Sales.Invoices;
GO

SELECT *
FROM ddl.table_index_create_alter;
GO