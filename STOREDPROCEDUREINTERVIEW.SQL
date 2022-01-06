
-- Author:      <MICHAEL YIMER>  
-- Create date: <05-Jan-2022>  
-- Description: <DEFINING A "STUDENTSTAGEHANDLING" STORED PROCEDURE>  
-- ==================================================================================================================================================

CREATE PROCEDURE STUDENTSTAGEHANDLING
    @stageDate1 datetime
--• Input parameter for the staging date
AS
BEGIN
    SET NOCOUNT ON
    -- Affected • Ensure that output from query execution showing number of affected rows is turned off
    BEGIN TRY    --Handling Exception • Error handling block to cover all procedure operations
    -- Process classes from ClassStage where StageDate equals input parameter
   print CONCAT(getdate,'STUDENTSTAGEHANDLING', 'BEGIN') ;   -- Print output at the beginning of the procedure that shows the date/time, 
                                                             -- ‘BEGIN’, procedure name, and parameter value 

   ---------------------------------------------------------------------------------------------------------------------------------------------------
    -- Process classes from ClassStage where StageDate equals input parameter
    -- Insert classes from ClassStage to Class for any class that does not exist
   ---------------------------------------------------------------------------------------------------------------------------------------------------

   insert into class
        (ClassKey, ClassName, ClassTime)
    select ClassKey, ClassName, ClassTime
    from ClassStage
    where StageDate =@stageDate1 and
        WHERE NOT EXISTS (SELECT *
    FROM Class
    WHERE ClassKey  =classtage.classKey  LIMIT 1) 

------------------------------------------------------------------------------------------------------------------------------------------------------
-- Use a cursor to process records from StudentClassStage where StageDate equals input parameter
-- For each distinct Student in the cursor results
-- Insert the Student if it does not exist
-- Insert all of the StudentClass records that do not exist
-- Use a transaction to ensure that all records related to a single student are committed together

  Declare 
      @stageDate  datetime,
            @accountNumber varchar(10),
            @firstName varchar(30),
            @lastName varchar(30),
            @classKey varchar(8),

  Declare cursorStudentClsStge cursor For
  select *
    from StudentClassStage
    where StageDate =@stageDate1
  OPEN cursorStudentClsStge 
           Fetch Next From cursorStudentClsStge Into @stageDate, @accountNumber,@firstName, @lastName, @classKey
     While @@Fetch_Status = 0 Begin

        print CONCAT(@firstName, @lastName,'is being processes');
        --Print output to show each student name as it is being processed

        insert into Studnet
            (AccountNumber, FirstName, LastName)
        values
            (@accountNumber, @firstName, @lastName)
        WHERE NOT EXISTS
        (SELECT *
        FROM student
        WHERE AccountNumber  =@accountNumber
        LIMIT 1)
    End -- End of Fetch
Close cursorStudentClsStge
Deallocate cursorStudentClsStge

--*****************************************************************************************************************************************************
--Show a query result at the end with all students that had any classes added. Showing StudentID, Student full name, Total count of *all* Classes 
--(not just new ones), Time of first class, Time of last class. Only include students whose first class is prior to 5pm. Sort by Student LastName
--=====================================================================================================================================================

Select studentId.Student, Concat(FirstName, ' ',  LastName).Student , classId.class, classTime.class classId.studentclass, count(class.studentClass),
from  Student
Inner Join student.studentid=studentclass.studentId
Inner Join class.classId=studentclass.classId
where class.classtime.time > 5pm.
order by lastName 

--========================================================================================================================================================

  print CONCAT(getdate, 'STUDENTSTAGEHANDLING', 'END'); -- Print output at the end to show the date/time, ‘END’, and procedure name
  END TRY
 BEGIN CATCH
  PRINT(ERROR_MESSAGE()) -- Show Exception Error...
 END CATCH
END  
GO

-- EXECUTE THE STORED PROCEDURE WITH THE CURRENT DATE
EXEC STUDENTSTAGEHANDLING GETDATE
()