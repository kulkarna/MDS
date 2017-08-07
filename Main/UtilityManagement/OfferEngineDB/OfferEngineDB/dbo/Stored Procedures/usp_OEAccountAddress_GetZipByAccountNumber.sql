CREATE PROC usp_OEAccountAddress_GetZipByAccountNumber
	@AccountNumber NVARCHAR(100)
	
AS 
BEGIN


	SELECT DISTINCT
		ZIP
	FROM
		dbo.OE_Account_Address (NOLOCK) OAA
	WHERE
		OAA.ACCOUNT_NUMBER = @AccountNumber
		
END