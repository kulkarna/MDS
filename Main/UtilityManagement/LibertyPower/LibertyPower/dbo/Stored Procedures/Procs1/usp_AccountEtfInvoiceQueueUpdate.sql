
CREATE PROCEDURE [dbo].[usp_AccountEtfInvoiceQueueUpdate]
	@EtfInvoiceID int
	,@AccountID int
	,@EtfID int
	,@StatusID int
	,@IsPaid bit
	,@DateInvoiced datetime
	,@IstaInvoiceNumber varchar(50)
	,@DateInserted datetime
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [AccountEtfInvoiceQueue]
		SET [AccountID] = @AccountID
		,[EtfID] = @EtfID
		,[StatusID] = @StatusID
		,[IsPaid] = @IsPaid
		,[DateInvoiced] = @DateInvoiced
		,[IstaInvoiceNumber] = @IstaInvoiceNumber
		,[DateInserted] = @DateInserted
	WHERE [EtfInvoiceID] = @EtfInvoiceID

	SET NOCOUNT OFF;

END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfInvoiceQueueUpdate';

