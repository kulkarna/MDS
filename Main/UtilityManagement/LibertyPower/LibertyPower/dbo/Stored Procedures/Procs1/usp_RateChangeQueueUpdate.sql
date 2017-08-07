
CREATE PROCEDURE [dbo].[usp_RateChangeQueueUpdate]
(
 @ID INT ,
 @CurrentRateChangeId INT = NULL,
 @NumUpdates INT = NULL,
 @ActualUpdates INT = NULL,
 @Finished BIT
 )
AS
BEGIN


      UPDATE		
          [RateChangeQueue]
      SET
		  [CurrentRateChangeId] = @CurrentRateChangeId,
		  [ActualUpdates] = ISNULL(@ActualUpdates, [ActualUpdates]),
		  [NumUpdates] = ISNULL(@NumUpdates,[NumUpdates]),
		  [Finished] = ISNULL(@Finished, [Finished]),
          [LastUpdate] = GETDATE()
      WHERE
          [ID] = @ID


	   SELECT * 
	   FROM
		   [RateChangeQueue]
	   WHERE
		   [RateChangeQueue].[ID] = @ID
         
END


