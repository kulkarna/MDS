


CREATE PROCEDURE [dbo].[usp_AccountEtfWaivedUpdate]
	@AccountID int,
	@WaiveEtf bit,
	@WaivedEtfReasonCodeID int = null
AS
BEGIN
	SET NOCOUNT ON;
	

	UPDATE LibertyPower..AccountEtfWaive
	SET 
	WaiveEtf = @WaiveEtf,
	WaivedEtfReasonCodeID = @WaivedEtfReasonCodeID
	WHERE AccountID = @AccountId




	SET NOCOUNT OFF;
	
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_AccountEtfWaivedUpdate';

