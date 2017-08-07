
CREATE	PROCEDURE	[dbo].[usp_UtilityAccountTypeList]
		
AS

BEGIN
	SELECT	ID,Description
	FROM LibertyPower.dbo.AccountType
END
