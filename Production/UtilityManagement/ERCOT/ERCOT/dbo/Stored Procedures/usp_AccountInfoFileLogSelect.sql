
/******************************  usp_AccountInfoFileSelect *********************************/
Create Procedure dbo.usp_AccountInfoFileLogSelect 
	@ZipFileName as varchar(200)
	
AS

BEGIN

	Select	* 
	From	AccountInfoFileLog
	Where	ZipFileName = @ZipFileName

END

