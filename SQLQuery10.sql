USE [CANDIDATE_Practical]
ALTER PROCEDURE [dbo].[Insert_Employee] 
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @BirthDate DATETIME,
    @JoinDate DATETIME,
    @Designation VARCHAR(255),
    @CompanyName VARCHAR(255)
AS
BEGIN
    DECLARE @empid INT;
    DECLARE @CompanyId INT;

    -- Get the CompanyId based on the provided CompanyName
    SELECT @CompanyId = CompanyId FROM CompanyTable WHERE CompanyName = @CompanyName;

    -- Check if the company exists
    IF @CompanyId IS NULL
    BEGIN
        RAISERROR ('The specified company does not exist.', 16, 1);
        RETURN; -- Exit the stored procedure
    END;

    -- Insert into Employee table
    INSERT INTO Employee (FirstName, LastName, BirthDate, JoinDate, Designation, CompanyName)
    VALUES (@FirstName, @LastName, @BirthDate, @JoinDate, @Designation, @CompanyName);

    -- Get the UniqueId of the newly inserted employee
    SET @empid = SCOPE_IDENTITY();

    -- Insert into RelationalTable
    INSERT INTO RelationalTable (empid, CompanyId)
    VALUES (@empid, @CompanyId);
END;

