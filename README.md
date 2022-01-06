# T-SQL-STORED-PROCEDURE-LOGICAL-PROBLEM-MY-SOLUTION-APPROACH
T-SQL STORED PROCEDURE: LOGICAL PROBLEM &amp; MY SOLUTION &amp; APPROACH


SQL Server Store Procedure Exercise
11/4/2020

Instructions:
Create a T-SQL stored procedure according to the requirements below.  Pay attention to the details of the table definitions to augment the requirements.

Stored Procedure Requirements
•	Input parameter for the staging date
•	Ensure that output from query execution showing number of affected rows is turned off
•	Print output statements
o	Print output at the beginning of the procedure that shows the date/time, ‘BEGIN’, procedure name, and parameter value
o	Print output to show each student name as it is being processed
o	Print output at the end to show the date/time, ‘END’, and procedure name
•	Error handling block to cover all procedure operations
o	If there is a transaction in process roll it back
o	Throw the error to be available to the calling application
•	Process classes from ClassStage where StageDate equals input parameter
o	Insert classes from ClassStage to Class for any class that does not exist
•	Use a cursor to process records from StudentClassStage where StageDate equals input parameter
o	For each distinct Student in the cursor results
•	Insert the Student if it does not exist
•	Insert all of the StudentClass records that do not exist
•	Use a transaction to ensure that all records related to a single student are committed together
•	Show a query result at the end with all students that had any classes added. Showing StudentID, Student full name, Total count of *all* Classes (not just new ones), Time of first class, Time of last class. Only include students whose first class is prior to 5pm. Sort by Student LastName
•	Format code for readability; add comments if they help to understand the code better

Table Definition Reference
 
ClassStage
•	StageDate date not null
•	ClassKey varchar(8) not null
•	ClassName varchar(30) not null
•	ClassTime time not null
 
StudentClassStage
•	StageDate date not null
•	AccountNumber varchar(10) not null
•	FirstName varchar(30) not null
•	LastName varchar(30) not null
•	ClassKey varchar(8) not null
 
Class
•	ClassID int identity not null; primary key
•	ClassKey varchar(8); unique index
•	ClassName varchar(30) not null
•	ClassTime time not null
•	CreateDT smalldatetime not null; default getdate()
 
Student
•	StudentID int identity not null; primary key
•	AccountNumber varchar(20) not null; unique index
•	FirstName varchar(30) not null
•	LastName varchar(30) not null
•	CreateDT smalldatetime not null; default getdate()
 
StudentClass
•	StudentID int not null; FK to Student
•	ClassID int not null; FK to Class
•	CreateDT smalldatetime not null; default getdate()
 
Sample Data

ClassStage	 	 	 
StageDate	ClassKey	ClassName	ClassTime
8/16/2020	HIST-100	American History I	12:00
8/16/2020	HIST-101	American History II	12:00
8/16/2020	LANG-100	English I	10:00
8/16/2020	LANG-101	English II	10:00
8/16/2020	MATH-100	Algebra I	08:00
8/16/2020	MATH-101	Algebra II	08:00
8/16/2020	PE-100	Weight Training	14:00
8/16/2020	PE-101	Nutrition and Fitness	14:00
8/17/2020	HIST-200	World History I	12:00
8/17/2020	HIST-201	World History II	12:00
8/17/2020	LANG-200	French I	10:00
8/17/2020	LANG-201	French II	10:00
8/17/2020	MATH-200	Calculus I	08:00
8/17/2020	MATH-201	Calculus II	08:00
8/17/2020	PE-200	Swimming	14:00
8/17/2020	PE-201	Golf	14:00
8/18/2020	HIST-500	Night History I	20:00
8/18/2020	LANG-500	Night English I	19:00
8/18/2020	MATH-500	Night Algebra I	18:00


StudentClassStage	 	 	 	 
StageDate	AccountNumber	FirstName	LastName	ClassKey
8/16/2020	1000-1001	John	Able	LANG-100
8/16/2020	1000-1001	John	Able	MATH-100
8/16/2020	1000-1001	John	Able	PE-100
8/16/2020	1000-2002	Mary	Bell	HIST-100
8/16/2020	1000-2002	Mary	Bell	LANG-100
8/16/2020	1000-2002	Mary	Bell	MATH-100
8/16/2020	1000-2002	Mary	Bell	PE-100
8/16/2020	1000-3003	Ted	Cross	HIST-101
8/16/2020	1000-3003	Ted	Cross	MATH-101
8/16/2020	1000-3003	Ted	Cross	PE-101
8/16/2020	1000-4004	Bob	Johns	HIST-101
8/16/2020	1000-4004	Bob	Johns	LANG-101
8/16/2020	1000-4004	Bob	Johns	MATH-101
8/17/2020	2000-1001	Donna	Doe	HIST-200
8/17/2020	2000-1001	Donna	Doe	LANG-200
8/17/2020	2000-1001	Donna	Doe	MATH-200
8/17/2020	2000-2002	Larry	Leed	HIST-201
8/17/2020	2000-2002	Larry	Leed	LANG-201
8/17/2020	2000-2002	Larry	Leed	MATH-201
8/17/2020	2000-2002	Larry	Leed	PE-201
8/18/2020	3000-1001	Barry	White	HIST-500
8/18/2020	3000-1001	Barry	White	LANG-500
8/18/2020	3000-1001	Barry	White	MATH-500
8/18/2020	3000-2002	Ellen	Snow	HIST-500
8/18/2020	3000-2002	Ellen	Snow	LANG-500
8/18/2020	3000-2002	Ellen	Snow	MATH-500
8/18/2020	1000-4004	Bob	Johns	PE-101
8/18/2020	2000-1001	Donna	Doe	PE-200


Class	 	 	 	 
ClassID	ClassKey	ClassName	ClassTime	CreateDT
1	HIST-100	American History I	12:00	8/15/2020 10:02
2	LANG-101	English II	10:00	8/15/2020 10:02
3	MATH-100	Algebra I	08:00	8/15/2020 10:02
4	HIST-200	World History I	12:00	8/15/2020 10:02
5	LANG-200	French I	10:00	8/15/2020 10:02
6	HIST-500	Night History I	20:00	8/15/2020 10:02


Student	 	 	 	 
StudentID	AccountNumber	FirstName	LastName	CreateDT
1	1000-1001	John	Able	8/15/2020 10:03
2	1000-3003	Ted	Cross	8/15/2020 10:03
3	3000-1001	Barry	White	8/15/2020 10:03


StudentClass	 	 
StudentID	ClassID	CreateDT
1	1	8/15/2020 10:03
2	2	8/15/2020 10:03
3	6	8/15/2020 10:03

