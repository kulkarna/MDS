USE lp_mtm
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_MtMCustomDealSelectByRates]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_MtMCustomDealSelectByRates]
GO

/* **********************************************************************************************
 *																								*
 *	Author:		gmangaroo																		*
 *	Created:	10/15/2013																		*
 *	Descp:																						*
 ********************************************************************************************** */
 
CREATE PROCEDURE usp_MtMCustomDealSelectByRates
(	@PriceIds AS PriceIdTableType READONLY
 ,	@ActiveOnly AS bit  = 0 
 )
AS 
BEGIN 
	SET NOCOUNT ON;

	/*SELECT DISTINCT cdh.* 
	FROM @productRateIds pr 
		JOIN Lp_deal_capture..deal_pricing_detail dpd (NOLOCK) 
			ON dpd.rate_id = pr.RateId 
			and dpd.Product_id = pr.productId
		JOIN lp_mtm..MtMCustomDealEntry cde (NOLOCK) 
			ON cde.PriceID = dpd.PriceID 
			AND (@ActiveOnly = 0 OR cde.InActive = 0  ) 
		JOIN lp_mtm..MtMCustomDealHeader cdh (NOLOCK) 
			ON cdh.ID = cde.CustomDealID
			AND (@ActiveOnly = 0 OR cdh.InActive = 0  ) 
	*/
	SELECT	DISTINCT cdh.* 
	FROM	MtMCustomDealEntry cde (NOLOCK)
	JOIN	@PriceIds pr 
	ON		cde.PriceID = pr.PriceID
	AND		(@ActiveOnly = 0 OR cde.InActive = 0  ) 

	JOIN	Lp_deal_capture..deal_pricing_detail dpd (NOLOCK) 
	ON		dpd.deal_pricing_id = cde.DealPricingId
	
	JOIN	MtMCustomDealHeader cdh (NOLOCK) 
	ON		cdh.ID = cde.CustomDealID
	AND		(@ActiveOnly = 0 OR cdh.InActive = 0  ) 

	SET NOCOUNT OFF;
END 
GO 