
-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- ADD @IsSilent parameter
-- =======================================

CREATE PROCEDURE [dbo].[usp_CustomerAddressInsert]
	@CustomerID int,
	@AddressID int,
	@ModifiedBy int,
	@CreatedBy int,
	@IsSilent BIT = 0
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Insert Into LibertyPower.dbo.CustomerAddress 
	(
		CustomerID,
		AddressID,
		Modified,
		ModifiedBy,
		DateCreated,
		CreatedBy
			
	) 
	Values
	(
		@CustomerID,
		@AddressID,
		GETDATE(),
		@ModifiedBy,
		GETDATE(),
		@CreatedBy
	)
	
	Declare @CustomerAddressID int
	Set @CustomerAddressID = SCOPE_IDENTITY()
	IF @IsSilent = 0	
		Exec LibertyPower.dbo.usp_CustomerAddressSelect @CustomerAddressID
	
	return @CustomerAddressID
END

