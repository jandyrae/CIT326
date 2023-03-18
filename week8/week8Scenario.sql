/*
Your company would like you to set up a maintenance plan to ensure overall health for a database of your choice. Watch the video below and review the other resources to help you in this task.
            Getting Started with Maintenance Plans For Backups
            Additional Considerations for Maintenance Plan Backups
            The Maintenance Plan Wizard Section of Chapter 16 in our Textbook
            Microsoft Learn
            Microsoft Documentation
            MSSQL Tips tutorials:
            Check Integrity
            Rebuild Indexes
            Reorganize Indexes and Update Statistics
            Cleanup History (optional)
SHOW 1: 
That the following tasks are present in your maintenance plan and prove they are successful: 
Check Database Integrity
Rebuild Index
Reorganize Indexes and Update Statistics
Backup Database (Full)
Cleanup History (optional)
A schedule for each task to run (even if it is only a combined one-time schedule)

HINT: As long as you can show a successful task for each of these, we will not worry about the scheduling order or dependencies. They can be separate jobs or steps within the same job.

Scenario 2 Description (40 points):

Your success in job automation last week has you wondering what else you can do to improve the quality of your environment. Take this opportunity to come up with a scenario for any one of your installed databases that requires job automation to manage. The scenario should be related to the topics covered in this course up to this point or related to the topic you explored during this week’s review and explore assignment.
*/
BACKUP DATABASE [master] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\master_backup_2023_02_24_113541_1690520.bak' WITH NOFORMAT,
NOINIT,
NAME = N'master_backup_2023_02_24_113541_1690520',
SKIP,
REWIND,
NOUNLOAD,
STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position
from msdb..backupset
where database_name = N'master'
    and backup_set_id =(
        select max(backup_set_id)
        from msdb..backupset
        where database_name = N'master'
    ) if @backupSetId is null begin raiserror(
        N'Verify failed. Backup information for database ' 'master'' not found.',
        16,
        1
    )
end RESTORE VERIFYONLY
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\master_backup_2023_02_24_113541_1690520.bak' WITH FILE = @backupSetId,
    NOUNLOAD,
    NOREWIND
GO use [master];
GO BACKUP DATABASE [model] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\model_backup_2023_02_24_113541_2230656.bak' WITH NOFORMAT,
    NOINIT,
    NAME = N'model_backup_2023_02_24_113541_2230656',
    SKIP,
    REWIND,
    NOUNLOAD,
    STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position
from msdb..backupset
where database_name = N'model'
    and backup_set_id =(
        select max(backup_set_id)
        from msdb..backupset
        where database_name = N'model'
    ) if @backupSetId is null begin raiserror(
        N'Verify failed. Backup information for database ' 'model'' not found.',
        16,
        1
    )
end RESTORE VERIFYONLY
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\model_backup_2023_02_24_113541_2230656.bak' WITH FILE = @backupSetId,
    NOUNLOAD,
    NOREWIND
GO use [model];
GO BACKUP DATABASE [msdb] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\msdb_backup_2023_02_24_113541_3060848.bak' WITH NOFORMAT,
    NOINIT,
    NAME = N'msdb_backup_2023_02_24_113541_3060848',
    SKIP,
    REWIND,
    NOUNLOAD,
    STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position
from msdb..backupset
where database_name = N'msdb'
    and backup_set_id =(
        select max(backup_set_id)
        from msdb..backupset
        where database_name = N'msdb'
    ) if @backupSetId is null begin raiserror(
        N'Verify failed. Backup information for database ' 'msdb'' not found.',
        16,
        1
    )
end RESTORE VERIFYONLY
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\msdb_backup_2023_02_24_113541_3060848.bak' WITH FILE = @backupSetId,
    NOUNLOAD,
    NOREWIND


/*
SHOW 2: 
The concept you are implementing and explain why it will help the company. 
The job that will help your implementation and the code inside of each step in the job.
The results after the job runs successfully.

HINTS:
You are encouraged to do your own search related to something in the book or take a deeper dive into something we have already covered (as mentioned, it can be the same as the topic you chose for the explore assignment). But, if you are coming up empty, here are other interesting possibilities:
This link includes some SQL Server Best Practices, particularly the “Checklists.”
Microsoft suggested best practices (scroll down to “SQL Server Features”).
You could also browse through SQL Server Blogs, such as this one.

NOTE: If you find a feature that doesn’t require a job to implement, you can still create a job to check that the feature is enabled and report on the status of the feature regularly (to verify it is still enabled each Monday, for example).
*/
-- create table
DROP TABLE IF EXISTS custom_audit.weekly_backup_health_$(ESCAPE_NONE(DATE)) 
CREATE TABLE custom_audit.weekly_backup_health_$(ESCAPE_NONE(DATE)) (
    Server varchar(25),
database_name varchar(100),
backup_start_date varchar(12),
backup_finish_date varchar(12),
backup_type varchar(20),
backup_size_kb int,                                              physical_device_name varchar(300), 
backupset_name varchar(100)
    );
-- insert data
INSERT INTO custom_audit.weekly_backup_health_$(ESCAPE_NONE(DATE)) (
Server,
database_name,
backup_start_date,
backup_finish_date,
backup_type,
backup_size_kb,                                                                               
physical_device_name, 
backupset_name
    ) SELECT 
   CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
   msdb.dbo.backupset.database_name, 
   LEFT(msdb.dbo.backupset.backup_start_date, 12) AS backup_start_date, 
   LEFT(msdb.dbo.backupset.backup_finish_date, 12) AS backup_finish_date, 
   CASE msdb..backupset.type 
      WHEN 'D' THEN 'Database' 
      WHEN 'L' THEN 'Log' 
      END AS backup_type, 
   FLOOR((msdb.dbo.backupset.backup_size) / 1024) as backup_size_kb, 
   msdb.dbo.backupmediafamily.physical_device_name, 
   msdb.dbo.backupset.name AS backupset_name
FROM 
   msdb.dbo.backupmediafamily 
   INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
WHERE 
   (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 7) 
ORDER BY 
   msdb.dbo.backupset.database_name, 
   msdb.dbo.backupset.backup_finish_date;