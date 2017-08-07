CREATE PROCEDURE [dbo].[usp_CustomerAddressSelect]
	@CustomerAddressID int
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Select
		CustomerAddressID,
		CustomerID,
		AddressID,
		Modified,
		ModifiedBy,
		DateCreated,
		CreatedBy
	From 
		LibertyPower.dbo.CustomerAddress 
	Where
		CustomerAddressID =@CustomerAddressID
		
END

