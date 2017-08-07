

CREATE PROCEDURE [dbo].[usp_AccountSalesPitchLetterQueueSelectBySalesPitchLetterID]
	@SalesPitchLetterID int
AS
BEGIN

	SET NOCOUNT ON;

	SELECT 
		SalesPitchLetterID
		, AccountID
		, EtfID
		, StatusID
		, DateScheduled
		, DateProcessed
		, DateInserted
	FROM AccountSalesPitchLetterQueue WITH (NOLOCK)
	WHERE SalesPitchLetterID = @SalesPitchLetterID

	SET NOCOUNT OFF;

END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountSalesPitchLetterQueueSelectBySalesPitchLetterID';

