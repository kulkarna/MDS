CREATE PROCEDURE [dbo].[usp_NameSelect]
	@NameID INT
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Select 
		[NameID],
		[Name],
		[Modified],
		[ModifiedBy],
		[DateCreated],
		[CreatedBy]
	From 
		LibertyPower.dbo.Name with (nolock)		
	Where 
		NameID = @NameID 
END

