

CREATE PROCEDURE [dbo].[usp_AccountSalesPitchLetterQueueUpdateProcessed]
	@SalesPitchLetterID int
	,@StatusID int
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [AccountSalesPitchLetterQueue]
		SET [StatusID] = @StatusID
		,[DateProcessed] = GetDate()
	WHERE [SalesPitchLetterID] = @SalesPitchLetterID

	SET NOCOUNT OFF;

END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountSalesPitchLetterQueueUpdateProcessed';

