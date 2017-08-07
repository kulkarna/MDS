
CREATE PROCEDURE [dbo].[usp_AccountEtfCalculationFixedInsert]
	@EtfID int
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

	INSERT INTO [AccountEtfCalculationFixed]
		([EtfID]
		,[LostTermDays]
		,[LostTermMonths]
		,[AccountRate]
		,[MarketRate]
		,[AnnualUsage]
		,[Term]
		,[FlowStartDate]
		,[DropMonthIndicator])
	VALUES
		(@EtfID
		,@LostTermDays
		,@LostTermMonths
		,@AccountRate
		,@MarketRate
		,@AnnualUsage
		,@Term
		,@FlowStartDate
		,@DropMonthIndicator)

	SELECT Scope_Identity()

	SET NOCOUNT OFF;

END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfCalculationFixedInsert';

