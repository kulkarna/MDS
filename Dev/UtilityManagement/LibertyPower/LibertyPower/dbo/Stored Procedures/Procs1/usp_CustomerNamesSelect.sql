
Create PROCEDURE [dbo].[usp_CustomerNamesSelect]
	@CustomerID int
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Select 
		CustomerNameId,
		CustomerID,
		NameID
	From 
		LibertyPower.dbo.CustomerName with (nolock)		
	Where
		CustomerID = @CustomerID
END


