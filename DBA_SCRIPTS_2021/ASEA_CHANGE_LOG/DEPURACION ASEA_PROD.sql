-- Deleting chunks of data
declare @RunDate as date = '2013-09-06'
declare @RunSequence as int = (select max(RunSequence) from [dbo].[TBL_ASEA_AAA_RUNDATES]
where RUNDATE = @RunDate)

--select * from [dbo].[TBL_ASEA_AAA_LOG]
--select @RunSequence

DECLARE @Count INT
Declare @for_delete INT
Declare @chunk_size INT
SELECT @chunk_size=1000
SELECT @Count = 0
select @for_delete=count(*) from xASEA.[dbo].[TBL_ASEA_AAA_BONUS_TREE] where RunDate = @RunDate and RunSequence < @RunSequence

While (@Count < @for_delete)
BEGIN
SELECT @Count = @Count + @chunk_size
BEGIN TRAN
--print @chunk_size
--print @RunDate
--print @RunSequence

DELETE top(@chunk_size) FROM xASEA.[dbo].[TBL_ASEA_AAA_BONUS_TREE] where RunDate = @RunDate and RunSequence < @RunSequence

COMMIT TRAN
END