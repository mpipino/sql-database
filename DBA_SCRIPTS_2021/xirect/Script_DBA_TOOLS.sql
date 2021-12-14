--Script to Live

CREATE SCHEMA [dba]
GO

/****** Object:  StoredProcedure [dba].[CommandExecute]    Script Date: 2/24/2021 6:47:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dba].[CommandExecute]

@DatabaseContext nvarchar(max),
@Command nvarchar(max),
@CommandType nvarchar(max),
@Mode int,
@Comment nvarchar(max) = NULL,
@DatabaseName nvarchar(max) = NULL,
@SchemaName nvarchar(max) = NULL,
@ObjectName nvarchar(max) = NULL,
@ObjectType nvarchar(max) = NULL,
@IndexName nvarchar(max) = NULL,
@IndexType int = NULL,
@StatisticsName nvarchar(max) = NULL,
@PartitionNumber int = NULL,
@ExtendedInfo xml = NULL,
@LockMessageSeverity int = 16,
@ExecuteAsUser nvarchar(max) = NULL,
@LogToTable nvarchar(max),
@Execute nvarchar(max)

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source:  https://ola.hallengren.com                                                        //--
  --// License: https://ola.hallengren.com/license.html                                           //--
  --// GitHub:  https://github.com/olahallengren/sql-server-maintenance-solution                  //--
  --// Version: 2020-12-31 18:58:56                                                               //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)
  DECLARE @ErrorMessageOriginal nvarchar(max)
  DECLARE @Severity int

  DECLARE @Errors TABLE (ID int IDENTITY PRIMARY KEY,
                         [Message] nvarchar(max) NOT NULL,
                         Severity int NOT NULL,
                         [State] int)

  DECLARE @CurrentMessage nvarchar(max)
  DECLARE @CurrentSeverity int
  DECLARE @CurrentState int

  DECLARE @sp_executesql nvarchar(max) = QUOTENAME(@DatabaseContext) + '.sys.sp_executesql'

  DECLARE @StartTime datetime2
  DECLARE @EndTime datetime2

  DECLARE @ID int

  DECLARE @Error int = 0
  DECLARE @ReturnCode int = 0

  DECLARE @EmptyLine nvarchar(max) = CHAR(9)

  DECLARE @RevertCommand nvarchar(max)

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF NOT (SELECT [compatibility_level] FROM sys.databases WHERE database_id = DB_ID()) >= 90
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The database ' + QUOTENAME(DB_NAME(DB_ID())) + ' has to be in compatibility level 90 or higher.', 16, 1
  END

  IF NOT (SELECT uses_ansi_nulls FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'ANSI_NULLS has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT (SELECT uses_quoted_identifier FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'QUOTED_IDENTIFIER has to be set to ON for the stored procedure.', 16, 1
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dbo' AND objects.[name] = 'CommandLog')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabaseContext IS NULL OR NOT EXISTS (SELECT * FROM sys.databases WHERE name = @DatabaseContext)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseContext is not supported.', 16, 1
  END

  IF @Command IS NULL OR @Command = ''
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Command is not supported.', 16, 1
  END

  IF @CommandType IS NULL OR @CommandType = '' OR LEN(@CommandType) > 60
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @CommandType is not supported.', 16, 1
  END

  IF @Mode NOT IN(1,2) OR @Mode IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Mode is not supported.', 16, 1
  END

  IF @LockMessageSeverity NOT IN(10,16) OR @LockMessageSeverity IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LockMessageSeverity is not supported.', 16, 1
  END

  IF LEN(@ExecuteAsUser) > 128
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ExecuteAsUser is not supported.', 16, 1
  END

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LogToTable is not supported.', 16, 1
  END

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Execute is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Raise errors                                                                               //--
  ----------------------------------------------------------------------------------------------------

  DECLARE ErrorCursor CURSOR FAST_FORWARD FOR SELECT [Message], Severity, [State] FROM @Errors ORDER BY [ID] ASC

  OPEN ErrorCursor

  FETCH ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState

  WHILE @@FETCH_STATUS = 0
  BEGIN
    RAISERROR('%s', @CurrentSeverity, @CurrentState, @CurrentMessage) WITH NOWAIT
    RAISERROR(@EmptyLine, 10, 1) WITH NOWAIT

    FETCH NEXT FROM ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState
  END

  CLOSE ErrorCursor

  DEALLOCATE ErrorCursor

  IF EXISTS (SELECT * FROM @Errors WHERE Severity >= 16)
  BEGIN
    SET @ReturnCode = 50000
    GOTO ReturnCode
  END

  ----------------------------------------------------------------------------------------------------
  --// Execute as user                                                                            //--
  ----------------------------------------------------------------------------------------------------

  IF @ExecuteAsUser IS NOT NULL
  BEGIN
    SET @Command = 'EXECUTE AS USER = ''' + REPLACE(@ExecuteAsUser,'''','''''') + '''; ' + @Command + '; REVERT;'

    SET @RevertCommand = 'REVERT'
  END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @StartTime = SYSDATETIME()

  SET @StartMessage = 'Date and time: ' + CONVERT(nvarchar,@StartTime,120)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Database context: ' + QUOTENAME(@DatabaseContext)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Command: ' + @Command
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  IF @Comment IS NOT NULL
  BEGIN
    SET @StartMessage = 'Comment: ' + @Comment
    RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT
  END

  IF @LogToTable = 'Y'
  BEGIN
    INSERT INTO dbo.CommandLog (DatabaseName, SchemaName, ObjectName, ObjectType, IndexName, IndexType, StatisticsName, PartitionNumber, ExtendedInfo, CommandType, Command, StartTime)
    VALUES (@DatabaseName, @SchemaName, @ObjectName, @ObjectType, @IndexName, @IndexType, @StatisticsName, @PartitionNumber, @ExtendedInfo, @CommandType, @Command, @StartTime)
  END

  SET @ID = SCOPE_IDENTITY()

  ----------------------------------------------------------------------------------------------------
  --// Execute command                                                                            //--
  ----------------------------------------------------------------------------------------------------

  IF @Mode = 1 AND @Execute = 'Y'
  BEGIN
    EXECUTE @sp_executesql @stmt = @Command
    SET @Error = @@ERROR
    SET @ReturnCode = @Error
  END

  IF @Mode = 2 AND @Execute = 'Y'
  BEGIN
    BEGIN TRY
      EXECUTE @sp_executesql @stmt = @Command
    END TRY
    BEGIN CATCH
      SET @Error = ERROR_NUMBER()
      SET @ErrorMessageOriginal = ERROR_MESSAGE()

      SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'')
      SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
      RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT

      IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
      BEGIN
        SET @ReturnCode = ERROR_NUMBER()
      END

      IF @ExecuteAsUser IS NOT NULL
      BEGIN
        EXECUTE @sp_executesql @RevertCommand
      END
    END CATCH
  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  SET @EndTime = SYSDATETIME()

  SET @EndMessage = 'Outcome: ' + CASE WHEN @Execute = 'N' THEN 'Not Executed' WHEN @Error = 0 THEN 'Succeeded' ELSE 'Failed' END
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  SET @EndMessage = 'Duration: ' + CASE WHEN (DATEDIFF(SECOND,@StartTime,@EndTime) / (24 * 3600)) > 0 THEN CAST((DATEDIFF(SECOND,@StartTime,@EndTime) / (24 * 3600)) AS nvarchar) + '.' ELSE '' END + CONVERT(nvarchar,DATEADD(SECOND,DATEDIFF(SECOND,@StartTime,@EndTime),'1900-01-01'),108)
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  SET @EndMessage = 'Date and time: ' + CONVERT(nvarchar,@EndTime,120)
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  IF @LogToTable = 'Y'
  BEGIN
    UPDATE dbo.CommandLog
    SET EndTime = @EndTime,
        ErrorNumber = CASE WHEN @Execute = 'N' THEN NULL ELSE @Error END,
        ErrorMessage = @ErrorMessageOriginal
    WHERE ID = @ID
  END

  ReturnCode:
  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END
GO

/****** Object:  StoredProcedure [dba].[IndexOptimize]    Script Date: 2/24/2021 6:48:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dba].[IndexOptimize]

@Databases nvarchar(max) = NULL,
@FragmentationLow nvarchar(max) = NULL,
@FragmentationMedium nvarchar(max) = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationHigh nvarchar(max) = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
@FragmentationLevel1 int = 5,
@FragmentationLevel2 int = 30,
@MinNumberOfPages int = 1000,
@MaxNumberOfPages int = NULL,
@SortInTempdb nvarchar(max) = 'N',
@MaxDOP int = NULL,
@FillFactor int = NULL,
@PadIndex nvarchar(max) = NULL,
@LOBCompaction nvarchar(max) = 'Y',
@UpdateStatistics nvarchar(max) = NULL,
@OnlyModifiedStatistics nvarchar(max) = 'N',
@StatisticsModificationLevel int = NULL,
@StatisticsSample int = NULL,
@StatisticsResample nvarchar(max) = 'N',
@PartitionLevel nvarchar(max) = 'Y',
@MSShippedObjects nvarchar(max) = 'N',
@Indexes nvarchar(max) = NULL,
@TimeLimit int = NULL,
@Delay int = NULL,
@WaitAtLowPriorityMaxDuration int = NULL,
@WaitAtLowPriorityAbortAfterWait nvarchar(max) = NULL,
@Resumable nvarchar(max) = 'N',
@AvailabilityGroups nvarchar(max) = NULL,
@LockTimeout int = NULL,
@LockMessageSeverity int = 16,
@StringDelimiter nvarchar(max) = ',',
@DatabaseOrder nvarchar(max) = NULL,
@DatabasesInParallel nvarchar(max) = 'N',
@ExecuteAsUser nvarchar(max) = NULL,
@LogToTable nvarchar(max) = 'N',
@Execute nvarchar(max) = 'Y'

AS

BEGIN

  ----------------------------------------------------------------------------------------------------
  --// Source:  https://ola.hallengren.com                                                        //--
  --// License: https://ola.hallengren.com/license.html                                           //--
  --// GitHub:  https://github.com/olahallengren/sql-server-maintenance-solution                  //--
  --// Version: 2020-12-31 18:58:56                                                               //--
  ----------------------------------------------------------------------------------------------------

  SET NOCOUNT ON

  SET ARITHABORT ON

  SET NUMERIC_ROUNDABORT OFF

  DECLARE @StartMessage nvarchar(max)
  DECLARE @EndMessage nvarchar(max)
  DECLARE @DatabaseMessage nvarchar(max)
  DECLARE @ErrorMessage nvarchar(max)
  DECLARE @Severity int

  DECLARE @StartTime datetime2 = SYSDATETIME()
  DECLARE @SchemaName nvarchar(max) = OBJECT_SCHEMA_NAME(@@PROCID)
  DECLARE @ObjectName nvarchar(max) = OBJECT_NAME(@@PROCID)
  DECLARE @VersionTimestamp nvarchar(max) = SUBSTRING(OBJECT_DEFINITION(@@PROCID),CHARINDEX('--// Version: ',OBJECT_DEFINITION(@@PROCID)) + LEN('--// Version: ') + 1, 19)
  DECLARE @Parameters nvarchar(max)

  DECLARE @HostPlatform nvarchar(max)

  DECLARE @PartitionLevelStatistics bit

  DECLARE @QueueID int
  DECLARE @QueueStartTime datetime2

  DECLARE @CurrentDBID int
  DECLARE @CurrentDatabaseName nvarchar(max)

  DECLARE @CurrentDatabase_sp_executesql nvarchar(max)

  DECLARE @CurrentExecuteAsUserExists bit
  DECLARE @CurrentUserAccess nvarchar(max)
  DECLARE @CurrentIsReadOnly bit
  DECLARE @CurrentDatabaseState nvarchar(max)
  DECLARE @CurrentInStandby bit
  DECLARE @CurrentRecoveryModel nvarchar(max)

  DECLARE @CurrentIsDatabaseAccessible bit
  DECLARE @CurrentReplicaID uniqueidentifier
  DECLARE @CurrentAvailabilityGroupID uniqueidentifier
  DECLARE @CurrentAvailabilityGroup nvarchar(max)
  DECLARE @CurrentAvailabilityGroupRole nvarchar(max)
  DECLARE @CurrentDatabaseMirroringRole nvarchar(max)

  DECLARE @CurrentDatabaseContext nvarchar(max)
  DECLARE @CurrentCommand nvarchar(max)
  DECLARE @CurrentCommandOutput int
  DECLARE @CurrentCommandType nvarchar(max)
  DECLARE @CurrentComment nvarchar(max)
  DECLARE @CurrentExtendedInfo xml

  DECLARE @Errors TABLE (ID int IDENTITY PRIMARY KEY,
                         [Message] nvarchar(max) NOT NULL,
                         Severity int NOT NULL,
                         [State] int)

  DECLARE @CurrentMessage nvarchar(max)
  DECLARE @CurrentSeverity int
  DECLARE @CurrentState int

  DECLARE @CurrentIxID int
  DECLARE @CurrentIxOrder int
  DECLARE @CurrentSchemaID int
  DECLARE @CurrentSchemaName nvarchar(max)
  DECLARE @CurrentObjectID int
  DECLARE @CurrentObjectName nvarchar(max)
  DECLARE @CurrentObjectType nvarchar(max)
  DECLARE @CurrentIsMemoryOptimized bit
  DECLARE @CurrentIndexID int
  DECLARE @CurrentIndexName nvarchar(max)
  DECLARE @CurrentIndexType int
  DECLARE @CurrentStatisticsID int
  DECLARE @CurrentStatisticsName nvarchar(max)
  DECLARE @CurrentPartitionID bigint
  DECLARE @CurrentPartitionNumber int
  DECLARE @CurrentPartitionCount int
  DECLARE @CurrentIsPartition bit
  DECLARE @CurrentIndexExists bit
  DECLARE @CurrentStatisticsExists bit
  DECLARE @CurrentIsImageText bit
  DECLARE @CurrentIsNewLOB bit
  DECLARE @CurrentIsFileStream bit
  DECLARE @CurrentIsColumnStore bit
  DECLARE @CurrentIsComputed bit
  DECLARE @CurrentIsTimestamp bit
  DECLARE @CurrentAllowPageLocks bit
  DECLARE @CurrentNoRecompute bit
  DECLARE @CurrentIsIncremental bit
  DECLARE @CurrentRowCount bigint
  DECLARE @CurrentModificationCounter bigint
  DECLARE @CurrentOnReadOnlyFileGroup bit
  DECLARE @CurrentResumableIndexOperation bit
  DECLARE @CurrentFragmentationLevel float
  DECLARE @CurrentPageCount bigint
  DECLARE @CurrentFragmentationGroup nvarchar(max)
  DECLARE @CurrentAction nvarchar(max)
  DECLARE @CurrentMaxDOP int
  DECLARE @CurrentUpdateStatistics nvarchar(max)
  DECLARE @CurrentStatisticsSample int
  DECLARE @CurrentStatisticsResample nvarchar(max)
  DECLARE @CurrentDelay datetime

  DECLARE @tmpDatabases TABLE (ID int IDENTITY,
                               DatabaseName nvarchar(max),
                               DatabaseType nvarchar(max),
                               AvailabilityGroup bit,
                               StartPosition int,
                               DatabaseSize bigint,
                               [Order] int,
                               Selected bit,
                               Completed bit,
                               PRIMARY KEY(Selected, Completed, [Order], ID))

  DECLARE @tmpAvailabilityGroups TABLE (ID int IDENTITY PRIMARY KEY,
                                        AvailabilityGroupName nvarchar(max),
                                        StartPosition int,
                                        Selected bit)

  DECLARE @tmpDatabasesAvailabilityGroups TABLE (DatabaseName nvarchar(max),
                                                 AvailabilityGroupName nvarchar(max))

  DECLARE @tmpIndexesStatistics TABLE (ID int IDENTITY,
                                       SchemaID int,
                                       SchemaName nvarchar(max),
                                       ObjectID int,
                                       ObjectName nvarchar(max),
                                       ObjectType nvarchar(max),
                                       IsMemoryOptimized bit,
                                       IndexID int,
                                       IndexName nvarchar(max),
                                       IndexType int,
                                       AllowPageLocks bit,
                                       IsImageText bit,
                                       IsNewLOB bit,
                                       IsFileStream bit,
                                       IsColumnStore bit,
                                       IsComputed bit,
                                       IsTimestamp bit,
                                       OnReadOnlyFileGroup bit,
                                       ResumableIndexOperation bit,
                                       StatisticsID int,
                                       StatisticsName nvarchar(max),
                                       [NoRecompute] bit,
                                       IsIncremental bit,
                                       PartitionID bigint,
                                       PartitionNumber int,
                                       PartitionCount int,
                                       StartPosition int,
                                       [Order] int,
                                       Selected bit,
                                       Completed bit,
                                       PRIMARY KEY(Selected, Completed, [Order], ID))

  DECLARE @SelectedDatabases TABLE (DatabaseName nvarchar(max),
                                    DatabaseType nvarchar(max),
                                    AvailabilityGroup nvarchar(max),
                                    StartPosition int,
                                    Selected bit)

  DECLARE @SelectedAvailabilityGroups TABLE (AvailabilityGroupName nvarchar(max),
                                             StartPosition int,
                                             Selected bit)

  DECLARE @SelectedIndexes TABLE (DatabaseName nvarchar(max),
                                  SchemaName nvarchar(max),
                                  ObjectName nvarchar(max),
                                  IndexName nvarchar(max),
                                  StartPosition int,
                                  Selected bit)

  DECLARE @Actions TABLE ([Action] nvarchar(max))

  INSERT INTO @Actions([Action]) VALUES('INDEX_REBUILD_ONLINE')
  INSERT INTO @Actions([Action]) VALUES('INDEX_REBUILD_OFFLINE')
  INSERT INTO @Actions([Action]) VALUES('INDEX_REORGANIZE')

  DECLARE @ActionsPreferred TABLE (FragmentationGroup nvarchar(max),
                                   [Priority] int,
                                   [Action] nvarchar(max))

  DECLARE @CurrentActionsAllowed TABLE ([Action] nvarchar(max))

  DECLARE @CurrentAlterIndexWithClauseArguments TABLE (ID int IDENTITY,
                                                       Argument nvarchar(max),
                                                       Added bit DEFAULT 0)

  DECLARE @CurrentAlterIndexArgumentID int
  DECLARE @CurrentAlterIndexArgument nvarchar(max)
  DECLARE @CurrentAlterIndexWithClause nvarchar(max)

  DECLARE @CurrentUpdateStatisticsWithClauseArguments TABLE (ID int IDENTITY,
                                                             Argument nvarchar(max),
                                                             Added bit DEFAULT 0)

  DECLARE @CurrentUpdateStatisticsArgumentID int
  DECLARE @CurrentUpdateStatisticsArgument nvarchar(max)
  DECLARE @CurrentUpdateStatisticsWithClause nvarchar(max)

  DECLARE @Error int = 0
  DECLARE @ReturnCode int = 0

  DECLARE @EmptyLine nvarchar(max) = CHAR(9)

  DECLARE @Version numeric(18,10) = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  IF @Version >= 14
  BEGIN
    SELECT @HostPlatform = host_platform
    FROM sys.dm_os_host_info
  END
  ELSE
  BEGIN
    SET @HostPlatform = 'Windows'
  END

  DECLARE @AmazonRDS bit = CASE WHEN DB_ID('rdsadmin') IS NOT NULL AND SUSER_SNAME(0x01) = 'rdsa' THEN 1 ELSE 0 END

  ----------------------------------------------------------------------------------------------------
  --// Log initial information                                                                    //--
  ----------------------------------------------------------------------------------------------------

  SET @Parameters = '@Databases = ' + ISNULL('''' + REPLACE(@Databases,'''','''''') + '''','NULL')
  SET @Parameters += ', @FragmentationLow = ' + ISNULL('''' + REPLACE(@FragmentationLow,'''','''''') + '''','NULL')
  SET @Parameters += ', @FragmentationMedium = ' + ISNULL('''' + REPLACE(@FragmentationMedium,'''','''''') + '''','NULL')
  SET @Parameters += ', @FragmentationHigh = ' + ISNULL('''' + REPLACE(@FragmentationHigh,'''','''''') + '''','NULL')
  SET @Parameters += ', @FragmentationLevel1 = ' + ISNULL(CAST(@FragmentationLevel1 AS nvarchar),'NULL')
  SET @Parameters += ', @FragmentationLevel2 = ' + ISNULL(CAST(@FragmentationLevel2 AS nvarchar),'NULL')
  SET @Parameters += ', @MinNumberOfPages = ' + ISNULL(CAST(@MinNumberOfPages AS nvarchar),'NULL')
  SET @Parameters += ', @MaxNumberOfPages = ' + ISNULL(CAST(@MaxNumberOfPages AS nvarchar),'NULL')
  SET @Parameters += ', @SortInTempdb = ' + ISNULL('''' + REPLACE(@SortInTempdb,'''','''''') + '''','NULL')
  SET @Parameters += ', @MaxDOP = ' + ISNULL(CAST(@MaxDOP AS nvarchar),'NULL')
  SET @Parameters += ', @FillFactor = ' + ISNULL(CAST(@FillFactor AS nvarchar),'NULL')
  SET @Parameters += ', @PadIndex = ' + ISNULL('''' + REPLACE(@PadIndex,'''','''''') + '''','NULL')
  SET @Parameters += ', @LOBCompaction = ' + ISNULL('''' + REPLACE(@LOBCompaction,'''','''''') + '''','NULL')
  SET @Parameters += ', @UpdateStatistics = ' + ISNULL('''' + REPLACE(@UpdateStatistics,'''','''''') + '''','NULL')
  SET @Parameters += ', @OnlyModifiedStatistics = ' + ISNULL('''' + REPLACE(@OnlyModifiedStatistics,'''','''''') + '''','NULL')
  SET @Parameters += ', @StatisticsModificationLevel = ' + ISNULL(CAST(@StatisticsModificationLevel AS nvarchar),'NULL')
  SET @Parameters += ', @StatisticsSample = ' + ISNULL(CAST(@StatisticsSample AS nvarchar),'NULL')
  SET @Parameters += ', @StatisticsResample = ' + ISNULL('''' + REPLACE(@StatisticsResample,'''','''''') + '''','NULL')
  SET @Parameters += ', @PartitionLevel = ' + ISNULL('''' + REPLACE(@PartitionLevel,'''','''''') + '''','NULL')
  SET @Parameters += ', @MSShippedObjects = ' + ISNULL('''' + REPLACE(@MSShippedObjects,'''','''''') + '''','NULL')
  SET @Parameters += ', @Indexes = ' + ISNULL('''' + REPLACE(@Indexes,'''','''''') + '''','NULL')
  SET @Parameters += ', @TimeLimit = ' + ISNULL(CAST(@TimeLimit AS nvarchar),'NULL')
  SET @Parameters += ', @Delay = ' + ISNULL(CAST(@Delay AS nvarchar),'NULL')
  SET @Parameters += ', @WaitAtLowPriorityMaxDuration = ' + ISNULL(CAST(@WaitAtLowPriorityMaxDuration AS nvarchar),'NULL')
  SET @Parameters += ', @WaitAtLowPriorityAbortAfterWait = ' + ISNULL('''' + REPLACE(@WaitAtLowPriorityAbortAfterWait,'''','''''') + '''','NULL')
  SET @Parameters += ', @Resumable = ' + ISNULL('''' + REPLACE(@Resumable,'''','''''') + '''','NULL')
  SET @Parameters += ', @AvailabilityGroups = ' + ISNULL('''' + REPLACE(@AvailabilityGroups,'''','''''') + '''','NULL')
  SET @Parameters += ', @LockTimeout = ' + ISNULL(CAST(@LockTimeout AS nvarchar),'NULL')
  SET @Parameters += ', @LockMessageSeverity = ' + ISNULL(CAST(@LockMessageSeverity AS nvarchar),'NULL')
  SET @Parameters += ', @StringDelimiter = ' + ISNULL('''' + REPLACE(@StringDelimiter,'''','''''') + '''','NULL')
  SET @Parameters += ', @DatabaseOrder = ' + ISNULL('''' + REPLACE(@DatabaseOrder,'''','''''') + '''','NULL')
  SET @Parameters += ', @DatabasesInParallel = ' + ISNULL('''' + REPLACE(@DatabasesInParallel,'''','''''') + '''','NULL')
  SET @Parameters += ', @ExecuteAsUser = ' + ISNULL('''' + REPLACE(@ExecuteAsUser,'''','''''') + '''','NULL')
  SET @Parameters += ', @LogToTable = ' + ISNULL('''' + REPLACE(@LogToTable,'''','''''') + '''','NULL')
  SET @Parameters += ', @Execute = ' + ISNULL('''' + REPLACE(@Execute,'''','''''') + '''','NULL')

  SET @StartMessage = 'Date and time: ' + CONVERT(nvarchar,@StartTime,120)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Server: ' + CAST(SERVERPROPERTY('ServerName') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Version: ' + CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Edition: ' + CAST(SERVERPROPERTY('Edition') AS nvarchar(max))
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Platform: ' + @HostPlatform
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Procedure: ' + QUOTENAME(DB_NAME(DB_ID())) + '.' + QUOTENAME(@SchemaName) + '.' + QUOTENAME(@ObjectName)
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Parameters: ' + @Parameters
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Version: ' + @VersionTimestamp
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  SET @StartMessage = 'Source: https://ola.hallengren.com'
  RAISERROR('%s',10,1,@StartMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  ----------------------------------------------------------------------------------------------------
  --// Check core requirements                                                                    //--
  ----------------------------------------------------------------------------------------------------

  IF NOT (SELECT [compatibility_level] FROM sys.databases WHERE database_id = DB_ID()) >= 90
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The database ' + QUOTENAME(DB_NAME(DB_ID())) + ' has to be in compatibility level 90 or higher.', 16, 1
  END

  IF NOT (SELECT uses_ansi_nulls FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'ANSI_NULLS has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT (SELECT uses_quoted_identifier FROM sys.sql_modules WHERE [object_id] = @@PROCID) = 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'QUOTED_IDENTIFIER has to be set to ON for the stored procedure.', 16, 1
  END

  IF NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dba' AND objects.[name] = 'CommandExecute')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure CommandExecute is missing. Download https://ola.hallengren.com/scripts/CommandExecute.sql.', 16, 1
  END

  IF EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'P' AND schemas.[name] = 'dba' AND objects.[name] = 'CommandExecute' AND OBJECT_DEFINITION(objects.[object_id]) NOT LIKE '%@DatabaseContext%')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The stored procedure CommandExecute needs to be updated. Download https://ola.hallengren.com/scripts/CommandExecute.sql.', 16, 1
  END

  IF @LogToTable = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dba' AND objects.[name] = 'CommandLog')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table CommandLog is missing. Download https://ola.hallengren.com/scripts/CommandLog.sql.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dba' AND objects.[name] = 'Queue')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table Queue is missing. Download https://ola.hallengren.com/scripts/Queue.sql.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND NOT EXISTS (SELECT * FROM sys.objects objects INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] = 'U' AND schemas.[name] = 'dba' AND objects.[name] = 'QueueDatabase')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The table QueueDatabase is missing. Download https://ola.hallengren.com/scripts/QueueDatabase.sql.', 16, 1
  END

  IF @@TRANCOUNT <> 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The transaction count is not 0.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select databases                                                                           //--
  ----------------------------------------------------------------------------------------------------

  SET @Databases = REPLACE(@Databases, CHAR(10), '')
  SET @Databases = REPLACE(@Databases, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @Databases) > 0 SET @Databases = REPLACE(@Databases, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @Databases) > 0 SET @Databases = REPLACE(@Databases, ' ' + @StringDelimiter, @StringDelimiter)

  SET @Databases = LTRIM(RTRIM(@Databases));

  WITH Databases1 (StartPosition, EndPosition, DatabaseItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, 1), 0), LEN(@Databases) + 1) - 1) AS DatabaseItem
  WHERE @Databases IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) AS EndPosition,
         SUBSTRING(@Databases, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Databases, EndPosition + 1), 0), LEN(@Databases) + 1) - EndPosition - 1) AS DatabaseItem
  FROM Databases1
  WHERE EndPosition < LEN(@Databases) + 1
  ),
  Databases2 (DatabaseItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem LIKE '-%' THEN RIGHT(DatabaseItem,LEN(DatabaseItem) - 1) ELSE DatabaseItem END AS DatabaseItem,
         StartPosition,
         CASE WHEN DatabaseItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Databases1
  ),
  Databases3 (DatabaseItem, DatabaseType, AvailabilityGroup, StartPosition, Selected) AS
  (
  SELECT CASE WHEN DatabaseItem IN('ALL_DATABASES','SYSTEM_DATABASES','USER_DATABASES','AVAILABILITY_GROUP_DATABASES') THEN '%' ELSE DatabaseItem END AS DatabaseItem,
         CASE WHEN DatabaseItem = 'SYSTEM_DATABASES' THEN 'S' WHEN DatabaseItem = 'USER_DATABASES' THEN 'U' ELSE NULL END AS DatabaseType,
         CASE WHEN DatabaseItem = 'AVAILABILITY_GROUP_DATABASES' THEN 1 ELSE NULL END AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases2
  ),
  Databases4 (DatabaseName, DatabaseType, AvailabilityGroup, StartPosition, Selected) AS
  (
  SELECT CASE WHEN LEFT(DatabaseItem,1) = '[' AND RIGHT(DatabaseItem,1) = ']' THEN PARSENAME(DatabaseItem,1) ELSE DatabaseItem END AS DatabaseItem,
         DatabaseType,
         AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases3
  )
  INSERT INTO @SelectedDatabases (DatabaseName, DatabaseType, AvailabilityGroup, StartPosition, Selected)
  SELECT DatabaseName,
         DatabaseType,
         AvailabilityGroup,
         StartPosition,
         Selected
  FROM Databases4
  OPTION (MAXRECURSION 0)

  IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN
    INSERT INTO @tmpAvailabilityGroups (AvailabilityGroupName, Selected)
    SELECT name AS AvailabilityGroupName,
           0 AS Selected
    FROM sys.availability_groups

    INSERT INTO @tmpDatabasesAvailabilityGroups (DatabaseName, AvailabilityGroupName)
    SELECT databases.name,
           availability_groups.name
    FROM sys.databases databases
    INNER JOIN sys.availability_replicas availability_replicas ON databases.replica_id = availability_replicas.replica_id
    INNER JOIN sys.availability_groups availability_groups ON availability_replicas.group_id = availability_groups.group_id
  END

  INSERT INTO @tmpDatabases (DatabaseName, DatabaseType, AvailabilityGroup, [Order], Selected, Completed)
  SELECT [name] AS DatabaseName,
         CASE WHEN name IN('master','msdb','model') OR is_distributor = 1 THEN 'S' ELSE 'U' END AS DatabaseType,
         NULL AS AvailabilityGroup,
         0 AS [Order],
         0 AS Selected,
         0 AS Completed
  FROM sys.databases
  WHERE [name] <> 'tempdb'
  AND source_database_id IS NULL
  ORDER BY [name] ASC

  UPDATE tmpDatabases
  SET AvailabilityGroup = CASE WHEN EXISTS (SELECT * FROM @tmpDatabasesAvailabilityGroups WHERE DatabaseName = tmpDatabases.DatabaseName) THEN 1 ELSE 0 END
  FROM @tmpDatabases tmpDatabases

  UPDATE tmpDatabases
  SET tmpDatabases.Selected = SelectedDatabases.Selected
  FROM @tmpDatabases tmpDatabases
  INNER JOIN @SelectedDatabases SelectedDatabases
  ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
  AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
  AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
  WHERE SelectedDatabases.Selected = 1

  UPDATE tmpDatabases
  SET tmpDatabases.Selected = SelectedDatabases.Selected
  FROM @tmpDatabases tmpDatabases
  INNER JOIN @SelectedDatabases SelectedDatabases
  ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
  AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
  AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
  WHERE SelectedDatabases.Selected = 0

  UPDATE tmpDatabases
  SET tmpDatabases.StartPosition = SelectedDatabases2.StartPosition
  FROM @tmpDatabases tmpDatabases
  INNER JOIN (SELECT tmpDatabases.DatabaseName, MIN(SelectedDatabases.StartPosition) AS StartPosition
              FROM @tmpDatabases tmpDatabases
              INNER JOIN @SelectedDatabases SelectedDatabases
              ON tmpDatabases.DatabaseName LIKE REPLACE(SelectedDatabases.DatabaseName,'_','[_]')
              AND (tmpDatabases.DatabaseType = SelectedDatabases.DatabaseType OR SelectedDatabases.DatabaseType IS NULL)
              AND (tmpDatabases.AvailabilityGroup = SelectedDatabases.AvailabilityGroup OR SelectedDatabases.AvailabilityGroup IS NULL)
              WHERE SelectedDatabases.Selected = 1
              GROUP BY tmpDatabases.DatabaseName) SelectedDatabases2
  ON tmpDatabases.DatabaseName = SelectedDatabases2.DatabaseName

  IF @Databases IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedDatabases) OR EXISTS(SELECT * FROM @SelectedDatabases WHERE DatabaseName IS NULL OR DatabaseName = ''))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Databases is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Select availability groups                                                                 //--
  ----------------------------------------------------------------------------------------------------

  IF @AvailabilityGroups IS NOT NULL AND @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
  BEGIN

    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(10), '')
    SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, CHAR(13), '')

    WHILE CHARINDEX(@StringDelimiter + ' ', @AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, @StringDelimiter + ' ', @StringDelimiter)
    WHILE CHARINDEX(' ' + @StringDelimiter, @AvailabilityGroups) > 0 SET @AvailabilityGroups = REPLACE(@AvailabilityGroups, ' ' + @StringDelimiter, @StringDelimiter)

    SET @AvailabilityGroups = LTRIM(RTRIM(@AvailabilityGroups));

    WITH AvailabilityGroups1 (StartPosition, EndPosition, AvailabilityGroupItem) AS
    (
    SELECT 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, 1), 0), LEN(@AvailabilityGroups) + 1) - 1) AS AvailabilityGroupItem
    WHERE @AvailabilityGroups IS NOT NULL
    UNION ALL
    SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
           ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) AS EndPosition,
           SUBSTRING(@AvailabilityGroups, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @AvailabilityGroups, EndPosition + 1), 0), LEN(@AvailabilityGroups) + 1) - EndPosition - 1) AS AvailabilityGroupItem
    FROM AvailabilityGroups1
    WHERE EndPosition < LEN(@AvailabilityGroups) + 1
    ),
    AvailabilityGroups2 (AvailabilityGroupItem, StartPosition, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem LIKE '-%' THEN RIGHT(AvailabilityGroupItem,LEN(AvailabilityGroupItem) - 1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           CASE WHEN AvailabilityGroupItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
    FROM AvailabilityGroups1
    ),
    AvailabilityGroups3 (AvailabilityGroupItem, StartPosition, Selected) AS
    (
    SELECT CASE WHEN AvailabilityGroupItem = 'ALL_AVAILABILITY_GROUPS' THEN '%' ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           Selected
    FROM AvailabilityGroups2
    ),
    AvailabilityGroups4 (AvailabilityGroupName, StartPosition, Selected) AS
    (
    SELECT CASE WHEN LEFT(AvailabilityGroupItem,1) = '[' AND RIGHT(AvailabilityGroupItem,1) = ']' THEN PARSENAME(AvailabilityGroupItem,1) ELSE AvailabilityGroupItem END AS AvailabilityGroupItem,
           StartPosition,
           Selected
    FROM AvailabilityGroups3
    )
    INSERT INTO @SelectedAvailabilityGroups (AvailabilityGroupName, StartPosition, Selected)
    SELECT AvailabilityGroupName, StartPosition, Selected
    FROM AvailabilityGroups4
    OPTION (MAXRECURSION 0)

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.Selected = SelectedAvailabilityGroups.Selected
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
    ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
    WHERE SelectedAvailabilityGroups.Selected = 1

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.Selected = SelectedAvailabilityGroups.Selected
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
    ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
    WHERE SelectedAvailabilityGroups.Selected = 0

    UPDATE tmpAvailabilityGroups
    SET tmpAvailabilityGroups.StartPosition = SelectedAvailabilityGroups2.StartPosition
    FROM @tmpAvailabilityGroups tmpAvailabilityGroups
    INNER JOIN (SELECT tmpAvailabilityGroups.AvailabilityGroupName, MIN(SelectedAvailabilityGroups.StartPosition) AS StartPosition
                FROM @tmpAvailabilityGroups tmpAvailabilityGroups
                INNER JOIN @SelectedAvailabilityGroups SelectedAvailabilityGroups
                ON tmpAvailabilityGroups.AvailabilityGroupName LIKE REPLACE(SelectedAvailabilityGroups.AvailabilityGroupName,'_','[_]')
                WHERE SelectedAvailabilityGroups.Selected = 1
                GROUP BY tmpAvailabilityGroups.AvailabilityGroupName) SelectedAvailabilityGroups2
    ON tmpAvailabilityGroups.AvailabilityGroupName = SelectedAvailabilityGroups2.AvailabilityGroupName

    UPDATE tmpDatabases
    SET tmpDatabases.StartPosition = tmpAvailabilityGroups.StartPosition,
        tmpDatabases.Selected = 1
    FROM @tmpDatabases tmpDatabases
    INNER JOIN @tmpDatabasesAvailabilityGroups tmpDatabasesAvailabilityGroups ON tmpDatabases.DatabaseName = tmpDatabasesAvailabilityGroups.DatabaseName
    INNER JOIN @tmpAvailabilityGroups tmpAvailabilityGroups ON tmpDatabasesAvailabilityGroups.AvailabilityGroupName = tmpAvailabilityGroups.AvailabilityGroupName
    WHERE tmpAvailabilityGroups.Selected = 1

  END

  IF @AvailabilityGroups IS NOT NULL AND (NOT EXISTS(SELECT * FROM @SelectedAvailabilityGroups) OR EXISTS(SELECT * FROM @SelectedAvailabilityGroups WHERE AvailabilityGroupName IS NULL OR AvailabilityGroupName = '') OR @Version < 11 OR SERVERPROPERTY('IsHadrEnabled') = 0)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @AvailabilityGroups is not supported.', 16, 1
  END

  IF (@Databases IS NULL AND @AvailabilityGroups IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You need to specify one of the parameters @Databases and @AvailabilityGroups.', 16, 2
  END

  IF (@Databases IS NOT NULL AND @AvailabilityGroups IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You can only specify one of the parameters @Databases and @AvailabilityGroups.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------
  --// Select indexes                                                                             //--
  ----------------------------------------------------------------------------------------------------

  SET @Indexes = REPLACE(@Indexes, CHAR(10), '')
  SET @Indexes = REPLACE(@Indexes, CHAR(13), '')

  WHILE CHARINDEX(@StringDelimiter + ' ', @Indexes) > 0 SET @Indexes = REPLACE(@Indexes, @StringDelimiter + ' ', @StringDelimiter)
  WHILE CHARINDEX(' ' + @StringDelimiter, @Indexes) > 0 SET @Indexes = REPLACE(@Indexes, ' ' + @StringDelimiter, @StringDelimiter)

  SET @Indexes = LTRIM(RTRIM(@Indexes));

  WITH Indexes1 (StartPosition, EndPosition, IndexItem) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Indexes, 1), 0), LEN(@Indexes) + 1) AS EndPosition,
         SUBSTRING(@Indexes, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Indexes, 1), 0), LEN(@Indexes) + 1) - 1) AS IndexItem
  WHERE @Indexes IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Indexes, EndPosition + 1), 0), LEN(@Indexes) + 1) AS EndPosition,
         SUBSTRING(@Indexes, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @Indexes, EndPosition + 1), 0), LEN(@Indexes) + 1) - EndPosition - 1) AS IndexItem
  FROM Indexes1
  WHERE EndPosition < LEN(@Indexes) + 1
  ),
  Indexes2 (IndexItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN IndexItem LIKE '-%' THEN RIGHT(IndexItem,LEN(IndexItem) - 1) ELSE IndexItem END AS IndexItem,
         StartPosition,
         CASE WHEN IndexItem LIKE '-%' THEN 0 ELSE 1 END AS Selected
  FROM Indexes1
  ),
  Indexes3 (IndexItem, StartPosition, Selected) AS
  (
  SELECT CASE WHEN IndexItem = 'ALL_INDEXES' THEN '%.%.%.%' ELSE IndexItem END AS IndexItem,
         StartPosition,
         Selected
  FROM Indexes2
  ),
  Indexes4 (DatabaseName, SchemaName, ObjectName, IndexName, StartPosition, Selected) AS
  (
  SELECT CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,3) ELSE PARSENAME(IndexItem,4) END AS DatabaseName,
         CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,2) ELSE PARSENAME(IndexItem,3) END AS SchemaName,
         CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN PARSENAME(IndexItem,1) ELSE PARSENAME(IndexItem,2) END AS ObjectName,
         CASE WHEN PARSENAME(IndexItem,4) IS NULL THEN '%' ELSE PARSENAME(IndexItem,1) END AS IndexName,
         StartPosition,
         Selected
  FROM Indexes3
  )
  INSERT INTO @SelectedIndexes (DatabaseName, SchemaName, ObjectName, IndexName, StartPosition, Selected)
  SELECT DatabaseName, SchemaName, ObjectName, IndexName, StartPosition, Selected
  FROM Indexes4
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Select actions                                                                             //--
  ----------------------------------------------------------------------------------------------------

  SET @FragmentationLow = REPLACE(@FragmentationLow, @StringDelimiter + ' ', @StringDelimiter);

  WITH FragmentationLow (StartPosition, EndPosition, [Action]) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationLow, 1), 0), LEN(@FragmentationLow) + 1) AS EndPosition,
         SUBSTRING(@FragmentationLow, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationLow, 1), 0), LEN(@FragmentationLow) + 1) - 1) AS [Action]
  WHERE @FragmentationLow IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationLow, EndPosition + 1), 0), LEN(@FragmentationLow) + 1) AS EndPosition,
         SUBSTRING(@FragmentationLow, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationLow, EndPosition + 1), 0), LEN(@FragmentationLow) + 1) - EndPosition - 1) AS [Action]
  FROM FragmentationLow
  WHERE EndPosition < LEN(@FragmentationLow) + 1
  )
  INSERT INTO @ActionsPreferred(FragmentationGroup, [Priority], [Action])
  SELECT 'Low' AS FragmentationGroup,
         ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS [Priority],
         [Action]
  FROM FragmentationLow
  OPTION (MAXRECURSION 0)

  SET @FragmentationMedium = REPLACE(@FragmentationMedium, @StringDelimiter + ' ', @StringDelimiter);

  WITH FragmentationMedium (StartPosition, EndPosition, [Action]) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationMedium, 1), 0), LEN(@FragmentationMedium) + 1) AS EndPosition,
         SUBSTRING(@FragmentationMedium, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationMedium, 1), 0), LEN(@FragmentationMedium) + 1) - 1) AS [Action]
  WHERE @FragmentationMedium IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationMedium, EndPosition + 1), 0), LEN(@FragmentationMedium) + 1) AS EndPosition,
         SUBSTRING(@FragmentationMedium, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationMedium, EndPosition + 1), 0), LEN(@FragmentationMedium) + 1) - EndPosition - 1) AS [Action]
  FROM FragmentationMedium
  WHERE EndPosition < LEN(@FragmentationMedium) + 1
  )
  INSERT INTO @ActionsPreferred(FragmentationGroup, [Priority], [Action])
  SELECT 'Medium' AS FragmentationGroup,
         ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS [Priority],
         [Action]
  FROM FragmentationMedium
  OPTION (MAXRECURSION 0)

  SET @FragmentationHigh = REPLACE(@FragmentationHigh, @StringDelimiter + ' ', @StringDelimiter);

  WITH FragmentationHigh (StartPosition, EndPosition, [Action]) AS
  (
  SELECT 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationHigh, 1), 0), LEN(@FragmentationHigh) + 1) AS EndPosition,
         SUBSTRING(@FragmentationHigh, 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationHigh, 1), 0), LEN(@FragmentationHigh) + 1) - 1) AS [Action]
  WHERE @FragmentationHigh IS NOT NULL
  UNION ALL
  SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
         ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationHigh, EndPosition + 1), 0), LEN(@FragmentationHigh) + 1) AS EndPosition,
         SUBSTRING(@FragmentationHigh, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(@StringDelimiter, @FragmentationHigh, EndPosition + 1), 0), LEN(@FragmentationHigh) + 1) - EndPosition - 1) AS [Action]
  FROM FragmentationHigh
  WHERE EndPosition < LEN(@FragmentationHigh) + 1
  )
  INSERT INTO @ActionsPreferred(FragmentationGroup, [Priority], [Action])
  SELECT 'High' AS FragmentationGroup,
         ROW_NUMBER() OVER(ORDER BY StartPosition ASC) AS [Priority],
         [Action]
  FROM FragmentationHigh
  OPTION (MAXRECURSION 0)

  ----------------------------------------------------------------------------------------------------
  --// Check input parameters                                                                     //--
  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT [Action] FROM @ActionsPreferred WHERE FragmentationGroup = 'Low' AND [Action] NOT IN(SELECT * FROM @Actions))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLow is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'Low' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLow is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT [Action] FROM @ActionsPreferred WHERE FragmentationGroup = 'Medium' AND [Action] NOT IN(SELECT * FROM @Actions))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationMedium is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'Medium' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationMedium is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS (SELECT [Action] FROM @ActionsPreferred WHERE FragmentationGroup = 'High' AND [Action] NOT IN(SELECT * FROM @Actions))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationHigh is not supported.', 16, 1
  END

  IF EXISTS (SELECT * FROM @ActionsPreferred WHERE FragmentationGroup = 'High' GROUP BY [Action] HAVING COUNT(*) > 1)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationHigh is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @FragmentationLevel1 <= 0 OR @FragmentationLevel1 >= 100 OR @FragmentationLevel1 IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLevel1 is not supported.', 16, 1
  END

  IF @FragmentationLevel1 >= @FragmentationLevel2
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLevel1 is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @FragmentationLevel2 <= 0 OR @FragmentationLevel2 >= 100 OR @FragmentationLevel2 IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLevel2 is not supported.', 16, 1
  END

  IF @FragmentationLevel2 <= @FragmentationLevel1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FragmentationLevel2 is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @MinNumberOfPages < 0 OR @MinNumberOfPages IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MinNumberOfPages is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @MaxNumberOfPages < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxNumberOfPages is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @SortInTempdb NOT IN('Y','N') OR @SortInTempdb IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @SortInTempdb is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @MaxDOP < 0 OR @MaxDOP > 64
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MaxDOP is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @FillFactor <= 0 OR @FillFactor > 100
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @FillFactor is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @PadIndex NOT IN('Y','N')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @PadIndex is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @LOBCompaction NOT IN('Y','N') OR @LOBCompaction IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LOBCompaction is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @UpdateStatistics NOT IN('ALL','COLUMNS','INDEX')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @UpdateStatistics is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @OnlyModifiedStatistics NOT IN('Y','N') OR @OnlyModifiedStatistics IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @OnlyModifiedStatistics is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StatisticsModificationLevel <= 0 OR @StatisticsModificationLevel > 100
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StatisticsModificationLevel is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @OnlyModifiedStatistics = 'Y' AND @StatisticsModificationLevel IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You can only specify one of the parameters @OnlyModifiedStatistics and @StatisticsModificationLevel.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StatisticsSample <= 0 OR @StatisticsSample  > 100
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StatisticsSample is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StatisticsResample NOT IN('Y','N') OR @StatisticsResample IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StatisticsResample is not supported.', 16, 1
  END

  IF @StatisticsResample = 'Y' AND @StatisticsSample IS NOT NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StatisticsResample is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @PartitionLevel NOT IN('Y','N') OR @PartitionLevel IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @PartitionLevel is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @MSShippedObjects NOT IN('Y','N') OR @MSShippedObjects IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @MSShippedObjects is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @SelectedIndexes WHERE DatabaseName IS NULL OR SchemaName IS NULL OR ObjectName IS NULL OR IndexName IS NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Indexes is not supported.', 16, 1
  END

  IF @Indexes IS NOT NULL AND NOT EXISTS(SELECT * FROM @SelectedIndexes)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Indexes is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @TimeLimit < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @TimeLimit is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Delay < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Delay is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @WaitAtLowPriorityMaxDuration < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @WaitAtLowPriorityMaxDuration is not supported.', 16, 1
  END

  IF @WaitAtLowPriorityMaxDuration IS NOT NULL AND @Version < 12
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @WaitAtLowPriorityMaxDuration is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @WaitAtLowPriorityAbortAfterWait NOT IN('NONE','SELF','BLOCKERS')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @WaitAtLowPriorityAbortAfterWait is not supported.', 16, 1
  END

  IF @WaitAtLowPriorityAbortAfterWait IS NOT NULL AND @Version < 12
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @WaitAtLowPriorityAbortAfterWait is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF (@WaitAtLowPriorityAbortAfterWait IS NOT NULL AND @WaitAtLowPriorityMaxDuration IS NULL) OR (@WaitAtLowPriorityAbortAfterWait IS NULL AND @WaitAtLowPriorityMaxDuration IS NOT NULL)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The parameters @WaitAtLowPriorityMaxDuration and @WaitAtLowPriorityAbortAfterWait can only be used together.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Resumable NOT IN('Y','N') OR @Resumable IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Resumable is not supported.', 16, 1
  END

  IF @Resumable = 'Y' AND NOT (@Version >= 14 OR SERVERPROPERTY('EngineEdition') IN (5, 8))
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Resumable is not supported.', 16, 2
  END

  IF @Resumable = 'Y' AND @SortInTempdb = 'Y'
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'You can only specify one of the parameters @Resumable and @SortInTempdb.', 16, 3
  END

  ----------------------------------------------------------------------------------------------------

  IF @LockTimeout < 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LockTimeout is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @LockMessageSeverity NOT IN(10, 16)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LockMessageSeverity is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @StringDelimiter IS NULL OR LEN(@StringDelimiter) > 1
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @StringDelimiter is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @DatabaseOrder NOT IN('DATABASE_NAME_ASC','DATABASE_NAME_DESC','DATABASE_SIZE_ASC','DATABASE_SIZE_DESC')
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported.', 16, 1
  END

  IF @DatabaseOrder IS NOT NULL AND SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabaseOrder is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF @DatabasesInParallel NOT IN('Y','N') OR @DatabasesInParallel IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabasesInParallel is not supported.', 16, 1
  END

  IF @DatabasesInParallel = 'Y' AND SERVERPROPERTY('EngineEdition') = 5
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @DatabasesInParallel is not supported.', 16, 2
  END

  ----------------------------------------------------------------------------------------------------

  IF LEN(@ExecuteAsUser) > 128
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @ExecuteAsUser is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @LogToTable NOT IN('Y','N') OR @LogToTable IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @LogToTable is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF @Execute NOT IN('Y','N') OR @Execute IS NULL
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The value for the parameter @Execute is not supported.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------

  IF EXISTS(SELECT * FROM @Errors)
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The documentation is available at https://ola.hallengren.com/sql-server-index-and-statistics-maintenance.html.', 16, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Check that selected databases and availability groups exist                                //--
  ----------------------------------------------------------------------------------------------------

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedDatabases
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases in the @Databases parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedIndexes
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases in the @Indexes parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(AvailabilityGroupName) + ', '
  FROM @SelectedAvailabilityGroups
  WHERE AvailabilityGroupName NOT LIKE '%[%]%'
  AND AvailabilityGroupName NOT IN (SELECT AvailabilityGroupName FROM @tmpAvailabilityGroups)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following availability groups do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  SET @ErrorMessage = ''
  SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + ', '
  FROM @SelectedIndexes
  WHERE DatabaseName NOT LIKE '%[%]%'
  AND DatabaseName IN (SELECT DatabaseName FROM @tmpDatabases)
  AND DatabaseName NOT IN (SELECT DatabaseName FROM @tmpDatabases WHERE Selected = 1)
  IF @@ROWCOUNT > 0
  BEGIN
    INSERT INTO @Errors ([Message], Severity, [State])
    SELECT 'The following databases have been selected in the @Indexes parameter, but not in the @Databases or @AvailabilityGroups parameters: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.', 10, 1
  END

  ----------------------------------------------------------------------------------------------------
  --// Raise errors                                                                               //--
  ----------------------------------------------------------------------------------------------------

  DECLARE ErrorCursor CURSOR FAST_FORWARD FOR SELECT [Message], Severity, [State] FROM @Errors ORDER BY [ID] ASC

  OPEN ErrorCursor

  FETCH ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState

  WHILE @@FETCH_STATUS = 0
  BEGIN
    RAISERROR('%s', @CurrentSeverity, @CurrentState, @CurrentMessage) WITH NOWAIT
    RAISERROR(@EmptyLine, 10, 1) WITH NOWAIT

    FETCH NEXT FROM ErrorCursor INTO @CurrentMessage, @CurrentSeverity, @CurrentState
  END

  CLOSE ErrorCursor

  DEALLOCATE ErrorCursor

  IF EXISTS (SELECT * FROM @Errors WHERE Severity >= 16)
  BEGIN
    SET @ReturnCode = 50000
    GOTO Logging
  END

  ----------------------------------------------------------------------------------------------------
  --// Should statistics be updated on the partition level?                                       //--
  ----------------------------------------------------------------------------------------------------

  SET @PartitionLevelStatistics = CASE WHEN @PartitionLevel = 'Y' AND ((@Version >= 12.05 AND @Version < 13) OR @Version >= 13.04422 OR SERVERPROPERTY('EngineEdition') IN (5,8)) THEN 1 ELSE 0 END

  ----------------------------------------------------------------------------------------------------
  --// Update database order                                                                      //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabaseOrder IN('DATABASE_SIZE_ASC','DATABASE_SIZE_DESC')
  BEGIN
    UPDATE tmpDatabases
    SET DatabaseSize = (SELECT SUM(CAST(size AS bigint)) FROM sys.master_files WHERE [type] = 0 AND database_id = DB_ID(tmpDatabases.DatabaseName))
    FROM @tmpDatabases tmpDatabases
  END

  IF @DatabaseOrder IS NULL
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY StartPosition ASC, DatabaseName ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_NAME_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseName ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_NAME_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseName DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_SIZE_ASC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseSize ASC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END
  ELSE
  IF @DatabaseOrder = 'DATABASE_SIZE_DESC'
  BEGIN
    WITH tmpDatabases AS (
    SELECT DatabaseName, [Order], ROW_NUMBER() OVER (ORDER BY DatabaseSize DESC) AS RowNumber
    FROM @tmpDatabases tmpDatabases
    WHERE Selected = 1
    )
    UPDATE tmpDatabases
    SET [Order] = RowNumber
  END

  ----------------------------------------------------------------------------------------------------
  --// Update the queue                                                                           //--
  ----------------------------------------------------------------------------------------------------

  IF @DatabasesInParallel = 'Y'
  BEGIN

    BEGIN TRY

      SELECT @QueueID = QueueID
      FROM dbo.[Queue]
      WHERE SchemaName = @SchemaName
      AND ObjectName = @ObjectName
      AND [Parameters] = @Parameters

      IF @QueueID IS NULL
      BEGIN
        BEGIN TRANSACTION

        SELECT @QueueID = QueueID
        FROM dbo.[Queue] WITH (UPDLOCK, HOLDLOCK)
        WHERE SchemaName = @SchemaName
        AND ObjectName = @ObjectName
        AND [Parameters] = @Parameters

        IF @QueueID IS NULL
        BEGIN
          INSERT INTO dbo.[Queue] (SchemaName, ObjectName, [Parameters])
          SELECT @SchemaName, @ObjectName, @Parameters

          SET @QueueID = SCOPE_IDENTITY()
        END

        COMMIT TRANSACTION
      END

      BEGIN TRANSACTION

      UPDATE [Queue]
      SET QueueStartTime = SYSDATETIME(),
          SessionID = @@SPID,
          RequestID = (SELECT request_id FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          RequestStartTime = (SELECT start_time FROM sys.dm_exec_requests WHERE session_id = @@SPID)
      FROM dbo.[Queue] [Queue]
      WHERE QueueID = @QueueID
      AND NOT EXISTS (SELECT *
                      FROM sys.dm_exec_requests
                      WHERE session_id = [Queue].SessionID
                      AND request_id = [Queue].RequestID
                      AND start_time = [Queue].RequestStartTime)
      AND NOT EXISTS (SELECT *
                      FROM dbo.QueueDatabase QueueDatabase
                      INNER JOIN sys.dm_exec_requests ON QueueDatabase.SessionID = session_id AND QueueDatabase.RequestID = request_id AND QueueDatabase.RequestStartTime = start_time
                      WHERE QueueDatabase.QueueID = @QueueID)

      IF @@ROWCOUNT = 1
      BEGIN
        INSERT INTO dbo.QueueDatabase (QueueID, DatabaseName)
        SELECT @QueueID AS QueueID,
               DatabaseName
        FROM @tmpDatabases tmpDatabases
        WHERE Selected = 1
        AND NOT EXISTS (SELECT * FROM dbo.QueueDatabase WHERE DatabaseName = tmpDatabases.DatabaseName AND QueueID = @QueueID)

        DELETE QueueDatabase
        FROM dbo.QueueDatabase QueueDatabase
        WHERE QueueID = @QueueID
        AND NOT EXISTS (SELECT * FROM @tmpDatabases tmpDatabases WHERE DatabaseName = QueueDatabase.DatabaseName AND Selected = 1)

        UPDATE QueueDatabase
        SET DatabaseOrder = tmpDatabases.[Order]
        FROM dbo.QueueDatabase QueueDatabase
        INNER JOIN @tmpDatabases tmpDatabases ON QueueDatabase.DatabaseName = tmpDatabases.DatabaseName
        WHERE QueueID = @QueueID
      END

      COMMIT TRANSACTION

      SELECT @QueueStartTime = QueueStartTime
      FROM dbo.[Queue]
      WHERE QueueID = @QueueID

    END TRY

    BEGIN CATCH
      IF XACT_STATE() <> 0
      BEGIN
        ROLLBACK TRANSACTION
      END
      SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'')
      RAISERROR('%s',16,1,@ErrorMessage) WITH NOWAIT
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      SET @ReturnCode = ERROR_NUMBER()
      GOTO Logging
    END CATCH

  END

  ----------------------------------------------------------------------------------------------------
  --// Execute commands                                                                           //--
  ----------------------------------------------------------------------------------------------------

  WHILE (1 = 1)
  BEGIN

    IF @DatabasesInParallel = 'Y'
    BEGIN
      UPDATE QueueDatabase
      SET DatabaseStartTime = NULL,
          SessionID = NULL,
          RequestID = NULL,
          RequestStartTime = NULL
      FROM dbo.QueueDatabase QueueDatabase
      WHERE QueueID = @QueueID
      AND DatabaseStartTime IS NOT NULL
      AND DatabaseEndTime IS NULL
      AND NOT EXISTS (SELECT * FROM sys.dm_exec_requests WHERE session_id = QueueDatabase.SessionID AND request_id = QueueDatabase.RequestID AND start_time = QueueDatabase.RequestStartTime)

      UPDATE QueueDatabase
      SET DatabaseStartTime = SYSDATETIME(),
          DatabaseEndTime = NULL,
          SessionID = @@SPID,
          RequestID = (SELECT request_id FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          RequestStartTime = (SELECT start_time FROM sys.dm_exec_requests WHERE session_id = @@SPID),
          @CurrentDatabaseName = DatabaseName
      FROM (SELECT TOP 1 DatabaseStartTime,
                         DatabaseEndTime,
                         SessionID,
                         RequestID,
                         RequestStartTime,
                         DatabaseName
            FROM dbo.QueueDatabase
            WHERE QueueID = @QueueID
            AND (DatabaseStartTime < @QueueStartTime OR DatabaseStartTime IS NULL)
            AND NOT (DatabaseStartTime IS NOT NULL AND DatabaseEndTime IS NULL)
            ORDER BY DatabaseOrder ASC
            ) QueueDatabase
    END
    ELSE
    BEGIN
      SELECT TOP 1 @CurrentDBID = ID,
                   @CurrentDatabaseName = DatabaseName
      FROM @tmpDatabases
      WHERE Selected = 1
      AND Completed = 0
      ORDER BY [Order] ASC
    END

    IF @@ROWCOUNT = 0
    BEGIN
      BREAK
    END

    SET @CurrentDatabase_sp_executesql = QUOTENAME(@CurrentDatabaseName) + '.sys.sp_executesql'

    IF @ExecuteAsUser IS NOT NULL
    BEGIN
      SET @CurrentCommand = ''
      SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.database_principals database_principals WHERE database_principals.[name] = @ParamExecuteAsUser) BEGIN SET @ParamExecuteAsUserExists = 1 END ELSE BEGIN SET @ParamExecuteAsUserExists = 0 END'

      EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamExecuteAsUser sysname, @ParamExecuteAsUserExists bit OUTPUT', @ParamExecuteAsUser = @ExecuteAsUser, @ParamExecuteAsUserExists = @CurrentExecuteAsUserExists OUTPUT
    END

    BEGIN
      SET @DatabaseMessage = 'Date and time: ' + CONVERT(nvarchar,SYSDATETIME(),120)
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Database: ' + QUOTENAME(@CurrentDatabaseName)
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    SELECT @CurrentUserAccess = user_access_desc,
           @CurrentIsReadOnly = is_read_only,
           @CurrentDatabaseState = state_desc,
           @CurrentInStandby = is_in_standby,
           @CurrentRecoveryModel = recovery_model_desc
    FROM sys.databases
    WHERE [name] = @CurrentDatabaseName

    BEGIN
      SET @DatabaseMessage = 'State: ' + @CurrentDatabaseState
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Standby: ' + CASE WHEN @CurrentInStandby = 1 THEN 'Yes' ELSE 'No' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Updateability: ' + CASE WHEN @CurrentIsReadOnly = 1 THEN 'READ_ONLY' WHEN  @CurrentIsReadOnly = 0 THEN 'READ_WRITE' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'User access: ' + @CurrentUserAccess
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Recovery model: ' + @CurrentRecoveryModel
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentDatabaseState = 'ONLINE' AND SERVERPROPERTY('EngineEdition') <> 5
    BEGIN
      IF EXISTS (SELECT * FROM sys.database_recovery_status WHERE database_id = DB_ID(@CurrentDatabaseName) AND database_guid IS NOT NULL)
      BEGIN
        SET @CurrentIsDatabaseAccessible = 1
      END
      ELSE
      BEGIN
        SET @CurrentIsDatabaseAccessible = 0
      END
    END

    IF @Version >= 11 AND SERVERPROPERTY('IsHadrEnabled') = 1
    BEGIN
      SELECT @CurrentReplicaID = databases.replica_id
      FROM sys.databases databases
      INNER JOIN sys.availability_replicas availability_replicas ON databases.replica_id = availability_replicas.replica_id
      WHERE databases.[name] = @CurrentDatabaseName

      SELECT @CurrentAvailabilityGroupID = group_id
      FROM sys.availability_replicas
      WHERE replica_id = @CurrentReplicaID

      SELECT @CurrentAvailabilityGroupRole = role_desc
      FROM sys.dm_hadr_availability_replica_states
      WHERE replica_id = @CurrentReplicaID

      SELECT @CurrentAvailabilityGroup = [name]
      FROM sys.availability_groups
      WHERE group_id = @CurrentAvailabilityGroupID
    END

    IF SERVERPROPERTY('EngineEdition') <> 5
    BEGIN
      SELECT @CurrentDatabaseMirroringRole = UPPER(mirroring_role_desc)
      FROM sys.database_mirroring
      WHERE database_id = DB_ID(@CurrentDatabaseName)
    END

    IF @CurrentIsDatabaseAccessible IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Is accessible: ' + CASE WHEN @CurrentIsDatabaseAccessible = 1 THEN 'Yes' ELSE 'No' END
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentAvailabilityGroup IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Availability group: ' + ISNULL(@CurrentAvailabilityGroup,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT

      SET @DatabaseMessage = 'Availability group role: ' + ISNULL(@CurrentAvailabilityGroupRole,'N/A')
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    IF @CurrentDatabaseMirroringRole IS NOT NULL
    BEGIN
      SET @DatabaseMessage = 'Database mirroring role: ' + @CurrentDatabaseMirroringRole
      RAISERROR('%s',10,1,@DatabaseMessage) WITH NOWAIT
    END

    RAISERROR(@EmptyLine,10,1) WITH NOWAIT

    IF @CurrentExecuteAsUserExists = 0
    BEGIN
      SET @DatabaseMessage = 'The user ' + QUOTENAME(@ExecuteAsUser) + ' does not exist in the database ' + QUOTENAME(@CurrentDatabaseName) + '.'
      RAISERROR('%s',16,1,@DatabaseMessage) WITH NOWAIT
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
    END

    IF @CurrentDatabaseState = 'ONLINE'
    AND NOT (@CurrentUserAccess = 'SINGLE_USER' AND @CurrentIsDatabaseAccessible = 0)
    AND DATABASEPROPERTYEX(@CurrentDatabaseName,'Updateability') = 'READ_WRITE'
    AND (@CurrentExecuteAsUserExists = 1 OR @CurrentExecuteAsUserExists IS NULL)
    BEGIN

      -- Select indexes in the current database
      IF (EXISTS(SELECT * FROM @ActionsPreferred) OR @UpdateStatistics IS NOT NULL) AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SET @CurrentCommand = 'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;'
                              + ' SELECT SchemaID, SchemaName, ObjectID, ObjectName, ObjectType, IsMemoryOptimized, IndexID, IndexName, IndexType, AllowPageLocks, IsImageText, IsNewLOB, IsFileStream, IsColumnStore, IsComputed, IsTimestamp, OnReadOnlyFileGroup, ResumableIndexOperation, StatisticsID, StatisticsName, NoRecompute, IsIncremental, PartitionID, PartitionNumber, PartitionCount, [Order], Selected, Completed'
                              + ' FROM ('

        IF EXISTS(SELECT * FROM @ActionsPreferred) OR @UpdateStatistics IN('ALL','INDEX')
        BEGIN
          SET @CurrentCommand = @CurrentCommand + 'SELECT schemas.[schema_id] AS SchemaID'
                                                    + ', schemas.[name] AS SchemaName'
                                                    + ', objects.[object_id] AS ObjectID'
                                                    + ', objects.[name] AS ObjectName'
                                                    + ', RTRIM(objects.[type]) AS ObjectType'
                                                    + ', ' + CASE WHEN @Version >= 12 THEN 'tables.is_memory_optimized' ELSE '0' END + ' AS IsMemoryOptimized'
                                                    + ', indexes.index_id AS IndexID'
                                                    + ', indexes.[name] AS IndexName'
                                                    + ', indexes.[type] AS IndexType'
                                                    + ', indexes.allow_page_locks AS AllowPageLocks'

                                                    + ', CASE WHEN indexes.[type] = 1 AND EXISTS(SELECT * FROM sys.columns columns INNER JOIN sys.types types ON columns.system_type_id = types.user_type_id WHERE columns.[object_id] = objects.object_id AND types.name IN(''image'',''text'',''ntext'')) THEN 1 ELSE 0 END AS IsImageText'

                                                    + ', CASE WHEN indexes.[type] = 1 AND EXISTS(SELECT * FROM sys.columns columns INNER JOIN sys.types types ON columns.system_type_id = types.user_type_id OR (columns.user_type_id = types.user_type_id AND types.is_assembly_type = 1) WHERE columns.[object_id] = objects.object_id AND (types.name IN(''xml'') OR (types.name IN(''varchar'',''nvarchar'',''varbinary'') AND columns.max_length = -1) OR (types.is_assembly_type = 1 AND columns.max_length = -1))) THEN 1'
                                                    + ' WHEN indexes.[type] = 2 AND EXISTS(SELECT * FROM sys.index_columns index_columns INNER JOIN sys.columns columns ON index_columns.[object_id] = columns.[object_id] AND index_columns.column_id = columns.column_id INNER JOIN sys.types types ON columns.system_type_id = types.user_type_id OR (columns.user_type_id = types.user_type_id AND types.is_assembly_type = 1) WHERE index_columns.[object_id] = objects.object_id AND index_columns.index_id = indexes.index_id AND (types.[name] IN(''xml'') OR (types.[name] IN(''varchar'',''nvarchar'',''varbinary'') AND columns.max_length = -1) OR (types.is_assembly_type = 1 AND columns.max_length = -1))) THEN 1 ELSE 0 END AS IsNewLOB'

                                                    + ', CASE WHEN indexes.[type] = 1 AND EXISTS(SELECT * FROM sys.columns columns WHERE columns.[object_id] = objects.object_id  AND columns.is_filestream = 1) THEN 1 ELSE 0 END AS IsFileStream'

                                                    + ', CASE WHEN EXISTS(SELECT * FROM sys.indexes indexes WHERE indexes.[object_id] = objects.object_id AND [type] IN(5,6)) THEN 1 ELSE 0 END AS IsColumnStore'

                                                    + ', CASE WHEN EXISTS(SELECT * FROM sys.index_columns index_columns INNER JOIN sys.columns columns ON index_columns.object_id = columns.object_id AND index_columns.column_id = columns.column_id WHERE (index_columns.key_ordinal > 0 OR index_columns.partition_ordinal > 0) AND columns.is_computed = 1 AND index_columns.object_id = indexes.object_id AND index_columns.index_id = indexes.index_id) THEN 1 ELSE 0 END AS IsComputed'

                                                    + ', CASE WHEN EXISTS(SELECT * FROM sys.index_columns index_columns INNER JOIN sys.columns columns ON index_columns.[object_id] = columns.[object_id] AND index_columns.column_id = columns.column_id INNER JOIN sys.types types ON columns.system_type_id = types.system_type_id WHERE index_columns.[object_id] = objects.object_id AND index_columns.index_id = indexes.index_id AND types.[name] = ''timestamp'') THEN 1 ELSE 0 END AS IsTimestamp'

                                                    + ', CASE WHEN EXISTS (SELECT * FROM sys.indexes indexes2 INNER JOIN sys.destination_data_spaces destination_data_spaces ON indexes.data_space_id = destination_data_spaces.partition_scheme_id INNER JOIN sys.filegroups filegroups ON destination_data_spaces.data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND indexes2.[object_id] = indexes.[object_id] AND indexes2.[index_id] = indexes.index_id' + CASE WHEN @PartitionLevel = 'Y' THEN ' AND destination_data_spaces.destination_id = partitions.partition_number' ELSE '' END + ') THEN 1'
                                                    + ' WHEN EXISTS (SELECT * FROM sys.indexes indexes2 INNER JOIN sys.filegroups filegroups ON indexes.data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND indexes.[object_id] = indexes2.[object_id] AND indexes.[index_id] = indexes2.index_id) THEN 1'
                                                    + ' WHEN indexes.[type] = 1 AND EXISTS (SELECT * FROM sys.tables tables INNER JOIN sys.filegroups filegroups ON tables.lob_data_space_id = filegroups.data_space_id WHERE filegroups.is_read_only = 1 AND tables.[object_id] = objects.[object_id]) THEN 1 ELSE 0 END AS OnReadOnlyFileGroup'

                                                    + ', ' + CASE WHEN @Version >= 14 THEN 'CASE WHEN EXISTS(SELECT * FROM sys.index_resumable_operations index_resumable_operations WHERE state_desc = ''PAUSED'' AND index_resumable_operations.object_id = indexes.object_id AND index_resumable_operations.index_id = indexes.index_id AND (index_resumable_operations.partition_number = partitions.partition_number OR index_resumable_operations.partition_number IS NULL)) THEN 1 ELSE 0 END' ELSE '0' END + ' AS ResumableIndexOperation'

                                                    + ', stats.stats_id AS StatisticsID'
                                                    + ', stats.name AS StatisticsName'
                                                    + ', stats.no_recompute AS NoRecompute'
                                                    + ', ' + CASE WHEN @Version >= 12 THEN 'stats.is_incremental' ELSE '0' END + ' AS IsIncremental'
                                                    + ', ' + CASE WHEN @PartitionLevel = 'Y' THEN 'partitions.partition_id AS PartitionID' WHEN @PartitionLevel = 'N' THEN 'NULL AS PartitionID' END
                                                    + ', ' + CASE WHEN @PartitionLevel = 'Y' THEN 'partitions.partition_number AS PartitionNumber' WHEN @PartitionLevel = 'N' THEN 'NULL AS PartitionNumber' END
                                                    + ', ' + CASE WHEN @PartitionLevel = 'Y' THEN 'IndexPartitions.partition_count AS PartitionCount' WHEN @PartitionLevel = 'N' THEN 'NULL AS PartitionCount' END
                                                    + ', 0 AS [Order]'
                                                    + ', 0 AS Selected'
                                                    + ', 0 AS Completed'
                                                    + ' FROM sys.indexes indexes'
                                                    + ' INNER JOIN sys.objects objects ON indexes.[object_id] = objects.[object_id]'
                                                    + ' INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id]'
                                                    + ' LEFT OUTER JOIN sys.tables tables ON objects.[object_id] = tables.[object_id]'
                                                    + ' LEFT OUTER JOIN sys.stats stats ON indexes.[object_id] = stats.[object_id] AND indexes.[index_id] = stats.[stats_id]'
          IF @PartitionLevel = 'Y'
          BEGIN
            SET @CurrentCommand = @CurrentCommand + ' LEFT OUTER JOIN sys.partitions partitions ON indexes.[object_id] = partitions.[object_id] AND indexes.index_id = partitions.index_id'
                                                      + ' LEFT OUTER JOIN (SELECT partitions.[object_id], partitions.index_id, COUNT(DISTINCT partitions.partition_number) AS partition_count FROM sys.partitions partitions GROUP BY partitions.[object_id], partitions.index_id) IndexPartitions ON partitions.[object_id] = IndexPartitions.[object_id] AND partitions.[index_id] = IndexPartitions.[index_id]'
          END

          SET @CurrentCommand = @CurrentCommand + ' WHERE objects.[type] IN(''U'',''V'')'
                                                    + CASE WHEN @MSShippedObjects = 'N' THEN ' AND objects.is_ms_shipped = 0' ELSE '' END
                                                    + ' AND indexes.[type] IN(1,2,3,4,5,6,7)'
                                                    + ' AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0'
        END

        IF (EXISTS(SELECT * FROM @ActionsPreferred) AND @UpdateStatistics = 'COLUMNS') OR @UpdateStatistics = 'ALL'
        BEGIN
          SET @CurrentCommand = @CurrentCommand + ' UNION '
        END

        IF @UpdateStatistics IN('ALL','COLUMNS')
        BEGIN
          SET @CurrentCommand = @CurrentCommand + 'SELECT schemas.[schema_id] AS SchemaID'
                                                    + ', schemas.[name] AS SchemaName'
                                                    + ', objects.[object_id] AS ObjectID'
                                                    + ', objects.[name] AS ObjectName'
                                                    + ', RTRIM(objects.[type]) AS ObjectType'
                                                    + ', ' + CASE WHEN @Version >= 12 THEN 'tables.is_memory_optimized' ELSE '0' END + ' AS IsMemoryOptimized'
                                                    + ', NULL AS IndexID, NULL AS IndexName'
                                                    + ', NULL AS IndexType'
                                                    + ', NULL AS AllowPageLocks'
                                                    + ', NULL AS IsImageText'
                                                    + ', NULL AS IsNewLOB'
                                                    + ', NULL AS IsFileStream'
                                                    + ', NULL AS IsColumnStore'
                                                    + ', NULL AS IsComputed'
                                                    + ', NULL AS IsTimestamp'
                                                    + ', NULL AS OnReadOnlyFileGroup'
                                                    + ', NULL AS ResumableIndexOperation'
                                                    + ', stats.stats_id AS StatisticsID'
                                                    + ', stats.name AS StatisticsName'
                                                    + ', stats.no_recompute AS NoRecompute'
                                                    + ', ' + CASE WHEN @Version >= 12 THEN 'stats.is_incremental' ELSE '0' END + ' AS IsIncremental'
                                                    + ', NULL AS PartitionID'
                                                    + ', ' + CASE WHEN @PartitionLevelStatistics = 1 THEN 'dm_db_incremental_stats_properties.partition_number' ELSE 'NULL' END + ' AS PartitionNumber'
                                                    + ', NULL AS PartitionCount'
                                                    + ', 0 AS [Order]'
                                                    + ', 0 AS Selected'
                                                    + ', 0 AS Completed'
                                                    + ' FROM sys.stats stats'
                                                    + ' INNER JOIN sys.objects objects ON stats.[object_id] = objects.[object_id]'
                                                    + ' INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id]'
                                                    + ' LEFT OUTER JOIN sys.tables tables ON objects.[object_id] = tables.[object_id]'

          IF @PartitionLevelStatistics = 1
          BEGIN
            SET @CurrentCommand = @CurrentCommand + ' OUTER APPLY sys.dm_db_incremental_stats_properties(stats.object_id, stats.stats_id) dm_db_incremental_stats_properties'
          END

          SET @CurrentCommand = @CurrentCommand + ' WHERE objects.[type] IN(''U'',''V'')'
                                                    + CASE WHEN @MSShippedObjects = 'N' THEN ' AND objects.is_ms_shipped = 0' ELSE '' END
                                                    + ' AND NOT EXISTS(SELECT * FROM sys.indexes indexes WHERE indexes.[object_id] = stats.[object_id] AND indexes.index_id = stats.stats_id)'
        END

        SET @CurrentCommand = @CurrentCommand + ') IndexesStatistics'

        INSERT INTO @tmpIndexesStatistics (SchemaID, SchemaName, ObjectID, ObjectName, ObjectType, IsMemoryOptimized, IndexID, IndexName, IndexType, AllowPageLocks, IsImageText, IsNewLOB, IsFileStream, IsColumnStore, IsComputed, IsTimestamp, OnReadOnlyFileGroup, ResumableIndexOperation, StatisticsID, StatisticsName, [NoRecompute], IsIncremental, PartitionID, PartitionNumber, PartitionCount, [Order], Selected, Completed)
        EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand
        SET @Error = @@ERROR
        IF @Error <> 0
        BEGIN
          SET @ReturnCode = @Error
        END
      END

      IF @Indexes IS NULL
      BEGIN
        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.Selected = 1
        FROM @tmpIndexesStatistics tmpIndexesStatistics
      END
      ELSE
      BEGIN
        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.Selected = SelectedIndexes.Selected
        FROM @tmpIndexesStatistics tmpIndexesStatistics
        INNER JOIN @SelectedIndexes SelectedIndexes
        ON @CurrentDatabaseName LIKE REPLACE(SelectedIndexes.DatabaseName,'_','[_]') AND tmpIndexesStatistics.SchemaName LIKE REPLACE(SelectedIndexes.SchemaName,'_','[_]') AND tmpIndexesStatistics.ObjectName LIKE REPLACE(SelectedIndexes.ObjectName,'_','[_]') AND COALESCE(tmpIndexesStatistics.IndexName,tmpIndexesStatistics.StatisticsName) LIKE REPLACE(SelectedIndexes.IndexName,'_','[_]')
        WHERE SelectedIndexes.Selected = 1

        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.Selected = SelectedIndexes.Selected
        FROM @tmpIndexesStatistics tmpIndexesStatistics
        INNER JOIN @SelectedIndexes SelectedIndexes
        ON @CurrentDatabaseName LIKE REPLACE(SelectedIndexes.DatabaseName,'_','[_]') AND tmpIndexesStatistics.SchemaName LIKE REPLACE(SelectedIndexes.SchemaName,'_','[_]') AND tmpIndexesStatistics.ObjectName LIKE REPLACE(SelectedIndexes.ObjectName,'_','[_]') AND COALESCE(tmpIndexesStatistics.IndexName,tmpIndexesStatistics.StatisticsName) LIKE REPLACE(SelectedIndexes.IndexName,'_','[_]')
        WHERE SelectedIndexes.Selected = 0

        UPDATE tmpIndexesStatistics
        SET tmpIndexesStatistics.StartPosition = SelectedIndexes2.StartPosition
        FROM @tmpIndexesStatistics tmpIndexesStatistics
        INNER JOIN (SELECT tmpIndexesStatistics.SchemaName, tmpIndexesStatistics.ObjectName, tmpIndexesStatistics.IndexName, tmpIndexesStatistics.StatisticsName, MIN(SelectedIndexes.StartPosition) AS StartPosition
                    FROM @tmpIndexesStatistics tmpIndexesStatistics
                    INNER JOIN @SelectedIndexes SelectedIndexes
                    ON @CurrentDatabaseName LIKE REPLACE(SelectedIndexes.DatabaseName,'_','[_]') AND tmpIndexesStatistics.SchemaName LIKE REPLACE(SelectedIndexes.SchemaName,'_','[_]') AND tmpIndexesStatistics.ObjectName LIKE REPLACE(SelectedIndexes.ObjectName,'_','[_]') AND COALESCE(tmpIndexesStatistics.IndexName,tmpIndexesStatistics.StatisticsName) LIKE REPLACE(SelectedIndexes.IndexName,'_','[_]')
                    WHERE SelectedIndexes.Selected = 1
                    GROUP BY tmpIndexesStatistics.SchemaName, tmpIndexesStatistics.ObjectName, tmpIndexesStatistics.IndexName, tmpIndexesStatistics.StatisticsName) SelectedIndexes2
        ON tmpIndexesStatistics.SchemaName = SelectedIndexes2.SchemaName
        AND tmpIndexesStatistics.ObjectName = SelectedIndexes2.ObjectName
        AND (tmpIndexesStatistics.IndexName = SelectedIndexes2.IndexName OR tmpIndexesStatistics.IndexName IS NULL)
        AND (tmpIndexesStatistics.StatisticsName = SelectedIndexes2.StatisticsName OR tmpIndexesStatistics.StatisticsName IS NULL)
      END;

      WITH tmpIndexesStatistics AS (
      SELECT SchemaName, ObjectName, [Order], ROW_NUMBER() OVER (ORDER BY ISNULL(ResumableIndexOperation,0) DESC, StartPosition ASC, SchemaName ASC, ObjectName ASC, CASE WHEN IndexType IS NULL THEN 1 ELSE 0 END ASC, IndexType ASC, IndexName ASC, StatisticsName ASC, PartitionNumber ASC) AS RowNumber
      FROM @tmpIndexesStatistics tmpIndexesStatistics
      WHERE Selected = 1
      )
      UPDATE tmpIndexesStatistics
      SET [Order] = RowNumber

      SET @ErrorMessage = ''
      SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + '.' + QUOTENAME(SchemaName) + '.' + QUOTENAME(ObjectName) + ', '
      FROM @SelectedIndexes SelectedIndexes
      WHERE DatabaseName = @CurrentDatabaseName
      AND SchemaName NOT LIKE '%[%]%'
      AND ObjectName NOT LIKE '%[%]%'
      AND IndexName LIKE '%[%]%'
      AND NOT EXISTS (SELECT * FROM @tmpIndexesStatistics WHERE SchemaName = SelectedIndexes.SchemaName AND ObjectName = SelectedIndexes.ObjectName)
      IF @@ROWCOUNT > 0
      BEGIN
        SET @ErrorMessage = 'The following objects in the @Indexes parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.'
        RAISERROR('%s',10,1,@ErrorMessage) WITH NOWAIT
        SET @Error = @@ERROR
        RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      END

      SET @ErrorMessage = ''
      SELECT @ErrorMessage = @ErrorMessage + QUOTENAME(DatabaseName) + QUOTENAME(SchemaName) + '.' + QUOTENAME(ObjectName) + '.' + QUOTENAME(IndexName) + ', '
      FROM @SelectedIndexes SelectedIndexes
      WHERE DatabaseName = @CurrentDatabaseName
      AND SchemaName NOT LIKE '%[%]%'
      AND ObjectName NOT LIKE '%[%]%'
      AND IndexName NOT LIKE '%[%]%'
      AND NOT EXISTS (SELECT * FROM @tmpIndexesStatistics WHERE SchemaName = SelectedIndexes.SchemaName AND ObjectName = SelectedIndexes.ObjectName AND IndexName = SelectedIndexes.IndexName)
      IF @@ROWCOUNT > 0
      BEGIN
        SET @ErrorMessage = 'The following indexes in the @Indexes parameter do not exist: ' + LEFT(@ErrorMessage,LEN(@ErrorMessage)-1) + '.'
        RAISERROR('%s',10,1,@ErrorMessage) WITH NOWAIT
        SET @Error = @@ERROR
        RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      END

      WHILE (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
      BEGIN
        SELECT TOP 1 @CurrentIxID = ID,
                     @CurrentIxOrder = [Order],
                     @CurrentSchemaID = SchemaID,
                     @CurrentSchemaName = SchemaName,
                     @CurrentObjectID = ObjectID,
                     @CurrentObjectName = ObjectName,
                     @CurrentObjectType = ObjectType,
                     @CurrentIsMemoryOptimized = IsMemoryOptimized,
                     @CurrentIndexID = IndexID,
                     @CurrentIndexName = IndexName,
                     @CurrentIndexType = IndexType,
                     @CurrentAllowPageLocks = AllowPageLocks,
                     @CurrentIsImageText = IsImageText,
                     @CurrentIsNewLOB = IsNewLOB,
                     @CurrentIsFileStream = IsFileStream,
                     @CurrentIsColumnStore = IsColumnStore,
                     @CurrentIsComputed = IsComputed,
                     @CurrentIsTimestamp = IsTimestamp,
                     @CurrentOnReadOnlyFileGroup = OnReadOnlyFileGroup,
                     @CurrentResumableIndexOperation = ResumableIndexOperation,
                     @CurrentStatisticsID = StatisticsID,
                     @CurrentStatisticsName = StatisticsName,
                     @CurrentNoRecompute = [NoRecompute],
                     @CurrentIsIncremental = IsIncremental,
                     @CurrentPartitionID = PartitionID,
                     @CurrentPartitionNumber = PartitionNumber,
                     @CurrentPartitionCount = PartitionCount
        FROM @tmpIndexesStatistics
        WHERE Selected = 1
        AND Completed = 0
        ORDER BY [Order] ASC

        IF @@ROWCOUNT = 0
        BEGIN
          BREAK
        END

        -- Is the index a partition?
        IF @CurrentPartitionNumber IS NULL OR @CurrentPartitionCount = 1 BEGIN SET @CurrentIsPartition = 0 END ELSE BEGIN SET @CurrentIsPartition = 1 END

        -- Does the index exist?
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentCommand = ''

          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '

          IF @CurrentIsPartition = 0 SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.indexes indexes INNER JOIN sys.objects objects ON indexes.[object_id] = objects.[object_id] INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] IN(''U'',''V'') AND indexes.[type] IN(1,2,3,4,5,6,7) AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0 AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND indexes.index_id = @ParamIndexID AND indexes.[name] = @ParamIndexName AND indexes.[type] = @ParamIndexType) BEGIN SET @ParamIndexExists = 1 END'
          IF @CurrentIsPartition = 1 SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.indexes indexes INNER JOIN sys.objects objects ON indexes.[object_id] = objects.[object_id] INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] INNER JOIN sys.partitions partitions ON indexes.[object_id] = partitions.[object_id] AND indexes.index_id = partitions.index_id WHERE objects.[type] IN(''U'',''V'') AND indexes.[type] IN(1,2,3,4,5,6,7) AND indexes.is_disabled = 0 AND indexes.is_hypothetical = 0 AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND indexes.index_id = @ParamIndexID AND indexes.[name] = @ParamIndexName AND indexes.[type] = @ParamIndexType AND partitions.partition_id = @ParamPartitionID AND partitions.partition_number = @ParamPartitionNumber) BEGIN SET @ParamIndexExists = 1 END'

          BEGIN TRY
            EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamSchemaID int, @ParamSchemaName sysname, @ParamObjectID int, @ParamObjectName sysname, @ParamObjectType sysname, @ParamIndexID int, @ParamIndexName sysname, @ParamIndexType int, @ParamPartitionID bigint, @ParamPartitionNumber int, @ParamIndexExists bit OUTPUT', @ParamSchemaID = @CurrentSchemaID, @ParamSchemaName = @CurrentSchemaName, @ParamObjectID = @CurrentObjectID, @ParamObjectName = @CurrentObjectName, @ParamObjectType = @CurrentObjectType, @ParamIndexID = @CurrentIndexID, @ParamIndexName = @CurrentIndexName, @ParamIndexType = @CurrentIndexType, @ParamPartitionID = @CurrentPartitionID, @ParamPartitionNumber = @CurrentPartitionNumber, @ParamIndexExists = @CurrentIndexExists OUTPUT

            IF @CurrentIndexExists IS NULL
            BEGIN
              SET @CurrentIndexExists = 0
              GOTO NoAction
            END
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ' The index ' + QUOTENAME(@CurrentIndexName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the index exists.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END

            GOTO NoAction
          END CATCH
        END

        -- Does the statistics exist?
        IF @CurrentStatisticsID IS NOT NULL AND @UpdateStatistics IS NOT NULL
        BEGIN
          SET @CurrentCommand = ''

          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '

          SET @CurrentCommand += 'IF EXISTS(SELECT * FROM sys.stats stats INNER JOIN sys.objects objects ON stats.[object_id] = objects.[object_id] INNER JOIN sys.schemas schemas ON objects.[schema_id] = schemas.[schema_id] WHERE objects.[type] IN(''U'',''V'')' + CASE WHEN @MSShippedObjects = 'N' THEN ' AND objects.is_ms_shipped = 0' ELSE '' END + ' AND schemas.[schema_id] = @ParamSchemaID AND schemas.[name] = @ParamSchemaName AND objects.[object_id] = @ParamObjectID AND objects.[name] = @ParamObjectName AND objects.[type] = @ParamObjectType AND stats.stats_id = @ParamStatisticsID AND stats.[name] = @ParamStatisticsName) BEGIN SET @ParamStatisticsExists = 1 END'

          BEGIN TRY
            EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamSchemaID int, @ParamSchemaName sysname, @ParamObjectID int, @ParamObjectName sysname, @ParamObjectType sysname, @ParamStatisticsID int, @ParamStatisticsName sysname, @ParamStatisticsExists bit OUTPUT', @ParamSchemaID = @CurrentSchemaID, @ParamSchemaName = @CurrentSchemaName, @ParamObjectID = @CurrentObjectID, @ParamObjectName = @CurrentObjectName, @ParamObjectType = @CurrentObjectType, @ParamStatisticsID = @CurrentStatisticsID, @ParamStatisticsName = @CurrentStatisticsName, @ParamStatisticsExists = @CurrentStatisticsExists OUTPUT

            IF @CurrentStatisticsExists IS NULL
            BEGIN
              SET @CurrentStatisticsExists = 0
              GOTO NoAction
            END
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ' The statistics ' + QUOTENAME(@CurrentStatisticsName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. It could not be checked if the statistics exists.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END

            GOTO NoAction
          END CATCH
        END

        -- Has the data in the statistics been modified since the statistics was last updated?
        IF @CurrentStatisticsID IS NOT NULL AND @UpdateStatistics IS NOT NULL
        BEGIN
          SET @CurrentCommand = ''

          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '

          IF @PartitionLevelStatistics = 1 AND @CurrentIsIncremental = 1
          BEGIN
            SET @CurrentCommand += 'SELECT @ParamRowCount = [rows], @ParamModificationCounter = modification_counter FROM sys.dm_db_incremental_stats_properties (@ParamObjectID, @ParamStatisticsID) WHERE partition_number = @ParamPartitionNumber'
          END
          ELSE
          IF (@Version >= 10.504000 AND @Version < 11) OR @Version >= 11.03000
          BEGIN
            SET @CurrentCommand += 'SELECT @ParamRowCount = [rows], @ParamModificationCounter = modification_counter FROM sys.dm_db_stats_properties (@ParamObjectID, @ParamStatisticsID)'
          END
          ELSE
          BEGIN
            SET @CurrentCommand += 'SELECT @ParamRowCount = rowcnt, @ParamModificationCounter = rowmodctr FROM sys.sysindexes sysindexes WHERE sysindexes.[id] = @ParamObjectID AND sysindexes.[indid] = @ParamStatisticsID'
          END

          BEGIN TRY
            EXECUTE @CurrentDatabase_sp_executesql @stmt = @CurrentCommand, @params = N'@ParamObjectID int, @ParamStatisticsID int, @ParamPartitionNumber int, @ParamRowCount bigint OUTPUT, @ParamModificationCounter bigint OUTPUT', @ParamObjectID = @CurrentObjectID, @ParamStatisticsID = @CurrentStatisticsID, @ParamPartitionNumber = @CurrentPartitionNumber, @ParamRowCount = @CurrentRowCount OUTPUT, @ParamModificationCounter = @CurrentModificationCounter OUTPUT

            IF @CurrentRowCount IS NULL SET @CurrentRowCount = 0
            IF @CurrentModificationCounter IS NULL SET @CurrentModificationCounter = 0
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ' The statistics ' + QUOTENAME(@CurrentStatisticsName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. The rows and modification_counter could not be checked.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END

            GOTO NoAction
          END CATCH
        END

        -- Is the index fragmented?
        IF @CurrentIndexID IS NOT NULL
        AND @CurrentOnReadOnlyFileGroup = 0
        AND EXISTS(SELECT * FROM @ActionsPreferred)
        AND (EXISTS(SELECT [Priority], [Action], COUNT(*) FROM @ActionsPreferred GROUP BY [Priority], [Action] HAVING COUNT(*) <> 3) OR @MinNumberOfPages > 0 OR @MaxNumberOfPages IS NOT NULL)
        BEGIN
          SET @CurrentCommand = ''

          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '

          SET @CurrentCommand += 'SELECT @ParamFragmentationLevel = MAX(avg_fragmentation_in_percent), @ParamPageCount = SUM(page_count) FROM sys.dm_db_index_physical_stats(DB_ID(@ParamDatabaseName), @ParamObjectID, @ParamIndexID, @ParamPartitionNumber, ''LIMITED'') WHERE alloc_unit_type_desc = ''IN_ROW_DATA'' AND index_level = 0'

          BEGIN TRY
            EXECUTE sp_executesql @stmt = @CurrentCommand, @params = N'@ParamDatabaseName nvarchar(max), @ParamObjectID int, @ParamIndexID int, @ParamPartitionNumber int, @ParamFragmentationLevel float OUTPUT, @ParamPageCount bigint OUTPUT', @ParamDatabaseName = @CurrentDatabaseName, @ParamObjectID = @CurrentObjectID, @ParamIndexID = @CurrentIndexID, @ParamPartitionNumber = @CurrentPartitionNumber, @ParamFragmentationLevel = @CurrentFragmentationLevel OUTPUT, @ParamPageCount = @CurrentPageCount OUTPUT
          END TRY
          BEGIN CATCH
            SET @ErrorMessage = 'Msg ' + CAST(ERROR_NUMBER() AS nvarchar) + ', ' + ISNULL(ERROR_MESSAGE(),'') + CASE WHEN ERROR_NUMBER() = 1222 THEN ' The index ' + QUOTENAME(@CurrentIndexName) + ' on the object ' + QUOTENAME(@CurrentDatabaseName) + '.' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' is locked. The page_count and avg_fragmentation_in_percent could not be checked.' ELSE '' END
            SET @Severity = CASE WHEN ERROR_NUMBER() IN(1205,1222) THEN @LockMessageSeverity ELSE 16 END
            RAISERROR('%s',@Severity,1,@ErrorMessage) WITH NOWAIT
            RAISERROR(@EmptyLine,10,1) WITH NOWAIT

            IF NOT (ERROR_NUMBER() IN(1205,1222) AND @LockMessageSeverity = 10)
            BEGIN
              SET @ReturnCode = ERROR_NUMBER()
            END

            GOTO NoAction
          END CATCH
        END

        -- Select fragmentation group
        IF @CurrentIndexID IS NOT NULL AND @CurrentOnReadOnlyFileGroup = 0 AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          SET @CurrentFragmentationGroup = CASE
          WHEN @CurrentFragmentationLevel >= @FragmentationLevel2 THEN 'High'
          WHEN @CurrentFragmentationLevel >= @FragmentationLevel1 AND @CurrentFragmentationLevel < @FragmentationLevel2 THEN 'Medium'
          WHEN @CurrentFragmentationLevel < @FragmentationLevel1 THEN 'Low'
          END
        END

        -- Which actions are allowed?
        IF @CurrentIndexID IS NOT NULL AND EXISTS(SELECT * FROM @ActionsPreferred)
        BEGIN
          IF @CurrentOnReadOnlyFileGroup = 0 AND @CurrentIndexType IN (1,2,3,4,5) AND (@CurrentIsMemoryOptimized = 0 OR @CurrentIsMemoryOptimized IS NULL) AND (@CurrentAllowPageLocks = 1 OR @CurrentIndexType = 5)
          BEGIN
            INSERT INTO @CurrentActionsAllowed ([Action])
            VALUES ('INDEX_REORGANIZE')
          END
          IF @CurrentOnReadOnlyFileGroup = 0 AND @CurrentIndexType IN (1,2,3,4,5) AND (@CurrentIsMemoryOptimized = 0 OR @CurrentIsMemoryOptimized IS NULL)
          BEGIN
            INSERT INTO @CurrentActionsAllowed ([Action])
            VALUES ('INDEX_REBUILD_OFFLINE')
          END
          IF @CurrentOnReadOnlyFileGroup = 0
          AND (@CurrentIsMemoryOptimized = 0 OR @CurrentIsMemoryOptimized IS NULL)
          AND (@CurrentIsPartition = 0 OR @Version >= 12)
          AND ((@CurrentIndexType = 1 AND @CurrentIsImageText = 0 AND @CurrentIsNewLOB = 0)
          OR (@CurrentIndexType = 2 AND @CurrentIsNewLOB = 0)
          OR (@CurrentIndexType = 1 AND @CurrentIsImageText = 0 AND @CurrentIsFileStream = 0 AND @Version >= 11)
          OR (@CurrentIndexType = 2 AND @Version >= 11))
          AND (@CurrentIsColumnStore = 0 OR @Version < 11)
          AND SERVERPROPERTY('EngineEdition') IN (3,5,8)
          BEGIN
            INSERT INTO @CurrentActionsAllowed ([Action])
            VALUES ('INDEX_REBUILD_ONLINE')
          END
        END

        -- Decide action
        IF @CurrentIndexID IS NOT NULL
        AND EXISTS(SELECT * FROM @ActionsPreferred)
        AND (@CurrentPageCount >= @MinNumberOfPages OR @MinNumberOfPages = 0)
        AND (@CurrentPageCount <= @MaxNumberOfPages OR @MaxNumberOfPages IS NULL)
        AND @CurrentResumableIndexOperation = 0
        BEGIN
          IF EXISTS(SELECT [Priority], [Action], COUNT(*) FROM @ActionsPreferred GROUP BY [Priority], [Action] HAVING COUNT(*) <> 3)
          BEGIN
            SELECT @CurrentAction = [Action]
            FROM @ActionsPreferred
            WHERE FragmentationGroup = @CurrentFragmentationGroup
            AND [Priority] = (SELECT MIN([Priority])
                              FROM @ActionsPreferred
                              WHERE FragmentationGroup = @CurrentFragmentationGroup
                              AND [Action] IN (SELECT [Action] FROM @CurrentActionsAllowed))
          END
          ELSE
          BEGIN
            SELECT @CurrentAction = [Action]
            FROM @ActionsPreferred
            WHERE [Priority] = (SELECT MIN([Priority])
                                FROM @ActionsPreferred
                                WHERE [Action] IN (SELECT [Action] FROM @CurrentActionsAllowed))
          END
        END

        IF @CurrentResumableIndexOperation = 1
        BEGIN
          SET @CurrentAction = 'INDEX_REBUILD_ONLINE'
        END

        -- Workaround for limitation in SQL Server, http://support.microsoft.com/kb/2292737
        IF @CurrentIndexID IS NOT NULL
        BEGIN
          SET @CurrentMaxDOP = @MaxDOP

          IF @CurrentAction = 'INDEX_REBUILD_ONLINE' AND @CurrentAllowPageLocks = 0
          BEGIN
            SET @CurrentMaxDOP = 1
          END
        END

        -- Update statistics?
        IF @CurrentStatisticsID IS NOT NULL
        AND ((@UpdateStatistics = 'ALL' AND (@CurrentIndexType IN (1,2,3,4,7) OR @CurrentIndexID IS NULL)) OR (@UpdateStatistics = 'INDEX' AND @CurrentIndexID IS NOT NULL AND @CurrentIndexType IN (1,2,3,4,7)) OR (@UpdateStatistics = 'COLUMNS' AND @CurrentIndexID IS NULL))
        AND ((@OnlyModifiedStatistics = 'N' AND @StatisticsModificationLevel IS NULL) OR (@OnlyModifiedStatistics = 'Y' AND @CurrentModificationCounter > 0) OR ((@CurrentModificationCounter * 1. / NULLIF(@CurrentRowCount,0)) * 100 >= @StatisticsModificationLevel) OR (@StatisticsModificationLevel IS NOT NULL AND @CurrentModificationCounter > 0 AND (@CurrentModificationCounter >= SQRT(@CurrentRowCount * 1000))) OR (@CurrentIsMemoryOptimized = 1 AND NOT (@Version >= 13 OR SERVERPROPERTY('EngineEdition') IN (5,8))))
        AND ((@CurrentIsPartition = 0 AND (@CurrentAction NOT IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') OR @CurrentAction IS NULL)) OR (@CurrentIsPartition = 1 AND (@CurrentPartitionNumber = @CurrentPartitionCount OR (@PartitionLevelStatistics = 1 AND @CurrentIsIncremental = 1))))
        BEGIN
          SET @CurrentUpdateStatistics = 'Y'
        END
        ELSE
        BEGIN
          SET @CurrentUpdateStatistics = 'N'
        END

        SET @CurrentStatisticsSample = @StatisticsSample
        SET @CurrentStatisticsResample = @StatisticsResample

        -- Memory-optimized tables only supports FULLSCAN and RESAMPLE in SQL Server 2014
        IF @CurrentIsMemoryOptimized = 1 AND NOT (@Version >= 13 OR SERVERPROPERTY('EngineEdition') IN (5,8)) AND (@CurrentStatisticsSample <> 100 OR @CurrentStatisticsSample IS NULL)
        BEGIN
          SET @CurrentStatisticsSample = NULL
          SET @CurrentStatisticsResample = 'Y'
        END

        -- Incremental statistics only supports RESAMPLE
        IF @PartitionLevelStatistics = 1 AND @CurrentIsIncremental = 1
        BEGIN
          SET @CurrentStatisticsSample = NULL
          SET @CurrentStatisticsResample = 'Y'
        END

        -- Create index comment
        IF @CurrentIndexID IS NOT NULL
        BEGIN
          SET @CurrentComment = 'ObjectType: ' + CASE WHEN @CurrentObjectType = 'U' THEN 'Table' WHEN @CurrentObjectType = 'V' THEN 'View' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'IndexType: ' + CASE WHEN @CurrentIndexType = 1 THEN 'Clustered' WHEN @CurrentIndexType = 2 THEN 'NonClustered' WHEN @CurrentIndexType = 3 THEN 'XML' WHEN @CurrentIndexType = 4 THEN 'Spatial' WHEN @CurrentIndexType = 5 THEN 'Clustered Columnstore' WHEN @CurrentIndexType = 6 THEN 'NonClustered Columnstore' WHEN @CurrentIndexType = 7 THEN 'NonClustered Hash' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'ImageText: ' + CASE WHEN @CurrentIsImageText = 1 THEN 'Yes' WHEN @CurrentIsImageText = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'NewLOB: ' + CASE WHEN @CurrentIsNewLOB = 1 THEN 'Yes' WHEN @CurrentIsNewLOB = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'FileStream: ' + CASE WHEN @CurrentIsFileStream = 1 THEN 'Yes' WHEN @CurrentIsFileStream = 0 THEN 'No' ELSE 'N/A' END + ', '
          IF @Version >= 11 SET @CurrentComment += 'ColumnStore: ' + CASE WHEN @CurrentIsColumnStore = 1 THEN 'Yes' WHEN @CurrentIsColumnStore = 0 THEN 'No' ELSE 'N/A' END + ', '
          IF @Version >= 14 AND @Resumable = 'Y' SET @CurrentComment += 'Computed: ' + CASE WHEN @CurrentIsComputed = 1 THEN 'Yes' WHEN @CurrentIsComputed = 0 THEN 'No' ELSE 'N/A' END + ', '
          IF @Version >= 14 AND @Resumable = 'Y' SET @CurrentComment += 'Timestamp: ' + CASE WHEN @CurrentIsTimestamp = 1 THEN 'Yes' WHEN @CurrentIsTimestamp = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'AllowPageLocks: ' + CASE WHEN @CurrentAllowPageLocks = 1 THEN 'Yes' WHEN @CurrentAllowPageLocks = 0 THEN 'No' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'PageCount: ' + ISNULL(CAST(@CurrentPageCount AS nvarchar),'N/A') + ', '
          SET @CurrentComment += 'Fragmentation: ' + ISNULL(CAST(@CurrentFragmentationLevel AS nvarchar),'N/A')
        END

        IF @CurrentIndexID IS NOT NULL AND (@CurrentPageCount IS NOT NULL OR @CurrentFragmentationLevel IS NOT NULL)
        BEGIN
        SET @CurrentExtendedInfo = (SELECT *
                                    FROM (SELECT CAST(@CurrentPageCount AS nvarchar) AS [PageCount],
                                                 CAST(@CurrentFragmentationLevel AS nvarchar) AS Fragmentation
                                    ) ExtendedInfo FOR XML RAW('ExtendedInfo'), ELEMENTS)
        END

        IF @CurrentIndexID IS NOT NULL AND @CurrentAction IS NOT NULL AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
        BEGIN
          SET @CurrentDatabaseContext = @CurrentDatabaseName

          SET @CurrentCommandType = 'ALTER_INDEX'

          SET @CurrentCommand = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand += 'ALTER INDEX ' + QUOTENAME(@CurrentIndexName) + ' ON ' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName)
          IF @CurrentResumableIndexOperation = 1 SET @CurrentCommand += ' RESUME'
          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @CurrentResumableIndexOperation = 0 SET @CurrentCommand += ' REBUILD'
          IF @CurrentAction IN('INDEX_REORGANIZE') AND @CurrentResumableIndexOperation = 0 SET @CurrentCommand += ' REORGANIZE'
          IF @CurrentIsPartition = 1 AND @CurrentResumableIndexOperation = 0 SET @CurrentCommand += ' PARTITION = ' + CAST(@CurrentPartitionNumber AS nvarchar)

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @SortInTempdb = 'Y' AND @CurrentIndexType IN(1,2,3,4) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'SORT_IN_TEMPDB = ON'
          END

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @SortInTempdb = 'N' AND @CurrentIndexType IN(1,2,3,4) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'SORT_IN_TEMPDB = OFF'
          END

          IF @CurrentAction = 'INDEX_REBUILD_ONLINE' AND (@CurrentIsPartition = 0 OR @Version >= 12) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'ONLINE = ON' + CASE WHEN @WaitAtLowPriorityMaxDuration IS NOT NULL THEN ' (WAIT_AT_LOW_PRIORITY (MAX_DURATION = ' + CAST(@WaitAtLowPriorityMaxDuration AS nvarchar) + ', ABORT_AFTER_WAIT = ' + UPPER(@WaitAtLowPriorityAbortAfterWait) + '))' ELSE '' END
          END

          IF @CurrentAction = 'INDEX_REBUILD_OFFLINE' AND (@CurrentIsPartition = 0 OR @Version >= 12) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'ONLINE = OFF'
          END

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @CurrentMaxDOP IS NOT NULL
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'MAXDOP = ' + CAST(@CurrentMaxDOP AS nvarchar)
          END

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @FillFactor IS NOT NULL AND @CurrentIsPartition = 0 AND @CurrentIndexType IN(1,2,3,4) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'FILLFACTOR = ' + CAST(@FillFactor AS nvarchar)
          END

          IF @CurrentAction IN('INDEX_REBUILD_ONLINE','INDEX_REBUILD_OFFLINE') AND @PadIndex = 'Y' AND @CurrentIsPartition = 0 AND @CurrentIndexType IN(1,2,3,4) AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'PAD_INDEX = ON'
          END

          IF (@Version >= 14 OR SERVERPROPERTY('EngineEdition') IN (5,8)) AND @CurrentAction = 'INDEX_REBUILD_ONLINE' AND @CurrentResumableIndexOperation = 0
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT CASE WHEN @Resumable = 'Y' AND @CurrentIndexType IN(1,2) AND @CurrentIsComputed = 0 AND @CurrentIsTimestamp = 0 THEN 'RESUMABLE = ON' ELSE 'RESUMABLE = OFF' END
          END

          IF (@Version >= 14 OR SERVERPROPERTY('EngineEdition') IN (5,8)) AND @CurrentAction = 'INDEX_REBUILD_ONLINE' AND @CurrentResumableIndexOperation = 0 AND @Resumable = 'Y'  AND @CurrentIndexType IN(1,2) AND @CurrentIsComputed = 0 AND @CurrentIsTimestamp = 0 AND @TimeLimit IS NOT NULL
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'MAX_DURATION = ' + CAST(DATEDIFF(MINUTE,SYSDATETIME(),DATEADD(SECOND,@TimeLimit,@StartTime)) AS nvarchar(max))
          END

          IF @CurrentAction IN('INDEX_REORGANIZE') AND @LOBCompaction = 'Y'
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'LOB_COMPACTION = ON'
          END

          IF @CurrentAction IN('INDEX_REORGANIZE') AND @LOBCompaction = 'N'
          BEGIN
            INSERT INTO @CurrentAlterIndexWithClauseArguments (Argument)
            SELECT 'LOB_COMPACTION = OFF'
          END

          IF EXISTS (SELECT * FROM @CurrentAlterIndexWithClauseArguments)
          BEGIN
            SET @CurrentAlterIndexWithClause = ' WITH ('

            WHILE (1 = 1)
            BEGIN
              SELECT TOP 1 @CurrentAlterIndexArgumentID = ID,
                           @CurrentAlterIndexArgument = Argument
              FROM @CurrentAlterIndexWithClauseArguments
              WHERE Added = 0
              ORDER BY ID ASC

              IF @@ROWCOUNT = 0
              BEGIN
                BREAK
              END

              SET @CurrentAlterIndexWithClause += @CurrentAlterIndexArgument + ', '

              UPDATE @CurrentAlterIndexWithClauseArguments
              SET Added = 1
              WHERE [ID] = @CurrentAlterIndexArgumentID
            END

            SET @CurrentAlterIndexWithClause = RTRIM(@CurrentAlterIndexWithClause)

            SET @CurrentAlterIndexWithClause = LEFT(@CurrentAlterIndexWithClause,LEN(@CurrentAlterIndexWithClause) - 1)

            SET @CurrentAlterIndexWithClause = @CurrentAlterIndexWithClause + ')'
          END

          IF @CurrentAlterIndexWithClause IS NOT NULL SET @CurrentCommand += @CurrentAlterIndexWithClause

          EXECUTE @CurrentCommandOutput = dba.CommandExecute @DatabaseContext = @CurrentDatabaseName, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 2, @Comment = @CurrentComment, @DatabaseName = @CurrentDatabaseName, @SchemaName = @CurrentSchemaName, @ObjectName = @CurrentObjectName, @ObjectType = @CurrentObjectType, @IndexName = @CurrentIndexName, @IndexType = @CurrentIndexType, @PartitionNumber = @CurrentPartitionNumber, @ExtendedInfo = @CurrentExtendedInfo, @LockMessageSeverity = @LockMessageSeverity, @ExecuteAsUser = @ExecuteAsUser, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput = @Error
          IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput

          IF @Delay > 0
          BEGIN
            SET @CurrentDelay = DATEADD(ss,@Delay,'1900-01-01')
            WAITFOR DELAY @CurrentDelay
          END
        END

        SET @CurrentMaxDOP = @MaxDOP

        -- Create statistics comment
        IF @CurrentStatisticsID IS NOT NULL
        BEGIN
          SET @CurrentComment = 'ObjectType: ' + CASE WHEN @CurrentObjectType = 'U' THEN 'Table' WHEN @CurrentObjectType = 'V' THEN 'View' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'IndexType: ' + CASE WHEN @CurrentIndexID IS NOT NULL THEN 'Index' ELSE 'Column' END + ', '
          IF @CurrentIndexID IS NOT NULL SET @CurrentComment += 'IndexType: ' + CASE WHEN @CurrentIndexType = 1 THEN 'Clustered' WHEN @CurrentIndexType = 2 THEN 'NonClustered' WHEN @CurrentIndexType = 3 THEN 'XML' WHEN @CurrentIndexType = 4 THEN 'Spatial' WHEN @CurrentIndexType = 5 THEN 'Clustered Columnstore' WHEN @CurrentIndexType = 6 THEN 'NonClustered Columnstore' WHEN @CurrentIndexType = 7 THEN 'NonClustered Hash' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'Incremental: ' + CASE WHEN @CurrentIsIncremental = 1 THEN 'Y' WHEN @CurrentIsIncremental = 0 THEN 'N' ELSE 'N/A' END + ', '
          SET @CurrentComment += 'RowCount: ' + ISNULL(CAST(@CurrentRowCount AS nvarchar),'N/A') + ', '
          SET @CurrentComment += 'ModificationCounter: ' + ISNULL(CAST(@CurrentModificationCounter AS nvarchar),'N/A')
        END

        IF @CurrentStatisticsID IS NOT NULL AND (@CurrentRowCount IS NOT NULL OR @CurrentModificationCounter IS NOT NULL)
        BEGIN
        SET @CurrentExtendedInfo = (SELECT *
                                    FROM (SELECT CAST(@CurrentRowCount AS nvarchar) AS [RowCount],
                                                 CAST(@CurrentModificationCounter AS nvarchar) AS ModificationCounter
                                    ) ExtendedInfo FOR XML RAW('ExtendedInfo'), ELEMENTS)
        END

        IF @CurrentStatisticsID IS NOT NULL AND @CurrentUpdateStatistics = 'Y' AND (SYSDATETIME() < DATEADD(SECOND,@TimeLimit,@StartTime) OR @TimeLimit IS NULL)
        BEGIN
          SET @CurrentDatabaseContext = @CurrentDatabaseName

          SET @CurrentCommandType = 'UPDATE_STATISTICS'

          SET @CurrentCommand = ''
          IF @LockTimeout IS NOT NULL SET @CurrentCommand = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS nvarchar) + '; '
          SET @CurrentCommand += 'UPDATE STATISTICS ' + QUOTENAME(@CurrentSchemaName) + '.' + QUOTENAME(@CurrentObjectName) + ' ' + QUOTENAME(@CurrentStatisticsName)

          IF @CurrentMaxDOP IS NOT NULL AND ((@Version >= 12.06024 AND @Version < 13) OR (@Version >= 13.05026 AND @Version < 14) OR @Version >= 14.030154)
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'MAXDOP = ' + CAST(@CurrentMaxDOP AS nvarchar)
          END

          IF @CurrentStatisticsSample = 100
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'FULLSCAN'
          END

          IF @CurrentStatisticsSample IS NOT NULL AND @CurrentStatisticsSample <> 100
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'SAMPLE ' + CAST(@CurrentStatisticsSample AS nvarchar) + ' PERCENT'
          END

          IF @CurrentStatisticsResample = 'Y'
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'RESAMPLE'
          END

          IF @CurrentNoRecompute = 1
          BEGIN
            INSERT INTO @CurrentUpdateStatisticsWithClauseArguments (Argument)
            SELECT 'NORECOMPUTE'
          END

          IF EXISTS (SELECT * FROM @CurrentUpdateStatisticsWithClauseArguments)
          BEGIN
            SET @CurrentUpdateStatisticsWithClause = ' WITH'

            WHILE (1 = 1)
            BEGIN
              SELECT TOP 1 @CurrentUpdateStatisticsArgumentID = ID,
                           @CurrentUpdateStatisticsArgument = Argument
              FROM @CurrentUpdateStatisticsWithClauseArguments
              WHERE Added = 0
              ORDER BY ID ASC

              IF @@ROWCOUNT = 0
              BEGIN
                BREAK
              END

              SET @CurrentUpdateStatisticsWithClause = @CurrentUpdateStatisticsWithClause + ' ' + @CurrentUpdateStatisticsArgument + ','

              UPDATE @CurrentUpdateStatisticsWithClauseArguments
              SET Added = 1
              WHERE [ID] = @CurrentUpdateStatisticsArgumentID
            END

            SET @CurrentUpdateStatisticsWithClause = LEFT(@CurrentUpdateStatisticsWithClause,LEN(@CurrentUpdateStatisticsWithClause) - 1)
          END

          IF @CurrentUpdateStatisticsWithClause IS NOT NULL SET @CurrentCommand += @CurrentUpdateStatisticsWithClause

          IF @PartitionLevelStatistics = 1 AND @CurrentIsIncremental = 1 AND @CurrentPartitionNumber IS NOT NULL SET @CurrentCommand += ' ON PARTITIONS(' + CAST(@CurrentPartitionNumber AS nvarchar(max)) + ')'

          EXECUTE @CurrentCommandOutput = dba.CommandExecute @DatabaseContext = @CurrentDatabaseName, @Command = @CurrentCommand, @CommandType = @CurrentCommandType, @Mode = 2, @Comment = @CurrentComment, @DatabaseName = @CurrentDatabaseName, @SchemaName = @CurrentSchemaName, @ObjectName = @CurrentObjectName, @ObjectType = @CurrentObjectType, @IndexName = @CurrentIndexName, @IndexType = @CurrentIndexType, @StatisticsName = @CurrentStatisticsName, @ExtendedInfo = @CurrentExtendedInfo, @LockMessageSeverity = @LockMessageSeverity, @ExecuteAsUser = @ExecuteAsUser, @LogToTable = @LogToTable, @Execute = @Execute
          SET @Error = @@ERROR
          IF @Error <> 0 SET @CurrentCommandOutput = @Error
          IF @CurrentCommandOutput <> 0 SET @ReturnCode = @CurrentCommandOutput
        END

        NoAction:

        -- Update that the index or statistics is completed
        UPDATE @tmpIndexesStatistics
        SET Completed = 1
        WHERE Selected = 1
        AND Completed = 0
        AND [Order] = @CurrentIxOrder
        AND ID = @CurrentIxID

        -- Clear variables
        SET @CurrentDatabaseContext = NULL

        SET @CurrentCommand = NULL
        SET @CurrentCommandOutput = NULL
        SET @CurrentCommandType = NULL
        SET @CurrentComment = NULL
        SET @CurrentExtendedInfo = NULL

        SET @CurrentIxID = NULL
        SET @CurrentIxOrder = NULL
        SET @CurrentSchemaID = NULL
        SET @CurrentSchemaName = NULL
        SET @CurrentObjectID = NULL
        SET @CurrentObjectName = NULL
        SET @CurrentObjectType = NULL
        SET @CurrentIsMemoryOptimized = NULL
        SET @CurrentIndexID = NULL
        SET @CurrentIndexName = NULL
        SET @CurrentIndexType = NULL
        SET @CurrentStatisticsID = NULL
        SET @CurrentStatisticsName = NULL
        SET @CurrentPartitionID = NULL
        SET @CurrentPartitionNumber = NULL
        SET @CurrentPartitionCount = NULL
        SET @CurrentIsPartition = NULL
        SET @CurrentIndexExists = NULL
        SET @CurrentStatisticsExists = NULL
        SET @CurrentIsImageText = NULL
        SET @CurrentIsNewLOB = NULL
        SET @CurrentIsFileStream = NULL
        SET @CurrentIsColumnStore = NULL
        SET @CurrentIsComputed = NULL
        SET @CurrentIsTimestamp = NULL
        SET @CurrentAllowPageLocks = NULL
        SET @CurrentNoRecompute = NULL
        SET @CurrentIsIncremental = NULL
        SET @CurrentRowCount = NULL
        SET @CurrentModificationCounter = NULL
        SET @CurrentOnReadOnlyFileGroup = NULL
        SET @CurrentResumableIndexOperation = NULL
        SET @CurrentFragmentationLevel = NULL
        SET @CurrentPageCount = NULL
        SET @CurrentFragmentationGroup = NULL
        SET @CurrentAction = NULL
        SET @CurrentMaxDOP = NULL
        SET @CurrentUpdateStatistics = NULL
        SET @CurrentStatisticsSample = NULL
        SET @CurrentStatisticsResample = NULL
        SET @CurrentAlterIndexArgumentID = NULL
        SET @CurrentAlterIndexArgument = NULL
        SET @CurrentAlterIndexWithClause = NULL
        SET @CurrentUpdateStatisticsArgumentID = NULL
        SET @CurrentUpdateStatisticsArgument = NULL
        SET @CurrentUpdateStatisticsWithClause = NULL

        DELETE FROM @CurrentActionsAllowed
        DELETE FROM @CurrentAlterIndexWithClauseArguments
        DELETE FROM @CurrentUpdateStatisticsWithClauseArguments

      END

    END

    IF @CurrentDatabaseState = 'SUSPECT'
    BEGIN
      SET @ErrorMessage = 'The database ' + QUOTENAME(@CurrentDatabaseName) + ' is in a SUSPECT state.'
      RAISERROR('%s',16,1,@ErrorMessage) WITH NOWAIT
      RAISERROR(@EmptyLine,10,1) WITH NOWAIT
      SET @Error = @@ERROR
    END

    -- Update that the database is completed
    IF @DatabasesInParallel = 'Y'
    BEGIN
      UPDATE dbo.QueueDatabase
      SET DatabaseEndTime = SYSDATETIME()
      WHERE QueueID = @QueueID
      AND DatabaseName = @CurrentDatabaseName
    END
    ELSE
    BEGIN
      UPDATE @tmpDatabases
      SET Completed = 1
      WHERE Selected = 1
      AND Completed = 0
      AND ID = @CurrentDBID
    END

    -- Clear variables
    SET @CurrentDBID = NULL
    SET @CurrentDatabaseName = NULL

    SET @CurrentDatabase_sp_executesql = NULL

    SET @CurrentExecuteAsUserExists = NULL
    SET @CurrentUserAccess = NULL
    SET @CurrentIsReadOnly = NULL
    SET @CurrentDatabaseState = NULL
    SET @CurrentInStandby = NULL
    SET @CurrentRecoveryModel = NULL

    SET @CurrentIsDatabaseAccessible = NULL
    SET @CurrentReplicaID = NULL
    SET @CurrentAvailabilityGroupID = NULL
    SET @CurrentAvailabilityGroup = NULL
    SET @CurrentAvailabilityGroupRole = NULL
    SET @CurrentDatabaseMirroringRole = NULL

    SET @CurrentCommand = NULL

    DELETE FROM @tmpIndexesStatistics

  END

  ----------------------------------------------------------------------------------------------------
  --// Log completing information                                                                 //--
  ----------------------------------------------------------------------------------------------------

  Logging:
  SET @EndMessage = 'Date and time: ' + CONVERT(nvarchar,SYSDATETIME(),120)
  RAISERROR('%s',10,1,@EndMessage) WITH NOWAIT

  RAISERROR(@EmptyLine,10,1) WITH NOWAIT

  IF @ReturnCode <> 0
  BEGIN
    RETURN @ReturnCode
  END

  ----------------------------------------------------------------------------------------------------

END

GO


/****** Object:  StoredProcedure [dba].[sp_BlitzIndex]    Script Date: 2/24/2021 6:49:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dba].[sp_BlitzIndex]
    @DatabaseName NVARCHAR(128) = NULL, /*Defaults to current DB if not specified*/
    @SchemaName NVARCHAR(128) = NULL, /*Requires table_name as well.*/
    @TableName NVARCHAR(128) = NULL,  /*Requires schema_name as well.*/
    @Mode TINYINT=0, /*0=Diagnose, 1=Summarize, 2=Index Usage Detail, 3=Missing Index Detail, 4=Diagnose Details*/
        /*Note:@Mode doesn't matter if you're specifying schema_name and @TableName.*/
    @Filter TINYINT = 0, /* 0=no filter (default). 1=No low-usage warnings for objects with 0 reads. 2=Only warn for objects >= 500MB */
        /*Note:@Filter doesn't do anything unless @Mode=0*/
    @SkipPartitions BIT	= 0,
    @SkipStatistics BIT	= 1,
    @GetAllDatabases BIT = 0,
    @BringThePain BIT = 0,
    @IgnoreDatabases NVARCHAR(MAX) = NULL, /* Comma-delimited list of databases you want to skip */
    @ThresholdMB INT = 250 /* Number of megabytes that an object must be before we include it in basic results */,
	@OutputType VARCHAR(20) = 'TABLE' ,
    @OutputServerName NVARCHAR(256) = NULL ,
    @OutputDatabaseName NVARCHAR(256) = NULL ,
    @OutputSchemaName NVARCHAR(256) = NULL ,
    @OutputTableName NVARCHAR(256) = NULL ,
	@IncludeInactiveIndexes BIT = 0 /* Will skip indexes with no reads or writes */,
    @ShowAllMissingIndexRequests BIT = 0 /*Will make all missing index requests show up*/,
	@SortOrder NVARCHAR(50) = NULL, /* Only affects @Mode = 2. */
	@SortDirection NVARCHAR(4) = 'DESC', /* Only affects @Mode = 2. */
    @Help TINYINT = 0,
	@Debug BIT = 0,
    @Version     VARCHAR(30) = NULL OUTPUT,
	@VersionDate DATETIME = NULL OUTPUT,
    @VersionCheckMode BIT = 0
WITH RECOMPILE
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT @Version = '8.01', @VersionDate = '20210222';
SET @OutputType  = UPPER(@OutputType);

IF(@VersionCheckMode = 1)
BEGIN
	RETURN;
END;

IF @Help = 1 
BEGIN
PRINT '
/*
sp_BlitzIndex from http://FirstResponderKit.org
	
This script analyzes the design and performance of your indexes.

To learn more, visit http://FirstResponderKit.org where you can download new
versions for free, watch training videos on how it works, get more info on
the findings, contribute your own code, and more.

Known limitations of this version:
 - Only Microsoft-supported versions of SQL Server. Sorry, 2005 and 2000.
 - Index create statements are just to give you a rough idea of the syntax. It includes filters and fillfactor.
 --        Example 1: index creates use ONLINE=? instead of ONLINE=ON / ONLINE=OFF. This is because it is important 
           for the user to understand if it is going to be offline and not just run a script.
 --        Example 2: they do not include all the options the index may have been created with (padding, compression
           filegroup/partition scheme etc.)
 --        (The compression and filegroup index create syntax is not trivial because it is set at the partition 
           level and is not trivial to code.)
 - Does not advise you about data modeling for clustered indexes and primary keys (primarily looks for signs of insanity.)

Unknown limitations of this version:
 - We knew them once, but we forgot.


MIT License

Copyright (c) 2021 Brent Ozar Unlimited

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
';
RETURN;
END;    /* @Help = 1 */

DECLARE @ScriptVersionName NVARCHAR(50);
DECLARE @DaysUptime NUMERIC(23,2);
DECLARE @DatabaseID INT;
DECLARE @ObjectID INT;
DECLARE @dsql NVARCHAR(MAX);
DECLARE @params NVARCHAR(MAX);
DECLARE @msg NVARCHAR(4000);
DECLARE @ErrorSeverity INT;
DECLARE @ErrorState INT;
DECLARE @Rowcount BIGINT;
DECLARE @SQLServerProductVersion NVARCHAR(128);
DECLARE @SQLServerEdition INT;
DECLARE @FilterMB INT;
DECLARE @collation NVARCHAR(256);
DECLARE @NumDatabases INT;
DECLARE @LineFeed NVARCHAR(5);
DECLARE @DaysUptimeInsertValue NVARCHAR(256);
DECLARE @DatabaseToIgnore NVARCHAR(MAX);
DECLARE @ColumnList NVARCHAR(MAX);

/* Let's get @SortOrder set to lower case here for comparisons later */
SET @SortOrder = REPLACE(LOWER(@SortOrder), N' ', N'_');
SET @SortDirection = LOWER(@SortDirection);

SET @LineFeed = CHAR(13) + CHAR(10);
SELECT @SQLServerProductVersion = CAST(SERVERPROPERTY('ProductVersion') AS NVARCHAR(128));
SELECT @SQLServerEdition =CAST(SERVERPROPERTY('EngineEdition') AS INT); /* We default to online index creates where EngineEdition=3*/
SET @FilterMB=250;
SELECT @ScriptVersionName = 'sp_BlitzIndex(TM) v' + @Version + ' - ' + DATENAME(MM, @VersionDate) + ' ' + RIGHT('0'+DATENAME(DD, @VersionDate),2) + ', ' + DATENAME(YY, @VersionDate);
SET @IgnoreDatabases = REPLACE(REPLACE(LTRIM(RTRIM(@IgnoreDatabases)), CHAR(10), ''), CHAR(13), '');

RAISERROR(N'Starting run. %s', 0,1, @ScriptVersionName) WITH NOWAIT;
																					
IF(@OutputType NOT IN ('TABLE','NONE'))
BEGIN
    RAISERROR('Invalid value for parameter @OutputType. Expected: (TABLE;NONE)',12,1);
    RETURN;
END;
                       
IF(@OutputType = 'NONE')
BEGIN
    IF(@OutputTableName IS NULL OR @OutputSchemaName IS NULL OR @OutputDatabaseName IS NULL)
    BEGIN
        RAISERROR('This procedure should be called with a value for @Output* parameters, as @OutputType is set to NONE',12,1);
        RETURN;
    END;
    IF(@BringThePain = 1)
    BEGIN
        RAISERROR('Incompatible Parameters: @BringThePain set to 1 and @OutputType set to NONE',12,1);
        RETURN;
    END;
	/* Eventually limit by mode																			   
    IF(@Mode not in (0,4)) 
	BEGIN
        RAISERROR('Incompatible Parameters: @Mode set to %d and @OutputType set to NONE',12,1,@Mode);
        RETURN;
	END;
	*/
END;

IF OBJECT_ID('tempdb..#IndexSanity') IS NOT NULL 
    DROP TABLE #IndexSanity;

IF OBJECT_ID('tempdb..#IndexPartitionSanity') IS NOT NULL 
    DROP TABLE #IndexPartitionSanity;

IF OBJECT_ID('tempdb..#IndexSanitySize') IS NOT NULL 
    DROP TABLE #IndexSanitySize;

IF OBJECT_ID('tempdb..#IndexColumns') IS NOT NULL 
    DROP TABLE #IndexColumns;

IF OBJECT_ID('tempdb..#MissingIndexes') IS NOT NULL 
    DROP TABLE #MissingIndexes;

IF OBJECT_ID('tempdb..#ForeignKeys') IS NOT NULL 
    DROP TABLE #ForeignKeys;

IF OBJECT_ID('tempdb..#BlitzIndexResults') IS NOT NULL 
    DROP TABLE #BlitzIndexResults;
        
IF OBJECT_ID('tempdb..#IndexCreateTsql') IS NOT NULL    
    DROP TABLE #IndexCreateTsql;

IF OBJECT_ID('tempdb..#DatabaseList') IS NOT NULL 
    DROP TABLE #DatabaseList;

IF OBJECT_ID('tempdb..#Statistics') IS NOT NULL 
    DROP TABLE #Statistics;

IF OBJECT_ID('tempdb..#PartitionCompressionInfo') IS NOT NULL 
    DROP TABLE #PartitionCompressionInfo;

IF OBJECT_ID('tempdb..#ComputedColumns') IS NOT NULL 
    DROP TABLE #ComputedColumns;
	
IF OBJECT_ID('tempdb..#TraceStatus') IS NOT NULL
	DROP TABLE #TraceStatus;

IF OBJECT_ID('tempdb..#TemporalTables') IS NOT NULL
	DROP TABLE #TemporalTables;

IF OBJECT_ID('tempdb..#CheckConstraints') IS NOT NULL
	DROP TABLE #CheckConstraints;

IF OBJECT_ID('tempdb..#FilteredIndexes') IS NOT NULL
	DROP TABLE #FilteredIndexes;
		
IF OBJECT_ID('tempdb..#Ignore_Databases') IS NOT NULL 
    DROP TABLE #Ignore_Databases

        RAISERROR (N'Create temp tables.',0,1) WITH NOWAIT;
        CREATE TABLE #BlitzIndexResults
            (
              blitz_result_id INT IDENTITY PRIMARY KEY,
              check_id INT NOT NULL,
              index_sanity_id INT NULL,
              Priority INT NULL,
              findings_group NVARCHAR(4000) NOT NULL,
              finding NVARCHAR(200) NOT NULL,
              [database_name] NVARCHAR(128) NULL,
              URL NVARCHAR(200) NOT NULL,
              details NVARCHAR(MAX) NOT NULL,
              index_definition NVARCHAR(MAX) NOT NULL,
              secret_columns NVARCHAR(MAX) NULL,
              index_usage_summary NVARCHAR(MAX) NULL,
              index_size_summary NVARCHAR(MAX) NULL,
              create_tsql NVARCHAR(MAX) NULL,
              more_info NVARCHAR(MAX)NULL
            );

        CREATE TABLE #IndexSanity
            (
              [index_sanity_id] INT IDENTITY PRIMARY KEY CLUSTERED,
              [database_id] SMALLINT NOT NULL ,
              [object_id] INT NOT NULL ,
              [index_id] INT NOT NULL ,
              [index_type] TINYINT NOT NULL,
              [database_name] NVARCHAR(128) NOT NULL ,
              [schema_name] NVARCHAR(128) NOT NULL ,
              [object_name] NVARCHAR(128) NOT NULL ,
              index_name NVARCHAR(128) NULL ,
              key_column_names NVARCHAR(MAX) NULL ,
              key_column_names_with_sort_order NVARCHAR(MAX) NULL ,
              key_column_names_with_sort_order_no_types NVARCHAR(MAX) NULL ,
              count_key_columns INT NULL ,
              include_column_names NVARCHAR(MAX) NULL ,
              include_column_names_no_types NVARCHAR(MAX) NULL ,
              count_included_columns INT NULL ,
              partition_key_column_name NVARCHAR(MAX) NULL,
              filter_definition NVARCHAR(MAX) NOT NULL ,
              is_indexed_view BIT NOT NULL ,
              is_unique BIT NOT NULL ,
              is_primary_key BIT NOT NULL ,
              is_XML BIT NOT NULL,
              is_spatial BIT NOT NULL,
              is_NC_columnstore BIT NOT NULL,
              is_CX_columnstore BIT NOT NULL,
              is_in_memory_oltp BIT NOT NULL ,
              is_disabled BIT NOT NULL ,
              is_hypothetical BIT NOT NULL ,
              is_padded BIT NOT NULL ,
              fill_factor SMALLINT NOT NULL ,
              user_seeks BIGINT NOT NULL ,
              user_scans BIGINT NOT NULL ,
              user_lookups BIGINT NOT  NULL ,
              user_updates BIGINT NULL ,
              last_user_seek DATETIME NULL ,
              last_user_scan DATETIME NULL ,
              last_user_lookup DATETIME NULL ,
              last_user_update DATETIME NULL ,
              is_referenced_by_foreign_key BIT DEFAULT(0),
              secret_columns NVARCHAR(MAX) NULL,
              count_secret_columns INT NULL,
              create_date DATETIME NOT NULL,
              modify_date DATETIME NOT NULL,
              filter_columns_not_in_index NVARCHAR(MAX),
            [db_schema_object_name] AS [schema_name] + N'.' + [object_name]  ,
            [db_schema_object_indexid] AS [schema_name] + N'.' + [object_name]
                + CASE WHEN [index_name] IS NOT NULL THEN N'.' + index_name
                ELSE N''
                END + N' (' + CAST(index_id AS NVARCHAR(20)) + N')' ,
            first_key_column_name AS CASE    WHEN count_key_columns > 1
                THEN LEFT(key_column_names, CHARINDEX(',', key_column_names, 0) - 1)
                ELSE key_column_names
                END ,
            index_definition AS 
            CASE WHEN partition_key_column_name IS NOT NULL 
                THEN N'[PARTITIONED BY:' + partition_key_column_name +  N']' 
                ELSE '' 
                END +
                CASE index_id
                    WHEN 0 THEN N'[HEAP] '
                    WHEN 1 THEN N'[CX] '
                    ELSE N'' END + CASE WHEN is_indexed_view = 1 THEN N'[VIEW] '
                    ELSE N'' END + CASE WHEN is_primary_key = 1 THEN N'[PK] '
                    ELSE N'' END + CASE WHEN is_XML = 1 THEN N'[XML] '
                    ELSE N'' END + CASE WHEN is_spatial = 1 THEN N'[SPATIAL] '
                    ELSE N'' END + CASE WHEN is_NC_columnstore = 1 THEN N'[COLUMNSTORE] '
                    ELSE N'' END + CASE WHEN is_in_memory_oltp = 1 THEN N'[IN-MEMORY] '
                    ELSE N'' END + CASE WHEN is_disabled = 1 THEN N'[DISABLED] '
                    ELSE N'' END + CASE WHEN is_hypothetical = 1 THEN N'[HYPOTHETICAL] '
                    ELSE N'' END + CASE WHEN is_unique = 1 AND is_primary_key = 0 THEN N'[UNIQUE] '
                    ELSE N'' END + CASE WHEN count_key_columns > 0 THEN 
                        N'[' + CAST(count_key_columns AS NVARCHAR(10)) + N' KEY' 
                            + CASE WHEN count_key_columns > 1 THEN  N'S' ELSE N'' END
                            + N'] ' + LTRIM(key_column_names_with_sort_order)
                    ELSE N'' END + CASE WHEN count_included_columns > 0 THEN 
                        N' [' + CAST(count_included_columns AS NVARCHAR(10))  + N' INCLUDE' + 
                            + CASE WHEN count_included_columns > 1 THEN  N'S' ELSE N'' END                    
                            + N'] ' + include_column_names
                    ELSE N'' END + CASE WHEN filter_definition <> N'' THEN N' [FILTER] ' + filter_definition
                    ELSE N'' END ,
            [total_reads] AS user_seeks + user_scans + user_lookups,
            [reads_per_write] AS CAST(CASE WHEN user_updates > 0
                THEN ( user_seeks + user_scans + user_lookups )  / (1.0 * user_updates)
                ELSE 0 END AS MONEY) ,
            [index_usage_summary] AS
				CASE WHEN is_spatial = 1 THEN N'Not Tracked'
				WHEN is_disabled = 1 THEN N'Disabled'
				ELSE N'Reads: ' + 
					REPLACE(CONVERT(NVARCHAR(30),CAST((user_seeks + user_scans + user_lookups) AS MONEY), 1), N'.00', N'')
					+ CASE WHEN user_seeks + user_scans + user_lookups > 0 THEN
						N' (' 
							+ RTRIM(
							CASE WHEN user_seeks > 0 THEN REPLACE(CONVERT(NVARCHAR(30),CAST((user_seeks) AS MONEY), 1), N'.00', N'') + N' seek ' ELSE N'' END
							+ CASE WHEN user_scans > 0 THEN REPLACE(CONVERT(NVARCHAR(30),CAST((user_scans) AS MONEY), 1), N'.00', N'') + N' scan '  ELSE N'' END
							+ CASE WHEN user_lookups > 0 THEN  REPLACE(CONVERT(NVARCHAR(30),CAST((user_lookups) AS MONEY), 1), N'.00', N'') + N' lookup' ELSE N'' END
							)
							+ N') '
						ELSE N' '
						END 
					+ N'Writes: ' + 
					REPLACE(CONVERT(NVARCHAR(30),CAST(user_updates AS MONEY), 1), N'.00', N'')
				END /* First "end" is about is_spatial */,
				[more_info] AS 
				CASE WHEN is_in_memory_oltp = 1 
					THEN N'EXEC dbo.sp_BlitzInMemoryOLTP @dbName=' + QUOTENAME([database_name],N'''') + 
					N', @tableName=' + QUOTENAME([object_name],N'''') + N';'
				ELSE N'EXEC dbo.sp_BlitzIndex @DatabaseName=' + QUOTENAME([database_name],N'''') + 
					N', @SchemaName=' + QUOTENAME([schema_name],N'''') + N', @TableName=' + QUOTENAME([object_name],N'''') + N';'
				END
		);
        RAISERROR (N'Adding UQ index on #IndexSanity (database_id, object_id, index_id)',0,1) WITH NOWAIT;
        IF NOT EXISTS(SELECT 1 FROM tempdb.sys.indexes WHERE name='uq_database_id_object_id_index_id') 
            CREATE UNIQUE INDEX uq_database_id_object_id_index_id ON #IndexSanity (database_id, object_id, index_id);


        CREATE TABLE #IndexPartitionSanity
            (
              [index_partition_sanity_id] INT IDENTITY,
              [index_sanity_id] INT NULL ,
              [database_id] INT NOT NULL ,
              [object_id] INT NOT NULL ,
			  [schema_name] NVARCHAR(128) NOT NULL,
              [index_id] INT NOT NULL ,
              [partition_number] INT NOT NULL ,
              row_count BIGINT NOT NULL ,
              reserved_MB NUMERIC(29,2) NOT NULL ,
              reserved_LOB_MB NUMERIC(29,2) NOT NULL ,
              reserved_row_overflow_MB NUMERIC(29,2) NOT NULL ,
              reserved_dictionary_MB NUMERIC(29,2) NOT NULL ,
              leaf_insert_count BIGINT NULL ,
              leaf_delete_count BIGINT NULL ,
              leaf_update_count BIGINT NULL ,
              range_scan_count BIGINT NULL ,
              singleton_lookup_count BIGINT NULL , 
              forwarded_fetch_count BIGINT NULL ,
              lob_fetch_in_pages BIGINT NULL ,
              lob_fetch_in_bytes BIGINT NULL ,
              row_overflow_fetch_in_pages BIGINT NULL ,
              row_overflow_fetch_in_bytes BIGINT NULL ,
              row_lock_count BIGINT NULL ,
              row_lock_wait_count BIGINT NULL ,
              row_lock_wait_in_ms BIGINT NULL ,
              page_lock_count BIGINT NULL ,
              page_lock_wait_count BIGINT NULL ,
              page_lock_wait_in_ms BIGINT NULL ,
              index_lock_promotion_attempt_count BIGINT NULL ,
              index_lock_promotion_count BIGINT NULL,
              data_compression_desc NVARCHAR(60) NULL,
			  page_latch_wait_count BIGINT NULL,
			  page_latch_wait_in_ms BIGINT NULL,
			  page_io_latch_wait_count BIGINT NULL,
			  page_io_latch_wait_in_ms BIGINT NULL,
              lock_escalation_desc nvarchar(60) NULL
            );

        CREATE TABLE #IndexSanitySize
            (
              [index_sanity_size_id] INT IDENTITY NOT NULL ,
              [index_sanity_id] INT NULL ,
              [database_id] INT NOT NULL,
			  [schema_name] NVARCHAR(128) NOT NULL,
              partition_count INT NOT NULL ,
              total_rows BIGINT NOT NULL ,
              total_reserved_MB NUMERIC(29,2) NOT NULL ,
              total_reserved_LOB_MB NUMERIC(29,2) NOT NULL ,
              total_reserved_row_overflow_MB NUMERIC(29,2) NOT NULL ,
              total_reserved_dictionary_MB NUMERIC(29,2) NOT NULL ,
              total_leaf_delete_count BIGINT NULL,
              total_leaf_update_count BIGINT NULL,
              total_range_scan_count BIGINT NULL,
              total_singleton_lookup_count BIGINT NULL,
              total_forwarded_fetch_count BIGINT NULL,
              total_row_lock_count BIGINT NULL ,
              total_row_lock_wait_count BIGINT NULL ,
              total_row_lock_wait_in_ms BIGINT NULL ,
              avg_row_lock_wait_in_ms BIGINT NULL ,
              total_page_lock_count BIGINT NULL ,
              total_page_lock_wait_count BIGINT NULL ,
              total_page_lock_wait_in_ms BIGINT NULL ,
              avg_page_lock_wait_in_ms BIGINT NULL ,
               total_index_lock_promotion_attempt_count BIGINT NULL ,
              total_index_lock_promotion_count BIGINT NULL ,
              data_compression_desc NVARCHAR(4000) NULL,
			  page_latch_wait_count BIGINT NULL,
			  page_latch_wait_in_ms BIGINT NULL,
			  page_io_latch_wait_count BIGINT NULL,
			  page_io_latch_wait_in_ms BIGINT NULL,
              lock_escalation_desc nvarchar(60) NULL,
              index_size_summary AS ISNULL(
                CASE WHEN partition_count > 1
                        THEN N'[' + CAST(partition_count AS NVARCHAR(10)) + N' PARTITIONS] '
                        ELSE N''
                END + REPLACE(CONVERT(NVARCHAR(30),CAST([total_rows] AS MONEY), 1), N'.00', N'') + N' rows; '
                + CASE WHEN total_reserved_MB > 1024 THEN 
                    CAST(CAST(total_reserved_MB/1024. AS NUMERIC(29,1)) AS NVARCHAR(30)) + N'GB'
                ELSE 
                    CAST(CAST(total_reserved_MB AS NUMERIC(29,1)) AS NVARCHAR(30)) + N'MB'
                END
                + CASE WHEN total_reserved_LOB_MB > 1024 THEN 
                    N'; ' + CAST(CAST(total_reserved_LOB_MB/1024. AS NUMERIC(29,1)) AS NVARCHAR(30)) + N'GB ' + CASE WHEN total_reserved_dictionary_MB = 0 THEN N'LOB' ELSE N'Columnstore' END
                WHEN total_reserved_LOB_MB > 0 THEN
                    N'; ' + CAST(CAST(total_reserved_LOB_MB AS NUMERIC(29,1)) AS NVARCHAR(30)) + N'MB ' + CASE WHEN total_reserved_dictionary_MB = 0 THEN N'LOB' ELSE N'Columnstore' END
                ELSE ''
                END
                 + CASE WHEN total_reserved_row_overflow_MB > 1024 THEN
                    N'; ' + CAST(CAST(total_reserved_row_overflow_MB/1024. AS NUMERIC(29,1)) AS NVARCHAR(30)) + N'GB Row Overflow'
                WHEN total_reserved_row_overflow_MB > 0 THEN
                    N'; ' + CAST(CAST(total_reserved_row_overflow_MB AS NUMERIC(29,1)) AS NVARCHAR(30)) + N'MB Row Overflow'
                ELSE ''
                END
                 + CASE WHEN total_reserved_dictionary_MB > 1024 THEN
                    N'; ' + CAST(CAST(total_reserved_dictionary_MB/1024. AS NUMERIC(29,1)) AS NVARCHAR(30)) + N'GB Dictionaries'
                WHEN total_reserved_dictionary_MB > 0 THEN
                    N'; ' + CAST(CAST(total_reserved_dictionary_MB AS NUMERIC(29,1)) AS NVARCHAR(30)) + N'MB Dictionaries'
                ELSE ''
                END ,
                    N'Error- NULL in computed column'),
            index_op_stats AS ISNULL(
                (
                    REPLACE(CONVERT(NVARCHAR(30),CAST(total_singleton_lookup_count AS MONEY), 1),N'.00',N'') + N' singleton lookups; '
                    + REPLACE(CONVERT(NVARCHAR(30),CAST(total_range_scan_count AS MONEY), 1),N'.00',N'') + N' scans/seeks; '
                    + REPLACE(CONVERT(NVARCHAR(30),CAST(total_leaf_delete_count AS MONEY), 1),N'.00',N'') + N' deletes; '
                    + REPLACE(CONVERT(NVARCHAR(30),CAST(total_leaf_update_count AS MONEY), 1),N'.00',N'') + N' updates; '
                    + CASE WHEN ISNULL(total_forwarded_fetch_count,0) >0 THEN
                        REPLACE(CONVERT(NVARCHAR(30),CAST(total_forwarded_fetch_count AS MONEY), 1),N'.00',N'') + N' forward records fetched; '
                    ELSE N'' END

                    /* rows will only be in this dmv when data is in memory for the table */
                ), N'Table metadata not in memory'),
            index_lock_wait_summary AS ISNULL(
                CASE WHEN total_row_lock_wait_count = 0 AND  total_page_lock_wait_count = 0 AND
                    total_index_lock_promotion_attempt_count = 0 THEN N'0 lock waits; '
                    + CASE WHEN lock_escalation_desc = N'DISABLE' THEN N'Lock escalation DISABLE.'
                      ELSE N''
                      END
                ELSE
                    CASE WHEN total_row_lock_wait_count > 0 THEN
                        N'Row lock waits: ' + REPLACE(CONVERT(NVARCHAR(30),CAST(total_row_lock_wait_count AS MONEY), 1), N'.00', N'')
                        + N'; total duration: ' + 
                            CASE WHEN total_row_lock_wait_in_ms >= 60000 THEN /*More than 1 min*/
                                REPLACE(CONVERT(NVARCHAR(30),CAST((total_row_lock_wait_in_ms/60000) AS MONEY), 1), N'.00', N'') + N' minutes; '
                            ELSE                         
                                REPLACE(CONVERT(NVARCHAR(30),CAST(ISNULL(total_row_lock_wait_in_ms/1000,0) AS MONEY), 1), N'.00', N'') + N' seconds; '
                            END
                        + N'avg duration: ' + 
                            CASE WHEN avg_row_lock_wait_in_ms >= 60000 THEN /*More than 1 min*/
                                REPLACE(CONVERT(NVARCHAR(30),CAST((avg_row_lock_wait_in_ms/60000) AS MONEY), 1), N'.00', N'') + N' minutes; '
                            ELSE                         
                                REPLACE(CONVERT(NVARCHAR(30),CAST(ISNULL(avg_row_lock_wait_in_ms/1000,0) AS MONEY), 1), N'.00', N'') + N' seconds; '
                            END
                    ELSE N''
                    END +
                    CASE WHEN total_page_lock_wait_count > 0 THEN
                        N'Page lock waits: ' + REPLACE(CONVERT(NVARCHAR(30),CAST(total_page_lock_wait_count AS MONEY), 1), N'.00', N'')
                        + N'; total duration: ' + 
                            CASE WHEN total_page_lock_wait_in_ms >= 60000 THEN /*More than 1 min*/
                                REPLACE(CONVERT(NVARCHAR(30),CAST((total_page_lock_wait_in_ms/60000) AS MONEY), 1), N'.00', N'') + N' minutes; '
                            ELSE                         
                                REPLACE(CONVERT(NVARCHAR(30),CAST(ISNULL(total_page_lock_wait_in_ms/1000,0) AS MONEY), 1), N'.00', N'') + N' seconds; '
                            END
                        + N'avg duration: ' + 
                            CASE WHEN avg_page_lock_wait_in_ms >= 60000 THEN /*More than 1 min*/
                                REPLACE(CONVERT(NVARCHAR(30),CAST((avg_page_lock_wait_in_ms/60000) AS MONEY), 1), N'.00', N'') + N' minutes; '
                            ELSE                         
                                REPLACE(CONVERT(NVARCHAR(30),CAST(ISNULL(avg_page_lock_wait_in_ms/1000,0) AS MONEY), 1), N'.00', N'') + N' seconds; '
                            END
                    ELSE N''
                    END +
                    CASE WHEN total_index_lock_promotion_attempt_count > 0 THEN
                        N'Lock escalation attempts: ' + REPLACE(CONVERT(NVARCHAR(30),CAST(total_index_lock_promotion_attempt_count AS MONEY), 1), N'.00', N'')
                        + N'; Actual Escalations: ' + REPLACE(CONVERT(NVARCHAR(30),CAST(ISNULL(total_index_lock_promotion_count,0) AS MONEY), 1), N'.00', N'') +N'; '
                    ELSE N''
                    END +
                    CASE WHEN lock_escalation_desc = N'DISABLE' THEN
                        N'Lock escalation is disabled.'
                    ELSE N''
                    END
                END                  
                    ,'Error- NULL in computed column')
            );

        CREATE TABLE #IndexColumns
            (
              [database_id] INT NOT NULL,
			  [schema_name] NVARCHAR(128),
              [object_id] INT NOT NULL ,
              [index_id] INT NOT NULL ,
              [key_ordinal] INT NULL ,
              is_included_column BIT NULL ,
              is_descending_key BIT NULL ,
              [partition_ordinal] INT NULL ,
              column_name NVARCHAR(256) NOT NULL ,
              system_type_name NVARCHAR(256) NOT NULL,
              max_length SMALLINT NOT NULL,
              [precision] TINYINT NOT NULL,
              [scale] TINYINT NOT NULL,
              collation_name NVARCHAR(256) NULL,
              is_nullable BIT NULL,
              is_identity BIT NULL,
              is_computed BIT NULL,
              is_replicated BIT NULL,
              is_sparse BIT NULL,
              is_filestream BIT NULL,
              seed_value DECIMAL(38,0) NULL,
              increment_value DECIMAL(38,0) NULL ,
              last_value DECIMAL(38,0) NULL,
              is_not_for_replication BIT NULL
            );
        CREATE CLUSTERED INDEX CLIX_database_id_object_id_index_id ON #IndexColumns
            (database_id, object_id, index_id);

        CREATE TABLE #MissingIndexes
            ([database_id] INT NOT NULL,
			[object_id] INT NOT NULL,
            [database_name] NVARCHAR(128) NOT NULL ,
            [schema_name] NVARCHAR(128) NOT NULL ,
            [table_name] NVARCHAR(128),
            [statement] NVARCHAR(512) NOT NULL,
            magic_benefit_number AS (( user_seeks + user_scans ) * avg_total_user_cost * avg_user_impact),
            avg_total_user_cost NUMERIC(29,4) NOT NULL,
            avg_user_impact NUMERIC(29,1) NOT NULL,
            user_seeks BIGINT NOT NULL,
            user_scans BIGINT NOT NULL,
            unique_compiles BIGINT NULL,
            equality_columns NVARCHAR(MAX),
            equality_columns_with_data_type NVARCHAR(MAX),
            inequality_columns NVARCHAR(MAX),
            inequality_columns_with_data_type NVARCHAR(MAX),
            included_columns NVARCHAR(MAX),
            included_columns_with_data_type NVARCHAR(MAX),
			is_low BIT,
                [index_estimated_impact] AS 
                    REPLACE(CONVERT(NVARCHAR(256),CAST(CAST(
                                    (user_seeks + user_scans)
                                     AS BIGINT) AS MONEY), 1), '.00', '') + N' use' 
                        + CASE WHEN (user_seeks + user_scans) > 1 THEN N's' ELSE N'' END
                         +N'; Impact: ' + CAST(avg_user_impact AS NVARCHAR(30))
                        + N'%; Avg query cost: '
                        + CAST(avg_total_user_cost AS NVARCHAR(30)),
                [missing_index_details] AS
                    CASE WHEN COALESCE(equality_columns_with_data_type,equality_columns) IS NOT NULL
						THEN N'EQUALITY: ' + COALESCE(CAST(equality_columns_with_data_type AS NVARCHAR(MAX)), CAST(equality_columns AS NVARCHAR(MAX))) + N' '
                         ELSE N'' END +

                    CASE WHEN COALESCE(inequality_columns_with_data_type,inequality_columns) IS NOT NULL
						THEN N'INEQUALITY: ' + COALESCE(CAST(inequality_columns_with_data_type AS NVARCHAR(MAX)), CAST(inequality_columns AS NVARCHAR(MAX))) + N' '
                         ELSE N'' END +

                    CASE WHEN COALESCE(included_columns_with_data_type,included_columns) IS NOT NULL
						THEN N'INCLUDE: ' + COALESCE(CAST(included_columns_with_data_type AS NVARCHAR(MAX)), CAST(included_columns AS NVARCHAR(MAX))) + N' '
                         ELSE N'' END,
                [create_tsql] AS N'CREATE INDEX [' 
                    + LEFT(REPLACE(REPLACE(REPLACE(REPLACE(
                        ISNULL(equality_columns,N'')+ 
                        CASE WHEN equality_columns IS NOT NULL AND inequality_columns IS NOT NULL THEN N'_' ELSE N'' END
                        + ISNULL(inequality_columns,''),',','')
                        ,'[',''),']',''),' ','_') 
                    + CASE WHEN included_columns IS NOT NULL THEN N'_Includes' ELSE N'' END, 128) + N'] ON ' 
                    + [statement] + N' (' + ISNULL(equality_columns,N'')
                    + CASE WHEN equality_columns IS NOT NULL AND inequality_columns IS NOT NULL THEN N', ' ELSE N'' END
                    + CASE WHEN inequality_columns IS NOT NULL THEN inequality_columns ELSE N'' END + 
                    ') ' + CASE WHEN included_columns IS NOT NULL THEN N' INCLUDE (' + included_columns + N')' ELSE N'' END
                    + N' WITH (' 
                        + N'FILLFACTOR=100, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?' 
                    + N')'
                    + N';'
                    ,
                [more_info] AS N'EXEC dbo.sp_BlitzIndex @DatabaseName=' + QUOTENAME([database_name],'''') + 
                    N', @SchemaName=' + QUOTENAME([schema_name],'''') + N', @TableName=' + QUOTENAME([table_name],'''') + N';',
				[sample_query_plan] XML NULL
            );

        CREATE TABLE #ForeignKeys (
			[database_id] INT NOT NULL,
            [database_name] NVARCHAR(128) NOT NULL ,
			[schema_name] NVARCHAR(128) NOT NULL ,
            foreign_key_name NVARCHAR(256),
            parent_object_id INT,
            parent_object_name NVARCHAR(256),
            referenced_object_id INT,
            referenced_object_name NVARCHAR(256),
            is_disabled BIT,
            is_not_trusted BIT,
            is_not_for_replication BIT,
            parent_fk_columns NVARCHAR(MAX),
            referenced_fk_columns NVARCHAR(MAX),
            update_referential_action_desc NVARCHAR(16),
            delete_referential_action_desc NVARCHAR(60)
        );
        
        CREATE TABLE #IndexCreateTsql (
            index_sanity_id INT NOT NULL,
            create_tsql NVARCHAR(MAX) NOT NULL
        );

        CREATE TABLE #DatabaseList (
			DatabaseName NVARCHAR(256),
            secondary_role_allow_connections_desc NVARCHAR(50)

        );

		CREATE TABLE #PartitionCompressionInfo (
			[index_sanity_id] INT NULL,
			[partition_compression_detail] NVARCHAR(4000) NULL
        );

		CREATE TABLE #Statistics (
		  database_id INT NOT NULL,
		  database_name NVARCHAR(256) NOT NULL,
		  table_name NVARCHAR(128) NULL,
		  schema_name NVARCHAR(128) NULL,
		  index_name  NVARCHAR(128) NULL,
		  column_names  NVARCHAR(MAX) NULL,
		  statistics_name NVARCHAR(128) NULL,
		  last_statistics_update DATETIME NULL,
		  days_since_last_stats_update INT NULL,
		  rows BIGINT NULL,
		  rows_sampled BIGINT NULL,
		  percent_sampled DECIMAL(18, 1) NULL,
		  histogram_steps INT NULL,
		  modification_counter BIGINT NULL,
		  percent_modifications DECIMAL(18, 1) NULL,
		  modifications_before_auto_update INT NULL,
		  index_type_desc NVARCHAR(128) NULL,
		  table_create_date DATETIME NULL,
		  table_modify_date DATETIME NULL,
		  no_recompute BIT NULL,
		  has_filter BIT NULL,
		  filter_definition NVARCHAR(MAX) NULL
		); 

		CREATE TABLE #ComputedColumns
		(
		  index_sanity_id INT IDENTITY(1, 1) NOT NULL,
		  database_name NVARCHAR(128) NULL,
		  database_id INT NOT NULL,
		  table_name NVARCHAR(128) NOT NULL,
		  schema_name NVARCHAR(128) NOT NULL,
		  column_name NVARCHAR(128) NULL,
		  is_nullable BIT NULL,
		  definition NVARCHAR(MAX) NULL,
		  uses_database_collation BIT NOT NULL,
		  is_persisted BIT NOT NULL,
		  is_computed BIT NOT NULL,
		  is_function INT NOT NULL,
		  column_definition NVARCHAR(MAX) NULL
		);
		
		CREATE TABLE #TraceStatus
		(
		 TraceFlag NVARCHAR(10) ,
		 status BIT ,
		 Global BIT ,
		 Session BIT
		);

        CREATE TABLE #TemporalTables
        (
            index_sanity_id INT IDENTITY(1, 1) NOT NULL,
            database_name NVARCHAR(128) NOT NULL,
            database_id INT NOT NULL,
            schema_name NVARCHAR(128) NOT NULL,
            table_name NVARCHAR(128) NOT NULL,
            history_table_name NVARCHAR(128) NOT NULL,
            history_schema_name NVARCHAR(128) NOT NULL,
            start_column_name NVARCHAR(128) NOT NULL,
            end_column_name NVARCHAR(128) NOT NULL,
            period_name NVARCHAR(128) NOT NULL
        );

		CREATE TABLE #CheckConstraints
		(
		  index_sanity_id INT IDENTITY(1, 1) NOT NULL,
		  database_name NVARCHAR(128) NULL,
		  database_id INT NOT NULL,
		  table_name NVARCHAR(128) NOT NULL,
		  schema_name NVARCHAR(128) NOT NULL,
		  constraint_name NVARCHAR(128) NULL,
		  is_disabled BIT NULL,
		  definition NVARCHAR(MAX) NULL,
		  uses_database_collation BIT NOT NULL,
		  is_not_trusted BIT NOT NULL,
		  is_function INT NOT NULL,
		  column_definition NVARCHAR(MAX) NULL
		);

		CREATE TABLE #FilteredIndexes
		(
		  index_sanity_id INT IDENTITY(1, 1) NOT NULL,
		  database_name NVARCHAR(128) NULL,
		  database_id INT NOT NULL,
		  schema_name NVARCHAR(128) NOT NULL,
		  table_name NVARCHAR(128) NOT NULL,
		  index_name NVARCHAR(128) NULL,
		  column_name NVARCHAR(128) NULL
		);

        CREATE TABLE #Ignore_Databases 
        (
          DatabaseName NVARCHAR(128), 
          Reason NVARCHAR(100)
        );

/* Sanitize our inputs */
SELECT
	@OutputServerName = QUOTENAME(@OutputServerName),
	@OutputDatabaseName = QUOTENAME(@OutputDatabaseName),
	@OutputSchemaName = QUOTENAME(@OutputSchemaName),
	@OutputTableName = QUOTENAME(@OutputTableName);
					
					
IF @GetAllDatabases = 1
    BEGIN
        INSERT INTO #DatabaseList (DatabaseName)
        SELECT  DB_NAME(database_id)
        FROM    sys.databases
        WHERE user_access_desc = 'MULTI_USER'
        AND state_desc = 'ONLINE'
        AND database_id > 4
        AND DB_NAME(database_id) NOT LIKE 'ReportServer%'
        AND DB_NAME(database_id) NOT LIKE 'rdsadmin%'
        AND is_distributor = 0
		OPTION    ( RECOMPILE );

        /* Skip non-readable databases in an AG - see Github issue #1160 */
        IF EXISTS (SELECT * FROM sys.all_objects o INNER JOIN sys.all_columns c ON o.object_id = c.object_id AND o.name = 'dm_hadr_availability_replica_states' AND c.name = 'role_desc')
            BEGIN
            SET @dsql = N'UPDATE #DatabaseList SET secondary_role_allow_connections_desc = ''NO'' WHERE DatabaseName IN (
                        SELECT d.name 
                        FROM sys.dm_hadr_availability_replica_states rs
                        INNER JOIN sys.databases d ON rs.replica_id = d.replica_id
                        INNER JOIN sys.availability_replicas r ON rs.replica_id = r.replica_id
                        WHERE rs.role_desc = ''SECONDARY''
                        AND r.secondary_role_allow_connections_desc = ''NO'')
						OPTION    ( RECOMPILE );';
            EXEC sp_executesql @dsql;

            IF EXISTS (SELECT * FROM #DatabaseList WHERE secondary_role_allow_connections_desc = 'NO')
                BEGIN
                INSERT    #BlitzIndexResults ( Priority, check_id, findings_group, finding, database_name, URL, details, index_definition,
                                                index_usage_summary, index_size_summary )
                VALUES  ( 1, 
				          0, 
		                  N'Skipped non-readable AG secondary databases.',
                          N'You are running this on an AG secondary, and some of your databases are configured as non-readable when this is a secondary node.',
				          N'To analyze those databases, run sp_BlitzIndex on the primary, or on a readable secondary.',
                          'http://FirstResponderKit.org', '', '', '', ''
                        );        
                END;
            END;

        IF @IgnoreDatabases IS NOT NULL
            AND LEN(@IgnoreDatabases) > 0
            BEGIN
                RAISERROR(N'Setting up filter to ignore databases', 0, 1) WITH NOWAIT;
                SET @DatabaseToIgnore = '';

                WHILE LEN(@IgnoreDatabases) > 0
                BEGIN
                    IF PATINDEX('%,%', @IgnoreDatabases) > 0
                    BEGIN  
                        SET @DatabaseToIgnore = SUBSTRING(@IgnoreDatabases, 0, PATINDEX('%,%',@IgnoreDatabases)) ;
                        
                        INSERT INTO #Ignore_Databases (DatabaseName, Reason)
                        SELECT LTRIM(RTRIM(@DatabaseToIgnore)), 'Specified in the @IgnoreDatabases parameter'
                        OPTION (RECOMPILE) ;
                        
                        SET @IgnoreDatabases = SUBSTRING(@IgnoreDatabases, LEN(@DatabaseToIgnore + ',') + 1, LEN(@IgnoreDatabases)) ;
                    END;
                    ELSE
                    BEGIN
                        SET @DatabaseToIgnore = @IgnoreDatabases ;
                        SET @IgnoreDatabases = NULL ;

                        INSERT INTO #Ignore_Databases (DatabaseName, Reason)
                        SELECT LTRIM(RTRIM(@DatabaseToIgnore)), 'Specified in the @IgnoreDatabases parameter'
                        OPTION (RECOMPILE) ;
                    END;
            END;
                
        END

    END;
ELSE
    BEGIN
        INSERT INTO #DatabaseList
                ( DatabaseName )
        SELECT CASE 
		            WHEN @DatabaseName IS NULL OR @DatabaseName = N'' 
		            THEN DB_NAME()
                    ELSE @DatabaseName END;
               END;

SET @NumDatabases = (SELECT COUNT(*) FROM #DatabaseList AS D LEFT OUTER JOIN #Ignore_Databases AS I ON D.DatabaseName = I.DatabaseName WHERE I.DatabaseName IS NULL);
SET @msg = N'Number of databases to examine: ' + CAST(@NumDatabases AS NVARCHAR(50));
RAISERROR (@msg,0,1) WITH NOWAIT;



/* Running on 50+ databases can take a reaaallly long time, so we want explicit permission to do so (and only after warning about it) */


BEGIN TRY
        IF @NumDatabases >= 50 AND @BringThePain != 1 AND @TableName IS NULL
        BEGIN

            INSERT    #BlitzIndexResults ( Priority, check_id, findings_group, finding, URL, details, index_definition,
                                            index_usage_summary, index_size_summary )
            VALUES  ( -1, 
			          0 , 
		              @ScriptVersionName,
                      CASE WHEN @GetAllDatabases = 1 THEN N'All Databases' ELSE N'Database ' + QUOTENAME(@DatabaseName) + N' as of ' + CONVERT(NVARCHAR(16), GETDATE(), 121) END, 
                      N'From Your Community Volunteers',   
					  N'http://FirstResponderKit.org',
                      N'',
                      N'',
					  N''
                    );
            INSERT    #BlitzIndexResults ( Priority, check_id, findings_group, finding, database_name, URL, details, index_definition,
                                            index_usage_summary, index_size_summary )
            VALUES  ( 1, 
			          0, 
		              N'You''re trying to run sp_BlitzIndex on a server with ' + CAST(@NumDatabases AS NVARCHAR(8)) + N' databases. ',
                      N'Running sp_BlitzIndex on a server with 50+ databases may cause temporary insanity for the server and/or user.',
				      N'If you''re sure you want to do this, run again with the parameter @BringThePain = 1.',
                      'http://FirstResponderKit.org', 
					  '', 
					  '', 
					  '', 
					  ''
                    );        
            
			if(@OutputType <> 'NONE')
			BEGIN
				SELECT bir.blitz_result_id,
					   bir.check_id,
					   bir.index_sanity_id,
					   bir.Priority,
					   bir.findings_group,
					   bir.finding,
					   bir.database_name,
					   bir.URL,
					   bir.details,
					   bir.index_definition,
					   bir.secret_columns,
					   bir.index_usage_summary,
					   bir.index_size_summary,
					   bir.create_tsql,
					   bir.more_info 
					   FROM #BlitzIndexResults AS bir;
				RAISERROR('Running sp_BlitzIndex on a server with 50+ databases may cause temporary insanity for the server', 12, 1);
			END;

		RETURN;

		END;
END TRY
BEGIN CATCH
        RAISERROR (N'Failure to execute due to number of databases.', 0,1) WITH NOWAIT;

        SELECT  @msg = ERROR_MESSAGE(), 
		          @ErrorSeverity = ERROR_SEVERITY(), 
				  @ErrorState = ERROR_STATE();

        RAISERROR (@msg, @ErrorSeverity, @ErrorState);
        
        WHILE @@trancount > 0 
            ROLLBACK;

        RETURN;
    END CATCH;


RAISERROR (N'Checking partition counts to exclude databases with over 100 partitions',0,1) WITH NOWAIT;
IF @BringThePain = 0 AND @SkipPartitions = 0 AND @TableName IS NULL
    BEGIN   
        DECLARE partition_cursor CURSOR FOR
        SELECT dl.DatabaseName
        FROM #DatabaseList dl
        LEFT OUTER JOIN #Ignore_Databases i ON dl.DatabaseName = i.DatabaseName
        WHERE COALESCE(dl.secondary_role_allow_connections_desc, 'OK') <> 'NO' 
        AND i.DatabaseName IS NULL

        OPEN partition_cursor
        FETCH NEXT FROM partition_cursor INTO @DatabaseName
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            /* Count the total number of partitions */
            SET @dsql = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
                    SELECT @RowcountOUT = SUM(1) FROM ' + QUOTENAME(@DatabaseName) + '.sys.partitions WHERE partition_number > 1 OPTION    ( RECOMPILE );';
            EXEC sp_executesql @dsql, N'@RowcountOUT BIGINT OUTPUT', @RowcountOUT = @Rowcount OUTPUT;
            IF @Rowcount > 100
                BEGIN
                   RAISERROR (N'Skipping database %s because > 100 partitions were found. To check this database, you must set @BringThePain = 1.',0,1,@DatabaseName) WITH NOWAIT;
				INSERT INTO #Ignore_Databases (DatabaseName, Reason)
				SELECT @DatabaseName, 'Over 100 partitions found - use @BringThePain = 1 to analyze'
                END;
            FETCH NEXT FROM partition_cursor INTO @DatabaseName
        END;
        CLOSE partition_cursor
        DEALLOCATE partition_cursor

    END;					

INSERT    #BlitzIndexResults ( Priority, check_id, findings_group, finding, URL, details, index_definition,
                                index_usage_summary, index_size_summary )
SELECT  1, 0 , 
        'Database Skipped',
        i.DatabaseName,
        'http://FirstResponderKit.org',
        i.Reason, '', '', ''
FROM #Ignore_Databases i;


/* Last startup */
SELECT  @DaysUptime = CAST(DATEDIFF(HOUR, create_date, GETDATE()) / 24. AS NUMERIC (23,2))
FROM    sys.databases
WHERE   database_id = 2;

IF @DaysUptime = 0 OR @DaysUptime IS NULL 
  SET @DaysUptime = .01;

SELECT @DaysUptimeInsertValue = 'Server: ' + (CONVERT(VARCHAR(256), (SERVERPROPERTY('ServerName')))) + ' Days Uptime: ' + RTRIM(@DaysUptime);


/* Permission granted or unnecessary? Ok, let's go! */

RAISERROR (N'Starting loop through databases',0,1) WITH NOWAIT;
DECLARE c1 CURSOR 
LOCAL FAST_FORWARD 
FOR 
SELECT dl.DatabaseName 
FROM #DatabaseList dl
LEFT OUTER JOIN #Ignore_Databases i ON dl.DatabaseName = i.DatabaseName
WHERE COALESCE(dl.secondary_role_allow_connections_desc, 'OK') <> 'NO' 
  AND i.DatabaseName IS NULL
ORDER BY dl.DatabaseName;

OPEN c1;
FETCH NEXT FROM c1 INTO @DatabaseName;
     WHILE @@FETCH_STATUS = 0

BEGIN
    
    RAISERROR (@LineFeed, 0, 1) WITH NOWAIT;
    RAISERROR (@LineFeed, 0, 1) WITH NOWAIT;
    RAISERROR (@DatabaseName, 0, 1) WITH NOWAIT;

SELECT   @DatabaseID = [database_id]
FROM     sys.databases
         WHERE [name] = @DatabaseName
         AND user_access_desc='MULTI_USER'
         AND state_desc = 'ONLINE';

----------------------------------------
--STEP 1: OBSERVE THE PATIENT
--This step puts index information into temp tables.
----------------------------------------
BEGIN TRY
    BEGIN

        --Validate SQL Server Version

        IF (SELECT LEFT(@SQLServerProductVersion,
              CHARINDEX('.',@SQLServerProductVersion,0)-1
              )) <= 9
        BEGIN
            SET @msg=N'sp_BlitzIndex is only supported on SQL Server 2008 and higher. The version of this instance is: ' + @SQLServerProductVersion;
            RAISERROR(@msg,16,1);
        END;

        --Short circuit here if database name does not exist.
        IF @DatabaseName IS NULL OR @DatabaseID IS NULL
        BEGIN
            SET @msg='Database does not exist or is not online/multi-user: cannot proceed.';
            RAISERROR(@msg,16,1);
        END;    

        --Validate parameters.
        IF (@Mode NOT IN (0,1,2,3,4))
        BEGIN
            SET @msg=N'Invalid @Mode parameter. 0=diagnose, 1=summarize, 2=index detail, 3=missing index detail, 4=diagnose detail';
            RAISERROR(@msg,16,1);
        END;

        IF (@Mode <> 0 AND @TableName IS NOT NULL)
        BEGIN
            SET @msg=N'Setting the @Mode doesn''t change behavior if you supply @TableName. Use default @Mode=0 to see table detail.';
            RAISERROR(@msg,16,1);
        END;

        IF ((@Mode <> 0 OR @TableName IS NOT NULL) AND @Filter <> 0)
        BEGIN
            SET @msg=N'@Filter only applies when @Mode=0 and @TableName is not specified. Please try again.';
            RAISERROR(@msg,16,1);
        END;

        IF (@SchemaName IS NOT NULL AND @TableName IS NULL) 
        BEGIN
            SET @msg='We can''t run against a whole schema! Specify a @TableName, or leave both NULL for diagnosis.';
            RAISERROR(@msg,16,1);
        END;


        IF  (@TableName IS NOT NULL AND @SchemaName IS NULL)
        BEGIN
            SET @SchemaName=N'dbo';
            SET @msg='@SchemaName wasn''t specified-- assuming schema=dbo.';
            RAISERROR(@msg,1,1) WITH NOWAIT;
        END;

        --If a table is specified, grab the object id.
        --Short circuit if it doesn't exist.
        IF @TableName IS NOT NULL
        BEGIN
            SET @dsql = N'
                    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
                    SELECT  @ObjectID= OBJECT_ID
                    FROM    ' + QUOTENAME(@DatabaseName) + N'.sys.objects AS so
                    JOIN    ' + QUOTENAME(@DatabaseName) + N'.sys.schemas AS sc on 
                        so.schema_id=sc.schema_id
                    where so.type in (''U'', ''V'')
                    and so.name=' + QUOTENAME(@TableName,'''')+ N'
                    and sc.name=' + QUOTENAME(@SchemaName,'''')+ N'
                    /*Has a row in sys.indexes. This lets us get indexed views.*/
                    and exists (
                        SELECT si.name
                        FROM ' + QUOTENAME(@DatabaseName) + '.sys.indexes AS si 
                        WHERE so.object_id=si.object_id)
                    OPTION (RECOMPILE);';

            SET @params='@ObjectID INT OUTPUT';                

            IF @dsql IS NULL 
                RAISERROR('@dsql is null',16,1);

            EXEC sp_executesql @dsql, @params, @ObjectID=@ObjectID OUTPUT;
            
            IF @ObjectID IS NULL
                    BEGIN
                        SET @msg=N'Oh, this is awkward. I can''t find the table or indexed view you''re looking for in that database.' + CHAR(10) +
                            N'Please check your parameters.';
                        RAISERROR(@msg,1,1);
                        RETURN;
                    END;
        END;

        --set @collation
        SELECT @collation=collation_name
        FROM sys.databases
        WHERE database_id=@DatabaseID;

        --insert columns for clustered indexes and heaps
        --collect info on identity columns for this one
        SET @dsql = N'/* sp_BlitzIndex */
				SET LOCK_TIMEOUT 1000; /* To fix locking bug in sys.identity_columns. See Github issue #2176. */
				SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
                SELECT ' + CAST(@DatabaseID AS NVARCHAR(16)) + ',
					s.name,    
                    si.object_id, 
                    si.index_id, 
                    sc.key_ordinal, 
                    sc.is_included_column, 
                    sc.is_descending_key,
                    sc.partition_ordinal,
                    c.name as column_name, 
                    st.name as system_type_name,
                    c.max_length,
                    c.[precision],
                    c.[scale],
                    c.collation_name,
                    c.is_nullable,
                    c.is_identity,
                    c.is_computed,
                    c.is_replicated,
                    ' + CASE WHEN @SQLServerProductVersion NOT LIKE '9%' THEN N'c.is_sparse' ELSE N'NULL as is_sparse' END + N',
                    ' + CASE WHEN @SQLServerProductVersion NOT LIKE '9%' THEN N'c.is_filestream' ELSE N'NULL as is_filestream' END + N',
                    CAST(ic.seed_value AS DECIMAL(38,0)),
                    CAST(ic.increment_value AS DECIMAL(38,0)),
                    CAST(ic.last_value AS DECIMAL(38,0)),
                    ic.is_not_for_replication
                FROM    ' + QUOTENAME(@DatabaseName) + N'.sys.indexes si
                JOIN    ' + QUOTENAME(@DatabaseName) + N'.sys.columns c ON
                    si.object_id=c.object_id
                LEFT JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.index_columns sc ON 
                    sc.object_id = si.object_id
                    and sc.index_id=si.index_id
                    AND sc.column_id=c.column_id
                LEFT JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.identity_columns ic ON
                    c.object_id=ic.object_id and
                    c.column_id=ic.column_id
                JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.types st ON 
                    c.system_type_id=st.system_type_id
                    AND c.user_type_id=st.user_type_id
				JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.objects AS so  ON si.object_id = so.object_id
																		  AND so.is_ms_shipped = 0
				JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.schemas AS s ON s.schema_id = so.schema_id
                WHERE si.index_id in (0,1) ' 
                    + CASE WHEN @ObjectID IS NOT NULL 
                        THEN N' AND si.object_id=' + CAST(@ObjectID AS NVARCHAR(30)) 
                    ELSE N'' END 
                + N'OPTION (RECOMPILE);';

        IF @dsql IS NULL 
            RAISERROR('@dsql is null',16,1);

        RAISERROR (N'Inserting data into #IndexColumns for clustered indexes and heaps',0,1) WITH NOWAIT;
        IF @Debug = 1
            BEGIN
                PRINT SUBSTRING(@dsql, 0, 4000);
                PRINT SUBSTRING(@dsql, 4000, 8000);
                PRINT SUBSTRING(@dsql, 8000, 12000);
                PRINT SUBSTRING(@dsql, 12000, 16000);
                PRINT SUBSTRING(@dsql, 16000, 20000);
                PRINT SUBSTRING(@dsql, 20000, 24000);
                PRINT SUBSTRING(@dsql, 24000, 28000);
                PRINT SUBSTRING(@dsql, 28000, 32000);
                PRINT SUBSTRING(@dsql, 32000, 36000);
                PRINT SUBSTRING(@dsql, 36000, 40000);
            END;
		BEGIN TRY
			INSERT    #IndexColumns ( database_id, [schema_name], [object_id], index_id, key_ordinal, is_included_column, is_descending_key, partition_ordinal,
				column_name, system_type_name, max_length, precision, scale, collation_name, is_nullable, is_identity, is_computed,
				is_replicated, is_sparse, is_filestream, seed_value, increment_value, last_value, is_not_for_replication )
					EXEC sp_executesql @dsql;
		END TRY
		BEGIN CATCH
			RAISERROR (N'Failure inserting data into #IndexColumns for clustered indexes and heaps.', 0,1) WITH NOWAIT;

			IF @dsql IS NOT NULL
			BEGIN
				SET @msg= 'Last @dsql: ' + @dsql;
				RAISERROR(@msg, 0, 1) WITH NOWAIT;
			END;

			SELECT  @msg = @DatabaseName + N' database failed to process. ' + ERROR_MESSAGE(),
				@ErrorSeverity = 0, @ErrorState = ERROR_STATE();
			RAISERROR (@msg,@ErrorSeverity, @ErrorState )WITH NOWAIT;

			WHILE @@trancount > 0 
				ROLLBACK;

			RETURN;
		END CATCH;


        --insert columns for nonclustered indexes
        --this uses a full join to sys.index_columns
        --We don't collect info on identity columns here. They may be in NC indexes, but we just analyze identities in the base table.
        SET @dsql = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
                SELECT ' + CAST(@DatabaseID AS NVARCHAR(16)) + ', 
					s.name,    
                    si.object_id, 
                    si.index_id, 
                    sc.key_ordinal, 
                    sc.is_included_column, 
                    sc.is_descending_key,
                    sc.partition_ordinal,
                    c.name as column_name, 
                    st.name as system_type_name,
                    c.max_length,
                    c.[precision],
                    c.[scale],
                    c.collation_name,
                    c.is_nullable,
                    c.is_identity,
                    c.is_computed,
                    c.is_replicated,
                    ' + CASE WHEN @SQLServerProductVersion NOT LIKE '9%' THEN N'c.is_sparse' ELSE N'NULL AS is_sparse' END + N',
                    ' + CASE WHEN @SQLServerProductVersion NOT LIKE '9%' THEN N'c.is_filestream' ELSE N'NULL AS is_filestream' END + N'                
                FROM    ' + QUOTENAME(@DatabaseName) + N'.sys.indexes AS si
                JOIN    ' + QUOTENAME(@DatabaseName) + N'.sys.columns AS c ON
                    si.object_id=c.object_id
                JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.index_columns AS sc ON 
                    sc.object_id = si.object_id
                    and sc.index_id=si.index_id
                    AND sc.column_id=c.column_id
                JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.types AS st ON 
                    c.system_type_id=st.system_type_id
                    AND c.user_type_id=st.user_type_id
				JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.objects AS so  ON si.object_id = so.object_id
																		  AND so.is_ms_shipped = 0
				JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.schemas AS s ON s.schema_id = so.schema_id
                WHERE si.index_id not in (0,1) ' 
                    + CASE WHEN @ObjectID IS NOT NULL 
                        THEN N' AND si.object_id=' + CAST(@ObjectID AS NVARCHAR(30)) 
                    ELSE N'' END 
                + N'OPTION (RECOMPILE);';

        IF @dsql IS NULL 
            RAISERROR('@dsql is null',16,1);

        RAISERROR (N'Inserting data into #IndexColumns for nonclustered indexes',0,1) WITH NOWAIT;
        IF @Debug = 1
            BEGIN
                PRINT SUBSTRING(@dsql, 0, 4000);
                PRINT SUBSTRING(@dsql, 4000, 8000);
                PRINT SUBSTRING(@dsql, 8000, 12000);
                PRINT SUBSTRING(@dsql, 12000, 16000);
                PRINT SUBSTRING(@dsql, 16000, 20000);
                PRINT SUBSTRING(@dsql, 20000, 24000);
                PRINT SUBSTRING(@dsql, 24000, 28000);
                PRINT SUBSTRING(@dsql, 28000, 32000);
                PRINT SUBSTRING(@dsql, 32000, 36000);
                PRINT SUBSTRING(@dsql, 36000, 40000);
            END;
        INSERT    #IndexColumns ( database_id, [schema_name], [object_id], index_id, key_ordinal, is_included_column, is_descending_key, partition_ordinal,
            column_name, system_type_name, max_length, precision, scale, collation_name, is_nullable, is_identity, is_computed,
            is_replicated, is_sparse, is_filestream )
                EXEC sp_executesql @dsql;
           
        SET @dsql = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
                SELECT  ' + CAST(@DatabaseID AS NVARCHAR(10)) + N' AS database_id, 
                        so.object_id, 
                        si.index_id, 
                        si.type,
                        @i_DatabaseName AS database_name, 
                        COALESCE(sc.NAME, ''Unknown'') AS [schema_name],
                        COALESCE(so.name, ''Unknown'') AS [object_name], 
                        COALESCE(si.name, ''Unknown'') AS [index_name],
                        CASE    WHEN so.[type] = CAST(''V'' AS CHAR(2)) THEN 1 ELSE 0 END, 
                        si.is_unique, 
                        si.is_primary_key, 
                        CASE when si.type = 3 THEN 1 ELSE 0 END AS is_XML,
                        CASE when si.type = 4 THEN 1 ELSE 0 END AS is_spatial,
                        CASE when si.type = 6 THEN 1 ELSE 0 END AS is_NC_columnstore,
                        CASE when si.type = 5 then 1 else 0 end as is_CX_columnstore,
                        CASE when si.data_space_id = 0 then 1 else 0 end as is_in_memory_oltp,
                        si.is_disabled,
                        si.is_hypothetical, 
                        si.is_padded, 
                        si.fill_factor,'
                        + CASE WHEN @SQLServerProductVersion NOT LIKE '9%' THEN N'
                        CASE WHEN si.filter_definition IS NOT NULL THEN si.filter_definition
                             ELSE N''''
                        END AS filter_definition' ELSE N''''' AS filter_definition' END + N'
                        , ISNULL(us.user_seeks, 0),
                        ISNULL(us.user_scans, 0),
                        ISNULL(us.user_lookups, 0),
                        ISNULL(us.user_updates, 0),
                        us.last_user_seek,
                        us.last_user_scan,
                        us.last_user_lookup,
                        us.last_user_update,
                        so.create_date,
                        so.modify_date
                FROM    ' + QUOTENAME(@DatabaseName) + N'.sys.indexes AS si WITH (NOLOCK)
                        JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.objects AS so WITH (NOLOCK) ON si.object_id = so.object_id
                                               AND so.is_ms_shipped = 0 /*Exclude objects shipped by Microsoft*/
                                               AND so.type <> ''TF'' /*Exclude table valued functions*/
                        JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.schemas sc ON so.schema_id = sc.schema_id
                        LEFT JOIN sys.dm_db_index_usage_stats AS us WITH (NOLOCK) ON si.[object_id] = us.[object_id]
                                                                       AND si.index_id = us.index_id
                                                                       AND us.database_id = ' + CAST(@DatabaseID AS NVARCHAR(10)) + N'
                WHERE    si.[type] IN ( 0, 1, 2, 3, 4, 5, 6 ) 
                /* Heaps, clustered, nonclustered, XML, spatial, Cluster Columnstore, NC Columnstore */ ' +
                CASE WHEN @TableName IS NOT NULL THEN N' and so.name=' + QUOTENAME(@TableName,N'''') + N' ' ELSE N'' END +
                CASE WHEN ( @IncludeInactiveIndexes = 0
                            AND @Mode IN (0, 4)
                            AND @TableName IS NULL )
                     THEN N'AND ( us.user_seeks + us.user_scans + us.user_lookups + us.user_updates ) > 0'
                     ELSE N''
                END
        + N'OPTION    ( RECOMPILE );
        ';
        IF @dsql IS NULL 
            RAISERROR('@dsql is null',16,1);

        RAISERROR (N'Inserting data into #IndexSanity',0,1) WITH NOWAIT;
        IF @Debug = 1
            BEGIN
                PRINT SUBSTRING(@dsql, 0, 4000);
                PRINT SUBSTRING(@dsql, 4000, 8000);
                PRINT SUBSTRING(@dsql, 8000, 12000);
                PRINT SUBSTRING(@dsql, 12000, 16000);
                PRINT SUBSTRING(@dsql, 16000, 20000);
                PRINT SUBSTRING(@dsql, 20000, 24000);
                PRINT SUBSTRING(@dsql, 24000, 28000);
                PRINT SUBSTRING(@dsql, 28000, 32000);
                PRINT SUBSTRING(@dsql, 32000, 36000);
                PRINT SUBSTRING(@dsql, 36000, 40000);
            END;
        INSERT    #IndexSanity ( [database_id], [object_id], [index_id], [index_type], [database_name], [schema_name], [object_name],
                                index_name, is_indexed_view, is_unique, is_primary_key, is_XML, is_spatial, is_NC_columnstore, is_CX_columnstore, is_in_memory_oltp,
                                is_disabled, is_hypothetical, is_padded, fill_factor, filter_definition, user_seeks, user_scans, 
                                user_lookups, user_updates, last_user_seek, last_user_scan, last_user_lookup, last_user_update,
                                create_date, modify_date )
                EXEC sp_executesql @dsql, @params = N'@i_DatabaseName NVARCHAR(128)', @i_DatabaseName = @DatabaseName;


        RAISERROR (N'Checking partition count',0,1) WITH NOWAIT;
        IF @BringThePain = 0 AND @SkipPartitions = 0 AND @TableName IS NULL
            BEGIN
                /* Count the total number of partitions */
                SET @dsql = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
                        SELECT @RowcountOUT = SUM(1) FROM ' + QUOTENAME(@DatabaseName) + '.sys.partitions WHERE partition_number > 1 OPTION    ( RECOMPILE );';
                EXEC sp_executesql @dsql, N'@RowcountOUT BIGINT OUTPUT', @RowcountOUT = @Rowcount OUTPUT;
                IF @Rowcount > 100
                    BEGIN
                        RAISERROR (N'Setting @SkipPartitions = 1 because > 100 partitions were found. To check them, you must set @BringThePain = 1.',0,1) WITH NOWAIT;
                        SET @SkipPartitions = 1;
                        INSERT    #BlitzIndexResults ( Priority, check_id, findings_group, finding, URL, details, index_definition,
                                                        index_usage_summary, index_size_summary )
                        VALUES  ( 1, 0 , 
		                       'Some Checks Were Skipped',
                               '@SkipPartitions Forced to 1',
                               'http://FirstResponderKit.org', CAST(@Rowcount AS NVARCHAR(50)) + ' partitions found. To analyze them, use @BringThePain = 1.', 'We try to keep things quick - and warning, running @BringThePain = 1 can take tens of minutes.', '', ''
                                );
                    END;
            END;



		 IF (@SkipPartitions = 0)
			BEGIN			
			IF (SELECT LEFT(@SQLServerProductVersion,
			      CHARINDEX('.',@SQLServerProductVersion,0)-1 )) <= 2147483647 --Make change here 			
			BEGIN
            
			RAISERROR (N'Preferring non-2012 syntax with LEFT JOIN to sys.dm_db_index_operational_stats',0,1) WITH NOWAIT;

            --NOTE: If you want to use the newer syntax for 2012+, you'll have to change 2147483647 to 11 on line ~819
			--This change was made because on a table with lots of paritions, the OUTER APPLY was crazy slow.
            SET @dsql = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
                        SELECT  ' + CAST(@DatabaseID AS NVARCHAR(10)) + N' AS database_id,
                                ps.object_id, 
								s.name,
                                ps.index_id, 
                                ps.partition_number, 
                                ps.row_count,
                                ps.reserved_page_count * 8. / 1024. AS reserved_MB,
                                ps.lob_reserved_page_count * 8. / 1024. AS reserved_LOB_MB,
                                ps.row_overflow_reserved_page_count * 8. / 1024. AS reserved_row_overflow_MB,
								le.lock_escalation_desc,
                            ' + CASE WHEN @SQLServerProductVersion NOT LIKE '9%' THEN N'par.data_compression_desc ' ELSE N'null as data_compression_desc ' END + N',
                                SUM(os.leaf_insert_count), 
                                SUM(os.leaf_delete_count), 
                                SUM(os.leaf_update_count), 
                                SUM(os.range_scan_count), 
                                SUM(os.singleton_lookup_count),  
                                SUM(os.forwarded_fetch_count),
                                SUM(os.lob_fetch_in_pages), 
                                SUM(os.lob_fetch_in_bytes), 
                                SUM(os.row_overflow_fetch_in_pages),
                                SUM(os.row_overflow_fetch_in_bytes), 
                                SUM(os.row_lock_count), 
                                SUM(os.row_lock_wait_count),
                                SUM(os.row_lock_wait_in_ms), 
                                SUM(os.page_lock_count), 
                                SUM(os.page_lock_wait_count), 
                                SUM(os.page_lock_wait_in_ms),
                                SUM(os.index_lock_promotion_attempt_count), 
                                SUM(os.index_lock_promotion_count), 
								SUM(os.page_latch_wait_count),
								SUM(os.page_latch_wait_in_ms),
								SUM(os.page_io_latch_wait_count),								
								SUM(os.page_io_latch_wait_in_ms), ';

		    /* Get columnstore dictionary size - more info: https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/issues/2585 */
			IF EXISTS (SELECT * FROM sys.all_objects WHERE name = 'column_store_dictionaries')
				SET @dsql = @dsql + N' COALESCE((SELECT SUM (on_disk_size / 1024.0 / 1024) FROM ' + QUOTENAME(@DatabaseName) + N'.sys.column_store_dictionaries dict WHERE dict.partition_id = ps.partition_id),0) AS reserved_dictionary_MB ';
			ELSE
				SET @dsql = @dsql + N' 0 AS reserved_dictionary_MB ';


            SET @dsql = @dsql + N'
			FROM    ' + QUOTENAME(@DatabaseName) + N'.sys.dm_db_partition_stats AS ps  
                    JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.partitions AS par on ps.partition_id=par.partition_id
                    JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.objects AS so ON ps.object_id = so.object_id
                               AND so.is_ms_shipped = 0 /*Exclude objects shipped by Microsoft*/
                               AND so.type <> ''TF'' /*Exclude table valued functions*/
					JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.schemas AS s ON s.schema_id = so.schema_id
                    LEFT JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.dm_db_index_operational_stats('
                + CAST(@DatabaseID AS NVARCHAR(10)) + N', NULL, NULL,NULL) AS os ON
                    ps.object_id=os.object_id and ps.index_id=os.index_id and ps.partition_number=os.partition_number 
			            OUTER APPLY (SELECT st.lock_escalation_desc
			                         FROM ' + QUOTENAME(@DatabaseName) + N'.sys.tables st
			                         WHERE st.object_id = ps.object_id
			                             AND ps.index_id < 2 ) le
                    WHERE 1=1 
                    ' + CASE WHEN @ObjectID IS NOT NULL THEN N'AND so.object_id=' + CAST(@ObjectID AS NVARCHAR(30)) + N' ' ELSE N' ' END + N'
                    ' + CASE WHEN @Filter = 2 THEN N'AND ps.reserved_page_count * 8./1024. > ' + CAST(@FilterMB AS NVARCHAR(5)) + N' ' ELSE N' ' END + N'
            GROUP BY ps.object_id, 
								s.name,
                                ps.index_id, 
                                ps.partition_number, 
								ps.partition_id,
                                ps.row_count,
                                ps.reserved_page_count,
                                ps.lob_reserved_page_count,
                                ps.row_overflow_reserved_page_count,
								le.lock_escalation_desc,
                            ' + CASE WHEN @SQLServerProductVersion NOT LIKE '9%' THEN N'par.data_compression_desc ' ELSE N'null as data_compression_desc ' END + N'
			ORDER BY ps.object_id,  ps.index_id, ps.partition_number
            OPTION    ( RECOMPILE );
            ';
        END;
        ELSE
        BEGIN
        RAISERROR (N'Using 2012 syntax to query sys.dm_db_index_operational_stats',0,1) WITH NOWAIT;
		--This is the syntax that will be used if you change 2147483647 to 11 on line ~819.
		--If you have a lot of paritions and this suddenly starts running for a long time, change it back.
         SET @dsql = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
                        SELECT  ' + CAST(@DatabaseID AS NVARCHAR(10)) + N' AS database_id,
                                ps.object_id, 
								s.name,
                                ps.index_id, 
                                ps.partition_number, 
                                ps.row_count,
                                ps.reserved_page_count * 8. / 1024. AS reserved_MB,
                                ps.lob_reserved_page_count * 8. / 1024. AS reserved_LOB_MB,
                                ps.row_overflow_reserved_page_count * 8. / 1024. AS reserved_row_overflow_MB,
								le.lock_escalation_desc,
                                ' + CASE WHEN @SQLServerProductVersion NOT LIKE '9%' THEN N'par.data_compression_desc ' ELSE N'null as data_compression_desc' END + N',
                                SUM(os.leaf_insert_count), 
                                SUM(os.leaf_delete_count), 
                                SUM(os.leaf_update_count), 
                                SUM(os.range_scan_count), 
                                SUM(os.singleton_lookup_count),  
                                SUM(os.forwarded_fetch_count),
                                SUM(os.lob_fetch_in_pages), 
                                SUM(os.lob_fetch_in_bytes), 
                                SUM(os.row_overflow_fetch_in_pages),
                                SUM(os.row_overflow_fetch_in_bytes), 
                                SUM(os.row_lock_count), 
                                SUM(os.row_lock_wait_count),
                                SUM(os.row_lock_wait_in_ms), 
                                SUM(os.page_lock_count), 
                                SUM(os.page_lock_wait_count), 
                                SUM(os.page_lock_wait_in_ms),
                                SUM(os.index_lock_promotion_attempt_count), 
                                SUM(os.index_lock_promotion_count),
								SUM(os.page_latch_wait_count),
								SUM(os.page_latch_wait_in_ms),
								SUM(os.page_io_latch_wait_count),								
								SUM(os.page_io_latch_wait_in_ms)';

		    /* Get columnstore dictionary size - more info: https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/issues/2585 */
			IF EXISTS (SELECT * FROM sys.all_objects WHERE name = 'column_store_dictionaries')
				SET @dsql = @dsql + N' COALESCE((SELECT SUM (on_disk_size / 1024.0 / 1024) FROM ' + QUOTENAME(@DatabaseName) + N'.sys.column_store_dictionaries dict WHERE dict.partition_id = ps.partition_id),0) AS reserved_dictionary_MB ';
			ELSE
				SET @dsql = @dsql + N' 0 AS reserved_dictionary_MB ';


            SET @dsql = @dsql + N'
                        FROM    ' + QUOTENAME(@DatabaseName) + N'.sys.dm_db_partition_stats AS ps  
                        JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.partitions AS par on ps.partition_id=par.partition_id
                        JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.objects AS so ON ps.object_id = so.object_id
                                   AND so.is_ms_shipped = 0 /*Exclude objects shipped by Microsoft*/
                                   AND so.type <> ''TF'' /*Exclude table valued functions*/
						JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.schemas AS s ON s.schema_id = so.schema_id
                        OUTER APPLY ' + QUOTENAME(@DatabaseName) + N'.sys.dm_db_index_operational_stats('
                    + CAST(@DatabaseID AS NVARCHAR(10)) + N', ps.object_id, ps.index_id,ps.partition_number) AS os
			            OUTER APPLY (SELECT st.lock_escalation_desc
			                         FROM ' + QUOTENAME(@DatabaseName) + N'.sys.tables st
			                         WHERE st.object_id = ps.object_id
			                             AND ps.index_id < 2 ) le
                        WHERE 1=1 
                        ' + CASE WHEN @ObjectID IS NOT NULL THEN N'AND so.object_id=' + CAST(@ObjectID AS NVARCHAR(30)) + N' ' ELSE N' ' END + N'
                        ' + CASE WHEN @Filter = 2 THEN N'AND ps.reserved_page_count * 8./1024. > ' + CAST(@FilterMB AS NVARCHAR(5)) + N' ' ELSE N' ' END + '
	            GROUP BY ps.object_id, 
								s.name,
                                ps.index_id, 
                                ps.partition_number,
								ps.partition_id,
                                ps.row_count,
                                ps.reserved_page_count,
                                ps.lob_reserved_page_count,
                                ps.row_overflow_reserved_page_count,
								le.lock_escalation_desc,
                            ' + CASE WHEN @SQLServerProductVersion NOT LIKE '9%' THEN N'par.data_compression_desc ' ELSE N'null as data_compression_desc ' END + N'
				ORDER BY ps.object_id,  ps.index_id, ps.partition_number
                OPTION    ( RECOMPILE );
                ';
        END;       

        IF @dsql IS NULL 
            RAISERROR('@dsql is null',16,1);

        RAISERROR (N'Inserting data into #IndexPartitionSanity',0,1) WITH NOWAIT;
        IF @Debug = 1
            BEGIN
                PRINT SUBSTRING(@dsql, 0, 4000);
                PRINT SUBSTRING(@dsql, 4000, 8000);
                PRINT SUBSTRING(@dsql, 8000, 12000);
                PRINT SUBSTRING(@dsql, 12000, 16000);
                PRINT SUBSTRING(@dsql, 16000, 20000);
                PRINT SUBSTRING(@dsql, 20000, 24000);
                PRINT SUBSTRING(@dsql, 24000, 28000);
                PRINT SUBSTRING(@dsql, 28000, 32000);
                PRINT SUBSTRING(@dsql, 32000, 36000);
                PRINT SUBSTRING(@dsql, 36000, 40000);
            END;
        INSERT    #IndexPartitionSanity ( [database_id],
                                          [object_id], 
										  [schema_name],
                                          index_id, 
                                          partition_number, 
                                          row_count, 
                                          reserved_MB,
                                          reserved_LOB_MB, 
                                          reserved_row_overflow_MB,
										  lock_escalation_desc,										   
                                          data_compression_desc, 
                                          leaf_insert_count,
                                          leaf_delete_count, 
                                          leaf_update_count, 
                                          range_scan_count,
                                          singleton_lookup_count,
                                          forwarded_fetch_count, 
                                          lob_fetch_in_pages, 
                                          lob_fetch_in_bytes, 
                                          row_overflow_fetch_in_pages,
                                          row_overflow_fetch_in_bytes, 
                                          row_lock_count, 
                                          row_lock_wait_count,
                                          row_lock_wait_in_ms, 
                                          page_lock_count, 
                                          page_lock_wait_count,
                                          page_lock_wait_in_ms, 
                                          index_lock_promotion_attempt_count,
                                          index_lock_promotion_count,
								          page_latch_wait_count,
								          page_latch_wait_in_ms,
								          page_io_latch_wait_count,								
								          page_io_latch_wait_in_ms,
										  reserved_dictionary_MB)
                EXEC sp_executesql @dsql;
        
		END; --End Check For @SkipPartitions = 0



        RAISERROR (N'Inserting data into #MissingIndexes',0,1) WITH NOWAIT;
        SET @dsql=N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;'


		SET @dsql = @dsql + 'WITH ColumnNamesWithDataTypes AS(SELECT id.index_handle,id.object_id,cn.IndexColumnType,STUFF((SELECT '', '' + cn_inner.ColumnName + '' '' +
			N'' {'' + CASE	 WHEN ty.name IN ( ''varchar'', ''char'' ) THEN ty.name + ''('' + CASE WHEN co.max_length = -1 THEN ''max'' ELSE CAST(co.max_length AS VARCHAR(25)) END + '')''
								WHEN ty.name IN ( ''nvarchar'', ''nchar'' ) THEN ty.name + ''('' + CASE WHEN co.max_length = -1 THEN ''max'' ELSE CAST(co.max_length / 2 AS VARCHAR(25)) END + '')''
								WHEN ty.name IN ( ''decimal'', ''numeric'' ) THEN ty.name + ''('' + CAST(co.precision AS VARCHAR(25)) + '', '' + CAST(co.scale AS VARCHAR(25)) + '')''
								WHEN ty.name IN ( ''datetime2'' ) THEN ty.name + ''('' + CAST(co.scale AS VARCHAR(25)) + '')''
								ELSE ty.name END + ''}''
				FROM	' + QUOTENAME(@DatabaseName) + N'.sys.dm_db_missing_index_details AS id_inner
				CROSS APPLY(
					SELECT	LTRIM(RTRIM(v.value(''(./text())[1]'', ''varchar(max)''))) AS ColumnName, ''Equality'' AS IndexColumnType
					FROM	(VALUES (CONVERT(XML, N''<x>'' + REPLACE((SELECT CAST(id_inner.equality_columns AS nvarchar(max)) FOR XML PATH('''')), N'','', N''</x><x>'') + N''</x>''))) x(n)
					CROSS APPLY n.nodes(''x'') node(v)
				UNION ALL
					SELECT	LTRIM(RTRIM(v.value(N''(./text())[1]'', ''varchar(max)''))) AS ColumnName, ''Inequality'' AS IndexColumnType
					FROM	(VALUES (CONVERT(XML, N''<x>'' + REPLACE((SELECT CAST(id_inner.inequality_columns AS nvarchar(max)) FOR XML PATH('''')), N'','', N''</x><x>'') + N''</x>''))) x(n)
					CROSS APPLY n.nodes(''x'') node(v)
				UNION ALL
					SELECT	LTRIM(RTRIM(v.value(''(./text())[1]'', ''varchar(max)''))) AS ColumnName, ''Included'' AS IndexColumnType
					FROM	(VALUES (CONVERT(XML, N''<x>'' + REPLACE((SELECT CAST(id_inner.included_columns AS nvarchar(max)) FOR XML PATH('''')), N'','', N''</x><x>'') + N''</x>''))) x(n)
					CROSS APPLY n.nodes(''x'') node(v)
			)AS cn_inner'
		+ /*split the string otherwise dsql cuts some of it out*/
		'		JOIN	' + QUOTENAME(@DatabaseName) + N'.sys.columns AS co ON co.object_id = id_inner.object_id AND ''['' + co.name + '']'' = cn_inner.ColumnName
				JOIN	' + QUOTENAME(@DatabaseName) + N'.sys.types AS ty ON ty.user_type_id = co.user_type_id 
                WHERE id_inner.index_handle = id.index_handle
				AND	id_inner.object_id = id.object_id
				AND cn_inner.IndexColumnType = cn.IndexColumnType
				FOR XML PATH('''')
			 ),1,1,'''') AS ReplaceColumnNames
            FROM ' + QUOTENAME(@DatabaseName) + N'.sys.dm_db_missing_index_details AS id
           CROSS APPLY(
						SELECT	LTRIM(RTRIM(v.value(''(./text())[1]'', ''varchar(max)''))) AS ColumnName, ''Equality'' AS IndexColumnType
						FROM	(VALUES (CONVERT(XML, N''<x>'' + REPLACE((SELECT CAST(id.equality_columns AS nvarchar(max)) FOR XML PATH('''')), N'','', N''</x><x>'') + N''</x>''))) x(n)
						CROSS APPLY n.nodes(''x'') node(v)
				    UNION ALL
						SELECT	LTRIM(RTRIM(v.value(''(./text())[1]'', ''varchar(max)''))) AS ColumnName, ''Inequality'' AS IndexColumnType
						FROM	(VALUES (CONVERT(XML, N''<x>'' + REPLACE((SELECT CAST(id.inequality_columns AS nvarchar(max)) FOR XML PATH('''')), N'','', N''</x><x>'') + N''</x>''))) x(n)
						CROSS APPLY n.nodes(''x'') node(v)
				    UNION ALL
						SELECT	LTRIM(RTRIM(v.value(''(./text())[1]'', ''varchar(max)''))) AS ColumnName, ''Included'' AS IndexColumnType
						FROM	(VALUES (CONVERT(XML, N''<x>'' + REPLACE((SELECT CAST(id.included_columns AS nvarchar(max)) FOR XML PATH('''')), N'','', N''</x><x>'') + N''</x>''))) x(n)
						CROSS APPLY n.nodes(''x'') node(v)
					)AS cn
				GROUP BY	id.index_handle,id.object_id,cn.IndexColumnType
				)
                SELECT  id.database_id, id.object_id, @i_DatabaseName, sc.[name], so.[name], id.statement , gs.avg_total_user_cost, 
                        gs.avg_user_impact, gs.user_seeks, gs.user_scans, gs.unique_compiles, id.equality_columns, id.inequality_columns, id.included_columns,
				(
                    SELECT ColumnNamesWithDataTypes.ReplaceColumnNames 
                    FROM ColumnNamesWithDataTypes WHERE ColumnNamesWithDataTypes.index_handle = id.index_handle
                    AND ColumnNamesWithDataTypes.object_id = id.object_id
                    AND ColumnNamesWithDataTypes.IndexColumnType = ''Equality''
                ) AS equality_columns_with_data_type
                ,(
                    SELECT ColumnNamesWithDataTypes.ReplaceColumnNames 
                    FROM ColumnNamesWithDataTypes WHERE ColumnNamesWithDataTypes.index_handle = id.index_handle
                    AND ColumnNamesWithDataTypes.object_id = id.object_id
                    AND ColumnNamesWithDataTypes.IndexColumnType = ''Inequality''
                ) AS inequality_columns_with_data_type
                ,(
                    SELECT ColumnNamesWithDataTypes.ReplaceColumnNames 
                    FROM ColumnNamesWithDataTypes WHERE ColumnNamesWithDataTypes.index_handle = id.index_handle
                    AND ColumnNamesWithDataTypes.object_id = id.object_id
                    AND ColumnNamesWithDataTypes.IndexColumnType = ''Included''
                ) AS included_columns_with_data_type '

		/* Github #2780 BGO Removing SQL Server 2019's new missing index sample plan because it doesn't work yet:
        IF NOT EXISTS (SELECT * FROM sys.all_objects WHERE name = 'dm_db_missing_index_group_stats_query')
        */
			SET @dsql = @dsql + N' , NULL AS sample_query_plan '
		/* Github #2780 BGO Removing SQL Server 2019's new missing index sample plan because it doesn't work yet:
        ELSE
		BEGIN
			SET @dsql = @dsql + N' , sample_query_plan = (SELECT TOP 1 p.query_plan
				FROM sys.dm_db_missing_index_group_stats gs 
				CROSS APPLY (SELECT TOP 1 s.plan_handle 
					FROM sys.dm_db_missing_index_group_stats_query q 
					INNER JOIN sys.dm_exec_query_stats s ON q.query_plan_hash = s.query_plan_hash
					WHERE gs.group_handle = q.group_handle 
					ORDER BY (q.user_seeks + q.user_scans) DESC, s.total_logical_reads DESC) q2
				CROSS APPLY sys.dm_exec_query_plan(q2.plan_handle) p
				WHERE gs.group_handle = gs.group_handle) '
		END
        */
        

		SET @dsql = @dsql + N'FROM    ' + QUOTENAME(@DatabaseName) + N'.sys.dm_db_missing_index_groups ig
                        JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.dm_db_missing_index_details id ON ig.index_handle = id.index_handle
                        JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.dm_db_missing_index_group_stats gs ON ig.index_group_handle = gs.group_handle
                        JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.objects so on 
                            id.object_id=so.object_id
                        JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.schemas sc on 
                            so.schema_id=sc.schema_id
                WHERE    id.database_id = ' + CAST(@DatabaseID AS NVARCHAR(30)) + '
                ' + CASE WHEN @ObjectID IS NULL THEN N'' 
                    ELSE N'and id.object_id=' + CAST(@ObjectID AS NVARCHAR(30)) 
                END +
        N'OPTION (RECOMPILE);';

        IF @dsql IS NULL 
            RAISERROR('@dsql is null',16,1);
        IF @Debug = 1
            BEGIN
                PRINT SUBSTRING(@dsql, 0, 4000);
                PRINT SUBSTRING(@dsql, 4000, 8000);
                PRINT SUBSTRING(@dsql, 8000, 12000);
                PRINT SUBSTRING(@dsql, 12000, 16000);
                PRINT SUBSTRING(@dsql, 16000, 20000);
                PRINT SUBSTRING(@dsql, 20000, 24000);
                PRINT SUBSTRING(@dsql, 24000, 28000);
                PRINT SUBSTRING(@dsql, 28000, 32000);
                PRINT SUBSTRING(@dsql, 32000, 36000);
                PRINT SUBSTRING(@dsql, 36000, 40000);
            END;
        INSERT    #MissingIndexes ( [database_id], [object_id], [database_name], [schema_name], [table_name], [statement], avg_total_user_cost, 
                                    avg_user_impact, user_seeks, user_scans, unique_compiles, equality_columns, 
                                    inequality_columns, included_columns, equality_columns_with_data_type, inequality_columns_with_data_type, 
                                    included_columns_with_data_type, sample_query_plan)
        EXEC sp_executesql @dsql, @params = N'@i_DatabaseName NVARCHAR(128)', @i_DatabaseName = @DatabaseName;

        SET @dsql = N'
            SELECT DB_ID(N' + QUOTENAME(@DatabaseName,'''') + N') AS [database_id], 
			    @i_DatabaseName AS database_name,
				s.name,
                fk_object.name AS foreign_key_name,
                parent_object.[object_id] AS parent_object_id,
                parent_object.name AS parent_object_name,
                referenced_object.[object_id] AS referenced_object_id,
                referenced_object.name AS referenced_object_name,
                fk.is_disabled,
                fk.is_not_trusted,
                fk.is_not_for_replication,
                parent.fk_columns,
                referenced.fk_columns,
                [update_referential_action_desc],
                [delete_referential_action_desc]
            FROM ' + QUOTENAME(@DatabaseName) + N'.sys.foreign_keys fk
            JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.objects fk_object ON fk.object_id=fk_object.object_id
            JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.objects parent_object ON fk.parent_object_id=parent_object.object_id
            JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.objects referenced_object ON fk.referenced_object_id=referenced_object.object_id
			JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.schemas AS s ON fk.schema_id=s.schema_id
            CROSS APPLY ( SELECT  STUFF( (SELECT  N'', '' + c_parent.name AS fk_columns
                                            FROM    ' + QUOTENAME(@DatabaseName) + N'.sys.foreign_key_columns fkc 
                                            JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.columns c_parent ON fkc.parent_object_id=c_parent.[object_id]
                                                AND fkc.parent_column_id=c_parent.column_id
                                            WHERE    fk.parent_object_id=fkc.parent_object_id
                                                AND fk.[object_id]=fkc.constraint_object_id
                                            ORDER BY fkc.constraint_column_id 
                                    FOR      XML PATH('''') ,
                                              TYPE).value(''.'', ''nvarchar(max)''), 1, 1, '''')/*This is how we remove the first comma*/ ) parent ( fk_columns )
            CROSS APPLY ( SELECT  STUFF( (SELECT  N'', '' + c_referenced.name AS fk_columns
                                            FROM    ' + QUOTENAME(@DatabaseName) + N'.sys.    foreign_key_columns fkc 
                                            JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.columns c_referenced ON fkc.referenced_object_id=c_referenced.[object_id]
                                                AND fkc.referenced_column_id=c_referenced.column_id
                                            WHERE    fk.referenced_object_id=fkc.referenced_object_id
                                                and fk.[object_id]=fkc.constraint_object_id
                                            ORDER BY fkc.constraint_column_id  /*order by col name, we don''t have anything better*/
                                    FOR      XML PATH('''') ,
                                              TYPE).value(''.'', ''nvarchar(max)''), 1, 1, '''') ) referenced ( fk_columns )
            ' + CASE WHEN @ObjectID IS NOT NULL THEN 
                    'WHERE fk.parent_object_id=' + CAST(@ObjectID AS NVARCHAR(30)) + N' OR fk.referenced_object_id=' + CAST(@ObjectID AS NVARCHAR(30)) + N' ' 
                    ELSE N' ' END + '
            ORDER BY parent_object_name, foreign_key_name
			OPTION (RECOMPILE);';
        IF @dsql IS NULL 
            RAISERROR('@dsql is null',16,1);

        RAISERROR (N'Inserting data into #ForeignKeys',0,1) WITH NOWAIT;
        IF @Debug = 1
            BEGIN
                PRINT SUBSTRING(@dsql, 0, 4000);
                PRINT SUBSTRING(@dsql, 4000, 8000);
                PRINT SUBSTRING(@dsql, 8000, 12000);
                PRINT SUBSTRING(@dsql, 12000, 16000);
                PRINT SUBSTRING(@dsql, 16000, 20000);
                PRINT SUBSTRING(@dsql, 20000, 24000);
                PRINT SUBSTRING(@dsql, 24000, 28000);
                PRINT SUBSTRING(@dsql, 28000, 32000);
                PRINT SUBSTRING(@dsql, 32000, 36000);
                PRINT SUBSTRING(@dsql, 36000, 40000);
            END;
        INSERT  #ForeignKeys ( [database_id], [database_name], [schema_name], foreign_key_name, parent_object_id,parent_object_name, referenced_object_id, referenced_object_name,
                                is_disabled, is_not_trusted, is_not_for_replication, parent_fk_columns, referenced_fk_columns,
                                [update_referential_action_desc], [delete_referential_action_desc] )
                EXEC sp_executesql @dsql, @params = N'@i_DatabaseName NVARCHAR(128)', @i_DatabaseName = @DatabaseName;


		IF @SkipStatistics = 0 /* AND DB_NAME() = @DatabaseName /* Can only get stats in the current database - see https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/issues/1947 */ */
			BEGIN
		IF  ((PARSENAME(@SQLServerProductVersion, 4) >= 12)
		OR   (PARSENAME(@SQLServerProductVersion, 4) = 11 AND PARSENAME(@SQLServerProductVersion, 2) >= 3000)
		OR   (PARSENAME(@SQLServerProductVersion, 4) = 10 AND PARSENAME(@SQLServerProductVersion, 3) = 50 AND PARSENAME(@SQLServerProductVersion, 2) >= 2500))
		BEGIN
		RAISERROR (N'Gathering Statistics Info With Newer Syntax.',0,1) WITH NOWAIT;
		SET @dsql=N'USE ' + @DatabaseName + N'; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
			INSERT #Statistics ( database_id, database_name, table_name, schema_name, index_name, column_names, statistics_name, last_statistics_update, 
								days_since_last_stats_update, rows, rows_sampled, percent_sampled, histogram_steps, modification_counter, 
								percent_modifications, modifications_before_auto_update, index_type_desc, table_create_date, table_modify_date,
								no_recompute, has_filter, filter_definition)
				SELECT DB_ID(N' + QUOTENAME(@DatabaseName,'''') + N') AS [database_id], 
				    @i_DatabaseName AS database_name,
					obj.name AS table_name,
					sch.name AS schema_name,
			        ISNULL(i.name, ''System Or User Statistic'') AS index_name,
			        ca.column_names AS column_names,
			        s.name AS statistics_name,
			        CONVERT(DATETIME, ddsp.last_updated) AS last_statistics_update,
			        DATEDIFF(DAY, ddsp.last_updated, GETDATE()) AS days_since_last_stats_update,
			        ddsp.rows,
			        ddsp.rows_sampled,
			        CAST(ddsp.rows_sampled / ( 1. * NULLIF(ddsp.rows, 0) ) * 100 AS DECIMAL(18, 1)) AS percent_sampled,
			        ddsp.steps AS histogram_steps,
			        ddsp.modification_counter,
			        CASE WHEN ddsp.modification_counter > 0
			             THEN CAST(ddsp.modification_counter / ( 1. * NULLIF(ddsp.rows, 0) ) * 100 AS DECIMAL(18, 1))
			             ELSE ddsp.modification_counter
			        END AS percent_modifications,
			        CASE WHEN ddsp.rows < 500 THEN 500
			             ELSE CAST(( ddsp.rows * .20 ) + 500 AS INT)
			        END AS modifications_before_auto_update,
			        ISNULL(i.type_desc, ''System Or User Statistic - N/A'') AS index_type_desc,
			        CONVERT(DATETIME, obj.create_date) AS table_create_date,
			        CONVERT(DATETIME, obj.modify_date) AS table_modify_date,
					s.no_recompute,
					s.has_filter,
					s.filter_definition
			FROM    ' + QUOTENAME(@DatabaseName) + N'.sys.stats AS s
			JOIN    ' + QUOTENAME(@DatabaseName) + N'.sys.objects obj
			ON      s.object_id = obj.object_id
			JOIN    ' + QUOTENAME(@DatabaseName) + N'.sys.schemas sch
			ON		sch.schema_id = obj.schema_id
			LEFT JOIN    ' + QUOTENAME(@DatabaseName) + N'.sys.indexes AS i
			ON      i.object_id = s.object_id
			        AND i.index_id = s.stats_id
			OUTER APPLY ' + QUOTENAME(@DatabaseName) + N'.sys.dm_db_stats_properties(s.object_id, s.stats_id) AS ddsp
			CROSS APPLY ( SELECT  STUFF((SELECT   '', '' + c.name
						  FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.stats_columns AS sc
						  JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.columns AS c
						  ON       sc.column_id = c.column_id AND sc.object_id = c.object_id
						  WHERE    sc.stats_id = s.stats_id AND sc.object_id = s.object_id
						  ORDER BY sc.stats_column_id
						  FOR   XML PATH(''''), TYPE).value(''.'', ''nvarchar(max)''), 1, 2, '''') 
						) ca (column_names)
			WHERE obj.is_ms_shipped = 0
			OPTION (RECOMPILE);';
			
			IF @dsql IS NULL 
            RAISERROR('@dsql is null',16,1);

			RAISERROR (N'Inserting data into #Statistics',0,1) WITH NOWAIT;
            IF @Debug = 1
                BEGIN
                    PRINT SUBSTRING(@dsql, 0, 4000);
                    PRINT SUBSTRING(@dsql, 4000, 8000);
                    PRINT SUBSTRING(@dsql, 8000, 12000);
                    PRINT SUBSTRING(@dsql, 12000, 16000);
                    PRINT SUBSTRING(@dsql, 16000, 20000);
                    PRINT SUBSTRING(@dsql, 20000, 24000);
                    PRINT SUBSTRING(@dsql, 24000, 28000);
                    PRINT SUBSTRING(@dsql, 28000, 32000);
                    PRINT SUBSTRING(@dsql, 32000, 36000);
                    PRINT SUBSTRING(@dsql, 36000, 40000);
                END;
			
			EXEC sp_executesql @dsql, @params = N'@i_DatabaseName NVARCHAR(128)', @i_DatabaseName = @DatabaseName;
			END;
			ELSE 
			BEGIN
			RAISERROR (N'Gathering Statistics Info With Older Syntax.',0,1) WITH NOWAIT;
			SET @dsql=N'USE ' + @DatabaseName + N'; SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
			INSERT #Statistics(database_id, database_name, table_name, schema_name, index_name, column_names, statistics_name, 
								last_statistics_update, days_since_last_stats_update, rows, modification_counter, 
								percent_modifications, modifications_before_auto_update, index_type_desc, table_create_date, table_modify_date,
								no_recompute, has_filter, filter_definition)
							SELECT DB_ID(N' + QUOTENAME(@DatabaseName,'''') + N') AS [database_id], 
							    @i_DatabaseName AS database_name,
								obj.name AS table_name,
								sch.name AS schema_name,
						        ISNULL(i.name, ''System Or User Statistic'') AS index_name,
						        ca.column_names  AS column_names,
						        s.name AS statistics_name,
						        CONVERT(DATETIME, STATS_DATE(s.object_id, s.stats_id)) AS last_statistics_update,
						        DATEDIFF(DAY, STATS_DATE(s.object_id, s.stats_id), GETDATE()) AS days_since_last_stats_update,
						        si.rowcnt,
						        si.rowmodctr,
						        CASE WHEN si.rowmodctr > 0 THEN CAST(si.rowmodctr / ( 1. * NULLIF(si.rowcnt, 0) ) * 100 AS DECIMAL(18, 1))
						             ELSE si.rowmodctr
						        END AS percent_modifications,
						        CASE WHEN si.rowcnt < 500 THEN 500
						             ELSE CAST(( si.rowcnt * .20 ) + 500 AS INT)
						        END AS modifications_before_auto_update,
						        ISNULL(i.type_desc, ''System Or User Statistic - N/A'') AS index_type_desc,
						        CONVERT(DATETIME, obj.create_date) AS table_create_date,
						        CONVERT(DATETIME, obj.modify_date) AS table_modify_date,
								s.no_recompute,
								'
								+ CASE WHEN @SQLServerProductVersion NOT LIKE '9%' 
								THEN N's.has_filter,
									   s.filter_definition' 
								ELSE N'NULL AS has_filter,
								       NULL AS filter_definition' END 
						+ N'								
						FROM    ' + QUOTENAME(@DatabaseName) + N'.sys.stats AS s
						INNER HASH JOIN    ' + QUOTENAME(@DatabaseName) + N'.sys.sysindexes si
						ON      si.name = s.name AND s.object_id = si.id
						INNER HASH JOIN    ' + QUOTENAME(@DatabaseName) + N'.sys.objects obj
						ON      s.object_id = obj.object_id
						INNER HASH JOIN    ' + QUOTENAME(@DatabaseName) + N'.sys.schemas sch
						ON		sch.schema_id = obj.schema_id
						LEFT HASH JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.indexes AS i
						ON      i.object_id = s.object_id
						        AND i.index_id = s.stats_id
						CROSS APPLY ( SELECT  STUFF((SELECT   '', '' + c.name
									  FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.stats_columns AS sc
									  JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.columns AS c
									  ON       sc.column_id = c.column_id AND sc.object_id = c.object_id
									  WHERE    sc.stats_id = s.stats_id AND sc.object_id = s.object_id
									  ORDER BY sc.stats_column_id
									  FOR   XML PATH(''''), TYPE).value(''.'', ''nvarchar(max)''), 1, 2, '''') 
									) ca (column_names)
						WHERE obj.is_ms_shipped = 0
						AND si.rowcnt > 0
						OPTION (RECOMPILE);';

			IF @dsql IS NULL 
            RAISERROR('@dsql is null',16,1);

			RAISERROR (N'Inserting data into #Statistics',0,1) WITH NOWAIT;
            IF @Debug = 1
                BEGIN
                    PRINT SUBSTRING(@dsql, 0, 4000);
                    PRINT SUBSTRING(@dsql, 4000, 8000);
                    PRINT SUBSTRING(@dsql, 8000, 12000);
                    PRINT SUBSTRING(@dsql, 12000, 16000);
                    PRINT SUBSTRING(@dsql, 16000, 20000);
                    PRINT SUBSTRING(@dsql, 20000, 24000);
                    PRINT SUBSTRING(@dsql, 24000, 28000);
                    PRINT SUBSTRING(@dsql, 28000, 32000);
                    PRINT SUBSTRING(@dsql, 32000, 36000);
                    PRINT SUBSTRING(@dsql, 36000, 40000);
                END;
			
			EXEC sp_executesql @dsql, @params = N'@i_DatabaseName NVARCHAR(128)', @i_DatabaseName = @DatabaseName;
			END;

			END;

			IF  (PARSENAME(@SQLServerProductVersion, 4) >= 10)
			BEGIN
			RAISERROR (N'Gathering Computed Column Info.',0,1) WITH NOWAIT;
			SET @dsql=N'SELECT DB_ID(@i_DatabaseName) AS [database_id], 
							   @i_DatabaseName AS database_name,
   					   		   t.name AS table_name,
   					           s.name AS schema_name,
   					           c.name AS column_name,
   					           cc.is_nullable,
   					           cc.definition,
   					           cc.uses_database_collation,
   					           cc.is_persisted,
   					           cc.is_computed,
   					   		   CASE WHEN cc.definition LIKE ''%|].|[%'' ESCAPE ''|'' THEN 1 ELSE 0 END AS is_function,
   					   		   ''ALTER TABLE '' + QUOTENAME(s.name) + ''.'' + QUOTENAME(t.name) + 
   					   		   '' ADD '' + QUOTENAME(c.name) + '' AS '' + cc.definition  + 
							   CASE WHEN is_persisted = 1 THEN '' PERSISTED'' ELSE '''' END + '';'' COLLATE DATABASE_DEFAULT AS [column_definition]
   					   FROM    ' + QUOTENAME(@DatabaseName) + N'.sys.computed_columns AS cc
   					   JOIN    ' + QUOTENAME(@DatabaseName) + N'.sys.columns AS c
   					   ON      cc.object_id = c.object_id
   					   		   AND cc.column_id = c.column_id
   					   JOIN    ' + QUOTENAME(@DatabaseName) + N'.sys.tables AS t
   					   ON      t.object_id = cc.object_id
   					   JOIN    ' + QUOTENAME(@DatabaseName) + N'.sys.schemas AS s
   					   ON      s.schema_id = t.schema_id
					   OPTION (RECOMPILE);';

			IF @dsql IS NULL RAISERROR('@dsql is null',16,1);

			INSERT #ComputedColumns
			        ( database_id, [database_name], table_name, schema_name, column_name, is_nullable, definition, 
					  uses_database_collation, is_persisted, is_computed, is_function, column_definition )			
			EXEC sp_executesql @dsql, @params = N'@i_DatabaseName NVARCHAR(128)', @i_DatabaseName = @DatabaseName;

			END; 
			
			RAISERROR (N'Gathering Trace Flag Information',0,1) WITH NOWAIT;
			INSERT #TraceStatus
			EXEC ('DBCC TRACESTATUS(-1) WITH NO_INFOMSGS');			

			IF  (PARSENAME(@SQLServerProductVersion, 4) >= 13)
			BEGIN
			RAISERROR (N'Gathering Temporal Table Info',0,1) WITH NOWAIT;
			SET @dsql=N'SELECT ' + QUOTENAME(@DatabaseName,'''') + N' AS database_name,
								   DB_ID(N' + QUOTENAME(@DatabaseName,'''') + N') AS [database_id], 
								   s.name AS schema_name,
								   t.name AS table_name, 
								   oa.hsn as history_schema_name,
								   oa.htn AS history_table_name, 
								   c1.name AS start_column_name,
								   c2.name AS end_column_name,
								   p.name AS period_name
							FROM ' + QUOTENAME(@DatabaseName) + N'.sys.periods AS p
							INNER JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.tables AS t
							ON  p.object_id = t.object_id
							INNER JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.columns AS c1
							ON  t.object_id = c1.object_id
							    AND p.start_column_id = c1.column_id
							INNER JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.columns AS c2
							ON  t.object_id = c2.object_id
							    AND p.end_column_id = c2.column_id
							INNER JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.schemas AS s
							ON t.schema_id = s.schema_id
							CROSS APPLY ( SELECT s2.name as hsn, t2.name htn
							              FROM ' + QUOTENAME(@DatabaseName) + N'.sys.tables AS t2
										  INNER JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.schemas AS s2
										  ON t2.schema_id = s2.schema_id
							              WHERE t2.object_id = t.history_table_id
							              AND t2.temporal_type = 1 /*History table*/ ) AS oa
							WHERE t.temporal_type IN ( 2, 4 ) /*BOL currently points to these types, but has no definition for 4*/
							OPTION (RECOMPILE);
							';
			
			IF @dsql IS NULL 
			RAISERROR('@dsql is null',16,1);
			
			INSERT #TemporalTables ( database_name, database_id, schema_name, table_name, history_schema_name, 
									 history_table_name, start_column_name, end_column_name, period_name )
					
			EXEC sp_executesql @dsql;

             SET @dsql=N'SELECT DB_ID(@i_DatabaseName) AS [database_id], 
             				   @i_DatabaseName AS database_name,
             		   		   t.name AS table_name,
             		           s.name AS schema_name,
             		           cc.name AS constraint_name,
             		           cc.is_disabled,
             		           cc.definition,
             		           cc.uses_database_collation,
             		           cc.is_not_trusted,
             		   		   CASE WHEN cc.definition LIKE ''%|].|[%'' ESCAPE ''|'' THEN 1 ELSE 0 END AS is_function,
             		   		   ''ALTER TABLE '' + QUOTENAME(s.name) + ''.'' + QUOTENAME(t.name) + 
             		   		   '' ADD CONSTRAINT '' + QUOTENAME(cc.name) + '' CHECK '' + cc.definition  + '';'' COLLATE DATABASE_DEFAULT AS [column_definition]
             		   FROM    ' + QUOTENAME(@DatabaseName) + N'.sys.check_constraints AS cc
             		   JOIN    ' + QUOTENAME(@DatabaseName) + N'.sys.tables AS t
             		   ON      t.object_id = cc.parent_object_id
             		   JOIN    ' + QUOTENAME(@DatabaseName) + N'.sys.schemas AS s
             		   ON      s.schema_id = t.schema_id
             		   OPTION (RECOMPILE);';
             
             INSERT #CheckConstraints
                     ( database_id, [database_name], table_name, schema_name, constraint_name, is_disabled, definition, 
             		  uses_database_collation, is_not_trusted, is_function, column_definition )		
             EXEC sp_executesql @dsql, @params = N'@i_DatabaseName NVARCHAR(128)', @i_DatabaseName = @DatabaseName;


            SET @dsql=N'SELECT DB_ID(@i_DatabaseName) AS [database_id], 
             				   @i_DatabaseName AS database_name,
                               s.name AS missing_schema_name,
                               t.name AS missing_table_name,
                               i.name AS missing_index_name,
                               c.name AS missing_column_name
                        FROM   ' + QUOTENAME(@DatabaseName) + N'.sys.sql_expression_dependencies AS sed
                        JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.tables AS t
                            ON t.object_id = sed.referenced_id
                        JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.schemas AS s
                            ON t.schema_id = s.schema_id
                        JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.indexes AS i
                            ON i.object_id = sed.referenced_id
                            AND i.index_id = sed.referencing_minor_id
                        JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.columns AS c
                            ON c.object_id = sed.referenced_id
                            AND c.column_id = sed.referenced_minor_id
                        WHERE  sed.referencing_class = 7
                        AND    sed.referenced_class = 1
                        AND    i.has_filter = 1
                        AND    NOT EXISTS (   SELECT 1/0
                                              FROM   ' + QUOTENAME(@DatabaseName) + N'.sys.index_columns AS ic
                                              WHERE  ic.index_id = sed.referencing_minor_id
                                              AND    ic.column_id = sed.referenced_minor_id
                                              AND    ic.object_id = sed.referenced_id )
                        OPTION(RECOMPILE);'

                INSERT #FilteredIndexes ( database_id, database_name, schema_name, table_name, index_name, column_name )
                EXEC sp_executesql @dsql, @params = N'@i_DatabaseName NVARCHAR(128)', @i_DatabaseName = @DatabaseName;


    END;
			
END;                    
END TRY
BEGIN CATCH
        RAISERROR (N'Failure populating temp tables.', 0,1) WITH NOWAIT;

        IF @dsql IS NOT NULL
        BEGIN
            SET @msg= 'Last @dsql: ' + @dsql;
            RAISERROR(@msg, 0, 1) WITH NOWAIT;
        END;

        SELECT  @msg = @DatabaseName + N' database failed to process. ' + ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
        RAISERROR (@msg,@ErrorSeverity, @ErrorState )WITH NOWAIT;
        
        
        WHILE @@trancount > 0 
            ROLLBACK;

        RETURN;
END CATCH;
 FETCH NEXT FROM c1 INTO @DatabaseName;
END;
DEALLOCATE c1;






----------------------------------------
--STEP 2: PREP THE TEMP TABLES
--EVERY QUERY AFTER THIS GOES AGAINST TEMP TABLES ONLY.
----------------------------------------

RAISERROR (N'Updating #IndexSanity.key_column_names',0,1) WITH NOWAIT;
UPDATE    #IndexSanity
SET        key_column_names = D1.key_column_names
FROM    #IndexSanity si
        CROSS APPLY ( SELECT  RTRIM(STUFF( (SELECT  N', ' + c.column_name 
                            + N' {' + system_type_name + N' ' +
							CASE max_length WHEN -1 THEN N'(max)' ELSE
								CASE  
									WHEN system_type_name IN (N'char',N'varchar',N'binary',N'varbinary') THEN N'(' + CAST(max_length AS NVARCHAR(20)) + N')' 
									WHEN system_type_name IN (N'nchar',N'nvarchar') THEN N'(' + CAST(max_length/2 AS NVARCHAR(20)) + N')' 
									ELSE '' 
								END
							END
							+ N'}'
                                AS col_definition
                            FROM    #IndexColumns c
                            WHERE    c.database_id= si.database_id
									AND c.schema_name = si.schema_name
                                    AND c.object_id = si.object_id
                                    AND c.index_id = si.index_id
                                    AND c.is_included_column = 0 /*Just Keys*/
                                    AND c.key_ordinal > 0 /*Ignore non-key columns, such as partitioning keys*/
                            ORDER BY c.object_id, c.index_id, c.key_ordinal    
                    FOR      XML PATH('') ,TYPE).value('.', 'nvarchar(max)'), 1, 1, ''))
                                ) D1 ( key_column_names );

RAISERROR (N'Updating #IndexSanity.partition_key_column_name',0,1) WITH NOWAIT;
UPDATE    #IndexSanity
SET        partition_key_column_name = D1.partition_key_column_name
FROM    #IndexSanity si
        CROSS APPLY ( SELECT  RTRIM(STUFF( (SELECT  N', ' + c.column_name AS col_definition
                            FROM    #IndexColumns c
                            WHERE    c.database_id= si.database_id
									AND c.schema_name = si.schema_name
                                    AND c.object_id = si.object_id
                                    AND c.index_id = si.index_id
                                    AND c.partition_ordinal <> 0 /*Just Partitioned Keys*/
                            ORDER BY c.object_id, c.index_id, c.key_ordinal    
                    FOR      XML PATH('') , TYPE).value('.', 'nvarchar(max)'), 1, 1,''))) D1 
                                ( partition_key_column_name );

RAISERROR (N'Updating #IndexSanity.key_column_names_with_sort_order',0,1) WITH NOWAIT;
UPDATE    #IndexSanity
SET        key_column_names_with_sort_order = D2.key_column_names_with_sort_order
FROM    #IndexSanity si
        CROSS APPLY ( SELECT  RTRIM(STUFF( (SELECT  N', ' + c.column_name + CASE c.is_descending_key
                            WHEN 1 THEN N' DESC'
                            ELSE N''
							END
                            + N' {' + system_type_name + N' ' +
							CASE max_length WHEN -1 THEN N'(max)' ELSE
								CASE  
									WHEN system_type_name IN (N'char',N'varchar',N'binary',N'varbinary') THEN N'(' + CAST(max_length AS NVARCHAR(20)) + N')' 
									WHEN system_type_name IN (N'nchar',N'nvarchar') THEN N'(' + CAST(max_length/2 AS NVARCHAR(20)) + N')' 
									ELSE '' 
								END
							END
							+ N'}'
                                AS col_definition
                    FROM    #IndexColumns c
                    WHERE    c.database_id= si.database_id
							AND c.schema_name = si.schema_name
                            AND c.object_id = si.object_id
                            AND c.index_id = si.index_id
                            AND c.is_included_column = 0 /*Just Keys*/
                            AND c.key_ordinal > 0 /*Ignore non-key columns, such as partitioning keys*/
                    ORDER BY c.object_id, c.index_id, c.key_ordinal    
            FOR      XML PATH('') , TYPE).value('.', 'nvarchar(max)'), 1, 1, ''))
            ) D2 ( key_column_names_with_sort_order );

RAISERROR (N'Updating #IndexSanity.key_column_names_with_sort_order_no_types (for create tsql)',0,1) WITH NOWAIT;
UPDATE    #IndexSanity
SET        key_column_names_with_sort_order_no_types = D2.key_column_names_with_sort_order_no_types
FROM    #IndexSanity si
        CROSS APPLY ( SELECT  RTRIM(STUFF( (SELECT  N', ' + QUOTENAME(c.column_name) + CASE c.is_descending_key
                            WHEN 1 THEN N' DESC'
                            ELSE N''
                        END AS col_definition
                    FROM    #IndexColumns c
                    WHERE    c.database_id= si.database_id
							AND c.schema_name = si.schema_name
                            AND c.object_id = si.object_id
                            AND c.index_id = si.index_id
                            AND c.is_included_column = 0 /*Just Keys*/
                            AND c.key_ordinal > 0 /*Ignore non-key columns, such as partitioning keys*/
                    ORDER BY c.object_id, c.index_id, c.key_ordinal    
            FOR      XML PATH('') , TYPE).value('.', 'nvarchar(max)'), 1, 1, ''))
            ) D2 ( key_column_names_with_sort_order_no_types );

RAISERROR (N'Updating #IndexSanity.include_column_names',0,1) WITH NOWAIT;
UPDATE    #IndexSanity
SET        include_column_names = D3.include_column_names
FROM    #IndexSanity si
        CROSS APPLY ( SELECT  RTRIM(STUFF( (SELECT  N', ' + c.column_name
                        + N' {' + system_type_name + N' ' + CAST(max_length AS NVARCHAR(50)) +  N'}'
                        FROM    #IndexColumns c
                        WHERE    c.database_id= si.database_id
								AND c.schema_name = si.schema_name
                                AND c.object_id = si.object_id
                                AND c.index_id = si.index_id
                                AND c.is_included_column = 1 /*Just includes*/
                        ORDER BY c.column_name /*Order doesn't matter in includes, 
                                this is here to make rows easy to compare.*/ 
                FOR      XML PATH('') ,  TYPE).value('.', 'nvarchar(max)'), 1, 1, ''))
                ) D3 ( include_column_names );

RAISERROR (N'Updating #IndexSanity.include_column_names_no_types (for create tsql)',0,1) WITH NOWAIT;
UPDATE    #IndexSanity
SET        include_column_names_no_types = D3.include_column_names_no_types
FROM    #IndexSanity si
        CROSS APPLY ( SELECT  RTRIM(STUFF( (SELECT  N', ' + QUOTENAME(c.column_name)
                        FROM    #IndexColumns c
                                WHERE    c.database_id= si.database_id
								AND c.schema_name = si.schema_name
                                AND c.object_id = si.object_id
                                AND c.index_id = si.index_id
                                AND c.is_included_column = 1 /*Just includes*/
                        ORDER BY c.column_name /*Order doesn't matter in includes, 
                                this is here to make rows easy to compare.*/ 
                FOR      XML PATH('') ,  TYPE).value('.', 'nvarchar(max)'), 1, 1, ''))
                ) D3 ( include_column_names_no_types );

RAISERROR (N'Updating #IndexSanity.count_key_columns and count_include_columns',0,1) WITH NOWAIT;
UPDATE    #IndexSanity
SET        count_included_columns = D4.count_included_columns,
        count_key_columns = D4.count_key_columns
FROM    #IndexSanity si
        CROSS APPLY ( SELECT  SUM(CASE WHEN is_included_column = 'true' THEN 1
                                            ELSE 0
                                    END) AS count_included_columns,
                                SUM(CASE WHEN is_included_column = 'false' AND c.key_ordinal > 0 THEN 1
                                            ELSE 0
                                    END) AS count_key_columns
                        FROM        #IndexColumns c
                            WHERE    c.database_id= si.database_id
									AND c.schema_name = si.schema_name
                                    AND c.object_id = si.object_id
                                AND c.index_id = si.index_id 
                                ) AS D4 ( count_included_columns, count_key_columns );

RAISERROR (N'Updating index_sanity_id on #IndexPartitionSanity',0,1) WITH NOWAIT;
UPDATE    #IndexPartitionSanity
SET        index_sanity_id = i.index_sanity_id
FROM #IndexPartitionSanity ps
        JOIN #IndexSanity i ON ps.[object_id] = i.[object_id]
                                AND ps.index_id = i.index_id
                                AND i.database_id = ps.database_id
								AND i.schema_name = ps.schema_name;


RAISERROR (N'Inserting data into #IndexSanitySize',0,1) WITH NOWAIT;
INSERT    #IndexSanitySize ( [index_sanity_id], [database_id], [schema_name], [lock_escalation_desc], partition_count, total_rows, total_reserved_MB,
                                total_reserved_LOB_MB, total_reserved_row_overflow_MB, total_reserved_dictionary_MB, total_range_scan_count,
                                total_singleton_lookup_count, total_leaf_delete_count, total_leaf_update_count, 
                                total_forwarded_fetch_count,total_row_lock_count,
                                total_row_lock_wait_count, total_row_lock_wait_in_ms, avg_row_lock_wait_in_ms,
                                total_page_lock_count, total_page_lock_wait_count, total_page_lock_wait_in_ms,
                                avg_page_lock_wait_in_ms, total_index_lock_promotion_attempt_count, 
                                total_index_lock_promotion_count, data_compression_desc, 
								page_latch_wait_count, page_latch_wait_in_ms, page_io_latch_wait_count, page_io_latch_wait_in_ms)
        SELECT  index_sanity_id, ipp.database_id, ipp.schema_name, ipp.lock_escalation_desc,						
				COUNT(*), SUM(row_count), SUM(reserved_MB),
				SUM(reserved_LOB_MB) - SUM(reserved_dictionary_MB), /* Subtract columnstore dictionaries from LOB data */
                SUM(reserved_row_overflow_MB), 
                SUM(reserved_dictionary_MB), 
                SUM(range_scan_count),
                SUM(singleton_lookup_count),
                SUM(leaf_delete_count), 
                SUM(leaf_update_count),
                SUM(forwarded_fetch_count),
                SUM(row_lock_count), 
                SUM(row_lock_wait_count),
                SUM(row_lock_wait_in_ms), 
                CASE WHEN SUM(row_lock_wait_in_ms) > 0 THEN
                    SUM(row_lock_wait_in_ms)/(1.*SUM(row_lock_wait_count))
                ELSE 0 END AS avg_row_lock_wait_in_ms,           
                SUM(page_lock_count), 
                SUM(page_lock_wait_count),
                SUM(page_lock_wait_in_ms), 
                CASE WHEN SUM(page_lock_wait_in_ms) > 0 THEN
                    SUM(page_lock_wait_in_ms)/(1.*SUM(page_lock_wait_count))
                ELSE 0 END AS avg_page_lock_wait_in_ms,           
                SUM(index_lock_promotion_attempt_count),
                SUM(index_lock_promotion_count),
                LEFT(MAX(data_compression_info.data_compression_rollup),4000),
				SUM(page_latch_wait_count), 
				SUM(page_latch_wait_in_ms), 
				SUM(page_io_latch_wait_count), 
				SUM(page_io_latch_wait_in_ms)
        FROM #IndexPartitionSanity ipp
        /* individual partitions can have distinct compression settings, just roll them into a list here*/
        OUTER APPLY (SELECT STUFF((
            SELECT  N', ' + data_compression_desc
            FROM #IndexPartitionSanity ipp2
            WHERE ipp.[object_id]=ipp2.[object_id]
                AND ipp.[index_id]=ipp2.[index_id]
                AND ipp.database_id = ipp2.database_id
				AND ipp.schema_name = ipp2.schema_name
            ORDER BY ipp2.partition_number
            FOR      XML PATH(''),TYPE).value('.', 'nvarchar(max)'), 1, 1, '')) 
                data_compression_info(data_compression_rollup)
        GROUP BY index_sanity_id, ipp.database_id, ipp.schema_name, ipp.lock_escalation_desc
        ORDER BY index_sanity_id 
OPTION    ( RECOMPILE );

RAISERROR (N'Determining index usefulness',0,1) WITH NOWAIT;
UPDATE #MissingIndexes 
SET is_low = CASE WHEN (user_seeks + user_scans) < 5000 
					    OR unique_compiles = 1
				  THEN 1
				  ELSE 0 
			  END;

RAISERROR (N'Updating #IndexSanity.referenced_by_foreign_key',0,1) WITH NOWAIT;
UPDATE #IndexSanity
    SET is_referenced_by_foreign_key=1
FROM #IndexSanity s
JOIN #ForeignKeys fk ON 
    s.object_id=fk.referenced_object_id
    AND s.database_id=fk.database_id
    AND LEFT(s.key_column_names,LEN(fk.referenced_fk_columns)) = fk.referenced_fk_columns;

RAISERROR (N'Update index_secret on #IndexSanity for NC indexes.',0,1) WITH NOWAIT;
UPDATE nc 
SET secret_columns=
    N'[' + 
    CASE tb.count_key_columns WHEN 0 THEN '1' ELSE CAST(tb.count_key_columns AS NVARCHAR(10)) END +
    CASE nc.is_unique WHEN 1 THEN N' INCLUDE' ELSE N' KEY' END +
    CASE WHEN tb.count_key_columns > 1 THEN  N'S] ' ELSE N'] ' END +
    CASE tb.index_id WHEN 0 THEN '[RID]' ELSE LTRIM(tb.key_column_names) +
        /* Uniquifiers only needed on non-unique clustereds-- not heaps */
        CASE tb.is_unique WHEN 0 THEN ' [UNIQUIFIER]' ELSE N'' END
    END
    , count_secret_columns=
    CASE tb.index_id WHEN 0 THEN 1 ELSE 
        tb.count_key_columns +
            CASE tb.is_unique WHEN 0 THEN 1 ELSE 0 END
    END
FROM #IndexSanity AS nc
JOIN #IndexSanity AS tb ON nc.object_id=tb.object_id
	AND nc.database_id = tb.database_id
	AND nc.schema_name = tb.schema_name
    AND tb.index_id IN (0,1) 
WHERE nc.index_id > 1;

RAISERROR (N'Update index_secret on #IndexSanity for heaps and non-unique clustered.',0,1) WITH NOWAIT;
UPDATE tb
SET secret_columns=    CASE tb.index_id WHEN 0 THEN '[RID]' ELSE '[UNIQUIFIER]' END
    , count_secret_columns = 1
FROM #IndexSanity AS tb
WHERE tb.index_id = 0 /*Heaps-- these have the RID */
    OR (tb.index_id=1 AND tb.is_unique=0); /* Non-unique CX: has uniquifer (when needed) */


RAISERROR (N'Populate #IndexCreateTsql.',0,1) WITH NOWAIT;
INSERT #IndexCreateTsql (index_sanity_id, create_tsql)
SELECT
    index_sanity_id,
    ISNULL (
    CASE index_id WHEN 0 THEN N'ALTER TABLE ' + QUOTENAME([database_name]) + N'.' + QUOTENAME([schema_name]) + N'.' + QUOTENAME([object_name])  + ' REBUILD;'
    ELSE 
        CASE WHEN is_XML = 1 OR is_spatial = 1 OR is_in_memory_oltp = 1 THEN N'' /* Not even trying for these just yet...*/
        ELSE 
            CASE WHEN is_primary_key=1 THEN
                N'ALTER TABLE ' + QUOTENAME([database_name]) + N'.' + QUOTENAME([schema_name]) +
                    N'.' + QUOTENAME([object_name]) + 
                    N' ADD CONSTRAINT [' +
                    index_name + 
                    N'] PRIMARY KEY ' + 
                    CASE WHEN index_id=1 THEN N'CLUSTERED (' ELSE N'(' END +
                    key_column_names_with_sort_order_no_types + N' )' 
                WHEN is_CX_columnstore= 1 THEN
                        N'CREATE CLUSTERED COLUMNSTORE INDEX ' + QUOTENAME(index_name) + N' on ' + QUOTENAME([database_name]) + N'.' + QUOTENAME([schema_name]) + N'.' + QUOTENAME([object_name])
            ELSE /*Else not a PK or cx columnstore */ 
                N'CREATE ' + 
                CASE WHEN is_unique=1 THEN N'UNIQUE ' ELSE N'' END +
                CASE WHEN index_id=1 THEN N'CLUSTERED ' ELSE N'' END +
                CASE WHEN is_NC_columnstore=1 THEN N'NONCLUSTERED COLUMNSTORE ' 
                ELSE N'' END +
                N'INDEX ['
                        + index_name + N'] ON ' + 
                    QUOTENAME([database_name]) + N'.' + 
                    QUOTENAME([schema_name]) + N'.' + QUOTENAME([object_name]) + 
                        CASE WHEN is_NC_columnstore=1 THEN 
                            N' (' + ISNULL(include_column_names_no_types,'') +  N' )' 
                        ELSE /*Else not columnstore */ 
                            N' (' + ISNULL(key_column_names_with_sort_order_no_types,'') +  N' )' 
                            + CASE WHEN include_column_names_no_types IS NOT NULL THEN 
                                N' INCLUDE (' + include_column_names_no_types + N')' 
                                ELSE N'' 
                            END
                        END /*End non-columnstore case */ 
                    + CASE WHEN filter_definition <> N'' THEN N' WHERE ' + filter_definition ELSE N'' END
                END /*End Non-PK index CASE */ 
            + CASE WHEN is_NC_columnstore=0 AND is_CX_columnstore=0 THEN
                N' WITH (' 
                    + N'FILLFACTOR=' + CASE fill_factor WHEN 0 THEN N'100' ELSE CAST(fill_factor AS NVARCHAR(5)) END + ', '
                    + N'ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?'
                + N')'
            ELSE N'' END
            + N';'
            END /*End non-spatial and non-xml CASE */ 
    END, '[Unknown Error]')
        AS create_tsql
FROM #IndexSanity;
	  
RAISERROR (N'Populate #PartitionCompressionInfo.',0,1) WITH NOWAIT;
WITH maps
    AS
     (
         SELECT ips.index_sanity_id,
                ips.partition_number,
                ips.data_compression_desc,
                ips.partition_number - ROW_NUMBER() OVER ( PARTITION BY ips.index_sanity_id, ips.data_compression_desc
                                                           ORDER BY ips.partition_number ) AS rn
         FROM   #IndexPartitionSanity AS ips
     )
SELECT *
INTO   #maps
FROM   maps;

WITH grps
    AS
     (
         SELECT   MIN(maps.partition_number) AS MinKey,
                  MAX(maps.partition_number) AS MaxKey,
                  maps.index_sanity_id,
                  maps.data_compression_desc
         FROM     #maps AS maps
         GROUP BY maps.rn, maps.index_sanity_id, maps.data_compression_desc
     )
SELECT *
INTO   #grps
FROM   grps;

INSERT #PartitionCompressionInfo ( index_sanity_id, partition_compression_detail )
SELECT DISTINCT
       grps.index_sanity_id,
       SUBSTRING(
           ( STUFF(
                 (   SELECT   N', ' + N' Partition'
                              + CASE
                                     WHEN grps2.MinKey < grps2.MaxKey
                                     THEN
                                     + N's ' + CAST(grps2.MinKey AS NVARCHAR(10)) + N' - '
                                     + CAST(grps2.MaxKey AS NVARCHAR(10)) + N' use ' + grps2.data_compression_desc
                                     ELSE
                                     N' ' + CAST(grps2.MinKey AS NVARCHAR(10)) + N' uses ' + grps2.data_compression_desc
                                END AS Partitions
                     FROM     #grps AS grps2
                     WHERE    grps2.index_sanity_id = grps.index_sanity_id
                     ORDER BY grps2.MinKey, grps2.MaxKey
                     FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'), 1, 1, '')), 0, 8000) AS partition_compression_detail
FROM   #grps AS grps;
		
RAISERROR (N'Update #PartitionCompressionInfo.',0,1) WITH NOWAIT;
UPDATE sz
SET sz.data_compression_desc = pci.partition_compression_detail
FROM #IndexSanitySize sz
JOIN #PartitionCompressionInfo AS pci
ON pci.index_sanity_id = sz.index_sanity_id;

RAISERROR (N'Update #IndexSanity for filtered indexes with columns not in the index definition.',0,1) WITH NOWAIT;
UPDATE    #IndexSanity
SET        filter_columns_not_in_index = D1.filter_columns_not_in_index
FROM    #IndexSanity si
        CROSS APPLY ( SELECT  RTRIM(STUFF( (SELECT  N', ' + c.column_name AS col_definition
                            FROM    #FilteredIndexes AS c
                            WHERE    c.database_id= si.database_id
									AND c.schema_name = si.schema_name
                                    AND c.table_name = si.object_name
                                    AND c.index_name = si.index_name   
                                    ORDER BY c.index_sanity_id
                    FOR      XML PATH('') , TYPE).value('.', 'nvarchar(max)'), 1, 1,''))) D1 
                                ( filter_columns_not_in_index );


IF @Debug = 1
BEGIN
    SELECT '#IndexSanity' AS table_name, * FROM  #IndexSanity;
    SELECT '#IndexPartitionSanity' AS table_name, * FROM  #IndexPartitionSanity;
    SELECT '#IndexSanitySize' AS table_name, * FROM  #IndexSanitySize;
    SELECT '#IndexColumns' AS table_name, * FROM  #IndexColumns;
    SELECT '#MissingIndexes' AS table_name, * FROM  #MissingIndexes;
    SELECT '#ForeignKeys' AS table_name, * FROM  #ForeignKeys;
    SELECT '#BlitzIndexResults' AS table_name, * FROM  #BlitzIndexResults;
    SELECT '#IndexCreateTsql' AS table_name, * FROM  #IndexCreateTsql;
    SELECT '#DatabaseList' AS table_name, * FROM  #DatabaseList;
    SELECT '#Statistics' AS table_name, * FROM  #Statistics;
    SELECT '#PartitionCompressionInfo' AS table_name, * FROM  #PartitionCompressionInfo;
    SELECT '#ComputedColumns' AS table_name, * FROM  #ComputedColumns;
    SELECT '#TraceStatus' AS table_name, * FROM  #TraceStatus;   
    SELECT '#CheckConstraints' AS table_name, * FROM  #CheckConstraints;   
    SELECT '#FilteredIndexes' AS table_name, * FROM  #FilteredIndexes;                   
END


----------------------------------------
--STEP 3: DIAGNOSE THE PATIENT
----------------------------------------


BEGIN TRY
----------------------------------------
--If @TableName is specified, just return information for that table.
--The @Mode parameter doesn't matter if you're looking at a specific table.
----------------------------------------
IF @TableName IS NOT NULL
BEGIN
    RAISERROR(N'@TableName specified, giving detail only on that table.', 0,1) WITH NOWAIT;

    --We do a left join here in case this is a disabled NC.
    --In that case, it won't have any size info/pages allocated.
 
   	
	   WITH table_mode_cte AS (
        SELECT 
            s.db_schema_object_indexid, 
            s.key_column_names,
            s.index_definition, 
            ISNULL(s.secret_columns,N'') AS secret_columns,
            s.fill_factor,
            s.index_usage_summary, 
            sz.index_op_stats,
            ISNULL(sz.index_size_summary,'') /*disabled NCs will be null*/ AS index_size_summary,
			partition_compression_detail ,
            ISNULL(sz.index_lock_wait_summary,'') AS index_lock_wait_summary,
            s.is_referenced_by_foreign_key,
            (SELECT COUNT(*)
                FROM #ForeignKeys fk WHERE fk.parent_object_id=s.object_id
                AND PATINDEX (fk.parent_fk_columns, s.key_column_names)=1) AS FKs_covered_by_index,
            s.last_user_seek,
            s.last_user_scan,
            s.last_user_lookup,
            s.last_user_update,
            s.create_date,
            s.modify_date,
			sz.page_latch_wait_count,
			CONVERT(VARCHAR(10), (sz.page_latch_wait_in_ms / 1000) / 86400) + ':' + CONVERT(VARCHAR(20), DATEADD(s, (sz.page_latch_wait_in_ms / 1000), 0), 108) AS page_latch_wait_time,
			sz.page_io_latch_wait_count,
			CONVERT(VARCHAR(10), (sz.page_io_latch_wait_in_ms / 1000) / 86400) + ':' + CONVERT(VARCHAR(20), DATEADD(s, (sz.page_io_latch_wait_in_ms / 1000), 0), 108) AS page_io_latch_wait_time,
            ct.create_tsql,
            CASE 
                WHEN s.is_primary_key = 1 AND s.index_definition <> '[HEAP]'
                THEN N'--ALTER TABLE ' + QUOTENAME(s.[database_name]) + N'.' + QUOTENAME(s.[schema_name]) + N'.' + QUOTENAME(s.[object_name])
                        + N' DROP CONSTRAINT ' + QUOTENAME(s.index_name) + N';'
                WHEN s.is_primary_key = 0 AND s.index_definition <> '[HEAP]'
                    THEN N'--DROP INDEX '+ QUOTENAME(s.index_name) + N' ON ' + QUOTENAME(s.[database_name]) + N'.' + 
                        QUOTENAME(s.[schema_name]) + N'.' + QUOTENAME(s.[object_name]) + N';'
                ELSE N''
            END AS drop_tsql,
            1 AS display_order
        FROM #IndexSanity s
        LEFT JOIN #IndexSanitySize sz ON 
            s.index_sanity_id=sz.index_sanity_id
        LEFT JOIN #IndexCreateTsql ct ON 
            s.index_sanity_id=ct.index_sanity_id
		LEFT JOIN #PartitionCompressionInfo pci ON 
			pci.index_sanity_id = s.index_sanity_id
        WHERE s.[object_id]=@ObjectID
        UNION ALL
        SELECT  N'Database ' + QUOTENAME(@DatabaseName) + N' as of ' + CONVERT(NVARCHAR(16),GETDATE(),121) +             
                N' (' + @ScriptVersionName + ')' ,   
                N'SQL Server First Responder Kit' ,   
                N'http://FirstResponderKit.org' ,
                N'From Your Community Volunteers',
                NULL,@DaysUptimeInsertValue,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
                0 AS display_order
    )
    SELECT 
            db_schema_object_indexid AS [Details: db_schema.table.index(indexid)], 
            index_definition AS [Definition: [Property]] ColumnName {datatype maxbytes}], 
            secret_columns AS [Secret Columns],
            fill_factor AS [Fillfactor],
            index_usage_summary AS [Usage Stats], 
            index_op_stats AS [Op Stats],
            index_size_summary AS [Size],
			partition_compression_detail AS [Compression Type],
            index_lock_wait_summary AS [Lock Waits],
            is_referenced_by_foreign_key AS [Referenced by FK?],
            FKs_covered_by_index AS [FK Covered by Index?],
            last_user_seek AS [Last User Seek],
            last_user_scan AS [Last User Scan],
            last_user_lookup AS [Last User Lookup],
            last_user_update AS [Last User Write],
            create_date AS [Created],
            modify_date AS [Last Modified],
			page_latch_wait_count AS [Page Latch Wait Count],
			page_latch_wait_time as [Page Latch Wait Time (D:H:M:S)],
			page_io_latch_wait_count AS [Page IO Latch Wait Count],								
			page_io_latch_wait_time as [Page IO Latch Wait Time (D:H:M:S)],
            create_tsql AS [Create TSQL],
            drop_tsql AS [Drop TSQL]
    FROM table_mode_cte
    ORDER BY display_order ASC, key_column_names ASC
    OPTION    ( RECOMPILE );                        

    IF (SELECT TOP 1 [object_id] FROM    #MissingIndexes mi) IS NOT NULL
    BEGIN;

	WITH create_date AS (
						SELECT i.database_id,
							   i.schema_name,
							   i.[object_id], 
							   ISNULL(NULLIF(MAX(DATEDIFF(DAY, i.create_date, SYSDATETIME())), 0), 1) AS create_days
						FROM #IndexSanity AS i
						GROUP BY i.database_id, i.schema_name, i.object_id
						)
        SELECT  N'Missing index.' AS Finding ,
                N'https://www.brentozar.com/go/Indexaphobia' AS URL ,
                mi.[statement] + 
                ' Est. Benefit: '
                    + CASE WHEN magic_benefit_number >= 922337203685477 THEN '>= 922,337,203,685,477'
                    ELSE REPLACE(CONVERT(NVARCHAR(256),CAST(CAST(
                                        (magic_benefit_number / CASE WHEN cd.create_days < @DaysUptime THEN cd.create_days ELSE @DaysUptime END)
                                        AS BIGINT) AS MONEY), 1), '.00', '')
                    END AS [Estimated Benefit],
                missing_index_details AS [Missing Index Request] ,
                index_estimated_impact AS [Estimated Impact],
                create_tsql AS [Create TSQL],
				sample_query_plan AS [Sample Query Plan]
        FROM    #MissingIndexes mi
		LEFT JOIN create_date AS cd
		ON mi.[object_id] =  cd.object_id 
		AND mi.database_id = cd.database_id
		AND mi.schema_name = cd.schema_name
        WHERE   mi.[object_id] = @ObjectID
        AND (@ShowAllMissingIndexRequests=1
                /* Minimum benefit threshold = 100k/day of uptime OR since table creation date, whichever is lower*/
            OR (magic_benefit_number / CASE WHEN cd.create_days < @DaysUptime THEN cd.create_days ELSE @DaysUptime END) >= 100000)
        ORDER BY magic_benefit_number DESC
        OPTION    ( RECOMPILE );
    END;       
    ELSE     
    SELECT 'No missing indexes.' AS finding;

    SELECT   
        column_name AS [Column Name],
        (SELECT COUNT(*)  
            FROM #IndexColumns c2 
            WHERE c2.column_name=c.column_name
            AND c2.key_ordinal IS NOT NULL)
        + CASE WHEN c.index_id = 1 AND c.key_ordinal IS NOT NULL THEN
            -1+ (SELECT COUNT(DISTINCT index_id)
            FROM #IndexColumns c3
            WHERE c3.index_id NOT IN (0,1))
            ELSE 0 END
                AS [Found In],
        system_type_name + 
            CASE max_length WHEN -1 THEN N' (max)' ELSE
                CASE  
                    WHEN system_type_name IN (N'char',N'varchar',N'binary',N'varbinary') THEN N' (' + CAST(max_length AS NVARCHAR(20)) + N')' 
                    WHEN system_type_name IN (N'nchar',N'nvarchar') THEN N' (' + CAST(max_length/2 AS NVARCHAR(20)) + N')' 
                    ELSE '' 
                END
            END
            AS [Type],
        CASE is_computed WHEN 1 THEN 'yes' ELSE '' END AS [Computed?],
        max_length AS [Length (max bytes)],
        [precision] AS [Prec],
        [scale] AS [Scale],
        CASE is_nullable WHEN 1 THEN 'yes' ELSE '' END AS [Nullable?],
        CASE is_identity WHEN 1 THEN 'yes' ELSE '' END AS [Identity?],
        CASE is_replicated WHEN 1 THEN 'yes' ELSE '' END AS [Replicated?],
        CASE is_sparse WHEN 1 THEN 'yes' ELSE '' END AS [Sparse?],
        CASE is_filestream WHEN 1 THEN 'yes' ELSE '' END AS [Filestream?],
        collation_name AS [Collation]
    FROM #IndexColumns AS c
    WHERE index_id IN (0,1);

    IF (SELECT TOP 1 parent_object_id FROM #ForeignKeys) IS NOT NULL
    BEGIN
        SELECT [database_name] + N':' + parent_object_name + N': ' + foreign_key_name AS [Foreign Key],
            parent_fk_columns AS [Foreign Key Columns],
            referenced_object_name AS [Referenced Table],
            referenced_fk_columns AS [Referenced Table Columns],
            is_disabled AS [Is Disabled?],
            is_not_trusted AS [Not Trusted?],
            is_not_for_replication [Not for Replication?],
            [update_referential_action_desc] AS [Cascading Updates?],
            [delete_referential_action_desc] AS [Cascading Deletes?]
        FROM #ForeignKeys
        ORDER BY [Foreign Key]
        OPTION    ( RECOMPILE );
    END;
    ELSE
    SELECT 'No foreign keys.' AS finding;

    /* Show histograms for all stats on this table. More info: https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/issues/1900 */
    IF EXISTS (SELECT * FROM sys.all_objects WHERE name = 'dm_db_stats_histogram')
    BEGIN
        SET @dsql=N'SELECT s.name AS [Stat Name], c.name AS [Leading Column Name], hist.step_number AS [Step Number], 
                        hist.range_high_key AS [Range High Key], hist.range_rows AS [Range Rows], 
                        hist.equal_rows AS [Equal Rows], hist.distinct_range_rows AS [Distinct Range Rows], hist.average_range_rows AS [Average Range Rows],
                        s.auto_created AS [Auto-Created], s.user_created AS [User-Created],
                        props.last_updated AS [Last Updated], props.modification_counter AS [Modification Counter], props.rows AS [Table Rows],
						props.rows_sampled AS [Rows Sampled], s.stats_id AS [StatsID]
                    FROM ' + QUOTENAME(@DatabaseName) + N'.sys.stats AS s
                    INNER JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.stats_columns sc ON s.object_id = sc.object_id AND s.stats_id = sc.stats_id AND sc.stats_column_id = 1
                    INNER JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.columns c ON sc.object_id = c.object_id AND sc.column_id = c.column_id
                    CROSS APPLY ' + QUOTENAME(@DatabaseName) + N'.sys.dm_db_stats_properties(s.object_id, s.stats_id) AS props  
                    CROSS APPLY ' + QUOTENAME(@DatabaseName) + N'.sys.dm_db_stats_histogram(s.[object_id], s.stats_id) AS hist
                    WHERE s.object_id = @ObjectID
                    ORDER BY s.auto_created, s.user_created, s.name, hist.step_number;';
        EXEC sp_executesql @dsql, N'@ObjectID INT', @ObjectID;
    END

    /* Visualize columnstore index contents. More info: https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/issues/2584 */
    IF 2 = (SELECT SUM(1) FROM sys.all_objects WHERE name IN ('column_store_row_groups','column_store_segments'))
    BEGIN
        RAISERROR(N'Visualizing columnstore index contents.', 0,1) WITH NOWAIT;

		SET @dsql = N'USE ' + QUOTENAME(@DatabaseName) + N'; 
			IF EXISTS(SELECT * FROM ' + QUOTENAME(@DatabaseName) + N'.sys.column_store_row_groups WHERE object_id = @ObjectID)
				BEGIN
				SET @ColumnList = N'''';
				WITH DistinctColumns AS (
				SELECT DISTINCT QUOTENAME(c.name) AS column_name, c.column_id
					FROM ' + QUOTENAME(@DatabaseName) + N'.sys.partitions p
					INNER JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.columns c ON p.object_id = c.object_id
                    INNER JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.index_columns ic on ic.column_id = c.column_id and ic.object_id = c.object_id AND ic.index_id = p.index_id
					INNER JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.types t ON c.system_type_id = t.system_type_id AND c.user_type_id = t.user_type_id
					WHERE p.object_id = @ObjectID
					AND EXISTS (SELECT * FROM ' + QUOTENAME(@DatabaseName) + N'.sys.column_store_segments seg WHERE p.partition_id = seg.partition_id AND seg.column_id = ic.index_column_id)
					AND p.data_compression IN (3,4)
				)
				SELECT @ColumnList = @ColumnList + column_name + N'', ''
					FROM DistinctColumns
					ORDER BY column_id;
				END';

		IF @Debug = 1
			BEGIN
				PRINT SUBSTRING(@dsql, 0, 4000);
				PRINT SUBSTRING(@dsql, 4000, 8000);
				PRINT SUBSTRING(@dsql, 8000, 12000);
				PRINT SUBSTRING(@dsql, 12000, 16000);
				PRINT SUBSTRING(@dsql, 16000, 20000);
				PRINT SUBSTRING(@dsql, 20000, 24000);
				PRINT SUBSTRING(@dsql, 24000, 28000);
				PRINT SUBSTRING(@dsql, 28000, 32000);
				PRINT SUBSTRING(@dsql, 32000, 36000);
				PRINT SUBSTRING(@dsql, 36000, 40000);
			END;

        EXEC sp_executesql @dsql, N'@ObjectID INT, @ColumnList NVARCHAR(MAX) OUTPUT', @ObjectID, @ColumnList OUTPUT;

		IF @Debug = 1
			SELECT @ColumnList AS ColumnstoreColumnList;

		IF @ColumnList <> ''
		BEGIN
			/* Remove the trailing comma */
			SET @ColumnList = LEFT(@ColumnList, LEN(@ColumnList) - 1);

			SET @dsql = N'USE ' + QUOTENAME(@DatabaseName) + N'; SELECT partition_number, row_group_id, total_rows, deleted_rows, ' + @ColumnList + N'
				FROM (
					SELECT c.name AS column_name, p.partition_number,
						rg.row_group_id, rg.total_rows, rg.deleted_rows,
						details = CAST(seg.min_data_id AS VARCHAR(20)) + '' to '' + CAST(seg.max_data_id AS VARCHAR(20)) + '', '' + CAST(CAST((seg.on_disk_size / 1024.0 / 1024) AS DECIMAL(18,0)) AS VARCHAR(20)) + '' MB''
					FROM ' + QUOTENAME(@DatabaseName) + N'.sys.column_store_row_groups rg 
					INNER JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.columns c ON rg.object_id = c.object_id
					INNER JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.partitions p ON rg.object_id = p.object_id AND rg.partition_number = p.partition_number
                    INNER JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.index_columns ic on ic.column_id = c.column_id AND ic.object_id = c.object_id AND ic.index_id = p.index_id
					LEFT OUTER JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.column_store_segments seg ON p.partition_id = seg.partition_id AND ic.index_column_id = seg.column_id AND rg.row_group_id = seg.segment_id
					WHERE rg.object_id = @ObjectID
				) AS x
				PIVOT (MAX(details) FOR column_name IN ( ' + @ColumnList + N')) AS pivot1
				ORDER BY partition_number, row_group_id;';
 
			IF @Debug = 1
				BEGIN
					PRINT SUBSTRING(@dsql, 0, 4000);
					PRINT SUBSTRING(@dsql, 4000, 8000);
					PRINT SUBSTRING(@dsql, 8000, 12000);
					PRINT SUBSTRING(@dsql, 12000, 16000);
					PRINT SUBSTRING(@dsql, 16000, 20000);
					PRINT SUBSTRING(@dsql, 20000, 24000);
					PRINT SUBSTRING(@dsql, 24000, 28000);
					PRINT SUBSTRING(@dsql, 28000, 32000);
					PRINT SUBSTRING(@dsql, 32000, 36000);
					PRINT SUBSTRING(@dsql, 36000, 40000);
				END;

			IF @dsql IS NULL 
				RAISERROR('@dsql is null',16,1);
			ELSE
				EXEC sp_executesql @dsql, N'@ObjectID INT', @ObjectID;
		END
		ELSE /* No columns were found for this object */
		BEGIN
			SELECT N'No compressed columnstore rowgroups were found for this object.' AS Columnstore_Visualization
			UNION ALL
			SELECT N'SELECT * FROM ' + QUOTENAME(@DatabaseName) + N'.sys.column_store_row_groups WHERE object_id = ' + CAST(@ObjectID AS NVARCHAR(100));
		END
        RAISERROR(N'Done visualizing columnstore index contents.', 0,1) WITH NOWAIT;
    END

END; /* IF @TableName IS NOT NULL */
































ELSE IF @Mode IN (0, 4) /* DIAGNOSE*//* IF @TableName IS NOT NULL, so  @TableName must not be null */
BEGIN;
	IF @Mode IN (0, 4) /* DIAGNOSE priorities 1-100 */
	BEGIN;
        RAISERROR(N'@Mode=0 or 4, running rules for priorities 1-100.', 0,1) WITH NOWAIT;

        ----------------------------------------
        --Multiple Index Personalities: Check_id 0-10
        ----------------------------------------
        RAISERROR('check_id 1: Duplicate keys', 0,1) WITH NOWAIT;
            WITH    duplicate_indexes
                      AS ( SELECT  [object_id], key_column_names, database_id, [schema_name]
                           FROM        #IndexSanity AS ip
                           WHERE  index_type IN (1,2) /* Clustered, NC only*/
                                AND is_hypothetical = 0
                                AND is_disabled = 0
								AND is_primary_key = 0
								AND EXISTS (
											SELECT 1/0
											FROM #IndexSanitySize ips 
											WHERE ip.index_sanity_id = ips.index_sanity_id 
								            AND ip.database_id = ips.database_id
											AND ip.schema_name = ips.schema_name
								            AND ips.total_reserved_MB >= CASE 
											                             WHEN (@GetAllDatabases = 1 OR @Mode = 0) 
																		 THEN @ThresholdMB 
																		 ELSE ips.total_reserved_MB 
																		 END
								            )
                           GROUP BY    [object_id], key_column_names, database_id, [schema_name]
                           HAVING    COUNT(*) > 1)
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  1 AS check_id, 
                                ip.index_sanity_id,
                                20 AS Priority,
                                'Multiple Index Personalities' AS findings_group,
                                'Duplicate keys' AS finding,
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/duplicateindex' AS URL,
                                N'Index Name: ' + ip.index_name + N' Table Name: ' + ip.db_schema_object_name AS details,
                                ip.index_definition, 
                                ip.secret_columns, 
                                ip.index_usage_summary,
                                ips.index_size_summary
                        FROM    duplicate_indexes di
                                JOIN #IndexSanity ip ON di.[object_id] = ip.[object_id]
                                                         AND ip.database_id = di.database_id
														 AND ip.[schema_name] = di.[schema_name]
                                                         AND di.key_column_names = ip.key_column_names
                                JOIN #IndexSanitySize ips ON ip.index_sanity_id = ips.index_sanity_id 
								                          AND ip.database_id = ips.database_id
														  AND ip.schema_name = ips.schema_name
                        /* WHERE clause limits to only @ThresholdMB or larger duplicate indexes when getting all databases or using PainRelief mode */
                        WHERE ips.total_reserved_MB >= CASE WHEN (@GetAllDatabases = 1 OR @Mode = 0) THEN @ThresholdMB ELSE ips.total_reserved_MB END
						AND ip.is_primary_key = 0
                        ORDER BY ips.total_rows DESC, ip.[schema_name], ip.[object_name], ip.key_column_names_with_sort_order    
                OPTION    ( RECOMPILE );

        RAISERROR('check_id 2: Keys w/ identical leading columns.', 0,1) WITH NOWAIT;
            WITH    borderline_duplicate_indexes
                      AS ( SELECT DISTINCT database_id, [object_id], first_key_column_name, key_column_names,
                                    COUNT([object_id]) OVER ( PARTITION BY database_id, [object_id], first_key_column_name ) AS number_dupes
                           FROM        #IndexSanity
                           WHERE index_type IN (1,2) /* Clustered, NC only*/
                            AND is_hypothetical=0
                            AND is_disabled=0
							AND is_primary_key = 0)
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  2 AS check_id, 
                                ip.index_sanity_id,
                                30 AS Priority,
                                'Multiple Index Personalities' AS findings_group,
                                'Borderline duplicate keys' AS finding,
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/duplicateindex' AS URL,
                                ip.db_schema_object_indexid AS details, 
                                ip.index_definition, 
                                ip.secret_columns,
                                ip.index_usage_summary,
                                ips.index_size_summary
                        FROM    #IndexSanity AS ip 
                        JOIN #IndexSanitySize ips ON ip.index_sanity_id = ips.index_sanity_id
                        WHERE EXISTS (
                            SELECT di.[object_id]
                            FROM borderline_duplicate_indexes AS di
                            WHERE di.[object_id] = ip.[object_id] AND
                                di.database_id = ip.database_id AND
                                di.first_key_column_name = ip.first_key_column_name AND
                                di.key_column_names <> ip.key_column_names AND
                                di.number_dupes > 1    
                        )
						AND ip.is_primary_key = 0                                          
                        ORDER BY ips.total_rows DESC, ip.[schema_name], ip.[object_name], ip.key_column_names, ip.include_column_names
            OPTION    ( RECOMPILE );

        ----------------------------------------
        --Aggressive Indexes: Check_id 10-19
        ----------------------------------------

        RAISERROR(N'check_id 11: Total lock wait time > 5 minutes (row + page)', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                SELECT  11 AS check_id, 
                        i.index_sanity_id,
                        70 AS Priority,
                        N'Aggressive ' 
                            + CASE COALESCE((SELECT SUM(1) 
							                 FROM #IndexSanity iMe 
											 INNER JOIN #IndexSanity iOthers 
												ON iMe.database_id = iOthers.database_id 
												AND iMe.object_id = iOthers.object_id 
												AND iOthers.index_id > 1 
											 WHERE i.index_sanity_id = iMe.index_sanity_id
												AND iOthers.is_hypothetical = 0
												AND iOthers.is_disabled = 0
											), 0)
                                WHEN 0 THEN N'Under-Indexing'
                                WHEN 1 THEN N'Under-Indexing'
                                WHEN 2 THEN N'Under-Indexing'
                                WHEN 3 THEN N'Under-Indexing'
                                WHEN 4 THEN N'Indexes'
                                WHEN 5 THEN N'Indexes'
                                WHEN 6 THEN N'Indexes'
                                WHEN 7 THEN N'Indexes'
                                WHEN 8 THEN N'Indexes'
                                WHEN 9 THEN N'Indexes'
                                ELSE N'Over-Indexing'
                                END AS findings_group,
                        N'Total lock wait time > 5 minutes (row + page)' AS finding, 
                        [database_name] AS [Database Name],
                        N'https://www.brentozar.com/go/AggressiveIndexes' AS URL,
                        (i.db_schema_object_indexid + N': ' +
                            sz.index_lock_wait_summary + N' NC indexes on table: ') COLLATE DATABASE_DEFAULT +
							 CAST(COALESCE((SELECT SUM(1) 
							                FROM #IndexSanity iMe 
											INNER JOIN #IndexSanity iOthers 
												ON iMe.database_id = iOthers.database_id 
												AND iMe.object_id = iOthers.object_id 
												AND iOthers.index_id > 1 
											WHERE i.index_sanity_id = iMe.index_sanity_id
											AND iOthers.is_hypothetical = 0
											AND iOthers.is_disabled = 0
										   ), 0)
                                         AS NVARCHAR(30))	 AS details, 
                        i.index_definition,
                        i.secret_columns,
                        i.index_usage_summary,
                        sz.index_size_summary
                FROM    #IndexSanity AS i
                JOIN #IndexSanitySize AS sz ON i.index_sanity_id = sz.index_sanity_id
                WHERE    (total_row_lock_wait_in_ms + total_page_lock_wait_in_ms) > 300000
				GROUP BY i.index_sanity_id, [database_name], i.db_schema_object_indexid, sz.index_lock_wait_summary, i.index_definition, i.secret_columns, i.index_usage_summary, sz.index_size_summary, sz.index_sanity_id
                ORDER BY SUM(total_row_lock_wait_in_ms + total_page_lock_wait_in_ms) DESC, 4, [database_name], 8
                OPTION    ( RECOMPILE );



        ---------------------------------------- 
        --Index Hoarder: Check_id 20-29
        ----------------------------------------
            RAISERROR(N'check_id 20: >= 10 NC indexes on any given table. Yes, 10 is an arbitrary number.', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  20 AS check_id, 
                                MAX(i.index_sanity_id) AS index_sanity_id, 
                                10 AS Priority,
                                'Index Hoarder' AS findings_group,
                                'Many NC Indexes on a Single Table' AS finding,
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/IndexHoarder' AS URL,
                                CAST (COUNT(*) AS NVARCHAR(30)) + ' NC indexes on ' + i.db_schema_object_name AS details,
                                i.db_schema_object_name + ' (' + CAST (COUNT(*) AS NVARCHAR(30)) + ' indexes)' AS index_definition,
                                '' AS secret_columns,
                                REPLACE(CONVERT(NVARCHAR(30),CAST(SUM(total_reads) AS MONEY), 1), N'.00', N'') + N' reads (ALL); '
                                    + REPLACE(CONVERT(NVARCHAR(30),CAST(SUM(user_updates) AS MONEY), 1), N'.00', N'') + N' writes (ALL); ',
                                REPLACE(CONVERT(NVARCHAR(30),CAST(MAX(total_rows) AS MONEY), 1), N'.00', N'') + N' rows (MAX)'
                                    + CASE WHEN SUM(total_reserved_MB) > 1024 THEN 
                                        N'; ' + CAST(CAST(SUM(total_reserved_MB)/1024. AS NUMERIC(29,1)) AS NVARCHAR(30)) + 'GB (ALL)'
                                    WHEN SUM(total_reserved_MB) > 0 THEN
                                        N'; ' + CAST(CAST(SUM(total_reserved_MB) AS NUMERIC(29,1)) AS NVARCHAR(30)) + 'MB (ALL)'
                                    ELSE ''
                                    END AS index_size_summary
                        FROM    #IndexSanity i
                        JOIN #IndexSanitySize ip ON i.index_sanity_id = ip.index_sanity_id
                        WHERE    index_id NOT IN ( 0, 1 )
                        GROUP BY db_schema_object_name, [i].[database_name]
                        HAVING    COUNT(*) >= 10
                        ORDER BY i.db_schema_object_name DESC  
						OPTION    ( RECOMPILE );

                RAISERROR(N'check_id 22: NC indexes with 0 reads. (Borderline) and >= 10,000 writes', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  22 AS check_id, 
                                i.index_sanity_id,
                                10 AS Priority,
                                N'Index Hoarder' AS findings_group,
                                N'Unused NC Index with High Writes' AS finding, 
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/IndexHoarder' AS URL,
                                N'Reads: 0,'
								+ N' Writes: ' 
								+ REPLACE(CONVERT(NVARCHAR(30), CAST((i.user_updates) AS MONEY), 1), N'.00', N'')
								+ N' on: '
								+ i.db_schema_object_indexid
								AS details, 
                                i.index_definition, 
                                i.secret_columns, 
                                i.index_usage_summary,
                                sz.index_size_summary
                        FROM    #IndexSanity AS i
                        JOIN    #IndexSanitySize AS sz ON i.index_sanity_id = sz.index_sanity_id
                        WHERE    i.total_reads=0
						    AND i.user_updates >= 10000
                                AND i.index_id NOT IN (0,1) /*NCs only*/
                                AND i.is_unique = 0
                                AND sz.total_reserved_MB >= CASE WHEN (@GetAllDatabases = 1 OR @Mode = 0) THEN @ThresholdMB ELSE sz.total_reserved_MB END
								AND @Filter <> 1 /* 1 = "ignore unused */
                        ORDER BY i.db_schema_object_indexid
                        OPTION    ( RECOMPILE );


		RAISERROR(N'check_id 34: Filtered index definition columns not in index definition', 0,1) WITH NOWAIT;
                 
                 INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  34 AS check_id, 
                                i.index_sanity_id,
                                80 AS Priority,
                                N'Abnormal Psychology' AS findings_group,
                                N'Filter Columns Not In Index Definition' AS finding, 
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/IndexFeatures' AS URL,
                                N'The index '
                                + QUOTENAME(i.index_name)
                                + N' on ['
                                + i.db_schema_object_name
                                + N'] has a filter on ['
                                + i.filter_definition
                                + N'] but is missing ['
                                + LTRIM(i.filter_columns_not_in_index)
                                + N'] from the index definition.'
                                AS details, 
                                i.index_definition, 
                                i.secret_columns, 
                                i.index_usage_summary,
                                sz.index_size_summary
                        FROM    #IndexSanity i
                        JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                        WHERE   i.filter_columns_not_in_index IS NOT NULL
                        ORDER BY i.db_schema_object_indexid
                        OPTION    ( RECOMPILE );
                                
         ----------------------------------------
        --Self Loathing Indexes : Check_id 40-49
        ----------------------------------------
        
            RAISERROR(N'check_id 40: Fillfactor in nonclustered 80 percent or less', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                    SELECT  40 AS check_id, 
                            i.index_sanity_id,
                            100 AS Priority,
                            N'Self Loathing Indexes' AS findings_group,
                            N'Low Fill Factor on Nonclustered Index' AS finding, 
                            [database_name] AS [Database Name],
                            N'https://www.brentozar.com/go/SelfLoathing' AS URL,
                            CAST(fill_factor AS NVARCHAR(10)) + N'% fill factor on ' + db_schema_object_indexid + N'. '+
                                CASE WHEN (last_user_update IS NULL OR user_updates < 1)
                                THEN N'No writes have been made.'
                                ELSE
                                    N'Last write was ' +  CONVERT(NVARCHAR(16),last_user_update,121) + N' and ' + 
                                    CAST(user_updates AS NVARCHAR(25)) + N' updates have been made.'
                                END
                                AS details, 
                            i.index_definition,
                            i.secret_columns,
                            i.index_usage_summary,
                            sz.index_size_summary
                    FROM    #IndexSanity AS i
                    JOIN    #IndexSanitySize AS sz ON i.index_sanity_id = sz.index_sanity_id
                    WHERE    index_id > 1
                    AND    fill_factor BETWEEN 1 AND 80 OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 40: Fillfactor in clustered 80 percent or less', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                    SELECT  40 AS check_id, 
                            i.index_sanity_id,
                            100 AS Priority,
                            N'Self Loathing Indexes' AS findings_group,
                            N'Low Fill Factor on Clustered Index' AS finding, 
                            [database_name] AS [Database Name],
                            N'https://www.brentozar.com/go/SelfLoathing' AS URL,
                            N'Fill factor on ' + db_schema_object_indexid + N' is ' + CAST(fill_factor AS NVARCHAR(10)) + N'%. '+
                                CASE WHEN (last_user_update IS NULL OR user_updates < 1)
                                THEN N'No writes have been made.'
                                ELSE
                                    N'Last write was ' +  CONVERT(NVARCHAR(16),last_user_update,121) + N' and ' + 
                                    CAST(user_updates AS NVARCHAR(25)) + N' updates have been made.'
                                END
                                AS details, 
                            i.index_definition,
                            i.secret_columns,
                            i.index_usage_summary,
                            sz.index_size_summary
                    FROM    #IndexSanity AS i
                    JOIN #IndexSanitySize AS sz ON i.index_sanity_id = sz.index_sanity_id
                    WHERE    index_id = 1
                    AND fill_factor BETWEEN 1 AND 80 OPTION    ( RECOMPILE );


            RAISERROR(N'check_id 43: Heaps with forwarded records', 0,1) WITH NOWAIT;
            WITH    heaps_cte
                      AS ( SELECT   [object_id],
								    [database_id],
								    [schema_name],
                                    SUM(forwarded_fetch_count) AS forwarded_fetch_count,
                                    SUM(leaf_delete_count) AS leaf_delete_count
                           FROM        #IndexPartitionSanity
                           GROUP BY    [object_id],
								       [database_id],
								       [schema_name]
                           HAVING    SUM(forwarded_fetch_count) > 0)
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  43 AS check_id, 
                                i.index_sanity_id,
                                100 AS Priority,
                                N'Self Loathing Indexes' AS findings_group,
                                N'Heaps with Forwarded Fetches' AS finding, 
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/SelfLoathing' AS URL,
                                CASE WHEN h.forwarded_fetch_count >= 922337203685477 THEN '>= 922,337,203,685,477'
                                    WHEN @DaysUptime < 1 THEN CAST(h.forwarded_fetch_count AS NVARCHAR(256)) + N' forwarded fetches against heap: ' + db_schema_object_indexid
                                    ELSE REPLACE(CONVERT(NVARCHAR(256),CAST(CAST(
                                    (h.forwarded_fetch_count /*/@DaysUptime */)
                                     AS BIGINT) AS MONEY), 1), '.00', '') 
                                    END + N' forwarded fetches per day against heap: '
                                + db_schema_object_indexid AS details, 
                                i.index_definition, 
                                i.secret_columns,
                                i.index_usage_summary,
                                sz.index_size_summary
                        FROM    #IndexSanity i
                        JOIN heaps_cte h ON i.[object_id] = h.[object_id] 
							 AND i.[database_id] = h.[database_id]
							 AND i.[schema_name] = h.[schema_name]
                        JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                        WHERE    i.index_id = 0 
                        AND h.forwarded_fetch_count / @DaysUptime > 1000
                        AND sz.total_reserved_MB >= CASE WHEN NOT (@GetAllDatabases = 1 OR @Mode = 4) THEN @ThresholdMB ELSE sz.total_reserved_MB END
                OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 44: Large Heaps with reads or writes.', 0,1) WITH NOWAIT;
            WITH    heaps_cte
                      AS ( SELECT   [object_id],
								    [database_id],
								    [schema_name], 
									SUM(forwarded_fetch_count) AS forwarded_fetch_count,
                                    SUM(leaf_delete_count) AS leaf_delete_count
                           FROM        #IndexPartitionSanity
                           GROUP BY  [object_id],
								     [database_id],
								     [schema_name]
                           HAVING    SUM(forwarded_fetch_count) > 0
                                    OR SUM(leaf_delete_count) > 0)
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  44 AS check_id, 
                                i.index_sanity_id,
                                100 AS Priority,
                                N'Self Loathing Indexes' AS findings_group,
                                N'Large Active Heap' AS finding, 
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/SelfLoathing' AS URL,
                                N'Should this table be a heap? ' + db_schema_object_indexid AS details, 
                                i.index_definition, 
                                'N/A' AS secret_columns,
                                i.index_usage_summary,
                                sz.index_size_summary
                        FROM    #IndexSanity i
                        LEFT JOIN heaps_cte h ON i.[object_id] = h.[object_id] 
								AND i.[database_id] = h.[database_id]
								AND i.[schema_name] = h.[schema_name]
                        JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                        WHERE    i.index_id = 0 
                                AND (i.total_reads > 0 OR i.user_updates > 0)
								AND sz.total_rows >= 100000
                                AND h.[object_id] IS NULL /*don't duplicate the prior check.*/
                OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 45: Medium Heaps with reads or writes.', 0,1) WITH NOWAIT;
            WITH    heaps_cte
                      AS ( SELECT   [object_id],
								    [database_id],
								    [schema_name], 
									SUM(forwarded_fetch_count) AS forwarded_fetch_count,
                                    SUM(leaf_delete_count) AS leaf_delete_count
                           FROM        #IndexPartitionSanity
                           GROUP BY  [object_id],
								     [database_id],
								     [schema_name]
                           HAVING    SUM(forwarded_fetch_count) > 0
                                    OR SUM(leaf_delete_count) > 0)
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  45 AS check_id, 
                                i.index_sanity_id,
                                100 AS Priority,
                                N'Self Loathing Indexes' AS findings_group,
                                N'Medium Active heap' AS finding, 
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/SelfLoathing' AS URL,
                                N'Should this table be a heap? ' + db_schema_object_indexid AS details, 
                                i.index_definition, 
                                'N/A' AS secret_columns,
                                i.index_usage_summary,
                                sz.index_size_summary
                        FROM    #IndexSanity i
                        LEFT JOIN heaps_cte h ON i.[object_id] = h.[object_id] 
								AND i.[database_id] = h.[database_id]
								AND i.[schema_name] = h.[schema_name]
                        JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                        WHERE    i.index_id = 0 
                                AND 
                                    (i.total_reads > 0 OR i.user_updates > 0)
								AND sz.total_rows >= 10000 AND sz.total_rows < 100000
                                AND h.[object_id] IS NULL /*don't duplicate the prior check.*/
                OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 46: Small Heaps with reads or writes.', 0,1) WITH NOWAIT;
            WITH    heaps_cte
                      AS ( SELECT   [object_id],
								    [database_id],
								    [schema_name], 
									SUM(forwarded_fetch_count) AS forwarded_fetch_count,
                                    SUM(leaf_delete_count) AS leaf_delete_count
                           FROM        #IndexPartitionSanity
                           GROUP BY  [object_id],
								     [database_id],
								     [schema_name]
                           HAVING    SUM(forwarded_fetch_count) > 0
                                    OR SUM(leaf_delete_count) > 0)
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  46 AS check_id, 
                                i.index_sanity_id,
                                100 AS Priority,
                                N'Self Loathing Indexes' AS findings_group,
                                N'Small Active heap' AS finding, 
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/SelfLoathing' AS URL,
                                N'Should this table be a heap? ' + db_schema_object_indexid AS details, 
                                i.index_definition, 
                                'N/A' AS secret_columns,
                                i.index_usage_summary,
                                sz.index_size_summary
                        FROM    #IndexSanity i
                        LEFT JOIN heaps_cte h ON i.[object_id] = h.[object_id] 
								AND i.[database_id] = h.[database_id]
								AND i.[schema_name] = h.[schema_name]
                        JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                        WHERE    i.index_id = 0 
                                AND 
                                    (i.total_reads > 0 OR i.user_updates > 0)
								AND sz.total_rows < 10000
                                AND h.[object_id] IS NULL /*don't duplicate the prior check.*/
						OPTION    ( RECOMPILE );

				            RAISERROR(N'check_id 47: Heap with a Nonclustered Primary Key', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  47 AS check_id, 
                                i.index_sanity_id,
                                100 AS Priority,
                                N'Self Loathing Indexes' AS findings_group,
                                N'Heap with a Nonclustered Primary Key' AS finding, 
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/SelfLoathing' AS URL,
								db_schema_object_indexid + N' is a HEAP with a Nonclustered Primary Key' AS details, 
                                i.index_definition, 
                                i.secret_columns,
                                i.index_usage_summary,
                                sz.index_size_summary
                        FROM    #IndexSanity i
                        JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                        WHERE    i.index_type = 2 AND i.is_primary_key = 1
                        AND EXISTS 
                            (
                              SELECT 1/0 
                              FROM #IndexSanity AS isa
                              WHERE i.database_id = isa.database_id
                              AND   i.object_id = isa.object_id
                              AND   isa.index_id = 0
                            )
						OPTION    ( RECOMPILE );

	            RAISERROR(N'check_id 48: Nonclustered indexes with a bad read to write ratio', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  48 AS check_id, 
                                i.index_sanity_id,
                                100 AS Priority,
                                N'Index Hoarder' AS findings_group,
                                N'NC index with High Writes:Reads' AS finding, 
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/IndexHoarder' AS URL,
                                N'Reads: '
								+ REPLACE(CONVERT(NVARCHAR(30), CAST((i.total_reads) AS MONEY), 1), N'.00', N'') 
								+ N' Writes: ' 
								+ REPLACE(CONVERT(NVARCHAR(30), CAST((i.user_updates) AS MONEY), 1), N'.00', N'')
								+ N' on: '
								+ i.db_schema_object_indexid AS details, 
                                i.index_definition, 
                                i.secret_columns, 
                                i.index_usage_summary,
                                sz.index_size_summary
                        FROM    #IndexSanity i
                        JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                        WHERE    i.total_reads > 0 /*Not totally unused*/
								AND i.user_updates >= 10000 /*Decent write activity*/
								AND i.total_reads < 10000
								AND ((i.total_reads * 10) < i.user_updates) /*10x more writes than reads*/
                                AND i.index_id NOT IN (0,1) /*NCs only*/
                                AND i.is_unique = 0 
                                AND sz.total_reserved_MB >= CASE WHEN (@GetAllDatabases = 1 OR @Mode = 0) THEN @ThresholdMB ELSE sz.total_reserved_MB END
                        ORDER BY i.db_schema_object_indexid
                        OPTION    ( RECOMPILE );

        ----------------------------------------
        --Indexaphobia
        --Missing indexes with value >= 5 million: : Check_id 50-59
        ----------------------------------------
            RAISERROR(N'check_id 50: Indexaphobia.', 0,1) WITH NOWAIT;
            WITH    index_size_cte
                      AS ( SELECT   i.database_id,
									i.schema_name,
									i.[object_id], 
                                    MAX(i.index_sanity_id) AS index_sanity_id,
									ISNULL(NULLIF(MAX(DATEDIFF(DAY, i.create_date, SYSDATETIME())), 0), 1) AS create_days,
                                ISNULL (
                                    CAST(SUM(CASE WHEN index_id NOT IN (0,1) THEN 1 ELSE 0 END)
                                         AS NVARCHAR(30))+ N' NC indexes exist (' + 
                                    CASE WHEN SUM(CASE WHEN index_id NOT IN (0,1) THEN sz.total_reserved_MB ELSE 0 END) > 1024
                                        THEN CAST(CAST(SUM(CASE WHEN index_id NOT IN (0,1) THEN sz.total_reserved_MB ELSE 0 END )/1024. 

                                            AS NUMERIC(29,1)) AS NVARCHAR(30)) + N'GB); ' 
                                        ELSE CAST(SUM(CASE WHEN index_id NOT IN (0,1) THEN sz.total_reserved_MB ELSE 0 END) 
                                            AS NVARCHAR(30)) + N'MB); '
                                    END + 
                                        CASE WHEN MAX(sz.[total_rows]) >= 922337203685477 THEN '>= 922,337,203,685,477'
                                        ELSE REPLACE(CONVERT(NVARCHAR(30),CAST(MAX(sz.[total_rows]) AS MONEY), 1), '.00', '') 
                                        END +
                                    + N' Estimated Rows;' 
                                ,N'') AS index_size_summary
                            FROM    #IndexSanity AS i
                            LEFT    JOIN #IndexSanitySize AS sz ON i.index_sanity_id = sz.index_sanity_id  AND i.database_id = sz.database_id
							WHERE i.is_hypothetical = 0
                                  AND i.is_disabled = 0
                           GROUP BY    i.database_id, i.schema_name, i.[object_id])
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               index_usage_summary, index_size_summary, create_tsql, more_info )
                        
                        SELECT check_id, t.index_sanity_id, t.check_id, t.findings_group, t.finding, t.[Database Name], t.URL, t.details, t.[definition],
                                index_estimated_impact, t.index_size_summary, create_tsql, more_info
                        FROM
                        (
                            SELECT  ROW_NUMBER() OVER (ORDER BY magic_benefit_number DESC) AS rownum,
                                50 AS check_id, 
                                sz.index_sanity_id,
                                40 AS Priority,
                                N'Indexaphobia' AS findings_group,
                                N'High Value Missing Index' AS finding, 
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/Indexaphobia' AS URL,
                                mi.[statement] + 
                                N' Est. benefit per day: ' + 
                                    CASE WHEN magic_benefit_number >= 922337203685477 THEN '>= 922,337,203,685,477'
                                    ELSE REPLACE(CONVERT(NVARCHAR(256),CAST(CAST(
                                    (magic_benefit_number/@DaysUptime)
                                     AS BIGINT) AS MONEY), 1), '.00', '') 
                                    END AS details,
                                missing_index_details AS [definition],
                                index_estimated_impact,
                                sz.index_size_summary,
                                mi.create_tsql,
                                mi.more_info,
                                magic_benefit_number,
								mi.is_low
                        FROM    #MissingIndexes mi
                                LEFT JOIN index_size_cte sz ON mi.[object_id] = sz.object_id 
										  AND mi.database_id = sz.database_id
										  AND mi.schema_name = sz.schema_name
                                        /* Minimum benefit threshold = 100k/day of uptime OR since table creation date, whichever is lower*/
                        WHERE @ShowAllMissingIndexRequests=1
                        OR ( @Mode = 4 AND (magic_benefit_number / CASE WHEN sz.create_days < @DaysUptime THEN sz.create_days ELSE @DaysUptime END) >= 100000 ) 
						OR (magic_benefit_number / CASE WHEN sz.create_days < @DaysUptime THEN sz.create_days ELSE @DaysUptime END) >= 100000
                        ) AS t
                        WHERE t.rownum <= CASE WHEN (@Mode <> 4) THEN 20 ELSE t.rownum END
                        ORDER BY magic_benefit_number DESC
						OPTION    ( RECOMPILE );



            RAISERROR(N'check_id 68: Identity columns within 30 percent of the end of range', 0,1) WITH NOWAIT;
            -- Allowed Ranges: 
                --int -2,147,483,648 to 2,147,483,647
                --smallint -32,768 to 32,768
                --tinyint 0 to 255

                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  68 AS check_id, 
                                i.index_sanity_id, 
                                80 AS Priority,
                                N'Abnormal Psychology' AS findings_group,
                                N'Identity Column Within ' +                                     
                                    CAST (calc1.percent_remaining AS NVARCHAR(256))
                                    + N' Percent End of Range' AS finding,
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/AbnormalPsychology' AS URL,
                                i.db_schema_object_name + N'.' +  QUOTENAME(ic.column_name)
                                    + N' is an identity with type ' + ic.system_type_name 
                                    + N', last value of ' 
                                        + ISNULL((CONVERT(NVARCHAR(256),CAST(ic.last_value AS DECIMAL(38,0)), 1)),N'NULL')
                                    + N', seed of '
                                        + ISNULL((CONVERT(NVARCHAR(256),CAST(ic.seed_value AS DECIMAL(38,0)), 1)),N'NULL')
                                    + N', increment of ' + CAST(ic.increment_value AS NVARCHAR(256)) 
                                    + N', and range of ' +
                                        CASE ic.system_type_name WHEN 'int' THEN N'+/- 2,147,483,647'
                                            WHEN 'smallint' THEN N'+/- 32,768'
                                            WHEN 'tinyint' THEN N'0 to 255'
                                            ELSE 'unknown'
                                        END
                                        AS details,
                                i.index_definition,
                                secret_columns, 
                                ISNULL(i.index_usage_summary,''),
                                ISNULL(ip.index_size_summary,'')
                        FROM    #IndexSanity i
                        JOIN    #IndexColumns ic ON
                            i.object_id=ic.object_id
							AND i.database_id = ic.database_id
							AND i.schema_name = ic.schema_name
                            AND i.index_id IN (0,1) /* heaps and cx only */
                            AND ic.is_identity=1
                            AND ic.system_type_name IN ('tinyint', 'smallint', 'int')
                        JOIN    #IndexSanitySize ip ON i.index_sanity_id = ip.index_sanity_id
                        CROSS APPLY (
                            SELECT CAST(CASE WHEN ic.increment_value >= 0
                                    THEN
                                        CASE ic.system_type_name 
                                            WHEN 'int' THEN (2147483647 - (ISNULL(ic.last_value,ic.seed_value) + ic.increment_value)) / 2147483647.*100
                                            WHEN 'smallint' THEN (32768 - (ISNULL(ic.last_value,ic.seed_value) + ic.increment_value)) / 32768.*100
                                            WHEN 'tinyint' THEN ( 255 - (ISNULL(ic.last_value,ic.seed_value) + ic.increment_value)) / 255.*100
                                            ELSE 999
                                        END
                                ELSE --ic.increment_value is negative
                                        CASE ic.system_type_name 
                                            WHEN 'int' THEN ABS(-2147483647 - (ISNULL(ic.last_value,ic.seed_value) + ic.increment_value)) / 2147483647.*100
                                            WHEN 'smallint' THEN ABS(-32768 - (ISNULL(ic.last_value,ic.seed_value) + ic.increment_value)) / 32768.*100
                                            WHEN 'tinyint' THEN ABS( 0 - (ISNULL(ic.last_value,ic.seed_value) + ic.increment_value)) / 255.*100
                                            ELSE -1
                                        END 
                                END AS NUMERIC(5,1)) AS percent_remaining
                                ) AS calc1
                        WHERE    i.index_id IN (1,0)
                            AND calc1.percent_remaining <= 30
                        OPTION (RECOMPILE);


		RAISERROR(N'check_id 72: Columnstore indexes with Trace Flag 834', 0,1) WITH NOWAIT;
            IF EXISTS (SELECT * FROM #IndexSanity WHERE index_type IN (5,6))
			AND EXISTS (SELECT * FROM #TraceStatus WHERE TraceFlag = 834 AND status = 1)
			BEGIN
			INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                            secret_columns, index_usage_summary, index_size_summary )
                SELECT  72 AS check_id, 
                        i.index_sanity_id,
                        80 AS Priority,
                        N'Abnormal Psychology' AS findings_group,
                        'Columnstore Indexes with Trace Flag 834' AS finding, 
                        [database_name] AS [Database Name],
                        N'https://support.microsoft.com/en-us/kb/3210239' AS URL,
                        i.db_schema_object_indexid AS details, 
                        i.index_definition,
                        i.secret_columns,
                        i.index_usage_summary,
                        ISNULL(sz.index_size_summary,'') AS index_size_summary
                FROM    #IndexSanity AS i
                JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                WHERE i.index_type IN (5,6)
                OPTION    ( RECOMPILE );
			END;

        ----------------------------------------
        --Statistics Info: Check_id 90-99
        ----------------------------------------

        RAISERROR(N'check_id 90: Outdated statistics', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
		SELECT  90 AS check_id, 
				90 AS Priority,
				'Functioning Statistaholics' AS findings_group,
				'Statistics Not Updated Recently',
				s.database_name,
				'https://www.brentozar.com/go/stats' AS URL,
				'Statistics on this table were last updated ' + 
					CASE WHEN s.last_statistics_update IS NULL THEN N' NEVER '
					ELSE CONVERT(NVARCHAR(20), s.last_statistics_update) + 
						' have had ' + CONVERT(NVARCHAR(100), s.modification_counter) +
						' modifications in that time, which is ' +
						CONVERT(NVARCHAR(100), s.percent_modifications) + 
						'% of the table.'
					END AS details,
				QUOTENAME(database_name) + '.' + QUOTENAME(s.schema_name) + '.' + QUOTENAME(s.table_name) + '.' + QUOTENAME(s.index_name) + '.' + QUOTENAME(s.statistics_name) + '.' + QUOTENAME(s.column_names) AS index_definition,
				'N/A' AS secret_columns,
				'N/A' AS index_usage_summary,
				'N/A' AS index_size_summary
		FROM #Statistics AS s
		WHERE s.last_statistics_update <= CONVERT(DATETIME, GETDATE() - 30) 
		AND s.percent_modifications >= 10. 
		AND s.rows >= 10000
		OPTION    ( RECOMPILE );

        RAISERROR(N'check_id 91: Statistics with a low sample rate', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
		SELECT  91 AS check_id, 
				90 AS Priority,
				'Functioning Statistaholics' AS findings_group,
				'Low Sampling Rates',
				s.database_name,
				'https://www.brentozar.com/go/stats' AS URL,
				'Only ' + CONVERT(NVARCHAR(100), s.percent_sampled) + '% of the rows were sampled during the last statistics update. This may lead to poor cardinality estimates.' AS details,
				QUOTENAME(database_name) + '.' + QUOTENAME(s.schema_name) + '.' + QUOTENAME(s.table_name) + '.' + QUOTENAME(s.index_name) + '.' + QUOTENAME(s.statistics_name) + '.' + QUOTENAME(s.column_names) AS index_definition,
				'N/A' AS secret_columns,
				'N/A' AS index_usage_summary,
				'N/A' AS index_size_summary
		FROM #Statistics AS s
		WHERE (s.rows BETWEEN 10000 AND 1000000 AND s.percent_sampled < 10)
		  OR (s.rows > 1000000 AND s.percent_sampled < 1)
		OPTION    ( RECOMPILE );

        RAISERROR(N'check_id 92: Statistics with NO RECOMPUTE', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
		SELECT  92 AS check_id, 
				90 AS Priority,
				'Functioning Statistaholics' AS findings_group,
				'Statistics With NO RECOMPUTE',
				s.database_name,
				'https://www.brentozar.com/go/stats' AS URL,
				'The statistic ' + QUOTENAME(s.statistics_name) +  ' is set to not recompute. This can be helpful if data is really skewed, but harmful if you expect automatic statistics updates.' AS details,
				QUOTENAME(database_name) + '.' + QUOTENAME(s.schema_name) + '.' + QUOTENAME(s.table_name) + '.' + QUOTENAME(s.index_name) + '.' + QUOTENAME(s.statistics_name) + '.' + QUOTENAME(s.column_names) AS index_definition,
				'N/A' AS secret_columns,
				'N/A' AS index_usage_summary,
				'N/A' AS index_size_summary
		FROM #Statistics AS s
		WHERE s.no_recompute = 1
		OPTION    ( RECOMPILE );


	     RAISERROR(N'check_id 94: Check Constraints That Reference Functions', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
		SELECT  94 AS check_id, 
				100 AS Priority,
				'Serial Forcer' AS findings_group,
				'Check Constraint with Scalar UDF' AS finding,
				cc.database_name,
				'https://www.brentozar.com/go/computedscalar' AS URL,
				'The check constraint ' + QUOTENAME(cc.constraint_name) + ' on ' + QUOTENAME(cc.schema_name) + '.' + QUOTENAME(cc.table_name) + ' is based on ' + cc.definition 
				+ '. That indicates it may reference a scalar function, or a CLR function with data access, which can cause all queries and maintenance to run serially.' AS details,
				cc.column_definition,
				'N/A' AS secret_columns,
				'N/A' AS index_usage_summary,
				'N/A' AS index_size_summary
		FROM #CheckConstraints AS cc
		WHERE cc.is_function = 1
		OPTION    ( RECOMPILE );

		RAISERROR(N'check_id 99: Computed Columns That Reference Functions', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
		SELECT  99 AS check_id, 
				100 AS Priority,
				'Serial Forcer' AS findings_group,
				'Computed Column with Scalar UDF' AS finding,
				cc.database_name,
				'https://www.brentozar.com/go/serialudf' AS URL,
				'The computed column ' + QUOTENAME(cc.column_name) + ' on ' + QUOTENAME(cc.schema_name) + '.' + QUOTENAME(cc.table_name) + ' is based on ' + cc.definition 
				+ '. That indicates it may reference a scalar function, or a CLR function with data access, which can cause all queries and maintenance to run serially.' AS details,
				cc.column_definition,
				'N/A' AS secret_columns,
				'N/A' AS index_usage_summary,
				'N/A' AS index_size_summary
		FROM #ComputedColumns AS cc
		WHERE cc.is_function = 1
		OPTION    ( RECOMPILE );



	END /* IF @Mode IN (0, 4) DIAGNOSE priorities 1-100 */

























    IF @Mode = 4 /* DIAGNOSE*/
    BEGIN;
        RAISERROR(N'@Mode=4, running rules for priorities 101+.', 0,1) WITH NOWAIT;

            RAISERROR(N'check_id 21: More Than 5 Percent NC Indexes Are Unused', 0,1) WITH NOWAIT;
            DECLARE @percent_NC_indexes_unused NUMERIC(29,1);
            DECLARE @NC_indexes_unused_reserved_MB NUMERIC(29,1);

            SELECT  @percent_NC_indexes_unused = ( 100.00 * SUM(CASE 
					                                                WHEN total_reads = 0 
																	THEN 1
                                                                    ELSE 0
                                                                    END) ) / COUNT(*),
                    @NC_indexes_unused_reserved_MB = SUM(CASE 
							                                    WHEN total_reads = 0 
																THEN sz.total_reserved_MB
                                                                ELSE 0
                                                            END) 
            FROM    #IndexSanity i
            JOIN    #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
            WHERE    index_id NOT IN ( 0, 1 ) 
                    AND i.is_unique = 0
					/*Skipping tables created in the last week, or modified in past 2 days*/
					AND	i.create_date >= DATEADD(dd,-7,GETDATE()) 
					AND i.modify_date > DATEADD(dd,-2,GETDATE()) 
            OPTION    ( RECOMPILE );
            IF @percent_NC_indexes_unused >= 5 
            INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                            secret_columns, index_usage_summary, index_size_summary )
                        SELECT  21 AS check_id, 
                                MAX(i.index_sanity_id) AS index_sanity_id, 
                                150 AS Priority,
                                N'Index Hoarder' AS findings_group,
                                N'More Than 5 Percent NC Indexes Are Unused' AS finding,
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/IndexHoarder' AS URL,
                                CAST (@percent_NC_indexes_unused AS NVARCHAR(30)) + N' percent NC indexes (' + CAST(COUNT(*) AS NVARCHAR(10)) + N') unused. ' +
                                N'These take up ' + CAST (@NC_indexes_unused_reserved_MB AS NVARCHAR(30)) + N'MB of space.' AS details,
                                i.database_name + ' (' + CAST (COUNT(*) AS NVARCHAR(30)) + N' indexes)' AS index_definition,
                                '' AS secret_columns, 
                                CAST(SUM(total_reads) AS NVARCHAR(256)) + N' reads (ALL); '
                                    + CAST(SUM([user_updates]) AS NVARCHAR(256)) + N' writes (ALL)' AS index_usage_summary,
                                
                                REPLACE(CONVERT(NVARCHAR(30),CAST(MAX([total_rows]) AS MONEY), 1), '.00', '') + N' rows (MAX)'
                                    + CASE WHEN SUM(total_reserved_MB) > 1024 THEN 
                                        N'; ' + CAST(CAST(SUM(total_reserved_MB)/1024. AS NUMERIC(29,1)) AS NVARCHAR(30)) + 'GB (ALL)'
                                    WHEN SUM(total_reserved_MB) > 0 THEN
                                        N'; ' + CAST(CAST(SUM(total_reserved_MB) AS NUMERIC(29,1)) AS NVARCHAR(30)) + 'MB (ALL)'
                                    ELSE ''
                                    END AS index_size_summary
                        FROM    #IndexSanity i
                        JOIN    #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                        WHERE    index_id NOT IN ( 0, 1 )
                                AND i.is_unique = 0
                                AND total_reads = 0
								/*Skipping tables created in the last week, or modified in past 2 days*/
								AND	i.create_date >= DATEADD(dd,-7,GETDATE()) 
								AND i.modify_date > DATEADD(dd,-2,GETDATE())
                        GROUP BY i.database_name 
                OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 23: Indexes with 7 or more columns. (Borderline)', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                    SELECT  23 AS check_id, 
                            i.index_sanity_id,
                            150 AS Priority, 
                            N'Index Hoarder' AS findings_group,
                            N'Borderline: Wide Indexes (7 or More Columns)' AS finding, 
                            [database_name] AS [Database Name],
                            N'https://www.brentozar.com/go/IndexHoarder' AS URL,
                            CAST(count_key_columns + count_included_columns AS NVARCHAR(10)) + ' columns on '
                            + i.db_schema_object_indexid AS details, i.index_definition, 
                            i.secret_columns, 
                            i.index_usage_summary,
                            sz.index_size_summary
                    FROM    #IndexSanity AS i
                    JOIN    #IndexSanitySize AS sz ON i.index_sanity_id = sz.index_sanity_id
                    WHERE    ( count_key_columns + count_included_columns ) >= 7
                    OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 24: Wide clustered indexes (> 3 columns or > 16 bytes).', 0,1) WITH NOWAIT;
                WITH count_columns AS (
                            SELECT database_id, [object_id],
                                SUM(CASE max_length WHEN -1 THEN 0 ELSE max_length END) AS sum_max_length
                            FROM #IndexColumns ic
                            WHERE index_id IN (1,0) /*Heap or clustered only*/
                            AND key_ordinal > 0
                            GROUP BY database_id, object_id
                            )
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  24 AS check_id, 
                                i.index_sanity_id, 
                                150 AS Priority,
                                N'Index Hoarder' AS findings_group,
                                N'Wide Clustered Index (> 3 columns OR > 16 bytes)' AS finding,
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/IndexHoarder' AS URL,
                                CAST (i.count_key_columns AS NVARCHAR(10)) + N' columns with potential size of '
                                    + CAST(cc.sum_max_length AS NVARCHAR(10))
                                    + N' bytes in clustered index:' + i.db_schema_object_name 
                                    + N'. ' + 
                                        (SELECT CAST(COUNT(*) AS NVARCHAR(23)) 
										 FROM #IndexSanity i2 
                                         WHERE i2.[object_id]=i.[object_id] 
										 AND i2.database_id = i.database_id 
										 AND i2.index_id <> 1
                                         AND i2.is_disabled=0 
										 AND i2.is_hypothetical=0)
                                        + N' NC indexes on the table.'
                                    AS details,
                                i.index_definition,
                                secret_columns, 
                                i.index_usage_summary,
                                ip.index_size_summary
                        FROM    #IndexSanity i
                        JOIN    #IndexSanitySize ip ON i.index_sanity_id = ip.index_sanity_id
                        JOIN    count_columns AS cc ON i.[object_id]=cc.[object_id]
                                                   AND i.database_id = cc.database_id
                        WHERE    index_id = 1 /* clustered only */
                                AND 
                                    (count_key_columns > 3 /*More than three key columns.*/
                                    OR cc.sum_max_length > 16 /*More than 16 bytes in key */)
									AND i.is_CX_columnstore = 0
                        ORDER BY i.db_schema_object_name DESC OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 25: Addicted to nullable columns.', 0,1) WITH NOWAIT;
                WITH count_columns AS (
                            SELECT [object_id],
								   [database_id],
								   [schema_name],
                                SUM(CASE is_nullable WHEN 1 THEN 0 ELSE 1 END) AS non_nullable_columns,
                                COUNT(*) AS total_columns
                            FROM #IndexColumns ic
                            WHERE index_id IN (1,0) /*Heap or clustered only*/
                            GROUP BY [object_id],
								     [database_id],
								     [schema_name]
                            )
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  25 AS check_id, 
                                i.index_sanity_id, 
                                200 AS Priority,
                                N'Index Hoarder' AS findings_group,
                                N'Addicted to Nulls' AS finding,
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/IndexHoarder' AS URL,
                                i.db_schema_object_name 
                                    + N' allows null in ' + CAST((total_columns-non_nullable_columns) AS NVARCHAR(10))
                                    + N' of ' + CAST(total_columns AS NVARCHAR(10))
                                    + N' columns.' AS details,
                                i.index_definition,
                                secret_columns, 
                                ISNULL(i.index_usage_summary,''),
                                ISNULL(ip.index_size_summary,'')
                        FROM    #IndexSanity i
                        JOIN    #IndexSanitySize ip ON i.index_sanity_id = ip.index_sanity_id
                        JOIN    count_columns AS cc ON i.[object_id]=cc.[object_id]
								AND cc.database_id = ip.database_id
								AND cc.[schema_name] = ip.[schema_name]
                        WHERE    i.index_id IN (1,0)
                            AND cc.non_nullable_columns < 2
                            AND cc.total_columns > 3
                        ORDER BY i.db_schema_object_name DESC OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 26: Wide tables (35+ cols or > 2000 non-LOB bytes).', 0,1) WITH NOWAIT;
                WITH count_columns AS (
                            SELECT [object_id],
								   [database_id],
								   [schema_name],
                                SUM(CASE max_length WHEN -1 THEN 1 ELSE 0 END) AS count_lob_columns,
                                SUM(CASE max_length WHEN -1 THEN 0 ELSE max_length END) AS sum_max_length,
                                COUNT(*) AS total_columns
                            FROM #IndexColumns ic
                            WHERE index_id IN (1,0) /*Heap or clustered only*/
                            GROUP BY [object_id],
								     [database_id],
								     [schema_name]
                            )
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  26 AS check_id, 
                                i.index_sanity_id, 
                                150 AS Priority,
                                N'Index Hoarder' AS findings_group,
                                N'Wide Tables: 35+ cols or > 2000 non-LOB bytes' AS finding,
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/IndexHoarder' AS URL,
                                i.db_schema_object_name 
                                    + N' has ' + CAST((total_columns) AS NVARCHAR(10))
                                    + N' total columns with a max possible width of ' + CAST(sum_max_length AS NVARCHAR(10))
                                    + N' bytes.' +
                                    CASE WHEN count_lob_columns > 0 THEN CAST((count_lob_columns) AS NVARCHAR(10))
                                        + ' columns are LOB types.' ELSE ''
                                    END
                                        AS details,
                                i.index_definition,
                                secret_columns, 
                                ISNULL(i.index_usage_summary,''),
                                ISNULL(ip.index_size_summary,'')
                        FROM    #IndexSanity i
                        JOIN    #IndexSanitySize ip ON i.index_sanity_id = ip.index_sanity_id
                        JOIN    count_columns AS cc ON i.[object_id]=cc.[object_id]
								AND cc.database_id = i.database_id
								AND cc.[schema_name] = i.[schema_name]
                        WHERE    i.index_id IN (1,0)
                            AND 
                            (cc.total_columns >= 35 OR
                            cc.sum_max_length >= 2000)
                        ORDER BY i.db_schema_object_name DESC OPTION    ( RECOMPILE );
                    
            RAISERROR(N'check_id 27: Addicted to strings.', 0,1) WITH NOWAIT;
                WITH count_columns AS (
                            SELECT [object_id],
								   [database_id],
								   [schema_name],
                                SUM(CASE WHEN system_type_name IN ('varchar','nvarchar','char') OR max_length=-1 THEN 1 ELSE 0 END) AS string_or_LOB_columns,
                                COUNT(*) AS total_columns
                            FROM #IndexColumns ic
                            WHERE index_id IN (1,0) /*Heap or clustered only*/
                            GROUP BY [object_id],
								     [database_id],
								     [schema_name]
                            )
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  27 AS check_id, 
                                i.index_sanity_id, 
                                200 AS Priority,
                                N'Index Hoarder' AS findings_group,
                                N'Addicted to strings' AS finding,
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/IndexHoarder' AS URL,
                                i.db_schema_object_name 
                                    + N' uses string or LOB types for ' + CAST((string_or_LOB_columns) AS NVARCHAR(10))
                                    + N' of ' + CAST(total_columns AS NVARCHAR(10))
                                    + N' columns. Check if data types are valid.' AS details,
                                i.index_definition,
                                secret_columns, 
                                ISNULL(i.index_usage_summary,''),
                                ISNULL(ip.index_size_summary,'')
                        FROM    #IndexSanity i
                        JOIN    #IndexSanitySize ip ON i.index_sanity_id = ip.index_sanity_id
                        JOIN    count_columns AS cc ON i.[object_id]=cc.[object_id]
								AND cc.database_id = i.database_id
								AND cc.[schema_name] = i.[schema_name]
                        CROSS APPLY (SELECT cc.total_columns - string_or_LOB_columns AS non_string_or_lob_columns) AS calc1
                        WHERE    i.index_id IN (1,0)
                            AND calc1.non_string_or_lob_columns <= 1
                            AND cc.total_columns > 3
                        ORDER BY i.db_schema_object_name DESC OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 28: Non-unique clustered index.', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  28 AS check_id, 
                                i.index_sanity_id, 
                                150 AS Priority,
                                N'Index Hoarder' AS findings_group,
                                N'Non-Unique Clustered JIndex' AS finding,
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/IndexHoarder' AS URL,
                                N'Uniquifiers will be required! Clustered index: ' + i.db_schema_object_name 
                                    + N' and all NC indexes. ' + 
                                        (SELECT CAST(COUNT(*) AS NVARCHAR(23)) 
										 FROM #IndexSanity i2 
                                         WHERE i2.[object_id]=i.[object_id] 
										 AND i2.database_id = i.database_id 
										 AND i2.index_id <> 1
                                         AND i2.is_disabled=0 
										 AND i2.is_hypothetical=0)
                                        + N' NC indexes on the table.'
                                    AS details,
                                i.index_definition,
                                secret_columns, 
                                i.index_usage_summary,
                                ip.index_size_summary
                        FROM    #IndexSanity i
                        JOIN    #IndexSanitySize ip ON i.index_sanity_id = ip.index_sanity_id
                        WHERE    index_id = 1 /* clustered only */
                                AND is_unique=0 /* not unique */
                                AND is_CX_columnstore=0 /* not a clustered columnstore-- no unique option on those */
                        ORDER BY i.db_schema_object_name DESC OPTION    ( RECOMPILE );

        RAISERROR(N'check_id 29: NC indexes with 0 reads. (Borderline) and < 10,000 writes', 0,1) WITH NOWAIT;
        INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                        secret_columns, index_usage_summary, index_size_summary )
                SELECT  29 AS check_id, 
                        i.index_sanity_id,
                        150 AS Priority,
                        N'Index Hoarder' AS findings_group,
                        N'Unused NC index with Low Writes' AS finding, 
                        [database_name] AS [Database Name],
                        N'https://www.brentozar.com/go/IndexHoarder' AS URL,
                        N'0 reads: ' + i.db_schema_object_indexid AS details, 
                        i.index_definition, 
                        i.secret_columns, 
                        i.index_usage_summary,
                        sz.index_size_summary
                FROM    #IndexSanity AS i
                JOIN    #IndexSanitySize AS sz ON i.index_sanity_id = sz.index_sanity_id
                WHERE    i.total_reads=0
						AND i.user_updates < 10000
                        AND i.index_id NOT IN (0,1) /*NCs only*/
                        AND i.is_unique = 0
                        AND sz.total_reserved_MB >= CASE WHEN (@GetAllDatabases = 1 OR @Mode = 0) THEN @ThresholdMB ELSE sz.total_reserved_MB END
						/*Skipping tables created in the last week, or modified in past 2 days*/
						AND	i.create_date >= DATEADD(dd,-7,GETDATE()) 
						AND i.modify_date > DATEADD(dd,-2,GETDATE())
                ORDER BY i.db_schema_object_indexid
                OPTION    ( RECOMPILE );


        ----------------------------------------
        --Feature-Phobic Indexes: Check_id 30-39
        ---------------------------------------- 
            RAISERROR(N'check_id 30: No indexes with includes', 0,1) WITH NOWAIT;
            /* This does not work the way you'd expect with @GetAllDatabases = 1. For details:
               https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/issues/825
            */

			SELECT  database_name,
					SUM(CASE WHEN count_included_columns > 0 THEN 1 ELSE 0 END) AS number_indexes_with_includes,
					100.* SUM(CASE WHEN count_included_columns > 0 THEN 1 ELSE 0 END) / ( 1.0 * COUNT(*) ) AS percent_indexes_with_includes
			INTO #index_includes
            FROM    #IndexSanity
			WHERE is_hypothetical = 0
			AND is_disabled = 0
			AND NOT (@GetAllDatabases = 1 OR @Mode = 0)
			GROUP BY database_name;

                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  30 AS check_id, 
                                NULL AS index_sanity_id, 
                                250 AS Priority,
                                N'Feature-Phobic Indexes' AS findings_group,
								database_name AS [Database Name],
                                N'No Indexes Use Includes' AS finding, 'https://www.brentozar.com/go/IndexFeatures' AS URL,
                                N'No Indexes Use Includes' AS details,
                                database_name + N' (Entire database)' AS index_definition, 
                                N'' AS secret_columns, 
                                N'N/A' AS index_usage_summary, 
                                N'N/A' AS index_size_summary 
						FROM #index_includes
						WHERE number_indexes_with_includes = 0
						OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 31: < 3 percent of indexes have includes', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
					SELECT  31 AS check_id,
					        NULL AS index_sanity_id, 
					        250 AS Priority,
					        N'Feature-Phobic Indexes' AS findings_group,
					        N'Few Indexes Use Includes' AS findings,
					        database_name AS [Database Name],
					        N'https://www.brentozar.com/go/IndexFeatures' AS URL,
					        N'Only ' + CAST(percent_indexes_with_includes AS NVARCHAR(20)) + '% of indexes have includes' AS details, 
					        N'Entire database' AS index_definition, 
					        N'' AS secret_columns,
					        N'N/A' AS index_usage_summary, 
					        N'N/A' AS index_size_summary
					FROM #index_includes
					WHERE number_indexes_with_includes > 0 AND percent_indexes_with_includes <= 3
					OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 32: filtered indexes and indexed views', 0,1) WITH NOWAIT;

                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
					SELECT  DISTINCT
							32 AS check_id, 
					        NULL AS index_sanity_id,
					        250 AS Priority,
					        N'Feature-Phobic Indexes' AS findings_group,
					        N'No Filtered Indexes or Indexed Views' AS finding, 
					        i.database_name AS [Database Name],
					        N'https://www.brentozar.com/go/IndexFeatures' AS URL,
					        N'These are NOT always needed-- but do you know when you would use them?' AS details,
					        i.database_name + N' (Entire database)' AS index_definition, 
					        N'' AS secret_columns,
					        N'N/A' AS index_usage_summary, 
					        N'N/A' AS index_size_summary 
					FROM #IndexSanity i
					WHERE i.database_name NOT IN (                
							SELECT   database_name
							FROM     #IndexSanity
							WHERE    filter_definition <> '' )
					AND i.database_name NOT IN (
					       SELECT  database_name
						   FROM    #IndexSanity
						   WHERE   is_indexed_view = 1 )
					OPTION    ( RECOMPILE );

        RAISERROR(N'check_id 33: Potential filtered indexes based on column names.', 0,1) WITH NOWAIT;

                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
					SELECT  33 AS check_id, 
					        i.index_sanity_id AS index_sanity_id,
					        250 AS Priority,
					        N'Feature-Phobic Indexes' AS findings_group,
					        N'Potential Filtered Index (Based on Column Name)' AS finding, 
					        [database_name] AS [Database Name],
					        N'https://www.brentozar.com/go/IndexFeatures' AS URL,
					        N'A column name in this index suggests it might be a candidate for filtering (is%, %archive%, %active%, %flag%)' AS details,
					        i.index_definition, 
					        i.secret_columns,
					        i.index_usage_summary, 
					        sz.index_size_summary
					FROM #IndexColumns ic 
					JOIN #IndexSanity i ON ic.[object_id]=i.[object_id] 
						AND ic.database_id =i.database_id
						AND ic.schema_name = i.schema_name
						AND ic.[index_id]=i.[index_id] 
						AND i.[index_id] > 1 /* non-clustered index */
					JOIN    #IndexSanitySize AS sz ON i.index_sanity_id = sz.index_sanity_id
					WHERE (column_name LIKE 'is%'
					    OR column_name LIKE '%archive%'
					    OR column_name LIKE '%active%'
					    OR column_name LIKE '%flag%')
					OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 41: Hypothetical indexes ', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                    SELECT  41 AS check_id, 
                            i.index_sanity_id,
                            150 AS Priority,
                            N'Self Loathing Indexes' AS findings_group,
                            N'Hypothetical Index' AS finding,
                            [database_name] AS [Database Name],
                            N'https://www.brentozar.com/go/SelfLoathing' AS URL,
                            N'Hypothetical Index: ' + db_schema_object_indexid AS details, 
                            i.index_definition,
                            i.secret_columns,
                            N'' AS index_usage_summary, 
                            N'' AS index_size_summary
                    FROM    #IndexSanity AS i
                    WHERE    is_hypothetical = 1 
                    OPTION    ( RECOMPILE );


            RAISERROR(N'check_id 42: Disabled indexes', 0,1) WITH NOWAIT;
            --Note: disabled NC indexes will have O rows in #IndexSanitySize!
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                    SELECT  42 AS check_id, 
                            index_sanity_id,
                            150 AS Priority,
                            N'Self Loathing Indexes' AS findings_group,
                            N'Disabled Index' AS finding, 
                            [database_name] AS [Database Name],
                            N'https://www.brentozar.com/go/SelfLoathing' AS URL,
                            N'Disabled Index:' + db_schema_object_indexid AS details, 
                            i.index_definition,
                            i.secret_columns,
                            i.index_usage_summary,
                            'DISABLED' AS index_size_summary
                    FROM    #IndexSanity AS i
                    WHERE    is_disabled = 1
                    OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 49: Heaps with deletes', 0,1) WITH NOWAIT;
            WITH    heaps_cte
                      AS ( SELECT   [object_id],
								    [database_id],
								    [schema_name],
                                    SUM(leaf_delete_count) AS leaf_delete_count
                           FROM        #IndexPartitionSanity
                           GROUP BY    [object_id],
								       [database_id],
								       [schema_name]
                           HAVING    SUM(forwarded_fetch_count) < 1000 * @DaysUptime /* Only alert about indexes with no forwarded fetches - we already alerted about those in check_id 43 */
                                    AND SUM(leaf_delete_count) > 0)
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  49 AS check_id, 
                                i.index_sanity_id,
                                200 AS Priority,
                                N'Self Loathing Indexes' AS findings_group,
                                N'Heaps with Deletes' AS finding, 
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/SelfLoathing' AS URL,
                                CAST(h.leaf_delete_count AS NVARCHAR(256)) + N' deletes against heap:'
                                + db_schema_object_indexid AS details, 
                                i.index_definition, 
                                i.secret_columns,
                                i.index_usage_summary,
                                sz.index_size_summary
                        FROM    #IndexSanity i
                        JOIN heaps_cte h ON i.[object_id] = h.[object_id] 
							 AND i.[database_id] = h.[database_id]
							 AND i.[schema_name] = h.[schema_name]
                        JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                        WHERE    i.index_id = 0 
                        AND sz.total_reserved_MB >= CASE WHEN NOT (@GetAllDatabases = 1 OR @Mode = 4) THEN @ThresholdMB ELSE sz.total_reserved_MB END
                OPTION    ( RECOMPILE );

         ----------------------------------------
        --Abnormal Psychology : Check_id 60-79
        ----------------------------------------
            RAISERROR(N'check_id 60: XML indexes', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                    SELECT  60 AS check_id, 
                            i.index_sanity_id,
                            150 AS Priority,
                            N'Abnormal Psychology' AS findings_group,
                            N'XML Index' AS finding, 
                            [database_name] AS [Database Name],
                            N'https://www.brentozar.com/go/AbnormalPsychology' AS URL,
                            i.db_schema_object_indexid AS details, 
                            i.index_definition,
                            i.secret_columns,
                            N'' AS index_usage_summary,
                            ISNULL(sz.index_size_summary,'') AS index_size_summary
                    FROM    #IndexSanity AS i
                    JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                    WHERE i.is_XML = 1 
					OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 61: Columnstore indexes', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                    SELECT  61 AS check_id, 
                            i.index_sanity_id,
                            150 AS Priority,
                            N'Abnormal Psychology' AS findings_group,
                            CASE WHEN i.is_NC_columnstore=1
                                THEN N'NC Columnstore Index' 
                                ELSE N'Clustered Columnstore Index' 
                                END AS finding, 
                            [database_name] AS [Database Name],
                            N'https://www.brentozar.com/go/AbnormalPsychology' AS URL,
                            i.db_schema_object_indexid AS details, 
                            i.index_definition,
                            i.secret_columns,
                            i.index_usage_summary,
                            ISNULL(sz.index_size_summary,'') AS index_size_summary
                    FROM    #IndexSanity AS i
                    JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                    WHERE i.is_NC_columnstore = 1 OR i.is_CX_columnstore=1
                    OPTION    ( RECOMPILE );


            RAISERROR(N'check_id 62: Spatial indexes', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                    SELECT  62 AS check_id, 
                            i.index_sanity_id,
                            150 AS Priority,
                            N'Abnormal Psychology' AS findings_group,
                            N'Spatial Index' AS finding,
                            [database_name] AS [Database Name], 
                            N'https://www.brentozar.com/go/AbnormalPsychology' AS URL,
                            i.db_schema_object_indexid AS details, 
                            i.index_definition,
                            i.secret_columns,
                            i.index_usage_summary,
                            ISNULL(sz.index_size_summary,'') AS index_size_summary
                    FROM    #IndexSanity AS i
                    JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                    WHERE i.is_spatial = 1 
					OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 63: Compressed indexes', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                    SELECT  63 AS check_id, 
                            i.index_sanity_id,
                            150 AS Priority,
                            N'Abnormal Psychology' AS findings_group,
                            N'Compressed Index' AS finding,
                            [database_name] AS [Database Name], 
                            N'https://www.brentozar.com/go/AbnormalPsychology' AS URL,
                            i.db_schema_object_indexid  + N'. COMPRESSION: ' + sz.data_compression_desc AS details, 
                            i.index_definition,
                            i.secret_columns,
                            i.index_usage_summary,
                            ISNULL(sz.index_size_summary,'') AS index_size_summary
                    FROM    #IndexSanity AS i
                    JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                    WHERE sz.data_compression_desc LIKE '%PAGE%' OR sz.data_compression_desc LIKE '%ROW%' 
					OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 64: Partitioned', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                    SELECT  64 AS check_id, 
                            i.index_sanity_id,
                            150 AS Priority,
                            N'Abnormal Psychology' AS findings_group,
                            N'Partitioned Index' AS finding,
                            [database_name] AS [Database Name], 
                            N'https://www.brentozar.com/go/AbnormalPsychology' AS URL,
                            i.db_schema_object_indexid AS details, 
                            i.index_definition,
                            i.secret_columns,
                            i.index_usage_summary,
                            ISNULL(sz.index_size_summary,'') AS index_size_summary
                    FROM    #IndexSanity AS i
                    JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                    WHERE i.partition_key_column_name IS NOT NULL 
					OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 65: Non-Aligned Partitioned', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                    SELECT  65 AS check_id, 
                            i.index_sanity_id,
                            150 AS Priority,
                            N'Abnormal Psychology' AS findings_group,
                            N'Non-Aligned Index on a Partitioned Table' AS finding,
                            i.[database_name] AS [Database Name], 
                            N'https://www.brentozar.com/go/AbnormalPsychology' AS URL,
                            i.db_schema_object_indexid AS details, 
                            i.index_definition,
                            i.secret_columns,
                            i.index_usage_summary,
                            ISNULL(sz.index_size_summary,'') AS index_size_summary
                    FROM    #IndexSanity AS i
                    JOIN #IndexSanity AS iParent ON
                        i.[object_id]=iParent.[object_id]
						AND i.database_id = iParent.database_id
						AND i.schema_name = iParent.schema_name
                        AND iParent.index_id IN (0,1) /* could be a partitioned heap or clustered table */
                        AND iParent.partition_key_column_name IS NOT NULL /* parent is partitioned*/         
                    JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                    WHERE i.partition_key_column_name IS NULL 
                    OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 66: Recently created tables/indexes (1 week)', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                    SELECT  66 AS check_id, 
                            i.index_sanity_id,
                            200 AS Priority,
                            N'Abnormal Psychology' AS findings_group,
                            N'Recently Created Tables/Indexes (1 week)' AS finding,
                            [database_name] AS [Database Name], 
                            N'https://www.brentozar.com/go/AbnormalPsychology' AS URL,
                            i.db_schema_object_indexid + N' was created on ' + 
                                CONVERT(NVARCHAR(16),i.create_date,121) + 
                                N'. Tables/indexes which are dropped/created regularly require special methods for index tuning.'
                                     AS details, 
                            i.index_definition,
                            i.secret_columns,
                            i.index_usage_summary,
                            ISNULL(sz.index_size_summary,'') AS index_size_summary
                    FROM    #IndexSanity AS i
                    JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                    WHERE i.create_date >= DATEADD(dd,-7,GETDATE()) 
                    OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 67: Recently modified tables/indexes (2 days)', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                    SELECT  67 AS check_id, 
                            i.index_sanity_id,
                            200 AS Priority,
                            N'Abnormal Psychology' AS findings_group,
                            N'Recently Modified Tables/Indexes (2 days)' AS finding,
                            [database_name] AS [Database Name], 
                            N'https://www.brentozar.com/go/AbnormalPsychology' AS URL,
                            i.db_schema_object_indexid + N' was modified on ' + 
                                CONVERT(NVARCHAR(16),i.modify_date,121) + 
                                N'. A large amount of recently modified indexes may mean a lot of rebuilds are occurring each night.'
                                     AS details, 
                            i.index_definition,
                            i.secret_columns,
                            i.index_usage_summary,
                            ISNULL(sz.index_size_summary,'') AS index_size_summary
                    FROM    #IndexSanity AS i
                    JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                    WHERE i.modify_date > DATEADD(dd,-2,GETDATE()) 
                    AND /*Exclude recently created tables.*/
                    i.create_date < DATEADD(dd,-7,GETDATE()) 
                    OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 69: Column collation does not match database collation', 0,1) WITH NOWAIT;
                WITH count_columns AS (
                            SELECT [object_id],
								   database_id,
								   schema_name,
                                   COUNT(*) AS column_count
                            FROM #IndexColumns ic
                            WHERE index_id IN (1,0) /*Heap or clustered only*/
                            AND collation_name <> @collation
                            GROUP BY [object_id],
								     database_id,
								     schema_name
                            )
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  69 AS check_id, 
                                i.index_sanity_id, 
                                150 AS Priority,
                                N'Abnormal Psychology' AS findings_group,
                                N'Column Collation Does Not Match Database Collation' AS finding,
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/AbnormalPsychology' AS URL,
                                i.db_schema_object_name 
                                    + N' has ' + CAST(column_count AS NVARCHAR(20))
                                    + N' column' + CASE WHEN column_count > 1 THEN 's' ELSE '' END
                                    + N' with a different collation than the db collation of '
                                    + @collation    AS details,
                                i.index_definition,
                                secret_columns, 
                                ISNULL(i.index_usage_summary,''),
                                ISNULL(ip.index_size_summary,'')
                        FROM    #IndexSanity i
                        JOIN    #IndexSanitySize ip ON i.index_sanity_id = ip.index_sanity_id
                        JOIN    count_columns AS cc ON i.[object_id]=cc.[object_id]
								AND cc.database_id = i.database_id
								AND cc.schema_name = i.schema_name
                        WHERE    i.index_id IN (1,0)
                        ORDER BY i.db_schema_object_name DESC OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 70: Replicated columns', 0,1) WITH NOWAIT;
                WITH count_columns AS (
                            SELECT [object_id],
								   database_id,
								   schema_name,
                                   COUNT(*) AS column_count,
                                   SUM(CASE is_replicated WHEN 1 THEN 1 ELSE 0 END) AS replicated_column_count
                            FROM #IndexColumns ic
                            WHERE index_id IN (1,0) /*Heap or clustered only*/
                            GROUP BY object_id,
								     database_id,
								     schema_name
                            )
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                        SELECT  70 AS check_id, 
                                i.index_sanity_id,
                                200 AS Priority, 
                                N'Abnormal Psychology' AS findings_group,
                                N'Replicated Columns' AS finding,
                                [database_name] AS [Database Name],
                                N'https://www.brentozar.com/go/AbnormalPsychology' AS URL,
                                i.db_schema_object_name 
                                    + N' has ' + CAST(replicated_column_count AS NVARCHAR(20))
                                    + N' out of ' + CAST(column_count AS NVARCHAR(20))
                                    + N' column' + CASE WHEN column_count > 1 THEN 's' ELSE '' END
                                    + N' in one or more publications.'
                                        AS details,
                                i.index_definition,
                                secret_columns, 
                                ISNULL(i.index_usage_summary,''),
                                ISNULL(ip.index_size_summary,'')
                        FROM    #IndexSanity i
                        JOIN    #IndexSanitySize ip ON i.index_sanity_id = ip.index_sanity_id
                        JOIN    count_columns AS cc ON i.[object_id]=cc.[object_id]
								AND i.database_id = cc.database_id
								AND i.schema_name = cc.schema_name
                        WHERE    i.index_id IN (1,0)
                            AND replicated_column_count > 0
                        ORDER BY i.db_schema_object_name DESC 
						OPTION    ( RECOMPILE );

            RAISERROR(N'check_id 71: Cascading updates or cascading deletes.', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary, more_info )
            SELECT  71 AS check_id, 
                    NULL AS index_sanity_id,
                    150 AS Priority,
                    N'Abnormal Psychology' AS findings_group,
                    N'Cascading Updates or Deletes' AS finding, 
                    [database_name] AS [Database Name],
                    N'https://www.brentozar.com/go/AbnormalPsychology' AS URL,
                    N'Foreign Key ' + foreign_key_name +
                    N' on ' + QUOTENAME(parent_object_name)  + N'(' + LTRIM(parent_fk_columns) + N')'
                        + N' referencing ' + QUOTENAME(referenced_object_name) + N'(' + LTRIM(referenced_fk_columns) + N')'
                        + N' has settings:'
                        + CASE [delete_referential_action_desc] WHEN N'NO_ACTION' THEN N'' ELSE N' ON DELETE ' +[delete_referential_action_desc] END
                        + CASE [update_referential_action_desc] WHEN N'NO_ACTION' THEN N'' ELSE N' ON UPDATE ' + [update_referential_action_desc] END
                            AS details, 
                    [fk].[database_name] 
                            AS index_definition, 
                    N'N/A' AS secret_columns,
                    N'N/A' AS index_usage_summary,
                    N'N/A' AS index_size_summary,
                    (SELECT TOP 1 more_info FROM #IndexSanity i WHERE i.object_id=fk.parent_object_id AND i.database_id = fk.database_id AND i.schema_name = fk.schema_name)
                        AS more_info
            FROM #ForeignKeys fk
            WHERE ([delete_referential_action_desc] <> N'NO_ACTION'
            OR [update_referential_action_desc] <> N'NO_ACTION')
			OPTION    ( RECOMPILE );


            RAISERROR(N'check_id 73: In-Memory OLTP', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
                    SELECT  73 AS check_id, 
                            i.index_sanity_id,
                            150 AS Priority,
                            N'Abnormal Psychology' AS findings_group,
                            N'In-Memory OLTP' AS finding,
                            [database_name] AS [Database Name], 
                            N'https://www.brentozar.com/go/AbnormalPsychology' AS URL,
                            i.db_schema_object_indexid AS details, 
                            i.index_definition,
                            i.secret_columns,
                            i.index_usage_summary,
                            ISNULL(sz.index_size_summary,'') AS index_size_summary
                    FROM    #IndexSanity AS i
                    JOIN #IndexSanitySize sz ON i.index_sanity_id = sz.index_sanity_id
                    WHERE i.is_in_memory_oltp = 1
					OPTION    ( RECOMPILE );

        RAISERROR(N'check_id 74: Identity column with unusual seed', 0,1) WITH NOWAIT;
            INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                            secret_columns, index_usage_summary, index_size_summary )
                    SELECT  74 AS check_id, 
                            i.index_sanity_id, 
                            200 AS Priority,
                            N'Abnormal Psychology' AS findings_group,
                            N'Identity Column Using a Negative Seed or Increment Other Than 1' AS finding,
                            [database_name] AS [Database Name],
                            N'https://www.brentozar.com/go/AbnormalPsychology' AS URL,
                            i.db_schema_object_name + N'.' +  QUOTENAME(ic.column_name)
                                + N' is an identity with type ' + ic.system_type_name 
                                + N', last value of ' 
                                    + ISNULL((CONVERT(NVARCHAR(256),CAST(ic.last_value AS DECIMAL(38,0)), 1)),N'NULL')
                                + N', seed of '
                                    + ISNULL((CONVERT(NVARCHAR(256),CAST(ic.seed_value AS DECIMAL(38,0)), 1)),N'NULL')
                                + N', increment of ' + CAST(ic.increment_value AS NVARCHAR(256)) 
                                + N', and range of ' +
                                    CASE ic.system_type_name WHEN 'int' THEN N'+/- 2,147,483,647'
                                        WHEN 'smallint' THEN N'+/- 32,768'
                                        WHEN 'tinyint' THEN N'0 to 255'
                                        ELSE 'unknown'
                                    END
                                    AS details,
                            i.index_definition,
                            secret_columns, 
                            ISNULL(i.index_usage_summary,''),
                            ISNULL(ip.index_size_summary,'')
                    FROM    #IndexSanity i
                    JOIN    #IndexColumns ic ON
                        i.object_id=ic.object_id
						AND i.database_id = ic.database_id
						AND i.schema_name = ic.schema_name
                        AND i.index_id IN (0,1) /* heaps and cx only */
                        AND ic.is_identity=1
                        AND ic.system_type_name IN ('tinyint', 'smallint', 'int')
                    JOIN    #IndexSanitySize ip ON i.index_sanity_id = ip.index_sanity_id
                    WHERE    i.index_id IN (1,0)
                        AND (ic.seed_value < 0 OR ic.increment_value <> 1)
                    ORDER BY finding, details DESC 
					OPTION    ( RECOMPILE );

        ----------------------------------------
        --Workaholics: Check_id 80-89
        ----------------------------------------

        RAISERROR(N'check_id 80: Most scanned indexes (index_usage_stats)', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )

        --Workaholics according to index_usage_stats
        --This isn't perfect: it mentions the number of scans present in a plan
        --A "scan" isn't necessarily a full scan, but hey, we gotta do the best with what we've got.
        --in the case of things like indexed views, the operator might be in the plan but never executed
        SELECT TOP 5 
            80 AS check_id,
            i.index_sanity_id AS index_sanity_id,
            200 AS Priority,
            N'Workaholics' AS findings_group,
            N'Scan-a-lots (index-usage-stats)' AS finding,
            [database_name] AS [Database Name],
            N'https://www.brentozar.com/go/Workaholics' AS URL,
            REPLACE(CONVERT( NVARCHAR(50),CAST(i.user_scans AS MONEY),1),'.00','')
                + N' scans against ' + i.db_schema_object_indexid
                + N'. Latest scan: ' + ISNULL(CAST(i.last_user_scan AS NVARCHAR(128)),'?') + N'. ' 
                + N'ScanFactor=' + CAST(((i.user_scans * iss.total_reserved_MB)/1000000.) AS NVARCHAR(256)) AS details,
            ISNULL(i.key_column_names_with_sort_order,'N/A') AS index_definition,
            ISNULL(i.secret_columns,'') AS secret_columns,
            i.index_usage_summary AS index_usage_summary,
            iss.index_size_summary AS index_size_summary
        FROM #IndexSanity i
        JOIN #IndexSanitySize iss ON i.index_sanity_id=iss.index_sanity_id
        WHERE ISNULL(i.user_scans,0) > 0
        ORDER BY  i.user_scans * iss.total_reserved_MB DESC
		OPTION    ( RECOMPILE );

        RAISERROR(N'check_id 81: Top recent accesses (op stats)', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, index_sanity_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
        --Workaholics according to index_operational_stats
        --This isn't perfect either: range_scan_count contains full scans, partial scans, even seeks in nested loop ops
        --But this can help bubble up some most-accessed tables 
        SELECT TOP 5 
            81 AS check_id,
            i.index_sanity_id AS index_sanity_id,
            200 AS Priority,
            N'Workaholics' AS findings_group,
            N'Top Recent Accesses (index-op-stats)' AS finding,
            [database_name] AS [Database Name],
            N'https://www.brentozar.com/go/Workaholics' AS URL,
            ISNULL(REPLACE(
                    CONVERT(NVARCHAR(50),CAST((iss.total_range_scan_count + iss.total_singleton_lookup_count) AS MONEY),1),
                    N'.00',N'') 
                + N' uses of ' + i.db_schema_object_indexid + N'. '
                + REPLACE(CONVERT(NVARCHAR(50), CAST(iss.total_range_scan_count AS MONEY),1),N'.00',N'') + N' scans or seeks. '
                + REPLACE(CONVERT(NVARCHAR(50), CAST(iss.total_singleton_lookup_count AS MONEY), 1),N'.00',N'') + N' singleton lookups. '
                + N'OpStatsFactor=' + CAST(((((iss.total_range_scan_count + iss.total_singleton_lookup_count) * iss.total_reserved_MB))/1000000.) AS VARCHAR(256)),'') AS details,
            ISNULL(i.key_column_names_with_sort_order,'N/A') AS index_definition,
            ISNULL(i.secret_columns,'') AS secret_columns,
            i.index_usage_summary AS index_usage_summary,
            iss.index_size_summary AS index_size_summary
        FROM #IndexSanity i
        JOIN #IndexSanitySize iss ON i.index_sanity_id=iss.index_sanity_id
        WHERE (ISNULL(iss.total_range_scan_count,0)  > 0 OR ISNULL(iss.total_singleton_lookup_count,0) > 0)
        ORDER BY ((iss.total_range_scan_count + iss.total_singleton_lookup_count) * iss.total_reserved_MB) DESC
		OPTION    ( RECOMPILE );



        RAISERROR(N'check_id 93: Statistics with filters', 0,1) WITH NOWAIT;
                INSERT    #BlitzIndexResults ( check_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
		SELECT  93 AS check_id, 
				200 AS Priority,
				'Functioning Statistaholics' AS findings_group,
				'Filter Fixation',
				s.database_name,
				'https://www.brentozar.com/go/stats' AS URL,
				'The statistic ' + QUOTENAME(s.statistics_name) +  ' is filtered on [' + s.filter_definition + ']. It could be part of a filtered index, or just a filtered statistic. This is purely informational.' AS details,
				 QUOTENAME(database_name) + '.' + QUOTENAME(s.schema_name) + '.' + QUOTENAME(s.table_name) + '.' + QUOTENAME(s.index_name) + '.' + QUOTENAME(s.statistics_name) + '.' + QUOTENAME(s.column_names) AS index_definition,
				'N/A' AS secret_columns,
				'N/A' AS index_usage_summary,
				'N/A' AS index_size_summary
		FROM #Statistics AS s
		WHERE s.has_filter = 1
		OPTION    ( RECOMPILE );


		RAISERROR(N'check_id 100: Computed Columns that are not Persisted.', 0,1) WITH NOWAIT;
        INSERT    #BlitzIndexResults ( check_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )
		SELECT  100 AS check_id, 
				200 AS Priority,
				'Cold Calculators' AS findings_group,
				'Definition Defeatists' AS finding,
				cc.database_name,
				'' AS URL,
				'The computed column ' + QUOTENAME(cc.column_name) + ' on ' + QUOTENAME(cc.schema_name) + '.' + QUOTENAME(cc.table_name) + ' is not persisted, which means it will be calculated when a query runs.' + 
				'You can change this with the following command, if the definition is deterministic: ALTER TABLE ' + QUOTENAME(cc.schema_name) + '.' + QUOTENAME(cc.table_name) + ' ALTER COLUMN ' + cc.column_name +
				' ADD PERSISTED'  AS details,
				cc.column_definition,
				'N/A' AS secret_columns,
				'N/A' AS index_usage_summary,
				'N/A' AS index_size_summary
		FROM #ComputedColumns AS cc
		WHERE cc.is_persisted = 0
		OPTION    ( RECOMPILE );

		RAISERROR(N'check_id 110: Temporal Tables.', 0,1) WITH NOWAIT;
        INSERT    #BlitzIndexResults ( check_id, Priority, findings_group, finding, [database_name], URL, details, index_definition,
                                               secret_columns, index_usage_summary, index_size_summary )

				SELECT  110 AS check_id, 
				200 AS Priority,
				'Abnormal Psychology' AS findings_group,
				'Temporal Tables',
				t.database_name,
				'' AS URL,
				'The table ' + QUOTENAME(t.schema_name) + '.' + QUOTENAME(t.table_name) + ' is a temporal table, with rows versioned in ' 
					+ QUOTENAME(t.history_schema_name) + '.' + QUOTENAME(t.history_table_name) + ' on History columns ' + QUOTENAME(t.start_column_name) + ' and ' + QUOTENAME(t.end_column_name) + '.'
				 AS details,
				'' AS index_definition,
				'N/A' AS secret_columns,
				'N/A' AS index_usage_summary,
				'N/A' AS index_size_summary
		FROM #TemporalTables AS t
		OPTION    ( RECOMPILE );




	END /* IF @Mode = 4 */



























 
        RAISERROR(N'Insert a row to help people find help', 0,1) WITH NOWAIT;
        IF DATEDIFF(MM, @VersionDate, GETDATE()) > 6
		BEGIN
            INSERT    #BlitzIndexResults ( Priority, check_id, findings_group, finding, URL, details, index_definition,
                                            index_usage_summary, index_size_summary )
            VALUES  ( -1, 0 , 
		           'Outdated sp_BlitzIndex', 'sp_BlitzIndex is Over 6 Months Old', 'http://FirstResponderKit.org/', 
                   'Fine wine gets better with age, but this ' + @ScriptVersionName + ' is more like bad cheese. Time to get a new one.',
                    @DaysUptimeInsertValue,N'',N''
                    );
        END;

        IF EXISTS(SELECT * FROM #BlitzIndexResults)
		BEGIN
            INSERT    #BlitzIndexResults ( Priority, check_id, findings_group, finding, URL, details, index_definition,
                                            index_usage_summary, index_size_summary )
            VALUES  ( -1, 0 , 
		            @ScriptVersionName,
                    CASE WHEN @GetAllDatabases = 1 THEN N'All Databases' ELSE N'Database ' + QUOTENAME(@DatabaseName) + N' as of ' + CONVERT(NVARCHAR(16),GETDATE(),121) END, 
                    N'From Your Community Volunteers' ,   N'http://FirstResponderKit.org' ,
                    @DaysUptimeInsertValue,N'',N''
                    );
        END;
        ELSE IF @Mode = 0 OR (@GetAllDatabases = 1 AND @Mode <> 4)
        BEGIN
            INSERT    #BlitzIndexResults ( Priority, check_id, findings_group, finding, URL, details, index_definition,
                                            index_usage_summary, index_size_summary )
            VALUES  ( -1, 0 , 
		            @ScriptVersionName,
                    CASE WHEN @GetAllDatabases = 1 THEN N'All Databases' ELSE N'Database ' + QUOTENAME(@DatabaseName) + N' as of ' + CONVERT(NVARCHAR(16),GETDATE(),121) END, 
                    N'From Your Community Volunteers' ,   N'http://FirstResponderKit.org' ,
                    @DaysUptimeInsertValue, N'',N''
                    );
            INSERT    #BlitzIndexResults ( Priority, check_id, findings_group, finding, URL, details, index_definition,
                                            index_usage_summary, index_size_summary )
            VALUES  ( 1, 0 , 
		           N'No Major Problems Found',
                   N'Nice Work!',
                   N'http://FirstResponderKit.org', 
                   N'Consider running with @Mode = 4 in individual databases (not all) for more detailed diagnostics.', 
                   N'The default Mode 0 only looks for very serious index issues.', 
                   @DaysUptimeInsertValue, N''
                    );

        END;
        ELSE
        BEGIN
            INSERT    #BlitzIndexResults ( Priority, check_id, findings_group, finding, URL, details, index_definition,
                                            index_usage_summary, index_size_summary )
            VALUES  ( -1, 0 , 
		            @ScriptVersionName,
                    CASE WHEN @GetAllDatabases = 1 THEN N'All Databases' ELSE N'Database ' + QUOTENAME(@DatabaseName) + N' as of ' + CONVERT(NVARCHAR(16),GETDATE(),121) END, 
                    N'From Your Community Volunteers' ,   N'http://FirstResponderKit.org' ,
                    @DaysUptimeInsertValue, N'',N''
                    );
            INSERT    #BlitzIndexResults ( Priority, check_id, findings_group, finding, URL, details, index_definition,
                                            index_usage_summary, index_size_summary )
            VALUES  ( 1, 0 , 
		           N'No Problems Found',
                   N'Nice job! Or more likely, you have a nearly empty database.',
                   N'http://FirstResponderKit.org', 'Time to go read some blog posts.', 
                   @DaysUptimeInsertValue, N'', N''
                    );

        END;

        RAISERROR(N'Returning results.', 0,1) WITH NOWAIT;
            
        /*Return results.*/
        IF (@Mode = 0)
        BEGIN
			IF(@OutputType <> 'NONE')
			BEGIN
				SELECT Priority, ISNULL(br.findings_group,N'') + 
						CASE WHEN ISNULL(br.finding,N'') <> N'' THEN N': ' ELSE N'' END
						+ br.finding AS [Finding], 
					br.[database_name] AS [Database Name],
					br.details AS [Details: schema.table.index(indexid)], 
					br.index_definition AS [Definition: [Property]] ColumnName {datatype maxbytes}], 
					ISNULL(br.secret_columns,'') AS [Secret Columns],          
					br.index_usage_summary AS [Usage], 
					br.index_size_summary AS [Size],
					COALESCE(br.more_info,sn.more_info,'') AS [More Info],
					br.URL, 
					COALESCE(br.create_tsql,ts.create_tsql,'') AS [Create TSQL]
				FROM #BlitzIndexResults br
				LEFT JOIN #IndexSanity sn ON 
					br.index_sanity_id=sn.index_sanity_id
				LEFT JOIN #IndexCreateTsql ts ON 
					br.index_sanity_id=ts.index_sanity_id
				ORDER BY br.Priority ASC, br.check_id ASC, br.blitz_result_id ASC, br.findings_group ASC
				OPTION (RECOMPILE);
			 END;

        END;
        ELSE IF (@Mode = 4)
			IF(@OutputType <> 'NONE')
		 	BEGIN	
				SELECT Priority, ISNULL(br.findings_group,N'') + 
						CASE WHEN ISNULL(br.finding,N'') <> N'' THEN N': ' ELSE N'' END
						+ br.finding AS [Finding], 
					br.[database_name] AS [Database Name],
					br.details AS [Details: schema.table.index(indexid)], 
					br.index_definition AS [Definition: [Property]] ColumnName {datatype maxbytes}], 
					ISNULL(br.secret_columns,'') AS [Secret Columns],          
					br.index_usage_summary AS [Usage], 
					br.index_size_summary AS [Size],
					COALESCE(br.more_info,sn.more_info,'') AS [More Info],
					br.URL, 
					COALESCE(br.create_tsql,ts.create_tsql,'') AS [Create TSQL]
				FROM #BlitzIndexResults br
				LEFT JOIN #IndexSanity sn ON 
					br.index_sanity_id=sn.index_sanity_id
				LEFT JOIN #IndexCreateTsql ts ON 
					br.index_sanity_id=ts.index_sanity_id
				ORDER BY br.Priority ASC, br.check_id ASC, br.blitz_result_id ASC, br.findings_group ASC
				OPTION (RECOMPILE);
			 END;

END /* End @Mode=0 or 4 (diagnose)*/

ELSE IF (@Mode=1) /*Summarize*/
    BEGIN
    --This mode is to give some overall stats on the database.
	 	IF(@OutputType <> 'NONE')
	 	BEGIN
			RAISERROR(N'@Mode=1, we are summarizing.', 0,1) WITH NOWAIT;

			SELECT DB_NAME(i.database_id) AS [Database Name],
				CAST((COUNT(*)) AS NVARCHAR(256)) AS [Number Objects],
				CAST(CAST(SUM(sz.total_reserved_MB)/
					1024. AS NUMERIC(29,1)) AS NVARCHAR(500)) AS [All GB],
				CAST(CAST(SUM(sz.total_reserved_LOB_MB)/
					1024. AS NUMERIC(29,1)) AS NVARCHAR(500)) AS [LOB GB],
				CAST(CAST(SUM(sz.total_reserved_row_overflow_MB)/
					1024. AS NUMERIC(29,1)) AS NVARCHAR(500)) AS [Row Overflow GB],
				CAST(SUM(CASE WHEN index_id=1 THEN 1 ELSE 0 END)AS NVARCHAR(50)) AS [Clustered Tables],
				CAST(SUM(CASE WHEN index_id=1 THEN sz.total_reserved_MB ELSE 0 END)
					/1024. AS NUMERIC(29,1)) AS [Clustered Tables GB],
				SUM(CASE WHEN index_id NOT IN (0,1) THEN 1 ELSE 0 END) AS [NC Indexes],
				CAST(SUM(CASE WHEN index_id NOT IN (0,1) THEN sz.total_reserved_MB ELSE 0 END)
					/1024. AS NUMERIC(29,1)) AS [NC Indexes GB],
				CASE WHEN SUM(CASE WHEN index_id NOT IN (0,1) THEN sz.total_reserved_MB ELSE 0 END)  > 0 THEN
					CAST(SUM(CASE WHEN index_id IN (0,1) THEN sz.total_reserved_MB ELSE 0 END)
						/ SUM(CASE WHEN index_id NOT IN (0,1) THEN sz.total_reserved_MB ELSE 0 END) AS NUMERIC(29,1)) 
					ELSE 0 END AS [ratio table: NC Indexes],
				SUM(CASE WHEN index_id=0 THEN 1 ELSE 0 END) AS [Heaps],
				CAST(SUM(CASE WHEN index_id=0 THEN sz.total_reserved_MB ELSE 0 END)
					/1024. AS NUMERIC(29,1)) AS [Heaps GB],
				SUM(CASE WHEN index_id IN (0,1) AND partition_key_column_name IS NOT NULL THEN 1 ELSE 0 END) AS [Partitioned Tables],
				SUM(CASE WHEN index_id NOT IN (0,1) AND  partition_key_column_name IS NOT NULL THEN 1 ELSE 0 END) AS [Partitioned NCs],
				CAST(SUM(CASE WHEN partition_key_column_name IS NOT NULL THEN sz.total_reserved_MB ELSE 0 END)/1024. AS NUMERIC(29,1)) AS [Partitioned GB],
				SUM(CASE WHEN filter_definition <> '' THEN 1 ELSE 0 END) AS [Filtered Indexes],
				SUM(CASE WHEN is_indexed_view=1 THEN 1 ELSE 0 END) AS [Indexed Views],
				MAX(total_rows) AS [Max Row Count],
				CAST(MAX(CASE WHEN index_id IN (0,1) THEN sz.total_reserved_MB ELSE 0 END)
					/1024. AS NUMERIC(29,1)) AS [Max Table GB],
				CAST(MAX(CASE WHEN index_id NOT IN (0,1) THEN sz.total_reserved_MB ELSE 0 END)
					/1024. AS NUMERIC(29,1)) AS [Max NC Index GB],
				SUM(CASE WHEN index_id IN (0,1) AND sz.total_reserved_MB > 1024 THEN 1 ELSE 0 END) AS [Count Tables > 1GB],
				SUM(CASE WHEN index_id IN (0,1) AND sz.total_reserved_MB > 10240 THEN 1 ELSE 0 END) AS [Count Tables > 10GB],
				SUM(CASE WHEN index_id IN (0,1) AND sz.total_reserved_MB > 102400 THEN 1 ELSE 0 END) AS [Count Tables > 100GB],    
				SUM(CASE WHEN index_id NOT IN (0,1) AND sz.total_reserved_MB > 1024 THEN 1 ELSE 0 END) AS [Count NCs > 1GB],
				SUM(CASE WHEN index_id NOT IN (0,1) AND sz.total_reserved_MB > 10240 THEN 1 ELSE 0 END) AS [Count NCs > 10GB],
				SUM(CASE WHEN index_id NOT IN (0,1) AND sz.total_reserved_MB > 102400 THEN 1 ELSE 0 END) AS [Count NCs > 100GB],
				MIN(create_date) AS [Oldest Create Date],
				MAX(create_date) AS [Most Recent Create Date],
				MAX(modify_date) AS [Most Recent Modify Date],
				1 AS [Display Order]
			FROM #IndexSanity AS i
			--left join here so we don't lose disabled nc indexes
			LEFT JOIN #IndexSanitySize AS sz 
				ON i.index_sanity_id=sz.index_sanity_id
			GROUP BY DB_NAME(i.database_id)	 
			UNION ALL
			SELECT  CASE WHEN @GetAllDatabases = 1 THEN N'All Databases' ELSE N'Database ' + N' as of ' + CONVERT(NVARCHAR(16),GETDATE(),121) END,        
					@ScriptVersionName,   
					N'From Your Community Volunteers' ,   
					N'http://FirstResponderKit.org' ,
					@DaysUptimeInsertValue,
					NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
					NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
					NULL,NULL,0 AS display_order
			ORDER BY [Display Order] ASC
			OPTION (RECOMPILE);
	  	END;
           
    END; /* End @Mode=1 (summarize)*/
    ELSE IF (@Mode=2) /*Index Detail*/
    BEGIN
        --This mode just spits out all the detail without filters.
        --This supports slicing AND dicing in Excel
        RAISERROR(N'@Mode=2, here''s the details on existing indexes.', 0,1) WITH NOWAIT;

		
		/* Checks if @OutputServerName is populated with a valid linked server, and that the database name specified is valid */
		DECLARE @ValidOutputServer BIT;
		DECLARE @ValidOutputLocation BIT;
		DECLARE @LinkedServerDBCheck NVARCHAR(2000);
		DECLARE @ValidLinkedServerDB INT;
		DECLARE @tmpdbchk TABLE (cnt INT);
		DECLARE @StringToExecute NVARCHAR(MAX);
		
		IF @OutputServerName IS NOT NULL
			BEGIN
				IF (SUBSTRING(@OutputTableName, 2, 1) = '#')
					BEGIN
						RAISERROR('Due to the nature of temporary tables, outputting to a linked server requires a permanent table.', 16, 0);
					END;
				ELSE IF EXISTS (SELECT server_id FROM sys.servers WHERE QUOTENAME([name]) = @OutputServerName)
					BEGIN
						SET @LinkedServerDBCheck = 'SELECT 1 WHERE EXISTS (SELECT * FROM '+@OutputServerName+'.master.sys.databases WHERE QUOTENAME([name]) = '''+@OutputDatabaseName+''')';
						INSERT INTO @tmpdbchk EXEC sys.sp_executesql @LinkedServerDBCheck;
						SET @ValidLinkedServerDB = (SELECT COUNT(*) FROM @tmpdbchk);
						IF (@ValidLinkedServerDB > 0)
							BEGIN
								SET @ValidOutputServer = 1;
								SET @ValidOutputLocation = 1;
							END;
						ELSE
							RAISERROR('The specified database was not found on the output server', 16, 0);
					END;
				ELSE
					BEGIN
						RAISERROR('The specified output server was not found', 16, 0);
					END;
			END;
		ELSE
			BEGIN
				IF (SUBSTRING(@OutputTableName, 2, 2) = '##')
					BEGIN
						SET @StringToExecute = N' IF (OBJECT_ID(''[tempdb].[dbo].@@@OutputTableName@@@'') IS NOT NULL) DROP TABLE @@@OutputTableName@@@';
						SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputTableName@@@', @OutputTableName); 
						EXEC(@StringToExecute);
						
						SET @OutputServerName = QUOTENAME(CAST(SERVERPROPERTY('ServerName') AS NVARCHAR(128)));
						SET @OutputDatabaseName = '[tempdb]';
						SET @OutputSchemaName = '[dbo]';
						SET @ValidOutputLocation = 1;
					END;
				ELSE IF (SUBSTRING(@OutputTableName, 2, 1) = '#')
					BEGIN
						RAISERROR('Due to the nature of Dymamic SQL, only global (i.e. double pound (##)) temp tables are supported for @OutputTableName', 16, 0);
					END;
				ELSE IF @OutputDatabaseName IS NOT NULL
					AND @OutputSchemaName IS NOT NULL
					AND @OutputTableName IS NOT NULL
					AND EXISTS ( SELECT *
						 FROM   sys.databases
						 WHERE  QUOTENAME([name]) = @OutputDatabaseName)
					BEGIN
						SET @ValidOutputLocation = 1;
						SET @OutputServerName = QUOTENAME(CAST(SERVERPROPERTY('ServerName') AS NVARCHAR(128)));
					END;
				ELSE IF @OutputDatabaseName IS NOT NULL
					AND @OutputSchemaName IS NOT NULL
					AND @OutputTableName IS NOT NULL
					AND NOT EXISTS ( SELECT *
						 FROM   sys.databases
						 WHERE  QUOTENAME([name]) = @OutputDatabaseName)
					BEGIN
						RAISERROR('The specified output database was not found on this server', 16, 0);
					END;
				ELSE
					BEGIN
						SET @ValidOutputLocation = 0; 
					END;
			END;
																										
        IF (@ValidOutputLocation = 0 AND @OutputType = 'NONE')
        BEGIN
            RAISERROR('Invalid output location and no output asked',12,1);
            RETURN;
        END;
																										
		/* @OutputTableName lets us export the results to a permanent table */
		DECLARE @RunID UNIQUEIDENTIFIER;
		SET @RunID = NEWID();
		
		IF (@ValidOutputLocation = 1 AND COALESCE(@OutputServerName, @OutputDatabaseName, @OutputSchemaName, @OutputTableName) IS NOT NULL)
			BEGIN
				DECLARE @TableExists BIT;
				DECLARE @SchemaExists BIT;
				SET @StringToExecute = 
					N'SET @SchemaExists = 0;
					SET @TableExists = 0;
					IF EXISTS(SELECT * FROM @@@OutputServerName@@@.@@@OutputDatabaseName@@@.INFORMATION_SCHEMA.SCHEMATA WHERE QUOTENAME(SCHEMA_NAME) = ''@@@OutputSchemaName@@@'') 
						SET @SchemaExists = 1
					IF EXISTS (SELECT * FROM @@@OutputServerName@@@.@@@OutputDatabaseName@@@.INFORMATION_SCHEMA.TABLES WHERE QUOTENAME(TABLE_SCHEMA) = ''@@@OutputSchemaName@@@'' AND QUOTENAME(TABLE_NAME) = ''@@@OutputTableName@@@'')
						SET @TableExists = 1';
	
				SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputServerName@@@', @OutputServerName);
				SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputDatabaseName@@@', @OutputDatabaseName);
				SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputSchemaName@@@', @OutputSchemaName); 
				SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputTableName@@@', @OutputTableName);
	
				EXEC sp_executesql @StringToExecute, N'@TableExists BIT OUTPUT, @SchemaExists BIT OUTPUT', @TableExists OUTPUT, @SchemaExists OUTPUT;
				
				IF @SchemaExists = 1
					BEGIN
						IF @TableExists = 0
							BEGIN
								SET @StringToExecute = 
									N'CREATE TABLE @@@OutputDatabaseName@@@.@@@OutputSchemaName@@@.@@@OutputTableName@@@ 
										(
											[id] INT IDENTITY(1,1) NOT NULL, 
											[run_id] UNIQUEIDENTIFIER,
											[run_datetime] DATETIME, 
											[server_name] NVARCHAR(128), 
											[database_name] NVARCHAR(128), 
											[schema_name] NVARCHAR(128), 
											[table_name] NVARCHAR(128), 
											[index_name] NVARCHAR(128),
                                            [Drop_Tsql] NVARCHAR(MAX),
                                            [Create_Tsql] NVARCHAR(MAX), 
											[index_id] INT, 
											[db_schema_object_indexid] NVARCHAR(500), 
											[object_type] NVARCHAR(15), 
											[index_definition] NVARCHAR(MAX), 
											[key_column_names_with_sort_order] NVARCHAR(MAX), 
											[count_key_columns] INT, 
											[include_column_names] NVARCHAR(MAX), 
											[count_included_columns] INT, 
											[secret_columns] NVARCHAR(MAX), 
											[count_secret_columns] INT, 
											[partition_key_column_name] NVARCHAR(MAX), 
											[filter_definition] NVARCHAR(MAX), 
											[is_indexed_view] BIT, 
											[is_primary_key] BIT, 
											[is_XML] BIT, 
											[is_spatial] BIT, 
											[is_NC_columnstore] BIT, 
											[is_CX_columnstore] BIT, 
											[is_in_memory_oltp] BIT, 
											[is_disabled] BIT, 
											[is_hypothetical] BIT, 
											[is_padded] BIT, 
											[fill_factor] INT, 
											[is_referenced_by_foreign_key] BIT,
											[last_user_seek] DATETIME, 
											[last_user_scan] DATETIME, 
											[last_user_lookup] DATETIME, 
											[last_user_update] DATETIME, 
											[total_reads] BIGINT, 
											[user_updates] BIGINT, 
											[reads_per_write] MONEY, 
											[index_usage_summary] NVARCHAR(200), 
											[total_singleton_lookup_count] BIGINT, 
											[total_range_scan_count] BIGINT, 
											[total_leaf_delete_count] BIGINT, 
											[total_leaf_update_count] BIGINT, 
											[index_op_stats] NVARCHAR(200), 
											[partition_count] INT, 
											[total_rows] BIGINT, 
											[total_reserved_MB] NUMERIC(29,2), 
											[total_reserved_LOB_MB] NUMERIC(29,2), 
											[total_reserved_row_overflow_MB] NUMERIC(29,2), 
											[index_size_summary] NVARCHAR(300), 
											[total_row_lock_count] BIGINT, 
											[total_row_lock_wait_count] BIGINT, 
											[total_row_lock_wait_in_ms] BIGINT, 
											[avg_row_lock_wait_in_ms] BIGINT, 
											[total_page_lock_count] BIGINT, 
											[total_page_lock_wait_count] BIGINT, 
											[total_page_lock_wait_in_ms] BIGINT, 
											[avg_page_lock_wait_in_ms] BIGINT, 
											[total_index_lock_promotion_attempt_count] BIGINT, 
											[total_index_lock_promotion_count] BIGINT, 
											[data_compression_desc] NVARCHAR(4000), 
						                    [page_latch_wait_count] BIGINT,
								            [page_latch_wait_in_ms] BIGINT,
								            [page_io_latch_wait_count] BIGINT,								
								            [page_io_latch_wait_in_ms] BIGINT,
											[create_date] DATETIME, 
											[modify_date] DATETIME, 
											[more_info] NVARCHAR(500),
											[display_order] INT,
											CONSTRAINT [PK_ID_@@@RunID@@@] PRIMARY KEY CLUSTERED ([id] ASC)
										);';
		
								SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputDatabaseName@@@', @OutputDatabaseName);
								SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputSchemaName@@@', @OutputSchemaName); 
								SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputTableName@@@', @OutputTableName); 
								SET @StringToExecute = REPLACE(@StringToExecute, '@@@RunID@@@', @RunID); 
								
								IF @ValidOutputServer = 1
									BEGIN
										SET @StringToExecute = REPLACE(@StringToExecute,'''','''''');
										EXEC('EXEC('''+@StringToExecute+''') AT ' + @OutputServerName);
									END;   
								ELSE
									BEGIN
										EXEC(@StringToExecute);
									END;
							END; /* @TableExists = 0 */
					
						SET @StringToExecute = 
							N'IF EXISTS(SELECT * FROM @@@OutputServerName@@@.@@@OutputDatabaseName@@@.INFORMATION_SCHEMA.SCHEMATA WHERE QUOTENAME(SCHEMA_NAME) = ''@@@OutputSchemaName@@@'') 
								AND NOT EXISTS (SELECT * FROM @@@OutputServerName@@@.@@@OutputDatabaseName@@@.INFORMATION_SCHEMA.TABLES WHERE QUOTENAME(TABLE_SCHEMA) = ''@@@OutputSchemaName@@@'' AND QUOTENAME(TABLE_NAME) = ''@@@OutputTableName@@@'')
								SET @TableExists = 0
							ELSE
								SET @TableExists = 1';
				
						SET @TableExists = NULL;
						SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputServerName@@@', @OutputServerName);
						SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputDatabaseName@@@', @OutputDatabaseName);
						SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputSchemaName@@@', @OutputSchemaName); 
						SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputTableName@@@', @OutputTableName); 
			
						EXEC sp_executesql @StringToExecute, N'@TableExists BIT OUTPUT', @TableExists OUTPUT;
						
						IF @TableExists = 1
							BEGIN
								SET @StringToExecute = 
									N'INSERT @@@OutputServerName@@@.@@@OutputDatabaseName@@@.@@@OutputSchemaName@@@.@@@OutputTableName@@@
										(
											[run_id], 
											[run_datetime], 
											[server_name], 
											[database_name], 
											[schema_name], 
											[table_name], 
											[index_name],
                                            [Drop_Tsql],
                                            [Create_Tsql], 
											[index_id], 
											[db_schema_object_indexid], 
											[object_type], 
											[index_definition], 
											[key_column_names_with_sort_order], 
											[count_key_columns], 
											[include_column_names], 
											[count_included_columns], 
											[secret_columns], 
											[count_secret_columns], 
											[partition_key_column_name], 
											[filter_definition], 
											[is_indexed_view], 
											[is_primary_key], 
											[is_XML], 
											[is_spatial], 
											[is_NC_columnstore], 
											[is_CX_columnstore], 
                                            [is_in_memory_oltp],
											[is_disabled], 
											[is_hypothetical], 
											[is_padded], 
											[fill_factor], 
											[is_referenced_by_foreign_key], 
											[last_user_seek], 
											[last_user_scan], 
											[last_user_lookup], 
											[last_user_update], 
											[total_reads], 
											[user_updates], 
											[reads_per_write], 
											[index_usage_summary], 
											[total_singleton_lookup_count],
											[total_range_scan_count],
											[total_leaf_delete_count],
											[total_leaf_update_count],
											[index_op_stats],
											[partition_count], 
											[total_rows], 
											[total_reserved_MB], 
											[total_reserved_LOB_MB], 
											[total_reserved_row_overflow_MB], 
											[index_size_summary], 
											[total_row_lock_count], 
											[total_row_lock_wait_count], 
											[total_row_lock_wait_in_ms], 
											[avg_row_lock_wait_in_ms], 
											[total_page_lock_count], 
											[total_page_lock_wait_count], 
											[total_page_lock_wait_in_ms], 
											[avg_page_lock_wait_in_ms], 
											[total_index_lock_promotion_attempt_count], 
											[total_index_lock_promotion_count], 
											[data_compression_desc], 
						                    [page_latch_wait_count],
								            [page_latch_wait_in_ms],
								            [page_io_latch_wait_count],								
								            [page_io_latch_wait_in_ms],
											[create_date], 
											[modify_date], 
											[more_info],
											[display_order]
										)
									SELECT ''@@@RunID@@@'',
										''@@@GETDATE@@@'',
										''@@@LocalServerName@@@'',
										-- Below should be a copy/paste of the real query
										-- Make sure all quotes are escaped
										i.[database_name] AS [Database Name], 
										i.[schema_name] AS [Schema Name], 
										i.[object_name] AS [Object Name], 
										ISNULL(i.index_name, '''') AS [Index Name],
                                        CASE 
						                    WHEN i.is_primary_key = 1 AND i.index_definition <> ''[HEAP]''
							                    THEN N''-ALTER TABLE '' + QUOTENAME(i.[database_name]) + N''.'' + QUOTENAME(i.[schema_name]) + N''.'' + QUOTENAME(i.[object_name]) +
							                         N'' DROP CONSTRAINT '' + QUOTENAME(i.index_name) + N'';''
						                    WHEN i.is_primary_key = 0 AND i.index_definition <> ''[HEAP]''
						                        THEN N''--DROP INDEX ''+ QUOTENAME(i.index_name) + N'' ON '' + QUOTENAME(i.[database_name]) + N''.'' +
							                         QUOTENAME(i.[schema_name]) + N''.'' + QUOTENAME(i.[object_name]) + N'';''
						                ELSE N''''
						                END AS [Drop TSQL],
					                    CASE 
						                    WHEN i.index_definition = ''[HEAP]'' THEN N''''
					                            ELSE N''--'' + ict.create_tsql END AS [Create TSQL],
										CAST(i.index_id AS NVARCHAR(10))AS [Index ID],
										db_schema_object_indexid AS [Details: schema.table.index(indexid)], 
										CASE    WHEN index_id IN ( 1, 0 ) THEN ''TABLE''
											ELSE ''NonClustered''
											END AS [Object Type], 
										LEFT(index_definition,4000) AS [Definition: [Property]] ColumnName {datatype maxbytes}],
										ISNULL(LTRIM(key_column_names_with_sort_order), '''') AS [Key Column Names With Sort],
										ISNULL(count_key_columns, 0) AS [Count Key Columns],
										ISNULL(include_column_names, '''') AS [Include Column Names], 
										ISNULL(count_included_columns,0) AS [Count Included Columns],
										ISNULL(secret_columns,'''') AS [Secret Column Names], 
										ISNULL(count_secret_columns,0) AS [Count Secret Columns],
										ISNULL(partition_key_column_name, '''') AS [Partition Key Column Name],
										ISNULL(filter_definition, '''') AS [Filter Definition], 
										is_indexed_view AS [Is Indexed View], 
										is_primary_key AS [Is Primary Key],
										is_XML AS [Is XML],
										is_spatial AS [Is Spatial],
										is_NC_columnstore AS [Is NC Columnstore],
										is_CX_columnstore AS [Is CX Columnstore],
										is_in_memory_oltp AS [Is In-Memory OLTP],
										is_disabled AS [Is Disabled], 
										is_hypothetical AS [Is Hypothetical],
										is_padded AS [Is Padded], 
										fill_factor AS [Fill Factor], 
										is_referenced_by_foreign_key AS [Is Reference by Foreign Key], 
										last_user_seek AS [Last User Seek], 
										last_user_scan AS [Last User Scan], 
										last_user_lookup AS [Last User Lookup],
										last_user_update AS [Last User Update], 
										total_reads AS [Total Reads], 
										user_updates AS [User Updates], 
										reads_per_write AS [Reads Per Write], 
										index_usage_summary AS [Index Usage], 
										sz.total_singleton_lookup_count AS [Singleton Lookups],
										sz.total_range_scan_count AS [Range Scans],
										sz.total_leaf_delete_count AS [Leaf Deletes],
										sz.total_leaf_update_count AS [Leaf Updates],
										sz.index_op_stats AS [Index Op Stats],
										sz.partition_count AS [Partition Count],
										sz.total_rows AS [Rows], 
										sz.total_reserved_MB AS [Reserved MB], 
										sz.total_reserved_LOB_MB AS [Reserved LOB MB], 
										sz.total_reserved_row_overflow_MB AS [Reserved Row Overflow MB],
										sz.index_size_summary AS [Index Size], 
										sz.total_row_lock_count AS [Row Lock Count],
										sz.total_row_lock_wait_count AS [Row Lock Wait Count],
										sz.total_row_lock_wait_in_ms AS [Row Lock Wait ms],
										sz.avg_row_lock_wait_in_ms AS [Avg Row Lock Wait ms],
										sz.total_page_lock_count AS [Page Lock Count],
										sz.total_page_lock_wait_count AS [Page Lock Wait Count],
										sz.total_page_lock_wait_in_ms AS [Page Lock Wait ms],
										sz.avg_page_lock_wait_in_ms AS [Avg Page Lock Wait ms],
										sz.total_index_lock_promotion_attempt_count AS [Lock Escalation Attempts],
										sz.total_index_lock_promotion_count AS [Lock Escalations],
										sz.data_compression_desc AS [Data Compression],
						                sz.page_latch_wait_count,
								        sz.page_latch_wait_in_ms,
								        sz.page_io_latch_wait_count,								
								        sz.page_io_latch_wait_in_ms,
										i.create_date AS [Create Date],
										i.modify_date AS [Modify Date],
										more_info AS [More Info],
										1 AS [Display Order]
									FROM #IndexSanity AS i
									LEFT JOIN #IndexSanitySize AS sz ON i.index_sanity_id = sz.index_sanity_id
                                    LEFT JOIN #IndexCreateTsql AS ict  ON i.index_sanity_id = ict.index_sanity_id
									ORDER BY [Database Name], [Schema Name], [Object Name], [Index ID]
									OPTION (RECOMPILE);';
	
								SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputServerName@@@', @OutputServerName);
								SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputDatabaseName@@@', @OutputDatabaseName);
								SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputSchemaName@@@', @OutputSchemaName); 
								SET @StringToExecute = REPLACE(@StringToExecute, '@@@OutputTableName@@@', @OutputTableName); 
								SET @StringToExecute = REPLACE(@StringToExecute, '@@@RunID@@@', @RunID);
								SET @StringToExecute = REPLACE(@StringToExecute, '@@@GETDATE@@@', GETDATE());
								SET @StringToExecute = REPLACE(@StringToExecute, '@@@LocalServerName@@@', CAST(SERVERPROPERTY('ServerName') AS NVARCHAR(128)));
								EXEC(@StringToExecute);
							END; /* @TableExists = 1 */
						ELSE
							RAISERROR('Creation of the output table failed.', 16, 0);
					END; /* @TableExists = 0 */
				ELSE
					RAISERROR (N'Invalid schema name, data could not be saved.', 16, 0);
			END; /* @ValidOutputLocation = 1 */
		ELSE
	
		IF(@OutputType <> 'NONE')
		BEGIN
			SELECT  i.[database_name] AS [Database Name], 
					i.[schema_name] AS [Schema Name], 
					i.[object_name] AS [Object Name], 
					ISNULL(i.index_name, '') AS [Index Name],
					CAST(i.index_id AS NVARCHAR(10))AS [Index ID],
					db_schema_object_indexid AS [Details: schema.table.index(indexid)], 
					CASE    WHEN index_id IN ( 1, 0 ) THEN 'TABLE'
						ELSE 'NonClustered'
						END AS [Object Type], 
					index_definition AS [Definition: [Property]] ColumnName {datatype maxbytes}],
					ISNULL(LTRIM(key_column_names_with_sort_order), '') AS [Key Column Names With Sort],
					ISNULL(count_key_columns, 0) AS [Count Key Columns],
					ISNULL(include_column_names, '') AS [Include Column Names], 
					ISNULL(count_included_columns,0) AS [Count Included Columns],
					ISNULL(secret_columns,'') AS [Secret Column Names], 
					ISNULL(count_secret_columns,0) AS [Count Secret Columns],
					ISNULL(partition_key_column_name, '') AS [Partition Key Column Name],
					ISNULL(filter_definition, '') AS [Filter Definition], 
					is_indexed_view AS [Is Indexed View], 
					is_primary_key AS [Is Primary Key],
					is_XML AS [Is XML],
					is_spatial AS [Is Spatial],
					is_NC_columnstore AS [Is NC Columnstore],
					is_CX_columnstore AS [Is CX Columnstore],
					is_in_memory_oltp AS [Is In-Memory OLTP],
					is_disabled AS [Is Disabled], 
					is_hypothetical AS [Is Hypothetical],
					is_padded AS [Is Padded], 
					fill_factor AS [Fill Factor], 
					is_referenced_by_foreign_key AS [Is Reference by Foreign Key], 
					last_user_seek AS [Last User Seek], 
					last_user_scan AS [Last User Scan], 
					last_user_lookup AS [Last User Lookup],
					last_user_update AS [Last User Update], 
					total_reads AS [Total Reads], 
					user_updates AS [User Updates], 
					reads_per_write AS [Reads Per Write], 
					index_usage_summary AS [Index Usage], 
					sz.total_singleton_lookup_count AS [Singleton Lookups],
					sz.total_range_scan_count AS [Range Scans],
					sz.total_leaf_delete_count AS [Leaf Deletes],
					sz.total_leaf_update_count AS [Leaf Updates],
					sz.index_op_stats AS [Index Op Stats],
					sz.partition_count AS [Partition Count],
					sz.total_rows AS [Rows], 
					sz.total_reserved_MB AS [Reserved MB], 
					sz.total_reserved_LOB_MB AS [Reserved LOB MB], 
					sz.total_reserved_row_overflow_MB AS [Reserved Row Overflow MB],
					sz.index_size_summary AS [Index Size], 
					sz.total_row_lock_count AS [Row Lock Count],
					sz.total_row_lock_wait_count AS [Row Lock Wait Count],
					sz.total_row_lock_wait_in_ms AS [Row Lock Wait ms],
					sz.avg_row_lock_wait_in_ms AS [Avg Row Lock Wait ms],
					sz.total_page_lock_count AS [Page Lock Count],
					sz.total_page_lock_wait_count AS [Page Lock Wait Count],
					sz.total_page_lock_wait_in_ms AS [Page Lock Wait ms],
					sz.avg_page_lock_wait_in_ms AS [Avg Page Lock Wait ms],
					sz.total_index_lock_promotion_attempt_count AS [Lock Escalation Attempts],
					sz.total_index_lock_promotion_count AS [Lock Escalations],
					sz.page_latch_wait_count AS [Page Latch Wait Count],
					sz.page_latch_wait_in_ms AS [Page Latch Wait ms],
					sz.page_io_latch_wait_count AS [Page IO Latch Wait Count],								
					sz.page_io_latch_wait_in_ms as [Page IO Latch Wait ms],
                    sz.total_forwarded_fetch_count AS [Forwarded Fetches],
					sz.data_compression_desc AS [Data Compression],
					i.create_date AS [Create Date],
					i.modify_date AS [Modify Date],
					more_info AS [More Info],
                    CASE 
						 WHEN i.is_primary_key = 1 AND i.index_definition <> '[HEAP]'
							THEN N'--ALTER TABLE ' + QUOTENAME(i.[database_name]) + N'.' + QUOTENAME(i.[schema_name]) + N'.' + QUOTENAME(i.[object_name])
							     + N' DROP CONSTRAINT ' + QUOTENAME(i.index_name) + N';'
						 WHEN i.is_primary_key = 0 AND i.index_definition <> '[HEAP]'
						     THEN N'--DROP INDEX '+ QUOTENAME(i.index_name) + N' ON ' + QUOTENAME(i.[database_name]) + N'.' + 
							     QUOTENAME(i.[schema_name]) + N'.' + QUOTENAME(i.[object_name]) + N';'
						 ELSE N''
						 END AS [Drop TSQL],
					CASE 
						WHEN i.index_definition = '[HEAP]' THEN N''
					    ELSE N'--' + ict.create_tsql END AS [Create TSQL], 
					1 AS [Display Order]
			FROM    #IndexSanity AS i --left join here so we don't lose disabled nc indexes
					LEFT JOIN #IndexSanitySize AS sz ON i.index_sanity_id = sz.index_sanity_id
                    LEFT JOIN #IndexCreateTsql AS ict ON i.index_sanity_id = ict.index_sanity_id
			ORDER BY CASE WHEN @SortDirection = 'desc' THEN
						CASE WHEN @SortOrder = N'rows' THEN sz.total_rows
							WHEN @SortOrder = N'reserved_mb' THEN sz.total_reserved_MB
							WHEN @SortOrder = N'size' THEN sz.total_reserved_MB
							WHEN @SortOrder = N'reserved_lob_mb' THEN sz.total_reserved_LOB_MB
							WHEN @SortOrder = N'lob' THEN sz.total_reserved_LOB_MB
							WHEN @SortOrder = N'total_row_lock_wait_in_ms' THEN COALESCE(sz.total_row_lock_wait_in_ms,0)
							WHEN @SortOrder = N'total_page_lock_wait_in_ms' THEN COALESCE(sz.total_page_lock_wait_in_ms,0)
							WHEN @SortOrder = N'lock_time' THEN (COALESCE(sz.total_row_lock_wait_in_ms,0) + COALESCE(sz.total_page_lock_wait_in_ms,0))
							WHEN @SortOrder = N'total_reads' THEN total_reads
							WHEN @SortOrder = N'reads' THEN total_reads
							WHEN @SortOrder = N'user_updates' THEN user_updates
							WHEN @SortOrder = N'writes' THEN user_updates
							WHEN @SortOrder = N'reads_per_write' THEN reads_per_write
							WHEN @SortOrder = N'ratio' THEN reads_per_write
							WHEN @SortOrder = N'forward_fetches' THEN sz.total_forwarded_fetch_count 
							WHEN @SortOrder = N'fetches' THEN sz.total_forwarded_fetch_count 
							ELSE NULL END
						ELSE 1 END
						DESC, /* Shout out to DHutmacher */
					CASE WHEN @SortDirection = 'asc' THEN
						CASE WHEN @SortOrder = N'rows' THEN sz.total_rows
							WHEN @SortOrder = N'reserved_mb' THEN sz.total_reserved_MB
							WHEN @SortOrder = N'size' THEN sz.total_reserved_MB
							WHEN @SortOrder = N'reserved_lob_mb' THEN sz.total_reserved_LOB_MB
							WHEN @SortOrder = N'lob' THEN sz.total_reserved_LOB_MB
							WHEN @SortOrder = N'total_row_lock_wait_in_ms' THEN COALESCE(sz.total_row_lock_wait_in_ms,0)
							WHEN @SortOrder = N'total_page_lock_wait_in_ms' THEN COALESCE(sz.total_page_lock_wait_in_ms,0)
							WHEN @SortOrder = N'lock_time' THEN (COALESCE(sz.total_row_lock_wait_in_ms,0) + COALESCE(sz.total_page_lock_wait_in_ms,0))
							WHEN @SortOrder = N'total_reads' THEN total_reads
							WHEN @SortOrder = N'reads' THEN total_reads
							WHEN @SortOrder = N'user_updates' THEN user_updates
							WHEN @SortOrder = N'writes' THEN user_updates
							WHEN @SortOrder = N'reads_per_write' THEN reads_per_write
							WHEN @SortOrder = N'ratio' THEN reads_per_write
							WHEN @SortOrder = N'forward_fetches' THEN sz.total_forwarded_fetch_count 
							WHEN @SortOrder = N'fetches' THEN sz.total_forwarded_fetch_count 
							ELSE NULL END
						ELSE 1 END
						ASC,
				i.[database_name], [Schema Name], [Object Name], [Index ID]
			OPTION (RECOMPILE);
  		END;

    END; /* End @Mode=2 (index detail)*/
    ELSE IF (@Mode=3) /*Missing index Detail*/
    BEGIN
		IF(@OutputType <> 'NONE')
		BEGIN;
			WITH create_date AS (
						SELECT i.database_id,
							   i.schema_name,
							   i.[object_id], 
							   ISNULL(NULLIF(MAX(DATEDIFF(DAY, i.create_date, SYSDATETIME())), 0), 1) AS create_days
						FROM #IndexSanity AS i
						GROUP BY i.database_id, i.schema_name, i.object_id
						)
			SELECT 
				mi.database_name AS [Database Name], 
				mi.[schema_name] AS [Schema], 
				mi.table_name AS [Table], 
				CAST((mi.magic_benefit_number / CASE WHEN cd.create_days < @DaysUptime THEN cd.create_days ELSE @DaysUptime END) AS BIGINT)
					AS [Magic Benefit Number], 
				mi.missing_index_details AS [Missing Index Details], 
				mi.avg_total_user_cost AS [Avg Query Cost], 
				mi.avg_user_impact AS [Est Index Improvement], 
				mi.user_seeks AS [Seeks], 
				mi.user_scans AS [Scans],
				mi.unique_compiles AS [Compiles],
				mi.equality_columns_with_data_type AS [Equality Columns],
				mi.inequality_columns_with_data_type AS [Inequality Columns],
				mi.included_columns_with_data_type AS [Included Columns], 
				mi.index_estimated_impact AS [Estimated Impact], 
				mi.create_tsql AS [Create TSQL], 
				mi.more_info AS [More Info],
				1 AS [Display Order],
				mi.is_low,
				mi.sample_query_plan AS [Sample Query Plan]
			FROM #MissingIndexes AS mi
			LEFT JOIN create_date AS cd
			ON mi.[object_id] =  cd.object_id 
			AND mi.database_id = cd.database_id
			AND mi.schema_name = cd.schema_name
			/* Minimum benefit threshold = 100k/day of uptime OR since table creation date, whichever is lower*/
			WHERE @ShowAllMissingIndexRequests=1 
            OR (mi.magic_benefit_number / CASE WHEN cd.create_days < @DaysUptime THEN cd.create_days ELSE @DaysUptime END) >= 100000
			UNION ALL
			SELECT               
				@ScriptVersionName,   
				N'From Your Community Volunteers' ,   
				N'http://FirstResponderKit.org' ,
				100000000000,
				@DaysUptimeInsertValue,
				NULL,NULL,NULL,NULL,NULL,NULL,NULL,
				NULL, NULL, NULL, NULL, 0 AS [Display Order], NULL AS is_low, NULL
			ORDER BY [Display Order] ASC, [Magic Benefit Number] DESC
			OPTION (RECOMPILE);
	  	END;

	IF  (@BringThePain = 1
	AND @DatabaseName IS NOT NULL
	AND @GetAllDatabases = 0)

	BEGIN

		EXEC sp_BlitzCache @SortOrder = 'sp_BlitzIndex', @DatabaseName = @DatabaseName, @BringThePain = 1, @QueryFilter = 'statement', @HideSummary = 1;
	                              
	END;


    END; /* End @Mode=3 (index detail)*/

END TRY

BEGIN CATCH
        RAISERROR (N'Failure analyzing temp tables.', 0,1) WITH NOWAIT;

        SELECT  @msg = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();

        RAISERROR (@msg, 
               @ErrorSeverity, 
               @ErrorState 
               );
        
        WHILE @@trancount > 0 
            ROLLBACK;

        RETURN;
    END CATCH;
GO


/****** Object:  StoredProcedure [dba].[sp_BlitzQueryStore]    Script Date: 2/24/2021 6:49:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dba].[sp_BlitzQueryStore]
    @Help BIT = 0,
    @DatabaseName NVARCHAR(128) = NULL ,
    @Top INT = 3,
	@StartDate DATETIME2 = NULL,
	@EndDate DATETIME2 = NULL,
    @MinimumExecutionCount INT = NULL,
    @DurationFilter DECIMAL(38,4) = NULL ,
    @StoredProcName NVARCHAR(128) = NULL,
	@Failed BIT = 0,
	@PlanIdFilter INT = NULL,
	@QueryIdFilter INT = NULL,
    @ExportToExcel BIT = 0,
    @HideSummary BIT = 0 ,
	@SkipXML BIT = 0,
	@Debug BIT = 0,
	@ExpertMode BIT = 0,
	@Version     VARCHAR(30) = NULL OUTPUT,
	@VersionDate DATETIME = NULL OUTPUT,
    @VersionCheckMode BIT = 0
WITH RECOMPILE
AS
BEGIN /*First BEGIN*/

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT @Version = '8.01', @VersionDate = '20210222';
IF(@VersionCheckMode = 1)
BEGIN
	RETURN;
END;


DECLARE /*Variables for the variable Gods*/
		@msg NVARCHAR(MAX) = N'', --Used to format RAISERROR messages in some places
		@sql_select NVARCHAR(MAX) = N'', --Used to hold SELECT statements for dynamic SQL
		@sql_where NVARCHAR(MAX) = N'', -- Used to hold WHERE clause for dynamic SQL
		@duration_filter_ms DECIMAL(38,4) = (@DurationFilter * 1000.), --We accept Duration in seconds, but we filter in milliseconds (this is grandfathered from sp_BlitzCache)
		@execution_threshold INT = 1000, --Threshold at which we consider a query to be frequently executed
        @ctp_threshold_pct TINYINT = 10, --Percentage of CTFP at which we consider a query to be near parallel
        @long_running_query_warning_seconds BIGINT = 300 * 1000 ,--Number of seconds (converted to milliseconds) at which a query is considered long running
		@memory_grant_warning_percent INT = 10,--Percent of memory grant used compared to what's granted; used to trigger unused memory grant warning
		@ctp INT,--Holds the CTFP value for the server
		@min_memory_per_query INT,--Holds the server configuration value for min memory per query
		@cr NVARCHAR(1) = NCHAR(13),--Special character
		@lf NVARCHAR(1) = NCHAR(10),--Special character
		@tab NVARCHAR(1) = NCHAR(9),--Special character
		@error_severity INT,--Holds error info for try/catch blocks
		@error_state INT,--Holds error info for try/catch blocks
		@sp_params NVARCHAR(MAX) = N'@sp_Top INT, @sp_StartDate DATETIME2, @sp_EndDate DATETIME2, @sp_MinimumExecutionCount INT, @sp_MinDuration INT, @sp_StoredProcName NVARCHAR(128), @sp_PlanIdFilter INT, @sp_QueryIdFilter INT',--Holds parameters used in dynamic SQL
		@is_azure_db BIT = 0, --Are we using Azure? I'm not. You might be. That's cool.
		@compatibility_level TINYINT = 0, --Some functionality (T-SQL) isn't available in lower compat levels. We can use this to weed out those issues as we go.
		@log_size_mb DECIMAL(38,2) = 0,
		@avg_tempdb_data_file DECIMAL(38,2) = 0;

/*Grabs CTFP setting*/
SELECT  @ctp = NULLIF(CAST(value AS INT), 0)
FROM    sys.configurations
WHERE   name = N'cost threshold for parallelism'
OPTION (RECOMPILE);

/*Grabs min query memory setting*/
SELECT @min_memory_per_query = CONVERT(INT, c.value)
FROM   sys.configurations AS c
WHERE  c.name = N'min memory per query (KB)'
OPTION (RECOMPILE);

/*Check if this is Azure first*/
IF (SELECT CONVERT(NVARCHAR(128), SERVERPROPERTY ('EDITION'))) <> 'SQL Azure'
    BEGIN 
        /*Grabs log size for datbase*/
        SELECT @log_size_mb = AVG(((mf.size * 8) / 1024.))
        FROM sys.master_files AS mf
        WHERE mf.database_id = DB_ID(@DatabaseName)
        AND mf.type_desc = 'LOG';
        
        /*Grab avg tempdb file size*/
        SELECT @avg_tempdb_data_file = AVG(((mf.size * 8) / 1024.))
        FROM sys.master_files AS mf
        WHERE mf.database_id = DB_ID('tempdb')
        AND mf.type_desc = 'ROWS';
    END;

/*Help section*/

IF @Help = 1
	BEGIN
	
	SELECT N'You have requested assistance. It will arrive as soon as humanly possible.' AS [Take four red capsules, help is on the way];

	PRINT N'
	sp_BlitzQueryStore from http://FirstResponderKit.org
		
	This script displays your most resource-intensive queries from the Query Store,
	and points to ways you can tune these queries to make them faster.
	
	
	To learn more, visit http://FirstResponderKit.org where you can download new
	versions for free, watch training videos on how it works, get more info on
	the findings, contribute your own code, and more.
	
	Known limitations of this version:
	 - This query will not run on SQL Server versions less than 2016.
	 - This query will not run on Azure Databases with compatibility less than 130.
	 - This query will not run on Azure Data Warehouse.

	Unknown limitations of this version:
	 - Could be tickling
	
	
	MIT License
	
	Copyright (c) 2021 Brent Ozar Unlimited
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
	';
	RETURN;

END;

/*Making sure your version is copasetic*/
IF  ( (SELECT CONVERT(NVARCHAR(128), SERVERPROPERTY ('EDITION'))) = 'SQL Azure' )
	BEGIN
		SET @is_azure_db = 1;

		IF	(	(SELECT SERVERPROPERTY ('ENGINEEDITION')) NOT IN (5,8)
			OR	(SELECT [compatibility_level] FROM sys.databases WHERE [name] = DB_NAME()) < 130 
			)
		BEGIN
			SELECT @msg = N'Sorry, sp_BlitzQueryStore doesn''t work on Azure Data Warehouse, or Azure Databases with DB compatibility < 130.' + REPLICATE(CHAR(13), 7933);
			PRINT @msg;
			RETURN;
		END;
	END;
ELSE IF  ( (SELECT PARSENAME(CONVERT(NVARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')), 4) ) < 13 )
	BEGIN
		SELECT @msg = N'Sorry, sp_BlitzQueryStore doesn''t work on versions of SQL prior to 2016.' + REPLICATE(CHAR(13), 7933);
		PRINT @msg;
		RETURN;
	END;

/*Making sure at least one database uses QS*/
IF  (	SELECT COUNT(*)
		FROM sys.databases AS d
		WHERE d.is_query_store_on = 1
		AND d.user_access_desc='MULTI_USER'
		AND d.state_desc = 'ONLINE'
		AND d.name NOT IN ('master', 'model', 'msdb', 'tempdb', '32767') 
		AND d.is_distributor = 0 ) = 0
	BEGIN
		SELECT @msg = N'You don''t currently have any databases with Query Store enabled.' + REPLICATE(CHAR(13), 7933);
		PRINT @msg;
		RETURN;
	END;
									
/*Making sure your databases are using QDS.*/
RAISERROR('Checking database validity', 0, 1) WITH NOWAIT;

IF (@is_azure_db = 1)
	SET @DatabaseName = DB_NAME();
ELSE
BEGIN	

	/*If we're on Azure we don't need to check all this @DatabaseName stuff...*/

	SET @DatabaseName = LTRIM(RTRIM(@DatabaseName));

	/*Did you set @DatabaseName?*/
	RAISERROR('Making sure [%s] isn''t NULL', 0, 1, @DatabaseName) WITH	NOWAIT;
	IF (@DatabaseName IS NULL)
	BEGIN
		RAISERROR('@DatabaseName cannot be NULL', 0, 1) WITH NOWAIT;
		RETURN;
	END;

	/*Does the database exist?*/
	RAISERROR('Making sure [%s] exists', 0, 1, @DatabaseName) WITH NOWAIT;
	IF ((DB_ID(@DatabaseName)) IS NULL)
	BEGIN
		RAISERROR('The @DatabaseName you specified ([%s]) does not exist. Please check the name and try again.', 0, 1, @DatabaseName) WITH	NOWAIT;
		RETURN;
	END;

	/*Is it online?*/
	RAISERROR('Making sure [%s] is online', 0, 1, @DatabaseName) WITH NOWAIT;
	IF (DATABASEPROPERTYEX(@DatabaseName, 'Collation')) IS NULL
	BEGIN
		RAISERROR('The @DatabaseName you specified ([%s]) is not readable. Please check the name and try again. Better yet, check your server.', 0, 1, @DatabaseName);
		RETURN;
	END;
END;

/*Does it have Query Store enabled?*/
RAISERROR('Making sure [%s] has Query Store enabled', 0, 1, @DatabaseName) WITH NOWAIT;
IF 	

	( SELECT [d].[name]
		FROM [sys].[databases] AS d
		WHERE [d].[is_query_store_on] = 1
		AND [d].[user_access_desc]='MULTI_USER'
		AND [d].[state_desc] = 'ONLINE'
		AND [d].[database_id] = (SELECT database_id FROM sys.databases WHERE name = @DatabaseName)
	) IS NULL
BEGIN
	RAISERROR('The @DatabaseName you specified ([%s]) does not have the Query Store enabled. Please check the name or settings, and try again.', 0, 1, @DatabaseName) WITH	NOWAIT;
	RETURN;
END;

/*Check database compat level*/

RAISERROR('Checking database compatibility level', 0, 1) WITH NOWAIT;

SELECT @compatibility_level = d.compatibility_level
FROM sys.databases AS d
WHERE d.name = @DatabaseName;

RAISERROR('The @DatabaseName you specified ([%s])is running in compatibility level ([%d]).', 0, 1, @DatabaseName, @compatibility_level) WITH NOWAIT;


/*Making sure top is set to something if NULL*/
IF ( @Top IS NULL )
   BEGIN
       SET @Top = 3;
   END;

/*
This section determines if you have the Query Store wait stats DMV
*/

RAISERROR('Checking for query_store_wait_stats', 0, 1) WITH NOWAIT;

DECLARE @ws_out INT,
		@waitstats BIT,
		@ws_sql NVARCHAR(MAX) = N'SELECT @i_out = COUNT(*) FROM ' + QUOTENAME(@DatabaseName) + N'.sys.all_objects WHERE name = ''query_store_wait_stats'' OPTION (RECOMPILE);',
		@ws_params NVARCHAR(MAX) = N'@i_out INT OUTPUT';

EXEC sys.sp_executesql @ws_sql, @ws_params, @i_out = @ws_out OUTPUT;

SELECT @waitstats = CASE @ws_out WHEN 0 THEN 0 ELSE 1 END;

SET @msg = N'Wait stats DMV ' + CASE @waitstats 
									WHEN 0 THEN N' does not exist, skipping.'
									WHEN 1 THEN N' exists, will analyze.'
							   END;
RAISERROR(@msg, 0, 1) WITH NOWAIT;

/*
This section determines if you have some additional columns present in 2017, in case they get back ported.
*/

RAISERROR('Checking for new columns in query_store_runtime_stats', 0, 1) WITH NOWAIT;

DECLARE @nc_out INT,
		@new_columns BIT,
		@nc_sql NVARCHAR(MAX) = N'SELECT @i_out = COUNT(*) 
							      FROM ' + QUOTENAME(@DatabaseName) + N'.sys.all_columns AS ac
								  WHERE OBJECT_NAME(object_id) = ''query_store_runtime_stats''
								  AND ac.name IN (
								  ''avg_num_physical_io_reads'',
								  ''last_num_physical_io_reads'',
								  ''min_num_physical_io_reads'',
								  ''max_num_physical_io_reads'',
								  ''avg_log_bytes_used'',
								  ''last_log_bytes_used'',
								  ''min_log_bytes_used'',
								  ''max_log_bytes_used'',
								  ''avg_tempdb_space_used'',
								  ''last_tempdb_space_used'',
								  ''min_tempdb_space_used'',
								  ''max_tempdb_space_used''
								  ) OPTION (RECOMPILE);',
		@nc_params NVARCHAR(MAX) = N'@i_out INT OUTPUT';

EXEC sys.sp_executesql @nc_sql, @ws_params, @i_out = @nc_out OUTPUT;

SELECT @new_columns = CASE @nc_out WHEN 12 THEN 1 ELSE 0 END;

SET @msg = N'New query_store_runtime_stats columns ' + CASE @new_columns 
									WHEN 0 THEN N' do not exist, skipping.'
									WHEN 1 THEN N' exist, will analyze.'
							   END;
RAISERROR(@msg, 0, 1) WITH NOWAIT;

 
/*
These are the temp tables we use
*/


/*
This one holds the grouped data that helps use figure out which periods to examine
*/

RAISERROR(N'Creating temp tables', 0, 1) WITH NOWAIT;

DROP TABLE IF EXISTS #grouped_interval;

CREATE TABLE #grouped_interval
(
    flat_date DATE NULL,
    start_range DATETIME NULL,
    end_range DATETIME NULL,
    total_avg_duration_ms DECIMAL(38, 2) NULL,
    total_avg_cpu_time_ms DECIMAL(38, 2) NULL,
    total_avg_logical_io_reads_mb DECIMAL(38, 2) NULL,
    total_avg_physical_io_reads_mb DECIMAL(38, 2) NULL,
    total_avg_logical_io_writes_mb DECIMAL(38, 2) NULL,
    total_avg_query_max_used_memory_mb DECIMAL(38, 2) NULL,
    total_rowcount DECIMAL(38, 2) NULL,
    total_count_executions BIGINT NULL,
	total_avg_log_bytes_mb DECIMAL(38, 2) NULL,
	total_avg_tempdb_space DECIMAL(38, 2) NULL,
    total_max_duration_ms DECIMAL(38, 2) NULL,
    total_max_cpu_time_ms DECIMAL(38, 2) NULL,
    total_max_logical_io_reads_mb DECIMAL(38, 2) NULL,
    total_max_physical_io_reads_mb DECIMAL(38, 2) NULL,
    total_max_logical_io_writes_mb DECIMAL(38, 2) NULL,
    total_max_query_max_used_memory_mb DECIMAL(38, 2) NULL,
	total_max_log_bytes_mb DECIMAL(38, 2) NULL,
	total_max_tempdb_space DECIMAL(38, 2) NULL,
	INDEX gi_ix_dates CLUSTERED (start_range, end_range)
);


/*
These are the plans we focus on based on what we find in the grouped intervals
*/
DROP TABLE IF EXISTS #working_plans;

CREATE TABLE #working_plans
(
    plan_id BIGINT,
    query_id BIGINT,
	pattern NVARCHAR(258),
	INDEX wp_ix_ids CLUSTERED (plan_id, query_id)
);


/*
These are the gathered metrics we get from query store to generate some warnings and help you find your worst offenders
*/
DROP TABLE IF EXISTS #working_metrics;

CREATE TABLE #working_metrics 
(
    database_name NVARCHAR(258),
	plan_id BIGINT,
    query_id BIGINT,
    query_id_all_plan_ids VARCHAR(8000),
	/*these columns are from query_store_query*/
	proc_or_function_name NVARCHAR(258),
	batch_sql_handle VARBINARY(64),
	query_hash BINARY(8),
	query_parameterization_type_desc NVARCHAR(258),
	parameter_sniffing_symptoms NVARCHAR(4000),
	count_compiles BIGINT,
	avg_compile_duration DECIMAL(38,2),
	last_compile_duration DECIMAL(38,2),
	avg_bind_duration DECIMAL(38,2),
	last_bind_duration DECIMAL(38,2),
	avg_bind_cpu_time DECIMAL(38,2),
	last_bind_cpu_time DECIMAL(38,2),
	avg_optimize_duration DECIMAL(38,2),
	last_optimize_duration DECIMAL(38,2),
	avg_optimize_cpu_time DECIMAL(38,2),
	last_optimize_cpu_time DECIMAL(38,2),
	avg_compile_memory_kb DECIMAL(38,2),
	last_compile_memory_kb DECIMAL(38,2),
	/*These come from query_store_runtime_stats*/
	execution_type_desc NVARCHAR(128),
	first_execution_time DATETIME2,
	last_execution_time DATETIME2,
	count_executions BIGINT,
	avg_duration DECIMAL(38,2) ,
	last_duration DECIMAL(38,2),
	min_duration DECIMAL(38,2),
	max_duration DECIMAL(38,2),
	avg_cpu_time DECIMAL(38,2),
	last_cpu_time DECIMAL(38,2),
	min_cpu_time DECIMAL(38,2),
	max_cpu_time DECIMAL(38,2),
	avg_logical_io_reads DECIMAL(38,2),
	last_logical_io_reads DECIMAL(38,2),
	min_logical_io_reads DECIMAL(38,2),
	max_logical_io_reads DECIMAL(38,2),
	avg_logical_io_writes DECIMAL(38,2),
	last_logical_io_writes DECIMAL(38,2),
	min_logical_io_writes DECIMAL(38,2),
	max_logical_io_writes DECIMAL(38,2),
	avg_physical_io_reads DECIMAL(38,2),
	last_physical_io_reads DECIMAL(38,2),
	min_physical_io_reads DECIMAL(38,2),
	max_physical_io_reads DECIMAL(38,2),
	avg_clr_time DECIMAL(38,2),
	last_clr_time DECIMAL(38,2),
	min_clr_time DECIMAL(38,2),
	max_clr_time DECIMAL(38,2),
	avg_dop BIGINT,
	last_dop BIGINT,
	min_dop BIGINT,
	max_dop BIGINT,
	avg_query_max_used_memory DECIMAL(38,2),
	last_query_max_used_memory DECIMAL(38,2),
	min_query_max_used_memory DECIMAL(38,2),
	max_query_max_used_memory DECIMAL(38,2),
	avg_rowcount DECIMAL(38,2),
	last_rowcount DECIMAL(38,2),
	min_rowcount DECIMAL(38,2),
	max_rowcount  DECIMAL(38,2),
	/*These are 2017 only, AFAIK*/
	avg_num_physical_io_reads DECIMAL(38,2),
	last_num_physical_io_reads DECIMAL(38,2),
	min_num_physical_io_reads DECIMAL(38,2),
	max_num_physical_io_reads DECIMAL(38,2),
	avg_log_bytes_used DECIMAL(38,2),
	last_log_bytes_used DECIMAL(38,2),
	min_log_bytes_used DECIMAL(38,2),
	max_log_bytes_used DECIMAL(38,2),
	avg_tempdb_space_used DECIMAL(38,2),
	last_tempdb_space_used DECIMAL(38,2),
	min_tempdb_space_used DECIMAL(38,2),
	max_tempdb_space_used DECIMAL(38,2),
	/*These are computed columns to make some stuff easier down the line*/
	total_compile_duration AS avg_compile_duration * count_compiles,
	total_bind_duration AS avg_bind_duration * count_compiles,
	total_bind_cpu_time AS avg_bind_cpu_time * count_compiles,
	total_optimize_duration AS avg_optimize_duration * count_compiles,
	total_optimize_cpu_time AS avg_optimize_cpu_time * count_compiles,
	total_compile_memory_kb AS avg_compile_memory_kb * count_compiles,
	total_duration AS avg_duration * count_executions,
	total_cpu_time AS avg_cpu_time * count_executions,
	total_logical_io_reads AS avg_logical_io_reads * count_executions,
	total_logical_io_writes AS avg_logical_io_writes * count_executions,
	total_physical_io_reads AS avg_physical_io_reads * count_executions,
	total_clr_time AS avg_clr_time * count_executions,
	total_query_max_used_memory AS avg_query_max_used_memory * count_executions,
	total_rowcount AS avg_rowcount * count_executions,
	total_num_physical_io_reads AS avg_num_physical_io_reads * count_executions,
	total_log_bytes_used AS avg_log_bytes_used * count_executions,
	total_tempdb_space_used AS avg_tempdb_space_used * count_executions,
	xpm AS NULLIF(count_executions, 0) / NULLIF(DATEDIFF(MINUTE, first_execution_time, last_execution_time), 0),
    percent_memory_grant_used AS CONVERT(MONEY, ISNULL(NULLIF(( max_query_max_used_memory * 1.00 ), 0) / NULLIF(min_query_max_used_memory, 0), 0) * 100.),
	INDEX wm_ix_ids CLUSTERED (plan_id, query_id, query_hash)
);


/*
This is where we store some additional metrics, along with the query plan and text
*/
DROP TABLE IF EXISTS #working_plan_text;

CREATE TABLE #working_plan_text 
(
	database_name NVARCHAR(258),
    plan_id BIGINT,
    query_id BIGINT,
	/*These are from query_store_plan*/
	plan_group_id BIGINT,
	engine_version NVARCHAR(64),
	compatibility_level INT,
	query_plan_hash BINARY(8),
	query_plan_xml XML,
	is_online_index_plan BIT,
	is_trivial_plan BIT,
	is_parallel_plan BIT,
	is_forced_plan BIT,
	is_natively_compiled BIT,
	force_failure_count BIGINT,
	last_force_failure_reason_desc NVARCHAR(258),
	count_compiles BIGINT,
	initial_compile_start_time DATETIME2,
	last_compile_start_time DATETIME2,
	last_execution_time DATETIME2,
	avg_compile_duration DECIMAL(38,2),
	last_compile_duration BIGINT,
	/*These are from query_store_query*/
	query_sql_text NVARCHAR(MAX),
	statement_sql_handle VARBINARY(64),
	is_part_of_encrypted_module BIT,
	has_restricted_text BIT,
	/*This is from query_context_settings*/
	context_settings NVARCHAR(512),
	/*This is from #working_plans*/
	pattern NVARCHAR(512),
	top_three_waits NVARCHAR(MAX),
	INDEX wpt_ix_ids CLUSTERED (plan_id, query_id, query_plan_hash)
); 


/*
This is where we store warnings that we generate from the XML and metrics
*/
DROP TABLE IF EXISTS #working_warnings;

CREATE TABLE #working_warnings 
(
    plan_id BIGINT,
    query_id BIGINT,
	query_hash BINARY(8),
	sql_handle VARBINARY(64),
	proc_or_function_name NVARCHAR(258),
	plan_multiple_plans BIT,
    is_forced_plan BIT,
    is_forced_parameterized BIT,
    is_cursor BIT,
	is_optimistic_cursor BIT,
	is_forward_only_cursor BIT,
	is_fast_forward_cursor BIT,	
	is_cursor_dynamic BIT,
    is_parallel BIT,
	is_forced_serial BIT,
	is_key_lookup_expensive BIT,
	key_lookup_cost FLOAT,
	is_remote_query_expensive BIT,
	remote_query_cost FLOAT,
    frequent_execution BIT,
    parameter_sniffing BIT,
    unparameterized_query BIT,
    near_parallel BIT,
    plan_warnings BIT,
    long_running BIT,
    downlevel_estimator BIT,
    implicit_conversions BIT,
    tvf_estimate BIT,
    compile_timeout BIT,
    compile_memory_limit_exceeded BIT,
    warning_no_join_predicate BIT,
    query_cost FLOAT,
    missing_index_count INT,
    unmatched_index_count INT,
    is_trivial BIT,
	trace_flags_session NVARCHAR(1000),
	is_unused_grant BIT,
	function_count INT,
	clr_function_count INT,
	is_table_variable BIT,
	no_stats_warning BIT,
	relop_warnings BIT,
	is_table_scan BIT,
	backwards_scan BIT,
	forced_index BIT,
	forced_seek BIT,
	forced_scan BIT,
	columnstore_row_mode BIT,
	is_computed_scalar BIT ,
	is_sort_expensive BIT,
	sort_cost FLOAT,
	is_computed_filter BIT,
	op_name NVARCHAR(100) NULL,
	index_insert_count INT NULL,
	index_update_count INT NULL,
	index_delete_count INT NULL,
	cx_insert_count INT NULL,
	cx_update_count INT NULL,
	cx_delete_count INT NULL,
	table_insert_count INT NULL,
	table_update_count INT NULL,
	table_delete_count INT NULL,
	index_ops AS (index_insert_count + index_update_count + index_delete_count + 
				  cx_insert_count + cx_update_count + cx_delete_count +
				  table_insert_count + table_update_count + table_delete_count),
	is_row_level BIT,
	is_spatial BIT,
	index_dml BIT,
	table_dml BIT,
	long_running_low_cpu BIT,
	low_cost_high_cpu BIT,
	stale_stats BIT,
	is_adaptive BIT,
	is_slow_plan BIT,
	is_compile_more BIT,
	index_spool_cost FLOAT,
	index_spool_rows FLOAT,
	is_spool_expensive BIT,
	is_spool_more_rows BIT,
	estimated_rows FLOAT,
	is_bad_estimate BIT, 
	is_big_log BIT,
	is_big_tempdb BIT,
	is_paul_white_electric BIT,
	is_row_goal BIT,
	is_mstvf BIT,
	is_mm_join BIT,
    is_nonsargable BIT,
	busy_loops BIT,
	tvf_join BIT,
	implicit_conversion_info XML,
	cached_execution_parameters XML,
	missing_indexes XML,
    warnings NVARCHAR(4000)
	INDEX ww_ix_ids CLUSTERED (plan_id, query_id, query_hash, sql_handle)
);


DROP TABLE IF EXISTS #working_wait_stats;

CREATE TABLE #working_wait_stats
(
    plan_id BIGINT,
	wait_category TINYINT,
	wait_category_desc NVARCHAR(258),
	total_query_wait_time_ms BIGINT,
	avg_query_wait_time_ms	 DECIMAL(38, 2),
	last_query_wait_time_ms	BIGINT,
	min_query_wait_time_ms	BIGINT,
	max_query_wait_time_ms	BIGINT,
	wait_category_mapped AS CASE wait_category
								WHEN 0  THEN N'UNKNOWN'
								WHEN 1  THEN N'SOS_SCHEDULER_YIELD'
								WHEN 2  THEN N'THREADPOOL'
								WHEN 3  THEN N'LCK_M_%'
								WHEN 4  THEN N'LATCH_%'
								WHEN 5  THEN N'PAGELATCH_%'
								WHEN 6  THEN N'PAGEIOLATCH_%'
								WHEN 7  THEN N'RESOURCE_SEMAPHORE_QUERY_COMPILE'
								WHEN 8  THEN N'CLR%, SQLCLR%'
								WHEN 9  THEN N'DBMIRROR%'
								WHEN 10 THEN N'XACT%, DTC%, TRAN_MARKLATCH_%, MSQL_XACT_%, TRANSACTION_MUTEX'
								WHEN 11 THEN N'SLEEP_%, LAZYWRITER_SLEEP, SQLTRACE_BUFFER_FLUSH, SQLTRACE_INCREMENTAL_FLUSH_SLEEP, SQLTRACE_WAIT_ENTRIES, FT_IFTS_SCHEDULER_IDLE_WAIT, XE_DISPATCHER_WAIT, REQUEST_FOR_DEADLOCK_SEARCH, LOGMGR_QUEUE, ONDEMAND_TASK_QUEUE, CHECKPOINT_QUEUE, XE_TIMER_EVENT'
								WHEN 12 THEN N'PREEMPTIVE_%'
								WHEN 13 THEN N'BROKER_% (but not BROKER_RECEIVE_WAITFOR)'
								WHEN 14 THEN N'LOGMGR, LOGBUFFER, LOGMGR_RESERVE_APPEND, LOGMGR_FLUSH, LOGMGR_PMM_LOG, CHKPT, WRITELOG'
								WHEN 15 THEN N'ASYNC_NETWORK_IO, NET_WAITFOR_PACKET, PROXY_NETWORK_IO, EXTERNAL_SCRIPT_NETWORK_IOF'
								WHEN 16 THEN N'CXPACKET, EXCHANGE, CXCONSUMER'
								WHEN 17 THEN N'RESOURCE_SEMAPHORE, CMEMTHREAD, CMEMPARTITIONED, EE_PMOLOCK, MEMORY_ALLOCATION_EXT, RESERVED_MEMORY_ALLOCATION_EXT, MEMORY_GRANT_UPDATE'
								WHEN 18 THEN N'WAITFOR, WAIT_FOR_RESULTS, BROKER_RECEIVE_WAITFOR'
								WHEN 19 THEN N'TRACEWRITE, SQLTRACE_LOCK, SQLTRACE_FILE_BUFFER, SQLTRACE_FILE_WRITE_IO_COMPLETION, SQLTRACE_FILE_READ_IO_COMPLETION, SQLTRACE_PENDING_BUFFER_WRITERS, SQLTRACE_SHUTDOWN, QUERY_TRACEOUT, TRACE_EVTNOTIFF'
								WHEN 20 THEN N'FT_RESTART_CRAWL, FULLTEXT GATHERER, MSSEARCH, FT_METADATA_MUTEX, FT_IFTSHC_MUTEX, FT_IFTSISM_MUTEX, FT_IFTS_RWLOCK, FT_COMPROWSET_RWLOCK, FT_MASTER_MERGE, FT_PROPERTYLIST_CACHE, FT_MASTER_MERGE_COORDINATOR, PWAIT_RESOURCE_SEMAPHORE_FT_PARALLEL_QUERY_SYNC'
								WHEN 21 THEN N'ASYNC_IO_COMPLETION, IO_COMPLETION, BACKUPIO, WRITE_COMPLETION, IO_QUEUE_LIMIT, IO_RETRY'
								WHEN 22 THEN N'SE_REPL_%, REPL_%, HADR_% (but not HADR_THROTTLE_LOG_RATE_GOVERNOR), PWAIT_HADR_%, REPLICA_WRITES, FCB_REPLICA_WRITE, FCB_REPLICA_READ, PWAIT_HADRSIM'
								WHEN 23 THEN N'LOG_RATE_GOVERNOR, POOL_LOG_RATE_GOVERNOR, HADR_THROTTLE_LOG_RATE_GOVERNOR, INSTANCE_LOG_RATE_GOVERNOR'
							END,
    INDEX wws_ix_ids CLUSTERED ( plan_id)
);


/*
The next three tables hold plan XML parsed out to different degrees 
*/
DROP TABLE IF EXISTS #statements;

CREATE TABLE #statements 
(
    plan_id BIGINT,
    query_id BIGINT,
	query_hash BINARY(8),
	sql_handle VARBINARY(64),
	statement XML,
    is_cursor BIT
	INDEX s_ix_ids CLUSTERED (plan_id, query_id, query_hash, sql_handle)
);


DROP TABLE IF EXISTS #query_plan;

CREATE TABLE #query_plan 
(
    plan_id BIGINT,
    query_id BIGINT,
	query_hash BINARY(8),
	sql_handle VARBINARY(64),
	query_plan XML,
	INDEX qp_ix_ids CLUSTERED (plan_id, query_id, query_hash, sql_handle)
);


DROP TABLE IF EXISTS #relop;

CREATE TABLE #relop 
(
    plan_id BIGINT,
    query_id BIGINT,
	query_hash BINARY(8),
	sql_handle VARBINARY(64),
	relop XML,
	INDEX ix_ids CLUSTERED (plan_id, query_id, query_hash, sql_handle)
);


DROP TABLE IF EXISTS #plan_cost;

CREATE TABLE #plan_cost 
(
	query_plan_cost DECIMAL(38,2),
	sql_handle VARBINARY(64),
	plan_id INT,
	INDEX px_ix_ids CLUSTERED (sql_handle, plan_id)
);


DROP TABLE IF EXISTS #est_rows;

CREATE TABLE #est_rows 
(
	estimated_rows DECIMAL(38,2),
	query_hash BINARY(8),
	INDEX px_ix_ids CLUSTERED (query_hash)
);


DROP TABLE IF EXISTS #stats_agg;

CREATE TABLE #stats_agg
(
    sql_handle VARBINARY(64),
    last_update DATETIME2,
    modification_count BIGINT,
    sampling_percent DECIMAL(38, 2),
    [statistics] NVARCHAR(258),
    [table] NVARCHAR(258),
    [schema] NVARCHAR(258),
    [database] NVARCHAR(258),
	INDEX sa_ix_ids CLUSTERED (sql_handle)
);


DROP TABLE IF EXISTS #trace_flags;

CREATE TABLE #trace_flags 
(
	sql_handle VARBINARY(54),
	global_trace_flags NVARCHAR(4000),
	session_trace_flags NVARCHAR(4000),
	INDEX tf_ix_ids CLUSTERED (sql_handle)
);


DROP TABLE IF EXISTS #warning_results;	

CREATE TABLE #warning_results 
(
    ID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED,
    CheckID INT,
    Priority TINYINT,
    FindingsGroup NVARCHAR(50),
    Finding NVARCHAR(200),
    URL NVARCHAR(200),
    Details NVARCHAR(4000)
);

/*These next three tables hold information about implicit conversion and cached parameters */
DROP TABLE IF EXISTS #stored_proc_info;	

CREATE TABLE #stored_proc_info
(
	sql_handle VARBINARY(64),
    query_hash BINARY(8),
    variable_name NVARCHAR(258),
    variable_datatype NVARCHAR(258),
	converted_column_name NVARCHAR(258),
    compile_time_value NVARCHAR(258),
    proc_name NVARCHAR(1000),
    column_name NVARCHAR(4000),
    converted_to NVARCHAR(258),
	set_options NVARCHAR(1000)
	INDEX tf_ix_ids CLUSTERED (sql_handle, query_hash)
);

DROP TABLE IF EXISTS #variable_info;

CREATE TABLE #variable_info
(
    query_hash BINARY(8),
    sql_handle VARBINARY(64),
    proc_name NVARCHAR(1000),
    variable_name NVARCHAR(258),
    variable_datatype NVARCHAR(258),
    compile_time_value NVARCHAR(258),
	INDEX vif_ix_ids CLUSTERED (sql_handle, query_hash)
);

DROP TABLE IF EXISTS #conversion_info;

CREATE TABLE #conversion_info
(
    query_hash BINARY(8),
    sql_handle VARBINARY(64),
    proc_name NVARCHAR(128),
    expression NVARCHAR(4000),
    at_charindex AS CHARINDEX('@', expression),
    bracket_charindex AS CHARINDEX(']', expression, CHARINDEX('@', expression)) - CHARINDEX('@', expression),
    comma_charindex AS CHARINDEX(',', expression) + 1,
    second_comma_charindex AS
        CHARINDEX(',', expression, CHARINDEX(',', expression) + 1) - CHARINDEX(',', expression) - 1,
    equal_charindex AS CHARINDEX('=', expression) + 1,
    paren_charindex AS CHARINDEX('(', expression) + 1,
    comma_paren_charindex AS
        CHARINDEX(',', expression, CHARINDEX('(', expression) + 1) - CHARINDEX('(', expression) - 1,
    convert_implicit_charindex AS CHARINDEX('=CONVERT_IMPLICIT', expression),
	INDEX cif_ix_ids CLUSTERED (sql_handle, query_hash)
);

/* These tables support the Missing Index details clickable*/


DROP TABLE IF EXISTS #missing_index_xml;

CREATE TABLE #missing_index_xml
(
    query_hash BINARY(8),
    sql_handle VARBINARY(64),
    impact FLOAT,
    index_xml XML,
	INDEX mix_ix_ids CLUSTERED (sql_handle, query_hash)
);

DROP TABLE IF EXISTS #missing_index_schema;

CREATE TABLE #missing_index_schema
(
    query_hash BINARY(8),
    sql_handle VARBINARY(64),
    impact FLOAT,
    database_name NVARCHAR(128),
    schema_name NVARCHAR(128),
    table_name NVARCHAR(128),
    index_xml XML,
	INDEX mis_ix_ids CLUSTERED (sql_handle, query_hash)
);


DROP TABLE IF EXISTS #missing_index_usage;

CREATE TABLE #missing_index_usage
(
    query_hash BINARY(8),
    sql_handle VARBINARY(64),
    impact FLOAT,
    database_name NVARCHAR(128),
    schema_name NVARCHAR(128),
    table_name NVARCHAR(128),
	usage NVARCHAR(128),
    index_xml XML,
	INDEX miu_ix_ids CLUSTERED (sql_handle, query_hash)
);

DROP TABLE IF EXISTS #missing_index_detail;

CREATE TABLE #missing_index_detail
(
    query_hash BINARY(8),
    sql_handle VARBINARY(64),
    impact FLOAT,
    database_name NVARCHAR(128),
    schema_name NVARCHAR(128),
    table_name NVARCHAR(128),
    usage NVARCHAR(128),
    column_name NVARCHAR(128),
	INDEX mid_ix_ids CLUSTERED (sql_handle, query_hash)
);


DROP TABLE IF EXISTS #missing_index_pretty;

CREATE TABLE #missing_index_pretty
(
    query_hash BINARY(8),
    sql_handle VARBINARY(64),
    impact FLOAT,
    database_name NVARCHAR(128),
    schema_name NVARCHAR(128),
    table_name NVARCHAR(128),
	equality NVARCHAR(MAX),
	inequality NVARCHAR(MAX),
	[include] NVARCHAR(MAX),
	is_spool BIT,
	details AS N'/* '
	           + CHAR(10) 
			   + CASE is_spool 
			          WHEN 0 
					  THEN N'The Query Processor estimates that implementing the '
					  ELSE N'We estimate that implementing the '
				 END  
			   + CONVERT(NVARCHAR(30), impact)
			   + '%.'
			   + CHAR(10)
			   + N'*/'
			   + CHAR(10) + CHAR(13) 
			   + N'/* '
			   + CHAR(10)
			   + N'USE '
			   + database_name
			   + CHAR(10)
			   + N'GO'
			   + CHAR(10) + CHAR(13)
			   + N'CREATE NONCLUSTERED INDEX ix_'
			   + ISNULL(REPLACE(REPLACE(REPLACE(equality,'[', ''), ']', ''),   ', ', '_'), '')
			   + ISNULL(REPLACE(REPLACE(REPLACE(inequality,'[', ''), ']', ''), ', ', '_'), '')
			   + CASE WHEN [include] IS NOT NULL THEN + N'_Includes' ELSE N'' END
			   + CHAR(10)
			   + N' ON '
			   + schema_name
			   + N'.'
			   + table_name
			   + N' (' + 
			   + CASE WHEN equality IS NOT NULL 
					  THEN equality
						+ CASE WHEN inequality IS NOT NULL
							   THEN N', ' + inequality
							   ELSE N''
						  END
					 ELSE inequality
				 END			   
			   + N')' 
			   + CHAR(10)
			   + CASE WHEN include IS NOT NULL
					  THEN N'INCLUDE (' + include + N') WITH (FILLFACTOR=100, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);'
					  ELSE N' WITH (FILLFACTOR=100, ONLINE=?, SORT_IN_TEMPDB=?, DATA_COMPRESSION=?);'
				 END
			   + CHAR(10)
			   + N'GO'
			   + CHAR(10)
			   + N'*/',
	INDEX mip_ix_ids CLUSTERED (sql_handle, query_hash)
);

DROP TABLE IF EXISTS #index_spool_ugly;

CREATE TABLE #index_spool_ugly
(
    query_hash BINARY(8),
    sql_handle VARBINARY(64),
    impact FLOAT,
    database_name NVARCHAR(128),
    schema_name NVARCHAR(128),
    table_name NVARCHAR(128),
	equality NVARCHAR(MAX),
	inequality NVARCHAR(MAX),
	[include] NVARCHAR(MAX),
	INDEX isu_ix_ids CLUSTERED (sql_handle, query_hash)
);


/*Sets up WHERE clause that gets used quite a bit*/

--Date stuff
--If they're both NULL, we'll just look at the last 7 days
IF (@StartDate IS NULL AND @EndDate IS NULL)
	BEGIN
	RAISERROR(N'@StartDate and @EndDate are NULL, checking last 7 days', 0, 1) WITH NOWAIT;
	SET @sql_where += N' AND qsrs.last_execution_time >= DATEADD(DAY, -7, DATEDIFF(DAY, 0, SYSDATETIME() ))
					  ';
	END;

--Hey, that's nice of me
IF @StartDate IS NOT NULL
	BEGIN 
	RAISERROR(N'Setting start date filter', 0, 1) WITH NOWAIT;
	SET @sql_where += N' AND qsrs.last_execution_time >= @sp_StartDate 
					   ';
	END; 

--Alright, sensible
IF @EndDate IS NOT NULL 
	BEGIN 
	RAISERROR(N'Setting end date filter', 0, 1) WITH NOWAIT;
	SET @sql_where += N' AND qsrs.last_execution_time < @sp_EndDate 
					   ';
    END;

--C'mon, why would you do that?
IF (@StartDate IS NULL AND @EndDate IS NOT NULL)
	BEGIN 
	RAISERROR(N'Setting reasonable start date filter', 0, 1) WITH NOWAIT;
	SET @sql_where += N' AND qsrs.last_execution_time >= DATEADD(DAY, -7, @sp_EndDate) 
					   ';
    END;

--Jeez, abusive
IF (@StartDate IS NOT NULL AND @EndDate IS NULL)
	BEGIN 
	RAISERROR(N'Setting reasonable end date filter', 0, 1) WITH NOWAIT;
	SET @sql_where += N' AND qsrs.last_execution_time < DATEADD(DAY, 7, @sp_StartDate) 
					   ';
    END;

--I care about minimum execution counts
IF @MinimumExecutionCount IS NOT NULL 
	BEGIN 
	RAISERROR(N'Setting execution filter', 0, 1) WITH NOWAIT;
	SET @sql_where += N' AND qsrs.count_executions >= @sp_MinimumExecutionCount 
					   ';
    END;

--You care about stored proc names
IF @StoredProcName IS NOT NULL 
	BEGIN 
	RAISERROR(N'Setting stored proc filter', 0, 1) WITH NOWAIT;
	SET @sql_where += N' AND object_name(qsq.object_id, DB_ID(' + QUOTENAME(@DatabaseName, '''') + N')) = @sp_StoredProcName 
					   ';
    END;

--I will always love you, but hopefully this query will eventually end
IF @DurationFilter IS NOT NULL
    BEGIN 
	RAISERROR(N'Setting duration filter', 0, 1) WITH NOWAIT;
	SET  @sql_where += N' AND (qsrs.avg_duration / 1000.) >= @sp_MinDuration 
					    '; 
	END; 

--I don't know why you'd go looking for failed queries, but hey
IF (@Failed = 0 OR @Failed IS NULL)
    BEGIN 
	RAISERROR(N'Setting failed query filter to 0', 0, 1) WITH NOWAIT;
	SET  @sql_where += N' AND qsrs.execution_type = 0 
					    '; 
	END; 
IF (@Failed = 1)
    BEGIN 
	RAISERROR(N'Setting failed query filter to 3, 4', 0, 1) WITH NOWAIT;
	SET  @sql_where += N' AND qsrs.execution_type IN (3, 4) 
					    '; 
	END;  

/*Filtering for plan_id or query_id*/
IF (@PlanIdFilter IS NOT NULL)
    BEGIN 
	RAISERROR(N'Setting plan_id filter', 0, 1) WITH NOWAIT;
	SET  @sql_where += N' AND qsp.plan_id = @sp_PlanIdFilter 
					    '; 
	END; 

IF (@QueryIdFilter IS NOT NULL)
    BEGIN 
	RAISERROR(N'Setting query_id filter', 0, 1) WITH NOWAIT;
	SET  @sql_where += N' AND qsq.query_id = @sp_QueryIdFilter 
					    '; 
	END; 

IF @Debug = 1
	RAISERROR(N'Starting WHERE clause:', 0, 1) WITH NOWAIT;
	PRINT @sql_where;

IF @sql_where IS NULL
    BEGIN
        RAISERROR(N'@sql_where is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

IF (@ExportToExcel = 1 OR @SkipXML = 1)	
	BEGIN
	RAISERROR(N'Exporting to Excel or skipping XML, hiding summary', 0, 1) WITH NOWAIT;
	SET @HideSummary = 1;
	END;

IF @StoredProcName IS NOT NULL
	BEGIN 
	
	DECLARE @sql NVARCHAR(MAX);
	DECLARE @out INT;
	DECLARE @proc_params NVARCHAR(MAX) = N'@sp_StartDate DATETIME2, @sp_EndDate DATETIME2, @sp_MinimumExecutionCount INT, @sp_MinDuration INT, @sp_StoredProcName NVARCHAR(128), @sp_PlanIdFilter INT, @sp_QueryIdFilter INT, @i_out INT OUTPUT';
	
	
	SET @sql = N'SELECT @i_out = COUNT(*) 
				 FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
				 JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
				 ON qsp.plan_id = qsrs.plan_id
				 JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
				 ON qsq.query_id = qsp.query_id
				 WHERE    1 = 1
				        AND qsq.is_internal_query = 0
				 	    AND qsp.query_plan IS NOT NULL 
				 ';
	
	SET @sql += @sql_where;

	EXEC sys.sp_executesql @sql, 
						   @proc_params, 
						   @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter, @i_out = @out OUTPUT;
	
	IF @out = 0
		BEGIN	

		SET @msg = N'We couldn''t find the Stored Procedure ' + QUOTENAME(@StoredProcName) + N' in the Query Store views for ' + QUOTENAME(@DatabaseName) + N' between ' + CONVERT(NVARCHAR(30), ISNULL(@StartDate, DATEADD(DAY, -7, DATEDIFF(DAY, 0, SYSDATETIME() ))) ) + N' and ' + CONVERT(NVARCHAR(30), ISNULL(@EndDate, SYSDATETIME())) +
					 '. Try removing schema prefixes or adjusting dates. If it was executed from a different database context, try searching there instead.';
		RAISERROR(@msg, 0, 1) WITH NOWAIT;

		SELECT @msg AS [Blue Flowers, Blue Flowers, Blue Flowers];
	
		RETURN;
	
		END; 
	
	END;




/*
This is our grouped interval query.

By default, it looks at queries: 
	In the last 7 days
	That aren't system queries
	That have a query plan (some won't, if nested level is > 128, along with other reasons)
	And haven't failed
	This stuff, along with some other options, will be configurable in the stored proc

*/

IF @sql_where IS NOT NULL
BEGIN TRY
	BEGIN

	RAISERROR(N'Populating temp tables', 0, 1) WITH NOWAIT;

RAISERROR(N'Gathering intervals', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
SELECT   CONVERT(DATE, qsrs.last_execution_time) AS flat_date,
         MIN(DATEADD(HOUR, DATEDIFF(HOUR, 0, qsrs.last_execution_time), 0)) AS start_range,
         MAX(DATEADD(HOUR, DATEDIFF(HOUR, 0, qsrs.last_execution_time) + 1, 0)) AS end_range,
         SUM(qsrs.avg_duration / 1000.) / SUM(qsrs.count_executions) AS total_avg_duration_ms,
         SUM(qsrs.avg_cpu_time / 1000.) / SUM(qsrs.count_executions) AS total_avg_cpu_time_ms,
         SUM((qsrs.avg_logical_io_reads * 8 ) / 1024.) / SUM(qsrs.count_executions) AS total_avg_logical_io_reads_mb,
         SUM((qsrs.avg_physical_io_reads* 8 ) / 1024.) / SUM(qsrs.count_executions) AS total_avg_physical_io_reads_mb,
         SUM((qsrs.avg_logical_io_writes* 8 ) / 1024.) / SUM(qsrs.count_executions) AS total_avg_logical_io_writes_mb,
         SUM((qsrs.avg_query_max_used_memory * 8 ) / 1024.) / SUM(qsrs.count_executions) AS total_avg_query_max_used_memory_mb,
         SUM(qsrs.avg_rowcount) AS total_rowcount,
         SUM(qsrs.count_executions) AS total_count_executions,
         SUM(qsrs.max_duration / 1000.) AS total_max_duration_ms,
         SUM(qsrs.max_cpu_time / 1000.) AS total_max_cpu_time_ms,
         SUM((qsrs.max_logical_io_reads * 8 ) / 1024.) AS total_max_logical_io_reads_mb,
         SUM((qsrs.max_physical_io_reads* 8 ) / 1024.) AS total_max_physical_io_reads_mb,
         SUM((qsrs.max_logical_io_writes* 8 ) / 1024.) AS total_max_logical_io_writes_mb,
         SUM((qsrs.max_query_max_used_memory * 8 ) / 1024.)  AS total_max_query_max_used_memory_mb         ';
		 IF @new_columns = 1
			BEGIN
				SET @sql_select += N',
									 SUM((qsrs.avg_log_bytes_used) / 1048576.) / SUM(qsrs.count_executions) AS total_avg_log_bytes_mb,
									 SUM(qsrs.avg_tempdb_space_used) /  SUM(qsrs.count_executions) AS total_avg_tempdb_space,
                                     SUM((qsrs.max_log_bytes_used) / 1048576.) AS total_max_log_bytes_mb,
		                             SUM(qsrs.max_tempdb_space_used) AS total_max_tempdb_space
									 ';
			END;
		IF @new_columns = 0
			BEGIN
				SET @sql_select += N',
									NULL AS total_avg_log_bytes_mb, 
									NULL AS total_avg_tempdb_space,
                                    NULL AS total_max_log_bytes_mb,
                                    NULL AS total_max_tempdb_space
									';
			END;


SET @sql_select += N'FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
					 JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
					 ON qsp.plan_id = qsrs.plan_id
					 JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
					 ON qsq.query_id = qsp.query_id
					 WHERE  1 = 1
					        AND qsq.is_internal_query = 0
					 	    AND qsp.query_plan IS NOT NULL
					 	  ';


SET @sql_select += @sql_where;

SET @sql_select += 
			N'GROUP BY CONVERT(DATE, qsrs.last_execution_time)
					OPTION (RECOMPILE);
			';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

INSERT #grouped_interval WITH (TABLOCK)
		( flat_date, start_range, end_range, total_avg_duration_ms, 
		  total_avg_cpu_time_ms, total_avg_logical_io_reads_mb, total_avg_physical_io_reads_mb, 
		  total_avg_logical_io_writes_mb, total_avg_query_max_used_memory_mb, total_rowcount, 
		  total_count_executions, total_max_duration_ms, total_max_cpu_time_ms, total_max_logical_io_reads_mb,
          total_max_physical_io_reads_mb, total_max_logical_io_writes_mb, total_max_query_max_used_memory_mb,
          total_avg_log_bytes_mb, total_avg_tempdb_space, total_max_log_bytes_mb, total_max_tempdb_space )                      

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


/*
The next group of queries looks at plans in the ranges we found in the grouped interval query

We take the highest value from each metric (duration, cpu, etc) and find the top plans by that metric in the range

They insert into the #working_plans table
*/



/*Get longest duration plans*/

RAISERROR(N'Gathering longest duration plans', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH duration_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_avg_duration_ms DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
         qsp.plan_id, qsp.query_id, ''avg duration''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     duration_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
	AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.avg_duration DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH duration_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_max_duration_ms DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
         qsp.plan_id, qsp.query_id, ''max duration''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     duration_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
	AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.max_duration DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


/*Get longest cpu plans*/

RAISERROR(N'Gathering highest cpu plans', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH cpu_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_avg_cpu_time_ms DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top )
		 qsp.plan_id, qsp.query_id, ''avg cpu''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     cpu_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.avg_cpu_time DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH cpu_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_max_cpu_time_ms DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top )
		 qsp.plan_id, qsp.query_id, ''max cpu''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     cpu_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.max_cpu_time DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


/*Get highest logical read plans*/

RAISERROR(N'Gathering highest logical read plans', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH logical_reads_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_avg_logical_io_reads_mb DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
		 qsp.plan_id, qsp.query_id, ''avg logical reads''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     logical_reads_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.avg_logical_io_reads DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH logical_reads_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_max_logical_io_reads_mb DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
		 qsp.plan_id, qsp.query_id, ''max logical reads''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     logical_reads_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.max_logical_io_reads DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


/*Get highest physical read plans*/

RAISERROR(N'Gathering highest physical read plans', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH physical_read_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_avg_physical_io_reads_mb DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
		 qsp.plan_id, qsp.query_id, ''avg physical reads''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     physical_read_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.avg_physical_io_reads DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH physical_read_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_max_physical_io_reads_mb DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
		 qsp.plan_id, qsp.query_id, ''max physical reads''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     physical_read_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.max_physical_io_reads DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


/*Get highest logical write plans*/

RAISERROR(N'Gathering highest write plans', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH logical_writes_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_avg_logical_io_writes_mb DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
		 qsp.plan_id, qsp.query_id, ''avg writes''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     logical_writes_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.avg_logical_io_writes DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH logical_writes_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_max_logical_io_writes_mb DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
		 qsp.plan_id, qsp.query_id, ''max writes''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     logical_writes_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.max_logical_io_writes DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


/*Get highest memory use plans*/

RAISERROR(N'Gathering highest memory use plans', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH memory_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_avg_query_max_used_memory_mb DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
		 qsp.plan_id, qsp.query_id, ''avg memory''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     memory_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.avg_query_max_used_memory DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH memory_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_max_query_max_used_memory_mb DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
		 qsp.plan_id, qsp.query_id, ''max memory''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     memory_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.max_query_max_used_memory DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


/*Get highest row count plans*/

RAISERROR(N'Gathering highest row count plans', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH rowcount_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_rowcount DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
		 qsp.plan_id, qsp.query_id, ''avg rows''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     rowcount_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.avg_rowcount DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


IF @new_columns = 1
BEGIN

RAISERROR(N'Gathering new 2017 new column info...', 0, 1) WITH NOWAIT;

/*Get highest log byte count plans*/

RAISERROR(N'Gathering highest log byte use plans', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH rowcount_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_avg_log_bytes_mb DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
		 qsp.plan_id, qsp.query_id, ''avg log bytes''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     rowcount_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.avg_log_bytes_used DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;

RAISERROR(N'Gathering highest log byte use plans', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH rowcount_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_max_log_bytes_mb DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
		 qsp.plan_id, qsp.query_id, ''max log bytes''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     rowcount_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.max_log_bytes_used DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


/*Get highest tempdb use plans*/

RAISERROR(N'Gathering highest tempdb use plans', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH rowcount_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_avg_tempdb_space DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
		 qsp.plan_id, qsp.query_id, ''avg tempdb space''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     rowcount_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.avg_tempdb_space_used DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
WITH rowcount_max
AS ( SELECT   TOP 1 
              gi.start_range,
              gi.end_range
     FROM     #grouped_interval AS gi
     ORDER BY gi.total_max_tempdb_space DESC )
INSERT #working_plans WITH (TABLOCK) 
		( plan_id, query_id, pattern )
SELECT   TOP ( @sp_Top ) 
		 qsp.plan_id, qsp.query_id, ''max tempdb space''
FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
JOIN     rowcount_max AS dm
ON qsp.last_execution_time >= dm.start_range
   AND qsp.last_execution_time < dm.end_range
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = qsp.plan_id
JOIN     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON qsq.query_id = qsp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'ORDER BY qsrs.max_tempdb_space_used DESC
					OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;


END;


/*
This rolls up the different patterns we find before deduplicating.

The point of this is so we know if a query was gathered by one or more of the search queries

*/

RAISERROR(N'Updating patterns', 0, 1) WITH NOWAIT;

WITH patterns AS (
SELECT wp.plan_id, wp.query_id,
	   pattern_path = STUFF((SELECT DISTINCT N', ' + wp2.pattern
									FROM #working_plans AS wp2
									WHERE wp.plan_id = wp2.plan_id
									AND wp.query_id = wp2.query_id
									FOR XML PATH(N''), TYPE).value(N'.[1]', N'NVARCHAR(MAX)'), 1, 2, N'')									
FROM #working_plans AS wp
)
UPDATE wp
SET wp.pattern = patterns.pattern_path
FROM #working_plans AS wp
JOIN patterns
ON  wp.plan_id = patterns.plan_id
AND wp.query_id = patterns.query_id
OPTION (RECOMPILE);


/*
This dedupes our results so we hopefully don't double-work the same plan
*/

RAISERROR(N'Deduplicating gathered plans', 0, 1) WITH NOWAIT;

WITH dedupe AS (
SELECT * , ROW_NUMBER() OVER (PARTITION BY wp.plan_id ORDER BY wp.plan_id) AS dupes
FROM #working_plans AS wp
)
DELETE dedupe
WHERE dedupe.dupes > 1
OPTION (RECOMPILE);

SET @msg = N'Removed ' + CONVERT(NVARCHAR(10), @@ROWCOUNT) + N' duplicate plan_ids.';
RAISERROR(@msg, 0, 1) WITH NOWAIT;


/*
This gathers data for the #working_metrics table
*/


RAISERROR(N'Collecting worker metrics', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
SELECT ' + QUOTENAME(@DatabaseName, '''') + N' AS database_name, wp.plan_id, wp.query_id,
       QUOTENAME(object_schema_name(qsq.object_id, DB_ID(' + QUOTENAME(@DatabaseName, '''') + N'))) + ''.'' +
	   QUOTENAME(object_name(qsq.object_id, DB_ID(' + QUOTENAME(@DatabaseName, '''') + N'))) AS proc_or_function_name,
	   qsq.batch_sql_handle, qsq.query_hash, qsq.query_parameterization_type_desc, qsq.count_compiles, 
	   (qsq.avg_compile_duration / 1000.), 
	   (qsq.last_compile_duration / 1000.), 
	   (qsq.avg_bind_duration / 1000.), 
	   (qsq.last_bind_duration / 1000.), 
	   (qsq.avg_bind_cpu_time / 1000.), 
	   (qsq.last_bind_cpu_time / 1000.), 
	   (qsq.avg_optimize_duration / 1000.), 
	   (qsq.last_optimize_duration / 1000.), 
	   (qsq.avg_optimize_cpu_time / 1000.), 
	   (qsq.last_optimize_cpu_time / 1000.), 
	   (qsq.avg_compile_memory_kb / 1024.), 
	   (qsq.last_compile_memory_kb / 1024.), 
	   qsrs.execution_type_desc, qsrs.first_execution_time, qsrs.last_execution_time, qsrs.count_executions, 
	   (qsrs.avg_duration / 1000.), 
	   (qsrs.last_duration / 1000.),
	   (qsrs.min_duration / 1000.), 
	   (qsrs.max_duration / 1000.), 
	   (qsrs.avg_cpu_time / 1000.), 
	   (qsrs.last_cpu_time / 1000.), 
	   (qsrs.min_cpu_time / 1000.), 
	   (qsrs.max_cpu_time / 1000.), 
	   ((qsrs.avg_logical_io_reads * 8 ) / 1024.), 
	   ((qsrs.last_logical_io_reads * 8 ) / 1024.), 
	   ((qsrs.min_logical_io_reads * 8 ) / 1024.), 
	   ((qsrs.max_logical_io_reads * 8 ) / 1024.), 
	   ((qsrs.avg_logical_io_writes * 8 ) / 1024.), 
	   ((qsrs.last_logical_io_writes * 8 ) / 1024.), 
	   ((qsrs.min_logical_io_writes * 8 ) / 1024.), 
	   ((qsrs.max_logical_io_writes * 8 ) / 1024.), 
	   ((qsrs.avg_physical_io_reads * 8 ) / 1024.), 
	   ((qsrs.last_physical_io_reads * 8 ) / 1024.), 
	   ((qsrs.min_physical_io_reads * 8 ) / 1024.), 
	   ((qsrs.max_physical_io_reads * 8 ) / 1024.), 
	   (qsrs.avg_clr_time / 1000.), 
	   (qsrs.last_clr_time / 1000.), 
	   (qsrs.min_clr_time / 1000.), 
	   (qsrs.max_clr_time / 1000.), 
	   qsrs.avg_dop, qsrs.last_dop, qsrs.min_dop, qsrs.max_dop, 
	   ((qsrs.avg_query_max_used_memory * 8 ) / 1024.), 
	   ((qsrs.last_query_max_used_memory * 8 ) / 1024.), 
	   ((qsrs.min_query_max_used_memory * 8 ) / 1024.), 
	   ((qsrs.max_query_max_used_memory * 8 ) / 1024.), 
	   qsrs.avg_rowcount, qsrs.last_rowcount, qsrs.min_rowcount, qsrs.max_rowcount,';
		
		IF @new_columns = 1
			BEGIN
			SET @sql_select += N'
			qsrs.avg_num_physical_io_reads, qsrs.last_num_physical_io_reads, qsrs.min_num_physical_io_reads, qsrs.max_num_physical_io_reads,
			(qsrs.avg_log_bytes_used / 100000000),
			(qsrs.last_log_bytes_used / 100000000),
			(qsrs.min_log_bytes_used / 100000000),
			(qsrs.max_log_bytes_used / 100000000),
			((qsrs.avg_tempdb_space_used * 8 ) / 1024.),
			((qsrs.last_tempdb_space_used * 8 ) / 1024.),
			((qsrs.min_tempdb_space_used * 8 ) / 1024.),
			((qsrs.max_tempdb_space_used * 8 ) / 1024.)
			';
			END;	
		IF @new_columns = 0
			BEGIN
			SET @sql_select += N'
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL,
			NULL
			';
			END;
SET @sql_select +=
N'FROM   #working_plans AS wp
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON wp.query_id = qsq.query_id
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = wp.plan_id
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
ON qsp.plan_id = wp.plan_id
AND qsp.query_id = wp.query_id
JOIN ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

INSERT #working_metrics WITH (TABLOCK)
		( database_name, plan_id, query_id, 
		  proc_or_function_name, 
		  batch_sql_handle, query_hash, query_parameterization_type_desc, count_compiles, 
		  avg_compile_duration, last_compile_duration, avg_bind_duration, last_bind_duration, avg_bind_cpu_time, last_bind_cpu_time, avg_optimize_duration, 
		  last_optimize_duration, avg_optimize_cpu_time, last_optimize_cpu_time, avg_compile_memory_kb, last_compile_memory_kb, execution_type_desc, 
		  first_execution_time, last_execution_time, count_executions, avg_duration, last_duration, min_duration, max_duration, avg_cpu_time, last_cpu_time, 
		  min_cpu_time, max_cpu_time, avg_logical_io_reads, last_logical_io_reads, min_logical_io_reads, max_logical_io_reads, avg_logical_io_writes, 
		  last_logical_io_writes, min_logical_io_writes, max_logical_io_writes, avg_physical_io_reads, last_physical_io_reads, min_physical_io_reads, 
		  max_physical_io_reads, avg_clr_time, last_clr_time, min_clr_time, max_clr_time, avg_dop, last_dop, min_dop, max_dop, avg_query_max_used_memory, 
		  last_query_max_used_memory, min_query_max_used_memory, max_query_max_used_memory, avg_rowcount, last_rowcount, min_rowcount, max_rowcount,
		  /* 2017 only columns */
		  avg_num_physical_io_reads, last_num_physical_io_reads, min_num_physical_io_reads, max_num_physical_io_reads,
		  avg_log_bytes_used, last_log_bytes_used, min_log_bytes_used, max_log_bytes_used,
		  avg_tempdb_space_used, last_tempdb_space_used, min_tempdb_space_used, max_tempdb_space_used )

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;



/*This just helps us classify our queries*/
UPDATE #working_metrics
SET proc_or_function_name = N'Statement'
WHERE proc_or_function_name IS NULL
OPTION(RECOMPILE);

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
    WITH patterns AS (
         SELECT query_id, planid_path = STUFF((SELECT DISTINCT N'', '' + RTRIM(qsp2.plan_id)
             									FROM ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp2
             									WHERE qsp.query_id = qsp2.query_id
             									FOR XML PATH(N''''), TYPE).value(N''.[1]'', N''NVARCHAR(MAX)''), 1, 2, N'''')
         FROM ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
    )
    UPDATE wm
    SET wm.query_id_all_plan_ids = patterns.planid_path
    FROM #working_metrics AS wm
    JOIN patterns
    ON  wm.query_id = patterns.query_id
    OPTION (RECOMPILE);
'

EXEC sys.sp_executesql  @stmt = @sql_select;

/*
This gathers data for the #working_plan_text table
*/


RAISERROR(N'Gathering working plans', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
SELECT ' + QUOTENAME(@DatabaseName, '''') + N' AS database_name,  wp.plan_id, wp.query_id,
	   qsp.plan_group_id, qsp.engine_version, qsp.compatibility_level, qsp.query_plan_hash, TRY_CONVERT(XML, qsp.query_plan), qsp.is_online_index_plan, qsp.is_trivial_plan, 
	   qsp.is_parallel_plan, qsp.is_forced_plan, qsp.is_natively_compiled, qsp.force_failure_count, qsp.last_force_failure_reason_desc, qsp.count_compiles, 
	   qsp.initial_compile_start_time, qsp.last_compile_start_time, qsp.last_execution_time, 
	   (qsp.avg_compile_duration / 1000.), 
	   (qsp.last_compile_duration / 1000.), 
	   qsqt.query_sql_text, qsqt.statement_sql_handle, qsqt.is_part_of_encrypted_module, qsqt.has_restricted_text
FROM   #working_plans AS wp
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
ON qsp.plan_id = wp.plan_id
   AND qsp.query_id = wp.query_id
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON wp.query_id = qsq.query_id
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = wp.plan_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

INSERT #working_plan_text WITH (TABLOCK)
		( database_name, plan_id, query_id, 
		  plan_group_id, engine_version, compatibility_level, query_plan_hash, query_plan_xml, is_online_index_plan, is_trivial_plan, 
		  is_parallel_plan, is_forced_plan, is_natively_compiled, force_failure_count, last_force_failure_reason_desc, count_compiles, 
		  initial_compile_start_time, last_compile_start_time, last_execution_time, avg_compile_duration, last_compile_duration, 
		  query_sql_text, statement_sql_handle, is_part_of_encrypted_module, has_restricted_text )

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;



/*
This gets us context settings for our queries and adds it to the #working_plan_text table
*/

RAISERROR(N'Gathering context settings', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
UPDATE wp
SET wp.context_settings = SUBSTRING(
					    CASE WHEN (CAST(qcs.set_options AS INT) & 1 = 1) THEN '', ANSI_PADDING'' ELSE '''' END +
					    CASE WHEN (CAST(qcs.set_options AS INT) & 8 = 8) THEN '', CONCAT_NULL_YIELDS_NULL'' ELSE '''' END +
					    CASE WHEN (CAST(qcs.set_options AS INT) & 16 = 16) THEN '', ANSI_WARNINGS'' ELSE '''' END +
					    CASE WHEN (CAST(qcs.set_options AS INT) & 32 = 32) THEN '', ANSI_NULLS'' ELSE '''' END +
					    CASE WHEN (CAST(qcs.set_options AS INT) & 64 = 64) THEN '', QUOTED_IDENTIFIER'' ELSE '''' END +
					    CASE WHEN (CAST(qcs.set_options AS INT) & 4096 = 4096) THEN '', ARITH_ABORT'' ELSE '''' END +
					    CASE WHEN (CAST(qcs.set_options AS INT) & 8192 = 8192) THEN '', NUMERIC_ROUNDABORT'' ELSE '''' END 
					    , 2, 200000)
FROM #working_plan_text wp
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON wp.query_id = qsq.query_id
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_context_settings AS qcs
ON qcs.context_settings_id = qsq.context_settings_id
OPTION (RECOMPILE);
';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select;


/*This adds the patterns we found from each interval to the #working_plan_text table*/

RAISERROR(N'Add patterns to working plans', 0, 1) WITH NOWAIT;

UPDATE wpt
SET wpt.pattern = wp.pattern
FROM #working_plans AS wp
JOIN #working_plan_text AS wpt
ON wpt.plan_id = wp.plan_id
AND wpt.query_id = wp.query_id
OPTION (RECOMPILE);

/*This cleans up query text a bit*/

RAISERROR(N'Clean awkward characters from query text', 0, 1) WITH NOWAIT;

UPDATE b
SET b.query_sql_text = REPLACE(REPLACE(REPLACE(b.query_sql_text, @cr, ' '), @lf, ' '), @tab, '  ')
FROM #working_plan_text AS b
OPTION (RECOMPILE);


/*This populates #working_wait_stats when available*/

IF @waitstats = 1

	BEGIN
	
	RAISERROR(N'Collecting wait stats info', 0, 1) WITH NOWAIT;
	
	
		SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
		SET @sql_select += N'
		SELECT   qws.plan_id,
		         qws.wait_category,
		         qws.wait_category_desc,
		         SUM(qws.total_query_wait_time_ms) AS total_query_wait_time_ms,
		         SUM(qws.avg_query_wait_time_ms) AS avg_query_wait_time_ms,
		         SUM(qws.last_query_wait_time_ms) AS last_query_wait_time_ms,
		         SUM(qws.min_query_wait_time_ms) AS min_query_wait_time_ms,
		         SUM(qws.max_query_wait_time_ms) AS max_query_wait_time_ms
		FROM     ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_wait_stats qws
		JOIN #working_plans AS wp
		ON qws.plan_id = wp.plan_id
		GROUP BY qws.plan_id, qws.wait_category, qws.wait_category_desc
		HAVING SUM(qws.min_query_wait_time_ms) >= 5
		OPTION (RECOMPILE);
		';
		
		IF @Debug = 1
			PRINT @sql_select;
		
		IF @sql_select IS NULL
		    BEGIN
		        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
		        RETURN;
		    END;
		
		INSERT #working_wait_stats WITH (TABLOCK)
				( plan_id, wait_category, wait_category_desc, total_query_wait_time_ms, avg_query_wait_time_ms, last_query_wait_time_ms, min_query_wait_time_ms, max_query_wait_time_ms )
		
		EXEC sys.sp_executesql  @stmt = @sql_select;
	
	
	/*This updates #working_plan_text with the top three waits from the wait stats DMV*/
	
	RAISERROR(N'Update working_plan_text with top three waits', 0, 1) WITH NOWAIT;
	
	
		UPDATE wpt
		SET wpt.top_three_waits = x.top_three_waits 
		FROM #working_plan_text AS wpt
		JOIN (
			SELECT wws.plan_id,
				   top_three_waits = STUFF((SELECT TOP 3 N', ' + wws2.wait_category_desc + N' (' + CONVERT(NVARCHAR(20), SUM(CONVERT(BIGINT, wws2.avg_query_wait_time_ms))) + N' ms) '
												FROM #working_wait_stats AS wws2
												WHERE wws.plan_id = wws2.plan_id
												GROUP BY wws2.wait_category_desc
												ORDER BY SUM(wws2.avg_query_wait_time_ms) DESC
												FOR XML PATH(N''), TYPE).value(N'.[1]', N'NVARCHAR(MAX)'), 1, 2, N'')							
			FROM #working_wait_stats AS wws
			GROUP BY wws.plan_id
		) AS x 
		ON x.plan_id = wpt.plan_id
		OPTION (RECOMPILE);

END;

/*End wait stats population*/

UPDATE #working_plan_text
SET top_three_waits = CASE 
						WHEN @waitstats = 0 
                        THEN N'The query store waits stats DMV is not available'
						ELSE N'No Significant waits detected!'
						END
WHERE top_three_waits IS NULL
OPTION(RECOMPILE);

END;
END TRY
BEGIN CATCH
        RAISERROR (N'Failure populating temp tables.', 0,1) WITH NOWAIT;

        IF @sql_select IS NOT NULL
        BEGIN
            SET @msg = N'Last @sql_select: ' + @sql_select;
            RAISERROR(@msg, 0, 1) WITH NOWAIT;
        END;

        SELECT    @msg = @DatabaseName + N' database failed to process. ' + ERROR_MESSAGE(), @error_severity = ERROR_SEVERITY(), @error_state = ERROR_STATE();
        RAISERROR (@msg, @error_severity, @error_state) WITH NOWAIT;
        
        
        WHILE @@TRANCOUNT > 0 
            ROLLBACK;

        RETURN;
END CATCH;

IF (@SkipXML = 0)
BEGIN TRY 
BEGIN

/*
This sets up the #working_warnings table with the IDs we're interested in so we can tie warnings back to them 
*/

RAISERROR(N'Populate working warnings table with gathered plans', 0, 1) WITH NOWAIT;


SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
SELECT DISTINCT wp.plan_id, wp.query_id, qsq.query_hash, qsqt.statement_sql_handle
FROM   #working_plans AS wp
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
ON qsp.plan_id = wp.plan_id
   AND qsp.query_id = wp.query_id
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON wp.query_id = qsq.query_id
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = wp.plan_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select +=  N'OPTION (RECOMPILE);
					';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

INSERT #working_warnings  WITH (TABLOCK)
	( plan_id, query_id, query_hash, sql_handle )
EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;

/*
This looks for queries in the query stores that we picked up from an internal that have multiple plans in cache

This and several of the following queries all replaced XML parsing to find plan attributes. Sweet.

Thanks, Query Store
*/

RAISERROR(N'Populating object name in #working_warnings', 0, 1) WITH NOWAIT;
UPDATE w
SET    w.proc_or_function_name = ISNULL(wm.proc_or_function_name, N'Statement')
FROM   #working_warnings AS w
JOIN   #working_metrics AS wm
ON w.plan_id = wm.plan_id
   AND w.query_id = wm.query_id
OPTION (RECOMPILE);


RAISERROR(N'Checking for multiple plans', 0, 1) WITH NOWAIT;

SET @sql_select = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;';
SET @sql_select += N'
UPDATE ww
SET ww.plan_multiple_plans = 1
FROM #working_warnings AS ww
JOIN 
(
SELECT wp.query_id, COUNT(qsp.plan_id) AS  plans
FROM   #working_plans AS wp
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_plan AS qsp
ON qsp.plan_id = wp.plan_id
   AND qsp.query_id = wp.query_id
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query AS qsq
ON wp.query_id = qsq.query_id
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_query_text AS qsqt
ON qsqt.query_text_id = qsq.query_text_id
JOIN   ' + QUOTENAME(@DatabaseName) + N'.sys.query_store_runtime_stats AS qsrs
ON qsrs.plan_id = wp.plan_id
WHERE    1 = 1
    AND qsq.is_internal_query = 0
	AND qsp.query_plan IS NOT NULL
	';

SET @sql_select += @sql_where;

SET @sql_select += 
N'GROUP BY wp.query_id
  HAVING COUNT(qsp.plan_id) > 1
) AS x
    ON ww.query_id = x.query_id
OPTION (RECOMPILE);
';

IF @Debug = 1
	PRINT @sql_select;

IF @sql_select IS NULL
    BEGIN
        RAISERROR(N'@sql_select is NULL', 0, 1) WITH NOWAIT;
        RETURN;
    END;

EXEC sys.sp_executesql  @stmt = @sql_select, 
						@params = @sp_params,
						@sp_Top = @Top, @sp_StartDate = @StartDate, @sp_EndDate = @EndDate, @sp_MinimumExecutionCount = @MinimumExecutionCount, @sp_MinDuration = @duration_filter_ms, @sp_StoredProcName = @StoredProcName, @sp_PlanIdFilter = @PlanIdFilter, @sp_QueryIdFilter = @QueryIdFilter;

/*
This looks for forced plans
*/

RAISERROR(N'Checking for forced plans', 0, 1) WITH NOWAIT;

UPDATE ww
SET    ww.is_forced_plan = 1
FROM   #working_warnings AS ww
JOIN   #working_plan_text AS wp
ON ww.plan_id = wp.plan_id
   AND ww.query_id = wp.query_id
   AND wp.is_forced_plan = 1
OPTION (RECOMPILE);


/*
This looks for forced parameterization
*/

RAISERROR(N'Checking for forced parameterization', 0, 1) WITH NOWAIT;

UPDATE ww
SET    ww.is_forced_parameterized = 1
FROM   #working_warnings AS ww
JOIN   #working_metrics AS wm
ON ww.plan_id = wm.plan_id
   AND ww.query_id = wm.query_id
   AND wm.query_parameterization_type_desc = 'Forced'
OPTION (RECOMPILE);


/*
This looks for unparameterized queries
*/

RAISERROR(N'Checking for unparameterized plans', 0, 1) WITH NOWAIT;

UPDATE ww
SET    ww.unparameterized_query = 1
FROM   #working_warnings AS ww
JOIN   #working_metrics AS wm
ON ww.plan_id = wm.plan_id
   AND ww.query_id = wm.query_id
   AND wm.query_parameterization_type_desc = 'None'
   AND ww.proc_or_function_name = 'Statement'
OPTION (RECOMPILE);


/*
This looks for cursors
*/

RAISERROR(N'Checking for cursors', 0, 1) WITH NOWAIT;
UPDATE ww
SET    ww.is_cursor = 1
FROM   #working_warnings AS ww
JOIN   #working_plan_text AS wp
ON ww.plan_id = wp.plan_id
   AND ww.query_id = wp.query_id
   AND wp.plan_group_id > 0
OPTION (RECOMPILE);


UPDATE ww
SET    ww.is_cursor = 1
FROM   #working_warnings AS ww
JOIN   #working_plan_text AS wp
ON ww.plan_id = wp.plan_id
   AND ww.query_id = wp.query_id
WHERE ww.query_hash = 0x0000000000000000
OR wp.query_plan_hash = 0x0000000000000000
OPTION (RECOMPILE);

/*
This looks for parallel plans
*/
UPDATE ww
SET    ww.is_parallel = 1
FROM   #working_warnings AS ww
JOIN   #working_plan_text AS wp
ON ww.plan_id = wp.plan_id
   AND ww.query_id = wp.query_id
   AND wp.is_parallel_plan = 1
OPTION (RECOMPILE);

/*This looks for old CE*/

RAISERROR(N'Checking for legacy CE', 0, 1) WITH NOWAIT;

UPDATE w
SET w.downlevel_estimator = 1
FROM #working_warnings AS w
JOIN #working_plan_text AS wpt
ON w.plan_id = wpt.plan_id
AND w.query_id = wpt.query_id
/*PLEASE DON'T TELL ANYONE I DID THIS*/
WHERE PARSENAME(wpt.engine_version, 4) < PARSENAME(CONVERT(VARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')), 4)
OPTION (RECOMPILE);
/*NO SERIOUSLY THIS IS A HORRIBLE IDEA*/


/*Plans that compile 2x more than they execute*/

RAISERROR(N'Checking for plans that compile 2x more than they execute', 0, 1) WITH NOWAIT;

UPDATE ww
SET    ww.is_compile_more = 1
FROM   #working_warnings AS ww
JOIN   #working_metrics AS wm
ON ww.plan_id = wm.plan_id
   AND ww.query_id = wm.query_id
   AND wm.count_compiles > (wm.count_executions * 2)
OPTION (RECOMPILE);

/*Plans that compile 2x more than they execute*/

RAISERROR(N'Checking for plans that take more than 5 seconds to bind, compile, or optimize', 0, 1) WITH NOWAIT;

UPDATE ww
SET    ww.is_slow_plan = 1
FROM   #working_warnings AS ww
JOIN   #working_metrics AS wm
ON ww.plan_id = wm.plan_id
   AND ww.query_id = wm.query_id
   AND (wm.avg_bind_duration > 5000
		OR 
		wm.avg_compile_duration > 5000
		OR
		wm.avg_optimize_duration > 5000
		OR 
		wm.avg_optimize_cpu_time > 5000)
OPTION (RECOMPILE);



/*
This parses the XML from our top plans into smaller chunks for easier consumption
*/

RAISERROR(N'Begin XML nodes parsing', 0, 1) WITH NOWAIT;

RAISERROR(N'Inserting #statements', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
INSERT #statements WITH (TABLOCK) ( plan_id, query_id, query_hash, sql_handle, statement, is_cursor )	
	SELECT ww.plan_id, ww.query_id, ww.query_hash, ww.sql_handle, q.n.query('.') AS statement, 0 AS is_cursor
	FROM #working_warnings AS ww
	JOIN #working_plan_text AS wp
	ON ww.plan_id = wp.plan_id
	AND ww.query_id = wp.query_id
    CROSS APPLY wp.query_plan_xml.nodes('//p:StmtSimple') AS q(n) 
OPTION (RECOMPILE);

RAISERROR(N'Inserting parsed cursor XML to #statements', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
INSERT #statements WITH (TABLOCK) ( plan_id, query_id, query_hash, sql_handle, statement, is_cursor )
	SELECT ww.plan_id, ww.query_id, ww.query_hash, ww.sql_handle, q.n.query('.') AS statement, 1 AS is_cursor
	FROM #working_warnings AS ww
	JOIN #working_plan_text AS wp
	ON ww.plan_id = wp.plan_id
	AND ww.query_id = wp.query_id
    CROSS APPLY wp.query_plan_xml.nodes('//p:StmtCursor') AS q(n) 
OPTION (RECOMPILE);

RAISERROR(N'Inserting to #query_plan', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
INSERT #query_plan WITH (TABLOCK) ( plan_id, query_id, query_hash, sql_handle, query_plan )
SELECT  s.plan_id, s.query_id, s.query_hash, s.sql_handle, q.n.query('.') AS query_plan
FROM    #statements AS s
        CROSS APPLY s.statement.nodes('//p:QueryPlan') AS q(n) 
OPTION (RECOMPILE);

RAISERROR(N'Inserting to #relop', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
INSERT #relop WITH (TABLOCK) ( plan_id, query_id, query_hash, sql_handle, relop)
SELECT  qp.plan_id, qp.query_id, qp.query_hash, qp.sql_handle, q.n.query('.') AS relop
FROM    #query_plan qp
        CROSS APPLY qp.query_plan.nodes('//p:RelOp') AS q(n) 
OPTION (RECOMPILE);


-- statement level checks

RAISERROR(N'Performing compile timeout checks', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET     b.compile_timeout = 1 
FROM    #statements s
JOIN #working_warnings AS b
ON  s.query_hash = b.query_hash
WHERE s.statement.exist('/p:StmtSimple/@StatementOptmEarlyAbortReason[.="TimeOut"]') = 1
OPTION (RECOMPILE);


RAISERROR(N'Performing compile memory limit exceeded checks', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET     b.compile_memory_limit_exceeded = 1 
FROM    #statements s
JOIN #working_warnings AS b
ON  s.query_hash = b.query_hash
WHERE s.statement.exist('/p:StmtSimple/@StatementOptmEarlyAbortReason[.="MemoryLimitExceeded"]') = 1
OPTION (RECOMPILE);

IF @ExpertMode > 0
BEGIN
RAISERROR(N'Performing index DML checks', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p),
index_dml AS (
	SELECT	s.query_hash,	
			index_dml = CASE WHEN s.statement.exist('//p:StmtSimple/@StatementType[.="CREATE INDEX"]') = 1 THEN 1
							 WHEN s.statement.exist('//p:StmtSimple/@StatementType[.="DROP INDEX"]') = 1 THEN 1
							 END
	FROM    #statements s
			)
	UPDATE b
		SET b.index_dml = i.index_dml
	FROM #working_warnings AS b
	JOIN index_dml i
	ON i.query_hash = b.query_hash
	WHERE i.index_dml = 1
OPTION (RECOMPILE);


RAISERROR(N'Performing table DML checks', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p),
table_dml AS (
	SELECT s.query_hash,			
		   table_dml = CASE WHEN s.statement.exist('//p:StmtSimple/@StatementType[.="CREATE TABLE"]') = 1 THEN 1
							WHEN s.statement.exist('//p:StmtSimple/@StatementType[.="DROP OBJECT"]') = 1 THEN 1
							END
		 FROM #statements AS s
		 )
	UPDATE b
		SET b.table_dml = t.table_dml
	FROM #working_warnings AS b
	JOIN table_dml t
	ON t.query_hash = b.query_hash
	WHERE t.table_dml = 1
OPTION (RECOMPILE);
END;


RAISERROR(N'Gathering trivial plans', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES ( 'http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p )
UPDATE b
SET b.is_trivial = 1
FROM #working_warnings AS b
JOIN (
SELECT  s.sql_handle
FROM    #statements AS s
JOIN    (   SELECT  r.sql_handle
            FROM    #relop AS r
            WHERE   r.relop.exist('//p:RelOp[contains(@LogicalOp, "Scan")]') = 1 ) AS r
    ON r.sql_handle = s.sql_handle
WHERE   s.statement.exist('//p:StmtSimple[@StatementOptmLevel[.="TRIVIAL"]]/p:QueryPlan/p:ParameterList') = 1
) AS s
ON b.sql_handle = s.sql_handle
OPTION (RECOMPILE);

IF @ExpertMode > 0
BEGIN
RAISERROR(N'Gathering row estimates', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES ('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p )
INSERT #est_rows (query_hash, estimated_rows)
SELECT DISTINCT 
		CONVERT(BINARY(8), RIGHT('0000000000000000' + SUBSTRING(c.n.value('@QueryHash', 'VARCHAR(18)'), 3, 18), 16), 2) AS query_hash,
		c.n.value('(/p:StmtSimple/@StatementEstRows)[1]', 'FLOAT') AS estimated_rows
FROM   #statements AS s
CROSS APPLY s.statement.nodes('/p:StmtSimple') AS c(n)
WHERE  c.n.exist('/p:StmtSimple[@StatementEstRows > 0]') = 1;

	UPDATE b
		SET b.estimated_rows = er.estimated_rows
	FROM #working_warnings AS b
	JOIN #est_rows er
	ON er.query_hash = b.query_hash
	OPTION (RECOMPILE);
END;


/*Begin plan cost calculations*/
RAISERROR(N'Gathering statement costs', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
INSERT #plan_cost WITH (TABLOCK)
	( query_plan_cost, sql_handle, plan_id )
SELECT  DISTINCT
		s.statement.value('sum(/p:StmtSimple/@StatementSubTreeCost)', 'float') query_plan_cost,
		s.sql_handle,
		s.plan_id
FROM    #statements s
OUTER APPLY s.statement.nodes('/p:StmtSimple') AS q(n)
WHERE s.statement.value('sum(/p:StmtSimple/@StatementSubTreeCost)', 'float') > 0
OPTION (RECOMPILE);


RAISERROR(N'Updating statement costs', 0, 1) WITH NOWAIT;
WITH pc AS (
	SELECT SUM(DISTINCT pc.query_plan_cost) AS queryplancostsum, pc.sql_handle, pc.plan_id
	FROM #plan_cost AS pc
	GROUP BY pc.sql_handle, pc.plan_id
	)
	UPDATE b
		SET b.query_cost = ISNULL(pc.queryplancostsum, 0)
		FROM  #working_warnings AS b
		JOIN pc
		ON pc.sql_handle = b.sql_handle
		AND pc.plan_id = b.plan_id
OPTION (RECOMPILE);


/*End plan cost calculations*/


RAISERROR(N'Checking for plan warnings', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE  b
SET b.plan_warnings = 1
FROM    #query_plan qp
JOIN #working_warnings b
ON  qp.sql_handle = b.sql_handle
AND qp.query_plan.exist('/p:QueryPlan/p:Warnings') = 1
OPTION (RECOMPILE);


RAISERROR(N'Checking for implicit conversion', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE  b
SET b.implicit_conversions = 1
FROM    #query_plan qp
JOIN #working_warnings b
ON  qp.sql_handle = b.sql_handle
AND qp.query_plan.exist('/p:QueryPlan/p:Warnings/p:PlanAffectingConvert/@Expression[contains(., "CONVERT_IMPLICIT")]') = 1
OPTION (RECOMPILE);

IF @ExpertMode > 0
BEGIN
RAISERROR(N'Performing busy loops checks', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE p
SET    busy_loops = CASE WHEN (x.estimated_executions / 100.0) > x.estimated_rows THEN 1 END 
FROM   #working_warnings p
       JOIN (
            SELECT qs.sql_handle,
                   relop.value('sum(/p:RelOp/@EstimateRows)', 'float') AS estimated_rows ,
                   relop.value('sum(/p:RelOp/@EstimateRewinds)', 'float') + relop.value('sum(/p:RelOp/@EstimateRebinds)', 'float') + 1.0 AS estimated_executions 
            FROM   #relop qs
       ) AS x ON p.sql_handle = x.sql_handle
OPTION (RECOMPILE);
END; 


RAISERROR(N'Performing TVF join check', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE p
SET    p.tvf_join = CASE WHEN x.tvf_join = 1 THEN 1 END
FROM   #working_warnings p
       JOIN (
			SELECT r.sql_handle,
				   1 AS tvf_join
			FROM #relop AS r
			WHERE r.relop.exist('//p:RelOp[(@LogicalOp[.="Table-valued function"])]') = 1
			AND   r.relop.exist('//p:RelOp[contains(@LogicalOp, "Join")]') = 1
       ) AS x ON p.sql_handle = x.sql_handle
OPTION (RECOMPILE);

IF @ExpertMode > 0
BEGIN
RAISERROR(N'Checking for operator warnings', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
, x AS (
SELECT r.sql_handle,
	   c.n.exist('//p:Warnings[(@NoJoinPredicate[.="1"])]') AS warning_no_join_predicate,
	   c.n.exist('//p:ColumnsWithNoStatistics') AS no_stats_warning ,
	   c.n.exist('//p:Warnings') AS relop_warnings
FROM #relop AS r
CROSS APPLY r.relop.nodes('/p:RelOp/p:Warnings') AS c(n)
)
UPDATE b
SET	   b.warning_no_join_predicate = x.warning_no_join_predicate,
	   b.no_stats_warning = x.no_stats_warning,
	   b.relop_warnings = x.relop_warnings
FROM #working_warnings b
JOIN x ON x.sql_handle = b.sql_handle
OPTION (RECOMPILE);
END; 


RAISERROR(N'Checking for table variables', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
, x AS (
SELECT r.sql_handle,
	   c.n.value('substring(@Table, 2, 1)','VARCHAR(100)') AS first_char
FROM   #relop r
CROSS APPLY r.relop.nodes('//p:Object') AS c(n)
)
UPDATE b
SET	   b.is_table_variable = 1
FROM #working_warnings b
JOIN x ON x.sql_handle = b.sql_handle
JOIN #working_metrics AS wm
ON b.plan_id = wm.plan_id
AND b.query_id = wm.query_id
AND wm.batch_sql_handle IS NOT NULL
WHERE x.first_char = '@'
OPTION (RECOMPILE);


IF @ExpertMode > 0
BEGIN
RAISERROR(N'Checking for functions', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
, x AS (
SELECT r.sql_handle,
	   n.fn.value('count(distinct-values(//p:UserDefinedFunction[not(@IsClrFunction)]))', 'INT') AS function_count,
	   n.fn.value('count(distinct-values(//p:UserDefinedFunction[@IsClrFunction = "1"]))', 'INT') AS clr_function_count
FROM   #relop r
CROSS APPLY r.relop.nodes('/p:RelOp/p:ComputeScalar/p:DefinedValues/p:DefinedValue/p:ScalarOperator') n(fn)
)
UPDATE b
SET	   b.function_count = x.function_count,
	   b.clr_function_count = x.clr_function_count
FROM #working_warnings b
JOIN x ON x.sql_handle = b.sql_handle
OPTION (RECOMPILE);
END;


RAISERROR(N'Checking for expensive key lookups', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET b.key_lookup_cost = x.key_lookup_cost
FROM #working_warnings b
JOIN (
SELECT 
       r.sql_handle,
	   MAX(r.relop.value('sum(/p:RelOp/@EstimatedTotalSubtreeCost)', 'float')) AS key_lookup_cost
FROM   #relop r
WHERE r.relop.exist('/p:RelOp/p:IndexScan[(@Lookup[.="1"])]') = 1
GROUP BY r.sql_handle
) AS x ON x.sql_handle = b.sql_handle
OPTION (RECOMPILE);


RAISERROR(N'Checking for expensive remote queries', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET b.remote_query_cost = x.remote_query_cost
FROM #working_warnings b
JOIN (
SELECT 
       r.sql_handle,
	   MAX(r.relop.value('sum(/p:RelOp/@EstimatedTotalSubtreeCost)', 'float')) AS remote_query_cost
FROM   #relop r
WHERE r.relop.exist('/p:RelOp[(@PhysicalOp[contains(., "Remote")])]') = 1
GROUP BY r.sql_handle
) AS x ON x.sql_handle = b.sql_handle
OPTION (RECOMPILE);


RAISERROR(N'Checking for expensive sorts', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET sort_cost = y.max_sort_cost 
FROM #working_warnings b
JOIN (
	SELECT x.sql_handle, MAX((x.sort_io + x.sort_cpu)) AS max_sort_cost
	FROM (
		SELECT 
		       qs.sql_handle,
			   relop.value('sum(/p:RelOp/@EstimateIO)', 'float') AS sort_io,
			   relop.value('sum(/p:RelOp/@EstimateCPU)', 'float') AS sort_cpu
		FROM   #relop qs
		WHERE [relop].exist('/p:RelOp[(@PhysicalOp[.="Sort"])]') = 1
		) AS x
	GROUP BY x.sql_handle
	) AS y
ON  b.sql_handle = y.sql_handle
OPTION (RECOMPILE);

IF NOT EXISTS(SELECT 1/0 FROM #statements AS s WHERE s.is_cursor = 1)
BEGIN

RAISERROR(N'No cursor plans found, skipping', 0, 1) WITH NOWAIT;

END

IF EXISTS(SELECT 1/0 FROM #statements AS s WHERE s.is_cursor = 1)
BEGIN

RAISERROR(N'Cursor plans found, investigating', 0, 1) WITH NOWAIT;

RAISERROR(N'Checking for Optimistic cursors', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET b.is_optimistic_cursor =  1
FROM #working_warnings b
JOIN #statements AS s
ON b.sql_handle = s.sql_handle
CROSS APPLY s.statement.nodes('/p:StmtCursor') AS n1(fn)
WHERE n1.fn.exist('//p:CursorPlan/@CursorConcurrency[.="Optimistic"]') = 1
AND s.is_cursor = 1
OPTION (RECOMPILE);


RAISERROR(N'Checking if cursor is Forward Only', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET b.is_forward_only_cursor = 1
FROM #working_warnings b
JOIN #statements AS s
ON b.sql_handle = s.sql_handle
CROSS APPLY s.statement.nodes('/p:StmtCursor') AS n1(fn)
WHERE n1.fn.exist('//p:CursorPlan/@ForwardOnly[.="true"]') = 1
AND s.is_cursor = 1
OPTION (RECOMPILE);


RAISERROR(N'Checking if cursor is Fast Forward', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET b.is_fast_forward_cursor = 1
FROM #working_warnings b
JOIN #statements AS s
ON b.sql_handle = s.sql_handle
CROSS APPLY s.statement.nodes('/p:StmtCursor') AS n1(fn)
WHERE n1.fn.exist('//p:CursorPlan/@CursorActualType[.="FastForward"]') = 1
AND s.is_cursor = 1
OPTION (RECOMPILE);


RAISERROR(N'Checking for Dynamic cursors', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET b.is_cursor_dynamic =  1
FROM #working_warnings b
JOIN #statements AS s
ON b.sql_handle = s.sql_handle
CROSS APPLY s.statement.nodes('/p:StmtCursor') AS n1(fn)
WHERE n1.fn.exist('//p:CursorPlan/@CursorActualType[.="Dynamic"]') = 1
AND s.is_cursor = 1
OPTION (RECOMPILE);

END

IF @ExpertMode > 0
BEGIN
RAISERROR(N'Checking for bad scans and plan forcing', 0, 1) WITH NOWAIT;
;WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET 
b.is_table_scan = x.is_table_scan,
b.backwards_scan = x.backwards_scan,
b.forced_index = x.forced_index,
b.forced_seek = x.forced_seek,
b.forced_scan = x.forced_scan
FROM #working_warnings b
JOIN (
SELECT 
       r.sql_handle,
	   0 AS is_table_scan,
	   q.n.exist('@ScanDirection[.="BACKWARD"]') AS backwards_scan,
	   q.n.value('@ForcedIndex', 'bit') AS forced_index,
	   q.n.value('@ForceSeek', 'bit') AS forced_seek,
	   q.n.value('@ForceScan', 'bit') AS forced_scan
FROM   #relop r
CROSS APPLY r.relop.nodes('//p:IndexScan') AS q(n)
UNION ALL
SELECT 
       r.sql_handle,
	   1 AS is_table_scan,
	   q.n.exist('@ScanDirection[.="BACKWARD"]') AS backwards_scan,
	   q.n.value('@ForcedIndex', 'bit') AS forced_index,
	   q.n.value('@ForceSeek', 'bit') AS forced_seek,
	   q.n.value('@ForceScan', 'bit') AS forced_scan
FROM   #relop r
CROSS APPLY r.relop.nodes('//p:TableScan') AS q(n)
) AS x ON b.sql_handle = x.sql_handle
OPTION (RECOMPILE);
END;


IF @ExpertMode > 0
BEGIN
RAISERROR(N'Checking for computed columns that reference scalar UDFs', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET b.is_computed_scalar = x.computed_column_function
FROM #working_warnings b
JOIN (
SELECT r.sql_handle,
	   n.fn.value('count(distinct-values(//p:UserDefinedFunction[not(@IsClrFunction)]))', 'INT') AS computed_column_function
FROM   #relop r
CROSS APPLY r.relop.nodes('/p:RelOp/p:ComputeScalar/p:DefinedValues/p:DefinedValue/p:ScalarOperator') n(fn)
WHERE n.fn.exist('/p:RelOp/p:ComputeScalar/p:DefinedValues/p:DefinedValue/p:ColumnReference[(@ComputedColumn[.="1"])]') = 1
) AS x ON x.sql_handle = b.sql_handle
OPTION (RECOMPILE);
END;


RAISERROR(N'Checking for filters that reference scalar UDFs', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET b.is_computed_filter = x.filter_function
FROM #working_warnings b
JOIN (
SELECT 
r.sql_handle, 
c.n.value('count(distinct-values(//p:UserDefinedFunction[not(@IsClrFunction)]))', 'INT') AS filter_function
FROM #relop AS r
CROSS APPLY r.relop.nodes('/p:RelOp/p:Filter/p:Predicate/p:ScalarOperator/p:Compare/p:ScalarOperator/p:UserDefinedFunction') c(n) 
) x ON x.sql_handle = b.sql_handle
OPTION (RECOMPILE);


IF @ExpertMode > 0
BEGIN
RAISERROR(N'Checking modification queries that hit lots of indexes', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p),	
IndexOps AS 
(
	SELECT 
	r.query_hash,
	c.n.value('@PhysicalOp', 'VARCHAR(100)') AS op_name,
	c.n.exist('@PhysicalOp[.="Index Insert"]') AS ii,
	c.n.exist('@PhysicalOp[.="Index Update"]') AS iu,
	c.n.exist('@PhysicalOp[.="Index Delete"]') AS id,
	c.n.exist('@PhysicalOp[.="Clustered Index Insert"]') AS cii,
	c.n.exist('@PhysicalOp[.="Clustered Index Update"]') AS ciu,
	c.n.exist('@PhysicalOp[.="Clustered Index Delete"]') AS cid,
	c.n.exist('@PhysicalOp[.="Table Insert"]') AS ti,
	c.n.exist('@PhysicalOp[.="Table Update"]') AS tu,
	c.n.exist('@PhysicalOp[.="Table Delete"]') AS td
	FROM #relop AS r
	CROSS APPLY r.relop.nodes('/p:RelOp') c(n)
	OUTER APPLY r.relop.nodes('/p:RelOp/p:ScalarInsert/p:Object') q(n)
	OUTER APPLY r.relop.nodes('/p:RelOp/p:Update/p:Object') o2(n)
	OUTER APPLY r.relop.nodes('/p:RelOp/p:SimpleUpdate/p:Object') o3(n)
), iops AS 
(
		SELECT	ios.query_hash,
		SUM(CONVERT(TINYINT, ios.ii)) AS index_insert_count,
		SUM(CONVERT(TINYINT, ios.iu)) AS index_update_count,
		SUM(CONVERT(TINYINT, ios.id)) AS index_delete_count,
		SUM(CONVERT(TINYINT, ios.cii)) AS cx_insert_count,
		SUM(CONVERT(TINYINT, ios.ciu)) AS cx_update_count,
		SUM(CONVERT(TINYINT, ios.cid)) AS cx_delete_count,
		SUM(CONVERT(TINYINT, ios.ti)) AS table_insert_count,
		SUM(CONVERT(TINYINT, ios.tu)) AS table_update_count,
		SUM(CONVERT(TINYINT, ios.td)) AS table_delete_count
		FROM IndexOps AS ios
		WHERE ios.op_name IN ('Index Insert', 'Index Delete', 'Index Update', 
							  'Clustered Index Insert', 'Clustered Index Delete', 'Clustered Index Update', 
							  'Table Insert', 'Table Delete', 'Table Update')
		GROUP BY ios.query_hash) 
UPDATE b
SET b.index_insert_count = iops.index_insert_count,
	b.index_update_count = iops.index_update_count,
	b.index_delete_count = iops.index_delete_count,
	b.cx_insert_count = iops.cx_insert_count,
	b.cx_update_count = iops.cx_update_count,
	b.cx_delete_count = iops.cx_delete_count,
	b.table_insert_count = iops.table_insert_count,
	b.table_update_count = iops.table_update_count,
	b.table_delete_count = iops.table_delete_count
FROM #working_warnings AS b
JOIN iops ON  iops.query_hash = b.query_hash
OPTION (RECOMPILE);
END;


IF @ExpertMode > 0
BEGIN
RAISERROR(N'Checking for Spatial index use', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET b.is_spatial = x.is_spatial
FROM #working_warnings AS b
JOIN (
SELECT r.sql_handle,
	   1 AS is_spatial
FROM   #relop r
CROSS APPLY r.relop.nodes('/p:RelOp//p:Object') n(fn)
WHERE n.fn.exist('(@IndexKind[.="Spatial"])') = 1
) AS x ON x.sql_handle = b.sql_handle
OPTION (RECOMPILE);
END;

RAISERROR(N'Checking for forced serialization', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE  b
SET b.is_forced_serial = 1
FROM #query_plan qp
JOIN #working_warnings AS b
ON    qp.sql_handle = b.sql_handle
AND b.is_parallel IS NULL
AND qp.query_plan.exist('/p:QueryPlan/@NonParallelPlanReason') = 1
OPTION (RECOMPILE);


IF @ExpertMode > 0
BEGIN
RAISERROR(N'Checking for ColumnStore queries operating in Row Mode instead of Batch Mode', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET b.columnstore_row_mode = x.is_row_mode
FROM #working_warnings AS b
JOIN (
SELECT 
       r.sql_handle,
	   r.relop.exist('/p:RelOp[(@EstimatedExecutionMode[.="Row"])]') AS is_row_mode
FROM   #relop r
WHERE r.relop.exist('/p:RelOp/p:IndexScan[(@Storage[.="ColumnStore"])]') = 1
) AS x ON x.sql_handle = b.sql_handle
OPTION (RECOMPILE);
END;


IF @ExpertMode > 0
BEGIN
RAISERROR('Checking for row level security only', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE  b
SET  b.is_row_level = 1
FROM #working_warnings b
JOIN #statements s 
ON s.query_hash = b.query_hash 
WHERE s.statement.exist('/p:StmtSimple/@SecurityPolicyApplied[.="true"]') = 1
OPTION (RECOMPILE);
END;


IF @ExpertMode > 0
BEGIN
RAISERROR('Checking for wonky Index Spools', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES (
    'http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p )
, selects
AS ( SELECT s.plan_id, s.query_id
     FROM   #statements AS s
     WHERE  s.statement.exist('/p:StmtSimple/@StatementType[.="SELECT"]') = 1 )
, spools
AS ( SELECT DISTINCT r.plan_id,
       r.query_id,
	   c.n.value('@EstimateRows', 'FLOAT') AS estimated_rows,
       c.n.value('@EstimateIO', 'FLOAT') AS estimated_io,
       c.n.value('@EstimateCPU', 'FLOAT') AS estimated_cpu,
       c.n.value('@EstimateRebinds', 'FLOAT') AS estimated_rebinds
FROM   #relop AS r
JOIN   selects AS s
ON s.plan_id = r.plan_id
   AND s.query_id = r.query_id
CROSS APPLY r.relop.nodes('/p:RelOp') AS c(n)
WHERE  r.relop.exist('/p:RelOp[@PhysicalOp="Index Spool" and @LogicalOp="Eager Spool"]') = 1
)
UPDATE ww
		SET ww.index_spool_rows = sp.estimated_rows,
			ww.index_spool_cost = ((sp.estimated_io * sp.estimated_cpu) * CASE WHEN sp.estimated_rebinds < 1 THEN 1 ELSE sp.estimated_rebinds END)

FROM #working_warnings ww
JOIN spools sp
ON ww.plan_id = sp.plan_id
AND ww.query_id = sp.query_id
OPTION (RECOMPILE);
END;


IF (PARSENAME(CONVERT(VARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')), 4)) >= 14
OR ((PARSENAME(CONVERT(VARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')), 4)) = 13
	AND PARSENAME(CONVERT(VARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')), 2) >= 5026)

BEGIN

RAISERROR(N'Beginning 2017 and 2016 SP2 specfic checks', 0, 1) WITH NOWAIT;

IF @ExpertMode > 0
BEGIN
RAISERROR('Gathering stats information', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
INSERT #stats_agg WITH (TABLOCK)
	(sql_handle, last_update, modification_count, sampling_percent, [statistics], [table], [schema], [database])
SELECT qp.sql_handle,
	   x.c.value('@LastUpdate', 'DATETIME2(7)') AS LastUpdate,
	   x.c.value('@ModificationCount', 'BIGINT') AS ModificationCount,
	   x.c.value('@SamplingPercent', 'FLOAT') AS SamplingPercent,
	   x.c.value('@Statistics', 'NVARCHAR(258)') AS [Statistics], 
	   x.c.value('@Table', 'NVARCHAR(258)') AS [Table], 
	   x.c.value('@Schema', 'NVARCHAR(258)') AS [Schema], 
	   x.c.value('@Database', 'NVARCHAR(258)') AS [Database]
FROM #query_plan AS qp
CROSS APPLY qp.query_plan.nodes('//p:OptimizerStatsUsage/p:StatisticsInfo') x (c)
OPTION (RECOMPILE);


RAISERROR('Checking for stale stats', 0, 1) WITH NOWAIT;
WITH  stale_stats AS (
	SELECT sa.sql_handle
	FROM #stats_agg AS sa
	GROUP BY sa.sql_handle
	HAVING MAX(sa.last_update) <= DATEADD(DAY, -7, SYSDATETIME())
	AND AVG(sa.modification_count) >= 100000
)
UPDATE b
SET b.stale_stats = 1
FROM #working_warnings AS b
JOIN stale_stats os
ON b.sql_handle = os.sql_handle
OPTION (RECOMPILE);
END;


IF (PARSENAME(CONVERT(VARCHAR(128), SERVERPROPERTY ('PRODUCTVERSION')), 4)) >= 14
	AND @ExpertMode > 0
BEGIN
RAISERROR(N'Checking for Adaptive Joins', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p),
aj AS (
	SELECT r.sql_handle
	FROM #relop AS r
	CROSS APPLY r.relop.nodes('//p:RelOp') x(c)
	WHERE x.c.exist('@IsAdaptive[.=1]') = 1
)
UPDATE b
SET b.is_adaptive = 1
FROM #working_warnings AS b
JOIN aj
ON b.sql_handle = aj.sql_handle
OPTION (RECOMPILE);
END; 


IF @ExpertMode > 0
BEGIN;
RAISERROR(N'Checking for Row Goals', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p),
row_goals AS(
SELECT qs.query_hash
FROM   #relop qs
WHERE relop.value('sum(/p:RelOp/@EstimateRowsWithoutRowGoal)', 'float') > 0
)
UPDATE b
SET b.is_row_goal = 1
FROM #working_warnings b
JOIN row_goals
ON b.query_hash = row_goals.query_hash
OPTION (RECOMPILE);
END;

END; 


RAISERROR(N'Performing query level checks', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE  b
SET     b.missing_index_count = query_plan.value('count(//p:QueryPlan/p:MissingIndexes/p:MissingIndexGroup)', 'int') ,
		b.unmatched_index_count = CASE WHEN is_trivial <> 1 THEN query_plan.value('count(//p:QueryPlan/p:UnmatchedIndexes/p:Parameterization/p:Object)', 'int') END
FROM    #query_plan qp
JOIN #working_warnings AS b
ON b.query_hash = qp.query_hash
OPTION (RECOMPILE);


RAISERROR(N'Trace flag checks', 0, 1) WITH NOWAIT;
;WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
, tf_pretty AS (
SELECT  qp.sql_handle,
		q.n.value('@Value', 'INT') AS trace_flag,
		q.n.value('@Scope', 'VARCHAR(10)') AS scope
FROM    #query_plan qp
CROSS APPLY qp.query_plan.nodes('/p:QueryPlan/p:TraceFlags/p:TraceFlag') AS q(n)
)
INSERT #trace_flags WITH (TABLOCK)
		(sql_handle, global_trace_flags, session_trace_flags )
SELECT DISTINCT tf1.sql_handle ,
    STUFF((
          SELECT DISTINCT N', ' + CONVERT(NVARCHAR(5), tf2.trace_flag)
          FROM  tf_pretty AS tf2 
          WHERE tf1.sql_handle = tf2.sql_handle 
		  AND tf2.scope = 'Global'
        FOR XML PATH(N'')), 1, 2, N''
      ) AS global_trace_flags,
    STUFF((
          SELECT DISTINCT N', ' + CONVERT(NVARCHAR(5), tf2.trace_flag)
          FROM  tf_pretty AS tf2 
          WHERE tf1.sql_handle = tf2.sql_handle 
		  AND tf2.scope = 'Session'
        FOR XML PATH(N'')), 1, 2, N''
      ) AS session_trace_flags
FROM tf_pretty AS tf1
OPTION (RECOMPILE);

UPDATE b
SET    b.trace_flags_session = tf.session_trace_flags
FROM   #working_warnings AS b
JOIN #trace_flags tf 
ON tf.sql_handle = b.sql_handle 
OPTION (RECOMPILE);


RAISERROR(N'Checking for MSTVFs', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET b.is_mstvf = 1
FROM #relop AS r
JOIN #working_warnings AS b
ON b.sql_handle = r.sql_handle
WHERE  r.relop.exist('/p:RelOp[(@EstimateRows="100" or @EstimateRows="1") and @LogicalOp="Table-valued function"]') = 1
OPTION (RECOMPILE);

IF @ExpertMode > 0
BEGIN
RAISERROR(N'Checking for many to many merge joins', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET b.is_mm_join = 1
FROM #relop AS r
JOIN #working_warnings AS b
ON b.sql_handle = r.sql_handle
WHERE  r.relop.exist('/p:RelOp/p:Merge/@ManyToMany[.="1"]') = 1
OPTION (RECOMPILE);
END;


IF @ExpertMode > 0
BEGIN
RAISERROR(N'Is Paul White Electric?', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p),
is_paul_white_electric AS (
SELECT 1 AS [is_paul_white_electric], 
r.sql_handle
FROM #relop AS r
CROSS APPLY r.relop.nodes('//p:RelOp') c(n)
WHERE c.n.exist('@PhysicalOp[.="Switch"]') = 1
)
UPDATE b
SET    b.is_paul_white_electric = ipwe.is_paul_white_electric
FROM   #working_warnings AS b
JOIN is_paul_white_electric ipwe 
ON ipwe.sql_handle = b.sql_handle 
OPTION (RECOMPILE);
END;



RAISERROR(N'Checking for non-sargable predicates', 0, 1) WITH NOWAIT;
WITH XMLNAMESPACES ( 'http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p )
, nsarg
    AS (   SELECT       r.query_hash, 1 AS fn, 0 AS jo, 0 AS lk
           FROM         #relop AS r
           CROSS APPLY  r.relop.nodes('/p:RelOp/p:IndexScan/p:Predicate/p:ScalarOperator/p:Compare/p:ScalarOperator') AS ca(x)
           WHERE        (   ca.x.exist('//p:ScalarOperator/p:Intrinsic/@FunctionName') = 1
                            OR     ca.x.exist('//p:ScalarOperator/p:IF') = 1 )
           UNION ALL
           SELECT       r.query_hash, 0 AS fn, 1 AS jo, 0 AS lk
           FROM         #relop AS r
           CROSS APPLY  r.relop.nodes('/p:RelOp//p:ScalarOperator') AS ca(x)
           WHERE        r.relop.exist('/p:RelOp[contains(@LogicalOp, "Join")]') = 1
                        AND ca.x.exist('//p:ScalarOperator[contains(@ScalarString, "Expr")]') = 1
           UNION ALL
           SELECT       r.query_hash, 0 AS fn, 0 AS jo, 1 AS lk
           FROM         #relop AS r
           CROSS APPLY  r.relop.nodes('/p:RelOp/p:IndexScan/p:Predicate/p:ScalarOperator') AS ca(x)
           CROSS APPLY  ca.x.nodes('//p:Const') AS co(x)
           WHERE        ca.x.exist('//p:ScalarOperator/p:Intrinsic/@FunctionName[.="like"]') = 1
                        AND (   (   co.x.value('substring(@ConstValue, 1, 1)', 'VARCHAR(100)') <> 'N'
                                    AND co.x.value('substring(@ConstValue, 2, 1)', 'VARCHAR(100)') = '%' )
                                OR (   co.x.value('substring(@ConstValue, 1, 1)', 'VARCHAR(100)') = 'N'
                                       AND co.x.value('substring(@ConstValue, 3, 1)', 'VARCHAR(100)') = '%' ))),
  d_nsarg
    AS (   SELECT   DISTINCT
                    nsarg.query_hash
           FROM     nsarg
           WHERE    nsarg.fn = 1
                    OR nsarg.jo = 1
                    OR nsarg.lk = 1 )
UPDATE  b
SET     b.is_nonsargable = 1
FROM    d_nsarg AS d
JOIN    #working_warnings AS b
    ON b.query_hash = d.query_hash
OPTION ( RECOMPILE );


        RAISERROR(N'Getting information about implicit conversions and stored proc parameters', 0, 1) WITH NOWAIT;

		RAISERROR(N'Getting variable info', 0, 1) WITH NOWAIT;
		WITH XMLNAMESPACES ( 'http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p )
		INSERT #variable_info ( query_hash, sql_handle, proc_name, variable_name, variable_datatype, compile_time_value )
		SELECT      DISTINCT
		            qp.query_hash,
		            qp.sql_handle,
		            b.proc_or_function_name AS proc_name,
		            q.n.value('@Column', 'NVARCHAR(258)') AS variable_name,
		            q.n.value('@ParameterDataType', 'NVARCHAR(258)') AS variable_datatype,
		            q.n.value('@ParameterCompiledValue', 'NVARCHAR(258)') AS compile_time_value
		FROM        #query_plan AS qp
           JOIN     #working_warnings AS b
           ON (b.query_hash = qp.query_hash AND b.proc_or_function_name = 'adhoc')
		   OR (b.sql_handle = qp.sql_handle AND b.proc_or_function_name <> 'adhoc')
		CROSS APPLY qp.query_plan.nodes('//p:QueryPlan/p:ParameterList/p:ColumnReference') AS q(n)
		OPTION (RECOMPILE);

		RAISERROR(N'Getting conversion info', 0, 1) WITH NOWAIT;
		WITH XMLNAMESPACES ( 'http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p )
		INSERT #conversion_info ( query_hash, sql_handle, proc_name, expression )
		SELECT      DISTINCT
		            qp.query_hash,
		            qp.sql_handle,
		            b.proc_or_function_name AS proc_name,
		            qq.c.value('@Expression', 'NVARCHAR(4000)') AS expression
		FROM        #query_plan AS qp
		   JOIN     #working_warnings AS b
           ON (b.query_hash = qp.query_hash AND b.proc_or_function_name = 'adhoc')
		   OR (b.sql_handle = qp.sql_handle AND b.proc_or_function_name <> 'adhoc')
		CROSS APPLY qp.query_plan.nodes('//p:QueryPlan/p:Warnings/p:PlanAffectingConvert') AS qq(c)
		WHERE       qq.c.exist('@ConvertIssue[.="Seek Plan"]') = 1
		            AND b.implicit_conversions = 1
		OPTION (RECOMPILE);

		RAISERROR(N'Parsing conversion info', 0, 1) WITH NOWAIT;
		INSERT #stored_proc_info ( sql_handle, query_hash, proc_name, variable_name, variable_datatype, converted_column_name, column_name, converted_to, compile_time_value )
		SELECT ci.sql_handle,
		       ci.query_hash,
		       ci.proc_name,
		       CASE WHEN ci.at_charindex > 0
		                 AND ci.bracket_charindex > 0 
					THEN SUBSTRING(ci.expression, ci.at_charindex, ci.bracket_charindex)
		            ELSE N'**no_variable**'
		       END AS variable_name,
			   N'**no_variable**' AS variable_datatype,
		       CASE WHEN ci.at_charindex = 0
		                 AND ci.comma_charindex > 0
		                 AND ci.second_comma_charindex > 0 
					THEN SUBSTRING(ci.expression, ci.comma_charindex, ci.second_comma_charindex)
		            ELSE N'**no_column**'
		       END AS converted_column_name,
		       CASE WHEN ci.at_charindex = 0
		                 AND ci.equal_charindex > 0 
						 AND ci.convert_implicit_charindex = 0
					THEN SUBSTRING(ci.expression, ci.equal_charindex, 4000)
					WHEN ci.at_charindex = 0
		                 AND (ci.equal_charindex -1) > 0 
						 AND ci.convert_implicit_charindex > 0
					THEN SUBSTRING(ci.expression, 0, ci.equal_charindex -1)
		            WHEN ci.at_charindex > 0
		                 AND ci.comma_charindex > 0
		                 AND ci.second_comma_charindex > 0 
					THEN SUBSTRING(ci.expression, ci.comma_charindex, ci.second_comma_charindex)
		            ELSE N'**no_column **'
		       END AS column_name,
		       CASE WHEN ci.paren_charindex > 0
		                 AND ci.comma_paren_charindex > 0 
					THEN SUBSTRING(ci.expression, ci.paren_charindex, ci.comma_paren_charindex)
		       END AS converted_to,
		       CASE WHEN ci.at_charindex = 0
		                 AND ci.convert_implicit_charindex = 0
		                 AND ci.proc_name = 'Statement' 
					THEN SUBSTRING(ci.expression, ci.equal_charindex, 4000)
		            ELSE '**idk_man**'
		       END AS compile_time_value
		FROM   #conversion_info AS ci
		OPTION (RECOMPILE);

		RAISERROR(N'Updating variables inserted procs', 0, 1) WITH NOWAIT;
		UPDATE sp
		SET sp.variable_datatype = vi.variable_datatype,
			sp.compile_time_value = vi.compile_time_value
		FROM   #stored_proc_info AS sp
		JOIN #variable_info AS vi
		ON (sp.proc_name = 'adhoc' AND sp.query_hash = vi.query_hash)
		OR 	(sp.proc_name <> 'adhoc' AND sp.sql_handle = vi.sql_handle)
		AND sp.variable_name = vi.variable_name
		OPTION (RECOMPILE);
		
		
		RAISERROR(N'Inserting variables for other procs', 0, 1) WITH NOWAIT;
		INSERT #stored_proc_info 
				( sql_handle, query_hash, variable_name, variable_datatype, compile_time_value, proc_name )
		SELECT vi.sql_handle, vi.query_hash, vi.variable_name, vi.variable_datatype, vi.compile_time_value, vi.proc_name
		FROM #variable_info AS vi
		WHERE NOT EXISTS
		(
			SELECT * 
			FROM   #stored_proc_info AS sp
			WHERE (sp.proc_name = 'adhoc' AND sp.query_hash = vi.query_hash)
			OR 	(sp.proc_name <> 'adhoc' AND sp.sql_handle = vi.sql_handle)
		)
		OPTION (RECOMPILE);
		
		RAISERROR(N'Updating procs', 0, 1) WITH NOWAIT;
		UPDATE s
		SET    s.variable_datatype = CASE WHEN s.variable_datatype LIKE '%(%)%' 
                                          THEN LEFT(s.variable_datatype, CHARINDEX('(', s.variable_datatype) - 1)
										  ELSE s.variable_datatype
		                             END,
		       s.converted_to = CASE WHEN s.converted_to LIKE '%(%)%' 
                                     THEN LEFT(s.converted_to, CHARINDEX('(', s.converted_to) - 1)
		                             ELSE s.converted_to
		                        END,
			   s.compile_time_value = CASE WHEN s.compile_time_value LIKE '%(%)%' 
                                           THEN SUBSTRING(s.compile_time_value, 
														  CHARINDEX('(', s.compile_time_value) + 1,
														  CHARINDEX(')', s.compile_time_value) - 1 - CHARINDEX('(', s.compile_time_value)
														  )
											WHEN variable_datatype NOT IN ('bit', 'tinyint', 'smallint', 'int', 'bigint') 
												AND s.variable_datatype NOT LIKE '%binary%' 
												AND s.compile_time_value NOT LIKE 'N''%'''
												AND s.compile_time_value NOT LIKE '''%''' 
                                                AND s.compile_time_value <> s.column_name
                                                AND s.compile_time_value <> '**idk_man**'
                                                THEN QUOTENAME(compile_time_value, '''')
									ELSE s.compile_time_value 
									  END
		FROM   #stored_proc_info AS s
		OPTION (RECOMPILE);

		
		RAISERROR(N'Updating SET options', 0, 1) WITH NOWAIT;
		WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
		UPDATE s
		SET set_options = set_options.ansi_set_options
		FROM #stored_proc_info AS s
		JOIN (
				SELECT  x.sql_handle,
						N'SET ANSI_NULLS ' + CASE WHEN [ANSI_NULLS] = 'true' THEN N'ON ' ELSE N'OFF ' END + NCHAR(10) +
						N'SET ANSI_PADDING ' + CASE WHEN [ANSI_PADDING] = 'true' THEN N'ON ' ELSE N'OFF ' END + NCHAR(10) +
						N'SET ANSI_WARNINGS ' + CASE WHEN [ANSI_WARNINGS] = 'true' THEN N'ON ' ELSE N'OFF ' END + NCHAR(10) +
						N'SET ARITHABORT ' + CASE WHEN [ARITHABORT] = 'true' THEN N'ON ' ELSE N' OFF ' END + NCHAR(10) +
						N'SET CONCAT_NULL_YIELDS_NULL ' + CASE WHEN [CONCAT_NULL_YIELDS_NULL] = 'true' THEN N'ON ' ELSE N'OFF ' END + NCHAR(10) +
						N'SET NUMERIC_ROUNDABORT ' + CASE WHEN [NUMERIC_ROUNDABORT] = 'true' THEN N'ON ' ELSE N'OFF ' END + NCHAR(10) +
						N'SET QUOTED_IDENTIFIER ' + CASE WHEN [QUOTED_IDENTIFIER] = 'true' THEN N'ON ' ELSE N'OFF ' + NCHAR(10) END AS [ansi_set_options]
				FROM (
					SELECT
						s.sql_handle,
						so.o.value('@ANSI_NULLS', 'NVARCHAR(20)') AS [ANSI_NULLS],
						so.o.value('@ANSI_PADDING', 'NVARCHAR(20)') AS [ANSI_PADDING],
						so.o.value('@ANSI_WARNINGS', 'NVARCHAR(20)') AS [ANSI_WARNINGS],
						so.o.value('@ARITHABORT', 'NVARCHAR(20)') AS [ARITHABORT],
						so.o.value('@CONCAT_NULL_YIELDS_NULL', 'NVARCHAR(20)') AS [CONCAT_NULL_YIELDS_NULL],
						so.o.value('@NUMERIC_ROUNDABORT', 'NVARCHAR(20)') AS [NUMERIC_ROUNDABORT],
						so.o.value('@QUOTED_IDENTIFIER', 'NVARCHAR(20)') AS [QUOTED_IDENTIFIER]
					FROM #statements AS s
					CROSS APPLY s.statement.nodes('//p:StatementSetOptions') AS so(o)
				   ) AS x
		) AS set_options ON set_options.sql_handle = s.sql_handle
		OPTION(RECOMPILE);


		RAISERROR(N'Updating conversion XML', 0, 1) WITH NOWAIT;
		WITH precheck AS (
		SELECT spi.sql_handle,
			   spi.proc_name,
					(SELECT CASE WHEN spi.proc_name <> 'Statement' 
						   THEN N'The stored procedure ' + spi.proc_name 
						   ELSE N'This ad hoc statement' 
					  END
					+ N' had the following implicit conversions: '
					+ CHAR(10)
					+ STUFF((
						SELECT DISTINCT 
								@cr + @lf
								+ CASE WHEN spi2.variable_name <> N'**no_variable**'
									   THEN N'The variable '
									   WHEN spi2.variable_name = N'**no_variable**' AND (spi2.column_name = spi2.converted_column_name OR spi2.column_name LIKE '%CONVERT_IMPLICIT%')
									   THEN N'The compiled value '
									   WHEN spi2.column_name LIKE '%Expr%'
									   THEN 'The expression '
									   ELSE N'The column '
								  END 
								+ CASE WHEN spi2.variable_name <> N'**no_variable**'
									   THEN spi2.variable_name
									   WHEN spi2.variable_name = N'**no_variable**' AND (spi2.column_name = spi2.converted_column_name OR spi2.column_name LIKE '%CONVERT_IMPLICIT%')
									   THEN spi2.compile_time_value
		
									   ELSE spi2.column_name
								  END 
								+ N' has a data type of '
								+ CASE WHEN spi2.variable_datatype = N'**no_variable**' THEN spi2.converted_to
									   ELSE spi2.variable_datatype 
								  END
								+ N' which caused implicit conversion on the column '
								+ CASE WHEN spi2.column_name LIKE N'%CONVERT_IMPLICIT%'
									   THEN spi2.converted_column_name
									   WHEN spi2.column_name = N'**no_column**'
									   THEN spi2.converted_column_name
									   WHEN spi2.converted_column_name = N'**no_column**'
									   THEN spi2.column_name
									   WHEN spi2.column_name <> spi2.converted_column_name
									   THEN spi2.converted_column_name
									   ELSE spi2.column_name
								  END
								+ CASE WHEN spi2.variable_name = N'**no_variable**' AND (spi2.column_name = spi2.converted_column_name OR spi2.column_name LIKE '%CONVERT_IMPLICIT%')
									   THEN N''
									   WHEN spi2.column_name LIKE '%Expr%'
									   THEN N''
									   WHEN spi2.compile_time_value NOT IN ('**declared in proc**', '**idk_man**')
									   AND spi2.compile_time_value <> spi2.column_name
									   THEN ' with the value ' + RTRIM(spi2.compile_time_value)
									ELSE N''
								 END 
								+ '.'
						FROM #stored_proc_info AS spi2
						WHERE spi.sql_handle = spi2.sql_handle
						FOR XML PATH(N''), TYPE).value(N'.[1]', N'NVARCHAR(MAX)'), 1, 1, N'')
					AS [processing-instruction(ClickMe)] FOR XML PATH(''), TYPE )
					AS implicit_conversion_info
		FROM #stored_proc_info AS spi
		GROUP BY spi.sql_handle, spi.proc_name
		)
		UPDATE b
        SET    b.implicit_conversion_info = pk.implicit_conversion_info
        FROM   #working_warnings AS b
        JOIN   precheck AS pk
        ON pk.sql_handle = b.sql_handle
        OPTION (RECOMPILE);

		RAISERROR(N'Updating cached parameter XML for procs', 0, 1) WITH NOWAIT;
		WITH precheck AS (
		SELECT spi.sql_handle,
			   spi.proc_name,
			   (SELECT set_options
					+ @cr + @lf
					+ @cr + @lf
					+ N'EXEC ' 
					+ spi.proc_name 
					+ N' '
					+ STUFF((
						SELECT DISTINCT N', ' 
								+ CASE WHEN spi2.variable_name <> N'**no_variable**' AND spi2.compile_time_value <> N'**idk_man**'
										THEN spi2.variable_name + N' = '
										ELSE @cr + @lf + N' We could not find any cached parameter values for this stored proc. ' 
								  END
								+ CASE WHEN spi2.variable_name = N'**no_variable**' OR spi2.compile_time_value = N'**idk_man**'
									   THEN @cr + @lf + N' Possible reasons include declared variables inside the procedure, recompile hints, etc. '
									   WHEN spi2.compile_time_value = N'NULL' 
									   THEN spi2.compile_time_value 
									   ELSE RTRIM(spi2.compile_time_value)
								  END
						FROM #stored_proc_info AS spi2
						WHERE spi.sql_handle = spi2.sql_handle
						AND spi2.proc_name <> N'Statement'
						FOR XML PATH(N''), TYPE).value(N'.[1]', N'NVARCHAR(MAX)'), 1, 1, N'')
					AS [processing-instruction(ClickMe)] FOR XML PATH(''), TYPE )
					AS cached_execution_parameters
		FROM #stored_proc_info AS spi
		GROUP BY spi.sql_handle, spi.proc_name, set_options
		) 
		UPDATE b
		SET b.cached_execution_parameters = pk.cached_execution_parameters
        FROM   #working_warnings AS b
        JOIN   precheck AS pk
        ON pk.sql_handle = b.sql_handle
		WHERE b.proc_or_function_name <> N'Statement'
        OPTION (RECOMPILE);


	RAISERROR(N'Updating cached parameter XML for statements', 0, 1) WITH NOWAIT;
	WITH precheck AS (
	SELECT spi.sql_handle,
			   spi.proc_name,
		   (SELECT 
				set_options
				+ @cr + @lf
				+ @cr + @lf
				+ N' See QueryText column for full query text'
				+ @cr + @lf
				+ @cr + @lf
				+ STUFF((
					SELECT DISTINCT N', ' 
							+ CASE WHEN spi2.variable_name <> N'**no_variable**' AND spi2.compile_time_value <> N'**idk_man**'
									THEN spi2.variable_name + N' = '
									ELSE + @cr + @lf + N' We could not find any cached parameter values for this stored proc. ' 
							  END
							+ CASE WHEN spi2.variable_name = N'**no_variable**' OR spi2.compile_time_value = N'**idk_man**'
								   THEN + @cr + @lf + N' Possible reasons include declared variables inside the procedure, recompile hints, etc. '
								   WHEN spi2.compile_time_value = N'NULL' 
								   THEN spi2.compile_time_value 
								   ELSE RTRIM(spi2.compile_time_value)
							  END
					FROM #stored_proc_info AS spi2
					WHERE spi.sql_handle = spi2.sql_handle
					AND spi2.proc_name = N'Statement'
					AND spi2.variable_name NOT LIKE N'%msparam%'
					FOR XML PATH(N''), TYPE).value(N'.[1]', N'NVARCHAR(MAX)'), 1, 1, N'')
				AS [processing-instruction(ClickMe)] FOR XML PATH(''), TYPE )
				AS cached_execution_parameters
	FROM #stored_proc_info AS spi
	GROUP BY spi.sql_handle, spi.proc_name, spi.set_options
	) 
	UPDATE b
	SET b.cached_execution_parameters = pk.cached_execution_parameters
    FROM   #working_warnings AS b
    JOIN   precheck AS pk
    ON pk.sql_handle = b.sql_handle
	WHERE b.proc_or_function_name = N'Statement'
    OPTION (RECOMPILE);


RAISERROR(N'Filling in implicit conversion info', 0, 1) WITH NOWAIT;
UPDATE b
SET    b.implicit_conversion_info = CASE WHEN b.implicit_conversion_info IS NULL 
									OR CONVERT(NVARCHAR(MAX), b.implicit_conversion_info) = N''
									THEN N'<?NoNeedToClickMe -- N/A --?>'
                                    ELSE b.implicit_conversion_info
                                    END,
       b.cached_execution_parameters = CASE WHEN b.cached_execution_parameters IS NULL 
									   OR CONVERT(NVARCHAR(MAX), b.cached_execution_parameters) = N''
									   THEN N'<?NoNeedToClickMe -- N/A --?>'
                                       ELSE b.cached_execution_parameters
                                       END
FROM   #working_warnings AS b
OPTION (RECOMPILE);

/*End implicit conversion and parameter info*/

/*Begin Missing Index*/
IF EXISTS ( SELECT 1/0 
            FROM #working_warnings AS ww 
            WHERE ww.missing_index_count > 0
		    OR ww.index_spool_cost > 0
		    OR ww.index_spool_rows > 0 )
		   
		BEGIN	
	
		RAISERROR(N'Inserting to #missing_index_xml', 0, 1) WITH NOWAIT;
		WITH XMLNAMESPACES ( 'http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p )
		INSERT 	#missing_index_xml
		SELECT qp.query_hash,
		       qp.sql_handle,
		       c.mg.value('@Impact', 'FLOAT') AS Impact,
			   c.mg.query('.') AS cmg
		FROM   #query_plan AS qp
		CROSS APPLY qp.query_plan.nodes('//p:MissingIndexes/p:MissingIndexGroup') AS c(mg)
		WHERE  qp.query_hash IS NOT NULL
		AND c.mg.value('@Impact', 'FLOAT') > 70.0
		OPTION (RECOMPILE);

		RAISERROR(N'Inserting to #missing_index_schema', 0, 1) WITH NOWAIT;		
		WITH XMLNAMESPACES ( 'http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p )
		INSERT #missing_index_schema
		SELECT mix.query_hash, mix.sql_handle, mix.impact,
		       c.mi.value('@Database', 'NVARCHAR(128)'),
		       c.mi.value('@Schema', 'NVARCHAR(128)'),
		       c.mi.value('@Table', 'NVARCHAR(128)'),
			   c.mi.query('.')
		FROM #missing_index_xml AS mix
		CROSS APPLY mix.index_xml.nodes('//p:MissingIndex') AS c(mi)
		OPTION (RECOMPILE);
		
		RAISERROR(N'Inserting to #missing_index_usage', 0, 1) WITH NOWAIT;
		WITH XMLNAMESPACES ( 'http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p )
		INSERT #missing_index_usage
		SELECT ms.query_hash, ms.sql_handle, ms.impact, ms.database_name, ms.schema_name, ms.table_name,
				c.cg.value('@Usage', 'NVARCHAR(128)'),
				c.cg.query('.')
		FROM #missing_index_schema ms
		CROSS APPLY ms.index_xml.nodes('//p:ColumnGroup') AS c(cg)
		OPTION (RECOMPILE);
		
		RAISERROR(N'Inserting to #missing_index_detail', 0, 1) WITH NOWAIT;
		WITH XMLNAMESPACES ( 'http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p )
		INSERT #missing_index_detail
		SELECT miu.query_hash,
		       miu.sql_handle,
		       miu.impact,
		       miu.database_name,
		       miu.schema_name,
		       miu.table_name,
		       miu.usage,
		       c.c.value('@Name', 'NVARCHAR(128)')
		FROM #missing_index_usage AS miu
		CROSS APPLY miu.index_xml.nodes('//p:Column') AS c(c)
		OPTION (RECOMPILE);
		
		RAISERROR(N'Inserting to #missing_index_pretty', 0, 1) WITH NOWAIT;
		INSERT #missing_index_pretty
		SELECT DISTINCT m.query_hash, m.sql_handle, m.impact, m.database_name, m.schema_name, m.table_name
		, STUFF((   SELECT DISTINCT N', ' + ISNULL(m2.column_name, '') AS column_name
		                 FROM   #missing_index_detail AS m2
		                 WHERE  m2.usage = 'EQUALITY'
						 AND m.query_hash = m2.query_hash
						 AND m.sql_handle = m2.sql_handle
						 AND m.impact = m2.impact
						 AND m.database_name = m2.database_name
						 AND m.schema_name = m2.schema_name
						 AND m.table_name = m2.table_name
		                 FOR XML PATH(N''), TYPE ).value(N'.[1]', N'NVARCHAR(MAX)'), 1, 2, N'') AS equality
		, STUFF((   SELECT DISTINCT N', ' + ISNULL(m2.column_name, '') AS column_name
		                 FROM   #missing_index_detail AS m2
		                 WHERE  m2.usage = 'INEQUALITY'
						 AND m.query_hash = m2.query_hash
						 AND m.sql_handle = m2.sql_handle
						 AND m.impact = m2.impact
						 AND m.database_name = m2.database_name
						 AND m.schema_name = m2.schema_name
						 AND m.table_name = m2.table_name
		                 FOR XML PATH(N''), TYPE ).value(N'.[1]', N'NVARCHAR(MAX)'), 1, 2, N'') AS inequality
		, STUFF((   SELECT DISTINCT N', ' + ISNULL(m2.column_name, '') AS column_name
		                 FROM   #missing_index_detail AS m2
		                 WHERE  m2.usage = 'INCLUDE'
						 AND m.query_hash = m2.query_hash
						 AND m.sql_handle = m2.sql_handle
						 AND m.impact = m2.impact
						 AND m.database_name = m2.database_name
						 AND m.schema_name = m2.schema_name
						 AND m.table_name = m2.table_name
		                 FOR XML PATH(N''), TYPE ).value(N'.[1]', N'NVARCHAR(MAX)'), 1, 2, N'') AS [include],
		0 AS is_spool
		FROM #missing_index_detail AS m
		GROUP BY m.query_hash, m.sql_handle, m.impact, m.database_name, m.schema_name, m.table_name
		OPTION (RECOMPILE);

		RAISERROR(N'Inserting to #index_spool_ugly', 0, 1) WITH NOWAIT;
		WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
		INSERT #index_spool_ugly 
		        (query_hash, sql_handle, impact, database_name, schema_name, table_name, equality, inequality, include)
		SELECT r.query_hash, 
		       r.sql_handle,                                                                               
		       (c.n.value('@EstimateIO', 'FLOAT') + (c.n.value('@EstimateCPU', 'FLOAT'))) 
					/ ( 1 * NULLIF(ww.query_cost, 0)) * 100 AS impact, 
			   o.n.value('@Database', 'NVARCHAR(128)') AS output_database, 
			   o.n.value('@Schema', 'NVARCHAR(128)') AS output_schema, 
			   o.n.value('@Table', 'NVARCHAR(128)') AS output_table, 
		       k.n.value('@Column', 'NVARCHAR(128)') AS range_column,
			   e.n.value('@Column', 'NVARCHAR(128)') AS expression_column,
			   o.n.value('@Column', 'NVARCHAR(128)') AS output_column
		FROM #relop AS r
		JOIN #working_warnings AS ww
		ON ww.query_hash = r.query_hash
		CROSS APPLY r.relop.nodes('/p:RelOp') AS c(n)
		CROSS APPLY r.relop.nodes('/p:RelOp/p:OutputList/p:ColumnReference') AS o(n)
		OUTER APPLY r.relop.nodes('/p:RelOp/p:Spool/p:SeekPredicateNew/p:SeekKeys/p:Prefix/p:RangeColumns/p:ColumnReference') AS k(n)
		OUTER APPLY r.relop.nodes('/p:RelOp/p:Spool/p:SeekPredicateNew/p:SeekKeys/p:Prefix/p:RangeExpressions/p:ColumnReference') AS e(n)
		WHERE  r.relop.exist('/p:RelOp[@PhysicalOp="Index Spool" and @LogicalOp="Eager Spool"]') = 1
		
		RAISERROR(N'Inserting to spools to #missing_index_pretty', 0, 1) WITH NOWAIT;
		INSERT #missing_index_pretty
			(query_hash, sql_handle, impact, database_name, schema_name, table_name, equality, inequality, include, is_spool)
		SELECT DISTINCT 
		       isu.query_hash,
		       isu.sql_handle,
		       isu.impact,
		       isu.database_name,
		       isu.schema_name,
		       isu.table_name
			   , STUFF((   SELECT DISTINCT N', ' + ISNULL(isu2.equality, '') AS column_name
			   		                 FROM   #index_spool_ugly AS isu2
			   		                 WHERE  isu2.equality IS NOT NULL
			   						 AND isu.query_hash = isu2.query_hash
			   						 AND isu.sql_handle = isu2.sql_handle
			   						 AND isu.impact = isu2.impact
			   						 AND isu.database_name = isu2.database_name
			   						 AND isu.schema_name = isu2.schema_name
			   						 AND isu.table_name = isu2.table_name
			   		                 FOR XML PATH(N''), TYPE ).value(N'.[1]', N'NVARCHAR(MAX)'), 1, 2, N'') AS equality
			   , STUFF((   SELECT DISTINCT N', ' + ISNULL(isu2.inequality, '') AS column_name
			   		                 FROM   #index_spool_ugly AS isu2
			   		                 WHERE  isu2.inequality IS NOT NULL
			   						 AND isu.query_hash = isu2.query_hash
			   						 AND isu.sql_handle = isu2.sql_handle
			   						 AND isu.impact = isu2.impact
			   						 AND isu.database_name = isu2.database_name
			   						 AND isu.schema_name = isu2.schema_name
			   						 AND isu.table_name = isu2.table_name
			   		                 FOR XML PATH(N''), TYPE ).value(N'.[1]', N'NVARCHAR(MAX)'), 1, 2, N'') AS inequality
			   , STUFF((   SELECT DISTINCT N', ' + ISNULL(isu2.include, '') AS column_name
			   		                 FROM   #index_spool_ugly AS isu2
			   		                 WHERE  isu2.include IS NOT NULL
			   						 AND isu.query_hash = isu2.query_hash
			   						 AND isu.sql_handle = isu2.sql_handle
			   						 AND isu.impact = isu2.impact
			   						 AND isu.database_name = isu2.database_name
			   						 AND isu.schema_name = isu2.schema_name
			   						 AND isu.table_name = isu2.table_name
			   		                 FOR XML PATH(N''), TYPE ).value(N'.[1]', N'NVARCHAR(MAX)'), 1, 2, N'') AS include,
			   1 AS is_spool
		FROM #index_spool_ugly AS isu


		RAISERROR(N'Updating missing index information', 0, 1) WITH NOWAIT;
		WITH missing AS (
		SELECT DISTINCT
		       mip.query_hash,
		       mip.sql_handle, 
			   N'<MissingIndexes><![CDATA['
			   + CHAR(10) + CHAR(13)
			   + STUFF((   SELECT CHAR(10) + CHAR(13) + ISNULL(mip2.details, '') AS details
		                   FROM   #missing_index_pretty AS mip2
						   WHERE mip.query_hash = mip2.query_hash
						   AND mip.sql_handle = mip2.sql_handle
						   GROUP BY mip2.details
		                   ORDER BY MAX(mip2.impact) DESC
						   FOR XML PATH(N''), TYPE ).value(N'.[1]', N'NVARCHAR(MAX)'), 1, 2, N'') 
			   + CHAR(10) + CHAR(13)
			   + N']]></MissingIndexes>'  
			   AS full_details
		FROM #missing_index_pretty AS mip
		GROUP BY mip.query_hash, mip.sql_handle, mip.impact
						)
		UPDATE ww
			SET ww.missing_indexes = m.full_details
		FROM #working_warnings AS ww
		JOIN missing AS m
		ON m.sql_handle = ww.sql_handle
		OPTION (RECOMPILE);

	RAISERROR(N'Filling in missing index blanks', 0, 1) WITH NOWAIT;
	UPDATE ww
	SET ww.missing_indexes = 
		CASE WHEN ww.missing_indexes IS NULL 
			 THEN '<?NoNeedToClickMe -- N/A --?>' 
			 ELSE ww.missing_indexes 
		END
	FROM #working_warnings AS ww
	OPTION (RECOMPILE);

END
/*End Missing Index*/

RAISERROR(N'General query dispositions: frequent executions, long running, etc.', 0, 1) WITH NOWAIT;

WITH XMLNAMESPACES('http://schemas.microsoft.com/sqlserver/2004/07/showplan' AS p)
UPDATE b
SET    b.frequent_execution = CASE WHEN wm.xpm > @execution_threshold THEN 1 END ,
	   b.near_parallel = CASE WHEN b.query_cost BETWEEN @ctp * (1 - (@ctp_threshold_pct / 100.0)) AND @ctp THEN 1 END,
	   b.long_running = CASE WHEN wm.avg_duration > @long_running_query_warning_seconds THEN 1
						     WHEN wm.max_duration > @long_running_query_warning_seconds THEN 1
                             WHEN wm.avg_cpu_time > @long_running_query_warning_seconds THEN 1
                             WHEN wm.max_cpu_time > @long_running_query_warning_seconds THEN 1 END,
	   b.is_key_lookup_expensive = CASE WHEN b.query_cost >= (@ctp / 2) AND b.key_lookup_cost >= b.query_cost * .5 THEN 1 END,
	   b.is_sort_expensive = CASE WHEN b.query_cost >= (@ctp / 2) AND b.sort_cost >= b.query_cost * .5 THEN 1 END,
	   b.is_remote_query_expensive = CASE WHEN b.remote_query_cost >= b.query_cost * .05 THEN 1 END,
	   b.is_unused_grant = CASE WHEN percent_memory_grant_used <= @memory_grant_warning_percent AND min_query_max_used_memory > @min_memory_per_query THEN 1 END,
	   b.long_running_low_cpu = CASE WHEN wm.avg_duration > wm.avg_cpu_time * 4 AND avg_cpu_time < 500. THEN 1 END,
	   b.low_cost_high_cpu = CASE WHEN b.query_cost < 10 AND wm.avg_cpu_time > 5000. THEN 1 END,
	   b.is_spool_expensive = CASE WHEN b.query_cost > (@ctp / 2) AND b.index_spool_cost >= b.query_cost * .1 THEN 1 END,
	   b.is_spool_more_rows = CASE WHEN b.index_spool_rows >= wm.min_rowcount THEN 1 END,
	   b.is_bad_estimate = CASE WHEN wm.avg_rowcount > 0 AND (b.estimated_rows * 1000 < wm.avg_rowcount OR b.estimated_rows > wm.avg_rowcount * 1000) THEN 1 END,
	   b.is_big_log = CASE WHEN wm.avg_log_bytes_used >= (@log_size_mb / 2.) THEN 1 END,
	   b.is_big_tempdb = CASE WHEN wm.avg_tempdb_space_used >= (@avg_tempdb_data_file / 2.) THEN 1 END
FROM #working_warnings AS b
JOIN #working_metrics AS wm
ON b.plan_id = wm.plan_id
AND b.query_id = wm.query_id
JOIN #working_plan_text AS wpt
ON b.plan_id = wpt.plan_id
AND b.query_id = wpt.query_id
OPTION (RECOMPILE);


RAISERROR('Populating Warnings column', 0, 1) WITH NOWAIT;
/* Populate warnings */
UPDATE b
SET    b.warnings = SUBSTRING(
                  CASE WHEN b.warning_no_join_predicate = 1 THEN ', No Join Predicate' ELSE '' END +
                  CASE WHEN b.compile_timeout = 1 THEN ', Compilation Timeout' ELSE '' END +
                  CASE WHEN b.compile_memory_limit_exceeded = 1 THEN ', Compile Memory Limit Exceeded' ELSE '' END +
                  CASE WHEN b.is_forced_plan = 1 THEN ', Forced Plan' ELSE '' END +
                  CASE WHEN b.is_forced_parameterized = 1 THEN ', Forced Parameterization' ELSE '' END +
                  CASE WHEN b.unparameterized_query = 1 THEN ', Unparameterized Query' ELSE '' END +
                  CASE WHEN b.missing_index_count > 0 THEN ', Missing Indexes (' + CAST(b.missing_index_count AS NVARCHAR(3)) + ')' ELSE '' END +
                  CASE WHEN b.unmatched_index_count > 0 THEN ', Unmatched Indexes (' + CAST(b.unmatched_index_count AS NVARCHAR(3)) + ')' ELSE '' END +                  
                  CASE WHEN b.is_cursor = 1 THEN ', Cursor' 
							+ CASE WHEN b.is_optimistic_cursor = 1 THEN '; optimistic' ELSE '' END
							+ CASE WHEN b.is_forward_only_cursor = 0 THEN '; not forward only' ELSE '' END
							+ CASE WHEN b.is_cursor_dynamic = 1 THEN '; dynamic' ELSE '' END
                            + CASE WHEN b.is_fast_forward_cursor = 1 THEN '; fast forward' ELSE '' END			
				  ELSE '' END +
                  CASE WHEN b.is_parallel = 1 THEN ', Parallel' ELSE '' END +
                  CASE WHEN b.near_parallel = 1 THEN ', Nearly Parallel' ELSE '' END +
                  CASE WHEN b.frequent_execution = 1 THEN ', Frequent Execution' ELSE '' END +
                  CASE WHEN b.plan_warnings = 1 THEN ', Plan Warnings' ELSE '' END +
                  CASE WHEN b.parameter_sniffing = 1 THEN ', Parameter Sniffing' ELSE '' END +
                  CASE WHEN b.long_running = 1 THEN ', Long Running Query' ELSE '' END +
                  CASE WHEN b.downlevel_estimator = 1 THEN ', Downlevel CE' ELSE '' END +
                  CASE WHEN b.implicit_conversions = 1 THEN ', Implicit Conversions' ELSE '' END +
                  CASE WHEN b.plan_multiple_plans = 1 THEN ', Multiple Plans' ELSE '' END +
                  CASE WHEN b.is_trivial = 1 THEN ', Trivial Plans' ELSE '' END +
				  CASE WHEN b.is_forced_serial = 1 THEN ', Forced Serialization' ELSE '' END +
				  CASE WHEN b.is_key_lookup_expensive = 1 THEN ', Expensive Key Lookup' ELSE '' END +
				  CASE WHEN b.is_remote_query_expensive = 1 THEN ', Expensive Remote Query' ELSE '' END + 
				  CASE WHEN b.trace_flags_session IS NOT NULL THEN ', Session Level Trace Flag(s) Enabled: ' + b.trace_flags_session ELSE '' END +
				  CASE WHEN b.is_unused_grant = 1 THEN ', Unused Memory Grant' ELSE '' END +
				  CASE WHEN b.function_count > 0 THEN ', Calls ' + CONVERT(VARCHAR(10), b.function_count) + ' function(s)' ELSE '' END + 
				  CASE WHEN b.clr_function_count > 0 THEN ', Calls ' + CONVERT(VARCHAR(10), b.clr_function_count) + ' CLR function(s)' ELSE '' END + 
				  CASE WHEN b.is_table_variable = 1 THEN ', Table Variables' ELSE '' END +
				  CASE WHEN b.no_stats_warning = 1 THEN ', Columns With No Statistics' ELSE '' END +
				  CASE WHEN b.relop_warnings = 1 THEN ', Operator Warnings' ELSE '' END  + 
				  CASE WHEN b.is_table_scan = 1 THEN ', Table Scans' ELSE '' END  + 
				  CASE WHEN b.backwards_scan = 1 THEN ', Backwards Scans' ELSE '' END  + 
				  CASE WHEN b.forced_index = 1 THEN ', Forced Indexes' ELSE '' END  + 
				  CASE WHEN b.forced_seek = 1 THEN ', Forced Seeks' ELSE '' END  + 
				  CASE WHEN b.forced_scan = 1 THEN ', Forced Scans' ELSE '' END  +
				  CASE WHEN b.columnstore_row_mode = 1 THEN ', ColumnStore Row Mode ' ELSE '' END +
				  CASE WHEN b.is_computed_scalar = 1 THEN ', Computed Column UDF ' ELSE '' END  +
				  CASE WHEN b.is_sort_expensive = 1 THEN ', Expensive Sort' ELSE '' END +
				  CASE WHEN b.is_computed_filter = 1 THEN ', Filter UDF' ELSE '' END +
				  CASE WHEN b.index_ops >= 5 THEN ', >= 5 Indexes Modified' ELSE '' END +
				  CASE WHEN b.is_row_level = 1 THEN ', Row Level Security' ELSE '' END + 
				  CASE WHEN b.is_spatial = 1 THEN ', Spatial Index' ELSE '' END + 
				  CASE WHEN b.index_dml = 1 THEN ', Index DML' ELSE '' END +
				  CASE WHEN b.table_dml = 1 THEN ', Table DML' ELSE '' END +
				  CASE WHEN b.low_cost_high_cpu = 1 THEN ', Low Cost High CPU' ELSE '' END + 
				  CASE WHEN b.long_running_low_cpu = 1 THEN + ', Long Running With Low CPU' ELSE '' END +
				  CASE WHEN b.stale_stats = 1 THEN + ', Statistics used have > 100k modifications in the last 7 days' ELSE '' END +
				  CASE WHEN b.is_adaptive = 1 THEN + ', Adaptive Joins' ELSE '' END	+
				  CASE WHEN b.is_spool_expensive = 1 THEN + ', Expensive Index Spool' ELSE '' END +
				  CASE WHEN b.is_spool_more_rows = 1 THEN + ', Large Index Row Spool' ELSE '' END +
				  CASE WHEN b.is_bad_estimate = 1 THEN + ', Row estimate mismatch' ELSE '' END +
				  CASE WHEN b.is_big_log = 1 THEN + ', High log use' ELSE '' END +
				  CASE WHEN b.is_big_tempdb = 1 THEN ', High tempdb use' ELSE '' END +
				  CASE WHEN b.is_paul_white_electric = 1 THEN ', SWITCH!' ELSE '' END + 
				  CASE WHEN b.is_row_goal = 1 THEN ', Row Goals' ELSE '' END + 
				  CASE WHEN b.is_mstvf = 1 THEN ', MSTVFs' ELSE '' END + 
				  CASE WHEN b.is_mm_join = 1 THEN ', Many to Many Merge' ELSE '' END + 
                  CASE WHEN b.is_nonsargable = 1 THEN ', non-SARGables' ELSE '' END
                  , 2, 200000) 
FROM #working_warnings b
OPTION (RECOMPILE);


END;
END TRY
BEGIN CATCH
        RAISERROR (N'Failure generating warnings.', 0,1) WITH NOWAIT;

        IF @sql_select IS NOT NULL
        BEGIN
            SET @msg = N'Last @sql_select: ' + @sql_select;
            RAISERROR(@msg, 0, 1) WITH NOWAIT;
        END;

        SELECT    @msg = @DatabaseName + N' database failed to process. ' + ERROR_MESSAGE(), @error_severity = ERROR_SEVERITY(), @error_state = ERROR_STATE();
        RAISERROR (@msg, @error_severity, @error_state) WITH NOWAIT;
        
        
        WHILE @@TRANCOUNT > 0 
            ROLLBACK;

        RETURN;
END CATCH;


BEGIN TRY 
BEGIN 

RAISERROR(N'Checking for parameter sniffing symptoms', 0, 1) WITH NOWAIT;

UPDATE b
SET b.parameter_sniffing_symptoms = 
CASE WHEN b.count_executions < 2 THEN 'Too few executions to compare (< 2).'
	ELSE													
	SUBSTRING(  
				/*Duration*/
				CASE WHEN (b.min_duration * 100) < (b.avg_duration) THEN ', Fast sometimes' ELSE '' END +
				CASE WHEN (b.max_duration) > (b.avg_duration * 100) THEN ', Slow sometimes' ELSE '' END +
				CASE WHEN (b.last_duration * 100) < (b.avg_duration)  THEN ', Fast last run' ELSE '' END +
				CASE WHEN (b.last_duration) > (b.avg_duration * 100) THEN ', Slow last run' ELSE '' END +
				/*CPU*/
				CASE WHEN (b.min_cpu_time / b.avg_dop) * 100 < (b.avg_cpu_time / b.avg_dop) THEN ', Low CPU sometimes' ELSE '' END +
				CASE WHEN (b.max_cpu_time / b.max_dop) > (b.avg_cpu_time / b.avg_dop) * 100 THEN ', High CPU sometimes' ELSE '' END +
				CASE WHEN (b.last_cpu_time / b.last_dop) * 100 < (b.avg_cpu_time / b.avg_dop)  THEN ', Low CPU last run' ELSE '' END +
				CASE WHEN (b.last_cpu_time / b.last_dop) > (b.avg_cpu_time / b.avg_dop) * 100 THEN ', High CPU last run' ELSE '' END +
				/*Logical Reads*/
				CASE WHEN (b.min_logical_io_reads * 100) < (b.avg_logical_io_reads) THEN ', Low reads sometimes' ELSE '' END +
				CASE WHEN (b.max_logical_io_reads) > (b.avg_logical_io_reads * 100) THEN ', High reads sometimes' ELSE '' END +
				CASE WHEN (b.last_logical_io_reads * 100) < (b.avg_logical_io_reads)  THEN ', Low reads last run' ELSE '' END +
				CASE WHEN (b.last_logical_io_reads) > (b.avg_logical_io_reads * 100) THEN ', High reads last run' ELSE '' END +
				/*Logical Writes*/
				CASE WHEN (b.min_logical_io_writes * 100) < (b.avg_logical_io_writes) THEN ', Low writes sometimes' ELSE '' END +
				CASE WHEN (b.max_logical_io_writes) > (b.avg_logical_io_writes * 100) THEN ', High writes sometimes' ELSE '' END +
				CASE WHEN (b.last_logical_io_writes * 100) < (b.avg_logical_io_writes)  THEN ', Low writes last run' ELSE '' END +
				CASE WHEN (b.last_logical_io_writes) > (b.avg_logical_io_writes * 100) THEN ', High writes last run' ELSE '' END +
				/*Physical Reads*/
				CASE WHEN (b.min_physical_io_reads * 100) < (b.avg_physical_io_reads) THEN ', Low physical reads sometimes' ELSE '' END +
				CASE WHEN (b.max_physical_io_reads) > (b.avg_physical_io_reads * 100) THEN ', High physical reads sometimes' ELSE '' END +
				CASE WHEN (b.last_physical_io_reads * 100) < (b.avg_physical_io_reads)  THEN ', Low physical reads last run' ELSE '' END +
				CASE WHEN (b.last_physical_io_reads) > (b.avg_physical_io_reads * 100) THEN ', High physical reads last run' ELSE '' END +
				/*Memory*/
				CASE WHEN (b.min_query_max_used_memory * 100) < (b.avg_query_max_used_memory) THEN ', Low memory sometimes' ELSE '' END +
				CASE WHEN (b.max_query_max_used_memory) > (b.avg_query_max_used_memory * 100) THEN ', High memory sometimes' ELSE '' END +
				CASE WHEN (b.last_query_max_used_memory * 100) < (b.avg_query_max_used_memory)  THEN ', Low memory last run' ELSE '' END +
				CASE WHEN (b.last_query_max_used_memory) > (b.avg_query_max_used_memory * 100) THEN ', High memory last run' ELSE '' END +
				/*Duration*/
				CASE WHEN b.min_rowcount * 100 < b.avg_rowcount THEN ', Low row count sometimes' ELSE '' END +
				CASE WHEN b.max_rowcount > b.avg_rowcount * 100 THEN ', High row count sometimes' ELSE '' END +
				CASE WHEN b.last_rowcount * 100 < b.avg_rowcount  THEN ', Low row count run' ELSE '' END +
				CASE WHEN b.last_rowcount > b.avg_rowcount * 100 THEN ', High row count last run' ELSE '' END +
				/*DOP*/
				CASE WHEN b.min_dop <> b.max_dop THEN ', Serial sometimes' ELSE '' END +
				CASE WHEN b.min_dop <> b.max_dop AND b.last_dop = 1  THEN ', Serial last run' ELSE '' END +
				CASE WHEN b.min_dop <> b.max_dop AND b.last_dop > 1 THEN ', Parallel last run' ELSE '' END +
				/*tempdb*/
				CASE WHEN b.min_tempdb_space_used * 100 < b.avg_tempdb_space_used THEN ', Low tempdb sometimes' ELSE '' END +
				CASE WHEN b.max_tempdb_space_used > b.avg_tempdb_space_used * 100 THEN ', High tempdb sometimes' ELSE '' END +
				CASE WHEN b.last_tempdb_space_used * 100 < b.avg_tempdb_space_used  THEN ', Low tempdb run' ELSE '' END +
				CASE WHEN b.last_tempdb_space_used > b.avg_tempdb_space_used * 100 THEN ', High tempdb last run' ELSE '' END +
				/*tlog*/
				CASE WHEN b.min_log_bytes_used * 100 < b.avg_log_bytes_used THEN ', Low log use sometimes' ELSE '' END +
				CASE WHEN b.max_log_bytes_used > b.avg_log_bytes_used * 100 THEN ', High log use sometimes' ELSE '' END +
				CASE WHEN b.last_log_bytes_used * 100 < b.avg_log_bytes_used  THEN ', Low log use run' ELSE '' END +
				CASE WHEN b.last_log_bytes_used > b.avg_log_bytes_used * 100 THEN ', High log use last run' ELSE '' END 
	, 2, 200000) 
	END
FROM #working_metrics AS b
OPTION (RECOMPILE);

END;
END TRY
BEGIN CATCH
        RAISERROR (N'Failure analyzing parameter sniffing', 0,1) WITH NOWAIT;

        IF @sql_select IS NOT NULL
        BEGIN
            SET @msg = N'Last @sql_select: ' + @sql_select;
            RAISERROR(@msg, 0, 1) WITH NOWAIT;
        END;

        SELECT    @msg = @DatabaseName + N' database failed to process. ' + ERROR_MESSAGE(), @error_severity = ERROR_SEVERITY(), @error_state = ERROR_STATE();
        RAISERROR (@msg, @error_severity, @error_state) WITH NOWAIT;
        
        
        WHILE @@TRANCOUNT > 0 
            ROLLBACK;

        RETURN;
END CATCH;

BEGIN TRY 

BEGIN 

IF (@Failed = 0 AND @ExportToExcel = 0 AND @SkipXML = 0)
BEGIN

RAISERROR(N'Returning regular results', 0, 1) WITH NOWAIT;

WITH x AS (
SELECT wpt.database_name, ww.query_cost, wm.plan_id, wm.query_id, wm.query_id_all_plan_ids, wpt.query_sql_text, wm.proc_or_function_name, wpt.query_plan_xml, ww.warnings, wpt.pattern, 
	   wm.parameter_sniffing_symptoms, wpt.top_three_waits, ww.missing_indexes, ww.implicit_conversion_info, ww.cached_execution_parameters, wm.count_executions, wm.count_compiles, wm.total_cpu_time, wm.avg_cpu_time,
	   wm.total_duration, wm.avg_duration, wm.total_logical_io_reads, wm.avg_logical_io_reads,
	   wm.total_physical_io_reads, wm.avg_physical_io_reads, wm.total_logical_io_writes, wm.avg_logical_io_writes, wm.total_rowcount, wm.avg_rowcount,
	   wm.total_query_max_used_memory, wm.avg_query_max_used_memory, wm.total_tempdb_space_used, wm.avg_tempdb_space_used,
	   wm.total_log_bytes_used, wm.avg_log_bytes_used, wm.total_num_physical_io_reads, wm.avg_num_physical_io_reads,
	   wm.first_execution_time, wm.last_execution_time, wpt.last_force_failure_reason_desc, wpt.context_settings, ROW_NUMBER() OVER (PARTITION BY wm.plan_id, wm.query_id, wm.last_execution_time ORDER BY wm.plan_id) AS rn
FROM #working_plan_text AS wpt
JOIN #working_warnings AS ww
	ON wpt.plan_id = ww.plan_id
	AND wpt.query_id = ww.query_id
JOIN #working_metrics AS wm
	ON wpt.plan_id = wm.plan_id
	AND wpt.query_id = wm.query_id
)
SELECT *
FROM x
WHERE x.rn = 1
ORDER BY x.last_execution_time
OPTION (RECOMPILE);

END;

IF (@Failed = 1 AND @ExportToExcel = 0 AND @SkipXML = 0)
BEGIN

RAISERROR(N'Returning results for failed queries', 0, 1) WITH NOWAIT;

WITH x AS (
SELECT wpt.database_name, ww.query_cost, wm.plan_id, wm.query_id, wm.query_id_all_plan_ids, wpt.query_sql_text, wm.proc_or_function_name, wpt.query_plan_xml, ww.warnings, wpt.pattern, 
	   wm.parameter_sniffing_symptoms, wpt.last_force_failure_reason_desc, wpt.top_three_waits, ww.missing_indexes, ww.implicit_conversion_info, ww.cached_execution_parameters, 
	   wm.count_executions, wm.count_compiles, wm.total_cpu_time, wm.avg_cpu_time,
	   wm.total_duration, wm.avg_duration, wm.total_logical_io_reads, wm.avg_logical_io_reads,
	   wm.total_physical_io_reads, wm.avg_physical_io_reads, wm.total_logical_io_writes, wm.avg_logical_io_writes, wm.total_rowcount, wm.avg_rowcount,
	   wm.total_query_max_used_memory, wm.avg_query_max_used_memory, wm.total_tempdb_space_used, wm.avg_tempdb_space_used,
	   wm.total_log_bytes_used, wm.avg_log_bytes_used, wm.total_num_physical_io_reads, wm.avg_num_physical_io_reads,
	   wm.first_execution_time, wm.last_execution_time, wpt.context_settings, ROW_NUMBER() OVER (PARTITION BY wm.plan_id, wm.query_id, wm.last_execution_time ORDER BY wm.plan_id) AS rn
FROM #working_plan_text AS wpt
JOIN #working_warnings AS ww
	ON wpt.plan_id = ww.plan_id
	AND wpt.query_id = ww.query_id
JOIN #working_metrics AS wm
	ON wpt.plan_id = wm.plan_id
	AND wpt.query_id = wm.query_id
)
SELECT *
FROM x
WHERE x.rn = 1
ORDER BY x.last_execution_time
OPTION (RECOMPILE);

END;

IF (@ExportToExcel = 1 AND @SkipXML = 0)
BEGIN

RAISERROR(N'Returning results for Excel export', 0, 1) WITH NOWAIT;

UPDATE #working_plan_text
SET query_sql_text = SUBSTRING(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(query_sql_text)),' ','<>'),'><',''),'<>',' '), 1, 31000)
OPTION (RECOMPILE);

WITH x AS (
SELECT wpt.database_name, ww.query_cost, wm.plan_id, wm.query_id, wm.query_id_all_plan_ids, wpt.query_sql_text, wm.proc_or_function_name, ww.warnings, wpt.pattern, 
	   wm.parameter_sniffing_symptoms, wpt.last_force_failure_reason_desc, wpt.top_three_waits, wm.count_executions, wm.count_compiles, wm.total_cpu_time, wm.avg_cpu_time,
	   wm.total_duration, wm.avg_duration, wm.total_logical_io_reads, wm.avg_logical_io_reads,
	   wm.total_physical_io_reads, wm.avg_physical_io_reads, wm.total_logical_io_writes, wm.avg_logical_io_writes, wm.total_rowcount, wm.avg_rowcount,
	   wm.total_query_max_used_memory, wm.avg_query_max_used_memory, wm.total_tempdb_space_used, wm.avg_tempdb_space_used,
	   wm.total_log_bytes_used, wm.avg_log_bytes_used, wm.total_num_physical_io_reads, wm.avg_num_physical_io_reads,
	   wm.first_execution_time, wm.last_execution_time, wpt.context_settings, ROW_NUMBER() OVER (PARTITION BY wm.plan_id, wm.query_id, wm.last_execution_time ORDER BY wm.plan_id) AS rn
FROM #working_plan_text AS wpt
JOIN #working_warnings AS ww
	ON wpt.plan_id = ww.plan_id
	AND wpt.query_id = ww.query_id
JOIN #working_metrics AS wm
	ON wpt.plan_id = wm.plan_id
	AND wpt.query_id = wm.query_id
)
SELECT *
FROM x
WHERE x.rn = 1
ORDER BY x.last_execution_time
OPTION (RECOMPILE);

END;

IF (@ExportToExcel = 0 AND @SkipXML = 1)
BEGIN

RAISERROR(N'Returning results for skipped XML', 0, 1) WITH NOWAIT;

WITH x AS (
SELECT wpt.database_name, wm.plan_id, wm.query_id, wm.query_id_all_plan_ids, wpt.query_sql_text, wpt.query_plan_xml, wpt.pattern, 
	   wm.parameter_sniffing_symptoms, wpt.top_three_waits, wm.count_executions, wm.count_compiles, wm.total_cpu_time, wm.avg_cpu_time,
	   wm.total_duration, wm.avg_duration, wm.total_logical_io_reads, wm.avg_logical_io_reads,
	   wm.total_physical_io_reads, wm.avg_physical_io_reads, wm.total_logical_io_writes, wm.avg_logical_io_writes, wm.total_rowcount, wm.avg_rowcount,
	   wm.total_query_max_used_memory, wm.avg_query_max_used_memory, wm.total_tempdb_space_used, wm.avg_tempdb_space_used,
	   wm.total_log_bytes_used, wm.avg_log_bytes_used, wm.total_num_physical_io_reads, wm.avg_num_physical_io_reads,
	   wm.first_execution_time, wm.last_execution_time, wpt.last_force_failure_reason_desc, wpt.context_settings, ROW_NUMBER() OVER (PARTITION BY wm.plan_id, wm.query_id, wm.last_execution_time ORDER BY wm.plan_id) AS rn
FROM #working_plan_text AS wpt
JOIN #working_metrics AS wm
	ON wpt.plan_id = wm.plan_id
	AND wpt.query_id = wm.query_id
)
SELECT *
FROM x
WHERE x.rn = 1
ORDER BY x.last_execution_time
OPTION (RECOMPILE);

END;

END;
END TRY
BEGIN CATCH
        RAISERROR (N'Failure returning results', 0,1) WITH NOWAIT;

        IF @sql_select IS NOT NULL
        BEGIN
            SET @msg = N'Last @sql_select: ' + @sql_select;
            RAISERROR(@msg, 0, 1) WITH NOWAIT;
        END;

        SELECT    @msg = @DatabaseName + N' database failed to process. ' + ERROR_MESSAGE(), @error_severity = ERROR_SEVERITY(), @error_state = ERROR_STATE();
        RAISERROR (@msg, @error_severity, @error_state) WITH NOWAIT;
        
        
        WHILE @@TRANCOUNT > 0 
            ROLLBACK;

        RETURN;
END CATCH;

BEGIN TRY 
BEGIN 

IF (@ExportToExcel = 0 AND @HideSummary = 0 AND @SkipXML = 0)
BEGIN
        RAISERROR('Building query plan summary data.', 0, 1) WITH NOWAIT;

        /* Build summary data */
        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE frequent_execution = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    1,
                    100,
                    'Execution Pattern',
                    'Frequently Executed Queries',
                    'http://brentozar.com/blitzcache/frequently-executed-queries/',
                    'Queries are being executed more than '
                    + CAST (@execution_threshold AS VARCHAR(5))
                    + ' times per minute. This can put additional load on the server, even when queries are lightweight.') ;

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  parameter_sniffing = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    2,
                    50,
                    'Parameterization',
                    'Parameter Sniffing',
                    'http://brentozar.com/blitzcache/parameter-sniffing/',
                    'There are signs of parameter sniffing (wide variance in rows return or time to execute). Investigate query patterns and tune code appropriately.') ;

        /* Forced execution plans */
        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  is_forced_plan = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    3,
                    5,
                    'Parameterization',
                    'Forced Plans',
                    'http://brentozar.com/blitzcache/forced-plans/',
                    'Execution plans have been compiled with forced plans, either through FORCEPLAN, plan guides, or forced parameterization. This will make general tuning efforts less effective.');

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  is_cursor = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    4,
                    200,
                    'Cursors',
                    'Cursors',
                    'http://brentozar.com/blitzcache/cursors-found-slow-queries/',
                    'There are cursors in the plan cache. This is neither good nor bad, but it is a thing. Cursors are weird in SQL Server.');

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  is_cursor = 1
				   AND is_optimistic_cursor = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    4,
                    200,
                    'Cursors',
                    'Optimistic Cursors',
                    'http://brentozar.com/blitzcache/cursors-found-slow-queries/',
                    'There are optimistic cursors in the plan cache, which can harm performance.');

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  is_cursor = 1
				   AND is_forward_only_cursor = 0
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    4,
                    200,
                    'Cursors',
                    'Non-forward Only Cursors',
                    'http://brentozar.com/blitzcache/cursors-found-slow-queries/',
                    'There are non-forward only cursors in the plan cache, which can harm performance.');

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  is_cursor = 1
				   AND is_cursor_dynamic = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (4,
                    200,
                    'Cursors',
                    'Dynamic Cursors',
                    'http://brentozar.com/blitzcache/cursors-found-slow-queries/',
                    'Dynamic Cursors inhibit parallelism!.');

		IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  is_cursor = 1
				   AND is_fast_forward_cursor = 1
                    )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (4,
                    200,
                    'Cursors',
                    'Fast Forward Cursors',
                    'http://brentozar.com/blitzcache/cursors-found-slow-queries/',
                    'Fast forward cursors inhibit parallelism!.');
					
        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  is_forced_parameterized = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    5,
                    50,
                    'Parameterization',
                    'Forced Parameterization',
                    'http://brentozar.com/blitzcache/forced-parameterization/',
                    'Execution plans have been compiled with forced parameterization.') ;

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.is_parallel = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    6,
                    200,
                    'Execution Plans',
                    'Parallelism',
                    'http://brentozar.com/blitzcache/parallel-plans-detected/',
                    'Parallel plans detected. These warrant investigation, but are neither good nor bad.') ;

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.near_parallel = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    7,
                    200,
                    'Execution Plans',
                    'Nearly Parallel',
                    'http://brentozar.com/blitzcache/query-cost-near-cost-threshold-parallelism/',
                    'Queries near the cost threshold for parallelism. These may go parallel when you least expect it.') ;

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.plan_warnings = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    8,
                    50,
                    'Execution Plans',
                    'Query Plan Warnings',
                    'http://brentozar.com/blitzcache/query-plan-warnings/',
                    'Warnings detected in execution plans. SQL Server is telling you that something bad is going on that requires your attention.') ;

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.long_running = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    9,
                    50,
                    'Performance',
                    'Long Running Queries',
                    'http://brentozar.com/blitzcache/long-running-queries/',
                    'Long running queries have been found. These are queries with an average duration longer than '
                    + CAST(@long_running_query_warning_seconds / 1000 / 1000 AS VARCHAR(5))
                    + ' second(s). These queries should be investigated for additional tuning options.') ;

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.missing_index_count > 0
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    10,
                    50,
                    'Performance',
                    'Missing Index Request',
                    'http://brentozar.com/blitzcache/missing-index-request/',
                    'Queries found with missing indexes.');

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.downlevel_estimator = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    13,
                    200,
                    'Cardinality',
                    'Legacy Cardinality Estimator in Use',
                    'http://brentozar.com/blitzcache/legacy-cardinality-estimator/',
                    'A legacy cardinality estimator is being used by one or more queries. Investigate whether you need to be using this cardinality estimator. This may be caused by compatibility levels, global trace flags, or query level trace flags.');

        IF EXISTS (SELECT 1/0
                   FROM #working_warnings p
                   WHERE p.implicit_conversions = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    14,
                    50,
                    'Performance',
                    'Implicit Conversions',
                    'http://brentozar.com/go/implicit',
                    'One or more queries are comparing two fields that are not of the same data type.') ;

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  busy_loops = 1
				   )
        INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
        VALUES (
                16,
                100,
                'Performance',
                'Busy Loops',
                'http://brentozar.com/blitzcache/busy-loops/',
                'Operations have been found that are executed 100 times more often than the number of rows returned by each iteration. This is an indicator that something is off in query execution.');

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  tvf_join = 1
				   )
        INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
        VALUES (
                17,
                50,
                'Performance',
                'Joining to table valued functions',
                'http://brentozar.com/blitzcache/tvf-join/',
                'Execution plans have been found that join to table valued functions (TVFs). TVFs produce inaccurate estimates of the number of rows returned and can lead to any number of query plan problems.');

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  compile_timeout = 1
				   )
        INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
        VALUES (
                18,
                50,
                'Execution Plans',
                'Compilation timeout',
                'http://brentozar.com/blitzcache/compilation-timeout/',
                'Query compilation timed out for one or more queries. SQL Server did not find a plan that meets acceptable performance criteria in the time allotted so the best guess was returned. There is a very good chance that this plan isn''t even below average - it''s probably terrible.');

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  compile_memory_limit_exceeded = 1
				   )
        INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
        VALUES (
                19,
                50,
                'Execution Plans',
                'Compilation memory limit exceeded',
                'http://brentozar.com/blitzcache/compile-memory-limit-exceeded/',
                'The optimizer has a limited amount of memory available. One or more queries are complex enough that SQL Server was unable to allocate enough memory to fully optimize the query. A best fit plan was found, and it''s probably terrible.');

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  warning_no_join_predicate = 1
				   )
        INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
        VALUES (
                20,
                10,
                'Execution Plans',
                'No join predicate',
                'http://brentozar.com/blitzcache/no-join-predicate/',
                'Operators in a query have no join predicate. This means that all rows from one table will be matched with all rows from anther table producing a Cartesian product. That''s a whole lot of rows. This may be your goal, but it''s important to investigate why this is happening.');

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  plan_multiple_plans = 1
				   )
        INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
        VALUES (
                21,
                200,
                'Execution Plans',
                'Multiple execution plans',
                'http://brentozar.com/blitzcache/multiple-plans/',
                'Queries exist with multiple execution plans (as determined by query_plan_hash). Investigate possible ways to parameterize these queries or otherwise reduce the plan count.');

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  unmatched_index_count > 0
				   )
        INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
        VALUES (
                22,
                100,
                'Performance',
                'Unmatched indexes',
                'http://brentozar.com/blitzcache/unmatched-indexes',
                'An index could have been used, but SQL Server chose not to use it - likely due to parameterization and filtered indexes.');

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  unparameterized_query = 1
				   )
        INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
        VALUES (
                23,
                100,
                'Parameterization',
                'Unparameterized queries',
                'http://brentozar.com/blitzcache/unparameterized-queries',
                'Unparameterized queries found. These could be ad hoc queries, data exploration, or queries using "OPTIMIZE FOR UNKNOWN".');

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings
                   WHERE  is_trivial = 1
				   )
        INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
        VALUES (
                24,
                100,
                'Execution Plans',
                'Trivial Plans',
                'http://brentozar.com/blitzcache/trivial-plans',
                'Trivial plans get almost no optimization. If you''re finding these in the top worst queries, something may be going wrong.');
    
        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.is_forced_serial= 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    25,
                    10,
                    'Execution Plans',
                    'Forced Serialization',
                    'http://www.brentozar.com/blitzcache/forced-serialization/',
                    'Something in your plan is forcing a serial query. Further investigation is needed if this is not by design.') ;	

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.is_key_lookup_expensive= 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    26,
                    100,
                    'Execution Plans',
                    'Expensive Key Lookups',
                    'http://www.brentozar.com/blitzcache/expensive-key-lookups/',
                    'There''s a key lookup in your plan that costs >=50% of the total plan cost.') ;	

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.is_remote_query_expensive= 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    28,
                    100,
                    'Execution Plans',
                    'Expensive Remote Query',
                    'http://www.brentozar.com/blitzcache/expensive-remote-query/',
                    'There''s a remote query in your plan that costs >=50% of the total plan cost.') ;

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.trace_flags_session IS NOT NULL
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    29,
                    100,
                    'Trace Flags',
                    'Session Level Trace Flags Enabled',
                    'https://www.brentozar.com/blitz/trace-flags-enabled-globally/',
                    'Someone is enabling session level Trace Flags in a query.') ;

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.is_unused_grant IS NOT NULL
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    30,
                    100,
                    'Unused memory grants',
                    'Queries are asking for more memory than they''re using',
                    'https://www.brentozar.com/blitzcache/unused-memory-grants/',
                    'Queries have large unused memory grants. This can cause concurrency issues, if queries are waiting a long time to get memory to run.') ;

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.function_count > 0
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    31,
                    100,
                    'Compute Scalar That References A Function',
                    'This could be trouble if you''re using Scalar Functions or MSTVFs',
                    'https://www.brentozar.com/blitzcache/compute-scalar-functions/',
                    'Both of these will force queries to run serially, run at least once per row, and may result in poor cardinality estimates.') ;

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.clr_function_count > 0
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    32,
                    100,
                    'Compute Scalar That References A CLR Function',
                    'This could be trouble if your CLR functions perform data access',
                    'https://www.brentozar.com/blitzcache/compute-scalar-functions/',
                    'May force queries to run serially, run at least once per row, and may result in poor cardinlity estimates.') ;


        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.is_table_variable = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    33,
                    100,
                    'Table Variables detected',
                    'Beware nasty side effects',
                    'https://www.brentozar.com/blitzcache/table-variables/',
                    'All modifications are single threaded, and selects have really low row estimates.') ;

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.no_stats_warning = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    35,
                    100,
                    'Columns with no statistics',
                    'Poor cardinality estimates may ensue',
                    'https://www.brentozar.com/blitzcache/columns-no-statistics/',
                    'Sometimes this happens with indexed views, other times because auto create stats is turned off.') ;

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.relop_warnings = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    36,
                    100,
                    'Operator Warnings',
                    'SQL is throwing operator level plan warnings',
                    'http://brentozar.com/blitzcache/query-plan-warnings/',
                    'Check the plan for more details.') ;

        IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.is_table_scan = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    37,
                    100,
                    'Table Scans',
                    'Your database has HEAPs',
                    'https://www.brentozar.com/archive/2012/05/video-heaps/',
                    'This may not be a problem. Run sp_BlitzIndex for more information.') ;
        
		IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.backwards_scan = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    38,
                    100,
                    'Backwards Scans',
                    'Indexes are being read backwards',
                    'https://www.brentozar.com/blitzcache/backwards-scans/',
                    'This isn''t always a problem. They can cause serial zones in plans, and may need an index to match sort order.') ;

		IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.forced_index = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    39,
                    100,
                    'Index forcing',
                    'Someone is using hints to force index usage',
                    'https://www.brentozar.com/blitzcache/optimizer-forcing/',
                    'This can cause inefficient plans, and will prevent missing index requests.') ;

		IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.forced_seek = 1
				   OR p.forced_scan = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    40,
                    100,
                    'Seek/Scan forcing',
                    'Someone is using hints to force index seeks/scans',
                    'https://www.brentozar.com/blitzcache/optimizer-forcing/',
                    'This can cause inefficient plans by taking seek vs scan choice away from the optimizer.') ;

		IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.columnstore_row_mode = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    41,
                    100,
                    'ColumnStore indexes operating in Row Mode',
                    'Batch Mode is optimal for ColumnStore indexes',
                    'https://www.brentozar.com/blitzcache/columnstore-indexes-operating-row-mode/',
                    'ColumnStore indexes operating in Row Mode indicate really poor query choices.') ;

		IF EXISTS (SELECT 1/0
                   FROM   #working_warnings p
                   WHERE  p.is_computed_scalar = 1
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    42,
                    50,
                    'Computed Columns Referencing Scalar UDFs',
                    'This makes a whole lot of stuff run serially',
                    'https://www.brentozar.com/blitzcache/computed-columns-referencing-functions/',
                    'This can cause a whole mess of bad serializartion problems.') ;

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_sort_expensive = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     43,
                     100,
                     'Execution Plans',
                     'Expensive Sort',
                     'http://www.brentozar.com/blitzcache/expensive-sorts/',
                     'There''s a sort in your plan that costs >=50% of the total plan cost.') ;

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_computed_filter = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     44,
                     50,
                     'Filters Referencing Scalar UDFs',
                     'This forces serialization',
                     'https://www.brentozar.com/blitzcache/compute-scalar-functions/',
                     'Someone put a Scalar UDF in the WHERE clause!') ;

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.index_ops >= 5
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     45,
                     100,
                     'Many Indexes Modified',
                     'Write Queries Are Hitting >= 5 Indexes',
                     'https://www.brentozar.com/blitzcache/many-indexes-modified/',
                     'This can cause lots of hidden I/O -- Run sp_BlitzIndex for more information.') ;

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_row_level = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     46,
                     100,
                     'Plan Confusion',
                     'Row Level Security is in use',
                     'https://www.brentozar.com/blitzcache/row-level-security/',
                     'You may see a lot of confusing junk in your query plan.') ;

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_spatial = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     47,
                     200,
                     'Spatial Abuse',
                     'You hit a Spatial Index',
                     'https://www.brentozar.com/blitzcache/spatial-indexes/',
                     'Purely informational.') ;

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.index_dml = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     48,
                     150,
                     'Index DML',
                     'Indexes were created or dropped',
                     'https://www.brentozar.com/blitzcache/index-dml/',
                     'This can cause recompiles and stuff.') ;

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.table_dml = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     49,
                     150,
                     'Table DML',
                     'Tables were created or dropped',
                     'https://www.brentozar.com/blitzcache/table-dml/',
                     'This can cause recompiles and stuff.') ;

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.long_running_low_cpu = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     50,
                     150,
                     'Long Running Low CPU',
                     'You have a query that runs for much longer than it uses CPU',
                     'https://www.brentozar.com/blitzcache/long-running-low-cpu/',
                     'This can be a sign of blocking, linked servers, or poor client application code (ASYNC_NETWORK_IO).') ;

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.low_cost_high_cpu = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     51,
                     150,
                     'Low Cost Query With High CPU',
                     'You have a low cost query that uses a lot of CPU',
                     'https://www.brentozar.com/blitzcache/low-cost-high-cpu/',
                     'This can be a sign of functions or Dynamic SQL that calls black-box code.') ;

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.stale_stats = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     52,
                     150,
                     'Biblical Statistics',
                     'Statistics used in queries are >7 days old with >100k modifications',
                     'https://www.brentozar.com/blitzcache/stale-statistics/',
                     'Ever heard of updating statistics?') ;

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_adaptive = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     53,
                     150,
                     'Adaptive joins',
                     'This is pretty cool -- you''re living in the future.',
                     'https://www.brentozar.com/blitzcache/adaptive-joins/',
                     'Joe Sack rules.') ;					 

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_spool_expensive = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     54,
                     150,
                     'Expensive Index Spool',
                     'You have an index spool, this is usually a sign that there''s an index missing somewhere.',
                     'https://www.brentozar.com/blitzcache/eager-index-spools/',
                     'Check operator predicates and output for index definition guidance') ;	

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_spool_more_rows = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     55,
                     150,
                     'Index Spools Many Rows',
                     'You have an index spool that spools more rows than the query returns',
                     'https://www.brentozar.com/blitzcache/eager-index-spools/',
                     'Check operator predicates and output for index definition guidance') ;	

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_bad_estimate = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     56,
                     100,
                     'Potentially bad cardinality estimates',
                     'Estimated rows are different from average rows by a factor of 10000',
                     'https://www.brentozar.com/blitzcache/bad-estimates/',
                     'This may indicate a performance problem if mismatches occur regularly') ;					

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_big_log = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     57,
                     100,
                     'High transaction log use',
                     'This query on average uses more than half of the transaction log',
                     'http://michaeljswart.com/2014/09/take-care-when-scripting-batches/',
                     'This is probably a sign that you need to start batching queries') ;
					 		
        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_big_tempdb = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     58,
                     100,
                     'High tempdb use',
                     'This query uses more than half of a data file on average',
                     'No URL yet',
                     'You should take a look at tempdb waits to see if you''re having problems') ;
					 
        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_row_goal = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (59,
                     200,
                     'Row Goals',
                     'This query had row goals introduced',
                     'https://www.brentozar.com/archive/2018/01/sql-server-2017-cu3-adds-optimizer-row-goal-information-query-plans/',
                     'This can be good or bad, and should be investigated for high read queries') ;						 	

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_mstvf = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     60,
                     100,
                     'MSTVFs',
                     'These have many of the same problems scalar UDFs have',
                     'http://brentozar.com/blitzcache/tvf-join/',
					 'Execution plans have been found that join to table valued functions (TVFs). TVFs produce inaccurate estimates of the number of rows returned and can lead to any number of query plan problems.');

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_mstvf = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (61,
                     100,
                     'Many to Many Merge',
                     'These use secret worktables that could be doing lots of reads',
                     'https://www.brentozar.com/archive/2018/04/many-mysteries-merge-joins/',
					 'Occurs when join inputs aren''t known to be unique. Can be really bad when parallel.');

        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_nonsargable = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (62,
                     50,
                     'Non-SARGable queries',
                     'Queries may be using',
                     'https://www.brentozar.com/blitzcache/non-sargable-predicates/',
					 'Occurs when join inputs aren''t known to be unique. Can be really bad when parallel.');
					
        IF EXISTS (SELECT 1/0
                    FROM   #working_warnings p
                    WHERE  p.is_paul_white_electric = 1
  					)
             INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
             VALUES (
                     998,
                     200,
                     'Is Paul White Electric?',
                     'This query has a Switch operator in it!',
                     'https://www.sql.kiwi/2013/06/hello-operator-my-switch-is-bored.html',
                     'You should email this query plan to Paul: SQLkiwi at gmail dot com') ;
					 
					 						 					
				
				INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
				SELECT 				
				999,
				200,
				'Database Level Statistics',
				'The database ' + sa.[database] + ' last had a stats update on '  + CONVERT(NVARCHAR(10), CONVERT(DATE, MAX(sa.last_update))) + ' and has ' + CONVERT(NVARCHAR(10), AVG(sa.modification_count)) + ' modifications on average.' AS Finding,
				'https://www.brentozar.com/blitzcache/stale-statistics/' AS URL,
				'Consider updating statistics more frequently,' AS Details
				FROM #stats_agg AS sa
				GROUP BY sa.[database]
				HAVING MAX(sa.last_update) <= DATEADD(DAY, -7, SYSDATETIME())
				AND AVG(sa.modification_count) >= 100000;

		
        IF EXISTS (SELECT 1/0
                   FROM   #trace_flags AS tf 
                   WHERE  tf.global_trace_flags IS NOT NULL
				   )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    1000,
                    255,
                    'Global Trace Flags Enabled',
                    'You have Global Trace Flags enabled on your server',
                    'https://www.brentozar.com/blitz/trace-flags-enabled-globally/',
                    'You have the following Global Trace Flags enabled: ' + (SELECT TOP 1 tf.global_trace_flags FROM #trace_flags AS tf WHERE tf.global_trace_flags IS NOT NULL)) ;


			/*
			Return worsts
			*/
			WITH worsts AS (
			SELECT gi.flat_date,
			       gi.start_range,
			       gi.end_range,
			       gi.total_avg_duration_ms,
			       gi.total_avg_cpu_time_ms,
			       gi.total_avg_logical_io_reads_mb,
			       gi.total_avg_physical_io_reads_mb,
			       gi.total_avg_logical_io_writes_mb,
			       gi.total_avg_query_max_used_memory_mb,
			       gi.total_rowcount,
				   gi.total_avg_log_bytes_mb,
				   gi.total_avg_tempdb_space,
                   gi.total_max_duration_ms, 
                   gi.total_max_cpu_time_ms, 
                   gi.total_max_logical_io_reads_mb,
                   gi.total_max_physical_io_reads_mb, 
                   gi.total_max_logical_io_writes_mb, 
                   gi.total_max_query_max_used_memory_mb,
                   gi.total_max_log_bytes_mb, 
                   gi.total_max_tempdb_space,
				   CONVERT(NVARCHAR(20), gi.flat_date) AS worst_date,
				   CASE WHEN DATEPART(HOUR, gi.start_range) = 0 THEN ' midnight '
						WHEN DATEPART(HOUR, gi.start_range) <= 12 THEN CONVERT(NVARCHAR(3), DATEPART(HOUR, gi.start_range)) + 'am '
						WHEN DATEPART(HOUR, gi.start_range) > 12 THEN CONVERT(NVARCHAR(3), DATEPART(HOUR, gi.start_range) -12) + 'pm '
						END AS worst_start_time,
				   CASE WHEN DATEPART(HOUR, gi.end_range) = 0 THEN ' midnight '
						WHEN DATEPART(HOUR, gi.end_range) <= 12 THEN CONVERT(NVARCHAR(3), DATEPART(HOUR, gi.end_range)) + 'am '
						WHEN DATEPART(HOUR, gi.end_range) > 12 THEN CONVERT(NVARCHAR(3),  DATEPART(HOUR, gi.end_range) -12) + 'pm '
						END AS worst_end_time
			FROM   #grouped_interval AS gi
			), /*averages*/
				duration_worst AS (
			SELECT TOP 1 'Your worst avg duration range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_avg_duration_ms DESC
				), 
				cpu_worst AS (
			SELECT TOP 1 'Your worst avg cpu range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_avg_cpu_time_ms DESC
				), 
				logical_reads_worst AS (
			SELECT TOP 1 'Your worst avg logical read range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_avg_logical_io_reads_mb DESC
				), 
				physical_reads_worst AS (
			SELECT TOP 1 'Your worst avg physical read range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_avg_physical_io_reads_mb DESC
				), 
				logical_writes_worst AS (
			SELECT TOP 1 'Your worst avg logical write range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_avg_logical_io_writes_mb DESC
				), 
				memory_worst AS (
			SELECT TOP 1 'Your worst avg memory range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_avg_query_max_used_memory_mb DESC
				), 
				rowcount_worst AS (
			SELECT TOP 1 'Your worst avg row count range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_rowcount DESC
				), 
				logbytes_worst AS (
			SELECT TOP 1 'Your worst avg log bytes range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_avg_log_bytes_mb DESC
				), 
				tempdb_worst AS (
			SELECT TOP 1 'Your worst avg tempdb range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_avg_tempdb_space DESC
				)/*maxes*/, 
				max_duration_worst AS (
			SELECT TOP 1 'Your worst max duration range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_max_duration_ms DESC
				), 
				max_cpu_worst AS (
			SELECT TOP 1 'Your worst max cpu range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_max_cpu_time_ms DESC
				), 
				max_logical_reads_worst AS (
			SELECT TOP 1 'Your worst max logical read range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_max_logical_io_reads_mb DESC
				), 
				max_physical_reads_worst AS (
			SELECT TOP 1 'Your worst max physical read range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_max_physical_io_reads_mb DESC
				), 
				max_logical_writes_worst AS (
			SELECT TOP 1 'Your worst max logical write range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_max_logical_io_writes_mb DESC
				), 
				max_memory_worst AS (
			SELECT TOP 1 'Your worst max memory range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_max_query_max_used_memory_mb DESC
				), 
				max_logbytes_worst AS (
			SELECT TOP 1 'Your worst max log bytes range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_max_log_bytes_mb DESC
				), 
				max_tempdb_worst AS (
			SELECT TOP 1 'Your worst max tempdb range was on ' + worsts.worst_date + ' between ' + worsts.worst_start_time + ' and ' + worsts.worst_end_time + '.' AS msg
			FROM worsts
			ORDER BY worsts.total_max_tempdb_space DESC
				)
			INSERT #warning_results ( CheckID, Priority, FindingsGroup, Finding, URL, Details )
			/*averages*/
            SELECT 1002, 255, 'Worsts', 'Worst Avg Duration', 'N/A', duration_worst.msg
			FROM duration_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Avg CPU', 'N/A', cpu_worst.msg
			FROM cpu_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Avg Logical Reads', 'N/A', logical_reads_worst.msg
			FROM logical_reads_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Avg Physical Reads', 'N/A', physical_reads_worst.msg
			FROM physical_reads_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Avg Logical Writes', 'N/A', logical_writes_worst.msg
			FROM logical_writes_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Avg Memory', 'N/A', memory_worst.msg
			FROM memory_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Row Counts', 'N/A', rowcount_worst.msg
			FROM rowcount_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Avg Log Bytes', 'N/A', logbytes_worst.msg
			FROM logbytes_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Avg tempdb', 'N/A', tempdb_worst.msg
			FROM tempdb_worst
            UNION ALL
            /*maxes*/
            SELECT 1002, 255, 'Worsts', 'Worst Max Duration', 'N/A', max_duration_worst.msg
			FROM max_duration_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Max CPU', 'N/A', max_cpu_worst.msg
			FROM max_cpu_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Max Logical Reads', 'N/A', max_logical_reads_worst.msg
			FROM max_logical_reads_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Max Physical Reads', 'N/A', max_physical_reads_worst.msg
			FROM max_physical_reads_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Max Logical Writes', 'N/A', max_logical_writes_worst.msg
			FROM max_logical_writes_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Max Memory', 'N/A', max_memory_worst.msg
			FROM max_memory_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Max Log Bytes', 'N/A', max_logbytes_worst.msg
			FROM max_logbytes_worst
			UNION ALL
			SELECT 1002, 255, 'Worsts', 'Worst Max tempdb', 'N/A', max_tempdb_worst.msg
			FROM max_tempdb_worst
			OPTION (RECOMPILE);


        IF NOT EXISTS (SELECT 1/0
					   FROM   #warning_results AS bcr
                       WHERE  bcr.Priority = 2147483646
				      )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (2147483646,
                    255,
                    'Need more help?' ,
                    'Paste your plan on the internet!',
                    'http://pastetheplan.com',
                    'This makes it easy to share plans and post them to Q&A sites like https://dba.stackexchange.com/!') ;


        IF NOT EXISTS (SELECT 1/0
					   FROM   #warning_results AS bcr
                       WHERE  bcr.Priority = 2147483647
				      )
            INSERT INTO #warning_results (CheckID, Priority, FindingsGroup, Finding, URL, Details)
            VALUES (
                    2147483647,
                    255,
                    'Thanks for using sp_BlitzQueryStore!' ,
                    'From Your Community Volunteers',
                    'http://FirstResponderKit.org',
                    'We hope you found this tool useful. Current version: ' + @Version + ' released on ' + CONVERT(NVARCHAR(30), @VersionDate) + '.') ;
	

	
    SELECT  Priority,
            FindingsGroup,
            Finding,
            URL,
            Details,
            CheckID
    FROM    #warning_results 
    GROUP BY Priority,
            FindingsGroup,
            Finding,
            URL,
            Details,
            CheckID
    ORDER BY Priority ASC, FindingsGroup, Finding, CheckID ASC
    OPTION (RECOMPILE);



END;	

END;
END TRY
BEGIN CATCH
        RAISERROR (N'Failure returning warnings', 0,1) WITH NOWAIT;

        IF @sql_select IS NOT NULL
        BEGIN
            SET @msg = N'Last @sql_select: ' + @sql_select;
            RAISERROR(@msg, 0, 1) WITH NOWAIT;
        END;

        SELECT    @msg = @DatabaseName + N' database failed to process. ' + ERROR_MESSAGE(), @error_severity = ERROR_SEVERITY(), @error_state = ERROR_STATE();
        RAISERROR (@msg, @error_severity, @error_state) WITH NOWAIT;
        
        
        WHILE @@TRANCOUNT > 0 
            ROLLBACK;

        RETURN;
END CATCH;

IF @Debug = 1	

BEGIN TRY 

BEGIN

RAISERROR(N'Returning debugging data from temp tables', 0, 1) WITH NOWAIT;

--Table content debugging

SELECT '#working_metrics' AS table_name, *
FROM #working_metrics AS wm
OPTION (RECOMPILE);

SELECT '#working_plan_text' AS table_name, *
FROM #working_plan_text AS wpt
OPTION (RECOMPILE);

SELECT '#working_warnings' AS table_name, *
FROM #working_warnings AS ww
OPTION (RECOMPILE);

SELECT '#working_wait_stats' AS table_name, *
FROM #working_wait_stats wws
OPTION (RECOMPILE);

SELECT '#grouped_interval' AS table_name, *
FROM #grouped_interval
OPTION (RECOMPILE);

SELECT '#working_plans' AS table_name, *
FROM #working_plans
OPTION (RECOMPILE);

SELECT '#stats_agg' AS table_name, *
FROM #stats_agg
OPTION (RECOMPILE);

SELECT '#trace_flags' AS table_name, *
FROM #trace_flags
OPTION (RECOMPILE);

SELECT '#statements' AS table_name, *
FROM #statements AS s
OPTION (RECOMPILE);

SELECT '#query_plan' AS table_name, *
FROM #query_plan AS qp
OPTION (RECOMPILE);

SELECT '#relop' AS table_name, *
FROM #relop AS r
OPTION (RECOMPILE);

SELECT '#plan_cost' AS table_name,  * 
FROM #plan_cost AS pc
OPTION (RECOMPILE);

SELECT '#est_rows' AS table_name,  * 
FROM #est_rows AS er
OPTION (RECOMPILE);

SELECT '#stored_proc_info' AS table_name, *
FROM #stored_proc_info AS spi
OPTION(RECOMPILE);

SELECT '#conversion_info' AS table_name, *
FROM #conversion_info AS ci
OPTION ( RECOMPILE );

SELECT '#variable_info' AS table_name, *
FROM #variable_info AS vi
OPTION ( RECOMPILE );

SELECT '#missing_index_xml' AS table_name, *
FROM   #missing_index_xml
OPTION ( RECOMPILE );

SELECT '#missing_index_schema' AS table_name, *
FROM   #missing_index_schema
OPTION ( RECOMPILE );

SELECT '#missing_index_usage' AS table_name, *
FROM   #missing_index_usage
OPTION ( RECOMPILE );

SELECT '#missing_index_detail' AS table_name, *
FROM   #missing_index_detail
OPTION ( RECOMPILE );

SELECT '#missing_index_pretty' AS table_name, *
FROM   #missing_index_pretty
OPTION ( RECOMPILE );

END; 

END TRY
BEGIN CATCH
        RAISERROR (N'Failure returning debug temp tables', 0,1) WITH NOWAIT;

        IF @sql_select IS NOT NULL
        BEGIN
            SET @msg = N'Last @sql_select: ' + @sql_select;
            RAISERROR(@msg, 0, 1) WITH NOWAIT;
        END;

        SELECT    @msg = @DatabaseName + N' database failed to process. ' + ERROR_MESSAGE(), @error_severity = ERROR_SEVERITY(), @error_state = ERROR_STATE();
        RAISERROR (@msg, @error_severity, @error_state) WITH NOWAIT;
        
        
        WHILE @@TRANCOUNT > 0 
            ROLLBACK;

        RETURN;
END CATCH;

/*
Ways to run this thing

--Debug
EXEC sp_BlitzQueryStore @DatabaseName = 'StackOverflow', @Debug = 1

--Get the top 1
EXEC sp_BlitzQueryStore @DatabaseName = 'StackOverflow', @Top = 1, @Debug = 1

--Use a StartDate												 
EXEC sp_BlitzQueryStore @DatabaseName = 'StackOverflow', @Top = 1, @StartDate = '20170527'
				
--Use an EndDate												 
EXEC sp_BlitzQueryStore @DatabaseName = 'StackOverflow', @Top = 1, @EndDate = '20170527'
				
--Use Both												 
EXEC sp_BlitzQueryStore @DatabaseName = 'StackOverflow', @Top = 1, @StartDate = '20170526', @EndDate = '20170527'

--Set a minimum execution count												 
EXEC sp_BlitzQueryStore @DatabaseName = 'StackOverflow', @Top = 1, @MinimumExecutionCount = 10

--Set a duration minimum
EXEC sp_BlitzQueryStore @DatabaseName = 'StackOverflow', @Top = 1, @DurationFilter = 5

--Look for a stored procedure name (that doesn't exist!)
EXEC sp_BlitzQueryStore @DatabaseName = 'StackOverflow', @Top = 1, @StoredProcName = 'blah'

--Look for a stored procedure name that does (at least On My Computer®)
EXEC sp_BlitzQueryStore @DatabaseName = 'StackOverflow', @Top = 1, @StoredProcName = 'UserReportExtended'

--Look for failed queries
EXEC sp_BlitzQueryStore @DatabaseName = 'StackOverflow', @Top = 1, @Failed = 1

--Filter by plan_id
EXEC sp_BlitzQueryStore @DatabaseName = 'StackOverflow', @PlanIdFilter = 3356

--Filter by query_id
EXEC sp_BlitzQueryStore @DatabaseName = 'StackOverflow', @QueryIdFilter = 2958

*/

END;

GO


