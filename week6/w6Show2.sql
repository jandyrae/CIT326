/*
Scenario 2 Description:

The CIO (Chief Information Officer) of Wide World Importers is concerned about data loss. The company is growing fast and has extra budget to spare to cover needs. He says he can't afford to lose sleep worrying about whether the company's IT needs are keeping up with the growth. He asks you to do whatever it takes to come up with the most complete and constant coverage possible.

SHOW 2: 
Tell what recovery model you chose and explain why.
Your suggested implementation for this scenario. 
Depending on your implementation, demonstrate backup(s), some transaction(s) and a restore (or restores) for the CIO using your plan.

*/

-- Full backup model with differential and transaction logs dependent on use
USE [master] RESTORE DATABASE [CIO_WideWorldImporters]
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\WideWorldImporters-Full.bak' WITH FILE = 1,
    MOVE N'WWI_Primary' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\CIO_WideWorldImporters.mdf',
    MOVE N'WWI_UserData' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\CIO_WideWorldImporters_UserData.ndf',
    MOVE N'WWI_InMemory_Data_1' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\CIO_WideWorldImporters_InMemory_Data_1',
    MOVE N'WWI_Log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\CIO_WideWorldImporters.ldf',
    NOUNLOAD,
    STATS = 5
GO
-- verify the property is set to full recovery, alter if needed to set to FULL
SELECT SERVERPROPERTY('EditionId') AS EditionId
---2117995310
GO
use master
GO

ALTER DATABASE [CIO_WideWorldImporters] SET RECOVERY FULL WITH NO_WAIT
GO

-- full backup
BACKUP DATABASE [CIO_WideWorldImporters] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\CIO_WideWorldImporters.bak' WITH NOFORMAT,
NOINIT,
NAME = N'CIO_WideWorldImporters-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO

/*
USE CIO_WideWorldImporters
SELECT t.NAME AS TableName
FROM sys.Tables t
LEFT JOIN sys.sql_expression_dependencies d ON d.referenced_id = t.object_id
WHERE d.referenced_id IS NULL;
*/
-- create table
Use CIO_WideWorldImporters
CREATE TABLE Persons (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
);
-- create schema
USE [CIO_WideWorldImporters]
GO
CREATE SCHEMA [Employee]
GO

-- create login
USE [master]
GO
CREATE LOGIN [CIO_of_WWImporters] WITH PASSWORD=N'password', DEFAULT_DATABASE=[CIO_WideWorldImporters], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

-- create user
USE [CIO_WideWorldImporters]
GO
CREATE USER [CIO_of_WWImporters] FOR LOGIN [CIO_of_WWImporters]
GO

-- alter schema to new table
USE [CIO_WideWorldImporters]
GO
ALTER SCHEMA Employee transfer Persons;

-- after all the changes we initially do a differential
BACKUP DATABASE [CIO_WideWorldImporters] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\CIO_WWImporters_differential.dif' WITH DIFFERENTIAL,
NOFORMAT,
NOINIT,
NAME = N'CIO_WideWorldImporters-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO
SELECT CURRENT_TIMESTAMP;
-- 2023-02-10 16:29:19.863

BACKUP LOG [CIO_WideWorldImporters] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\CIO_WWImporters_transactions.trn' WITH NOFORMAT,
NOINIT,
NAME = N'CIO_WideWorldImporters-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO