 
CREATE PROCEDURE [dbo].[usp_UpdateRateSubmitInd]     
 @PriceId int    
  
AS    
BEGIN    
   update deal_pricing_detail set rate_submit_ind = 1 where PriceID = @PriceId  
END    

