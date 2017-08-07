-- =============================================
-- Author:		Jaime Forero
-- Create date: 07/08/2010
-- Description:	Get next available job
-- =============================================
CREATE PROCEDURE [dbo].[usp_RateChangeGetNextAvailableJob]
	@AccountNumber VARCHAR(50) = NULL,
	@RateChangeQueueID INT = NULL,
	@ProcessingRateChangeQueueID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @NextJobID INT;
	SET @NextJobID = NULL;
	
	DECLARE @Status_Processing INT;
	SET @Status_Processing = 3;
		
	DECLARE @Status_Unsent INT;
	SET @Status_Unsent = 0;
	
	DECLARE @Status_Failed INT;
	SET @Status_Failed = 2;
		
	DECLARE @Status_Accepted INT;
	SET @Status_Accepted = 1;
   
	BEGIN TRY 
		BEGIN TRANSACTION Insert_RateChange
		
			SELECT @NextJobID = [ID] FROM [RateChange]
			WHERE [AccountNumber] = ISNULL(@AccountNumber,[AccountNumber])
				  AND [RateChangeQueueID] = ISNULL(@RateChangeQueueID,[RateChangeQueueID])
				  AND [Status] = @Status_Unsent; 
			
			IF @NextJobID IS NOT NULL 
			BEGIN
				
				UPDATE [RateChange] SET [Status] = @Status_Processing, 
					   [DateModified] = GETDATE(), 
					   [ProcessedBy] = @ProcessingRateChangeQueueID 
			    WHERE [ID] = @NextJobID;
				
				UPDATE [RateChangeQueue] SET [ActualUpdates] = [ActualUpdates] + 1, 
				       [CurrentRateChangeId] = @NextJobID, 
				       [LastUpdate] = GETDATE() 
				WHERE [ID] = @ProcessingRateChangeQueueID;
				
			END
			-- Return the next job, if null then .NET should handle it
			
			SELECT * FROM [RateChange] WHERE [ID] = @NextJobID;
			
		COMMIT TRANSACTION Insert_RateChange
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION Insert_RateChange;
			
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)

	END CATCH
	
	
	
	
	
	
	
END
