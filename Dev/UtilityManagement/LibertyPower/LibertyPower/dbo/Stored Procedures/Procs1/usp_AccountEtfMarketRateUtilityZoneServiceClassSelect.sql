
CREATE PROCEDURE [dbo].[usp_AccountEtfMarketRateUtilityZoneServiceClassSelect] 
	@EffectiveDate datetime,
	@EffectiveDateStart datetime,
	@RetailMarket char(2),
	@Utility varchar(20),
	@Zone varchar(50),
	@ServiceClass varchar(50),
	@Term int,
	@DropMonthIndicator int,
	@AccountType char(3)
AS
BEGIN
	EXEC usp_AccountEtfMarketRateUtilityPricingZoneServiceClassSelect
	@EffectiveDate = @EffectiveDate
	,@EffectiveDateStart = @EffectiveDateStart
	,@RetailMarket = @RetailMarket
	,@Utility = @Utility
	,@ServiceClass = @ServiceClass
	,@Zone = @Zone
	,@Term = @Term
	,@DropMonthIndicator = @DropMonthIndicator
	,@AccountType = @AccountType
END





GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfMarketRateUtilityZoneServiceClassSelect';

