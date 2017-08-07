USE lp_mtm
GO 

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[zAuditMtMCustomDealAccountInsert]'))
	DROP TRIGGER [dbo].[zAuditMtMCustomDealAccountInsert]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 12/11/2013
-- Description:	Update trigger 
-- =============================================
CREATE TRIGGER dbo.zAuditMtMCustomDealAccountInsert
   ON  dbo.MtMCustomDealAccount
   AFTER INSERT,UPDATE
AS 
BEGIN

	SET NOCOUNT ON;

    -- Insert statements for trigger here
	INSERT INTO [lp_mtm].[dbo].[zAuditMtMCustomDealAccount]
        
           ([ID]
           ,[CustomDealID]
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
           ,[DateCreated]
           ,[CreatedBy]
           ,[ModifiedBy]
           ,[DateModified]
           ,[DealPricingID]
           ,[InActive]
           ,[AccountID]
           ,[ContractID]
           ,[DeliveryLocationRefID]
           ,[SettlementLocationRefID]
           ,[LoadProfileRefID]
           ,[AccountTypeID]
           ,[BillingTypeID])
     
     SELECT 
           ID
           ,CustomDealID
           ,AccountNumber
           ,Utility
           ,DeliveryLocation
           ,SettlementLocation
           
           ,MeterType
           ,ProfileID
           ,LossFactorID
           ,AccountType
           ,BillingType
           ,PureShapingPremiumFactor
           ,VolShapingPremiumFactor
           ,ContractRate
           ,Margin
           ,Commission
           ,TotalCost
           ,Energy
           ,Shaping
           ,Intraday
           ,AncillaryServices
           ,ARR
           ,Capacity
           ,Losses
           ,VoluntaryGreen
           ,MLC
           ,Transmission
           ,RUC
           ,RMR
           ,RPS
           ,FinancingFee
           ,PORBarDebtFee
           ,InvoicingCost
           ,Bandwidth
           ,PUCAssessmentFee
           ,PaymentTermPremium
           ,PostingCollateral
           ,CustomBilling
           ,MiscFee
           ,DateCreated 
           ,CreatedBy
           ,ModifiedBy
           ,DateModified
           ,DealPricingID
           ,InActive
           ,AccountID
           ,ContractID
           ,DeliveryLocationRefID
           ,SettlementLocationRefID
           ,LoadProfileRefID
           ,AccountTypeID
           ,BillingTypeID
	FROM inserted

	SET NOCOUNT OFF;
END
GO
