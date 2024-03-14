-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE <Procedure_Name, sysname, ProcedureName> 
	-- Add the parameters for the stored procedure here
	<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
	<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
END
GO

CREATE PROCEDURE DeleteCompany
    @companyid INT
AS
BEGIN
    -- Check if there are any employees associated with the company
    IF EXISTS (SELECT 1 FROM RelationalTable WHERE CompanyId = @companyid)
    BEGIN
        -- If there are employees associated with the company, return an error message
        -- or raise an error to indicate that the company cannot be deleted
        RAISERROR('Cannot delete company. Employees are associated with this company.', 16, 1)
    END
    ELSE
    BEGIN
        -- If there are no employees associated with the company, delete records from the relational table
        DELETE FROM RelationalTable WHERE CompanyID = @companyid;

        -- After deleting records from the relational table, delete the company from the company table
        DELETE FROM CompanyTable WHERE CompanyID = @companyid;

        -- Return a success message or code indicating successful deletion
        SELECT 'Company deleted successfully.' AS Result;
    END
END
