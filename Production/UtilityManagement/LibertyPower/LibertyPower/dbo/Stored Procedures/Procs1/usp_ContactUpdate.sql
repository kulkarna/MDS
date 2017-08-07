
CREATE PROCEDURE [dbo].[usp_ContactUpdate]
	@ContactID int,
	@FirstName nvarchar(50),
	@LastName nvarchar(50),
	@Title nvarchar(50),
	@Phone varchar(20),
	@Fax varchar(20),
	@Email nvarchar(75),
	@Birthdate datetime,	
	@ModifiedBy int
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Update LibertyPower.dbo.Contact
    Set				
		FirstName = @FirstName,
		LastName = @LastName,
		Title = @Title,
		Phone = @Phone,
		Fax = @Fax,
		Email = @Email,
		Birthdate = @Birthdate,
		Modified = GETDATE(),
		ModifiedBy = @ModifiedBy
	From 
		LibertyPower.dbo.Contact	
	Where 
		ContactID = @ContactID 
				
	EXEC LibertyPower.dbo.usp_ContactSelect @ContactID;
END


