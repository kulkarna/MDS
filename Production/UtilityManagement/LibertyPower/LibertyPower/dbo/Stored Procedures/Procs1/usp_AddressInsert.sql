-- =================================================
-- Modified 10/31/2012 - Jose Munoz SWCS 
-- Ticket # 1-34030211
-- ADD @IsSilent parameter
-- =======================================

CREATE PROCEDURE [dbo].[usp_AddressInsert]	
	@Address1 nvarchar(150),
	@Address2 nvarchar(150) = '',
	@City nvarchar(100),
	@State char(2),
	@StateFips char(2) = '',
	@Zip char(10),
	@County nvarchar(100) = '',
	@CountyFips char(3) = '',
	@ModifiedBy int,
	@CreatedBy int,
	@IsSilent BIT = 0
AS
BEGIN
	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    Insert Into LibertyPower.dbo.[Address]
    (
		[Address1],
		[Address2],
		[City],
		[State],
		[StateFips],
		[Zip],
		[County],
		[CountyFips],		
		[Modified],
		[ModifiedBy],
		[DateCreated],
		[CreatedBy]
    )
    Values
    (
		@Address1,
		@Address2,
		@City,
		@State,
		@StateFips,
		@Zip,
		@County,
		@CountyFips,
		GETDATE(),
		@ModifiedBy,
		GETDATE(),
		@CreatedBy
    )
   
	Declare @AddressID int
	SET @AddressID = SCOPE_IDENTITY();
	IF @IsSilent = 0		
		EXEC LibertyPower.dbo.usp_AddressSelect @AddressID;
	
	RETURN @AddressID;
END

