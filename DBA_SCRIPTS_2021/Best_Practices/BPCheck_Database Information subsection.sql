-- Building DB list
DECLARE @curdbname NVARCHAR(1000), @curdbid int, @currole tinyint, @cursecondary_role_allow_connections tinyint, @state tinyint

IF EXISTS (SELECT [object_id] FROM tempdb.sys.objects (NOLOCK) WHERE [object_id] = OBJECT_ID('tempdb.dbo.#tmpdbs0'))
DROP TABLE #tmpdbs0;
IF NOT EXISTS (SELECT [object_id] FROM tempdb.sys.objects (NOLOCK) WHERE [object_id] = OBJECT_ID('tempdb.dbo.#tmpdbs0'))
CREATE TABLE #tmpdbs0 (id int IDENTITY(1,1), [dbid] int, [dbname] NVARCHAR(1000), [compatibility_level] tinyint, is_read_only bit, [state] tinyint, is_distributor bit, [role] tinyint, [secondary_role_allow_connections] tinyint, is_database_joined bit, is_failover_ready bit, isdone bit);

IF EXISTS (SELECT [object_id] FROM tempdb.sys.objects (NOLOCK) WHERE [object_id] = OBJECT_ID('tempdb.dbo.#tmpdbfiledetail'))
DROP TABLE #tmpdbfiledetail;
IF NOT EXISTS (SELECT [object_id] FROM tempdb.sys.objects (NOLOCK) WHERE [object_id] = OBJECT_ID('tempdb.dbo.#tmpdbfiledetail'))
CREATE TABLE #tmpdbfiledetail([database_id] [int] NOT NULL, [file_id] int, [type_desc] NVARCHAR(60), [data_space_id] int, [name] sysname, [physical_name] NVARCHAR(260), [state_desc] NVARCHAR(60), [size] bigint, [max_size] bigint, [is_percent_growth] bit, [growth] int, [is_media_read_only] bit, [is_read_only] bit, [is_sparse] bit, [is_name_reserved] bit)

IF EXISTS (SELECT [object_id] FROM tempdb.sys.objects (NOLOCK) WHERE [object_id] = OBJECT_ID('tempdb.dbo.##tmpdbsizes'))
DROP TABLE ##tmpdbsizes;
IF NOT EXISTS (SELECT [object_id] FROM tempdb.sys.objects (NOLOCK) WHERE [object_id] = OBJECT_ID('tempdb.dbo.##tmpdbsizes'))
CREATE TABLE ##tmpdbsizes([database_id] [int] NOT NULL, [size] bigint, [type_desc] NVARCHAR(60))

-- Get DB info
DECLARE @sqlmajorver int
DECLARE @sqlcmd NVARCHAR(max), @params NVARCHAR(600)
DECLARE @dbid int, @dbname NVARCHAR(1000)
DECLARE @ErrorMessage NVARCHAR(4000)

SELECT @sqlmajorver = CONVERT(int, (@@microsoftversion / 0x1000000) & 0xff);

IF @sqlmajorver < 11
BEGIN
	SET @sqlcmd = 'SELECT database_id, name, [compatibility_level], is_read_only, [state], is_distributor, 1, 1, 0 FROM master.sys.databases (NOLOCK)'
	INSERT INTO #tmpdbs0 ([dbid], [dbname], [compatibility_level], is_read_only, [state], is_distributor, [role], [secondary_role_allow_connections], [isdone])
	EXEC sp_executesql @sqlcmd;
END;

IF @sqlmajorver > 10
BEGIN
	SET @sqlcmd = 'SELECT sd.database_id, sd.name, sd.[compatibility_level], sd.is_read_only, sd.[state], sd.is_distributor, MIN(COALESCE(ars.[role],1)) AS [role], ar.secondary_role_allow_connections, rcs.is_database_joined, rcs.is_failover_ready, 0 
	FROM master.sys.databases (NOLOCK) sd
		LEFT JOIN sys.dm_hadr_database_replica_states (NOLOCK) d ON sd.database_id = d.database_id
		LEFT JOIN sys.availability_replicas ar (NOLOCK) ON d.group_id = ar.group_id AND d.replica_id = ar.replica_id
		LEFT JOIN sys.dm_hadr_availability_replica_states (NOLOCK) ars ON d.group_id = ars.group_id AND d.replica_id = ars.replica_id
		LEFT JOIN sys.dm_hadr_database_replica_cluster_states (NOLOCK) rcs ON rcs.database_name = sd.name AND rcs.replica_id = ar.replica_id
	GROUP BY sd.database_id, sd.name, sd.is_read_only, sd.[state], sd.is_distributor, ar.secondary_role_allow_connections, sd.[compatibility_level], rcs.is_database_joined, rcs.is_failover_ready;'
	INSERT INTO #tmpdbs0 ([dbid], [dbname], [compatibility_level], is_read_only, [state], is_distributor, [role], [secondary_role_allow_connections], is_database_joined, is_failover_ready, [isdone])
	EXEC sp_executesql @sqlcmd;
END;

/* Validate if database scope is set */
IF @dbScope IS NOT NULL AND ISNUMERIC(@dbScope) <> 1 AND @dbScope NOT LIKE '%,%'
BEGIN
	RAISERROR('ERROR: Invalid parameter. Valid input consists of database IDs. If more than one ID is specified, the values must be comma separated.', 16, 42) WITH NOWAIT;
	RETURN
END;
	
IF @dbScope IS NOT NULL
BEGIN
    RAISERROR (N'Applying specific database scope list, if any', 10, 1) WITH NOWAIT
	SELECT @sqlcmd = 'DELETE FROM #tmpdbs0 WHERE [dbid] > 4 AND [dbid] NOT IN (' + REPLACE(@dbScope,' ','') + ')'
	EXEC sp_executesql @sqlcmd;
END;

/* Populate data file info*/
WHILE (SELECT COUNT(id) FROM #tmpdbs0 WHERE isdone = 0) > 0
BEGIN
	SELECT TOP 1 @curdbname = [dbname], @curdbid = [dbid], @currole = [role], @state = [state], @cursecondary_role_allow_connections = secondary_role_allow_connections FROM #tmpdbs0 WHERE isdone = 0
	IF (@currole = 2 AND @cursecondary_role_allow_connections = 0) OR @state <> 0
	BEGIN
		SET @sqlcmd = 'SELECT [database_id], [file_id], type_desc, data_space_id, name, physical_name, state_desc, size, max_size, is_percent_growth,growth, is_media_read_only, is_read_only, is_sparse, is_name_reserved
FROM sys.master_files (NOLOCK) WHERE [database_id] = ' + CONVERT(VARCHAR(10), @curdbid)
	END
	ELSE
	BEGIN
		SET @sqlcmd = 'USE ' + QUOTENAME(@curdbname) + ';
SELECT ' + CONVERT(VARCHAR(10), @curdbid) + ' AS [database_id], [file_id], type_desc, data_space_id, name, physical_name, state_desc, size, max_size, is_percent_growth,growth, is_media_read_only, is_read_only, is_sparse, is_name_reserved
FROM sys.database_files (NOLOCK)'
	END

	BEGIN TRY
		INSERT INTO #tmpdbfiledetail
		EXECUTE sp_executesql @sqlcmd
	END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
		SELECT @ErrorMessage = 'Database Information subsection - Error raised in TRY block. ' + ERROR_MESSAGE()
		RAISERROR (@ErrorMessage, 16, 1);
	END CATCH
	
	UPDATE #tmpdbs0
	SET isdone = 1
	WHERE [dbid] = @curdbid
END;

BEGIN TRY
	INSERT INTO ##tmpdbsizes([database_id], [size], [type_desc])
	SELECT [database_id], SUM([size]) AS [size], [type_desc]
	FROM #tmpdbfiledetail
	WHERE [type_desc] <> 'LOG'
	GROUP BY [database_id], [type_desc]
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
	SELECT @ErrorMessage = 'Database Information subsection - Error raised in TRY block. ' + ERROR_MESSAGE()
	RAISERROR (@ErrorMessage, 16, 1);
END CATCH

IF @sqlmajorver < 11
BEGIN
	SET @sqlcmd = N'SELECT ''Information'' AS [Category], ''Databases'' AS [Information],
	db.[name] AS [Database_Name], SUSER_SNAME(db.owner_sid) AS [Owner_Name], db.[database_id], 
	db.recovery_model_desc AS [Recovery_Model], db.create_date, db.log_reuse_wait_desc AS [Log_Reuse_Wait_Description], 
	(dbsize.[size]*8)/1024 AS [Data_Size_MB], ISNULL((dbfssize.[size]*8)/1024,0) AS [Filestream_Size_MB], 
	ls.cntr_value/1024 AS [Log_Size_MB], lu.cntr_value/1024 AS [Log_Used_MB],
	CAST(CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT)AS DECIMAL(18,2)) * 100 AS [Log_Used_pct], 
	db.[compatibility_level] AS [Compatibility_Level], db.collation_name AS [DB_Collation], 
	db.page_verify_option_desc AS [Page_Verify_Option], db.is_auto_create_stats_on, db.is_auto_update_stats_on,
	db.is_auto_update_stats_async_on, db.is_parameterization_forced, 
	db.snapshot_isolation_state_desc, db.is_read_committed_snapshot_on,
	db.is_read_only, db.is_auto_close_on, db.is_auto_shrink_on, ''NA'' AS [is_indirect_checkpoint_on], 
	db.is_trustworthy_on, db.is_db_chaining_on, db.is_parameterization_forced
FROM master.sys.databases AS db (NOLOCK)
INNER JOIN ##tmpdbsizes AS dbsize (NOLOCK) ON db.database_id = dbsize.database_id
INNER JOIN sys.dm_os_performance_counters AS lu (NOLOCK) ON db.name = lu.instance_name
INNER JOIN sys.dm_os_performance_counters AS ls (NOLOCK) ON db.name = ls.instance_name
LEFT JOIN ##tmpdbsizes AS dbfssize (NOLOCK) ON db.database_id = dbfssize.database_id AND dbfssize.[type_desc] = ''FILESTREAM''
WHERE dbsize.[type_desc] = ''ROWS''
	AND dbfssize.[type_desc] = ''FILESTREAM''
	AND lu.counter_name LIKE N''Log File(s) Used Size (KB)%'' 
	AND ls.counter_name LIKE N''Log File(s) Size (KB)%''
	AND ls.cntr_value > 0 AND ls.cntr_value > 0' + CASE WHEN @dbScope IS NOT NULL THEN CHAR(10) + ' AND db.[database_id] IN (' + REPLACE(@dbScope,' ','') + ')' ELSE '' END + '
ORDER BY [Database_Name]	
OPTION (RECOMPILE)'
END
ELSE IF @sqlmajorver = 11
BEGIN
	SET @sqlcmd = N'SELECT ''Information'' AS [Category], ''Databases'' AS [Information],
	db.[name] AS [Database_Name], SUSER_SNAME(db.owner_sid) AS [Owner_Name], db.[database_id], 
	db.recovery_model_desc AS [Recovery_Model], db.create_date, db.log_reuse_wait_desc AS [Log_Reuse_Wait_Description], 
	(dbsize.[size]*8)/1024 AS [Data_Size_MB], ISNULL((dbfssize.[size]*8)/1024,0) AS [Filestream_Size_MB], 
	ls.cntr_value/1024 AS [Log_Size_MB], lu.cntr_value/1024 AS [Log_Used_MB],
	CAST(CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT)AS DECIMAL(18,2)) * 100 AS [Log_Used_pct], 
	db.[compatibility_level] AS [Compatibility_Level], db.collation_name AS [DB_Collation], 
	db.page_verify_option_desc AS [Page_Verify_Option], db.is_auto_create_stats_on, db.is_auto_update_stats_on,
	db.is_auto_update_stats_async_on, db.is_parameterization_forced, 
	db.snapshot_isolation_state_desc, db.is_read_committed_snapshot_on,
	db.is_read_only, db.is_auto_close_on, db.is_auto_shrink_on, 
	CASE WHEN db.target_recovery_time_in_seconds > 0 THEN 1 ELSE 0 END AS is_indirect_checkpoint_on,
	db.target_recovery_time_in_seconds, db.is_encrypted, db.is_trustworthy_on, db.is_db_chaining_on, db.is_parameterization_forced
FROM master.sys.databases AS db (NOLOCK)
INNER JOIN ##tmpdbsizes AS dbsize (NOLOCK) ON db.database_id = dbsize.database_id
INNER JOIN sys.dm_os_performance_counters AS lu (NOLOCK) ON db.name = lu.instance_name
INNER JOIN sys.dm_os_performance_counters AS ls (NOLOCK) ON db.name = ls.instance_name
LEFT JOIN ##tmpdbsizes AS dbfssize (NOLOCK) ON db.database_id = dbfssize.database_id AND dbfssize.[type_desc] = ''FILESTREAM''
WHERE dbsize.[type_desc] = ''ROWS''
	AND lu.counter_name LIKE N''Log File(s) Used Size (KB)%'' 
	AND ls.counter_name LIKE N''Log File(s) Size (KB)%''
	AND ls.cntr_value > 0 AND ls.cntr_value > 0' + CASE WHEN @dbScope IS NOT NULL THEN CHAR(10) + ' AND db.[database_id] IN (' + REPLACE(@dbScope,' ','') + ')' ELSE '' END + '
ORDER BY [Database_Name]	
OPTION (RECOMPILE)'
END
ELSE IF @sqlmajorver = 12
BEGIN
	SET @sqlcmd = N'SELECT ''Information'' AS [Category], ''Databases'' AS [Information],
	db.[name] AS [Database_Name], SUSER_SNAME(db.owner_sid) AS [Owner_Name], db.[database_id], 
	db.recovery_model_desc AS [Recovery_Model], db.create_date, db.log_reuse_wait_desc AS [Log_Reuse_Wait_Description], 
	(dbsize.[size]*8)/1024 AS [Data_Size_MB], ISNULL((dbfssize.[size]*8)/1024,0) AS [Filestream_Size_MB], 
	ls.cntr_value/1024 AS [Log_Size_MB], lu.cntr_value/1024 AS [Log_Used_MB],
	CAST(CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT)AS DECIMAL(18,2)) * 100 AS [Log_Used_pct], 
	db.[compatibility_level] AS [Compatibility_Level], db.collation_name AS [DB_Collation], 
	db.page_verify_option_desc AS [Page_Verify_Option], db.is_auto_create_stats_on, db.is_auto_create_stats_incremental_on,
	db.is_auto_update_stats_on, db.is_auto_update_stats_async_on, db.delayed_durability_desc AS [delayed_durability_status], 
	db.snapshot_isolation_state_desc, db.is_read_committed_snapshot_on,
	db.is_read_only, db.is_auto_close_on, db.is_auto_shrink_on,
	CASE WHEN db.target_recovery_time_in_seconds > 0 THEN 1 ELSE 0 END AS is_indirect_checkpoint_on,
	db.target_recovery_time_in_seconds, db.is_encrypted, db.is_trustworthy_on, db.is_db_chaining_on, db.is_parameterization_forced
FROM master.sys.databases AS db (NOLOCK)
INNER JOIN ##tmpdbsizes AS dbsize (NOLOCK) ON db.database_id = dbsize.database_id
INNER JOIN sys.dm_os_performance_counters AS lu (NOLOCK) ON db.name = lu.instance_name
INNER JOIN sys.dm_os_performance_counters AS ls (NOLOCK) ON db.name = ls.instance_name
LEFT JOIN ##tmpdbsizes AS dbfssize (NOLOCK) ON db.database_id = dbfssize.database_id AND dbfssize.[type_desc] = ''FILESTREAM''
WHERE dbsize.[type_desc] = ''ROWS''
	AND lu.counter_name LIKE N''Log File(s) Used Size (KB)%'' 
	AND ls.counter_name LIKE N''Log File(s) Size (KB)%''
	AND ls.cntr_value > 0 AND ls.cntr_value > 0' + CASE WHEN @dbScope IS NOT NULL THEN CHAR(10) + ' AND db.[database_id] IN (' + REPLACE(@dbScope,' ','') + ')' ELSE '' END + '
ORDER BY [Database_Name]	
OPTION (RECOMPILE)'
END
ELSE IF @sqlmajorver >= 13
BEGIN
	SET @sqlcmd = N'SELECT ''Information'' AS [Category], ''Databases'' AS [Information],
	db.[name] AS [Database_Name], SUSER_SNAME(db.owner_sid) AS [Owner_Name], db.[database_id], 
	db.recovery_model_desc AS [Recovery_Model], db.create_date, db.log_reuse_wait_desc AS [Log_Reuse_Wait_Description], 
	(dbsize.[size]*8)/1024 AS [Data_Size_MB], ISNULL((dbfssize.[size]*8)/1024,0) AS [Filestream_Size_MB], 
	ls.cntr_value/1024 AS [Log_Size_MB], lu.cntr_value/1024 AS [Log_Used_MB],
	CAST(CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT)AS DECIMAL(18,2)) * 100 AS [Log_Used_pct], 
	db.[compatibility_level] AS [Compatibility_Level], db.collation_name AS [DB_Collation], 
	db.page_verify_option_desc AS [Page_Verify_Option], db.is_auto_create_stats_on, db.is_auto_create_stats_incremental_on,
	db.is_auto_update_stats_on, db.is_auto_update_stats_async_on, db.delayed_durability_desc AS [delayed_durability_status], 
	db.is_query_store_on, db.snapshot_isolation_state_desc, db.is_read_committed_snapshot_on,
	db.is_read_only, db.is_auto_close_on, db.is_auto_shrink_on, 
	CASE WHEN db.target_recovery_time_in_seconds > 0 THEN 1 ELSE 0 END AS is_indirect_checkpoint_on,
	db.target_recovery_time_in_seconds, db.is_encrypted, db.is_trustworthy_on, db.is_db_chaining_on, db.is_parameterization_forced, 
	db.is_memory_optimized_elevate_to_snapshot_on, db.is_remote_data_archive_enabled, db.is_mixed_page_allocation_on
FROM master.sys.databases AS db (NOLOCK)
INNER JOIN sys.dm_os_performance_counters AS lu (NOLOCK) ON db.name = lu.instance_name
INNER JOIN sys.dm_os_performance_counters AS ls (NOLOCK) ON db.name = ls.instance_name
INNER JOIN ##tmpdbsizes AS dbsize (NOLOCK) ON db.database_id = dbsize.database_id
LEFT JOIN ##tmpdbsizes AS dbfssize (NOLOCK) ON db.database_id = dbfssize.database_id AND dbfssize.[type_desc] = ''FILESTREAM''
WHERE dbsize.[type_desc] = ''ROWS''
	AND lu.counter_name LIKE N''Log File(s) Used Size (KB)%'' 
	AND ls.counter_name LIKE N''Log File(s) Size (KB)%''
	AND ls.cntr_value > 0 AND ls.cntr_value > 0' + CASE WHEN @dbScope IS NOT NULL THEN CHAR(10) + ' AND db.[database_id] IN (' + REPLACE(@dbScope,' ','') + ')' ELSE '' END + '
ORDER BY [Database_Name]	
OPTION (RECOMPILE)'
END
ELSE IF @sqlmajorver >= 14
BEGIN
	SET @sqlcmd = N'SELECT ''Information'' AS [Category], ''Databases'' AS [Information],
	db.[name] AS [Database_Name], SUSER_SNAME(db.owner_sid) AS [Owner_Name], db.[database_id], 
	db.recovery_model_desc AS [Recovery_Model], db.create_date, db.log_reuse_wait_desc AS [Log_Reuse_Wait_Description], 
	(dbsize.[size]*8)/1024 AS [Data_Size_MB], ISNULL((dbfssize.[size]*8)/1024,0) AS [Filestream_Size_MB], 
	ls.cntr_value/1024 AS [Log_Size_MB], lu.cntr_value/1024 AS [Log_Used_MB],
	CAST(CAST(lu.cntr_value AS FLOAT) / CAST(ls.cntr_value AS FLOAT)AS DECIMAL(18,2)) * 100 AS [Log_Used_pct],
	CASE WHEN ssu.reserved_space_kb>0 THEN ssu.reserved_space_kb/1024 ELSE 0 END AS [Version_Store_Size_MB],
	db.[compatibility_level] AS [Compatibility_Level], db.collation_name AS [DB_Collation], 
	db.page_verify_option_desc AS [Page_Verify_Option], db.is_auto_create_stats_on, db.is_auto_create_stats_incremental_on,
	db.is_auto_update_stats_on, db.is_auto_update_stats_async_on, db.delayed_durability_desc AS [delayed_durability_status], 
	db.is_query_store_on, db.snapshot_isolation_state_desc, db.is_read_committed_snapshot_on,
	db.is_read_only, db.is_auto_close_on, db.is_auto_shrink_on, 
	CASE WHEN db.target_recovery_time_in_seconds > 0 THEN 1 ELSE 0 END AS is_indirect_checkpoint_on,
	db.target_recovery_time_in_seconds, db.is_encrypted, db.is_trustworthy_on, db.is_db_chaining_on, db.is_parameterization_forced, 
	db.is_memory_optimized_elevate_to_snapshot_on, db.is_remote_data_archive_enabled, db.is_mixed_page_allocation_on
FROM master.sys.databases AS db (NOLOCK)
INNER JOIN ##tmpdbsizes AS dbsize (NOLOCK) ON db.database_id = dbsize.database_id
INNER JOIN sys.dm_os_performance_counters AS lu (NOLOCK) ON db.name = lu.instance_name
INNER JOIN sys.dm_os_performance_counters AS ls (NOLOCK) ON db.name = ls.instance_name
LEFT JOIN ##tmpdbsizes AS dbfssize (NOLOCK) ON db.database_id = dbfssize.database_id AND dbfssize.[type_desc] = ''FILESTREAM''
LEFT JOIN sys.dm_tran_version_store_space_usage AS ssu (NOLOCK) ON db.database_id = ssu.database_id
WHERE dbsize.[type_desc] = ''ROWS''
	AND lu.counter_name LIKE N''Log File(s) Used Size (KB)%'' 
	AND ls.counter_name LIKE N''Log File(s) Size (KB)%''
	AND ls.cntr_value > 0 AND ls.cntr_value > 0' + CASE WHEN @dbScope IS NOT NULL THEN CHAR(10) + ' AND db.[database_id] IN (' + REPLACE(@dbScope,' ','') + ')' ELSE '' END + '
ORDER BY [Database_Name]	
OPTION (RECOMPILE)'
END

EXECUTE sp_executesql @sqlcmd;
	
SELECT 'Information' AS [Category], 'Database_Files' AS [Information], DB_NAME(database_id) AS [Database_Name], [file_id], type_desc, data_space_id AS [Filegroup], name, physical_name,
	state_desc, (size * 8) / 1024 AS size_MB, CASE max_size WHEN -1 THEN 'Unlimited' ELSE CONVERT(VARCHAR(10), max_size) END AS max_size,
	CASE WHEN is_percent_growth = 0 THEN CONVERT(VARCHAR(10),((growth * 8) / 1024)) ELSE growth END AS [growth], CASE WHEN is_percent_growth = 1 THEN 'Pct' ELSE 'MB' END AS growth_type,
	is_media_read_only, is_read_only, is_sparse, is_name_reserved
FROM #tmpdbfiledetail
ORDER BY database_id, [file_id];

IF @sqlmajorver >= 12
BEGIN
	IF EXISTS (SELECT [object_id] FROM tempdb.sys.objects (NOLOCK) WHERE [object_id] = OBJECT_ID('tempdb.dbo.#tblInMemDBs'))
	DROP TABLE #tblInMemDBs;
	IF NOT EXISTS (SELECT [object_id] FROM tempdb.sys.objects (NOLOCK) WHERE [object_id] = OBJECT_ID('tempdb.dbo.#tblInMemDBs'))
	CREATE TABLE #tblInMemDBs ([DBName] sysname, [Has_MemoryOptimizedObjects] bit, [MemoryAllocated_MemoryOptimizedObjects_KB] DECIMAL(18,2), [MemoryUsed_MemoryOptimizedObjects_KB] DECIMAL(18,2));
	
	UPDATE #tmpdbs0
	SET isdone = 0;

	UPDATE #tmpdbs0
	SET isdone = 1
	WHERE [state] <> 0 OR [dbid] < 5;

	UPDATE #tmpdbs0
	SET isdone = 1
	WHERE [role] = 2 AND secondary_role_allow_connections = 0;
	
	IF (SELECT COUNT(id) FROM #tmpdbs0 WHERE isdone = 0) > 0
	BEGIN
		RAISERROR (N'Starting Storage analysis for In-Memory OLTP Engine', 10, 1) WITH NOWAIT
	
		WHILE (SELECT COUNT(id) FROM #tmpdbs0 WHERE isdone = 0) > 0
		BEGIN
			SELECT TOP 1 @dbname = [dbname], @dbid = [dbid] FROM #tmpdbs0 WHERE isdone = 0
			
			SET @sqlcmd = 'USE ' + QUOTENAME(@dbname) + ';
SELECT ''' + REPLACE(@dbname, CHAR(39), CHAR(95)) + ''' AS [DBName], ISNULL((SELECT 1 FROM sys.filegroups FG WHERE FG.[type] = ''FX''), 0) AS [Has_MemoryOptimizedObjects],
ISNULL((SELECT CONVERT(DECIMAL(18,2), (SUM(tms.memory_allocated_for_table_kb) + SUM(tms.memory_allocated_for_indexes_kb))) FROM sys.dm_db_xtp_table_memory_stats tms), 0.00) AS [MemoryAllocated_MemoryOptimizedObjects_KB],
ISNULL((SELECT CONVERT(DECIMAL(18,2),(SUM(tms.memory_used_by_table_kb) + SUM(tms.memory_used_by_indexes_kb))) FROM sys.dm_db_xtp_table_memory_stats tms), 0.00) AS [MemoryUsed_MemoryOptimizedObjects_KB];'

			BEGIN TRY
				INSERT INTO #tblInMemDBs
				EXECUTE sp_executesql @sqlcmd
			END TRY
			BEGIN CATCH
				SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
				SELECT @ErrorMessage = 'Storage analysis for In-Memory OLTP Engine subsection - Error raised in TRY block. ' + ERROR_MESSAGE()
				RAISERROR (@ErrorMessage, 16, 1);
			END CATCH
			
			UPDATE #tmpdbs0
			SET isdone = 1
			WHERE [dbid] = @dbid
		END
	END;

	IF (SELECT COUNT([DBName]) FROM #tblInMemDBs WHERE [Has_MemoryOptimizedObjects] = 1) > 0
	BEGIN
		SELECT 'Information' AS [Category], 'InMem_Database_Storage' AS [Information], DBName AS [Database_Name],
			[MemoryAllocated_MemoryOptimizedObjects_KB], [MemoryUsed_MemoryOptimizedObjects_KB]
		FROM #tblInMemDBs WHERE Has_MemoryOptimizedObjects = 1
		ORDER BY DBName;
	END
	ELSE
	BEGIN
		SELECT 'Information' AS [Category], 'InMem_Database_Storage' AS [Information], 'NA' AS [Comment]
	END
END;

-- http://support.microsoft.com/kb/2857849
DECLARE @IsHadrEnabled tinyint

SELECT @IsHadrEnabled = CONVERT(tinyint, SERVERPROPERTY('IsHadrEnabled'))

IF @sqlmajorver > 10 AND @IsHadrEnabled = 1
BEGIN
	SELECT 'Information' AS [Category], 'AlwaysOn_AG_Databases' AS [Information], dc.database_name AS [Database_Name],
		d.synchronization_health_desc, d.synchronization_state_desc, d.database_state_desc
	FROM sys.dm_hadr_database_replica_states d
	INNER JOIN sys.availability_databases_cluster dc ON d.group_database_id=dc.group_database_id
	WHERE d.is_local=1
END;