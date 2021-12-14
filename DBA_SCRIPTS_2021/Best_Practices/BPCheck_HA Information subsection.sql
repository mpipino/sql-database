SET NOCOUNT ON;
SET ANSI_WARNINGS ON;
SET QUOTED_IDENTIFIER ON;

DECLARE @sqlcmd NVARCHAR(max), @params NVARCHAR(600)
DECLARE @sqlmajorver int, @sqlminorver int, @sqlbuild int, @clustered bit
DECLARE @ptochecks bit

SET @ptochecks = 1 --(1 = ON; 0 = OFF)

SELECT @sqlmajorver = CONVERT(int, (@@microsoftversion / 0x1000000) & 0xff);
SELECT @sqlminorver = CONVERT(int, (@@microsoftversion / 0x10000) & 0xff);
SELECT @sqlbuild = CONVERT(int, @@microsoftversion & 0xffff);
SELECT @clustered = CONVERT(bit,ISNULL(SERVERPROPERTY('IsClustered'),0))

IF @clustered = 1
BEGIN
	IF @sqlmajorver < 11
		BEGIN
			EXEC ('SELECT ''Information'' AS [Category], ''Cluster'' AS [Information], NodeName AS node_name FROM sys.dm_os_cluster_nodes (NOLOCK)')
		END
	ELSE
		BEGIN
			EXEC ('SELECT ''Information'' AS [Category], ''Cluster'' AS [Information], NodeName AS node_name, status_description, is_current_owner FROM sys.dm_os_cluster_nodes (NOLOCK)')
		END
	SELECT 'Information' AS [Category], 'Cluster' AS [Information], DriveName AS cluster_shared_drives FROM sys.dm_io_cluster_shared_drives (NOLOCK)
END
ELSE
BEGIN
	SELECT 'Information' AS [Category], 'Cluster' AS [Information], 'NOT_CLUSTERED' AS [Status]
END;

IF @sqlmajorver > 10
BEGIN
	DECLARE @IsHadrEnabled tinyint, @HadrManagerStatus tinyint
	SELECT @IsHadrEnabled = CASE WHEN SERVERPROPERTY('EngineEdition') = 8 THEN 1 ELSE CONVERT(tinyint, SERVERPROPERTY('IsHadrEnabled')) END;
	SELECT @HadrManagerStatus = CASE WHEN SERVERPROPERTY('EngineEdition') = 8 THEN 1 ELSE CONVERT(tinyint, SERVERPROPERTY('HadrManagerStatus')) END;
	
	SELECT 'Information' AS [Category], 'AlwaysOn_AG' AS [Information], 
		CASE @IsHadrEnabled WHEN 0 THEN 'Disabled'
			WHEN 1 THEN 'Enabled' END AS [AlwaysOn_Availability_Groups],
		CASE WHEN @IsHadrEnabled = 1 THEN
			CASE @HadrManagerStatus WHEN 0 THEN '[Not started, pending communication]'
				WHEN 1 THEN '[Started and running]'
				WHEN 2 THEN '[Not started and failed]'
			END
		END AS [Status];
	
	IF @IsHadrEnabled = 1
	BEGIN	
		IF EXISTS (SELECT 1 FROM sys.dm_hadr_cluster) 
		SELECT 'Information' AS [Category], 'AlwaysOn_Cluster' AS [Information], cluster_name, quorum_type_desc, quorum_state_desc 
		FROM sys.dm_hadr_cluster;

		IF EXISTS (SELECT 1 FROM sys.dm_hadr_cluster_members) 
		SELECT 'Information' AS [Category], 'AlwaysOn_Cluster_Members' AS [Information], member_name, member_type_desc, member_state_desc, number_of_quorum_votes 
		FROM sys.dm_hadr_cluster_members;
		
		IF EXISTS (SELECT 1 FROM sys.dm_hadr_cluster_networks) 
		SELECT 'Information' AS [Category], 'AlwaysOn_Cluster_Networks' AS [Information], member_name, network_subnet_ip, network_subnet_ipv4_mask, is_public, is_ipv4 
		FROM sys.dm_hadr_cluster_networks;
	END;
	
	IF @ptochecks = 1 AND @IsHadrEnabled = 1
	BEGIN
		-- Note: If low_water_mark_for_ghosts number is not increasing over time, it implies that ghost cleanup might not happen.
		SET @sqlcmd = 'SELECT ''Information'' AS [Category], ''AlwaysOn_Replicas'' AS [Information], database_id, group_id, replica_id, group_database_id, is_local, synchronization_state_desc, 
	is_commit_participant, synchronization_health_desc, database_state_desc, is_suspended, suspend_reason_desc, last_sent_time, last_received_time, last_hardened_time, 
	last_redone_time, log_send_queue_size, log_send_rate, redo_queue_size, redo_rate, filestream_send_rate, last_commit_time, 
	low_water_mark_for_ghosts' + CASE WHEN @sqlmajorver > 12 THEN ', secondary_lag_seconds' ELSE '' END + ' 
FROM sys.dm_hadr_database_replica_states'
		EXECUTE sp_executesql @sqlcmd

		SELECT 'Information' AS [Category], 'AlwaysOn_Replica_Cluster' AS [Information], replica_id, group_database_id, database_name, is_failover_ready, is_pending_secondary_suspend, 
			is_database_joined, recovery_lsn, truncation_lsn 
		FROM sys.dm_hadr_database_replica_cluster_states;
	END
END;