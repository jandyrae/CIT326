-- Get the table ID, user ID, and table type of the employee table:
-- ex. 9.1
use sample;
select object_id, principal_id, type
    from sys.objects
    where name = 'employee';


-- Get the names of all tables of the sample database that contain the project_no column:
-- 9.2
use sample;
select sys.objects.name
    from sys.objects inner join sys.columns on sys.objects.object_id = sys.columns.object_id
    where sys.objects.type = 'U'
    and sys.columns.name = 'project_no';

--     The following list identifies and describes some of these categories:
-- •   sys.dm_db_* Contains information about databases and their objects
-- •   sys.dm_tran_* Contains information in relation to transactions
-- •   sys.dm_io_* Contains information about I/O activities
-- •   sys.dm_exec_* Contains information related to the execution of user code