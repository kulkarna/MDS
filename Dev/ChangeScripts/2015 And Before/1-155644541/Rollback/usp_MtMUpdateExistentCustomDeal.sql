USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMUpdateExistentCustomDeal]    Script Date: 08/12/2013 11:37:03 ******/
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
 *	Modified:																					*
 * exec [usp_MtMUpdateExistentCustomDeal] 467798															*
 ********************************************************************************************** */
ALTER PROCEDURE [dbo].[usp_MtMUpdateExistentCustomDeal]  
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
  join lp_common..common_product_rate g (nolock) on f.LegacyProductID=g.product_id and f.RateID=g.rate_id   
  join lp_common..common_product j (nolock) on g.product_id=j.product_id   
  join lp_deal_capture..deal_pricing_detail h (nolock) on g.product_id=h.product_id and g.rate_id=h.rate_id   
  join lp_deal_capture..deal_pricing k (nolock) on h.deal_pricing_id=k.deal_pricing_id  
  join MtMCustomDealHeader (nolock) cd on k.pricing_request_id = cd.PricingRequest   
           and cd.ContractStartDate = f.RateStart   
           and DATEADD(d, -1, DATEADD(m, cd.Term, cd.ContractStartDate)) = f.RateEnd  
  join MtMAccount (nolock) ma on b.AccountID = ma.AccountID and k.deal_pricing_id = ma.DealPricingID   
          and PATINDEX('%CustomDealUpload%', ma.QuoteNumber) > 0  
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
