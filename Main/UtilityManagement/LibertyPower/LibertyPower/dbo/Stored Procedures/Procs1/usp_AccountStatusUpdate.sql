
/*
* PROCEDURE:	[usp_AccountStatusUpdate]
* DEFINITION:  Updates a record into AccountStatus
* REVISIONS:	9/2/2011 11:58:55 AM	Jaime Forero
*/

CREATE PROCEDURE [dbo].[usp_AccountStatusUpdate]
	@AccountStatusID INT = NULL,
	@AccountContractID INT = NULL,
	@Status VARCHAR(15),
	@SubStatus VARCHAR(15),
	@ModifiedBy	INT,
	@IsSilent BIT = 0
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	IF @AccountStatusID IS NULL AND @AccountContractID IS NULL
		RAISERROR ('Need at least one of the two: @AccountStatusID or @AccountContractID' , 11, 1);
	
	IF @AccountStatusID IS NULL
	BEGIN 
		SELECT @AccountStatusID = ASS.AccountStatusID FROM Libertypower.dbo.AccountStatus ASS WHERE ASS.AccountContractID = @AccountContractID 
	END
	
	UPDATE LibertyPower.[dbo].[AccountStatus]
	SET [Status] = @Status,
		[SubStatus] = @SubStatus,
		[Modified] = GETDATE(),
		[ModifiedBy] = @ModifiedBy
	WHERE AccountStatusID = @AccountStatusID 
	;
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountStatusSelect @AccountStatusID ;
	
	RETURN @AccountStatusID;
	
END
