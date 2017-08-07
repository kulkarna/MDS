

CREATE PROCEDURE [dbo].[usp_RetentionSavedAccountsQueueInsert]
	@AccountID int
	,@EtfID int
	,@EtfInvoiceID int
	,@StatusID int
	,@DateProcessed datetime
	,@ProcessedBy varchar(100) 
	,@DateInserted datetime
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [RetentionSavedAccountsQueue]
		([AccountID]
		,[EtfID]
		,[EtfInvoiceID]
		,[StatusID]
		,[DateProcessed]
		,[ProcessedBy]
		,[DateInserted])
	VALUES
		(@AccountID
		,@EtfID
		,@EtfInvoiceID
		,@StatusID
		,@DateProcessed
		,@ProcessedBy
		,@DateInserted)

	SELECT Scope_Identity()

	SET NOCOUNT OFF;

END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RetentionSavedAccountsQueueInsert';

