sp_BlitzCache

[dba].sp_BlitzCache @StoredProcName = 'sp_CalculateVolume'
You have 67745 plans in your cache, and 99.00% are duplicates with more than 5 entries, meaning similar queries are generating the same plan repeatedly. Forced Parameterization may fix the issue. To find troublemakers, use: EXEC sp_BlitzCache @SortOrder = 'query hash'; 



[dba].sp_BlitzCache @StoredProcName = 'SP_RPT_SALESPRODUCTSUMMARYBYDAY'



[dba].sp_BlitzCache @SortOrder = 'recent compilations'
[dba].sp_BlitzCache @SortOrder = 'query hash';



[dba].sp_BlitzCache @SortOrder = 'avg writes'

--You have 75328 plans in your cache, and 97.00% are duplicates with more than 5 entries, meaning similar queries are generating the same plan repeatedly. Forced Parameterization may fix the issue. To find troublemakers, use: EXEC sp_BlitzCache @SortOrder = 'query hash'; 

/*
--https://support.microsoft.com/en-us/topic/kb4041814-improve-tempdb-spill-diagnostics-in-dmv-and-extended-events-in-sql-server-2017-and-sql-server-2016-sp2-724acea7-cc94-d0cb-faa5-22935de990ca

total_spills. Total number of pages spilled by execution of this plan since it was compiled.
last_spills. Number of pages spilled the last time the plan was executed
min_spills. Minimum number of pages that this plan has ever spilled during a single execution
max_spills. Maximum number of pages that this plan has ever spilled during a single execution

*/
[dba].sp_BlitzCache @SortOrder = 'avg spills';

[dba].sp_BlitzCache @SortOrder = 'average memory grant'





