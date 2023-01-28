
-- W02 Scenario Submission Guidelines:
-- Be sure you submit all elements labeled by the bolded word, SHOW.
-- NOTE: 
-- Some of these steps refer to a database of your choice. In addition to the databases requested, you will choose to examine one additional database from the Mere Mortals book (EntertainmentAgency, Recipes, SalesOrder, or SchoolScheduling).
-- For all of these steps, you do NOT need to show the information requested within one complex query. It might be easier for you to address things in smaller pieces by writing multiple queries (one for each database). If you need to refresh your SQL first, please look at the W2 SQL Review assignment.


/*-- In your new job, you need to be aware of how many tables you must manage in each database. One way to do this is:
-- Run a query using "sys.tables" within each database to discover all user tables (type = ‘U’) in the three databases (WideWorldImporters, Bowling, and your chosen DB).

-- HINT: Notice at the top of the sys.tables documentation that some data dictionary columns, such as ‘type,’ are inherited from sys.objects. You do not need to join to this table, but it is something to be aware of. All database ‘objects’ share these inherited attributes.
 
-- SHOW 1: Your queries and query results. The results should include the names of all user tables in each database, when each was created, and last modified date.*/
use WideWorldImporters;
select name, create_date, modify_date from sys.tables
	where type = 'U';
use BowlingLeagueExample;
select name, create_date, modify_date from sys.tables
	where type = 'U';
use RecipesExample;
select name, create_date, modify_date from sys.tables
	where type = 'U';

/*-- During the job interview, you were told that the company recently ran into a customer whose name length exceeded the defined column size. You want to make sure this never happens again. Start by identifying all columns that contain any type of name data. One way to do this is:
-- Run a query using “sys.columns” and "sys.tables" in the same three databases (one query for each) to identify all columns which include the string "name" within the column name. We should also show the currently configured maximum length for these columns. You should also display the tables each column belongs to.

-- HINT: In your SQL, you will need to use the LIKE operator and wildcards to see all relevant columns (such as first_name, customerName, etc.). The wildcards should also consider “name” may be in the middle or at the beginning of the column name.  
-- HINT: You will need to perform a two table JOIN (video review on joins). Keep in mind, many thousands of developers and administrators worldwide are using the data dictionary to answer these types of questions. You can easily do web searches on how to use and join these system catalog views. These data dictionary tables and views are similar for all installations of SQL Server. Try searches such as ‘sql server sys.columns join sys.tables list all columns for each table.’ Also, go read the documentation for sys.columns to see what ‘object_ID’ is!

-- SHOW 2: Your queries and query results for each of the three databases. The results should include: the name of the column, the name of the table the column belongs to, and the current maximum length for that column.*/
use WideWorldImporters;
select sys.columns.name as columns_name, sys.tables.name as tables_name, 
sys.columns.max_length as tables_length
    from sys.columns inner join sys.tables 
        on sys.columns.object_id = sys.tables.object_id
    where sys.columns.name like '%name%' or sys.tables.name like '%name%';

use BowlingLeagueExample;
select sys.columns.name as columns_name, sys.tables.name as tables_name, 
sys.columns.max_length as tables_length
    from sys.columns inner join sys.tables 
        on sys.columns.object_id = sys.tables.object_id
    where sys.columns.name like '%name%' or sys.tables.name like '%name%';

use RecipesExample;
select sys.columns.name as columns_name, sys.tables.name as tables_name, 
sys.columns.max_length as tables_length
    from sys.columns inner join sys.tables 
        on sys.columns.object_id = sys.tables.object_id
    where sys.columns.name like '%name%' or sys.tables.name like '%name%';

/* It is also important to know which databases are your “heavy hitters” in terms of space and resource consumption. 
-- Run queries using the same three databases you previously explored to find out how large each database is and where the largest files are stored. We should also convert the file sizes shown in the data dictionary to MB.

-- HINT: Take a look at the system catalog views regarding databases and files. Try querying them or reading the documentation to determine which to use. You will have to do some conversion, because the “size” column lists a different type of measurement in the documentation. Read it carefully as well as this page for database storage measurements.

-- SHOW 3: 
-- Queries and results which list the file name, file location, and file size (as listed in the database_files catalog view without conversion) of any file greater than size 1024.
-- Queries and results which list the full size of each database in MB. You will have to add the size for each database file using the SUM function and then include the calculations from the hint above. (Video review on using math in your SQL.)
-- Show the screen in your Windows explorer where you navigate to the folder which holds the files (listed in your query from part i). Identify them and compare them to your results from steps i and ii. Your calculations from step ii should match what you see in Windows!*/
use WideWorldImporters;
select sys.database_files.name as file_name, sys.database_files.physical_name as physical_location, (sys.database_files.size * 8/1024) as mb_file_size, sys.database_files.size*8 as kb_file_size
    from sys.database_files; 

use BowlingLeagueExample;
select sys.database_files.name as file_name, sys.database_files.physical_name as physical_location, (sys.database_files.size * 8/1024) as mb_file_size, sys.database_files.size*8 as kb_file_size
    from sys.database_files; 

use RecipesExample;
select sys.database_files.name as file_name, sys.database_files.physical_name as physical_location, (sys.database_files.size * 8/1024) as mb_file_size, sys.database_files.size*8 as kb_file_size
    from sys.database_files; 

/* Take a closer look at any of the catalog tables/views mentioned in the 
week 2 preparation post (Always read the preparation posts!). Read through 
the official Microsoft documentation or the book to find out what the columns 
mean. Find two more items that could be of interest to you in administering 
these databases. 

-- SHOW 4: The two items you discovered in the data dictionary and the 
corresponding query results. Explain why you believe these would be important 
to keep an eye on.*/

-- sys.objects considered the base view, - 
--	The base view contains a subset of columns and a superset of rows.
	-- sys.objects -  does not show DDL triggers, because they are not schema-scoped. 
	-- All triggers, both DML and DDL, are found in sys.triggers. sys.triggers 
	-- supports a mixture of name-scoping rules for the various kinds of triggers.

-- sys.tables the derived view 
-- Returns a row for each user table in SQL Server
--	The derived view contains a superset of columns and a subset of rows.


-- sys.databases information about the databases status, permissions, etc.
-- Contains one row per database in the instance of SQL Server
  -- example:
  SELECT name, user_access_desc, is_read_only, state_desc, recovery_model_desc
	FROM sys.databases;

-- sys.columns - Returns a row for each column of an object that has columns, such as views or tables. The following is a list of object types that have columns:
--		Table-valued assembly functions (FT)
--		Inline table-valued SQL functions (IF)
--		Internal tables (IT)
--		System tables (S)
--		Table-valued SQL functions (TF)
--		User tables (U)
--		Views (V)

select *  from sys.messages as message
	where message.language_id = 1033
	order by message.message_id;


select distinct sys.messages.severity as severity_rating 
	from sys.messages
	order by severity_rating;
