/*
Class Database Connection Information:
 
Here is the site to connect to the server using SSH in the browser. You need to be logged into Google with your BYU-Idaho email:

https://console.cloud.google.com/compute/instances?project=cit-326-class-2021-22
 
The VM named "mssql-weight" is the VM you will SSH in and upload your backups.
 
Here is the connection information to connect to the class server through SSMS (SQL Server Management Studio):
 
Server Name: 35.225.13.65,49433
User name: sa
Password: cit326password$

sqlcmd -S 35.225.13.65,49433 -U sa -P cit326password$
 */
/*

expand the server, expand Server Objects, right-click Backup Devices, and choose New Backup Device. In the Backup Device dialog box, enter the name of either the disk device (if you clicked File) or the tape device (if you clicked Tape). In the former case, you can click the ... button on the right side of the field to display existing backup device locations. In the latter case, if Tape cannot be activated, then no tape devices exist on the local computer. Click OK.
*/
-- 
USE [master]
GO
EXEC master.dbo.sp_addumpdevice  @devtype = N'disk', @logicalname = N'mssql_backup', @physicalname = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\mssql_backup.bak'
GO

-- 
BACKUP DATABASE [BowlingLeagueExample] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\BowlingLeagueExample.bak' WITH FORMAT, INIT,  NAME = N'BowlingLeagueExample-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'BowlingLeagueExample' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'BowlingLeagueExample' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''BowlingLeagueExample'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\BowlingLeagueExample.bak' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO



