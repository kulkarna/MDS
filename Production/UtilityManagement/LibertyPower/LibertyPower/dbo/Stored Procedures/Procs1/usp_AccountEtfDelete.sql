



CREATE PROCEDURE [dbo].[usp_AccountEtfDelete]
	
	@EtfID int
AS
BEGIN

	SET NOCOUNT ON;
	
	--Remove any current EtfCalculation
	exec usp_AccountEtfCalculationVariableDelete @EtfID
	exec usp_AccountEtfCalculationVariableDelete @EtfID

	--Remove current Etf

	DELETE FROM [AccountEtf]		
	WHERE [EtfID] = @EtfID

	
	--Update current Etf on Account table
	UPDATE [LibertyPower]..[AccountEtfWaive]
		SET [CurrentEtfID] = null
	WHERE [CurrentEtfID] = @EtfID

	
	SET NOCOUNT OFF;

END






GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfDelete';

