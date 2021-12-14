SELECT * FROM sysprocesses

--WHERE HOSTNAME=''
--WHERE PROGRAM_NAME LIKE '%Microsoft SQL Server Management Studio%'
order by cpu, LOGINAME desc
