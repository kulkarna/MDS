




CREATE PROCEDURE [dbo].[usp_RetentionSavedAccountsQueueSelectBySavedAccountsQueueID]
	@SavedAccountsQueueID int
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [SavedAccountsQueueID]
      ,[AccountID]
      ,[EtfID]
      ,[EtfInvoiceID]
      ,[StatusID]
      ,[DateProcessed]
	  ,[ProcessedBy]	
	  ,IstaWaivedInvoiceNumber
      ,[DateInserted]
	FROM [RetentionSavedAccountsQueue] WITH (NOLOCK)
	WHERE SavedAccountsQueueID = @SavedAccountsQueueID

	SET NOCOUNT OFF;

END





GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_RetentionSavedAccountsQueueSelectBySavedAccountsQueueID';

