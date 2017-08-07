USE lp_mtm
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MtMCustomDealAccountUpdate]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MtMCustomDealAccountUpdate]
GO

/* **********************************************************************************************
 *																								*
 *	Author:		Gail Mangaroo																	*
 *	Created:	12/11/2013																		*
 *	Descp:																						*
 ********************************************************************************************** */
 
 CREATE PROCEDURE  usp_MtMCustomDealAccountUpdate 
( @ID int 
	, @CustomDealID int = null 
	, @AccountNumber varchar(50) = null
	, @Utility varchar(50) = null 
	, @DeliveryLocation varchar(50) = null 
	, @SettlementLocation varchar(50) = null 
	
	, @MeterType varchar(50) = null 
	, @ProfileID varchar(50) = null 
	, @LossFactorID varchar(50) = null 
	, @AccountType varchar(50) = null 
	, @BillingType varchar(50) = null 
	, @PureShapingPremiumFactor decimal(9,6) = null 
	, @VolShapingPremiumFactor decimal(9,6) = null 
	
	, @ContractRate decimal(9,6) = null 
	, @Margin decimal(9,6) = null 
	, @Commission decimal(9,6) = null 
	, @TotalCost decimal(9,6) = null 
	, @Energy decimal(9,6) = null 
	, @Shaping decimal(9,6) = null 
	, @Intraday decimal(9,6) = null 
	, @AncillaryServices decimal(9,6) = null 
	, @ARR decimal(9,6) = null 
	, @Capacity decimal(9,6) = null 
	, @Losses decimal(9,6) = null 
	, @VoluntaryGreen decimal(9,6) = null 
	, @MLC decimal(9,6) = null 
	, @Transmission decimal(9,6) = null 
	, @RUC decimal(9,6) = null 
	, @RMR decimal(9,6) = null 
	, @RPS decimal(9,6) = null 
	, @FinancingFee decimal(9,6) = null 
	, @PORBarDebtFee decimal(9,6) = null 
	, @InvoicingCost decimal(9,6) = null 
	, @Bandwidth decimal(9,6) = null 
	, @PUCAssessmentFee decimal(9,6) = null 
	, @PaymentTermPremium decimal(9,6) = null 
	, @PostingCollateral decimal(9,6) = null 
	, @CustomBilling decimal(9,6) = null 
	, @MiscFee decimal(9,6) = null 
	
	
	, @ModifiedBy varchar(50)
	
	
	, @DealPricingID int = null 
	, @InActive bit  = null 
	, @AccountID int = null 
	, @ContractID int = null 
	, @DeliveryLocationRefID int = null 
	, @SettlementLocationRefID int = null 
	, @LoadProfileRefID int = null 
	, @AccountTypeID int = null 
	, @BillingTypeID int = null 
	
) 
AS 
BEGIN 

	SET NOCOUNT ON; 

	UPDATE [lp_MtM].[dbo].[MtMCustomDealAccount]
	SET 
		[CustomDealID] = ISNULL ( @CustomDealID , [CustomDealID] ) 
      ,[AccountNumber] = ISNULL ( @AccountNumber , [AccountNumber] ) 
      ,[Utility] = ISNULL( @Utility, Utility ) 
      ,[DeliveryLocation] = ISNULL ( @DeliveryLocation, DeliveryLocation )
      ,[SettlementLocation] = ISNULL ( @SettlementLocation, SettlementLocation )

      ,[MeterType] = ISNULL ( @MeterType , MeterType )
      ,[ProfileID] = ISNULL ( @ProfileID , ProfileID )
      ,[LossFactorID] = ISNULL ( @LossFactorID, LossFactorID ) 
      ,[AccountType] = ISNULL ( @AccountType , AccountType ) 
      ,[BillingType] = ISNULL ( @BillingType, BillingType ) 
      ,[PureShapingPremiumFactor] = ISNULL ( @PureShapingPremiumFactor , PureShapingPremiumFactor ) 
      ,[VolShapingPremiumFactor] = ISNULL ( @VolShapingPremiumFactor , VolShapingPremiumFactor ) 
      ,[ContractRate] = ISNULL ( @ContractRate , ContractRate) 
      ,[Margin] = ISNULL ( @Margin , Margin) 
      ,[Commission] = ISNULL ( @Commission , Commission ) 
      ,[TotalCost] = ISNULL ( @TotalCost, TotalCost ) 
      ,[Energy] = ISNULL ( @Energy , Energy ) 
      ,[Shaping] = ISNULL ( @Shaping, Shaping ) 
      ,[Intraday] = ISNULL ( @Intraday, Intraday ) 
      ,[AncillaryServices] = ISNULL ( @AncillaryServices, AncillaryServices ) 
      ,[ARR] = ISNULL ( @ARR , ARR ) 
      ,[Capacity] = ISNULL ( @Capacity, Capacity ) 
      ,[Losses] = ISNULL ( @Losses , Losses ) 
      ,[VoluntaryGreen] = ISNULL ( @VoluntaryGreen, VoluntaryGreen ) 
      ,[MLC] = ISNULL ( @MLC , MLC ) 
      ,[Transmission] = ISNULL ( @Transmission, Transmission ) 
      ,[RUC] = ISNULL ( @RUC , RUC ) 
      ,[RMR] = ISNULL ( @RMR , RMR ) 
      ,[RPS] = ISNULL ( @RPS , RPS ) 
      ,[FinancingFee] = ISNULL ( @FinancingFee, FinancingFee ) 
      ,[PORBarDebtFee] = ISNULL ( @PORBarDebtFee, PORBarDebtFee ) 
      ,[InvoicingCost] = ISNULL ( @InvoicingCost, InvoicingCost ) 
      ,[Bandwidth] = ISNULL ( @Bandwidth, Bandwidth ) 
      ,[PUCAssessmentFee] = ISNULL ( @PUCAssessmentFee, PUCAssessmentFee ) 
      ,[PaymentTermPremium] = ISNULL ( @PaymentTermPremium , PaymentTermPremium ) 
      ,[PostingCollateral] = ISNULL ( @PostingCollateral, PostingCollateral) 
      ,[CustomBilling] = ISNULL ( CustomBilling, CustomBilling ) 
      ,[MiscFee] = ISNULL ( @MiscFee, MiscFee ) 
      
      --,[DateCreated] = <DateCreated, datetime,>
      --,[CreatedBy] = <CreatedBy, varchar(50),>
      
      ,[ModifiedBy] = @ModifiedBy
      ,[DateModified] = getdate() 
      
      ,[DealPricingID] = ISNULL ( @DealPricingID, DealPricingID ) 
      ,[InActive] = ISNULL ( @InActive, InActive ) 
      ,[AccountID] = ISNULL ( @AccountID, AccountID ) 
      ,[ContractID] = ISNULL ( @ContractID , ContractID ) 
      ,[DeliveryLocationRefID] = ISNULL ( @DeliveryLocationRefID , DeliveryLocationRefID ) 
      ,[SettlementLocationRefID] = ISNULL ( @SettlementLocationRefID , SettlementLocationRefID ) 
      ,[LoadProfileRefID] = ISNULL ( @LoadProfileRefID , LoadProfileRefID ) 
      ,[AccountTypeID] = ISNULL ( @AccountTypeID , AccountTypeID ) 
      ,[BillingTypeID] = ISNULL ( @BillingTypeID, @BillingTypeID ) 

	WHERE ID = @ID

	SELECT @@ROWCOUNT;

	SET NOCOUNT OFF; 
END
GO


