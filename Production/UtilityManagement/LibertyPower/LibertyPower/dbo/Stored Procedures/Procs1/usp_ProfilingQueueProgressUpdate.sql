
CREATE PROCEDURE [dbo].[usp_ProfilingQueueProgressUpdate]
@QueueId	  int,
@NumberOfAccountsTotal int,
@NumberOfAccountsRemaining int

AS

UPDATE ProfilingQueue  SET NumberOfAccountsTotal = @NumberOfAccountsTotal, NumberOfAccountsRemaining = @NumberOfAccountsRemaining WHERE ID = @QueueId

SELECT ID, OfferID, [Owner], [Status], DateStarted, DateCompletedOrCanceled, CanceledBy, DateCreated, ResultOutput, NumberOfAccountsTotal, NumberOfAccountsRemaining
FROM ProfilingQueue (NOLOCK)
WHERE ID = @QueueId
