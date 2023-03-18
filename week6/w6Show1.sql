/*
Scenario 1 Description:

The owner of the bowling league, Karl, recently had a scare when a Chicago ice storm knocked the power out and the database server went down. Luckily, everything powered back on and came online. This was enough for him to ask you, "What could we have done if the server was corrupted and the data was no longer readable?"

You ask a few more questions and find out that he would be totally satisfied if he knew he could at least get back to the information at the end of each night, after all of the leagues and players are finished. He isn't worried about up to the minute changes or data loss during the day. Though he would like to have peace of mind, he is also worried about incurring extra server and disk space costs for his bowling alley that is barely turning a profit (even with insane margins on cheap food). In other words, he wants to have a nightly recovery plan with the lowest possible amount of disk space usage.

SHOW 1: 
Tell what recovery model you chose and explain why.
Your suggested implementation for this scenario. 
Depending on your implementation, demonstrate backup(s), some transaction(s) and a restore (or restores) for Karl using your plan.

*/
-- My initial thought is simple recovery model. Although transaction logs are not available, this doesn't seem to be the concern with Karl's Bowling League DB. His desire to keep disk space low would be addressed by this solution because the inactive log is removed and able to be reused. The other reason this model sounds best for Karl is that he would be happy as long as his data was kept safe from the night before. This also leads to the simple recovery model because transaction logs (including point in time) are not available.
-- Table backup or file level backups
-- point of failure recovery is available for full and diff backups
-- no admin overhead 

--created karls db from the bowling example
USE [master] RESTORE DATABASE [karlsBowlingDatabase]
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\BowlingLeagueExample.bak' WITH FILE = 1,
    MOVE N'BowlingLeagueExample' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\karlsBowlingDatabase.mdf',
    MOVE N'BowlingLeagueExample_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\karlsBowlingDatabase_log.ldf',
    NOUNLOAD,
    STATS = 5
GO

-- Full backup new database - needed for any type of recovery model
BACKUP DATABASE [karlsBowlingDatabase] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\karlsBowlingDatabase.bak' WITH NOFORMAT,
NOINIT,
NAME = N'karlsBowlingDatabase-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position
from msdb..backupset
where database_name = N'karlsBowlingDatabase'
    and backup_set_id =(
        select max(backup_set_id)
        from msdb..backupset
        where database_name = N'karlsBowlingDatabase'
    ) if @backupSetId is null begin raiserror(
        N'Verify failed. Backup information for database ' 'karlsBowlingDatabase'' not found.',
        16,
        1
    )
end RESTORE VERIFYONLY
FROM DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\karlsBowlingDatabase.bak' WITH FILE = @backupSetId,
    NOUNLOAD,
    NOREWIND
GO

-- change properties for db limit filesize - addressing Karl's concern 
USE [master]
GO
ALTER DATABASE [karlsBowlingDatabase] MODIFY FILE ( NAME = N'BowlingLeagueExample', MAXSIZE = 102400KB )
GO
ALTER DATABASE [karlsBowlingDatabase] MODIFY FILE ( NAME = N'BowlingLeagueExample_log', MAXSIZE = 1024000KB )
GO


-- differential backup done with compression
BACKUP DATABASE [karlsBowlingDatabase] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\karlsBowlingDifferential.dif' WITH DIFFERENTIAL,
FORMAT,
INIT,
NAME = N'karlsBowlingDatabase-Differential Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
COMPRESSION,
STATS = 10
GO


-- Using a FULL recovery model and using differentials is a second way to address Karl's needs, do a FULL backup weekly and differentials nightly, this would be small in memory space (especially with compressed differentials), and would give no more than one day that could be lost and would not take a lot of room or time if recovery is needed.

select * from karlsBowlingDatabase.registration.Bowlers;
select * from karlsBowlingDatabase.registration.Teams;
select * from karlsBowlingDatabase.registration.Tournaments;

insert into karlsBowlingDatabase.registration.Teams values (11, 'Jellyfish', 33)
SELECT CURRENT_TIMESTAMP;
-- 2023-02-09 17:12:06.193

-- at end of business day the differential is run and ready for next day

/*
BACKUP DATABASE [karlsBowlingDatabase] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\karlsBowlingDifferential_monday.dif' WITH DIFFERENTIAL,
FORMAT,
INIT,
NAME = N'karlsBowlingDatabase-Differential Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
COMPRESSION,
STATS = 10
GO
*/
insert into karlsBowlingDatabase.registration.Bowlers values (33, 'Kiger', 'Jason', 'E', '1324 Meadow View Ln', 'Lancaster', 'CA', 93536, '(661) 555-8569', 11),
(34, 'Kiger', 'Jandy', '', '1324 Meadow View Ln', 'Lancaster', 'CA', 93536, '(661) 555-8565', 11),
(35, 'Kiger', 'TJ', '', '1324 Meadow View Ln', 'Lancaster', 'CA', 93536, '(661) 555-5565', 11),
(36, 'Kiger', 'Riles', '', '1324 Meadow View Ln', 'Lancaster', 'CA', 93536, '(661) 555-5365', 11);
SELECT CURRENT_TIMESTAMP;
-- 2023-02-09 17:14:11.070
select * from karlsBowlingDatabase.registration.Bowlers;

/*
BACKUP DATABASE [karlsBowlingDatabase] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\karlsBowlingDifferential_tuesday.dif' WITH DIFFERENTIAL,
FORMAT,
INIT,
NAME = N'karlsBowlingDatabase-Differential Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
COMPRESSION,
STATS = 10
GO
*/
INSERT INTO karlsBowlingDatabase.registration.Tournaments ([TourneyID]
      ,[TourneyDate]
      ,[TourneyLocation]) VALUES (21, '2019-09-01', 'Lancaster Ghetto');
INSERT INTO [karlsBowlingDatabase].[scoring].[Tourney_Matches] ([MatchID]
      ,[TourneyID]
      ,[Lanes]
      ,[OddLaneTeamID]
      ,[EvenLaneTeamID])
  VALUES (58, 21, '19-20', 2, 11)
INSERT INTO karlsBowlingDatabase.scoring.Match_Games ([MatchID]
      ,[GameNumber]
      ,[WinningTeamID]) VALUES (58, 2, 11);
INSERT INTO [karlsBowlingDatabase].[scoring].[Bowler_Scores] ([MatchID]
      ,[GameNumber]
      ,[BowlerID]
      ,[RawScore]
      ,[HandiCapScore]
      ,[WonGame])
	VALUES (58, 2, 33, 150, 180, 1)
	, (58, 2, 34, 140, 188, 0)
	, (58, 2, 35, 145, 188, 1)
	, (58, 2, 36, 145, 195, 1);
SELECT CURRENT_TIMESTAMP;
-- 2023-02-09 17:33:57.243


select * from karlsBowlingDatabase.scoring.Bowler_Scores WHERE MatchID = 58;
/*
BACKUP DATABASE [karlsBowlingDatabase] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\karlsBowlingDifferential_wednesday.dif' WITH DIFFERENTIAL,
FORMAT,
INIT,
NAME = N'karlsBowlingDatabase-Differential Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
COMPRESSION,
STATS = 10
GO
*/

INSERT INTO karlsBowlingDatabase.scoring.Match_Games ([MatchID]
      ,[GameNumber]
      ,[WinningTeamID]) VALUES (58, 1, 11)
	  , (58, 3, 11);
SELECT CURRENT_TIMESTAMP;
-- 2023-02-09 16:27:21.267
select * from karlsBowlingDatabase.scoring.Match_Games WHERE MatchID = 58;
/*
BACKUP DATABASE [karlsBowlingDatabase] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\karlsBowlingDifferential_thursday.dif' WITH DIFFERENTIAL,
FORMAT,
INIT,
NAME = N'karlsBowlingDatabase-Differential Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
COMPRESSION,
STATS = 10
GO
*/

/*
USE karlsBowlingDatabase
SELECT t.NAME AS TableName
FROM sys.Tables t
LEFT JOIN sys.sql_expression_dependencies d ON d.referenced_id = t.object_id
WHERE d.referenced_id IS NULL;
*/

-- alter table karlsBowlingDatabase.scoring.Bowler_Scores drop constraint Bowler_Scores_FK00;
use karlsBowlingDatabase
DELETE FROM [registration].Bowlers;
SELECT CURRENT_TIMESTAMP;
select * from karlsBowlingDatabase.registration.Bowlers;
-- 2023-02-09 17:37:17.960
-- Ralph doesn't even bother to say what he did, he just doesn't come back to work.

/*
BACKUP DATABASE [karlsBowlingDatabase] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\karlsBowlingDifferential_friday.dif' WITH DIFFERENTIAL,
FORMAT,
INIT,
NAME = N'karlsBowlingDatabase-Differential Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
COMPRESSION,
STATS = 10
GO
*/

-- we notice here just before the tournament that the table that held the tourney dates and locations got deleted, then we backed up the deletion!! 
-- restore to new name to verify this is the correct restore point

USE [master]
ALTER DATABASE [karlsBowlingDatabase] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [karlsBowlingDatabase] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\karlsBowlingDatabase.bak' WITH  FILE = 1,  NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5
RESTORE DATABASE [karlsBowlingDatabase] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\karlsBowlingDifferential_thursday.dif' WITH  FILE = 1,  NOUNLOAD,  STATS = 5
ALTER DATABASE [karlsBowlingDatabase] SET MULTI_USER

GO

-- verify the table is returned - and no other data is missing
select * from karlsBowlingDatabase.registration.Tournaments;
select * from karlsBowlingDatabase.scoring.Match_Games;
select * from karlsBowlingDatabase.scoring.Bowler_Scores;
select * from karlsBowlingDatabase.registration.Bowlers;
select * from karlsBowlingDatabase.registration.Teams;


-- saved the day (and data) run backup 