USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_CheckAnnualUsageJobStatus]    Script Date: 10/8/2015 4:54:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_CheckAnnualUsageJobStatus 
 * <Purpose,,>
 * This  SP Retrurns  the LStatus of the AnnualUsageJosb status for the Processor
 * 
 * History

 *******************************************************************************
 * 10/08/2015 - Manoj Thanath
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_CheckAnnualUsageJobStatus](
	 @p_IntervalDays	INT = null
	) 
	
AS

BEGIN
   SET NOCOUNT ON;   
   DECLARE @CurrDate Datetime = GETDATE()
	,@JobStartDate					Datetime
	,@CountUprocessed				INT
	,@AccountId					INT 
	,@ReturnStatus				INT  
	,@DateRange datetime   
   BEGIN TRY
        
		SELECT TOP 1 @JobStartDate = a.CreateDate
		FROM  libertypower..AnnualUsageTranDetail a(nolock)
		Order by a.CreateDate desc

		SELECT @CountUprocessed  = Count(ID) 
		FROM  libertypower..AnnualUsageTranDetail a(nolock)
		where (a.Iscomplete IS NULL)

		SET @DateRange =  DATEADD(DAY, -(@p_IntervalDays), @CurrDate) ;

		IF   (@JobStartDate < @DateRange )
		     BEGIN
                SET @ReturnStatus = 1;  -- Re -Load all the data and re-process from begining
			 END
		ELSE IF ((@JobStartDate > @DateRange) AND (@CountUprocessed > 0)) 
		     BEGIN
		        SET @ReturnStatus = 2; -- Just re-process the existing already uploaded Data.
			 END 
		ELSE 
		     BEGIN
		        SET @ReturnStatus = 3; 
			 END

		SELECT @ReturnStatus; 

	    --*********************************************************
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

-- Copyright 06/11/2015 Liberty Power
