USE [CANDIDATE_Practical]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCompanyAndAssociatedEmployees]    Script Date: 3/18/2024 2:44:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[DeleteCompanyAndAssociatedEmployees]
    @companyid INT
AS
BEGIN
    SET NOCOUNT OFF;

    BEGIN TRY
        -- Start a transaction
        BEGIN TRANSACTION;

        -- Delete all associated employees from the Employee table
        DELETE FROM Employee WHERE UniqueId IN (
            SELECT empid FROM RelationalTable WHERE CompanyID = @companyid
        );

        -- Delete all associations from the RelationalTable
        DELETE FROM RelationalTable WHERE CompanyID = @companyid;

        -- Delete the company from the Company table
        DELETE FROM CompanyTable WHERE companyid = @companyid;

        -- Commit the transaction
        COMMIT TRANSACTION;

        -- Return success message
        SELECT 'true'
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if an error occurs
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
		--RAISEERROR(@ErrorMessage, 16, 1);
		SELECT 'false'
    END CATCH;
END
