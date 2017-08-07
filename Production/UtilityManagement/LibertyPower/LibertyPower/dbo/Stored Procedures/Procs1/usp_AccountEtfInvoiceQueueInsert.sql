
CREATE PROCEDURE [dbo].[usp_AccountEtfInvoiceQueueInsert]
	@AccountID int
	,@EtfID int
	,@StatusID int
	,@IsPaid bit
	,@DateInvoiced datetime = null
	,@IstaInvoiceNumber varchar(50) = null
	,@DateInserted datetime
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [AccountEtfInvoiceQueue]
		([AccountID]
		,[EtfID]
		,[StatusID]
		,[IsPaid]
		,[DateInvoiced]
		,[IstaInvoiceNumber]
		,[DateInserted])
	VALUES
		(@AccountID
		,@EtfID
		,@StatusID
		,@IsPaid
		,@DateInvoiced
		,@IstaInvoiceNumber
		,@DateInserted)

	SELECT Scope_Identity()

	SET NOCOUNT OFF;

END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfInvoiceQueueInsert';

