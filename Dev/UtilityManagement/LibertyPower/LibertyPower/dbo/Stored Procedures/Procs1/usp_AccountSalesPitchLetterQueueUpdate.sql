
CREATE PROCEDURE [dbo].[usp_AccountSalesPitchLetterQueueUpdate]
	@SalesPitchLetterID int
	,@AccountID int
	,@EtfID int
	,@StatusID int
	,@DateScheduled datetime
	,@DateProcessed datetime
	,@DateInserted datetime
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [AccountSalesPitchLetterQueue]
		SET [AccountID] = @AccountID
		,[EtfID] = @EtfID
		,[StatusID] = @StatusID
		,[DateScheduled] = @DateScheduled
		,[DateProcessed] = @DateProcessed
		,[DateInserted] = @DateInserted
	WHERE [SalesPitchLetterID] = @SalesPitchLetterID

	SET NOCOUNT OFF;

END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountSalesPitchLetterQueueUpdate';

