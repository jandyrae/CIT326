/*
Jandy Kiger CIT 326
Stepping Stone Week 6

Take a screenshot of the finished product that includes the following:
The larger size of your transaction file
The larger row count in the employee table
After you are done, you should restore to the full backup you took before video one to reduce the size of this file.
*/

use sample;
select * from sys.database_files;
select COUNT (*) from dbo.employee;


DECLARE @Counter INT
SET @Counter = (SELECT MAX(e.emp_no) FROM dbo.employee AS e)
WHILE (@Counter < 50000)
	BEGIN
	INSERT INTO dbo.employee 
		VALUES
			(@Counter, 'Test', 'Student #' + CAST(@Counter AS VARCHAR), 'd1')
	COMMIT
SET @Counter = @Counter + 1
END;

/*
BACKUP DATABASE [sample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\fullsample.bak' WITH NOFORMAT,
NOINIT,
NAME = N'sample-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO
*/
SELECT * FROM project;
INSERT INTO project VALUES ('p4', 'Rexburg Rapids', 150000.00);
select GETDATE();
-- 2023-02-06 18:10:39.850

/*
BACKUP LOG [sample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample_tlog.trn' WITH NOFORMAT,
NOINIT,
NAME = N'sample-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO
*/
SELECT distinct(project_no), project_name, budget FROM project;
INSERT INTO project VALUES ('p5', 'Barnums'' Circus', 150000.00);
select GETDATE();
-- 2023-02-06 18:15:17.347

INSERT INTO project VALUES ('p6', 'Others'' Circus', 120000.00);
select GETDATE();
-- 2023-02-06 18:17:28.217

INSERT INTO project VALUES ('p5', 'Barnums'' Circus', 150000.00);
select GETDATE();
-- 2023-02-06 18:18:01.183

/*
BACKUP LOG [sample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample_tlog1.trn' WITH NOFORMAT,
NOINIT,
NAME = N'sample-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO
*/

INSERT INTO project VALUES ('p7', 'Barnums'' Freak Show', 160000.00);
select GETDATE();
-- 2023-02-06 18:37:30.467
/*
BACKUP LOG [sample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample_tlog2.trn' WITH NOFORMAT,
NOINIT,
NAME = N'sample-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO
*/
DELETE FROM project;
select GETDATE();
-- 2023-02-06 18:22:08.917
/*
BACKUP LOG [sample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample_tlog3.trn' WITH NOFORMAT,
NOINIT,
NAME = N'sample-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO
*/

USE [master]
ALTER DATABASE [sample] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
BACKUP LOG [sample] TO  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample_LogBackup_2023-02-06_18-25-28.bak' WITH NOFORMAT, NOINIT,  NAME = N'sample_LogBackup_2023-02-06_18-25-28', NOSKIP, NOREWIND, NOUNLOAD,  NORECOVERY ,  STATS = 5
RESTORE DATABASE [sample] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\fullsample.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
RESTORE LOG [sample] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample_tlog.trn' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  STATS = 5
RESTORE LOG [sample] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample_tlog.trn' WITH  FILE = 2,  NOUNLOAD,  STATS = 5
ALTER DATABASE [sample] SET MULTI_USER

GO