CREATE PROCEDURE [dbo].[usp_AddressSelect]
	@AddressID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Select 
		[AddressID],
		[Address1],
		[Address2],
		[City],
		[State],
		[StateFips],
		[Zip],
		[County],
		[CountyFips],
		[Modified],
		[ModifiedBy],
		[DateCreated],
		[CreatedBy]
	From 
		LibertyPower.dbo.[Address] with (nolock)		
	Where 
		AddressID = @AddressID 
END

