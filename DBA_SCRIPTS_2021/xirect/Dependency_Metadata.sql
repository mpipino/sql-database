-- SQL Server 2008 object dependency query - listing object dependencies
SELECT ReferencingObjectType = o1.type,

       ReferencingObject = SCHEMA_NAME(o1.schema_id)+'.'+o1.name,

       ReferencedObject = SCHEMA_NAME(o2.schema_id)+'.'+ed.referenced_entity_name,

       ReferencedObjectType = o2.type

FROM   sys.sql_expression_dependencies ed

       INNER JOIN  sys.objects o1

         ON ed.referencing_id = o1.object_id

       INNER JOIN sys.objects o2

         ON ed.referenced_id = o2.object_id

WHERE	--o1.type in ('P','TR','V', 'TF') AND 
		o2.name='tbl_distributor_commissions_v2'
ORDER BY ReferencingObjectType, ReferencingObject


/*
-- Find all stored procedures where a column is being used/referenced
*/
DECLARE @SchemaName sysname = N'dbo';

DECLARE @TableName sysname = N'%Tbl_Distributor_Commissions_V2%';

DECLARE @ColumnName1 sysname = N'%CreateDate%';
DECLARE @ColumnName2 sysname = N'%joinDate%';
 

SELECT QUOTENAME(refing.referencing_schema_name) +

     N'.' + QUOTENAME(refing.referencing_entity_name) As SprocName

FROM sys.dm_sql_referencing_entities(QUOTENAME(ISNULL(@SchemaName,N'dbo')) +

     N'.' + QUOTENAME(@TableName),'object') refing

CROSS APPLY sys.dm_sql_referenced_entities(QUOTENAME(refing.referencing_schema_name) +

     N'.' + QUOTENAME(refing.referencing_entity_name), 'object') refed

WHERE EXISTS(SELECT * FROM sys.objects 

             WHERE refing.referencing_id = object_id and type ='P')

 -- AND refed.referenced_schema_name = @SchemaName

  AND refed.referenced_entity_name = @TableName

  --AND refed.referenced_minor_name  = @ColumnName1

  AND (refed.referenced_minor_name  = @ColumnName1 or refed.referenced_minor_name  = @ColumnName2)

ORDER BY SprocName;



/*
-- View column dependencies
*/
SELECT ReferencingObject = SCHEMA_NAME(o1.schema_id) + '.' + o1.name,

       ReferencedObject = SCHEMA_NAME(o2.schema_id) + '.'

                          + ed.referenced_entity_name,

       ColumnName = c.name,

       ReferencedObjectType = o2.type,

       ReferencingObjecType = o1.type

FROM   sys.sql_expression_dependencies ed

       INNER JOIN sys.objects o1

               ON ed.referencing_id = o1.object_id

       INNER JOIN sys.objects o2

               ON ed.referenced_id = o2.object_id

       INNER JOIN sys.sql_dependencies d

               ON ed.referencing_id = d.object_id

                  AND d.referenced_major_id = ed.referenced_id

       INNER JOIN sys.columns c

               ON c.object_id = ed.referenced_id

                  AND d.referenced_minor_id = c.column_id

--WHERE  SCHEMA_NAME(o1.schema_id) + '.' + o1.name = 'Commissions_Distributor_Temp'

ORDER  BY ReferencedObject,

          c.column_id; 