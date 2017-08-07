
/*
*
* PROCEDURE:	[usp_CustomerUpdate]
*
* DEFINITION:  Updates a record into Customer table
*
* RETURN CODE: 
*
* REVISIONS:	6/24/2011 11:58:55 AM	Jaime Forero
*/

CREATE PROCEDURE [dbo].[usp_CustomerUpdate]
	@CustomerID INT,
	@NameID INT = null,
	@OwnerNameID INT = null,
	@AddressID INT = null,
	@CustomerPreferenceID INT = null,
	@ContactID INT = null,
	@ExternalNumber VARCHAR(64) = NULL,
	@DBA VARCHAR(128) = NULL,
	@Duns VARCHAR(30) = NULL,
	@SsnClear NVARCHAR(100) = null,
	@SsnEncrypted NVARCHAR(512) = null,
	@TaxId VARCHAR(30) = NULL,
	@EmployerId varchar(30) = NULL,
	@CreditAgencyID INT = null,
	@CreditScoreEncrypted NVARCHAR(512) = null,
	@BusinessTypeID INT = null,
	@BusinessActivityID INT = null,
	@ModifiedBy INT = null,
	@IsSilent BIT = 0
AS
BEGIN 
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET FMTONLY OFF
	SET NO_BROWSETABLE OFF

	-- CLEAN SOME DATA, previoulsy done in trigger
	SET @TaxId			= lp_account.dbo.ufn_strip_special_characters(@TaxId);
	SET @DBA			= lp_account.dbo.ufn_strip_special_characters(@DBA);
	SET @EmployerId		= lp_account.dbo.ufn_strip_special_characters(@EmployerId);	
	SET @Duns			= lp_account.dbo.ufn_strip_special_characters(@Duns);	
	
	--IF @ContactID IS NULL OR @ContactID = 0 OR @ContactID = -1
	--	RAISERROR('@ContactID IS NULL in the Customer Update procedure, cannot continue',11,1)
		
	UPDATE LibertyPower.[dbo].[Customer]
	SET [NameID] = ISNULL(@NameID,NameID) ,
		[OwnerNameID] = ISNULL(@OwnerNameID,OwnerNameID),
		[AddressID] = ISNULL(@AddressID,AddressID),
		[CustomerPreferenceID] = ISNULL(@CustomerPreferenceID,CustomerPreferenceID), 
		[ContactID] = ISNULL(@ContactID, ContactID) ,
		[ExternalNumber] = ISNULL(@ExternalNumber, ExternalNumber),
		[DBA] = ISNULL(@DBA, DBA),
		[Duns] = ISNULL(@Duns,Duns),
		[SsnClear] = @SsnClear,
		[SsnEncrypted] = @SsnEncrypted,
		[TaxId] = ISNULL(@TaxId, TaxId),
		[EmployerId] = ISNULL(@EmployerId,EmployerId),
		[CreditAgencyID] = ISNULL(@CreditAgencyID,CreditAgencyID),
		[CreditScoreEncrypted] = @CreditScoreEncrypted,
		[BusinessTypeID] = @BusinessTypeID,
		[BusinessActivityID] = @BusinessActivityID,
		[Modified] = GETDATE(),
		[ModifiedBy] = @ModifiedBy
	WHERE CustomerID = @CustomerID 
	;
	IF @IsSilent = 0
		EXEC LibertyPower..usp_CustomerSelect @CustomerID;
	RETURN @CustomerID;
END
