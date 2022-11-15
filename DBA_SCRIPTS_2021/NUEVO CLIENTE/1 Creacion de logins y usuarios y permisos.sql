/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login dbupMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN dbupMillenialstage WITH PASSWORD=N'rBgqFnNqs6t5qv'
GO

--dbupMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login Millenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN Millenialstage WITH PASSWORD=N'v8iDqeHrqE5Sht'
GO

--Millenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xapiMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xapiMillenialstage WITH PASSWORD=N'wjczMps2Qdc5Qd'
GO

--xapiMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xautoshipMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xautoshipMillenialstage WITH PASSWORD=N'gv3AmAfgm9ErN4'
GO

--xautoshipMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xbackofficeMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xbackofficeMillenialstage WITH PASSWORD=N'spCYa3gchDbLXB'
GO

--xbackofficeMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xcorporateMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xcorporateMillenialstage WITH PASSWORD=N'pQ5wWidWEoqkug'
GO

--xcorporateMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xenrollMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xenrollMillenialstage WITH PASSWORD=N'RXUjfcSk3bz323'
GO

--xenrollMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xorderMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xorderMillenialstage WITH PASSWORD=N'G268apjEpWnWc3'
GO

--xorderMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xruntasksMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xruntasksMillenialstage WITH PASSWORD=N'a5ZU2GZhiiVfYG'
GO

--xruntasksMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xtranslationsMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xtranslationsMillenialstage WITH PASSWORD=N'f2ZGzPyH2kmoYc'
GO

--xtranslationsMillenialstage DISABLE
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login xwebservicescommMillenialstage    Script Date: 5/28/2022 11:59:26 AM ******/
CREATE LOGIN xwebservicescommMillenialstage WITH PASSWORD=N'4HHe8gfX7i2T3q'
GO

--xwebservicescommMillenialstage DISABLE
GO



----------------EN LA BASE:
/****** Object:  User dbupMillenialstage    Script Date: 5/28/2022 12:22:22 PM ******/
CREATE USER dbupMillenialstage FOR LOGIN dbupMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER dbupMillenialstage

/****** Object:  User Millenialstage    Script Date: 5/28/2022 12:22:22 PM ******/
CREATE USER Millenialstage FOR LOGIN Millenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER Millenialstage

/****** Object:  User xbackofficeMillenialstage    Script Date: 5/28/2022 12:22:22 PM ******/
CREATE USER xbackofficeMillenialstage FOR LOGIN xbackofficeMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xbackofficeMillenialstage

/****** Object:  User xtranslationsMillenialstage    Script Date: 5/28/2022 12:22:22 PM ******/
CREATE USER xtranslationsMillenialstage FOR LOGIN xtranslationsMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xtranslationsMillenialstage

CREATE USER xorderMillenialstage FOR LOGIN xorderMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xorderMillenialstage

CREATE USER xruntasksMillenialstage FOR LOGIN xruntasksMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xruntasksMillenialstage

CREATE USER xwebservicescommMillenialstage FOR LOGIN xwebservicescommMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xwebservicescommMillenialstage

CREATE USER xapiMillenialstage FOR LOGIN xapiMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xapiMillenialstage

CREATE USER xautoshipMillenialstage FOR LOGIN xautoshipMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xautoshipMillenialstage

CREATE USER xcorporateMillenialstage FOR LOGIN xcorporateMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xcorporateMillenialstage

CREATE USER xenrollMillenialstage FOR LOGIN xenrollMillenialstage WITH DEFAULT_SCHEMA=dbo
GO
ALTER ROLE db_owner ADD MEMBER xenrollMillenialstage



