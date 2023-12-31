---latency!!!!!!!!!
SELECT
    [vfs].[database_id]
    ,DB_NAME ([vfs].[database_id]) AS [DB]
    ,[vfs].[file_id]
    ,FileType = 
        CASE [vfs].[file_id]
            WHEN 1 THEN 'DATA'
            WHEN 2 THEN 'LOG'
            ELSE CONVERT(varchar, [vfs].[file_id])
        END

    --virtual file latency
    ,[ReadLatency] =
        CASE WHEN [num_of_reads] = 0
            THEN 0 ELSE ([io_stall_read_ms] / [num_of_reads]) END
    ,[WriteLatency] =
        CASE WHEN [num_of_writes] = 0
            THEN 0 ELSE ([io_stall_write_ms] / [num_of_writes]) END
    ,[Latency] =
        CASE WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0)
            THEN 0 ELSE ([io_stall] / ([num_of_reads] + [num_of_writes])) END
    --avg bytes per IOP
    ,[AvgBPerRead] =
        CASE WHEN [num_of_reads] = 0
            THEN 0 ELSE ([num_of_bytes_read] / [num_of_reads]) END
    ,[AvgBPerWrite] =
        CASE WHEN [io_stall_write_ms] = 0
            THEN 0 ELSE ([num_of_bytes_written] / [num_of_writes]) END
    ,[AvgBPerTransfer] =
        CASE WHEN ([num_of_reads] = 0 AND [num_of_writes] = 0)
            THEN 0 ELSE
                (([num_of_bytes_read] + [num_of_bytes_written]) /
                ([num_of_reads] + [num_of_writes])) END
FROM sys.dm_io_virtual_file_stats (DB_ID(),NULL) AS [vfs]
-- WHERE [vfs].[file_id] = 2 -- log files
--ORDER BY [Latency] DESC
--ORDER BY [ReadLatency] DESC
--ORDER BY [WriteLatency] DESC;















