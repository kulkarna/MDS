USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountInsert]    Script Date: 10/14/2013 16:17:35 ******/
/*
UPDATE: CGHAZAL ON 12/16/2013 --: It051 Release 0: MAke sure to pass 0 to the new 3 columns (@DeliveryLocationRefId,@LoadProfileRefId,@ServiceClassRefID) in case the values are null
*/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_AccountInsert]
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
	@IsSilent BIT = 0,
	@DeliveryLocationRefId INT = null,
	@LoadProfileRefId INT = null ,
	@ServiceClassRefID INT = null 
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
           ,[MigrationComplete]
           ,[DeliveryLocationRefId]
		   ,[LoadProfileRefId]
		   ,[ServiceClassRefID]
		
	)
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
			1 ,
			ISNULL(@DeliveryLocationRefId,0),
			ISNULL(@LoadProfileRefId,0),
			ISNULL(@ServiceClassRefID,0)
           )
	;
	SET @AccountID  = SCOPE_IDENTITY();
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountSelect @AccountID  ;
	RETURN @AccountID;

SET NOCOUNT OFF
END
