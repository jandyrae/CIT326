/*
* Jandy Kiger CIT326
* Week 4 Stepping Stone Backup/Recovery
*/

-- sample backup query
BACKUP DATABASE [sample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample.bak' WITH NOFORMAT,
NOINIT,
NAME = N'sample-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO

-- delete table from backed up db
USE [sample]
GO
/****** Object:  Table [dbo].[works_on]    Script Date: 1/24/2023 3:45:05 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[works_on]') AND type in (N'U'))
DROP TABLE [dbo].[works_on]
GO


-- restore the database from backup to recover the dropped table
USE [master] BACKUP LOG [sample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample_LogBackup_2023-01-24_15-47-22.bak' WITH NOFORMAT,
NOINIT,
NAME = N'sample_LogBackup_2023-01-24_15-47-22',
NOSKIP,
NOREWIND,
NOUNLOAD,
NORECOVERY,
STATS = 5 RESTORE DATABASE [sample]
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample.bak' WITH FILE = 1,
    NOUNLOAD,
    STATS = 5
GO
-- changed to use options to recover full backup and replace/overwrite, 
USE [master]
BACKUP LOG [sample] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample_LogBackup_2023-01-24_15-59-02.bak' WITH NOFORMAT, 
NOINIT,  
NAME = N'sample_LogBackup_2023-01-24_15-59-02', 
NOSKIP, 
NOREWIND, 
NOUNLOAD,  
NORECOVERY ,  
STATS = 5 RESTORE DATABASE [sample] 
FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample.bak' WITH  FILE = 1,  
	NOUNLOAD,  
	REPLACE,  
	STATS = 5

GO

-- create a new database (changed name) from a restored db 
USE [master] 
/*
this first part is a backup log created to protect us from data loss - in this case it is not needed.

BACKUP LOG [sample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample_LogBackup_2023-01-24_16-04-53.bak' WITH NOFORMAT,
NOINIT,
NAME = N'sample_LogBackup_2023-01-24_16-04-53',
NOSKIP,
NOREWIND,
NOUNLOAD,
NORECOVERY,
STATS = 5 
*/
RESTORE DATABASE [sampleTEST]
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample.bak' WITH FILE = 1,
    MOVE N'sample' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\sampleTEST.mdf',
    MOVE N'sample_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\sampleTEST_log.ldf',
    NOUNLOAD,
    STATS = 5
GO

--showing the new database sampleTEST can be queried
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [dept_no]
      ,[dept_name]
      ,[location]
  FROM [sampleTEST].[dbo].[department]