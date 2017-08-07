
CREATE PROCEDURE [dbo].[usp_ProfilingQueueStatusUpdate]
@QueueId	  int,
@QueueStatus int,
@User   varchar(50),
@ResultOutput varchar(MAX) = NULL

AS
BEGIN TRANSACTION

IF @ResultOutput IS NULL
BEGIN
    UPDATE ProfilingQueue  SET [Status] = @QueueStatus WHERE ID = @QueueId
END
ELSE
BEGIN
    UPDATE ProfilingQueue  SET [Status] = @QueueStatus, ResultOutput = @ResultOutput WHERE ID = @QueueId
END 

IF @QueueStatus = 1
BEGIN
 UPDATE ProfilingQueue  SET DateStarted = getdate() WHERE ID = @QueueId
END
ELSE IF @QueueStatus = 2 OR @QueueStatus = 3 
BEGIN
 UPDATE ProfilingQueue  SET DateCompletedOrCanceled = getdate(), NumberOfAccountsRemaining = 0 WHERE ID = @QueueId
END
ELSE IF @QueueStatus = 5 
BEGIN
 UPDATE ProfilingQueue  SET DateCompletedOrCanceled = getdate(), NumberOfAccountsRemaining = 0, CanceledBy = @User WHERE ID = @QueueId
END

SELECT ID, OfferID, [Owner], [Status], NumberOfAccountsTotal, NumberOfAccountsRemaining, DateStarted, DateCompletedOrCanceled, CanceledBy, DateCreated, ResultOutput
FROM ProfilingQueue (NOLOCK)
WHERE ID = @QueueId


IF @@ERROR = 0
	COMMIT
ELSE
	ROLLBACK
