USE [CANDIDATE_Practical]
GO
/****** Object:  StoredProcedure [dbo].[Update_Insert_Employee]    Script Date: 3/11/2024 12:24:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Update_Insert_Employee] 
    @UniqueId INT,
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @BirthDate DATETIME,
    @JoinDate DATETIME,
    @Designation VARCHAR(255),
	@CompanyName VARCHAR(255)
AS
BEGIN
    -- Check if the UniqueId already exists in the Employee table
    IF EXISTS (SELECT 1 FROM Employee WHERE UniqueId = @UniqueId)
    BEGIN
        -- Update the existing row
        UPDATE Employee
        SET FirstName = @FirstName,
            LastName = @LastName,
            BirthDate = @BirthDate,
            JoinDate = @JoinDate,
            Designation = @Designation,
			CompanyName = @CompanyName
        WHERE UniqueId = @UniqueId;
        
        -- Return a success message or value if the record was updated
        SELECT 'Record updated successfully' AS Result;
    END
    ELSE
    BEGIN
        -- Return an error message or value if the UniqueId does not exist
        SELECT 'Error: Record not found for UniqueId ' + CAST(@UniqueId AS VARCHAR(10)) AS Result;
    END
END;


