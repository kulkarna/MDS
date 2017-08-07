
CREATE PROCEDURE [dbo].[usp_ProfilingQueueDecrementRemainingProgressUpdate]
@QueueId	  int

AS
BEGIN TRANSACTION
DECLARE @RemainingAccounts INT
SET @RemainingAccounts = (SELECT NumberOfAccountsRemaining FROM ProfilingQueue (NOLOCK) WHERE ID = @QueueId )

UPDATE ProfilingQueue SET NumberOfAccountsRemaining = @RemainingAccounts - 1 WHERE ID = @QueueId

IF @@ERROR = 0
	COMMIT
ELSE
	ROLLBACK
	
	
