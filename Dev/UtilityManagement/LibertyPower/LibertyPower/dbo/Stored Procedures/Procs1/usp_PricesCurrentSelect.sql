/*******************************************************************************
 * usp_DailyPricingSalesChannelPricesCurrentSelect
 * Gets current prices for specified sales channel
 *
 * History
 *******************************************************************************
 * 12/7/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 * Modified at 11/05/2012 by Lev Rosenblum
 * Merged the production and development versions: 
 * add three input fields with null default value from development version,
 * add extra left join lp_deal_capture..deal_pricing_detail table from production version,
 * add two output fields from production and development versions,
 * replace join creterium to illiminate duplication  
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PricesCurrentSelect]
	@ChannelID	int
	, @MarketCode nvarchar(20)		=null
	, @UtilityCode nvarchar(20)		=null
	, @ProductBrandID int			=null
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ProductCostRuleSetupSetID	int,
			@ProductCrossPriceSetID	int
			
	SELECT	@ProductCostRuleSetupSetID = MAX(ProductCostRuleSetupSetID)
    FROM	LibertyPower..ProductCostRuleSetupSet WITH (NOLOCK)
	WHERE	UploadStatus = 2 --> 2 = Complete 			
    
	SELECT	@ProductCrossPriceSetID = MAX(ProductCrossPriceSetID)
    FROM	LibertyPower..ProductCrossPriceSet
	WHERE	EffectiveDate < '9999-12-31'       
    
	SELECT	p.ID, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID, 
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,
			m.MarketCode, u.UtilityCode, at.AccountType AS Segment, pt.Name AS ProductTypeName, ct.Name AS ChannelType, z.zone AS ZoneCode, 
			s.service_rate_class AS ServiceClassCode, ISNULL(cr.ServiceClassDisplayName, '') AS ServiceClassDisplayName, p.PriceTier, p.ProductBrandID, 
			p.GrossMargin, ISNULL(CAST(d.rate_submit_ind AS INT),2) AS LegacyStatus, d.ContractRate, p.ProductCrossPriceID, pb.IsMultiTerm, dp.account_name AS RateDescription
	FROM	LibertyPower..Price p WITH (NOLOCK)
			INNER JOIN	Libertypower..Market m WITH (NOLOCK) ON p.MarketID = m.ID
			INNER JOIN	Libertypower..Utility u WITH (NOLOCK) ON p.UtilityID = u.ID
			INNER JOIN	Libertypower..AccountType at WITH (NOLOCK) ON p.SegmentID = at.ID
			INNER JOIN	Libertypower..ProductType pt WITH (NOLOCK) ON p.ProductTypeID = pt.ProductTypeID					
			INNER JOIN	Libertypower..ChannelType ct WITH (NOLOCK) ON p.ChannelTypeID = ct.ID
			INNER JOIN	Libertypower..ProductBrand pb WITH (NOLOCK) ON p.ProductBrandID = pb.ProductBrandID
			LEFT JOIN	lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id
			LEFT JOIN	lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id
			LEFT JOIN   lp_deal_capture..deal_pricing_detail d WITH (NOLOCK) ON p.ID = d.PriceID
			LEFT JOIN lp_deal_capture..deal_pricing dp WITH (NOLOCK) ON d.deal_pricing_id = dp.deal_pricing_id
			LEFT JOIN	Libertypower..ProductCostRuleSetup cr WITH (NOLOCK)
			ON	p.SegmentID			= cr.Segment
			AND	p.ProductTypeID		= cr.ProductType
			AND	p.UtilityID			= cr.Utility
			-----------------------------------------------------------------------------------------------------
			------------Removed by Lev Rosenblum at 11/05/2012 due to causing duplication of records--------
			--AND (p.ZoneID = cr.Zone OR cr.Zone = -1)  
			--AND (p.ServiceClassID = cr.ServiceClass OR cr.ServiceClass = -1) 
			------------Added by Lev Rosenblum at 11/05/2012 due to illiminate the duplication of records--------
			AND (p.ZoneID = cr.Zone)  
			AND (p.ServiceClassID = cr.ServiceClass) 
			-----------------------------------------------------------------------------------------------------
			AND p.PriceTier			= cr.PriceTier		
	WHERE	p.ChannelID						= @ChannelID
	AND		(p.ProductCrossPriceSetID  = @ProductCrossPriceSetID OR (p.ProductCrossPriceSetID = 0 AND p.CostRateExpirationDate > GETDATE()))
	AND		(cr.ProductCostRuleSetupSetID	= @ProductCostRuleSetupSetID OR cr.ProductCostRuleSetupSetID IS NULL)
	
	AND		Lower(m.MarketCode)=CASE WHEN @MarketCode is null THEN Lower(m.MarketCode) ELSE @MarketCode END
	AND		Lower(u.UtilityCode)=CASE WHEN @UtilityCode is null THEN Lower(u.UtilityCode) ELSE @UtilityCode END
	AND		pb.ProductBrandID=CASE WHEN @ProductBrandID is null THEN pb.ProductBrandID ELSE @ProductBrandID END
    SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
