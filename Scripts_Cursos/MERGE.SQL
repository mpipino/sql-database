CREATE PROCEDURE [dbo].[usp_ProcessContact]
    @Contact        ContactTemplate READONLY
AS

MERGE [dbo].[Contact] AS [Target]
USING @Contact AS [Source]
ON [Target].[Email] = [Source].[Email]
WHEN MATCHED THEN
    UPDATE SET [FirstName] = [Source].[FirstName],
               [LastName]  = [Source].[LastName]
WHEN NOT MATCHED THEN
    INSERT ( [Email], [FirstName], [LastName] )
    VALUES ( [Source].[Email], [Source].[FirstName], [Source].[LastName] );
GO
--To use this stored procedure, you simply declare a local variable with a type of ContactTemplate, fill up the variable with data and pass it as a table-valued parameter to the stored procedure.

DECLARE @Contacts ContactTemplate

INSERT INTO @Contacts
VALUES ( 'mickey@mouse.com', 'Mickey', 'Mouse' ),
       ( 'minnie@mouse.com', 'Minnie', 'Mouse' )

EXECUTE [dbo].[usp_ProcessContact] @Contacts
SELECT * FROM [dbo].[Contact]
/*
Email               FirstName    LastName
------------------  -----------  -----------
mickey@mouse.com    Mickey       Mouse
minnie@mouse.com    Minnie       Mouse
*/

--------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_MergeEmployee]
    @EmployeeNumber         VARCHAR(10),
    @FirstName              VARCHAR(50),
    @LastName               VARCHAR(50),
    @Position               VARCHAR(50)
AS

MERGE [dbo].[Employee] AS [Target]
USING (SELECT @EmployeeNumber, @FirstName, @LastName, @Position)
   AS [Source] ( [EmployeeNumber], [FirstName], [LastName], [Position] )
ON [Target].[EmployeeNumber] = [Source].[EmployeeNumber]
WHEN MATCHED THEN
    UPDATE SET [FirstName] = [Source][FirstName],
               [LastName]  = [Source].[LastName],
               [Position]  = [Source].[Position]
WHEN NOT MATCHED THEN
    INSERT ( [EmployeeNumber], [FirstName], [LastName], [Position] )
    VALUES ( [Source].[EmployeeNumber], [Source].[FirstName], 
             [Source].[LastName], [Source].[Position] );
GO

DELETE FROM [dbo].[Employee]

EXECUTE [dbo].[usp_MergeEmployee] 'ABC123', 'John', 'Smith', 'Vice President'
SELECT * FROM [dbo].[Employee]
GO

EmployeeNumber   FirstName    LastName    Position
---------------  -----------  ----------  ------------
ABC123           John         Smith       Vice President

EXECUTE [dbo].[usp_MergeEmployee] 'ABC123', 'John', 'Smith', 'President'
SELECT * FROM [dbo].[Employee]
GO
--------------------------------------------------------------------
DECLARE @archive TABLE
(
   ActionType VARCHAR(50),
   [DepartmentID] INT,
   [Name] VARCHAR(50),
   [GroupName] VARCHAR(50),
   [ModifiedDate] DATE
);

MERGE [dbo].[Department_Target] AS tar
USING [dbo].[Department_Source] AS src
ON tar.[DepartmentID] = src.[DepartmentID]
WHEN MATCHED THEN
   UPDATE SET
      tar.Name = src.Name,
      tar.[GroupName] = src.[GroupName],
      tar.[ModifiedDate] = src.[ModifiedDate]
WHEN NOT MATCHED THEN
   INSERT
   (
      [DepartmentID],
      [Name],
      [GroupName],
      [ModifiedDate]
   )
   VALUES
   (
      src.[DepartmentID], src.[Name], src.[GroupName], src.[ModifiedDate]
   )
WHEN NOT MATCHED BY SOURCE THEN
   DELETE
OUTPUT
   $action AS ActionType,
   deleted.*
INTO @archive;

SELECT  * FROM  @archive WHERE  ActionType IN ( 'DELETE', 'UPDATE' );
-------------------------------------------------------------------------

