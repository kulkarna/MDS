CREATE PROCEDURE [dbo].[usp_ContactSelect]
	@ContactID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Select 
		[ContactID],
		[FirstName],
		[LastName],
		[Title],
		[Phone],
		[Fax],
		[Email],
		[Birthdate],
		[Modified],
		[ModifiedBy],
		[DateCreated],
		[CreatedBy]
	From 
		LibertyPower.dbo.Contact with (nolock)		
	Where 
		ContactID = @ContactID
END

