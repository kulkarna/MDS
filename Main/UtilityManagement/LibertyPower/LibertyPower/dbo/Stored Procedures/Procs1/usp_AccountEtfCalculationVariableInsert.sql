

CREATE PROCEDURE [dbo].[usp_AccountEtfCalculationVariableInsert]
	@EtfID int
	,@AccountCount int
	,@AverageAnnualConsumption bigint

AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [AccountEtfCalculationVariable]
		([EtfID]
		,[AccountCount]
		,[AverageAnnualConsumption])
	VALUES
		(@EtfID
		,@AccountCount
		,@AverageAnnualConsumption)

	SELECT Scope_Identity()

	SET NOCOUNT OFF;

END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfCalculationVariableInsert';

