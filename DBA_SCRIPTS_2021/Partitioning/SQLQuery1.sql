-- PARA CREAR PARTICIONES
--Create integer partition function for 15,000 partitions.  
-- FUNCION Y ESQUEMA DE PARTICION IMPLEMENTADOS EN CP_DW
DECLARE @IntegerPartitionFunction nvarchar(max) = 
    N'CREATE PARTITION FUNCTION pf_100000000_100000_1000 (int) 
    AS RANGE RIGHT FOR VALUES (';  
DECLARE @i int = 1;  
--SELECT 100000000/100000 --100 millones de ids de a 100 mil en 1000 particiones.
WHILE @i < 100000000  
BEGIN  
SET @IntegerPartitionFunction += CAST(@i as nvarchar(10)) + N', ';  
SET @i += 100000;  
END  
SET @IntegerPartitionFunction += CAST(@i as nvarchar(10)) + N');';  
--PRINT @IntegerPartitionFunction
EXEC sp_executesql @IntegerPartitionFunction;  
GO

CREATE PARTITION SCHEME [ps_TABLAS_pf_100000000_100000_1000] 
AS PARTITION [pf_100000000_100000_1000] ALL TO ([TABLAS])

--EJEMPLO:
--select max (intidcontacto) from cp_dw..tblContacto
--select COUNT(intidcontacto) from cp_dw..tblContacto --17702525

--ALTER TABLE [dbo].[tblContacto] DROP CONSTRAINT [PK_tblContacto]


--ALTER TABLE [dbo].[tblContacto] ADD  CONSTRAINT [PK_tblContacto] PRIMARY KEY CLUSTERED 
--(
--	[intIdContacto] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF
--, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON
--, FILLFACTOR = 100, DATA_COMPRESSION = PAGE) ON [ps_TABLAS_pf_100000000_100000_1000]([intIdContacto]) --2:18 



DECLARE @IntegerPartitionFunction nvarchar(max) = 
    N'CREATE PARTITION FUNCTION pf_1000000000_1000000_1000 (int) 
    AS RANGE RIGHT FOR VALUES (';  
DECLARE @i int = 1;  
--SELECT 1000000000/1000000 --1000 millones de ids de a 1 millon en 1000 particiones.
WHILE @i < 1000000000  
BEGIN  
SET @IntegerPartitionFunction += CAST(@i as nvarchar(10)) + N', ';  
SET @i += 1000000;  
END  
SET @IntegerPartitionFunction += CAST(@i as nvarchar(10)) + N');';  
--PRINT @IntegerPartitionFunction
EXEC sp_executesql @IntegerPartitionFunction;  
GO




CREATE PARTITION SCHEME [ps_TABLAS_pf_BIGINT_1000000000_1000000_1000] 
AS PARTITION [pf_1000000000_1000000_1000] ALL TO ([TABLAS])


DECLARE @IntegerPartitionFunction nvarchar(max) = 
    N'CREATE PARTITION FUNCTION pf_BIGINT_1000000000_1000000_1000 (BIGint) 
    AS RANGE RIGHT FOR VALUES (';  
DECLARE @i int = 1;  
--SELECT 1000000000/1000000 --1000 millones de ids de a 1 millon en 1000 particiones.
WHILE @i < 1000000000  
BEGIN  
SET @IntegerPartitionFunction += CAST(@i as nvarchar(10)) + N', ';  
SET @i += 1000000;  
END  
SET @IntegerPartitionFunction += CAST(@i as nvarchar(10)) + N');';  
--PRINT @IntegerPartitionFunction
EXEC sp_executesql @IntegerPartitionFunction;  
GO


CREATE PARTITION SCHEME [ps_TABLAS_pf_BIGINT_1000000000_1000000_1000] 
AS PARTITION [pf_BIGINT_1000000000_1000000_1000] ALL TO ([TABLAS])



/*

 PARTICIONES DE SIR.

 Particion 1 es del SIR, INTERACTIVO
 PARTIONO 2...N SON DE LAS IMPORTACIONES DE bRASIL.

*/

use rom

select *
from rom.config.tblAuditoriaParticiones 


/*

	PARA VER TAMBIEN LOS VALORES DE CORTE.

*/
--paritioned table and index details
use rom
SELECT
      OBJECT_NAME(p.object_id) AS ObjectName,
      i.name                   AS IndexName,
      p.index_id               AS IndexID,
      ds.name                  AS PartitionScheme,   
      p.partition_number       AS PartitionNumber,
      fg.name                  AS FileGroupName,
      prv_left.value           AS LowerBoundaryValue,
      prv_right.value          AS UpperBoundaryValue,
      CASE pf.boundary_value_on_right
            WHEN 1 THEN 'RIGHT'
            ELSE 'LEFT' END    AS Range,
      p.rows AS Rows
FROM sys.partitions                  AS p
JOIN sys.indexes                     AS i
      ON i.object_id = p.object_id
      AND i.index_id = p.index_id
JOIN sys.data_spaces                 AS ds
      ON ds.data_space_id = i.data_space_id
JOIN sys.partition_schemes           AS ps
      ON ps.data_space_id = ds.data_space_id
JOIN sys.partition_functions         AS pf
      ON pf.function_id = ps.function_id
JOIN sys.destination_data_spaces     AS dds2
      ON dds2.partition_scheme_id = ps.data_space_id 
      AND dds2.destination_id = p.partition_number
JOIN sys.filegroups                  AS fg
      ON fg.data_space_id = dds2.data_space_id
LEFT JOIN sys.partition_range_values AS prv_left
      ON ps.function_id = prv_left.function_id
      AND prv_left.boundary_id = p.partition_number - 1
LEFT JOIN sys.partition_range_values AS prv_right
      ON ps.function_id = prv_right.function_id
      AND prv_right.boundary_id = p.partition_number 
WHERE
      OBJECTPROPERTY(p.object_id, 'ISMSShipped') = 0
	  and OBJECT_NAME(p.object_id)='tblhistoriaDetalle'
	  
UNION ALL
--non-partitioned table/indexes
SELECT
      OBJECT_NAME(p.object_id)    AS ObjectName,
      i.name                      AS IndexName,
      p.index_id                  AS IndexID,
      NULL                        AS PartitionScheme,
      p.partition_number          AS PartitionNumber,
      fg.name                     AS FileGroupName,  
      NULL                        AS LowerBoundaryValue,
      NULL                        AS UpperBoundaryValue,
      NULL                        AS Boundary, 
      p.rows                      AS Rows
FROM sys.partitions     AS p
JOIN sys.indexes        AS i
      ON i.object_id = p.object_id
      AND i.index_id = p.index_id
JOIN sys.data_spaces    AS ds
      ON ds.data_space_id = i.data_space_id
JOIN sys.filegroups           AS fg
      ON fg.data_space_id = i.data_space_id
WHERE
      OBJECTPROPERTY(p.object_id, 'ISMSShipped') = 0 
	  and OBJECT_NAME(p.object_id)='tblhistoriaDetalle'
ORDER BY
      ObjectName,
      IndexID,
      PartitionNumber;



------------------------------------------------------------------





/*
 show partitioned objects range values
	MUESTRA TABLAS INDICES PFUNCIONES DE PARTICION Y CANTIDAD DE ROWS.
 */
select p.[object_id],
   OBJECT_NAME(p.[object_id]) AS TbName, 
   p.index_id,
   p.partition_number,
   p.rows,
   index_name = i.[name],
   index_type_desc = i.type_desc,
   i.data_space_id,
   ds1.NAME AS [FILEGROUP_NAME],
   pf.function_id,
   pf.[name] AS Pf_Name,
   pf.type_desc,
   pf.boundary_value_on_right,
   destination_data_space_id = dds.destination_id,
   prv.parameter_id,
   prv.value
from sys.partitions p
inner join sys.indexes i 
 on p.[object_id] = i.[object_id] 
 and p.index_id = i.index_id
inner JOIN sys.data_spaces ds 
 on i.data_space_id = ds.data_space_id
inner JOIN sys.partition_schemes ps 
 on ds.data_space_id = ps.data_space_id
inner JOIN sys.partition_functions pf 
 on ps.function_id = pf.function_id
inner join sys.destination_data_spaces dds 
 on dds.partition_scheme_id = ds.data_space_id 
 and p.partition_number = dds.destination_id
INNER JOIN sys.data_spaces ds1
 on ds1.data_space_id = dds.data_space_id 
left outer JOIN sys.partition_range_values prv 
 on prv.function_id = ps.function_id 
 and p.partition_number = prv.boundary_id
--WHERE p.[object_id] = object_id('thename')
order by TbName, p.index_id, p.partition_number
 ;
 
go


select distinct
   p.[object_id],
   TbName = OBJECT_NAME(p.[object_id]), 
   index_name = i.[name],
   index_type_desc = i.type_desc,
   partition_scheme = ps.[name],
   data_space_id = ps.data_space_id,
   function_name = pf.[name],
   function_id = ps.function_id
from sys.partitions p
inner join sys.indexes i 
   on p.[object_id] = i.[object_id] 
   and p.index_id = i.index_id
inner join sys.data_spaces ds 
   on i.data_space_id = ds.data_space_id
inner join sys.partition_schemes ps 
 on ds.data_space_id = ps.data_space_id
inner JOIN sys.partition_functions pf 
   on ps.function_id = pf.function_id

-- WHERE p.[object_id] = object_id('JBMTest')
order by    TbName, index_name ;

/*
 show partitioned objects range values
 */
select p.[object_id],
   OBJECT_NAME(p.[object_id]) AS TbName, 
   p.index_id,
   p.partition_number,
   p.rows,
   index_name = i.[name],
   index_type_desc = i.type_desc,
   i.data_space_id,
   ds1.NAME AS [FILEGROUP_NAME],
   pf.function_id,
   pf.[name] AS Pf_Name,
   pf.type_desc,
   pf.boundary_value_on_right,
   destination_data_space_id = dds.destination_id,
   prv.parameter_id,
   prv.value
from sys.partitions p
inner join sys.indexes i 
 on p.[object_id] = i.[object_id] 
 and p.index_id = i.index_id
inner JOIN sys.data_spaces ds 
 on i.data_space_id = ds.data_space_id
inner JOIN sys.partition_schemes ps 
 on ds.data_space_id = ps.data_space_id
inner JOIN sys.partition_functions pf 
 on ps.function_id = pf.function_id
inner join sys.destination_data_spaces dds 
 on dds.partition_scheme_id = ds.data_space_id 
 and p.partition_number = dds.destination_id
INNER JOIN sys.data_spaces ds1
 on ds1.data_space_id = dds.data_space_id 
left outer JOIN sys.partition_range_values prv 
 on prv.function_id = ps.function_id 
 and p.partition_number = prv.boundary_id
--WHERE p.[object_id] = object_id('thename')
order by TbName, p.index_id, p.partition_number
 ;
 
go

/*

	PARA VER QUE PARTICIONES Y ESQUEMAS USA CADA TABLA
	
*/

select 
	t.name as TableName
	, ps.name as PartitionScheme
	, pf.name as PartitionFunction
	, p.partition_number
	, p.rows
	, case 
		when pf.boundary_value_on_right=1 then 'RIGHT' 
		else 'LEFT' 
	  end [range_type]
	, prv.value [boundary]
from sys.tables t
    join sys.indexes i on t.object_id = i.object_id
    join sys.partition_schemes ps on i.data_space_id = ps.data_space_id
    join sys.partition_functions pf on ps.function_id = pf.function_id
    join sys.partitions p on i.object_id = p.object_id and i.index_id = p.index_id
    join sys.partition_range_values prv on pf.function_id = prv.function_id and p.partition_number = prv.boundary_id
where i.index_id < 2  --So we're only looking at a clustered index or heap, which the table is partitioned on
order by p.partition_number



/*

	PARA VER INFORMACION DE LAS PARTICIONES DE UNA TABLA
	
	object – The table name.
	
	p# – The partition number.
	
	filegroup – The filegroup the partition is located on. Note that in this result, I am using the same filegroup for all partitions, but usually you would probably not do this.
	
	rows – Number of rows in the partition.
	
	comparison – shows “less than” if you are using right range partitioning or “less than or equal to” if you are using left range partitioning.
	
	value – The boundary point between the two partitions. This value is either in the right or left partition of the boundary point, depending on whether or not you are using right range or left range partitioning.
	
	first_page – The first file:page allocated for the partition.

*/

use romhistoria
DECLARE @TableName NVARCHAR(200) = N'tblHistoriaHistoria'
 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object]
     , p.partition_number AS [p#]
     , fg.name AS [filegroup]
     , p.rows
     , au.total_pages AS pages
     , CASE boundary_value_on_right
       WHEN 1 THEN 'less than'
       ELSE 'less than or equal to' END as comparison
     , rv.value
     , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
       SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
       CONVERT (INT, SUBSTRING (au.first_page, 4, 1) +
       SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) +
       SUBSTRING (au.first_page, 1, 1))) AS first_page
FROM sys.partitions p
INNER JOIN sys.indexes i
     ON p.object_id = i.object_id
AND p.index_id = i.index_id
INNER JOIN sys.objects o
     ON p.object_id = o.object_id
INNER JOIN sys.system_internals_allocation_units au
     ON p.partition_id = au.container_id
INNER JOIN sys.partition_schemes ps
     ON ps.data_space_id = i.data_space_id
INNER JOIN sys.partition_functions f
     ON f.function_id = ps.function_id
INNER JOIN sys.destination_data_spaces dds
     ON dds.partition_scheme_id = ps.data_space_id
     AND dds.destination_id = p.partition_number
INNER JOIN sys.filegroups fg
     ON dds.data_space_id = fg.data_space_id
LEFT OUTER JOIN sys.partition_range_values rv
     ON f.function_id = rv.function_id
     AND p.partition_number = rv.boundary_id
WHERE i.index_id < 2
     AND o.object_id = OBJECT_ID(@TableName);











-------------------------------------------

DECLARE @vchCadena NVARCHAR(MAX) = ''

;WITH cte AS (
SELECT CAST( '1' AS INT)  PARTICION
UNION ALL
SELECT 1 + PARTICION 
FROM cte
WHERE PARTICION < 450
)
SELECT @vchCadena += ',' + QUOTENAME( CONVERT ( VARCHAR, PARTICION, 106 ), '''' )
FROM cte
OPTION ( MAXRECURSION 450 )

SELECT @vchCadena = 'CREATE PARTITION FUNCTION pf_HISTORIAS (int) AS RANGE RIGHT FOR VALUES ( ' + STUFF( @vchCadena, 1, 1, '' ) + ' )'
SELECT @vchCadena CADENA

-- Create the partition function
PRINT @vchCadena
--EXEC ( @vchCadena )
GO

USE ROM
CREATE PARTITION FUNCTION pf_HISTORIAS (int) AS RANGE RIGHT FOR VALUES ( '1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59','60','61','62','63','64','65','66','67','68','69','70','71','72','73','74','75','76','77','78','79','80','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99','100','101','102','103','104','105','106','107','108','109','110','111','112','113','114','115','116','117','118','119','120','121','122','123','124','125','126','127','128','129','130','131','132','133','134','135','136','137','138','139','140','141','142','143','144','145','146','147','148','149','150','151','152','153','154','155','156','157','158','159','160','161','162','163','164','165','166','167','168','169','170','171','172','173','174','175','176','177','178','179','180','181','182','183','184','185','186','187','188','189','190','191','192','193','194','195','196','197','198','199','200','201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216','217','218','219','220','221','222','223','224','225','226','227','228','229','230','231','232','233','234','235','236','237','238','239','240','241','242','243','244','245','246','247','248','249','250','251','252','253','254','255','256','257','258','259','260','261','262','263','264','265','266','267','268','269','270','271','272','273','274','275','276','277','278','279','280','281','282','283','284','285','286','287','288','289','290','291','292','293','294','295','296','297','298','299','300','301','302','303','304','305','306','307','308','309','310','311','312','313','314','315','316','317','318','319','320','321','322','323','324','325','326','327','328','329','330','331','332','333','334','335','336','337','338','339','340','341','342','343','344','345','346','347','348','349','350','351','352','353','354','355','356','357','358','359','360','361','362','363','364','365','366','367','368','369','370','371','372','373','374','375','376','377','378','379','380','381','382','383','384','385','386','387','388','389','390','391','392','393','394','395','396','397','398','399','400','401','402','403','404','405','406','407','408','409','410','411','412','413','414','415','416','417','418','419','420','421','422','423','424','425','426','427','428','429','430','431','432','433','434','435','436','437','438','439','440','441','442','443','444','445','446','447','448','449','450' )
CREATE PARTITION SCHEME ps_HISTORIAS AS PARTITION pf_HISTORIAS ALL TO ( [romhistoria] )


----------------------------------------------------------------------

-- Generate partition function with ~3 years worth of daily partitions from 1 Jan 2014.
DECLARE @bigString NVARCHAR(MAX) = ''

;WITH cte AS (
SELECT CAST( '30 Apr 2014' AS DATE ) testDate
UNION ALL
SELECT DATEADD( day, 1, testDate )
FROM cte
WHERE testDate < '31 Dec 2016'
)
SELECT @bigString += ',' + QUOTENAME( CONVERT ( VARCHAR, testDate, 106 ), '''' )
FROM cte
OPTION ( MAXRECURSION 1100 )

SELECT @bigString = 'CREATE PARTITION FUNCTION pf_test (DATE) AS RANGE RIGHT FOR VALUES ( ' + STUFF( @bigString, 1, 1, '' ) + ' )'
SELECT @bigString bs

-- Create the partition function
PRINT @bigString
--EXEC ( @bigString )
GO

/*
-- Look at the boundaries
SELECT *
FROM sys.partition_range_values
WHERE function_id = ( SELECT function_id FROM sys.partition_functions WHERE name = 'pf_test' )
GO
*/

DECLARE @bigString NVARCHAR(MAX) = ''

;WITH cte AS (
SELECT ROW_NUMBER() OVER( ORDER BY boundary_id ) rn
FROM sys.partition_range_values
WHERE function_id = ( SELECT function_id FROM sys.partition_functions WHERE name = 'pf_test' )
UNION ALL 
SELECT 1    -- additional row required for fg
)
SELECT @bigString += ',' + '[tooManyPartitionsTestFg' + CAST( ( rn % 7 ) + 1 AS VARCHAR(5) ) + ']'
FROM cte
OPTION ( MAXRECURSION 1100 )

SELECT @bigString = 'CREATE PARTITION SCHEME ps_test AS PARTITION pf_test TO ( ' + STUFF( @bigString, 1, 1, '' ) + ' )'
PRINT @bigString
EXEC ( @bigString )
GO