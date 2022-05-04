SELECT
      [Commissions_VolumeCalculationLog_Id]
      
      ,Min([CreateDate]) as 'start'
	  ,max([CreateDate]) as 'end'
  FROM [dbo].[Commissions_VolumeCalculationLog_Detail]
 group by [Commissions_VolumeCalculationLog_Id]
 order by [Commissions_VolumeCalculationLog_Id] desc --32557