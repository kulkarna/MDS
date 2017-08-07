
-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- ADD @IsSilent parameter
-- =======================================

CREATE PROCEDURE [dbo].[usp_ContactInsert]		
	@FirstName nvarchar(50) = null,
	@LastName nvarchar(50) = null,
	@Title nvarchar(50) = null,
	@Phone varchar(20) = null,
	@Fax varchar(20) = '',
	@Email nvarchar(75) = null,
	@Birthdate datetime = null,	
	@ModifiedBy int = null,
	@CreatedBy int = null,
	@IsSilent BIT = 0
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Insert Into LibertyPower.dbo.Contact
    (				
		[FirstName],
		[LastName],
		[Title],
		[Phone],
		[Fax],
		[Email],
		[Birthdate],
		[Modified],
		[ModifiedBy],
		[DateCreated],
		[CreatedBy]
	)
	Values
	(		
		@FirstName,
		@LastName,
		@Title,
		@Phone,
		@Fax,
		@Email,
		@Birthdate,	
		GETDATE(),	
		@ModifiedBy,
		GETDATE(),	
		@CreatedBy
	)
	
	Declare @ContactID int
	SET @ContactID = SCOPE_IDENTITY();
	IF @IsSilent = 0		
		EXEC LibertyPower.dbo.usp_ContactSelect @ContactID;
	
	RETURN @ContactID;
END



