
CREATE PROCEDURE [dbo].[usp_CustomerNameSelect]
	@CustomerNameID int
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Select
		CustomerID,
		NameID,
		Modified,
		ModifiedBy,
		DateCreated,
		CreatedBy
	From 
		LibertyPower.dbo.CustomerName WITH (NOLOCK)
	Where
		CustomerNameID =@CustomerNameID
		
END


