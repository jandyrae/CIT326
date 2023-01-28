/*
* Jandy Kiger CIT326
* Week 4 Stepping Stone Backup/Recovery
* Part 2
*/


USE [master] RESTORE DATABASE [kiger_sample_development]
FROM DISK = N'/home/kiger_sample_development.bak' WITH FILE = 1,
    MOVE N'sample' TO N'/var/opt/mssql/data/kiger_sample_development.mdf',
    MOVE N'sample_log' TO N'/var/opt/mssql/data/kiger_sample_development_log.ldf',
    NOUNLOAD,
    STATS = 5
GO
