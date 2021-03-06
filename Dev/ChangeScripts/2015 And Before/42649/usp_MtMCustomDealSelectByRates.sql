USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMCustomDealSelectByRates]    Script Date: 06/26/2014 19:19:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************
 *																								*
 *	Author:		gmangaroo																		*
 *	Created:	10/15/2013																		*
 *	Descp:																						*
 ************************************************************************************************
 *	Modified:  6/26/2014
			   by gMANGAROO: Get the custom deals by looking up the rate in the table 
			   deal_pricing_detail table and in the table MtMCustomDealEntry
 ********************************************************************************************** */
 
ALTER PROCEDURE [dbo].[usp_MtMCustomDealSelectByRates]
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
	CREATE TABLE #CustomDealIDs (ID int)
	
	-- Get Custom Deal ids directly from lp_deal_capture..deal_pricing
	-- ======================================================================
	INSERT INTO #CustomDealIDs
	SELECT  DISTINCT d.CustomDealID
	FROM lp_deal_capture..deal_pricing_detail dpd (NOLOCK)
	JOIN	@PriceIds pr 
	ON		dpd.PriceID = pr.PriceID
	JOIN lp_deal_capture..deal_pricing d (NOLOCK)
	ON	 d.deal_pricing_id = dpd.deal_pricing_id
	WHERE d.CustomDealID IS NOT NULL 
	
	-- Get Custom Deal ids from lp_MtM..CustomDealEntry 
	-- ========================================================================
	INSERT INTO #CustomDealIDs
	SELECT	DISTINCT cde.CustomDealID
	FROM	MtMCustomDealEntry cde (NOLOCK)
	JOIN	@PriceIds pr 
	ON		cde.PriceID = pr.PriceID
	AND		(@ActiveOnly = 0 OR cde.InActive = 0  ) 

	JOIN	Lp_deal_capture..deal_pricing_detail dpd (NOLOCK) 
	ON		dpd.deal_pricing_id = cde.DealPricingId
	
	-- GET CustomDeal records 
	-- ==========================================================================
	SELECT DISTINCT cdh.*
	FROM	MtMCustomDealHeader cdh (NOLOCK) 
	JOIN	#CustomDealIDs cdi 
	ON		cdi.ID = cdh.ID
	AND		(@ActiveOnly = 0 OR cdh.InActive = 0  ) 

	SET NOCOUNT OFF;
END 
