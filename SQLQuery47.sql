USE [CANDIDATE_Practical]
GO
/****** Object:  StoredProcedure [dbo].[Update_Insert_Employee]    Script Date: 3/13/2024 9:50:47 AM ******/
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
	@companyid    
	--@CompanyName VARCHAR(255)
    --@CompanyName VARCHAR(255) = NULL  -- Optional parameter for updating CompanyName
  
AS
BEGIN
    DECLARE @CompanyId INT;
	

    -- If CompanyName is provided, get the CompanyId based on the provided CompanyName
    IF @CompanyName IS NOT NULL
    BEGIN
        SELECT @CompanyId = companyid FROM CompanyTable WHERE CompanyName = @CompanyName;
        
        -- Check if the company exists
        IF @CompanyId IS NULL
        BEGIN
            RAISERROR ('The specified company does not exist.', 16, 1);
            RETURN; -- Exit the stored procedure
        END;
    END;

    -- Update Employee table
    UPDATE Employee
    SET FirstName = @FirstName,
        LastName = @LastName,
        BirthDate = @BirthDate,
        JoinDate = @JoinDate,
        Designation = @Designation
    WHERE UniqueId = @UniqueId;

    -- If CompanyName is provided, update the CompanyId in the RelationalTable

	
	IF @CompanyName IS NOT NULL
BEGIN
    -- Update both empid and CompanyId in RelationalTable based on CompanyName
    UPDATE RelationalTable
    SET empid = CASE
                    WHEN empid IS NULL THEN @UniqueId  -- Assign UniqueId parameter if empid is null
                    ELSE empid  -- Leave empid unchanged
                END,
        CompanyId = @CompanyId

      WHERE empid = @UniqueId
    --WHERE CompanyId IN (SELECT companyid FROM CompanyTable WHERE CompanyName = @CompanyName);
END;
  --  IF @CompanyName IS NOT NULL
	 --   UPDATE RelationalTable
  --                  SET empid = CASE
  --                  WHEN empid IS NULL THEN @UniqueId  -- Assign UniqueId parameter if empid is null
  --                  ELSE empid  -- Leave empid unchanged
  --              END,
  --      CompanyId = @CompanyId
  --  WHERE CompanyId IN (SELECT CompanyId FROM CompanyTable WHERE CompanyName = @CompanyName);
  --      SET empid = @UniqueId;
  --      UPDATE RelationalTable
  --      SET CompanyId = @CompanyId
		--WHERE empid = @UniqueId;
    
END;
