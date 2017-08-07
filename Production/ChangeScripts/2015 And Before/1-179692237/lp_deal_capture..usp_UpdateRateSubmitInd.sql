USE [lp_deal_capture]
GO
/****** Object:  StoredProcedure [dbo].[usp_UpdateRateSubmitInd]    Script Date: 07/25/2013 13:21:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- =============================================
-- Modify : Thiago Nogueira
-- Date : 7/25/2013 
-- Ticket: 1-179692237
-- Changed PriceID to BIGINT
-- ============================================= 
 
ALTER PROCEDURE [dbo].[usp_UpdateRateSubmitInd]     
 @PriceId bigint    
  
AS    
BEGIN    

SET NOCOUNT ON
   update deal_pricing_detail set rate_submit_ind = 1 where PriceID = @PriceId  
   
SET NOCOUNT OFF
END    

