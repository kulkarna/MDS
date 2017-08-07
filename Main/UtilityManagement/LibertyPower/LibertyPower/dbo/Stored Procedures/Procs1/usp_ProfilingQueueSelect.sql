
CREATE PROCEDURE [dbo].[usp_ProfilingQueueSelect]  
AS

SELECT ID, OfferID, [Owner], [Status], NumberOfAccountsTotal, NumberOfAccountsRemaining, DateStarted, DateCompletedOrCanceled, CanceledBy, DateCreated, ResultOutput
FROM ProfilingQueue 
WHERE [Status] <> 4 AND (DateCompletedOrCanceled IS NULL  OR  DateCompletedOrCanceled > GETDATE() - 30)
ORDER BY ID



