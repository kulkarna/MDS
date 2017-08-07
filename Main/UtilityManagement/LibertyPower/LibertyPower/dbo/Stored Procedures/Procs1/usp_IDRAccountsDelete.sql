/********************************* [dbo].[usp_IDRAccountsDelete] ********************/
CREATE PROCEDURE [dbo].[usp_IDRAccountsDelete]
	  @UtilityID varchar(15)	
AS
BEGIN

	-- First delete the account from the table
	DELETE FROM dbo.IDRAccounts
	WHERE	UtilityID = @UtilityID
	
END
