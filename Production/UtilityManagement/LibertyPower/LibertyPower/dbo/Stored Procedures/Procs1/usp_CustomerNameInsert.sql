
-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- ADD @IsSilent parameter
-- =======================================

CREATE PROCEDURE [dbo].[usp_CustomerNameInsert]
	@CustomerID int,
	@NameID int,
	@ModifiedBy int,
	@CreatedBy int,
	@IsSilent BIT = 0
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Insert Into LibertyPower.dbo.CustomerName 
	(
		CustomerID,
		NameID,
		Modified,
		ModifiedBy,
		DateCreated,
		CreatedBy
			
	) 
	Values
	(
		@CustomerID,
		@NameID,
		GETDATE(),
		@ModifiedBy,
		GETDATE(),
		@CreatedBy
	)
	
	DECLARE @CustomerNameID int
	SET @CustomerNameID = SCOPE_IDENTITY()
	IF @IsSilent = 0	
		Exec LibertyPower.dbo.usp_CustomerNameSelect @CustomerNameID
	
	return @CustomerNameID
END


