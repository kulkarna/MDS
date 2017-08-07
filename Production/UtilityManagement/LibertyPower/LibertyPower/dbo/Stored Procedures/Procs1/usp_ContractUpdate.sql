
CREATE PROCEDURE [dbo].[usp_ContractUpdate]
	@ContractID INT
   ,@Number VARCHAR(50)
   ,@ContractTypeID INT
   ,@ContractDealTypeID INT
   ,@ContractStatusID INT
   ,@ContractTemplateID INT
   ,@ReceiptDate DATETIME
   ,@StartDate DATETIME
   ,@EndDate DATETIME
   ,@SignedDate DATETIME
   ,@SubmitDate DATETIME
   ,@SalesChannelID INT = NULL
   ,@SalesRep VARCHAR(64)
   ,@SalesManagerID INT= NULL
   ,@PricingTypeID INT = NULL
   ,@ModifiedBy INT = NULL
   ,@IsSilent BIT = 0
   ,@MigrationComplete BIT = 0
   ,@EstimatedAnnualUsage int = NULL
AS
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET FMTONLY OFF
	SET NO_BROWSETABLE OFF
	
	-- DATA CLEANUP
	SET @SalesRep	= lp_account.dbo.ufn_strip_special_characters(@SalesRep);	

	UPDATE [LibertyPower].[dbo].[Contract]
	SET  [Number] = @Number
		,[ContractTypeID] = @ContractTypeID
		,[ContractDealTypeID] = @ContractDealTypeID
		,[ContractStatusID] = @ContractStatusID
		,[ContractTemplateID] = @ContractTemplateID
		,[ReceiptDate] = @ReceiptDate
		,[StartDate] = @StartDate
		,[EndDate] = @EndDate
		,[SignedDate] = @SignedDate
		,[SubmitDate] = @SubmitDate	
		,[SalesChannelID] = @SalesChannelID
		,[SalesRep] = @SalesRep
		,[SalesManagerID] = @SalesManagerID
		,[PricingTypeID] = @PricingTypeID
		,[ModifiedBy] = @ModifiedBy
		,[Modified] = GETDATE()
		,[MigrationComplete] = @MigrationComplete
		,[EstimatedAnnualUsage] = ISNULL(@EstimatedAnnualUsage, 0)
	WHERE  ContractID = @ContractID
	;
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_ContractSelect @ContractID;
	
	RETURN @ContractID;
	
END
