USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetDealPrincingByAccountID]    Script Date: 08/12/2013 11:32:14 ******/
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
 * exec usp_GetDealPrincingByAccountID '243704'                       *  
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
