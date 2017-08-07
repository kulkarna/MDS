

CREATE PROCEDURE [dbo].[usp_AccountEtfMarketRateImportInsert]
	@EffectiveDate datetime
	,@RetailMarket char(2)
	,@Utility varchar(20)
	,@Zone varchar(25)
	,@ServiceClass varchar(50)
	,@Term int
	,@DropMonthIndicator int
	,@AccountType char(3)
	,@Rate float
AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [AccountEtfMarketRateImport]
		([EffectiveDate]
		,[RetailMarket]
		,[Utility]
		,[Zone]
		,[ServiceClass]
		,[Term]
		,[DropMonthIndicator]
		,[AccountType]
		,[Rate])
	VALUES
		(@EffectiveDate
		,@RetailMarket
		,@Utility
		,@Zone
		,@ServiceClass
		,@Term
		,@DropMonthIndicator
		,@AccountType
		,@Rate)

	SET NOCOUNT OFF;

END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfMarketRateImportInsert';

