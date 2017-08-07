

/*
*
* PROCEDURE:	usp_Account_U
*
* DEFINITION:  Updates a record from Account
*
* RETURN CODE: 
*
* REVISIONS:	6/9/2011 11:58:15 AM	Jaime Forero
*/


CREATE PROCEDURE [dbo].[usp_AccountUpdate]
	@AccountID INT,
	@AccountIdLegacy CHAR(12) ,
	@AccountNumber VARCHAR(30),
	@AccountTypeID INT= NULL,
	@CurrentContractID INT = NULL,
	@CurrentRenewalContractID INT = NULL,
	@CustomerID INT= NULL,
	@CustomerIdLegacy VARCHAR(10) = '',
	@EntityID CHAR(15),
	@RetailMktID INT= NULL,
	@UtilityID INT= NULL,
	@AccountNameID INT= NULL,
	@BillingAddressID INT= NULL,
	@BillingContactID INT= NULL,
	@ServiceAddressID INT= NULL,
	@Origin VARCHAR(50),
	@TaxStatusID INT= NULL,
	@PorOption BIT= NULL,
	@BillingTypeID INT= NULL,
	@Zone VARCHAR(50),
	@ServiceRateClass VARCHAR(50),
	@StratumVariable VARCHAR(15),
	@BillingGroup VARCHAR(15),
	@Icap VARCHAR(15),
	@Tcap VARCHAR(15),
	@LoadProfile VARCHAR(50),
	@LossCode VARCHAR(15),
	@MeterTypeID INT = NULL,
	@Modified DATETIME, -- This is only here because of migration purposes but normally this shouldnt be used !
	@ModifiedBy INT = NULL, 
	@DateCreated DATETIME, -- This is only here because of migration purposes but normally this shouldnt be used !
	@CreatedBy INT = NULL, -- This is only here because of migration purposes but normally this shouldnt be used !
	@MigrationComplete BIT = 1,
	@IsSilent BIT = 0
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	IF @Modified IS NULL
		SET @Modified = GETDATE();
		
	UPDATE [dbo].[Account] WITH (ROWLOCK)
		SET
		[AccountIdLegacy] = @AccountIdLegacy,
		[AccountNumber] = @AccountNumber,
		[AccountTypeID] = ISNULL(@AccountTypeID, AccountTypeID),
		[CurrentContractID] = @CurrentContractID, 
		[CurrentRenewalContractID] = @CurrentRenewalContractID,
		[CustomerID] = @CustomerID,
		[CustomerIdLegacy] = @CustomerIdLegacy,
		[EntityID] = @EntityID,
		[RetailMktID] = @RetailMktID,
		[UtilityID] = @UtilityID,
		[AccountNameID] = ISNULL(@AccountNameID, AccountNameID),
		[BillingAddressID] = ISNULL(@BillingAddressID,BillingAddressID) ,
		[BillingContactID] = ISNULL(@BillingContactID,BillingContactID) ,
		[ServiceAddressID] = ISNULL(@ServiceAddressID,ServiceAddressID) ,
		[Origin] = @Origin,
		[TaxStatusID] = @TaxStatusID,
		[PorOption] = @PorOption,
		[BillingTypeID] = @BillingTypeID,
		[Zone] = @Zone,
		[ServiceRateClass] = @ServiceRateClass,
		[StratumVariable] = @StratumVariable,
		[BillingGroup] = @BillingGroup,
		[Icap] = @Icap,
		[Tcap] = @Tcap,
		[LoadProfile] = @LoadProfile,
		[LossCode] = @LossCode,
		[MeterTypeID] = @MeterTypeID,
		[ModifiedBy] = ISNULL(@ModifiedBy, ModifiedBy),
		[Modified] = GETDATE(),		
		[MigrationComplete] = 1
	WHERE
		 AccountID = @AccountID 
	;

	
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountSelect @AccountID;
	
	RETURN @AccountID;
END

