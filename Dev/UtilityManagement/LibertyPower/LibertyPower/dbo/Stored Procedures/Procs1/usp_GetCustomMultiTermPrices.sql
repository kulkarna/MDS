-- =============================================
-- Author:		<Lev Rosenblum
-- Create date: <2/17/2013,>
-- Description:	<usp_Get Custom Multi Term Prices>
-- =============================================
CREATE PROCEDURE dbo.usp_GetCustomMultiTermPrices
	@ChannelID				INT
	,@ContractSignDate		DateTime
	,@MarketID				INT
	,@UtilityID				INT
	,@ProductBrandID		INT
	,@AccountTypeID			INT 

AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
	p.ID, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID
	, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID, p.ServiceClassID, p.StartDate, p.Term
	, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated
	, p.PriceTier, p.ProductBrandID, p.GrossMargin, p.ProductCrossPriceID  
	, m.MarketCode, u.UtilityCode, at.AccountType AS Segment, pt.Name AS ProductTypeName
	, ct.Name AS ChannelType, z.zone AS ZoneCode, pb.IsMultiTerm, dp.account_name AS RateDescription 
	, s.service_rate_class AS ServiceClassCode, s.service_rate_class  AS ServiceClassDisplayName
	, ISNULL(CAST(dpd.rate_submit_ind AS INT),2) AS LegacyStatus, dpd.ContractRate	   
	FROM Libertypower..Price p WITH (NOLOCK) 
		INNER JOIN Libertypower..ChannelType ct WITH (NOLOCK) ON p.ChannelTypeID = ct.ID   
		INNER JOIN Libertypower..Market m WITH (NOLOCK) ON p.MarketID = m.ID  
		INNER JOIN Libertypower..Utility u WITH (NOLOCK) ON p.UtilityID = u.ID  
		INNER JOIN Libertypower..AccountType at WITH (NOLOCK) ON p.SegmentID = at.ID  
		INNER JOIN Libertypower..ProductBrand pb WITH (NOLOCK) ON p.ProductBrandID = pb.ProductBrandID
		INNER JOIN Libertypower..ProductType pt WITH (NOLOCK) ON pt.ProductTypeID = pb.ProductTypeID
		LEFT JOIN lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id  
		LEFT JOIN lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id 
		LEFT JOIN lp_deal_capture..deal_pricing_detail dpd WITH (NOLOCK) ON p.ID = dpd.PriceID
		LEFT JOIN lp_deal_capture..deal_pricing dp WITH (NOLOCK) ON dpd.deal_pricing_id = dp.deal_pricing_id
	WHERE p.ChannelID		= @ChannelID  
	AND p.CostRateEffectiveDate =@ContractSignDate 
	AND p.MarketID			= @MarketID
	AND p.UtilityID			= @UtilityID
	AND p.ProductBrandID	= @ProductBrandID 
	AND p.SegmentID			= @AccountTypeID 
	AND pb.IsCustom = 1 
	AND	p.ProductCrossPriceSetID = 0
	AND dpd.rate_submit_ind = 0
END
