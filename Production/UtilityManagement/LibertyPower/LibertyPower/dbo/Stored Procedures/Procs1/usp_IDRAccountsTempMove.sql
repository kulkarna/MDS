/********************************* [dbo].[usp_IDRAccountsTempMove] ********************/
CREATE PROCEDURE [dbo].[usp_IDRAccountsTempMove]
	  @UtilityID varchar(15)
AS
BEGIN
	
	--make sure all records for the utility has been deleted
	exec usp_IDRAccountsTempDelete @UtilityID
	
	INSERT INTO IDRAccountsTemp
	SELECT	*
	FROM	IDRAccounts
	
END
