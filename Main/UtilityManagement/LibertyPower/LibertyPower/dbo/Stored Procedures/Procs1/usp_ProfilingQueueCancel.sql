--status: 0=queued, 1 = running, 2 = complete success, 3 = complete errors, 4 = complete reviewed, 5 = canceled
CREATE PROCEDURE [dbo].[usp_ProfilingQueueCancel]
@QueueId	  int,
@user   varchar(50)

AS

UPDATE ProfilingQueue  SET [Status] = 5 WHERE ID = @QueueId

SELECT ID, OfferID, [Owner], [Status], NumberOfAccountsTotal, NumberOfAccountsRemaining, DateStarted, DateCompletedOrCanceled, CanceledBy, DateCreated
FROM ProfilingQueue 
WHERE ID = @QueueId
