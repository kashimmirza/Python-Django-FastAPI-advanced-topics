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

CREATE PROCEDURE GetEmployees
    @Offset INT,
    @PageSize INT
AS
BEGIN
    SELECT UniqueId,
           CONCAT(FirstName, ' ', LastName) AS Name,
           CASE
               WHEN MONTH(GETDATE()) < MONTH(BirthDate) OR
                    (MONTH(GETDATE()) = MONTH(BirthDate) AND DAY(GETDATE()) < DAY(BirthDate))
               THEN DATEDIFF(YEAR, BirthDate, GETDATE()) - 1
               ELSE DATEDIFF(YEAR, BirthDate, GETDATE())
           END AS Age,
           CONVERT(VARCHAR, JoinDate, 106) AS JoinDate,
           Designation
    FROM Employees_View
    ORDER BY JoinDate DESC
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END

