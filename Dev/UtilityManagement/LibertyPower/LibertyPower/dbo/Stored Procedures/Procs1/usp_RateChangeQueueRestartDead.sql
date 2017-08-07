-- =============================================
-- Author:		 Jaime Forero
-- Create date:  7/13/2010
-- Description:	 re-schedules rate update jobs that have been idle for more than 1 minute.
-- =============================================
CREATE PROCEDURE [dbo].[usp_RateChangeQueueRestartDead]
	
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Status_Processing INT;
	SET @Status_Processing = 3;
	DECLARE @Status_Unsent INT ;
	SET @Status_Unsent = 0;
	DECLARE @Status_Failed INT ;
	SET @Status_Failed = 2;
	DECLARE @Status_Accepted INT ;
	SET @Status_Accepted = 1
	DECLARE @Threshold INT ;
	SET  @Threshold = 1;
   
	
   
	DECLARE @deadThreads TABLE 
	(
		QueueID INT,
		RateChangeID INT
	)
	
	BEGIN TRY 
		BEGIN TRANSACTION AwakeDeadThreads;
		
			INSERT INTO @deadThreads
				SELECT Q.ID, R.ID FROM RateChangeQueue Q
				JOIN RateChange R ON Q.CurrentRateChangeId = R.ID
				WHERE R.[Status] = @Status_Processing
				AND  DATEDIFF(MINUTE,Q.LastUpdate, GETDATE()) > @Threshold;
				
			-- SELECT * FROM @deadThreads; 
			
			UPDATE RateChangeQueue
			SET [Failed] = 1, [CurrentRateChangeID] = NULL, [Finished] = 1, [LastUpdate] = GETDATE(), [ActualUpdates] = [ActualUpdates] - 1
			WHERE [ID] IN (SELECT QueueID FROM @deadThreads);
			
					
			UPDATE RateChange
			SET [Status] = @Status_Unsent
			WHERE ID IN (SELECT RateChangeID FROM @deadThreads);
			
			-- NOW if for any chance a thread died before updating its own status, 
			-- but had actually processed the request
			DELETE FROM @deadThreads;
			
			INSERT INTO @deadThreads
				SELECT Q.ID, R.ID FROM RateChangeQueue Q
				JOIN RateChange R ON Q.CurrentRateChangeId = R.ID
				WHERE R.[Status] IN (@Status_Accepted, @Status_Failed)
				AND  DATEDIFF(MINUTE,Q.LastUpdate, GETDATE()) > @Threshold;
			
			UPDATE RateChangeQueue
			SET [Failed] = 1, [CurrentRateChangeID] = NULL, [Finished] = 1, [LastUpdate] = GETDATE(), [ActualUpdates] = [ActualUpdates] - 1
			WHERE [ID] IN (SELECT QueueID FROM @deadThreads);
			
			
		COMMIT TRANSACTION AwakeDeadThreads;
	END TRY
	
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION AwakeDeadThreads;
			
		DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)

	END CATCH
		
END
