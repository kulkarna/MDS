

/*
*
* PROCEDURE:	[usp_AccountContractCommissionUpdate]
*
* DEFINITION:  Updates a record into AccountContractCommission Table
*
* RETURN CODE: 
*
* REVISIONS:	9/2/2011 Jaime Forero
*/

CREATE PROCEDURE [dbo].[usp_AccountContractCommissionUpdate]
	@AccountContractCommissionID INT = NULL,
	@AccountContractID INT = NULL,
	@EvergreenOptionID INT,
	@EvergreenCommissionEnd DATETIME,
	@EvergreenCommissionRate FLOAT,
	@ResidualOptionID INT,
	@ResidualCommissionEnd DATETIME,
	@InitialPymtOptionID INT,
	@ModifiedBy	INT,
	@IsSilent BIT = 0
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	-- Either one or the other can be null but not both
	IF @AccountContractCommissionID IS NULL AND @AccountContractID IS NULL
		RAISERROR ('Need at least one of the 2: @AccountContractCommissionID or @AccountContractID' , 11, 1);
	
	IF @AccountContractCommissionID IS NULL
	BEGIN -- Asssumes there is only 1 records per account/contract combination
		SELECT @AccountContractCommissionID = ACC.AccountContractCommissionID 
		FROM [LibertyPower].[dbo].[AccountContractCommission] ACC (NOLOCK) 
		WHERE ACC.AccountContractID = @AccountContractID;
	END

	UPDATE [LibertyPower].[dbo].[AccountContractCommission]
	SET [EvergreenOptionID] = @EvergreenOptionID,
		[EvergreenCommissionEnd] = @EvergreenCommissionEnd,
		[EvergreenCommissionRate] = @EvergreenCommissionRate,
		[ResidualOptionID] = @ResidualOptionID,
		[ResidualCommissionEnd] = @ResidualCommissionEnd,
		[InitialPymtOptionID] = @InitialPymtOptionID,
		[ModifiedBy] = @ModifiedBy,
		[Modified] = GETDATE()
	WHERE AccountContractCommissionID = @AccountContractCommissionID
	;
	
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountContractCommissionSelect @AccountContractCommissionID  ;
		
	RETURN @AccountContractCommissionID ;
END
