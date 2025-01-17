USE [CANDIDATE_Practical]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 3/5/2024 2:57:57 PM ******/

ALTER PROCEDURE [dbo].[GetEmployees]
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
    --ORDER BY JoinDate DESC
	ORDER BY YEAR(JoinDate) DESC, MONTH(JoinDate) DESC, DAY(JoinDate) DESC, UniqueId ASC
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END