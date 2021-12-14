
SELECT top 10		
        *, 'CLICK_NEXT_CELL_TO_BROWSE_ITS_RESULTS!' as [CLICK_NEXT_CELL_TO_BROWSE_ITS_RESULTS],
        CAST(event_data AS XML) AS [event_data_XML]  -- TODO: In ssms.exe results grid, double-click this cell!
    FROM
        sys.fn_xe_file_target_read_file
            (
                -- TODO: Fill in Storage Account name, and the associated Container name.
                -- TODO: The name of the .xel file needs to be an exact match to the files in the storage account Container (You can use Storage Account explorer from the portal to find out the exact file names or you can retrieve the name using the following DMV-query: select target_data from sys.dm_xe_database_session_targets. The 3rd xml-node, "File name", contains the name of the file currently written to.)
                'https://aseadbextendedevents.blob.core.windows.net/aseastage/SP_CalculateVolume_0_132665147448690000.xel',
                null, null, null
            );
GO


SELECT 
    --[XML Data],        
    [XML Data].value('(/event/data[@name=''cpu_time'']/value)[1]','varchar(max)')                AS cpu_time,
	[XML Data].value('(/event/data[@name=''duration'']/value)[1]','varchar(max)')                AS duration,
	[XML Data].value('(/event/data[@name=''object_name'']/value)[1]','varchar(max)')             AS object_name,
	[XML Data].value('(/event/data[@name=''statement'']/value)[1]','varchar(max)')               AS statement,	
	[XML Data].value('(/event/action[@name=''logical_reads'']/value)[1]','varchar(max)')         AS logical_reads,
	[XML Data].value('(/event/action[@name=''row_count'']/value)[1]','varchar(max)')             AS row_count,	
	[XML Data].value('(/event/action[@name=''num_response_rows'']/value)[1]','varchar(max)')     AS num_response_rows,	
    [XML Data].value('(/event/action[@name=''sql_text'']/value)[1]','varchar(max)')              AS sql_text,
	[XML Data].value('(/event/action[@name=''session_id'']/value)[1]','varchar(max)')            AS session_id	
into dba.Events_sp_CalculateVolume
FROM
    (SELECT          
        CONVERT(XML, event_data) AS [XML Data]
    FROM
        sys.fn_xe_file_target_read_file
    ( 'https://aseadbextendedevents.blob.core.windows.net/aseastage/SP_CalculateVolume_0_132665147448690000.xel',NULL,NULL,NULL)) as eventos

--drop table dba.Events_sp_CalculateVolume	                                                                               
--select * from dba.Events_sp_CalculateVolume