USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMGetContractDates]    Script Date: 08/12/2013 11:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************  
 *                        *  
 * Author:  fmedeiros                  *  
 * Created: 03/05/2013                  *  
 * Descp:  created for IT051 Phase 2a              *  
 *                        *  
 * Modified:                     *  
 *                        *  
 
 usp_MtMGetContractDates '123' 
 ********************************************************************************************** */  
ALTER PROCEDURE [dbo].[usp_MtMGetContractDates]    
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
join lp_common..common_product_rate  g (nolock) on f.LegacyProductID=g.product_id and f.RateID=g.rate_id     
join lp_common..common_product j (nolock) on g.product_id=j.product_id and j.IsCustom = 1    
join lp_deal_capture..deal_pricing_detail h (nolock)on g.product_id=h.product_id and g.rate_id=h.rate_id     
join lp_deal_capture..deal_pricing k (nolock) on h.deal_pricing_id=k.deal_pricing_id    
left join MtMCustomDealHeader (nolock) cd on k.pricing_request_id = cd.PricingRequest    
join MtMAccount (nolock) ma on b.AccountID = ma.AccountID and k.deal_pricing_id = ma.DealPricingID     
          and PATINDEX('%CustomDealUpload%', ma.QuoteNumber) > 0    
          and ma.ContractID is null    
where    
 e.ContractID = @ContractID    

SET NOCOUNT OFF; 

END
