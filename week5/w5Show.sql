/*
W05 Scenario:


Karl, the owner of the bowling alley, has decided that he wants to start emailing "lunch & bowl" coupons to the league members between seasons. As you go to look at the bowler table to add this new column, you have a feeling that not everyone should be able to view the personally identifiable information in the bowling table. You decide to take some steps to keep lower-level employees from seeing the contact information of each bowler.

W05 Scenario Submission Guidelines:
*/

/*
1. Create a new email address column for bowlers:

    a. Verify that you have a recent backup of your bowling database or take a new one.
    b. Write an SQL ALTER TABLE statement to add an e-mail address column alter statement to add an email address column of length 50 to the "bowlers" table.
    c. Write an UPDATE statement (not INSERT) to simulate email addresses for each customer using their first name plus last name @gmail.com (for example, row 1 should be barbarafournier@gmail.com ). You will use concatenation (this tutorial shows how) to do this.
    NOTE: Save your commands from steps 1-3, so you can run them again on the class server in step 4!
 
SHOW 1: The contents of the bowlers table with the new email addresses you added. (If you already encrypted the value in a future step, you can simply show the commands you used in this step along with the encrypted contents.)

*/

/*
*	Jandy Kiger
*	Week 5 Scenario
*/
-- verify backup is recent
SELECT bs.database_name,
    backuptype = CASE 
        WHEN bs.type = 'D' AND bs.is_copy_only = 0 THEN 'Full Database'
        WHEN bs.type = 'D' AND bs.is_copy_only = 1 THEN 'Full Copy-Only Database'
        WHEN bs.type = 'I' THEN 'Differential database backup'
        WHEN bs.type = 'L' THEN 'Transaction Log'
        WHEN bs.type = 'F' THEN 'File or filegroup'
        WHEN bs.type = 'G' THEN 'Differential file'
        WHEN bs.type = 'P' THEN 'Partial'
        WHEN bs.type = 'Q' THEN 'Differential partial'
        END + ' Backup',
    CASE bf.device_type
        WHEN 2 THEN 'Disk'
        WHEN 5 THEN 'Tape'
        WHEN 7 THEN 'Virtual device'
        WHEN 9 THEN 'Azure Storage'
        WHEN 105 THEN 'A permanent backup device'
        ELSE 'Other Device'
        END AS DeviceType,
    bms.software_name AS backup_software,
    bs.recovery_model,
    bs.compatibility_level,
    BackupStartDate = bs.Backup_Start_Date,
    BackupFinishDate = bs.Backup_Finish_Date,
    LatestBackupLocation = bf.physical_device_name,
    backup_size_mb = CONVERT(DECIMAL(10, 2), bs.backup_size / 1024. / 1024.),
    compressed_backup_size_mb = CONVERT(DECIMAL(10, 2), bs.compressed_backup_size / 1024. / 1024.),
    database_backup_lsn, -- For tlog and differential backups, this is the checkpoint_lsn of the FULL backup it is based on.
    checkpoint_lsn,
    begins_log_chain,
    bms.is_password_protected
FROM msdb.dbo.backupset bs
LEFT JOIN msdb.dbo.backupmediafamily bf
    ON bs.[media_set_id] = bf.[media_set_id]
INNER JOIN msdb.dbo.backupmediaset bms
    ON bs.[media_set_id] = bms.[media_set_id]
WHERE bs.backup_start_date > DATEADD(MONTH, - 2, sysdatetime()) --only look at last two months
and database_name = 'bowling_TEST'
-- where recovery_model = 'FULL'
ORDER BY bs.database_name ASC,
    bs.Backup_Start_Date DESC;

-- write an alter table statement to add email addresses
ALTER TABLE registration.Bowlers
ADD BowlerEmail varchar(50);

select * from bowling_TEST.registration.Bowlers;
-- built the update statement from a select with concatenation
select CONCAT('UPDATE bowling_TEST.registration.Bowlers
SET BowlerEmail = ''', LOWER(BowlerFirstName), LOWER(BowlerLastName), '@gmail.com''', ' where BowlerID = ', BowlerID) as update_statement from bowling_TEST.registration.Bowlers;

-- returned update statement pasted to update rows
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'barbarafournier@gmail.com' where BowlerID = 1
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'davidfournier@gmail.com' where BowlerID = 2
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'johnkennedy@gmail.com' where BowlerID = 3
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'sarasheskey@gmail.com' where BowlerID = 4
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'annpatterson@gmail.com' where BowlerID = 5
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'neilpatterson@gmail.com' where BowlerID = 6
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'davidviescas@gmail.com' where BowlerID = 7
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'stephanieviescas@gmail.com' where BowlerID = 8
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'alastairblack@gmail.com' where BowlerID = 9
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'dougsteele@gmail.com' where BowlerID = 10
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'angelkennedy@gmail.com' where BowlerID = 11
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'carolviescas@gmail.com' where BowlerID = 12
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'elizabethhallmark@gmail.com' where BowlerID = 13
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'garyhallmark@gmail.com' where BowlerID = 14
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'kathrynpatterson@gmail.com' where BowlerID = 15
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'richardsheskey@gmail.com' where BowlerID = 16
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'kendrahernandez@gmail.com' where BowlerID = 17
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'michaelhernandez@gmail.com' where BowlerID = 18
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'johnviescas@gmail.com' where BowlerID = 19
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'suzanneviescas@gmail.com' where BowlerID = 20
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'zacharyehrlich@gmail.com' where BowlerID = 21
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'alainahallmark@gmail.com' where BowlerID = 22
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'calebviescas@gmail.com' where BowlerID = 23
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'sarahthompson@gmail.com' where BowlerID = 24
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'meganpatterson@gmail.com' where BowlerID = 25
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'marythompson@gmail.com' where BowlerID = 26
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'williamthompson@gmail.com' where BowlerID = 27
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'michaelviescas@gmail.com' where BowlerID = 28
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'baileyhallmark@gmail.com' where BowlerID = 29
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'rachelpatterson@gmail.com' where BowlerID = 30
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'benclothier@gmail.com' where BowlerID = 31
UPDATE bowling_TEST.registration.Bowlers  SET BowlerEmail = 'joerosales@gmail.com' where BowlerID = 32
/*
2. Under the chapter section, "Data Security and Views," we learn how we can keep users from seeing certain columns that they should not view: 

    a. Create a new login/user for a junior employee. Name it bob_the_scorekeeper and use a password of your choice.
    b. Create a view that displays all other information in the "bowlers" table except for street address, phone number and email address for each bowler. The view must be created using the same schema name as the bowling table. Grant access to this view to the new user created in step 1. 
    NOTE: Generate and save your scripts from steps 1-3 so you can run them on the class server in step 4!

SHOW 2: That the view works by logging in to the database as the new user and selecting from the view. Provide a screenshot that shows that the personal information (other than first and last name) is not displayed in the results.
*/
USE [master]
GO
CREATE LOGIN [bob_the_scorekeeper] WITH PASSWORD=N'password', DEFAULT_DATABASE=[bowling_TEST], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
-- create user for login in bowling_test
USE bowling_TEST;
CREATE USER [bob_the_scorekeeper] FOR LOGIN [bob_the_scorekeeper];

-- grant select for the view to see the view created in that schema

use [bowling_TEST]
GO
GRANT SELECT ON [registration].[scorekeeper_view] TO [bob_the_scorekeeper]
GO

USE bowling_TEST;
CREATE VIEW registration.scorekeeper_view as 
(SELECT [BowlerID]
      ,[BowlerLastName]
      ,[BowlerFirstName]
      ,[BowlerMiddleInit]
      ,[BowlerCity]
      ,[BowlerState]
      ,[BowlerZip]
      ,[TeamID]
	  from registration.Bowlers)

/*
3. Your new programmer needs a bit more access than Bob the scorekeeper. Create her a login/user called "carol_the_programmer" with a password of your choice. Carol needs to be able to see all the columns, but not the actual data. To solve this, you should:

    a. Implement column level encryption (as shown at that link or in the stepping stones) on street address, phone number and email address columns.
    b. Grant Carol the ability to select and insert into the "bowlers" table.
    NOTE: Generate and save your scripts from steps 1-3 so you can run them on the class server in step 4!

SHOW 3: A connection logged in as Carol and prove that she only sees encrypted values in the address, phone number, and email columns.

*/
USE [master]
GO
CREATE LOGIN [carol_the_programmer] WITH PASSWORD=N'password', DEFAULT_DATABASE=[bowling_TEST], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
-- create user for login in bowling_test
USE bowling_TEST;
CREATE USER [carol_the_programmer] FOR LOGIN [carol_the_programmer];

-- grant select for the schema to see the view created in that schema
GRANT SELECT ON SCHEMA::[registration] TO [carol_the_programmer];


USE bowling_TEST;
CREATE VIEW registration.programmer_view as 
(SELECT [BowlerID]
      ,[BowlerLastName]
      ,[BowlerFirstName]
      ,[BowlerMiddleInit]
      ,[BowlerCity]
      ,[BowlerState]
      ,[BowlerZip]
      ,[TeamID]
	  from registration.Bowlers)
/*
4. Let's test your level of security with a classmate's help!

    a. Repeat your saved scripts from steps 1-3 in your bowling database on the cloud class server. You should have copied this database last week. OR, you can once again backup your bowling database and restore it to the class server (using the stepping stone instructions from last week). 
    b. Create the same logins from steps 1-3 on the class cloud server, but this time add your last name after Bob and Carol (such as carol_jones_the_programmer).
    c. Give the names of these logins and their passwords to a running buddy. You, in turn, should receive logins from another student. HINT: If you are having trouble arranging this, make or respond to a post in the weekly Teams channel. It is alright if you need to login to someone’s database who already has had someone else look as well.
    d. Login to your running buddy's (or other classmate’s) database and scout out what you can see as Bob and as Carol. The sensitive data should be encrypted and/or protected with views. Are you able to see more than you should with the account? Are you able to do anything you are not intended to do, such as delete a row or make a new table?
    e. Report your findings to your classmate.

SHOW 4:
Your connections to your classmate’s database (one as Bob, one as Carol).
What you were able to see and do when logged in as each account. NOTE: You are not required to submit anything regarding what they found in your database (only what you saw in theirs).
*/

-- write an alter table statement to add email addresses
ALTER TABLE kiger_bowling_development.registration.Bowlers
ADD BowlerEmail varchar(50);

select * from kiger_bowling_development.registration.Bowlers;
-- built the update statement from a select with concatenation
select CONCAT('UPDATE kiger_bowling_development.registration.Bowlers
SET BowlerEmail = ''', LOWER(BowlerFirstName), LOWER(BowlerLastName), '@gmail.com''', ' where BowlerID = ', BowlerID) as update_statement from kiger_bowling_development.registration.Bowlers

--- try this... 
UPDATE kiger_bowling_development.registration.Bowlers
SET BowlerEmail = LOWER(BowlerFirstName) + LOWER(BowlerLastName) + '@gmail.com';

-- 2
USE [master]
GO
CREATE LOGIN [bob_kiger_the_scorekeeper] WITH PASSWORD=N'password', DEFAULT_DATABASE=[kiger_bowling_development], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
-- create user for login in kiger_bowling_development
USE kiger_bowling_development;
CREATE USER [bob_kiger_the_scorekeeper] FOR LOGIN [bob_kiger_the_scorekeeper];

-- grant select for the schema to see the view created in that schema
GRANT SELECT ON SCHEMA::[registration] TO [bob_kiger_the_scorekeeper];
use [kiger_bowling_development]
GO
GRANT SELECT ON [registration].[scorekeeper_view] TO [bob_kiger_the_scorekeeper]
GO

USE kiger_bowling_development;
CREATE VIEW registration.scorekeeper_view as 
(SELECT [BowlerID]
      ,[BowlerLastName]
      ,[BowlerFirstName]
      ,[BowlerMiddleInit]
      ,[BowlerCity]
      ,[BowlerState]
      ,[BowlerZip]
      ,[TeamID]
	  from registration.Bowlers)

	  -- 3
USE [master]
GO
CREATE LOGIN [carol_kiger_the_programmer] WITH PASSWORD=N'password', DEFAULT_DATABASE=[kiger_bowling_development], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
-- create user for login in kiger_bowling_development
USE kiger_bowling_development;
CREATE USER [carol_kiger_the_programmer] FOR LOGIN [carol_kiger_the_programmer];

-- grant select for the TABLE to see the view created in that schema

use [kiger_bowling_development];

GRANT INSERT ON [registration].[Bowlers] TO [carol_kiger_the_programmer];
GRANT SELECT ON [registration].[Bowlers] TO [carol_kiger_the_programmer];


-- change to carol's login and check to see if only encrypted view on email, address, and phone number
SELECT [BowlerID]
      ,[BowlerLastName]
      ,[BowlerFirstName]
      ,[BowlerMiddleInit]
      ,[BowlerAddress]
      ,[BowlerCity]
      ,[BowlerState]
      ,[BowlerZip]
      ,[BowlerPhoneNumber]
      ,[TeamID]
      ,[BowlerEmail]
  FROM [kiger_bowling_development].[registration].[Bowlers] 