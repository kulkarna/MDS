


CREATE PROCEDURE [dbo].[usp_AccountByLegacyAccountIdSelect]                                                                                     
	@LegacyAccountId char(12)
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE @AccountID INT
	
	SELECT @AccountID = AccountID
	FROM lp_account..account (NOLOCK)
	WHERE account_id = @LegacyAccountId
	
	EXEC usp_AccountByAccountIdSelect @AccountId = @AccountID
	

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power



