USE [CANDIDATE_Practical]
GO
/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 3/12/2024 9:09:32 AM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--/****** Object:  StoredProcedure [dbo].[GetEmployees]    Script Date: 3/5/2024 2:57:57 PM ******/

--ALTER PROCEDURE [dbo].[GetEmployees]
--    @Offset INT,
--    @PageSize INT
--AS
--BEGIN
--    SELECT UniqueId,
--           CONCAT(FirstName, ' ', LastName) AS Name,
--           CASE
--               WHEN MONTH(GETDATE()) < MONTH(BirthDate) OR
--                    (MONTH(GETDATE()) = MONTH(BirthDate) AND DAY(GETDATE()) < DAY(BirthDate))
--               THEN DATEDIFF(YEAR, BirthDate, GETDATE()) - 1
--               ELSE DATEDIFF(YEAR, BirthDate, GETDATE())
--           END AS Age,
--           CONVERT(VARCHAR, JoinDate, 106) AS JoinDate,
--           Designation,
--		   CompanyName
		   
--    FROM Employees_View
--    --ORDER BY JoinDate DESC
--	ORDER BY  UniqueId desc --YEAR(JoinDate) DESC, MONTH(JoinDate) DESC, DAY(JoinDate) DESC,
--    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
--END


ALTER PROCEDURE [dbo].[GetEmployees]
    @Offset INT,
    @PageSize INT
AS
BEGIN
    SELECT e.UniqueId,
           CONCAT(e.FirstName, ' ', e.LastName) AS Name,
           CASE
               WHEN MONTH(GETDATE()) < MONTH(e.BirthDate) OR
                    (MONTH(GETDATE()) = MONTH(e.BirthDate) AND DAY(GETDATE()) < DAY(e.BirthDate))
               THEN DATEDIFF(YEAR, e.BirthDate, GETDATE()) - 1
               ELSE DATEDIFF(YEAR, e.BirthDate, GETDATE())
           END AS Age,
           CONVERT(VARCHAR, e.JoinDate, 106) AS JoinDate,
           e.Designation,
           c.CompanyName
    FROM Employees_View e
    LEFT JOIN EmployeeCompany ec ON e.UniqueId = ec.EmpId
    LEFT JOIN Company c ON ec.CompId = c.CompId
    ORDER BY e.UniqueId DESC
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END;
