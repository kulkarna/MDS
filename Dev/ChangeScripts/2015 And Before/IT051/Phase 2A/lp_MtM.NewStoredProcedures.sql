/* ------------------------------------------------------------

DESCRIPTION: Schema Synchronization Script for Object(s) \r\n
    procedures:
        [dbo].[usp_GetCommonProductId], [dbo].[usp_GetDealPrincingByAccountID], [dbo].[usp_MtMCustomDealAccountSelect], [dbo].[usp_MtMCustomDealDelete], [dbo].[usp_MtMCustomDealHeaderInsert], [dbo].[usp_MtMCustomDealHeaderSelect], [dbo].[usp_MtMCustomerInfoByPR], [dbo].[usp_MtMGetContractDates], [dbo].[usp_MtMGetStatusSubStatus], [dbo].[usp_MtMUpdateExistentCustomDeal]

     Make LPCNOCSQL9\TRANSACTIONS.lp_MtM Equal vm2lpcnocsql9\TRANSACTIONS.lp_MtM_UAT

   AUTHOR:	[Insert Author Name]

   DATE:	3/13/2013 2:47:35 PM

   LEGAL:	2012[Insert Company Name]

   ------------------------------------------------------------ */

SET NOEXEC OFF
SET ANSI_WARNINGS ON
SET XACT_ABORT ON
SET IMPLICIT_TRANSACTIONS OFF
SET ARITHABORT ON
SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
GO
USE [lp_MtM]
GO

BEGIN TRAN
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_GetCommonProductId]
Print 'Create Procedure [dbo].[usp_GetCommonProductId]'
GO
/* **********************************************************************************************
 *																								*
 *	Author:		fmedeiros																		*
 *	Created:	03/05/2013																		*
 *	Descp:		created for IT051 Phase 2a														*
 *																								*
 *	Modified:																					*
 *																								*
 ********************************************************************************************** */
CREATE procedure [dbo].[usp_GetCommonProductId] 
(
	@productCategory as varchar(50)
	,@utilityCode as varchar(50)	
	,@accountTypeID as int
)
as
BEGIN

SET NOCOUNT ON; 

	SELECT 
		product_id
	FROM lp_common..common_product p (nolock)
	WHERE
		product_category = @productCategory
		and IsCustom = 1
		and inactive_ind = 0
		and utility_id = @utilityCode
		and account_type_id = @accountTypeID
		
SET NOCOUNT OFF; 
END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_MtMGetStatusSubStatus]
Print 'Create Procedure [dbo].[usp_MtMGetStatusSubStatus]'
GO
/* **********************************************************************************************
 *																								*
 *	Author:		fmedeiros																		*
 *	Created:	03/05/2013																		*
 *	Descp:		created for IT051 Phase 2a														*
 *																								*
 *	Modified:																					*
 *																								*
 ********************************************************************************************** */
CREATE procedure [dbo].[usp_MtMGetStatusSubStatus]
as
BEGIN

SET NOCOUNT ON; 

select StatusCode                                  = LTRIM(rtrim(Status))
                                                   + '-'
                                                   + LTRIM(rtrim(Sub_Status)),
       StatusDescription                           = ltrim(rtrim(Status_Descp))
                                                   + '-'
                                                   + ltrim(rtrim(Sub_Status_Descp))                                       
from lp_account.dbo.enrollment_status_substatus_vw with (nolock)

SET NOCOUNT OFF; 

END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_MtMCustomerInfoByPR]
Print 'Create Procedure [dbo].[usp_MtMCustomerInfoByPR]'
GO
/* **********************************************************************************************
 *																								*
 *	Author:		fmedeiros																		*
 *	Created:	03/05/2013																		*
 *	Descp:		created for IT051 Phase 2a														*
 *																								*
 *	Modified:																					*
 *																								*
 ********************************************************************************************** */
CREATE PROCEDURE  [dbo].[usp_MtMCustomerInfoByPR] --'PR-201210-35630'
(
	@PricingRequest varchar(50)
)
AS
BEGIN

SET NOCOUNT ON; 

	SELECT      
	r.Name AS REQUEST_ID
	,u.FirstName
	,u.LastName
	,isnull(u.Phone, '0000000000') as Phone
	,isnull(u.Email, 'customercare@libertypowercorp.com') as Email
	,isnull(u.Title,'Manager') as Title
	,isnull(a.BillingStreet,'1901 Cypress Creek') as Street
	,isnull(a.BillingCity,'Fort Lauderdale') as City
	,isnull(a.BillingState,'FL') as [State]
	,isnull(a.BillingPostalCode,'33309') as Zip
	FROM        
	SalesForce.dbo.Indicative_Pricing_Request__c r WITH (NOLOCK) INNER JOIN 
	SalesForce.dbo.User1 u WITH (NOLOCK) on r.CreatedById = u.Id INNER JOIN 
	SalesForce.dbo.Account a  (nolock) on r.IPR_Account_Name__c = a.Id 
	WHERE       --r.Pricing_Request_Status__c = 'Request Pricing'
				--and 
				r.Name = @PricingRequest
	--AND               r.CreatedDate >= CAST('5/15/2008' AS datetime)

SET NOCOUNT OFF; 

END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_MtMGetContractDates]
Print 'Create Procedure [dbo].[usp_MtMGetContractDates]'
GO
/* **********************************************************************************************  
 *                        *  
 * Author:  fmedeiros                  *  
 * Created: 03/05/2013                  *  
 * Descp:  created for IT051 Phase 2a              *  
 *                        *  
 * Modified:                     *  
 *                        *  
 ********************************************************************************************** */  
CREATE PROCEDURE [dbo].[usp_MtMGetContractDates]    
(     
 @ContractID int    
)        
AS

BEGIN

SET NOCOUNT ON; 

select f.RateStart,     
  f.RateEnd,     
  cd.ContractStartDate as CustomStartDate,     
  DATEADD(d, -1, DATEADD(m, cd.Term, cd.ContractStartDate)) as CustomEndDate    
from libertypower..Account b (nolock)  
join libertypower..AccountContract d (nolock)   
on  b.AccountID=d.AccountID     
join libertypower..Contract e (nolock) on d.ContractID=e.ContractID    
join libertypower..vw_AccountContractRate f with (nolock)   on d.AccountContractID=f.AccountContractID --and f.IsContractedRate = 1    
join lp_common..common_product_rate (nolock) g on f.LegacyProductID=g.product_id and f.RateID=g.rate_id     
join lp_common..common_product (nolock) j on g.product_id=j.product_id and j.IsCustom = 1    
join lp_deal_capture..deal_pricing_detail (nolock) h on g.product_id=h.product_id and g.rate_id=h.rate_id     
join lp_deal_capture..deal_pricing (nolock) k on h.deal_pricing_id=k.deal_pricing_id    
left join MtMCustomDealHeader (nolock) cd on k.pricing_request_id = cd.PricingRequest    
join MtMAccount (nolock) ma on b.AccountID = ma.AccountID and k.deal_pricing_id = ma.DealPricingID     
          and PATINDEX('CustomDealUpload-%', ma.QuoteNumber) > 0    
          and ma.ContractID is null    
where    
 e.ContractID = @ContractID    

SET NOCOUNT OFF; 

END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_GetDealPrincingByAccountID]
Print 'Create Procedure [dbo].[usp_GetDealPrincingByAccountID]'
GO
	/* **********************************************************************************************  
 *                        *  
 * Author:  fmedeiros                  *  
 * Created: 03/05/2013                  *  
 * Descp:  created for IT051 Phase 2a              *  
 *                        *  
 * Modified:                     *  
 *                        *  
 ********************************************************************************************** */  
CREATE Procedure [dbo].[usp_GetDealPrincingByAccountID]     
( @AccountID int =  null ) 
      
AS    
    
BEGIN    
 SET NOCOUNT ON;    

--Getting the last Deal Pricing
select 
	MAX(ID) as a, AccountID, DealPricingID
INTO
	#DealPricing
from
	MtMAccount (nolock)
where 
	AccountID = @AccountID
	and DealPricingID <> 0
	and DealPricingID is not null
group by
	AccountID, DealPricingID
	
--Returning the last Deal Pricing
select DealPricingID from #DealPricing
    
 SET NOCOUNT OFF;    
END   
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_MtMCustomDealHeaderSelect]
Print 'Create Procedure [dbo].[usp_MtMCustomDealHeaderSelect]'
GO
/* **********************************************************************************************
 *																								*
 *	Author:		fmedeiros																		*
 *	Created:	03/05/2013																		*
 *	Descp:		created for IT051 Phase 2a														*
 *																								*
 *	Modified:																					*
 *																								*
 ********************************************************************************************** */
CREATE Procedure [dbo].[usp_MtMCustomDealHeaderSelect]   
( @CustomDealID int =  null,
  @PricingRequest as varchar(50) = null )  
    
AS  
  
BEGIN  
 SET NOCOUNT ON;  
   
 Select  *  
 From MtMCustomDealHeader (nolock)  
 where  
  ((@CustomDealID IS NULL) OR (ID = @CustomDealID))  
  AND ((@PricingRequest IS NULL) OR (PricingRequest = @PricingRequest))  
  order by DateCreated desc
  
 SET NOCOUNT OFF;  
END 
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_MtMCustomDealHeaderInsert]
Print 'Create Procedure [dbo].[usp_MtMCustomDealHeaderInsert]'
GO
/* **********************************************************************************************
 *																								*
 *	Author:		fmedeiros																		*
 *	Created:	03/05/2013																		*
 *	Descp:		created for IT051 Phase 2a														*
 *																								*
 *	Modified:																					*
 *																								*
 ********************************************************************************************** */
CREATE Procedure [dbo].[usp_MtMCustomDealHeaderInsert]
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
   ,@Zkey varchar(10)
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
           ,[CreatedBy])
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
		   ,@CreatedBy)
		   
select @new_id = SCOPE_IDENTITY();

SET NOCOUNT OFF; 

END


GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_MtMUpdateExistentCustomDeal]
Print 'Create Procedure [dbo].[usp_MtMUpdateExistentCustomDeal]'
GO
/* **********************************************************************************************
 *																								*
 *	Author:		fmedeiros																		*
 *	Created:	03/05/2013																		*
 *	Descp:		created for IT051 Phase 2a														*
 *																								*
 *	Modified:																					*
 *																								*
 ********************************************************************************************** */
CREATE PROCEDURE [dbo].[usp_MtMUpdateExistentCustomDeal]  
(   
 @ContractID int  
 , @Updated bit = 0 output  
)      
AS      
      
BEGIN     
  
  SET NOCOUNT ON; 
 
 DECLARE @NeedUpdate as int  
  
 --Getting old Custom Deals with same accounts end Deal Pricing ID  
 SELECT ma.ID as MTMAccountID  
 INTO #MtMOldCustomDeal  
 FROM   
  libertypower..Account b (nolock) 
  join libertypower..AccountContract d  (nolock)  on b.AccountID=d.AccountID   
  join libertypower..[Contract] e  (nolock) on d.ContractID=e.ContractID   
  join libertypower..vw_AccountContractRate f  on d.AccountContractID=f.AccountContractID --and f.IsContractedRate = 1  
  join lp_common..common_product_rate (nolock) g on f.LegacyProductID=g.product_id and f.RateID=g.rate_id   
  join lp_common..common_product (nolock) j on g.product_id=j.product_id   
  join lp_deal_capture..deal_pricing_detail (nolock) h on g.product_id=h.product_id and g.rate_id=h.rate_id   
  join lp_deal_capture..deal_pricing (nolock) k on h.deal_pricing_id=k.deal_pricing_id  
  join MtMCustomDealHeader (nolock) cd on k.pricing_request_id = cd.PricingRequest   
           and cd.ContractStartDate = f.RateStart   
           and DATEADD(d, -1, DATEADD(m, cd.Term, cd.ContractStartDate)) = f.RateEnd  
  join MtMAccount (nolock) ma on b.AccountID = ma.AccountID and k.deal_pricing_id = ma.DealPricingID   
          and PATINDEX('CustomDealUpload-%', ma.QuoteNumber) > 0  
          and ma.ContractID is null  
 WHERE  
  e.ContractID = @ContractID  
 
       
 SELECT @NeedUpdate = COUNT(*) FROM #MtMOldCustomDeal  
  
 --If #MtMOldCustomDeal has any row then MtMAccount need to be updated with new ContractID  
 IF @NeedUpdate > 0  
 BEGIN  
  UPDATE ma SET ma.ContractID = @ContractID  
  FROM MtMAccount ma join #MtMOldCustomDeal moa on ID = moa.MTMAccountID  
    
  --Changing the Updated flag  
  SELECT @Updated = 1  
 END  
  
SET NOCOUNT OFF; 
  
END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_MtMCustomDealAccountSelect]
Print 'Create Procedure [dbo].[usp_MtMCustomDealAccountSelect]'
GO
/* **********************************************************************************************
 *	Author:		fmedeiros																		*
 *	Created:	11/26/2012																		*
 *	Descp:		select MtMAccount data															*
 *	Modified:																					*
 ********************************************************************************************** */
CREATE	PROCEDURE  [usp_MtMCustomDealAccountSelect]
( @CustomDealID int )
AS

BEGIN
	SET NOCOUNT ON;
	
	SELECT	*
	FROM	MtMCustomDealAccount (nolock)
	WHERE	CustomDealID = @CustomDealID
	
	SET NOCOUNT OFF;
END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Create Procedure [dbo].[usp_MtMCustomDealDelete]
Print 'Create Procedure [dbo].[usp_MtMCustomDealDelete]'
GO

/* **********************************************************************************************
 *																								*
 *	Author:		fmedeiros																		*
 *	Created:	03/05/2013																		*
 *	Descp:		created for IT051 Phase 2a														*
 *																								*
 *	Modified:																					*
 *																								*
 ********************************************************************************************** */
CREATE PROCEDURE  [dbo].[usp_MtMCustomDealDelete]
				@ID int
AS

BEGIN TRANSACTION

SET NOCOUNT ON; 

DELETE	dbo.MtMCustomDealEntry
WHERE	PricingRequest = (SELECT PricingRequest FROM dbo.MtMCustomDealHeader WHERE ID = @ID)

-- Rollback the transaction if there were any errors
IF @@ERROR <> 0
 BEGIN
    -- Rollback the transaction
    ROLLBACK

    -- Raise an error and return
    RAISERROR ('Error in deleting registers in MtMCustomDealEntry.', 16, 1)
    RETURN
 END

DELETE	dbo.MtMCustomDealAccount
WHERE	CustomDealID = @ID

-- Rollback the transaction if there were any errors
IF @@ERROR <> 0
 BEGIN
    -- Rollback the transaction
    ROLLBACK

    -- Raise an error and return
    RAISERROR ('Error in deleting accounts in MtMCustomDealAccount.', 16, 1)
    RETURN
 END

DELETE	dbo.MtMCustomDealHeader
WHERE	ID = @ID

-- Rollback the transaction if there were any errors
IF @@ERROR <> 0
 BEGIN
    -- Rollback the transaction
    ROLLBACK

    -- Raise an error and return
    RAISERROR ('Error in deleting custom deals in MtMCustomDealHeader.', 16, 1)
    RETURN
 END

SET NOCOUNT OFF; 

COMMIT
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT

SET NOEXEC OFF

