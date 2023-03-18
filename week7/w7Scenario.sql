/*
W07 Scenario:

Karl is encouraged by your efforts and wants to ramp up development efforts of the bowling system. He hires Ralph, who says he is a SQL Server DBA, to help you and support a small growing team of developers. It doesn't take you long to find out Ralph has a nasty habit… "Hey, as long as we are just developing things, l just add all new users to the sysadmin server role. That way I can go out for my deep dish pizza without getting a phone call about someone having insufficient privileges and halting development." You know this "natural man" attitude doesn't feel quite right, so you decide to take action.

W07 Scenario Submission Guidelines:

You realize you need to explain to Ralph and Karl why you think the overuse of the sysadmin role (https://www.mssqltips.com/sqlservertip/1887/understanding-sql-server-fixed-server-roles/) can cause trouble and should be avoided at all costs.

	SHOW 1: Your understanding of security best practices by explaining this in your video.
*/

-- sysadmin
    --can do anything within the SQL Server

-- bulkadmin
    -- allows the import of data from external files
    -- have to have INSERT rights on the table
    
-- dbcreator
    -- allows creation of databases within SQL Server
    -- ideal role for a junior DBA

-- diskadmin
    -- allows management of backup devices
    -- (typically automated, this role is rarely used)

-- processadmin
    -- ability to alter any connection
    -- powerful role - can kill connections to SQL Server

-- securityadmin
    -- controls security for the SQL Server
    -- can grant access to databases within SQL Server

-- serveradmin
    -- manages the SQL Server configuration
    -- should really be handled by the DBA, also rarely used

-- setupadmin
    -- gives control over linked servers

/*
Implement a daily scheduled job to check for all logins with the sysadmin role to keep tabs on the extent of this issue and be able to revoke sysadmin when needed.
Create a SQL Authenticated login for Ralph and add it to the sysadmin server role.
Investigate system security catalog views, such as sys.server_principals (https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-server-principals-transact-sql?view=sql-server-ver15) or sys.server_role_members (https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-server-role-members-transact-sql?view=sql-server-ver15), to create a query to list the name of each account with sysadmin privileges and the last modified date of that login. HINT: Do a web search to find an example of such a query. It is a common security question!
Set up a custom audit job that runs daily and inserts the data from your query into a new table each time. The job should have two steps (refer to the stepping stone video). You do not need to make or use a stored procedure. Just use an INSERT INTO SELECT.
Log in as Ralph and simulate his behavior by creating four new logins and adding them all to the sysadmin role.
Run your custom audit job again to see if it captured Ralph’s behavior in step d.

SHOW 2:
A demonstration of you running the new job.
The job history showing all steps successful.
The contents of your custom table (step c) which should include the four new sysadmin logins that Ralph created in step d.

*/
USE msdb
SELECT	roles.principal_id							AS RolePrincipalID
	,	roles.name									AS RolePrincipalName
	,	server_role_members.member_principal_id		AS MemberPrincipalID
	,	members.name								AS MemberPrincipalName
	,	members.modify_date							AS MemberModifyDate
	,	roles.modify_date							AS RoleModifyDate
FROM sys.server_role_members AS server_role_members
INNER JOIN sys.server_principals AS roles
    ON server_role_members.role_principal_id = roles.principal_id
INNER JOIN sys.server_principals AS members 
    ON server_role_members.member_principal_id = members.principal_id  
GO  

-- DROP TABLE IF EXISTS custom_audit.systemAdmins_$(ESCAPE_NONE(DATE))
USE msdb
DROP TABLE IF EXISTS custom_audit.systemAdmins
-- CREATE TABLE custom_audit.systemAdmins_$(ESCAPE_NONE(DATE))
CREATE TABLE custom_audit.systemAdmins
(
RolePrincipalID int
, RolePrincipalName varchar(20)
, RoleModifyDate datetime
, MemberPrincipalID int
, MemberPrincipalName varchar(50)
, MemberModifyDate datetime
);

-- INSERT INTO custom_audit.systemAdmins_$(ESCAPE_NONE(DATE)) (
INSERT INTO custom_audit.systemAdmins (
	RolePrincipalID 
, RolePrincipalName 
, RoleModifyDate 
, MemberPrincipalID 
, MemberPrincipalName 
, MemberModifyDate 
)
SELECT	roles.principal_id							AS RolePrincipalID
	,	roles.name									AS RolePrincipalName
	,	roles.modify_date							AS RoleModifyDate
	,	server_role_members.member_principal_id		AS MemberPrincipalID
	,	members.name								AS MemberPrincipalName
	,	members.modify_date							AS MemberModifyDate

FROM sys.server_role_members AS server_role_members
INNER JOIN sys.server_principals AS roles
    ON server_role_members.role_principal_id = roles.principal_id
INNER JOIN sys.server_principals AS members 
    ON server_role_members.member_principal_id = members.principal_id  
;


-- login_time
SELECT * -- login_name ,COUNT(session_id) AS session_count 
FROM sys.dm_exec_sessions 
-- GROUP BY login_name;

