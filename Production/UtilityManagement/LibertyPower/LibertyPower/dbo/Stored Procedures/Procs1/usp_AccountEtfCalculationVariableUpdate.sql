

CREATE PROCEDURE [dbo].[usp_AccountEtfCalculationVariableUpdate]
	@EtfCalculationVariableID int
	,@EtfID int
	,@AccountCount int
	,@AverageAnnualConsumption bigint

AS
BEGIN

	SET NOCOUNT ON;

	UPDATE [AccountEtfCalculationVariable]
		SET [EtfID] = @EtfID
		,[AccountCount] = @AccountCount
		,[AverageAnnualConsumption] = @AverageAnnualConsumption

	WHERE [EtfCalculationVariableID] = @EtfCalculationVariableID

	SET NOCOUNT OFF;

END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfCalculationVariableUpdate';

