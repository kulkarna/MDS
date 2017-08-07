USE lp_mtm
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MtMCustomDealAccountInsert]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MtMCustomDealAccountInsert]
GO

/* **********************************************************************************************
 *																								*
 *	Author:		Gail Mangaroo																	*
 *	Created:	12/11/2013																		*
 *	Descp:																						*
 ********************************************************************************************** */
 
 CREATE PROCEDURE  usp_MtMCustomDealAccountInsert
( 
	@CustomDealID int = null 
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
		
	, @DealPricingID int = null 
	, @InActive bit  = null 
	, @AccountID int = null 
	, @ContractID int = null 
	, @DeliveryLocationRefID int = null 
	, @SettlementLocationRefID int = null 
	, @LoadProfileRefID int = null 
	, @AccountTypeID int = null 
	, @BillingTypeID int = null 
	
	, @CreatedBy varchar(50)
	
) 
AS 
BEGIN 
	
	SET NOCOUNT ON;
	
	INSERT INTO [lp_MtM].[dbo].[MtMCustomDealAccount]
           ([CustomDealID]
           ,[AccountNumber]
           ,[Utility]
           ,[DeliveryLocation]
           ,[SettlementLocation]
           
           ,[MeterType]
           ,[ProfileID]
           ,[LossFactorID]
           ,[AccountType]
           ,[BillingType]
           ,[PureShapingPremiumFactor]
           ,[VolShapingPremiumFactor]
          
           ,[ContractRate]
           ,[Margin]
           ,[Commission]
           ,[TotalCost]
           ,[Energy]
           ,[Shaping]
           ,[Intraday]
           ,[AncillaryServices]
           ,[ARR]
           ,[Capacity]
           ,[Losses]
           ,[VoluntaryGreen]
           ,[MLC]
           ,[Transmission]
           ,[RUC]
           ,[RMR]
           ,[RPS]
           ,[FinancingFee]
           ,[PORBarDebtFee]
           ,[InvoicingCost]
           ,[Bandwidth]
           ,[PUCAssessmentFee]
           ,[PaymentTermPremium]
           ,[PostingCollateral]
           ,[CustomBilling]
           ,[MiscFee]
           
           --,[DateCreated]
           ,[CreatedBy]
           
           --,[ModifiedBy]
           --,[DateModified]
           
           ,[DealPricingID]
           ,[InActive]
           ,[AccountID]
           ,[ContractID]
           ,[DeliveryLocationRefID]
           ,[SettlementLocationRefID]
           ,[LoadProfileRefID]
           ,[AccountTypeID]
           ,[BillingTypeID])
     
     VALUES
           ( @CustomDealID  
			, @AccountNumber 
			, @Utility  
			, @DeliveryLocation  
			, @SettlementLocation  
			
			, @MeterType  
			, @ProfileID  
			, @LossFactorID  
			, @AccountType  
			, @BillingType  
			, @PureShapingPremiumFactor  
			, @VolShapingPremiumFactor  
			
			, @ContractRate  
			, @Margin  
			, @Commission  
			, @TotalCost  
			, @Energy  
			, @Shaping  
			, @Intraday  
			, @AncillaryServices  
			, @ARR  
			, @Capacity  
			, @Losses  
			, @VoluntaryGreen  
			, @MLC  
			, @Transmission  
			, @RUC  
			, @RMR  
			, @RPS  
			, @FinancingFee  
			, @PORBarDebtFee  
			, @InvoicingCost  
			, @Bandwidth  
			, @PUCAssessmentFee  
			, @PaymentTermPremium  
			, @PostingCollateral  
			, @CustomBilling  
			, @MiscFee  
			
			
			, @CreatedBy 
			
			
			, @DealPricingID  
			, @InActive  
			, @AccountID  
			, @ContractID  
			, @DeliveryLocationRefID  
			, @SettlementLocationRefID  
			, @LoadProfileRefID  
			, @AccountTypeID  
			, @BillingTypeID  
			)
			
			
			SELECT SCOPE_IDENTITY()

	SET NOCOUNT OFF;
END 	
GO


