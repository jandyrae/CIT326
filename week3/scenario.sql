/*
W03 Scenario:

Your new manager has many concerns about database security. After reading about a recent data breach in the news, it is one of the things that keeps him up at night. Help calm your manager’s nerves by investigating how to control database security more precisely.

W03 Scenario Submission Guidelines:
Be sure you submit all elements labeled by the bolded word, SHOW.

NOTE: 
If you have doubts about these security tasks, the best approach is to experiment. TRY it, GRANT it, LOGIN (with the new account), and TEST it.
*/

-- The owner of the company has some security questions for you…
-- What is Windows authentication in SQL Server? 
        -- Authentication validates the identity of the user to prevent unauthorized users from using a system.

-- What is one benefit to Windows Authentication over SQL Authentication?
        -- Windows Authentication is considered a 'trusted connection' as it trusts the OS has alredy validated the account and password.

-- Explain the difference between authentication and authorization. Give an example of authorization in the database.
        -- authentication would validate the user whereas authorization would determine what that user has access to.

-- Verify your SQL Server installation is in mixed authorization mode and can accept both Windows and SQL Server Authentication.
        -- see login to verify

-- What would happen if you grant SELECT permission on a table to the fixed database role called ‘public?’ Would this granted permission apply to future users also (users that are not created yet)? Why could this be dangerous? HINT: Look under ‘Fixed Database Roles’ in Chapter 12 or here in the Microsoft documentation.
        --  This could enable unintended privilege escalation.
/* https://learn.microsoft.com/en-us/sql/relational-databases/security/authentication-access/database-level-roles?view=sql-server-ver15 */
/*

SHOW 1: Your understanding by answering these questions confidently. Use the textbook or Microsoft documentation to verify your answers.
*/
-- *******************************************************

-- You have heard that using ‘schemas’ can give you added flexibility and control in database security. You decide to test this by doing the following:
-- Create two new schemas for the Bowling database and two more for an additional database of your choice. You will be creating four schemas total.
-- Transfer the tables in the bowling database and your chosen database out of the dbo (database owner) schema and into the four new schemas. How you choose to separate the tables into these schemas is completely up to you (you will not be graded on that choice). NOTE: Tables can only belong to one schema.
-- Create four new logins and map them to each database (two for each database). Issue a grant command that will give SELECT rights on an entire schema (one for each user). Do this for each of the four logins. Test this authorization by logging in with these new users.

-- HINT: Remember that a “login” is on the instance/server level and is used for authentication. Each login can map to one or more users in each of the databases in the instance. Logins receive instance/server level authorizations. Users receive database/schema/table/etc level authorizations. Consider users to be under the umbrella of a login.


/*
SHOW 2: 
The four new schemas you created and the process you used to do so.
The process you used to transfer the tables into the four new schemas.
Proof that each of the four logins can access the schema intended and no other schemas.
*/
USE [BowlingLeagueExample]
GO
CREATE SCHEMA [registration]
GO
CREATE SCHEMA [scoring]
GO

-- returns list of table names to transfer to new schema
USE [BowlingLeagueExample]
select 'alter schema registration transfer ' + name + ';' from sys.tables;

USE [BowlingLeagueExample]
alter schema registration transfer Bowlers;
alter schema registration transfer Teams;
alter schema registration transfer Tournaments;

-- returns list of table names to transfer to new schema
USE [BowlingLeagueExample]
select 'alter schema scoring transfer ' + name + ';' from sys.tables;

USE [BowlingLeagueExample]
alter schema scoring transfer Bowler_Scores;
alter schema scoring transfer Match_Games;
alter schema scoring transfer Tourney_Matches;


-- creating logins for bowling DB
USE [master]
GO
CREATE LOGIN [bowler_registration] WITH PASSWORD=N'password', DEFAULT_DATABASE=[BowlingLeagueExample], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
CREATE LOGIN [bowler_scoring] WITH PASSWORD=N'password', DEFAULT_DATABASE=[BowlingLeagueExample], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

-- grant privileges for user to access schema (registration)
USE [BowlingLeagueExample]
GO
CREATE USER [bowler_registration] FOR LOGIN [bowler_registration]
GO
ALTER USER [bowler_registration] WITH DEFAULT_SCHEMA=[registration]
GO
-- grant privileges for user to access schema (scoring)
USE [BowlingLeagueExample]
GO
CREATE USER [bowler_scoring] FOR LOGIN [bowler_scoring]
GO
ALTER USER [bowler_scoring] WITH DEFAULT_SCHEMA=[scoring]
GO

-- grant select for schema
use [BowlingLeagueExample]
GO
GRANT SELECT ON SCHEMA::[registration] TO [bowler_registration]
GO

use [BowlingLeagueExample]
GO
GRANT SELECT ON SCHEMA::[scoring] TO [bowler_scoring]
GO

-- show select on registration
/****** Script for SelectTopNRows command from SSMS  ******/
/*
SELECT TOP (100) [BowlerID]
      ,[BowlerLastName]
      ,[BowlerFirstName]
      ,[BowlerMiddleInit]
      ,[BowlerAddress]
      ,[BowlerCity]
      ,[BowlerState]
      ,[BowlerZip]
      ,[BowlerPhoneNumber]
      ,[TeamID]
  FROM [BowlingLeagueExample].[registration].[Bowlers]
  */
-- show select on scoring
/*
/****** Script for SelectTopNRows command from SSMS  ******/
/*
SELECT TOP (1000) [MatchID]
      ,[GameNumber]
      ,[BowlerID]
      ,[RawScore]
      ,[HandiCapScore]
      ,[WonGame]
  FROM [BowlingLeagueExample].[scoring].[Bowler_Scores]
*/


/*
With “user-defined roles,” determine a common level of authorization privileges new users should have in one database of your choice. This may be different for each business model (database) according to your discretion.
First, you decide to create a list of DCL (Data Control Language or “GRANT commands”) to assign to every future entry-level user of a given database. You can choose whatever you would like for the users to be authorized to do.
HINT: Here is a student example of practicing DCL for two test users.

Then, you get smarter and realize you can use a user-defined role as explained in chapter 12 instead of issuing so many separate GRANTS for each individual user. Create a role for new employees and grant the permissions you listed in ‘3a’ directly to the new role instead.		
HINT: Here is the student example from this week’s preparation post on how to use a fixed role for permissions. In your case, you will instead add users to the custom role you create.

Create two new database logins/users and add them as members to the new role from ‘3b’ instead of granting the permissions one by one directly to the users. In this manner, you save time and are less error prone.
*/

/*
SHOW 3: 
All DCL code (“GRANT” statements) from step ‘a’ above.
The process you used to create a role with the needed DCL authorization commands instead.
Proof that the new role works as it should for your two new logins/users.
*/

/*
Investigate these security related data dictionary entries (or others you may find) to see where you can see evidence of the new schemas, logins, users, or role from this assignment in the data dictionary. 
*/

/*
SHOW 4: 

A query and results that include data dictionary information showing evidence of something you did in this assignment (perhaps a query that shows a new schema, login, or user-defined role you created in steps 1, 2, or 3).
One additional data dictionary query regarding anything in database security that might be useful to the business going forward. Include the query, the results, and your explanation for why it would be a useful security report.
*/

-- show newly created or modified users
select login.name,
    users.name,
    login.type_desc,
    login.create_date,
    users.updatedate,
    default_database_name,
    roles
from sys.sql_logins login
    inner join sys.sysusers users on login.sid <> users.sid
where create_date > '2023-01-17'
    or users.updatedate > '2023-01-17';


-- show access to new role
select top (10) * from Members;

INSERT INTO Members (
	[MemberID]
      ,[MbrFirstName]
      ,[MbrLastName]
      ,[MbrPhoneNumber]
      ,[Gender])
 VALUES (1001, 'Jandy', 'Kiger', 555-8401, 'F');

DELETE FROM Members WHERE MemberID = 1001;