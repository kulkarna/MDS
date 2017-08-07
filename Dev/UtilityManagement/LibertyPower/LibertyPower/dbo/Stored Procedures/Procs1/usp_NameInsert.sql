
-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- ADD @IsSilent parameter
-- =======================================


CREATE PROCEDURE [dbo].[usp_NameInsert]	
	@Name nvarchar(150) = null,
	@ModifiedBy int = null,
	@CreatedBy int = null,
	@IsSilent BIT = 0
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Insert Into LibertyPower.dbo.Name
    (		
		Name,		
		Modified,
		ModifiedBy,
		DateCreated,
		CreatedBy
	)
	Values
	(
		@Name,
		GETDATE(),
		@ModifiedBy,
		GETDATE(),
		@CreatedBy
	)
	
	Declare @NameID int
	SET @NameID = SCOPE_IDENTITY();
	IF @IsSilent = 0	
		EXEC LibertyPower.dbo.usp_NameSelect @NameID;
	
	RETURN @NameID;
END



