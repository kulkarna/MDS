

CREATE PROCEDURE [dbo].[usp_RetentionSavedAccountsQueueUpdate]
	@SavedAccountsQueueID int
	,@AccountID int
	,@EtfID int
	,@EtfInvoiceID int
	,@StatusID int
	,@DateProcessed datetime
	,@ProcessedBy varchar(100)
	,@IstaWaivedInvoiceNumber varchar(50)
	,@DateInserted datetime
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [RetentionSavedAccountsQueue]
		SET [AccountID] = @AccountID
		,[EtfID] = @EtfID
		,[EtfInvoiceID] = @EtfInvoiceID
		,[StatusID] = @StatusID
		,[DateProcessed] = @DateProcessed
		,[ProcessedBy] = @ProcessedBy
		,[IstaWaivedInvoiceNumber] = @IstaWaivedInvoiceNumber
		,[DateInserted] = @DateInserted
	WHERE [SavedAccountsQueueID] = @SavedAccountsQueueID

	SET NOCOUNT OFF;

END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RetentionSavedAccountsQueueUpdate';

