-- it is expected that this script is running under same windows user (you) that will run tests in visual studio
PRINT '**********************'
PRINT 'it is expected that:'
PRINT '- this script is running under same windows user (you) that will run tests in visual studio (or adjust this sql script for different user)'
PRINT '- SQL SERVER 2019 DEVELOPER EDITION is localhost default instance (or adjust restore.bat for different sql server or instance)'
PRINT '- it will restore/overwrite [eav-unit-test-temp] SQL database'
PRINT '**********************'
-- 1. restore db
PRINT '-- 1. restore db'
USE [master]
IF DB_ID('eav-unit-test-temp') IS NOT NULL
	ALTER DATABASE [eav-unit-test-temp] SET SINGLE_USER WITH ROLLBACK IMMEDIATE

RESTORE DATABASE [eav-unit-test-temp] FROM
	DISK = N'C:\Projects\2sxc\unit-test-assets-eav-db\eav-testing.bak' WITH  FILE = 1,
	MOVE N'eav-testing_Data' TO N'c:\db\eav-unit-test-temp_Data.mdf',
	MOVE N'eav-testing_Log' TO N'c:\db\eav-unit-test-temp_Log.ldf',
	NOUNLOAD,  REPLACE,  STATS = 5

ALTER DATABASE [eav-unit-test-temp] SET MULTI_USER
GO

-- 2. ensure your windows integrated server login
PRINT '-- 2. ensure your windows integrated server login'
USE [master]
DECLARE @SqlStatement nvarchar(MAX)
IF NOT EXISTS(SELECT * FROM sys.server_principals WHERE NAME = SYSTEM_USER)
BEGIN
	-- create a server login
	PRINT '    create a server login'
	SET @SqlStatement = 'CREATE LOGIN [' + SYSTEM_USER + '] FROM WINDOWS';
	PRINT @SqlStatement;
	EXEC sp_executesql @SqlStatement;
END
GO

-- 3. ensure your windows integrated database user and permissions
PRINT '-- 3. ensure your windows integrated database user and permissions'
USE [eav-unit-test-temp]
DECLARE @SqlStatement nvarchar(MAX)
IF NOT EXISTS(SELECT * FROM sys.database_principals WHERE NAME = SYSTEM_USER)
BEGIN
	-- create your database user
	PRINT '    create your database user'
	SET @SqlStatement = 'CREATE USER [' + SYSTEM_USER + '] FOR LOGIN [' + SYSTEM_USER + ']';
	PRINT @SqlStatement;
	EXEC sp_executesql @SqlStatement;

	-- set permissions
	PRINT '    set permissions'
	SET @SqlStatement = 'ALTER AUTHORIZATION ON SCHEMA::[db_owner] TO [' + SYSTEM_USER + ']'
	PRINT @SqlStatement;
	EXEC sp_executesql @SqlStatement;
END
ELSE
BEGIN
	-- user exists, auto fix it if necesary
	PRINT '    user exists, auto fix it if necesary'
	SET @SqlStatement = 'EXEC sp_change_users_login ''Auto_Fix'', ''' + SYSTEM_USER + '''';
	PRINT @SqlStatement;
	EXEC sp_executesql @SqlStatement;
END
GO

PRINT '*** END ***'
GO
