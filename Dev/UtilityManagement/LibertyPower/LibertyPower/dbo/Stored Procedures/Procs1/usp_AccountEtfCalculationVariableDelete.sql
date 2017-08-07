



CREATE PROCEDURE [dbo].[usp_AccountEtfCalculationVariableDelete]
	@EtfID int
	
AS
BEGIN

	SET NOCOUNT ON;

	DELETE FROM [AccountEtfCalculationVariable]		
	WHERE [EtfID] = @EtfID

	SET NOCOUNT OFF;

END





GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfCalculationVariableDelete';

