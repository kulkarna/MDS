
CREATE PROCEDURE [dbo].[usp_AccountEtfCalculationFixedUpdate]
	@EtfCalculationFixedID int
	,@EtfID int
	,@LostTermDays int
	,@LostTermMonths int
	,@AccountRate float
	,@MarketRate float
	,@AnnualUsage int
	,@Term int
	,@FlowStartDate datetime
	,@DropMonthIndicator int
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [AccountEtfCalculationFixed]
		SET [EtfID] = @EtfID
		,[LostTermDays] = @LostTermDays
		,[LostTermMonths] = @LostTermMonths
		,[AccountRate] = @AccountRate
		,[MarketRate] = @MarketRate
		,[AnnualUsage] = @AnnualUsage
		,[Term] = @Term
		,[FlowStartDate] = @FlowStartDate
		,[DropMonthIndicator] = @DropMonthIndicator
	WHERE [EtfCalculationFixedID] = @EtfCalculationFixedID

	SET NOCOUNT OFF;

END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfCalculationFixedUpdate';

