/*
W04 Scenario:

You are starting to get the sense that the previous "Jack of all trades" IT guy spent more time bowling than caring for his systems. You feel this way because there doesn't seem to be a test server, which means all development was done on the live (production) system. This is a risky way to conduct business and you are determined to change it. You also wonder if the database has ever been backed up!

*/

/*
1. Use the data dictionary to write a query to find out when the last time all of your databases were backed up. Hint: use msdb.dbo.backupset and the example at the bottom of that page (or come up with your own).
 
SHOW: Your query and the results.
*/

/*
2. Make new backups for ALL of your user databases (not system databases).

	SHOW: 
The method you used to backup the databases. 
Re-run the query from step one, proving that you now have recent backups.

*/
BACKUP DATABASE [BowlingLeagueExample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\BowlingLeagueExample.bak' WITH NOFORMAT,
NOINIT,
NAME = N'BowlingLeagueExample-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO

BACKUP DATABASE [RecipesExample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\RecipesExample.bak' WITH NOFORMAT,
NOINIT,
NAME = N'RecipesExample-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO BACKUP DATABASE [SalesOrdersExample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\SalesOrdersExample.bak' WITH NOFORMAT,
    NOINIT,
    NAME = N'SalesOrdersExample-Full Database Backup',
    SKIP,
    NOREWIND,
    NOUNLOAD,
    STATS = 10
GO BACKUP DATABASE [sampleTEST] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sampleTEST.bak' WITH NOFORMAT,
    NOINIT,
    NAME = N'sampleTEST-Full Database Backup',
    SKIP,
    NOREWIND,
    NOUNLOAD,
    STATS = 10
GO BACKUP DATABASE [SchoolSchedulingExample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\SchoolSchedulingExample.bak' WITH NOFORMAT,
    NOINIT,
    NAME = N'SchoolSchedulingExample-Full Database Backup',
    SKIP,
    NOREWIND,
    NOUNLOAD,
    STATS = 10
GO
/*
3. You decide to make copies of the bowling database for test purposes:

a. Restore the bowling database using your backup from step 2. However, you should restore it within your instance with the new name, "bowling_TEST." Be sure the internal database file names are also changed as part of the restore.
b. Use the videos this week to login to the class server in the cloud and restore it there also. You will consider this copy to be a development version. Change the name of the bowling database to start with your last name such as "jones_bowling_development." Again be sure to change your file names.

NOTE: If your SSH connection errors and you are sure you are logged in to GCP correctly (with your BYUI account), you may contact your instructor to restart the server and/or upload your backup file to the appropriate Teams channel and ask a classmate to upload and copy your backup file for you. You can then restore it through Management Studio. Alternatively, if you are comfortable trying to set up your own SSH connection instead, you can do so by following this optional document (skip step 4).

SHOW (screenshot examples): 
I. The process you used to copy the database as a “test” version. Show that the new copy exists.
II. The process you used to copy the database as a “development” version. Show that this copy exists in the cloud.

*/
USE [master] BACKUP LOG [BowlingLeagueExample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\BowlingLeagueExample_LogBackup_2023-01-26_18-02-26.bak' WITH NOFORMAT,
NOINIT,
NAME = N'BowlingLeagueExample_LogBackup_2023-01-26_18-02-26',
NOSKIP,
NOREWIND,
NOUNLOAD,
NORECOVERY,
STATS = 5 RESTORE DATABASE [bowling_TEST]
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\BowlingLeagueExample.bak' WITH FILE = 1,
    MOVE N'BowlingLeagueExample' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\bowling_TEST.mdf',
    MOVE N'BowlingLeagueExample_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\bowling_TEST_log.ldf',
    NOUNLOAD,
    REPLACE,
    STATS = 5
GO

USE [master] RESTORE DATABASE [kiger_bowling_development]
FROM DISK = N'/home/kiger_bowling_development.bak' WITH FILE = 1,
    MOVE N'BowlingLeagueExample' TO N'/var/opt/mssql/data/kiger_bowling_development.mdf',
    MOVE N'BowlingLeagueExample_log' TO N'/var/opt/mssql/data/kiger_bowling_development_log.ldf',
    NOUNLOAD,
    REPLACE,
    STATS = 5
GO
/*
4. Now that you have a development database, we need to be prepared to refresh certain tables after the live data changes in production (we will say production is your local laptop). You will need to practice backing up and reloading individual tables (instead of whole databases). For this, we will not use backup/restore. We will use the BCP utility outlined in this week's preparation page (and chapter 15 of the book) or in the video in step 2 below.

a. Make sure you have a recent backup of your bowling database (you should have this from the above steps).
b. Use this student example to run a bcp export on the Bowler_scores and Bowlers tables from your original (production) bowling database on your laptop. 
HINT: Be sure to change your bcp commands to match your own schema names and folder path on your laptop, as they will likely differ from what the video uses (you will probably have something other than the bowlingadmin schema).
c. Validate your export files from step b exist. Run two deletes to wipe out all data in the Bowler_scores and Bowlers tables on your laptop. NOTE: You will need to delete the rows from the Bowler_scores table first due to foreign key dependencies.
d. Run a bcp import to reload both tables using your export files created in step b.

SHOW:
I. Your bcp export files created in step b for the Bowler_scores and Bowlers tables.
II. You have deleted all rows in the Bowler_scores and Bowlers tables.
III. Successful import messages from step d and that you once again have data in those two tables

*/