@ECHO OFF
SET SCRIPT=%~dp0restore.sql
:: C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE
SQLCMD.EXE -S "localhost" -E -i %SCRIPT%
:: PAUSE
