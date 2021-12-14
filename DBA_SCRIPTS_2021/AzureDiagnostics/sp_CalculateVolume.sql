---Para ejecutar en Azure Logs:
---https://portal.azure.com/#@softwareasea.onmicrosoft.com/resource/subscriptions/f6d7f502-5128-4fa1-937d-144f1261bed1/resourceGroups/Default-SQL-EastUS/providers/Microsoft.Sql/servers/dlo6zra872/databases/Asea_Prod/analytics

AzureDiagnostics
| where Category == 'SQLSecurityAuditEvents'
| where ResourceId == '/SUBSCRIPTIONS/F6D7F502-5128-4FA1-937D-144F1261BED1/RESOURCEGROUPS/DEFAULT-SQL-EASTUS/PROVIDERS/MICROSOFT.SQL/SERVERS/DLO6ZRA872/DATABASES/ASEA_PROD'
| where duration_milliseconds_d > 10000
| where statement_s contains 'sp_CalculateVolume'
| where event_time_t > datetime(2021-02-01)
//| where affected_rows_d >10
| project format_datetime(event_time_t, 'yyyy-MM-dd HH:m:s' ), statement_s,duration_milliseconds_d,affected_rows_d, succeeded_s 
| order by event_time_t asc 
//| take 100

