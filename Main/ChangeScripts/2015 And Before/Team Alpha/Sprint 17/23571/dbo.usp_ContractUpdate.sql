USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ContractUpdate]    Script Date: 10/29/2013 16:29:23 ******/


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
*
* PROCEDURE:	[usp_ContractUpdate]
*
* DEFINITION:  Updates a record on the contract table.
*
* RETURN CODE: 
*
*			 Developer			ModifiedDate	  Description	
* REVISIONS: Satchi Jena 	    10/29/2013        Added AffinityCode.
*/


ALTER PROCEDURE [dbo].[usp_ContractUpdate]
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
   ,@DigitalSignature varchar(100) = null
   ,@AffinityCode varchar(50) = null
AS
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	
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
		,[DigitalSignature] = Isnull(@DigitalSignature, [DigitalSignature])
		,[ModifiedBy] = @ModifiedBy
		,[Modified] = GETDATE()
		,[MigrationComplete] = @MigrationComplete
		,[EstimatedAnnualUsage] = ISNULL(@EstimatedAnnualUsage, 0)
		,[AffinityCode] = @AffinityCode 
	WHERE  ContractID = @ContractID
	;
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_ContractSelect @ContractID;
	
	RETURN @ContractID;

SET NOCOUNT OFF 	

END
