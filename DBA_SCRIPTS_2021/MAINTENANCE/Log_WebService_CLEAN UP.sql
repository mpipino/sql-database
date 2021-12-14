--hacerlo en BodyLogic.
Select count(*) FROM Log_WebService --229677
where CreatedDate < DATEADD(day, -14, GETDATE()) --205842

DELETE TOP (10000) FROM Log_WebService
where CreatedDate < DATEADD(day, -14, GETDATE())
WAITFOR DELAY '00:07';  
go 10;