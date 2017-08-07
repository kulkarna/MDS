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
 * Author:  gmangaroo																*  
 * Created: 7/19/2013																*  
 * Descp:  Update the newly submitted custom deal with the contract id              *  
 ************************************************************************************************
 * Modified: gmangaroo 08/28/2013
 * Update both MtmAccount and MtMCustomdealId
 ************************************************************************************************
 */  
CREATE PROCEDURE [dbo].[usp_MtMCustomDealContractUpdate]    
(     
 @ContractID int    
)        
AS

BEGIN

SET NOCOUNT ON; 

	declare @rowCount int = 0 
	
	SELECT b.AccountID, e.ContractID , b.AccountNumber , k.pricing_request_id, h.PriceID 
	INTO #contractAccts
	
	FROM libertypower..Account b (NOLOCK)  
	
	JOIN libertypower..AccountContract d (NOLOCK)   
		ON  b.AccountID = d.AccountID     
	JOIN libertypower..Contract e (NOLOCK) 
		ON d.ContractID = e.ContractID    
	JOIN libertypower..vw_AccountContractRate f with (NOLOCK)   
		ON d.AccountContractID = f.AccountContractID 
	
	JOIN lp_deal_capture..deal_pricing_detail h (NOLOCK)
		ON f.PriceID = h.PriceID  
	JOIN lp_deal_capture..deal_pricing k (NOLOCK) 
		ON h.deal_pricing_id = k.deal_pricing_id    
			
	WHERE e.ContractID = @ContractID  
		
	---- Update MtmCustomDealAccount
	UPDATE cda SET cda.ContractID = ca.ContractID 
	FROM #contractAccts ca 
	
	JOIN lp_mtm..MtMCustomDealEntry (NOLOCK) cde 
		ON cde.PriceId = ca.PriceID
		AND cde.InActive = 0 
		
	JOIN lp_mtm..MtMCustomDealHeader (NOLOCK) cdh 
		ON cde.CustomDealID = cdh.ID    
		AND cdh.InActive = 0 
		
	JOIN lp_mtm..MtMCustomDealAccount cda 
		ON cda.CustomDealID = cdh.ID
		AND cda.AccountID = ca.AccountID 
		AND cda.ContractID IS NUll 
	
	Set @rowCount = @rowCount + @@ROWCOUNT
				
	-- Update MtMAccount 		
	UPDATE ma SET ma.ContractID = ca.ContractID 
	FROM #contractAccts ca 		
	
	JOIN lp_mtm..MtMCustomDealEntry (NOLOCK) cde 
		ON cde.PriceId = ca.PriceID
		AND cde.InActive = 0 
	
	JOIN lp_mtm..MtMCustomDealHeader (NOLOCK) cdh 
		ON cde.CustomDealID = cdh.ID    
		AND cdh.InActive = 0 
		
	JOIN lp_mtm..MtMAccount ma 
		ON ma.CustomDealID = cdh.ID
		AND ma.AccountID  = ca.AccountID
		AND ma.ContractID is null 
	
	Set @rowCount = @rowCount + @@ROWCOUNT
	
	
	SELECT @rowCount
	
SET NOCOUNT OFF; 
END
GO 