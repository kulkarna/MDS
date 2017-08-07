

CREATE PROCEDURE [dbo].[usp_AccountCurrentEtfIDUpdate]
	@AccountID int,
	@CurrentEtfID int
AS
BEGIN

	SET NOCOUNT ON;
	
	UPDATE AccountEtfWaive
		SET CurrentEtfID = @CurrentEtfID
	WHERE AccountID = @AccountID

	SET NOCOUNT OFF;

END

