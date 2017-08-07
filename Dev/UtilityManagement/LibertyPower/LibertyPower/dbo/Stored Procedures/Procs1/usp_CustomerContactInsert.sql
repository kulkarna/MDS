-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- ADD @IsSilent parameter
-- =======================================

CREATE PROCEDURE [dbo].[usp_CustomerContactInsert]
	@CustomerID int,
	@ContactID int,
	@ModifiedBy int,
	@CreatedBy int,
	@IsSilent BIT = 0
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Insert Into LibertyPower.dbo.CustomerContact 
	(
		CustomerID,
		ContactID,
		Modified,
		ModifiedBy,
		DateCreated,
		CreatedBy
			
	) 
	Values
	(
		@CustomerID,
		@ContactID,
		GETDATE(),
		@ModifiedBy,
		GETDATE(),
		@CreatedBy
	)
	
	Declare @CustomerContactID int
	Set @CustomerContactID = SCOPE_IDENTITY()
	IF @IsSilent = 0			
		Exec LibertyPower.dbo.usp_CustomerContactSelect @CustomerContactID
	
	return @CustomerContactID
END


