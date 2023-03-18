/*
Transaction log backups give you point-in-time recovery. Differentials do not. A differential is only the full backup plus whatever changes have happened since the full backup and up to the differential. They do not include any changes after the differential. But a tlog backup does.

Here's an example:

12am full backup
12pm diff
12am-11:59pm - tlog backups every 15 minutes

System crash at 6:01pm that requires complete recovery.

You would restore the 12am full backup, the 12pm diff, and then all of the tlogs from 12pm until 6pm. If you were able to do a tail backup at 6:01pm or after, then you could even restore that.

If you don't do tlog backups, then you could only restore full backup + diff, which would mean data loss from 12pm until 6pm-ish.

Hope this makes sense. Ask more questions if needed!*/

-- diff backups are cumulative
BACKUP DATABASE [sample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\fullsample.bak' WITH NOFORMAT,
NOINIT,
NAME = N'sample-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO

2023-02-06 18:10:39.850

BACKUP LOG [sample] TO DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\sample_tlog.trn' WITH NOFORMAT,
NOINIT,
NAME = N'sample-Full Database Backup',
SKIP,
NOREWIND,
NOUNLOAD,
STATS = 10
GO