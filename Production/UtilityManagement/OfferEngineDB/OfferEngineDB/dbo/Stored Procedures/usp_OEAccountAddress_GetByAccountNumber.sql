
CREATE PROC [dbo].[usp_OEAccountAddress_GetByAccountNumber]
	@AccountNumber VARCHAR(100)
	
AS 
BEGIN

	SET NOCOUNT ON;  

	SELECT DISTINCT
		ZIP
	FROM
		dbo.OE_Account_Address (NOLOCK) OAA
	WHERE
		OAA.ACCOUNT_NUMBER = @AccountNumber

	SET NOCOUNT OFF;

END
