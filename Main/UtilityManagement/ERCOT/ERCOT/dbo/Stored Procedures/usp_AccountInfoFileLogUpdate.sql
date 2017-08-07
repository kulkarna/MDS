
/******************************  usp_AccountInfoFileLogGetID *********************************/
Create Procedure dbo.usp_AccountInfoFileLogUpdate 
	@ID int,
	@Status int, 
	@Information as varchar (500)
	
AS

BEGIN

	Update	AccountInfoFileLog
	Set		[Status] = @Status,
			Information = @Information
	Where	ID = @ID

END

