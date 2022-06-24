--xirectinternal.database.xirect.com en BD: Logging.
--DELETE TOP (5000) 
select count(*)
FROM AseaNLogs
where LoggedOnDate < DATEADD(day, -120, GETDATE())
Select 'Proximo'
WAITFOR DELAY '00:00:15'
go 100