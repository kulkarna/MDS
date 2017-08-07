CREATE PROCEDURE [dbo].[usp_AddressUpdate]
	@AddressID int,
	@Address1 nvarchar(150),
	@Address2 nvarchar(150),
	@City nvarchar(100),
	@State char(2) = NULL,
	@StateFips char(2) = NULL,
	@Zip char(10) = NULL,
	@County nvarchar(100),
	@CountyFips char(3) = null,
	@ModifiedBy int
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Update LibertyPower.dbo.[Address]
    Set		
		[Address1] = @Address1,
		[Address2] = @Address2,
		[City] = @City,
		[State] = @State,
		[StateFips] = ISNULL(@StateFips, StateFips),
		[Zip] = ISNULL(@Zip, Zip),
		[County] = ISNULL(@County, County),
		[CountyFips] = ISNULL(@CountyFips,CountyFips),
		[Modified] = GETDATE(),
		[ModifiedBy] = @ModifiedBy
	Where 
		AddressID = @AddressID 
						
	EXEC LibertyPower.dbo.usp_AddressSelect @AddressID;
		
END

