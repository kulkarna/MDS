
CREATE PROCEDURE usp_AccountEtfInvoiceQueueSelectByEtfInvoiceID
	@EtfInvoiceID int
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [EtfInvoiceID]
      ,[AccountID]
      ,[EtfID]
      ,[StatusID]
      ,[IsPaid]
      ,[DateInvoiced]
      ,[IstaInvoiceNumber]
      ,[DateInserted]
	FROM AccountEtfInvoiceQueue WITH (NOLOCK)
	WHERE EtfInvoiceID = @EtfInvoiceID

	SET NOCOUNT OFF;

END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfInvoiceQueueSelectByEtfInvoiceID';

