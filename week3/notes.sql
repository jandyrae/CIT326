/*
The following are the most important database security concepts:

•   Data encryption
        Data encryption is the process of scrambling information so that it is incomprehensible until it is decrypted by the intended recipient
•   Authentication
        Authentication validates the identity of the user
•   Authorization
        Authorization is the process that is applied after the identity of a user is verified through authentication
•   Change tracking
        Change tracking means that actions of users are followed and documented on your system

•   Principals -  Subjects that have permission to access a particular entity. Typical principals are Windows user accounts and SQL Server logins. 

•   Securables The resources to which the database authorization system regulates access. Most securables build a hierarchy, meaning that some of them can be contained within others. Most of them have a certain number of permissions that apply to them. There are three main securable scopes: server, database, and schema.

•   Permissions Every securable has associated permissions that can be granted to a principal. 
*************************************************************

Once the database master key exists, users can use it to create keys. There are three forms of user keys:

•   Symmetric keys
    An encryption system that uses symmetric keys is one in which the sender and receiver of a message share a common key -- has several benefits and one disadvantage. One advantage of using symmetric keys is that they can protect a significantly greater amount of data than can the other two types of user keys. Also, using this key type is faster than using an asymmetric key --- in a distributed environment, using this type of key can make it almost impossible to keep encryption secure.

•   Asymmetric keys
    An asymmetric key consists of two parts: a private key and the corresponding public key. Each key can decrypt data encrypted by the other key. Because of the existence of a private key, asymmetric encryption provides a higher level of security than does symmetric encryption.

•   Certificates
    A public key certificate, usually simply called a certificate, is a digitally signed statement that binds the value of a public key to the identity of the person, device, or service that holds the corresponding private key.
    Certificates contain the following information:

•   The subject’s public key value
•   The subject’s identifier information
•   Issuer identifier information
•   The digital signature of the issuer
-------------------------------------------------

Editing Metadata Concerning User Keys
The most important catalog views in relation to user keys are the following:

•   sys.symmetric_keys

•   sys.asymmetric_keys

•   sys.certificates

•   sys.database_principals

Transparent Data Encryption vs. Always Encrypted
There are several significant differences between TDE and Always Encrypted. The most important one is that TDE encrypts at the database level, while Always Encrypted encrypts at the column level of a table. Therefore, Always Encrypted reduces further the attack’s surface area and the number of people who have access to the data in relation to TDE.

*/

-- The CREATE LOGIN statement creates a new login. The syntax is as follows:
/*
create LOGIN login_name
    -- login_name specifies the name of the login that is being created
{ with option_list1 |
--option_list1 contains several options. The most important one is the PASSWORD option, which specifies the password of the login (see Example 12.8). (The other possible options are DEFAULT_DATABASE, DEFAULT_LANGUAGE, and CHECK_EXPIRATION.)
    from {Windows [with option_list2 [,...] ]
    -- WINDOWS Specifies that the login will be mapped to an existing user account
    -- ASYMMETRIC KEY Specifies the name of the asymmetric key to be associated with this login
    | certificate certname   |   asymmetric key key_name } }
*/

-- https://learning.oreilly.com/library/view/microsoft-sql-server/9781260458886/ch12.xhtml#:-:text=Example

/*
A schema is a collection of database objects that is owned by a single person. The main purpose of a schema is to group logically related objects of a large database in different subunits. The Database Engine supports named schemas using the notion of a principal. A principal can be either of the following:  
- indivisible principal or single user, or a group principal group of users or for a role.
-- CREATE --
use sample; 
create schema my_schema authorization peter;
--CREATE SCHEMA statement can create a schema; create the tables and views it contains; and grant, revoke, or deny permissions on a securable in a single statement
create table product
    (product_no char(10) not null unique, 
    product_name char(20) null,
    price money null);
create view product_info
    as select product_no, product_name 
        from product;
grant select to mary;
deny update to mary;

-- ALTER -- 
alter schema schema_name transfer object_name;
use AdventureWorks;
alter schema HumanResources transfer Person.ContactType;
-- alters the schema called HumanResources of the AdventureWorks database by transferring into it the ContactType table from the Person schema of the same database

-- DROP SCHEMA --
-- The DROP SCHEMA statement removes a schema from the database. 
*/

/*
Default Database Schemas
Each database within the system has the following default database schemas:

•   guest
•   dbo
•   INFORMATION_SCHEMA
•   sys

*/