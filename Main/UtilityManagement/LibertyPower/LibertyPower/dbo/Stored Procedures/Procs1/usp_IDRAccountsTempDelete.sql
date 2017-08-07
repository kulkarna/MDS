/********************************* [dbo].[usp_IDRAccountsTempDelete] ********************/
CREATE PROCEDURE [dbo].[usp_IDRAccountsTempDelete]
	  @UtilityID varchar(15)
AS
BEGIN
	
	--make sure all records for the utility has been deleted
	DELETE
	FROM	IDRAccountsTemp
	WHERE	UtilityID = @UtilityID
	
END
