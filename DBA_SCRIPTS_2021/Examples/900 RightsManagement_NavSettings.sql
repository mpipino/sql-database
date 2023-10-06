
select *
from [dbo].[RightsManagement_NavSettings] rm
where rm.MenuTypeId not in (select MenuTypeId from [dbo].[RightsManagement_NavSettings_MenuType])

BEGIN TRANSACTION
--fks
ALTER TABLE dbo.RightsManagement_NavSettings WITH NOCHECK
   ADD CONSTRAINT FK_RightsManagement_NavSettings_MenuTypeId FOREIGN KEY (MenuTypeId)
      REFERENCES  dbo.[RightsManagement_NavSettings_MenuType](MenuTypeId)
COMMIT
/*
Express:
Msg 1778, Level 16, State 0, Line 8
Column 'dbo.RightsManagement_NavSettings_MenuType.MenuTypeId' is not the same data type as referencing column 'RightsManagement_NavSettings.MenuTypeId' in foreign key 'FK_RightsManagement_NavSettings_MenuTypeId'.
Msg 1750, Level 16, State 1, Line 8
Could not create constraint or index. See previous errors.
*/

