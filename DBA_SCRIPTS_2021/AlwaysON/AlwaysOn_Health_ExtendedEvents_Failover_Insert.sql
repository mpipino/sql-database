USE [dbaadmin]
GO
/****** Object:  StoredProcedure [dbo].[pr_AlwaysOn_Health_ExtendedEvents_Failover_Insert]    Script Date: 28/05/2021 09:00:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[AlwaysOn_Health_ExtendedEvents_Failover_Insert]
as
begin
	with cte as (
	SELECT  
		xml_data.value('(/event/@name)[1]','varchar(max)') AS eventName  
	  , xml_data.value('(/event/@package)[1]', 'varchar(max)') AS package  
	  , xml_data.value('(/event/@timestamp)[1]', 'datetime')-'03:00' AS 'eventDate'  
	  , xml_data.value('(/event/data[@name=''availability_group_name'']/value)[1]','varchar(500)') AS 'availabilityGroupName'  
	  , xml_data.value('(/event/data[@name=''statement'']/value)[1]','varchar(500)') AS 'eventDataFailover'
	  , xml_data.value('(/event/data[@name=''ddl_phase'']/value)[1]','varchar(500)') AS 'phase'  
	  , xml_data.value('(/event/data[@name=''ddl_phase'']/text)[1]','varchar(500)') AS 'phaseDesc'  
	  ,event_data
	  --into #aaa
	FROM   
	(  
		  SELECT  object_name as event, CONVERT(xml, event_data) as xml_data ,event_data
		   FROM sys.fn_xe_file_target_read_file('AlwaysOn_health*.xel', NULL, NULL, NULL)  
	)   
	AS XEventData  
	WHERE event_data LIKE '%ALTER AVAILABILITY GROUP%FAILOVER;%' )


	insert into [DBA_AlwaysOn_Health_ExtendedEvents_Failover]
	select 
	@@SERVERNAME 'Replica'
	,eventDate
	,availabilityGroupName
	,eventDataFailover
	from cte c
	where phase = 1
	except 
	select * from [DBA_AlwaysOn_Health_ExtendedEvents_Failover]

end