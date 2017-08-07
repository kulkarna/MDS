


/*******************************************************************************
 * usp_AccountByAccountNumberUtilitySelect
 * Get account data
 *
 * History
 *******************************************************************************
 * 4/29/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 5/22/2010 - Eric Hernandez
 * Due to utilities sharing duns numbers, this proc has been called several times with the wrong utility code.
 * To reduce the impact of this problem significantly, the utility code will only be used to resolve duplicate account number issues.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_AccountByAccountNumberUtilitySelect]                                                                                     
	@AccountNumber	varchar(50),
	@UtilityCode	varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @AccountID INT
	DECLARE @DuplicateCount INT
	
	SELECT @DuplicateCount = count(*)
	FROM LibertyPower..Account a (NOLOCK)
	WHERE a.accountnumber = @AccountNumber
	
	SELECT @AccountID = AccountID
	FROM LibertyPower..Account a (NOLOCK)
	JOIN LibertyPower..Utility u (NOLOCK) ON a.UtilityID = u.ID
	WHERE a.accountnumber = @AccountNumber
	AND (@DuplicateCount = 1 OR u.UtilityCode = @UtilityCode) -- only use Utility code if there are duplicate account numbers in the system.
	
	EXEC usp_AccountByAccountIdSelect @AccountId = @AccountID

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power



