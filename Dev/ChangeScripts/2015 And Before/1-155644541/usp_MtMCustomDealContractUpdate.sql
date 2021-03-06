USE [lp_mtm]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MtMCustomDealContractUpdate]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MtMCustomDealContractUpdate]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************  
 * Author:  gmangaroo                  *  
 * Created: 7/19/2013                  *  
 * Descp:  Update the newly submitted custom deal with the contract id              *  
 ********************************************************************************************** */  
CREATE PROCEDURE [dbo].[usp_MtMCustomDealContractUpdate]    
(     
 @ContractID int    
)        
AS

BEGIN

SET NOCOUNT ON; 

	UPDATE ma SET ContractID = @ContractID 
	FROM libertypower..Account b (NOLOCK)  
	
	JOIN libertypower..AccountContract d (NOLOCK)   
		ON  b.AccountID = d.AccountID     
	JOIN libertypower..Contract e (NOLOCK) 
		ON d.ContractID = e.ContractID    
	JOIN libertypower..vw_AccountContractRate f with (NOLOCK)   
		ON d.AccountContractID = f.AccountContractID --and f.IsContractedRate = 1    
	JOIN lp_common..common_product_rate  g (NOLOCK) 
		ON f.LegacyProductID = g.product_id 
			AND f.RateID = g.rate_id     
	JOIN lp_common..common_product j (NOLOCK) 
		ON g.product_id = j.product_id 
			AND j.IsCustom = 1    
	JOIN lp_deal_capture..deal_pricing_detail h (NOLOCK)
		ON g.product_id = h.product_id 
			AND g.rate_id = h.rate_id     
	JOIN lp_deal_capture..deal_pricing k (NOLOCK) 
		ON h.deal_pricing_id = k.deal_pricing_id    
	LEFT JOIN MtMCustomDealHeader (NOLOCK) cd 
		ON k.pricing_request_id = cd.PricingRequest    
		AND cd.InActive = 0 
	JOIN MtMAccount (NOLOCK) ma 
		ON b.AccountID = ma.AccountID 
		AND ma.CustomDealID = cd.ID
		AND f.RateStart = cd.ContractStartDate
		AND f.RateEnd = DATEADD(d, -1, DATEADD(m, cd.Term, cd.ContractStartDate)) 

	WHERE    
		 e.ContractID = @ContractID    
		AND ma.ContractID is null 

	RETURN @@ROWCOUNT
	
SET NOCOUNT OFF; 

END
