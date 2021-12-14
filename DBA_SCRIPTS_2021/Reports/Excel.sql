--DB Size
select    
      sum (reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats

GO


--Table Size
select    
      sys.objects.name, sum(reserved_page_count) * 8.0 / 1024 / 1024 [SizeInGB] 
from    
      sys.dm_db_partition_stats, sys.objects
where    
      sys.dm_db_partition_stats.object_id = sys.objects.object_id

group by sys.objects.name
order by sum(reserved_page_count) DESC



-- Historico de Fragmentation.
SELECT getdate() as Snapshot_date
,S.name as 'Schema',
T.name as 'Table',
I.name as 'Index',
DDIPS.avg_fragmentation_in_percent,
convert (int,DDIPS.page_count) as page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS DDIPS
INNER JOIN sys.tables T on T.object_id = DDIPS.object_id
INNER JOIN sys.schemas S on T.schema_id = S.schema_id
INNER JOIN sys.indexes I ON I.object_id = DDIPS.object_id
AND DDIPS.index_id = I.index_id
WHERE DDIPS.database_id = DB_ID()
and I.name is not null
AND DDIPS.avg_fragmentation_in_percent > 0
ORDER BY page_count DESC ,DDIPS.avg_fragmentation_in_percent desc


--------------------
--PAGE SPLITS
SELECT 
GETDATE--() AS snapshot_date,
IOS.INDEX_ID,
O.NAME AS OBJECT_NAME,
I.NAME AS INDEX_NAME,
IOS.LEAF_ALLOCATION_COUNT AS PAGE_SPLIT_FOR_INDEX,
IOS.NONLEAF_ALLOCATION_COUNT PAGE_ALLOCATION_CAUSED_BY_PAGESPLIT
FROM SYS.DM_DB_INDEX_OPERATIONAL_STATS--(DB_ID--(N'DB_NAME'),NULL,NULL,NULL) IOS
JOIN
SYS.INDEXES I
ON
IOS.INDEX_ID=I.INDEX_ID
AND IOS.OBJECT_ID = I.OBJECT_ID
JOIN
SYS.OBJECTS O
ON
IOS.OBJECT_ID=O.OBJECT_ID
--WHERE O.TYPE_DESC='USER_TABLE'
--ORDER BY PAGE_ALLOCATION_CAUSED_BY_PAGESPLIT DESC
ORDER BY PAGE_SPLIT_FOR_INDEX DESC

-------------------

--sp_execution_Analysis
SELECT TOP 50 d.object_id, db_name(d.database_id) as BaseDatos, OBJECT_NAME(object_id, database_id) 'proc name', 
d.cached_time, d.last_execution_time, d.total_elapsed_time/d.execution_count AS [avg_elapsed_time],
d.last_elapsed_time, d.execution_count,max_logical_reads,max_logical_writes, LAST_LOGICAL_READS, LAST_LOGICAL_WRITES, LAST_WORKER_TIME, LAST_ELAPSED_TIME --PARA EVALUAR HISTORICO!
FROM sys.dm_exec_procedure_stats AS d
--where [proc name] like "%%"
ORDER BY last_execution_time DESC
--ORDER BY execution_count desc, max_logical_reads desc, [total_worker_time] DESC;
-- Bl_Commissions_Distributor_Volume_Ranks_Sp --maxlogwrites: 20599 --max logical reads: 17561705
-- Distributor_Get_TotalEarnings_EnrollmentTree_ByDistributorId_Sp --(octavo) -- 3079022 2512
--1481160422	BodyLogic_Live	Countries_GetById_Sp	2021-02-26 05:22:11.670	2021-03-10 13:36:58.617	91837901	51	41	1791789	13	5
--select * FROM sys.dm_exec_procedure_stats 

-------------
--table access analysis
--Tablas mas accedidas:

Declare @Database varchar--(max)
Declare @Tabla varchar--(max)
select  
			GETDATE--() AS SNAPSHOT_DATE,
			S.[Name] as Tabla, 
             s.object_id,
             Si.[name] As Indice, SI.[index_id], SI.[type_desc] as Tipo_Indice,
             SIu.user_seeks,
             SIU.user_scans,
             SIU.user_lookups,
             SIU.user_updates,
             SIU.last_user_seek,
             SIU.last_user_scan,
             SIU.last_user_lookup,
             SIU.last_user_update
From sys.objects S 
Inner Join sys.indexes SI On S.object_id = SI.object_id
Inner Join sys.dm_db_index_usage_stats SIU On Siu.object_id = SI.object_id and SIU.index_id = SI.index_id
--Where 
 ----(@Tabla is null or S.[name] = @Tabla)
and S.type = 'U'
--and SIU.database_id = DB_ID--(@Database)
--Order by Tabla, Si.index_id
Order by SIu.user_seeks DESC

-----------
--tipos de datos de columnas. para ver cuales nombres de columnas tiene n distintos tipos de dato
-----------
select  
        s.[name]            'Schema',
        t.[name]            'Table',
        c.[name]            'Column',
        d.[name]            'Data Type',
        c.[max_length]      'Length',
        d.[max_length]      'Max Length',
        d.[precision]       'Precision',
        c.[is_identity]     'Is Id',
        c.[is_nullable]     'Is Nullable',
        c.[is_computed]     'Is Computed',
        d.[is_user_defined] 'Is UserDefined',
        t.[modify_date]     'Date Modified',
        t.[create_date]     'Date created'
from        sys.schemas s
inner join  sys.tables  t
on s.schema_id = t.schema_id
inner join  sys.columns c
on t.object_id = c.object_id
inner join  sys.types   d
on c.user_type_id = d.user_type_id
order by c.[name] desc, t.[name]  


-------------------------------------------
-- Missing indexes
Declare @Database varchar--(max)
Declare @Tabla varchar--(max)
Set @Database = 'ASEA_prod' 
--Set @Tabla = 'Materiales'
--Set @Tabla = 'TRF_TRANSFERS'
select  S.[Name] as Tabla, 
             s.object_id,
             Si.[name] As Indice, SI.[index_id], SI.[type_desc] as Tipo_Indice,
             SIu.user_seeks,
             SIU.user_scans,
             SIU.user_lookups,
             SIU.user_updates,
             SIU.last_user_seek,
             SIU.last_user_scan,
             SIU.last_user_lookup,
             SIU.last_user_update
From sys.objects S 
Inner Join sys.indexes SI On S.object_id = SI.object_id
Inner Join sys.dm_db_index_usage_stats SIU On Siu.object_id = SI.object_id and SIU.index_id = SI.index_id
Where 
 --(@Tabla is null or S.[name] = @Tabla)
and S.type = 'U'
and SIU.database_id = DB_ID--(@Database)
--Order by Tabla, Si.index_id
Order by SIu.user_seeks DESC