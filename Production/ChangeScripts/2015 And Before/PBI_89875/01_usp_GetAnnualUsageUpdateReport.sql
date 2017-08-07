USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAnnualUsageUpdateReport]    Script Date: 10/8/2015 4:54:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_GetAnnualUsageUpdateReport
 * <Purpose,,>
 * This  SP Retrurns  the List of Accounts currently actively enrolled
 * 
 * History

 *******************************************************************************
 * 10/08/2015 - Manoj Thanath
 * Created.
 *******************************************************************************
 */
ALTER PROC usp_GetAnnualUsageUpdateReport
  
AS
BEGIN
   SET NOCOUNT ON;         
   BEGIN TRY

	   DECLARE @CurrDate Datetime
			,@TotalAccountBegin     	INT
			,@TotalAccountProcessed		INT
			,@TotalAccountPending		INT
			,@TotalAccountUpdated		INT
			
		    SELECT @CurrDate = GETDATE();
         ---  Get the List of Accouts from the table
         select @TotalAccountBegin = Count(*) 
         from libertyPower..AnnualUsageTranDetail( nolock) a
        
		 select @TotalAccountProcessed = Count(*) 
         from libertyPower..AnnualUsageTranDetail( nolock) a
         where a.Iscomplete = 1;
         
		 select @TotalAccountPending = Count(*) 
         from libertyPower..AnnualUsageTranDetail( nolock) a
         where ((a.Iscomplete <> 1) OR (a.Iscomplete is null))
         AND a.AnnualUsage is null ;

		 select @TotalAccountUpdated = Count(*) 
         FROM [Libertypower].[dbo].[AccountUsage](nolock)a
		 where a.ModifiedBy = 3705
		 AND  Modified >= @CurrDate -1;

		 SELECT @TotalAccountBegin,@TotalAccountProcessed,@TotalAccountPending,@TotalAccountUpdated;
		 
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
