
CREATE PROCEDURE [dbo].[usp_AccountInsert]
	@AccountIdLegacy CHAR(12),
	@AccountNumber VARCHAR(30),
	@AccountTypeID INT,
	@CurrentContractID INT = NULL,
	@CurrentRenewalContractID INT = NULL,
	@CustomerID INT = NULL,
	@CustomerIdLegacy VARCHAR(10) = NULL,
	@EntityID CHAR(15),
	@RetailMktID INT,
	@UtilityID INT,
	@AccountNameID INT,
	@BillingAddressID INT,
	@BillingContactID INT,
	@ServiceAddressID INT,
	@Origin VARCHAR(50),
	@TaxStatusID INT,
	@PorOption BIT,
	@BillingTypeID INT,
	@Zone VARCHAR(50) = '',
	@ServiceRateClass VARCHAR(50) = '',
	@StratumVariable VARCHAR(15) = '',
	@BillingGroup VARCHAR(15) = '',
	@Icap VARCHAR(15) = '',
	@Tcap VARCHAR(15) = '',
	@LoadProfile VARCHAR(50) = '',
	@LossCode VARCHAR(15) = '',
	@MeterTypeID INT = NULL,
	@ModifiedBy INT,
	@Modified DATETIME,
	@DateCreated DATETIME,
	@CreatedBy INT,
	@MigrationComplete BIT = 1,
	@IsSilent BIT = 0
AS
BEGIN

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
	
	DECLARE @AccountID INT;
	
	INSERT INTO [LibertyPower].[dbo].[Account]
           (
            [AccountIdLegacy]
           ,[AccountNumber]
           ,[AccountTypeID]
           ,[CurrentContractID]
           ,[CurrentRenewalContractID]
           ,[CustomerID]
           ,[CustomerIdLegacy]
           ,[EntityID]
           ,[RetailMktID]
           ,[UtilityID]
           ,[AccountNameID]
           ,[BillingAddressID]
           ,[BillingContactID]
           ,[ServiceAddressID]
           ,[Origin]
           ,[TaxStatusID]
           ,[PorOption]
           ,[BillingTypeID]
           ,[Zone]
           ,[ServiceRateClass]
           ,[StratumVariable]
           ,[BillingGroup]
           ,[Icap]
           ,[Tcap]
           ,[LoadProfile]
           ,[LossCode]
           ,[MeterTypeID]
           ,[CreatedBy]	
           ,[ModifiedBy]
           ,[Modified]
           ,[DateCreated]
           ,[MigrationComplete])
     VALUES
           (
			@AccountIdLegacy,
			@AccountNumber,
			@AccountTypeID,
			@CurrentContractID,
			@CurrentRenewalContractID,
			@CustomerID,
			@CustomerIdLegacy,
			@EntityID,
			@RetailMktID,
			@UtilityID,
			@AccountNameID,
			@BillingAddressID,
			@BillingContactID,
			@ServiceAddressID,
			@Origin,
			@TaxStatusID,
			@PorOption,
			@BillingTypeID,
			@Zone,
			@ServiceRateClass,
			@StratumVariable,
			@BillingGroup,
			@Icap,
			@Tcap,
			@LoadProfile,
			@LossCode,
			@MeterTypeID ,
			@CreatedBy ,
			@ModifiedBy,
			GETDATE(),
			GETDATE(),
			1 
           )
	;
	SET @AccountID  = SCOPE_IDENTITY();
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountSelect @AccountID  ;
	RETURN @AccountID;
END
