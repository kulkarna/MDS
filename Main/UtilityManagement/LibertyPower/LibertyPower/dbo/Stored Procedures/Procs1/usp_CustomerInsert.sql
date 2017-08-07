/*
*
* PROCEDURE:	usp_CustomerInsert
*
* DEFINITION:  Inserts a record into Customer
*
* RETURN CODE: 
*
* REVISIONS:	6/9/2011 11:58:55 AM	Jaime Forero
*/


CREATE PROCEDURE [dbo].[usp_CustomerInsert]
		@NameID INT,
		@OwnerNameID INT = null,
		@AddressID INT = null,
		@CustomerPreferenceID INT = null,
		@ContactID INT = null,
		@ExternalNumber VARCHAR(64) = null,
		@DBA VARCHAR(128) = null,
		@Duns VARCHAR(30) = null,
		@SsnClear NVARCHAR(100) = null,
		@SsnEncrypted NVARCHAR(512) = null,
		@TaxId VARCHAR(30) = null,
		@EmployerId varchar(30) = null,
		@CreditAgencyID INT = null,
		@CreditScoreEncrypted NVARCHAR(512) = null,
		@BusinessTypeID INT = null,
		@BusinessActivityID INT = null,
		@ModifiedBy INT,
		@CreatedBy INT,
		@IsSilent BIT = 0
AS
BEGIN 
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET FMTONLY OFF
	SET NO_BROWSETABLE OFF

	DECLARE @CustomerID INT;
	
	-- CLEAN SOME DATA, previoulsy done in trigger
	SET @TaxId			= lp_account.dbo.ufn_strip_special_characters(@TaxId);
	SET @DBA			= lp_account.dbo.ufn_strip_special_characters(@DBA);
	SET @EmployerId		= lp_account.dbo.ufn_strip_special_characters(@EmployerId);	
	SET @Duns			= lp_account.dbo.ufn_strip_special_characters(@Duns);	
	
	INSERT INTO [dbo].[Customer]
	(
		[NameID],
		[OwnerNameID],
		[AddressID],
		[CustomerPreferenceID],
		[ContactID],
		[ExternalNumber],
		[DBA],
		[Duns],
		[SsnClear],
		[SsnEncrypted],
		[TaxId],
		[EmployerId],
		[CreditAgencyID],
		[CreditScoreEncrypted],
		[BusinessTypeID],
		[BusinessActivityID],
		[ModifiedBy],
		[Modified],
		[CreatedBy],
		[DateCreated]
	)
	VALUES
	(
		@NameID,
		@OwnerNameID,
		@AddressID,
		@CustomerPreferenceID,
		@ContactID,
		@ExternalNumber,
		@DBA,
		@Duns,
		@SsnClear,
		@SsnEncrypted,
		@TaxId,
		@EmployerId,
		@CreditAgencyID,
		@CreditScoreEncrypted,
		@BusinessTypeID,
		@BusinessActivityID,
		@ModifiedBy,
		GETDATE(),
		@CreatedBy,
		GETDATE()
	)
		
	SET @CustomerID = SCOPE_IDENTITY();
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_CustomerSelect @CustomerID;
	
	RETURN @CustomerID;

END
