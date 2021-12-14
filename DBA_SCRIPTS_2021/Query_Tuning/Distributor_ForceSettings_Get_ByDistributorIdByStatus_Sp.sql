
[dba].sp_BlitzCache @StoredProcName = 'Distributor_ForceSettings_Get_ByDistributorIdByStatus_Sp'

CREATE STATISTICS stat_Commissions_Distributor_ForcedValues_4_22_2021 
ON Commissions_Distributor_ForcedValues
( Id, DistributorId, Begin_CommPeriodId, End_CommPeriodId, ForcedId, [Status]
) 
WITH SAMPLE 100 PERCENT;
GO
