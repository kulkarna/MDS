/******************************  usp_AccountInfoFileLogGetID *********************************/
Create Procedure dbo.usp_AccountInfoFileLogGetID 
	@ZipFileName as varchar(200)
	
AS

BEGIN

	Select	ID
	From	AccountInfoFileLog
	Where	ZipFileName = @ZipFileName

END

