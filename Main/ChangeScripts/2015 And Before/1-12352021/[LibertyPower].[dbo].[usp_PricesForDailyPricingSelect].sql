USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_PricesForDailyPricingSelect]    Script Date: 10/02/2012 01:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_PricesForDailyPricingSelect
 * Gets prices for specified sales channel and date
 *
 * History
 *******************************************************************************
 * 8/22/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_PricesForDailyPricingSelect]
	@ChannelID	int,
	@Date		datetime
AS
BEGIN
    SET NOCOUNT ON;

 DECLARE @ProductCostRuleSetupSetID int,  
   @ProductCrossPriceSetID  int  
      
 SELECT @ProductCostRuleSetupSetID = MAX(ProductCostRuleSetupSetID)  
    FROM LibertyPower..ProductCostRuleSetupSet WITH (NOLOCK)  
 WHERE UploadStatus = 2 --> 2 = Complete   
   
 SELECT @ProductCrossPriceSetID = MAX(ProductCrossPriceSetID)  
    FROM LibertyPower..Price WITH (NOLOCK)  
 WHERE ChannelID    = @ChannelID  
 AND  @Date BETWEEN CostRateEffectiveDate AND CostRateExpirationDate                                                                                                                           

if object_id('tempdb.dbo.#t1') is not null
 Drop table #t1

Select p.ID, ServiceClassDisplayName=ISNULL(cr.ServiceClassDisplayName, '')
, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID,   
   p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,  
   p.PriceTier, p.ProductBrandID, p.GrossMargin  
into #t1
FROM Libertypower..Price p WITH (NOLOCK)  
LEFT JOIN Libertypower..ProductCostRuleSetup cr WITH (NOLOCK)  
   ON p.SegmentID   = cr.Segment  
   AND p.ProductTypeID  = cr.ProductType  
   AND p.UtilityID   = cr.Utility  
   AND p.ZoneID = cr.Zone
   AND p.ServiceClassID = cr.ServiceClass 
   AND ( (p.PriceTier  = cr.PriceTier) OR ( (p.PriceTier = 0 OR p.PriceTier IS NULL) AND (cr.PriceTier = 0 OR cr.PriceTier IS NULL) ) )     
WHERE p.ChannelID      = @ChannelID  
 AND		p.ProductCrossPriceSetID  = @ProductCrossPriceSetID
 AND		(cr.ProductCostRuleSetupSetID	= @ProductCostRuleSetupSetID OR cr.ProductCostRuleSetupSetID IS NULL)
 AND @Date BETWEEN p.CostRateEffectiveDate AND p.CostRateExpirationDate


 SELECT DISTINCT p.ID, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID,   
   p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,  
   m.MarketCode, u.UtilityCode, at.AccountType AS Segment, pt.Name AS ProductTypeName, ct.Name AS ChannelType, z.zone AS ZoneCode,   
   s.service_rate_class AS ServiceClassCode, p.ServiceClassDisplayName AS ServiceClassDisplayName, p.PriceTier, p.ProductBrandID, p.GrossMargin,
   ISNULL(CAST(d.rate_submit_ind AS INT),2) AS LegacyStatus,d.ContractRate  
 FROM #t1 p WITH (NOLOCK)  
   INNER JOIN Libertypower..Market m WITH (NOLOCK) ON p.MarketID = m.ID  
   INNER JOIN Libertypower..Utility u WITH (NOLOCK) ON p.UtilityID = u.ID  
   INNER JOIN Libertypower..AccountType at WITH (NOLOCK) ON p.SegmentID = at.ID  
   INNER JOIN Libertypower..ProductType pt WITH (NOLOCK) ON p.ProductTypeID = pt.ProductTypeID  
   INNER JOIN Libertypower..ChannelType ct WITH (NOLOCK) ON p.ChannelTypeID = ct.ID  
   LEFT JOIN lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id  
   LEFT JOIN lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id  
   LEFT JOIN   lp_deal_capture..deal_pricing_detail d WITH (NOLOCK) ON p.ID = d.PriceID

/*    
    DECLARE	@ProductCostRuleSetupSetID	int,
			@ProductCrossPriceSetID		int
    
	SELECT	@ProductCostRuleSetupSetID = MAX(ProductCostRuleSetupSetID)
    FROM	LibertyPower..ProductCostRuleSetupSet WITH (NOLOCK)
	WHERE	UploadStatus = 2 --> 2 = Complete 
	
	SELECT	@ProductCrossPriceSetID = MAX(ProductCrossPriceSetID)
    FROM	LibertyPower..Price WITH (NOLOCK)
	WHERE	ChannelID				= @ChannelID
	AND		CostRateEffectiveDate	<= @Date
	AND		CostRateExpirationDate	>= @Date    	                                                                                                                       
    
	SELECT	p.ID, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID, 
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,
			m.MarketCode, u.UtilityCode, at.AccountType AS Segment, pt.Name AS ProductTypeName, ct.Name AS ChannelType, z.zone AS ZoneCode, 
			s.service_rate_class AS ServiceClassCode, ISNULL(cr.ServiceClassDisplayName, '') AS ServiceClassDisplayName, p.PriceTier, p.ProductBrandID, p.GrossMargin
	FROM	Libertypower..Price p WITH (NOLOCK)
			INNER JOIN	Libertypower..Market m WITH (NOLOCK) ON p.MarketID = m.ID
			INNER JOIN	Libertypower..Utility u WITH (NOLOCK) ON p.UtilityID = u.ID
			INNER JOIN	Libertypower..AccountType at WITH (NOLOCK) ON p.SegmentID = at.ID
			INNER JOIN	Libertypower..ProductType pt WITH (NOLOCK) ON p.ProductTypeID = pt.ProductTypeID
			INNER JOIN	Libertypower..ChannelType ct WITH (NOLOCK) ON p.ChannelTypeID = ct.ID
			LEFT JOIN	lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id
			LEFT JOIN	lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id
			LEFT JOIN	Libertypower..ProductCostRuleSetup cr WITH (NOLOCK)
			ON	p.SegmentID			= cr.Segment
			AND	p.ProductTypeID		= cr.ProductType
			AND	p.UtilityID			= cr.Utility
			AND	p.ZoneID			= cr.Zone
			AND	p.ServiceClassID	= cr.ServiceClass 
			AND p.PriceTier			= cr.PriceTier			
	WHERE	p.ChannelID						= @ChannelID
	AND		p.ProductCrossPriceSetID		= @ProductCrossPriceSetID
	AND		cr.ProductCostRuleSetupSetID	= @ProductCostRuleSetupSetID
*/
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

