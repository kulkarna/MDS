
CREATE PROCEDURE [dbo].[usp_NameUpdate]
	@NameID int,
	@Name nvarchar(150),	
	@ModifiedBy int
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Update LibertyPower.dbo.Name
    Set		
		Name = @Name,
		Modified = GETDATE(),
		ModifiedBy = @ModifiedBy
	From 
		LibertyPower.dbo.Name with (nolock)		
	Where 
		NameID = @NameID 
		
	SET @NameID = SCOPE_IDENTITY();
	
	EXEC LibertyPower.dbo.usp_NameSelect @NameID;
END


