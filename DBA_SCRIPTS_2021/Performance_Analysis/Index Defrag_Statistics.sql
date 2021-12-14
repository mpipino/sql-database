EXECUTE [dba].[IndexOptimize]
						 @Databases = 'Express_Test', @FragmentationLow = NULL, @FragmentationMedium = 'INDEX_REORGANIZE'
						 ,@FragmentationHigh = 'INDEX_REBUILD_ONLINE', @FragmentationLevel1 = 20, @FragmentationLevel2 = 40
						 --,@FragmentationHigh = 'INDEX_REORGANIZE', @FragmentationLevel1 = 40, @FragmentationLevel2 = 80
						 , @MaxDOP = 4				
						 --,@MaxNumberOfPages=100000
						 --,@MinNumberOfPages=10000
						 ,@Execute='y'
						 ,@LogToTable='y'
						 --Commissions_Distributor_Temp
						 --,@Indexes = 'BodyLogic_Live.dbo.Commissions_Distributor_Temp'
						 --,@Indexes = 'Asea_Prod.dbo.tbl_distributor_commissions_v2.PK__tbl_dist__3214EC275D93B669'


--Actualizacion estadisticas.
EXECUTE dba.IndexOptimize
@Databases = 'Asea_Stage',
@FragmentationLow = NULL,
@FragmentationMedium = NULL,
@FragmentationHigh = NULL,
@UpdateStatistics = 'ALL',
--@MinNumberOfPages=10000,
--@OnlyModifiedStatistics = 'Y',
@StatisticsModificationLevel=50
,@Execute='n'
,@LogToTable='y'


-- Genera el alter index reorganize
SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName, 
ind.name AS IndexName, indexstats.index_type_desc AS IndexType, 
indexstats.avg_fragmentation_in_percent,
'ALTER INDEX ' + QUOTENAME(ind.name)  + ' ON ' +QUOTENAME(object_name(ind.object_id)) + 
CASE    WHEN indexstats.avg_fragmentation_in_percent>30 THEN ' REORGANIZE ' 
        WHEN indexstats.avg_fragmentation_in_percent>=5 THEN 'REORGANIZE'
        ELSE NULL END as [SQLQuery]  -- if <5 not required, so no query needed
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats 
INNER JOIN sys.indexes ind ON ind.object_id = indexstats.object_id 
    AND ind.index_id = indexstats.index_id 
WHERE 
indexstats.avg_fragmentation_in_percent > 20
and ind.Name is not null 
ORDER BY indexstats.avg_fragmentation_in_percent DESC


------------------
  IF OBJECT_ID('tempdb..#work_to_do') IS NOT NULL 
        DROP TABLE tempdb..#work_to_do

BEGIN TRY
--BEGIN TRAN


-- Genera el alter index reorganize con cantidad de páginas y defrag.
-- Ensure a USE  statement has been executed first.

    SET NOCOUNT ON;

    DECLARE @objectid INT;
    DECLARE @indexid INT;
    DECLARE @partitioncount BIGINT;
    DECLARE @schemaname NVARCHAR(130);
    DECLARE @objectname NVARCHAR(130);
    DECLARE @indexname NVARCHAR(130);
    DECLARE @partitionnum BIGINT;
    DECLARE @partitions BIGINT;
    DECLARE @frag FLOAT;
    DECLARE @pagecount INT;
    DECLARE @command NVARCHAR(4000);

    DECLARE @page_count_minimum SMALLINT
    SET @page_count_minimum = 5000

    DECLARE @fragmentation_minimum FLOAT
    SET @fragmentation_minimum = 30.0

-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function
-- and convert object and index IDs to names.

    SELECT  object_id AS objectid ,
            index_id AS indexid ,
            partition_number AS partitionnum ,
            avg_fragmentation_in_percent AS frag ,
            page_count AS page_count
    INTO    #work_to_do
    FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL,
                                           'LIMITED')
    WHERE   avg_fragmentation_in_percent > @fragmentation_minimum
            AND index_id > 0
            AND page_count > @page_count_minimum;

IF CURSOR_STATUS('global', 'partitions') >= -1
BEGIN
 PRINT 'partitions CURSOR DELETED' ;
    CLOSE partitions
    DEALLOCATE partitions
END
-- Declare the cursor for the list of partitions to be processed.
    DECLARE partitions CURSOR LOCAL
    FOR
        SELECT  *
        FROM    #work_to_do;

-- Open the cursor.
    OPEN partitions;

-- Loop through the partitions.
    WHILE ( 1 = 1 )
        BEGIN;
            FETCH NEXT
FROM partitions
INTO @objectid, @indexid, @partitionnum, @frag, @pagecount;

            IF @@FETCH_STATUS < 0
                BREAK;

            SELECT  @objectname = QUOTENAME(o.name) ,
                    @schemaname = QUOTENAME(s.name)
            FROM    sys.objects AS o
                    JOIN sys.schemas AS s ON s.schema_id = o.schema_id
            WHERE   o.object_id = @objectid;

            SELECT  @indexname = QUOTENAME(name)
            FROM    sys.indexes
            WHERE   object_id = @objectid
                    AND index_id = @indexid;

            SELECT  @partitioncount = COUNT(*)
            FROM    sys.partitions
            WHERE   object_id = @objectid
                    AND index_id = @indexid;

            SET @command = N'ALTER INDEX ' + @indexname + N' ON '
                + @schemaname + N'.' + @objectname + N' REORGANIZE';

            IF @partitioncount > 1
                SET @command = @command + N' PARTITION='
                    + CAST(@partitionnum AS NVARCHAR(10));

            --EXEC (@command);
            print (@command); 

            PRINT N'--REORGANIZING index ' + @indexname + ' on table '
                + @objectname;
            PRINT N'  --Fragmentation: ' + CAST(@frag AS VARCHAR(15));
            PRINT N'  --Page Count:    ' + CAST(@pagecount AS VARCHAR(15));
            PRINT N' ';
        END;

-- Close and deallocate the cursor.
    CLOSE partitions;
    DEALLOCATE partitions;

-- Drop the temporary table.
    DROP TABLE #work_to_do;
--COMMIT TRAN

END TRY
BEGIN CATCH
--ROLLBACK TRAN
    PRINT 'ERROR ENCOUNTERED:' + ERROR_MESSAGE()
END CATCH
--------------------------------------------------------------------------



-- ghost rows
SELECT OBJECT_NAME(object_id) AS table_name, forwarded_record_count, avg_fragmentation_in_percent, page_count 
FROM sys.dm_db_index_physical_stats (DB_ID(), DEFAULT, DEFAULT, DEFAULT, 'DETAILED') 
WHERE index_id=0 --AND page_count < 10000 
--4:49 minutos y no terminó. CPU 100%
GO

SELECT DB_NAME() AS Database_Name
, sc.name AS Schema_Name
, o.name AS Table_Name
, o.type_desc
, i.name AS Index_Name
, i.type_desc AS Index_Type
, i.fill_factor
,'ALTER INDEX ' + '['+ i.name+'] ON ' + sc.name+ '.['+ o.name+'] REBUILD PARTITION = ALL WITH (online=on,FILLFACTOR = 100)'
FROM sys.indexes i
INNER JOIN sys.objects o ON i.object_id = o.object_id
INNER JOIN sys.schemas sc ON o.schema_id = sc.schema_id
WHERE i.name IS NOT NULL
AND o.type = 'U'and fill_factor<>100 
ORDER BY i.fill_factor DESC, o.name


--Statistics:
--Set the thresholds when to consider the statistics outdated
DECLARE @hours int
DECLARE @modified_rows int
DECLARE @update_statement nvarchar(300);

SET @hours=24
SET @modified_rows=1000

--Update all the outdated statistics
DECLARE statistics_cursor CURSOR FOR
SELECT 'UPDATE STATISTICS ['+OBJECT_NAME(id)+'] [' + name + '] WITH FULLSCAN'

FROM sys.sysindexes
WHERE STATS_DATE(id, indid)<=DATEADD(HOUR,-@hours,GETDATE()) 
AND rowmodctr>=@modified_rows AND dpages > 500 and dpages < 1000
AND id IN (SELECT object_id FROM sys.tables)
 
OPEN statistics_cursor;
FETCH NEXT FROM statistics_cursor INTO @update_statement;
 
 WHILE (@@FETCH_STATUS <> -1)
 BEGIN
  --EXECUTE (@update_statement);
  PRINT @update_statement;
 
 FETCH NEXT FROM statistics_cursor INTO @update_statement;
 END;
 
 PRINT 'The outdated statistics have been updated.';
CLOSE statistics_cursor;
DEALLOCATE statistics_cursor;
GO