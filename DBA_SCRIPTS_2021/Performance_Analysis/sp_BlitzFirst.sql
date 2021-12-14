-- attention batch per second
[dba].[sp_BlitzFirst] @ExpertMode=1, @Seconds=60, @CheckProcedureCache = 1 


/*
VDI_CLIENT_OTHER:
This wait type is when a thread is waiting for more work when seeding a new availability group replica
, or in Azure when something triggers a database copy, like changing a service tier or setting up geo-replication.
https://www.sqlskills.com/help/waits/vdi_client_other/
*/

