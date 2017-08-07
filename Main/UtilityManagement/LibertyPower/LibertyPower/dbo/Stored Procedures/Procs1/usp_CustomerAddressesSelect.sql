
CREATE PROCEDURE [dbo].[usp_CustomerAddressesSelect]
	@CustomerID int
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Select 
		CustomerAddressId,
		CustomerID,
		AddressID
	From 
		LibertyPower.dbo.CustomerAddress with (nolock)		
	Where
		CustomerID = @CustomerID
END


