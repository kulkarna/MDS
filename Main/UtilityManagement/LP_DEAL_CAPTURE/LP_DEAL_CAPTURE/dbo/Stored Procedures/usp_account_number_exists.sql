-- =============================================
-- Author:		Jaime Forero
-- Create date: 2/17/2012
-- Description:	returns 1 if account number exists in the system, 0 otherwise.
-- DOES NOT VALIDATE INPUTS !
-- =============================================
/*
Unit Tests:

SELECT TOP(100) * FROM LibertyPower..account

-- existing account
EXEC usp_account_number_exists '651291000', 'CL&P'

-- non existing account
EXEC usp_account_number_exists '651291045', 'CL&P'

*/
CREATE PROCEDURE usp_account_number_exists
	@AccountNumber VARCHAR(30),
	@UtilityCode VARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @UtilityId INT;
	
	SELECT @UtilityId = ID FROM LibertyPower..Utility U (NOLOCK) WHERE U.UtilityCode = @UtilityCode	AND Inactiveind = '0'
	
    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP(1) AccountID FROM LibertyPower.dbo.Account (NOLOCK) WHERE AccountNumber = @AccountNumber AND UtilityID = @UtilityId)
		SELECT 1 AS HasAccount;
	ELSE
		SELECT 0 AS HasAccount;
	
END
