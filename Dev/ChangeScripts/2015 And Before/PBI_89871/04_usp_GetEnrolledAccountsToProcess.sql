USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetEnrolledAccountsToProcess]    Script Date: 10/8/2015 4:54:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_GetEnrolledAccountsToProcess
 * <Purpose,,>
 * This  SP Retrurns  the List of Accounts currently actively enrolled
 * 
 * History

 *******************************************************************************
 * 10/08/2015 - Manoj Thanath
 * Created.
 *******************************************************************************
 */
ALTER PROC usp_GetEnrolledAccountsToProcess
   (@p_NumberofAccount	int		= NULL
	)
    
AS
BEGIN
   SET NOCOUNT ON;         
   BEGIN TRY
         ---  Get the List of Accouts from the table
         select TOP (@p_NumberofAccount) AccountId,AccountNumber,UtilityId
         from libertyPower..AnnualUsageTranDetail( nolock) a
         where ((a.Iscomplete <> 1) OR (a.Iscomplete is null))
         AND a.AnnualUsage is null ;

  END TRY
	BEGIN CATCH
		SELECT ERROR_NUMBER() AS ErrorNumber
			,ERROR_SEVERITY() AS ErrorSeverity
			,ERROR_STATE() AS ErrorState
			,ERROR_PROCEDURE() AS ErrorProcedure
			,ERROR_LINE() AS ErrorLine
			,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
	
    SET NOCOUNT OFF;

END
