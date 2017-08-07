

CREATE PROCEDURE [dbo].[usp_RateChangeUtilityIDByAccountListSelect]
	@AccountNumberList VARCHAR(4000)
AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @pos INT;
	DECLARE @currentAccount VARCHAR(100);
	
	SET @pos = 0;
	
	DECLARE @tempAccountsTable TABLE 
	(
		accountNumber VARCHAR(100)
	)

	WHILE CHARINDEX(',',@AccountNumberList) > 0
	BEGIN
		SET @pos=CHARINDEX(',',@AccountNumberList);
		SET @currentAccount = RTRIM(SUBSTRING(@AccountNumberList,1,@pos-1));
		INSERT INTO @tempAccountsTable (accountNumber) VALUES (@currentAccount);
		SET @AccountNumberList=SUBSTRING(@AccountNumberList,@pos+1,4000);
	END
		
	Select
		Account.AccountNumber as Account_Number,
		Utility.UtilityCode as Utility_Id,
		Utility.UtilityCode,
		Utility.DunsNumber
	From
		Account
		Inner Join Utility
		On Account.UtilityID = Utility.ID
	Where
		Account.AccountNumber in (SELECT * FROM @tempAccountsTable)
	Order By 
		Account.AccountNumber
END

