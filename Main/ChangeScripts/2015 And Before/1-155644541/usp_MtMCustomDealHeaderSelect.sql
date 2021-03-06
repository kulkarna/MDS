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
 *	Modified:	gmangaroo																		*
 *				7/19/2013 																		*
 *				Adde Active flag																*
 ********************************************************************************************** */
ALTER Procedure [dbo].[usp_MtMCustomDealHeaderSelect]   
( @CustomDealID int =  null
  , @PricingRequest as varchar(50) = null 
  , @ActiveOnly bit  = 0 )  
    
AS  
  
BEGIN  
 SET NOCOUNT ON;  
   
	SELECT  *  
	FROM MtMCustomDealHeader (nolock)  
	WHERE  
		((@CustomDealID IS NULL) OR (ID = @CustomDealID))  
		AND ((@PricingRequest IS NULL) OR (PricingRequest = @PricingRequest))  
		AND (@ActiveOnly = 0 OR InActive = 0  ) 
	ORDER BY DateCreated DESC
  
 SET NOCOUNT OFF;  
END 
