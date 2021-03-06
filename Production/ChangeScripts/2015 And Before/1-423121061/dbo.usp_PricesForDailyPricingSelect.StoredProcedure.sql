USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_PricesForDailyPricingSelect]    Script Date: 02/19/2014 15:13:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PricesForDailyPricingSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_PricesForDailyPricingSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_PricesForDailyPricingSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

/*******************************************************************************
 * usp_PricesForDailyPricingSelect
 * Gets prices for specified sales channel and date
 *
 * History
 *******************************************************************************
 * 8/22/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 10/16/2012 - Thiago Nogueira
 * Modfify
 * Added rate description
 *******************************************************************************
  * 10/22/2013 - Rick Deigsler
 * Modified
 * Added where clause in price selection to prevent any price greater than 2015 from being pulled
 *******************************************************************************
 * 10/23/2013 - Alberto Franco
 * Modified
 * Changed the previous update from 20160101 to 20161101
 *******************************************************************************
 * 12/06/2013 - Rick Deigsler
 * Modified
 * Changed the previous update from 20161101 to 20170201
 *******************************************************************************
 * 12/13/2013 - Alberto Franco
 * Modified
 * Changed the previous update from 20170201 to 20200101 (requested with 
 * reference date 12/1/2019 from Ted who agreed on the pattern during Rick''s 
 * absence)
 *******************************************************************************
 * 12/18/2013 - Rick Deigsler
 * Modified
 * 1-337764761 - Commented out date restriction
 * (Did not remove in case of future restrictions)
 *******************************************************************************
 * 2/19/2014 - Rick Deigsler
 * Modified
 * 1-423121061 - Modified last select statement to satisfy
 * requirements of ticket (66 months out from prompt month)
 *
 * Prompt month is defined as:
 * IF CURRENT DATE > (LAST DAY OF CURRENT MONTH - 3) 
 * THEN CURRENT MONTH + 2 Month
 * ELSE CURRENT MONTH + 1 Month
 *******************************************************************************
 
 exec [usp_PricesForDailyPricingSelect] 27, ''20120910''
 */
CREATE PROCEDURE [dbo].[usp_PricesForDailyPricingSelect]
	@ChannelID	int,
	@Date		datetime
AS
BEGIN
    SET NOCOUNT ON;

	 DECLARE	@ProductCostRuleSetupSetID	int,  
				@ProductCrossPriceSetID		int,
				@MonthEndDate				datetime,
				@Today						datetime,
				@MonthsForward				int
				
	SET			@Today			= GETDATE()
	EXEC		@MonthEndDate	= lp_account.dbo.get_month_end @Today
	SET			@MonthsForward	= CASE WHEN @Today > DATEADD (dd, -3, @MonthEndDate ) THEN 68 ELSE 67 END
	      
	SELECT	@ProductCostRuleSetupSetID = MAX(ProductCostRuleSetupSetID)  
	FROM	LibertyPower..ProductCostRuleSetupSet WITH (NOLOCK)  
	WHERE	UploadStatus = 2 --> 2 = Complete   
	   
	SELECT	@ProductCrossPriceSetID = MAX(ProductCrossPriceSetID)  
	FROM	LibertyPower..Price WITH (NOLOCK)  
	WHERE	ChannelID    = @ChannelID  
	AND		@Date BETWEEN CostRateEffectiveDate AND CostRateExpirationDate    
	 	                                                                                                                        
	IF object_id(''tempdb.dbo.#t1'') IS NOT NULL
		DROP TABLE #t1

	SELECT	p.ID, ServiceClassDisplayName=ISNULL(cr.ServiceClassDisplayName, '''')
			, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID,   
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,  
			p.PriceTier, p.ProductBrandID, p.GrossMargin, p.ProductCrossPriceID
	INTO	#t1
	FROM	Libertypower..Price p WITH (NOLOCK)  
	LEFT JOIN Libertypower..ProductCostRuleSetup cr WITH (NOLOCK)  
		ON p.SegmentID   = cr.Segment  
		AND p.ProductTypeID  = cr.ProductType  
		AND p.UtilityID   = cr.Utility  
		AND p.ZoneID = cr.Zone
		AND p.ServiceClassID = cr.ServiceClass 
		AND ( (p.PriceTier  = cr.PriceTier) OR ( (p.PriceTier = 0 OR p.PriceTier IS NULL) AND (cr.PriceTier = 0 OR cr.PriceTier IS NULL) ) )     
	WHERE	p.ChannelID      = @ChannelID  
	AND		p.ProductCrossPriceSetID  = @ProductCrossPriceSetID
	AND		(cr.ProductCostRuleSetupSetID	= @ProductCostRuleSetupSetID OR cr.ProductCostRuleSetupSetID IS NULL)
	AND		@Date BETWEEN p.CostRateEffectiveDate AND p.CostRateExpirationDate


	SELECT	DISTINCT p.ID, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID,   
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,  
			m.MarketCode, u.UtilityCode, at.AccountType AS Segment, pt.Name AS ProductTypeName, ct.Name AS ChannelType, z.zone AS ZoneCode,   
			s.service_rate_class AS ServiceClassCode, case when ltrim(rtrim(p.ServiceClassDisplayName)) = '''' then s.service_rate_class else p.ServiceClassDisplayName end AS ServiceClassDisplayName
			, p.PriceTier, p.ProductBrandID, p.GrossMargin, 
			p.ProductCrossPriceID, ISNULL(cp.ProductConfigurationID, 0) AS ProductConfigurationID
			, ISNULL(CAST(d.rate_submit_ind AS INT),2) AS LegacyStatus, d.ContractRate, dp.account_name AS RateDescription
	FROM	#t1 p WITH (NOLOCK)  
	INNER JOIN Libertypower..Market m WITH (NOLOCK) ON p.MarketID = m.ID  
	INNER JOIN Libertypower..Utility u WITH (NOLOCK) ON p.UtilityID = u.ID  
	INNER JOIN Libertypower..AccountType at WITH (NOLOCK) ON p.SegmentID = at.ID  
	INNER JOIN Libertypower..ProductType pt WITH (NOLOCK) ON p.ProductTypeID = pt.ProductTypeID  
	INNER JOIN Libertypower..ChannelType ct WITH (NOLOCK) ON p.ChannelTypeID = ct.ID  
	LEFT JOIN lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id  
	LEFT JOIN lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id  
	LEFT JOIN Libertypower..ProductConfigurationPrices cp WITH (NOLOCK) ON p.ID = cp.PriceID
	LEFT JOIN lp_deal_capture..deal_pricing_detail d WITH (NOLOCK) ON p.ID = d.PriceID
	LEFT JOIN lp_deal_capture..deal_pricing dp WITH (NOLOCK) ON d.deal_pricing_id = dp.deal_pricing_id
	-- 1-423121061
	WHERE	DATEADD (mm , p.Term , p.StartDate ) <= DATEADD (mm, @MonthsForward, GETDATE() ) -- added for price limits

    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power


' 
END
GO
