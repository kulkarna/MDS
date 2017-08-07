
CREATE PROCEDURE [dbo].[usp_AccountSalesPitchLetterQueueInsert]
	@AccountID int
	,@EtfID int
	,@StatusID int
	,@DateScheduled datetime
	,@DateProcessed datetime = null
	,@DateInserted datetime
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [AccountSalesPitchLetterQueue]
		([AccountID]
		,[EtfID]
		,[StatusID]
		,[DateScheduled]
		,[DateProcessed]
		,[DateInserted])
	VALUES
		(@AccountID
		,@EtfID
		,@StatusID
		,@DateScheduled
		,@DateProcessed
		,@DateInserted)

	SELECT Scope_Identity()

	SET NOCOUNT OFF;

END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountSalesPitchLetterQueueInsert';

