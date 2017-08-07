
/*
* PROCEDURE:   usp_AccountUsageUpdate
* DEFINITION:  Updates a record into AccountUsage
* NOTE:		This assumes there is only one record for every account, in the future this wont be true
*/
CREATE PROCEDURE [dbo].[usp_AccountUsageUpdate]
	@AccountUsageID INT = NULL,
	@AccountID INT		= NULL,
	@AnnualUsage INT = NULL,
	@UsageReqStatusID INT,
	@EffectiveDate DATETIME,
	@ModifiedBy INT,
	@IsSilent BIT = 0
AS
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET FMTONLY OFF
	SET NO_BROWSETABLE OFF
	
	IF @AccountUsageID IS NULL AND @AccountID IS NULL
	BEGIN
		RAISERROR('@AccountUsageID and @AccountID cannot both be null. Cannot continue',11,1)
		RETURN -1;
	END

	IF @AccountUsageID  IS NULL
	BEGIN
		SELECT @AccountUsageID = AU.AccountUsageID FROM Libertypower.dbo.AccountUsage AU WHERE AU.AccountID = @AccountID;
	END

	UPDATE Libertypower.[dbo].[AccountUsage]
	SET [AnnualUsage] = @AnnualUsage,
		[UsageReqStatusID] = @UsageReqStatusID,
		[EffectiveDate] = @EffectiveDate,
		ModifiedBy = @ModifiedBy
	WHERE AccountUsageID = @AccountUsageID

	IF @IsSilent = 0
		EXEC Libertypower.dbo.usp_AccountUsageSelect @AccountUsageID;
	RETURN @AccountUsageID;

END
