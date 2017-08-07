

/*
*
* PROCEDURE:	[usp_AccountDetailUpdate]
*
* DEFINITION:  Updates a record in the Account Detail record
*
* RETURN CODE: 
*
* REVISIONS:	8/31/2011 Jaime Forero
*
*/

CREATE PROCEDURE [dbo].[usp_AccountDetailUpdate]
	@AccountDetailID INT = NULL,
	@AccountID INT = NULL,
	@EnrollmentTypeID INT = NULL,
	@OriginalTaxDesignation INT = NULL,
	@ModifiedBy INT,
	@IsSilent BIT = 0
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	IF @AccountDetailID IS NULL AND @AccountID IS NULL
	BEGIN
		RAISERROR('@AccountDetailID and @AccountID cannot both be null. Cannot continue',11,1)
		RETURN -1;
	END
	
	IF @AccountDetailID IS NULL
	BEGIN
		SELECT @AccountDetailID = AD.AccountDetailID FROM Libertypower.dbo.AccountDetail AD WHERE AD.AccountID = @AccountID;
	END

	UPDATE Libertypower.dbo.AccountDetail
	SET [EnrollmentTypeID] = @EnrollmentTypeID,
		[OriginalTaxDesignation] = @OriginalTaxDesignation,
		[Modified] = GETDATE(),
		[ModifiedBy] = @ModifiedBy
	WHERE	[AccountDetailID] = @AccountDetailID 
	;
	
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountDetailSelect @AccountDetailID, @AccountID  ;
	
	RETURN @AccountDetailID;
	
END
