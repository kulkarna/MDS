USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_PricesSelect]    Script Date: 10/16/2012 16:47:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_PricesSelect
 * Gets prices for specified sales channel and date
 *
 * History
 *******************************************************************************
 * 12/7/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 10/01/2012 - Jose Munoz
 * Modfify
 * Change the query to use the parameters "@UtilityID" and "@MarketID".
 *******************************************************************************
 * 10/16/2012 - Thiago Nogueira
 * Modfify
 * Added rate description
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_PricesSelect]
	@ChannelID			int
	,@Date				datetime
	,@UtilityID			INT = NULL
	,@MarketID			INT = NULL
	,@ProductTypeID		INT = NULL
	,@AccountTypeID		INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

	-- this is a temporary fix until SR 1-24199655 is completed
	-- this is to be executed for daily pricing price sheets in the evening
	-- need to omit custom prices
	IF DATEPART(hh, GETDATE()) > 18
	BEGIN
		EXEC usp_PricesForDailyPricingSelect @ChannelID, @Date
	END
	ELSE
	BEGIN
		DECLARE @ProductCostRuleSetupSetID		int,  
			@ProductCrossPriceSetID				int  

		DECLARE @T1 TABLE (ID							bigint	
							,ServiceClassDisplayName	varchar	(50)
							,ChannelID					int	
							,ChannelGroupID				int	
							,ChannelTypeID				int	
							,ProductCrossPriceSetID		int	
							,ProductTypeID				int	
							,MarketID					int	
							,UtilityID					int	
							,SegmentID					int	
							,ZoneID						int	
							,ServiceClassID				int	
							,StartDate					datetime	
							,Term						int	
							,Price						decimal	(18,10)
							,CostRateEffectiveDate		datetime	
							,CostRateExpirationDate		datetime	
							,IsTermRange				tinyint	
							,DateCreated				datetime	
							,PriceTier					tinyint	
							,ProductBrandID				int
							,GrossMargin				decimal	(18,10))
			   
			      
		SELECT @ProductCostRuleSetupSetID = MAX(ProductCostRuleSetupSetID)  
		FROM LibertyPower..ProductCostRuleSetupSet WITH (NOLOCK)  
		WHERE UploadStatus = 2 --> 2 = Complete   

		SELECT @ProductCrossPriceSetID = MAX(ProductCrossPriceSetID)  
		FROM LibertyPower..Price WITH (NOLOCK)  
		WHERE ChannelID    = @ChannelID  
		AND  @Date BETWEEN CostRateEffectiveDate AND CostRateExpirationDate                                                                                                                           

		IF NOT (@MarketID IS NULL)
		AND NOT (@UtilityID IS NULL)
			INSERT INTO @T1 
			SELECT p.ID, ServiceClassDisplayName = ISNULL(cr.ServiceClassDisplayName, '')
			, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID,   
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,  
			p.PriceTier, p.ProductBrandID, p.GrossMargin  
			FROM Libertypower..Price p WITH (NOLOCK)  
			JOIN Libertypower..ProductBrand pb WITH (NOLOCK) ON p.ProductBrandID = pb.ProductBrandID
			LEFT JOIN Libertypower..ProductCostRuleSetup cr WITH (NOLOCK)  
			ON p.SegmentID			= cr.Segment  
			AND p.ProductTypeID		= cr.ProductType  
			AND p.UtilityID			= cr.Utility  
			AND p.ZoneID			= cr.Zone
			AND p.ServiceClassID	= cr.ServiceClass 
			AND ( (p.PriceTier		= cr.PriceTier) OR ( (p.PriceTier = 0 OR p.PriceTier IS NULL) AND (cr.PriceTier = 0 OR cr.PriceTier IS NULL) ) )     
			WHERE p.ChannelID		= @ChannelID  
			AND p.MarketID			= @MarketID
			AND p.UtilityID			= @UtilityID
			AND	 (p.ProductCrossPriceSetID  = @ProductCrossPriceSetID OR p.ProductCrossPriceSetID = 0) -- custom price will have ProductCrossPriceSetID = 0
			AND	 (cr.ProductCostRuleSetupSetID	= @ProductCostRuleSetupSetID OR cr.ProductCostRuleSetupSetID IS NULL OR pb.IsCustom = 1)
			AND @Date BETWEEN p.CostRateEffectiveDate AND p.CostRateExpirationDate
		ELSE
			INSERT INTO @T1 
			SELECT p.ID, ServiceClassDisplayName = ISNULL(cr.ServiceClassDisplayName, '')
			, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID,   
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,  
			p.PriceTier, p.ProductBrandID, p.GrossMargin  
			FROM Libertypower..Price p WITH (NOLOCK)  
			JOIN Libertypower..ProductBrand pb WITH (NOLOCK) ON p.ProductBrandID = pb.ProductBrandID
			LEFT JOIN Libertypower..ProductCostRuleSetup cr WITH (NOLOCK)  
			ON p.SegmentID			= cr.Segment  
			AND p.ProductTypeID		= cr.ProductType  
			AND p.UtilityID			= cr.Utility  
			AND p.ZoneID			= cr.Zone
			AND p.ServiceClassID	= cr.ServiceClass 
			AND ( (p.PriceTier		= cr.PriceTier) OR ( (p.PriceTier = 0 OR p.PriceTier IS NULL) AND (cr.PriceTier = 0 OR cr.PriceTier IS NULL) ) )     
			WHERE p.ChannelID		= @ChannelID  
			AND	 (p.ProductCrossPriceSetID  = @ProductCrossPriceSetID OR p.ProductCrossPriceSetID = 0) -- custom price will have ProductCrossPriceSetID = 0
			AND	 (cr.ProductCostRuleSetupSetID	= @ProductCostRuleSetupSetID OR cr.ProductCostRuleSetupSetID IS NULL OR pb.IsCustom = 1)
			AND @Date BETWEEN p.CostRateEffectiveDate AND p.CostRateExpirationDate
		

		SELECT DISTINCT p.ID, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID,   
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,  
			m.MarketCode, u.UtilityCode, at.AccountType AS Segment, pt.Name AS ProductTypeName, ct.Name AS ChannelType, z.zone AS ZoneCode,   
			s.service_rate_class AS ServiceClassCode
			,case when ltrim(rtrim(p.ServiceClassDisplayName)) = '' then s.service_rate_class else p.ServiceClassDisplayName end AS ServiceClassDisplayName
			, p.PriceTier, p.ProductBrandID, p.GrossMargin  
			, ISNULL(CAST(d.rate_submit_ind AS INT),2) AS LegacyStatus, d.ContractRate, dp.account_name AS RateDescription
		FROM @T1 P 
		INNER JOIN Libertypower..Market m WITH (NOLOCK) ON p.MarketID = m.ID  
		INNER JOIN Libertypower..Utility u WITH (NOLOCK) ON p.UtilityID = u.ID  
		INNER JOIN Libertypower..AccountType at WITH (NOLOCK) ON p.SegmentID = at.ID  
		INNER JOIN Libertypower..ProductType pt WITH (NOLOCK) ON p.ProductTypeID = pt.ProductTypeID  
		INNER JOIN Libertypower..ChannelType ct WITH (NOLOCK) ON p.ChannelTypeID = ct.ID  
		LEFT JOIN lp_common..zone z WITH (NOLOCK) ON p.ZoneID = z.zone_id  
		LEFT JOIN lp_common..service_rate_class s WITH (NOLOCK) ON p.ServiceClassID = s.service_rate_class_id 
		LEFT JOIN lp_deal_capture..deal_pricing_detail d WITH (NOLOCK) ON p.ID = d.PriceID
		LEFT JOIN lp_deal_capture..deal_pricing dp WITH (NOLOCK) ON d.deal_pricing_id = dp.deal_pricing_id
		OPTION (KEEP PLAN)
	END

	SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power
