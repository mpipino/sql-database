/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [dbupexpress]    Script Date: 2/7/2022 6:44:51 PM ******/
CREATE LOGIN [dbupbodylogictest] WITH PASSWORD=N'W5LrKSFRpkGx67'
GO

/****** Object:  User [dbupexpress]    Script Date: 2/7/2022 6:48:49 PM ******/
CREATE USER [dbupbodylogictest] FOR LOGIN [dbupbodylogictest] 
WITH DEFAULT_SCHEMA=[dbo]
GO

sp_addrolemember 'db_owner', 'dbupbodylogictest'


/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [dbupexpress]    Script Date: 2/7/2022 6:44:51 PM ******/
CREATE LOGIN [dbupbodylogicstage] WITH PASSWORD=N'Jgow7V4VUXPpJj'
GO

/****** Object:  User [dbupexpress]    Script Date: 2/7/2022 6:48:49 PM ******/
CREATE USER [dbupbodylogicstage] FOR LOGIN [dbupbodylogicstage] 
WITH DEFAULT_SCHEMA=[dbo]
GO

sp_addrolemember 'db_owner', 'dbupbodylogicstage'

------------------------------------

CREATE LOGIN [dbupbodylogiclive] WITH PASSWORD=N'75TaJEjtz7iama'
GO

/****** Object:  User [dbupexpress]    Script Date: 2/7/2022 6:48:49 PM ******/
CREATE USER [dbupbodylogiclive] FOR LOGIN [dbupbodylogiclive] 
WITH DEFAULT_SCHEMA=[dbo]
GO

sp_addrolemember 'db_owner', 'dbupbodylogiclive'