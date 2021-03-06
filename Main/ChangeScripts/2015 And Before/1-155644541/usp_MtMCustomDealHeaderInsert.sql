USE [lp_mtm]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************
 *																								*
 *	Author:		fmedeiros																		*
 *	Created:	03/05/2013																		*
 *	Descp:		created for IT051 Phase 2a														*
 *																								*
 *	Modified:	Gail Mangaroo																	*
 *			:	Added EntityCount 
 *																								*
 ********************************************************************************************** */
ALTER Procedure [dbo].[usp_MtMCustomDealHeaderInsert]
	@PricingRequest varchar(50)
   ,@CustomerName varchar(100)
   ,@SalesChannel varchar(50)
   ,@ProductCode varchar(50)
   ,@ContractStartDate datetime
   ,@HasPassThrough bit
   ,@Term int
   ,@BackToBack bit
   ,@ExpectedTermUsage int
   ,@CommissionCap decimal (18,3)
   ,@PriceAggregation varchar(50)
   ,@IndexType varchar(10)
   ,@AggregationDeal bit
   ,@Zkey varchar(10)= null
   ,@DateCreated datetime
   ,@FileName varchar(100)
   ,@CreatedBy varchar(50)
   
   ,@new_id int output
   
   ,@PassEnergy bit
   ,@PassShaping bit
   ,@PassIntraday bit
   ,@PassAncillaryServices bit
   ,@PassARR bit
   ,@PassCapacity bit
   ,@PassLosses bit
   ,@PassVoluntaryGreen bit
   ,@PassMLC bit
   ,@PassTransmission bit
   ,@PassRUC bit
   ,@PassRMR bit
   ,@PassRPS bit
   ,@PassFinancingFee bit
   ,@PassPORBadDebtFee bit
   ,@PassInvoicingCost bit
   ,@PassBandwidth bit
   ,@PassPUCAssessmentFee bit
   ,@PassPaymentTermPremium bit
   ,@PassPostingCollateral bit
   ,@PassCustomBilling bit
   ,@PassMiscFee bit
   
   ,@EntityCount int 
AS

BEGIN

SET NOCOUNT ON; 

INSERT INTO [MtMCustomDealHeader]
           ([PricingRequest]
           ,[CustomerName]
           ,[SalesChannel]
           ,[ProductCode]
           ,[ContractStartDate]
           ,[Term]
           ,[HasPassThrough]
           ,[BackToBack]
           ,[ExpectedTermUsage]
		   ,[CommissionCap]
           ,[PriceAggregation]
           ,[IndexType]
           ,[AggregationDeal]
           ,[Zkey]
           ,[FileName]
           ,[PassEnergy]
           ,[PassShaping]
           ,[PassIntraday]
           ,[PassAncillaryServices]
           ,[PassARR]
           ,[PassCapacity]
           ,[PassLosses]
           ,[PassVoluntaryGreen]
           ,[PassMLC]
           ,[PassTransmission]
           ,[PassRUC]
           ,[PassRMR]
           ,[PassRPS]
           ,[PassFinancingFee]
           ,[PassPORBadDebtFee]
           ,[PassInvoicingCost]
           ,[PassBandwidth]
           ,[PassPUCAssessmentFee]
           ,[PassPaymentTermPremium]
           ,[PassPostingCollateral]
           ,[PassCustomBilling]
           ,[PassMiscFee]
           ,[DateCreated]
           ,[CreatedBy]
           
           ,EntityCount
           )
     VALUES
           (@PricingRequest
		   ,@CustomerName
		   ,@SalesChannel
		   ,@ProductCode
		   ,@ContractStartDate
		   ,@Term
		   ,@HasPassThrough
		   ,@BackToBack
		   ,@ExpectedTermUsage
		   ,@CommissionCap
		   ,@PriceAggregation
		   ,@IndexType
		   ,@AggregationDeal
		   ,@Zkey
		   ,@FileName
		   ,@PassEnergy
           ,@PassShaping
           ,@PassIntraday
           ,@PassAncillaryServices
           ,@PassARR
           ,@PassCapacity
           ,@PassLosses
           ,@PassVoluntaryGreen
           ,@PassMLC
           ,@PassTransmission
           ,@PassRUC
           ,@PassRMR
           ,@PassRPS
           ,@PassFinancingFee
           ,@PassPORBadDebtFee
           ,@PassInvoicingCost
           ,@PassBandwidth
           ,@PassPUCAssessmentFee
           ,@PassPaymentTermPremium
           ,@PassPostingCollateral
           ,@PassCustomBilling
           ,@PassMiscFee
		   ,@DateCreated
		   ,@CreatedBy
		   
		   ,@EntityCount
		   )
		   
select @new_id = SCOPE_IDENTITY();

SET NOCOUNT OFF; 

END


