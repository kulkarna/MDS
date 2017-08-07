
CREATE PROCEDURE [dbo].[usp_AccountEtfMarketRateSelect] 
	@EffectiveDate datetime,
	@RetailMarket char(2),
	@Utility varchar(20),
	@Zone varchar(5),
	@ServiceClass varchar(5),
	@Term int,
	@DropMonthIndicator int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT [Rate]
	FROM [AccountEtfMarketRate] WITH (NOLOCK)
	WHERE 
		[EffectiveDate] = @EffectiveDate
		AND [RetailMarket] = @RetailMarket
		AND [Utility] = @Utility
		AND Zone = @Zone
		AND ServiceClass = @ServiceClass
		AND Term = @Term
		AND DropMonthIndicator = @DropMonthIndicator

	SET NOCOUNT OFF;

END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfMarketRateSelect';

