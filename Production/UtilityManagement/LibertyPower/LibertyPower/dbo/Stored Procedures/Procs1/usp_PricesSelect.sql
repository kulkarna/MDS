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
 * 10/29/2012 - Lev Rosenblum
 * Modfify
 * Add productBrandID as input parameter with null default value. Add filters in select statement if 
 * any of following parameters @UtilityID,@MarketID,@ProductTypeID,@AccountTypeID,@ProductBrandID is not null
 *******************************************************************************
 * 11/2/2012 - Rick Deigsler
 * Modified
 * Added @ProductBrandID and @AccountTypeID parameters
 *******************************************************************************
 * 11/19/2012 - Rick Deigsler
 * Modified
 * Merged with production
 *******************************************************************************
 * 11/21/2012 - Lev Rosenblum
 * add with (nolock) statement
 *******************************************************************************
  
 */
CREATE PROCEDURE [dbo].[usp_PricesSelect]
	@ChannelID				int
	,@Date					datetime
	,@ProductAccountTypeID	INT = NULL
	,@UtilityID				INT = NULL
	,@MarketID				INT = NULL
	,@AccountTypeID			INT = NULL
	,@ProductBrandID		INT = NULL
	,@ProductTypeID			INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

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
							,GrossMargin				decimal	(18,10)
							,ProductCrossPriceID		int
							,IsMultiTerm				bit
							,IsCustom					bit
							)
			   
			      
		SELECT @ProductCostRuleSetupSetID = MAX(ProductCostRuleSetupSetID)  
		FROM LibertyPower..ProductCostRuleSetupSet WITH (NOLOCK)  
		WHERE UploadStatus = 2 --> 2 = Complete   

		SELECT @ProductCrossPriceSetID = MAX(ProductCrossPriceSetID)  
		FROM LibertyPower..Price WITH (NOLOCK)  
		WHERE ChannelID    = @ChannelID  
		AND  @Date BETWEEN CostRateEffectiveDate AND CostRateExpirationDate   
		
		-- convert account type id to libertypower..accounttype
		IF @ProductAccountTypeID IS NOT NULL
		BEGIN
			SELECT @AccountTypeID = ID 
			FROM Libertypower..AccountType with (nolock)
			WHERE ProductAccountTypeID = @ProductAccountTypeID       
		END  		                                                                                                                        

		IF NOT (@MarketID IS NULL) AND NOT (@UtilityID IS NULL) AND NOT (@ProductBrandID IS NULL) AND NOT (@AccountTypeID IS NULL)
		BEGIN
			INSERT INTO @T1 
			SELECT p.ID, ServiceClassDisplayName = ISNULL(cr.ServiceClassDisplayName, '')
			, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID,   
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,  
			p.PriceTier, p.ProductBrandID, p.GrossMargin, p.ProductCrossPriceID, pb.IsMultiTerm, pb.IsCustom   
			FROM Libertypower..Price p WITH (NOLOCK)  
			JOIN Libertypower..ProductBrand pb WITH (NOLOCK) ON p.ProductBrandID = pb.ProductBrandID
			LEFT JOIN Libertypower..ProductCostRuleSetup cr WITH (NOLOCK)  
			ON p.SegmentID			= cr.Segment  
			AND p.ProductTypeID		= cr.ProductType  
			AND p.UtilityID			= cr.Utility  
			AND p.ZoneID			= cr.Zone
			AND p.ServiceClassID	= cr.ServiceClass 
			AND ( (p.PriceTier		= cr.PriceTier) OR ( (p.PriceTier = 0 OR p.PriceTier IS NULL) AND (cr.PriceTier = 0 OR cr.PriceTier IS NULL) ) )     
			AND	 (cr.ProductCostRuleSetupSetID	= @ProductCostRuleSetupSetID OR cr.ProductCostRuleSetupSetID IS NULL OR pb.IsCustom = 1)
			WHERE p.ChannelID		= @ChannelID  
			AND @Date BETWEEN p.CostRateEffectiveDate AND p.CostRateExpirationDate
			AND	(p.ProductCrossPriceSetID  = @ProductCrossPriceSetID OR p.ProductCrossPriceSetID = 0) -- custom price will have ProductCrossPriceSetID = 0
			
			AND p.MarketID			= @MarketID
			AND p.UtilityID			= @UtilityID
			AND p.ProductBrandID	= @ProductBrandID 
			AND p.SegmentID			= @AccountTypeID 
			AND	p.ProductTypeID=CASE WHEN @ProductTypeID is NULL Then p.ProductTypeID ELSE @ProductTypeID  END
			
		END
		ELSE
		BEGIN
			INSERT INTO @T1 
			SELECT p.ID, ServiceClassDisplayName = ISNULL(cr.ServiceClassDisplayName, '')
			, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID,   
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,  
			p.PriceTier, p.ProductBrandID, p.GrossMargin, p.ProductCrossPriceID, pb.IsMultiTerm, pb.IsCustom 
			FROM Libertypower..Price p WITH (NOLOCK)  
			JOIN Libertypower..ProductBrand pb WITH (NOLOCK) ON p.ProductBrandID = pb.ProductBrandID
			LEFT JOIN Libertypower..ProductCostRuleSetup cr WITH (NOLOCK)  
			ON p.SegmentID			= cr.Segment  
			AND p.ProductTypeID		= cr.ProductType  
			AND p.UtilityID			= cr.Utility  
			AND p.ZoneID			= cr.Zone
			AND p.ServiceClassID	= cr.ServiceClass 
			AND ( (p.PriceTier		= cr.PriceTier) OR ( (p.PriceTier = 0 OR p.PriceTier IS NULL) AND (cr.PriceTier = 0 OR cr.PriceTier IS NULL) ) )     
			AND	 (cr.ProductCostRuleSetupSetID	= @ProductCostRuleSetupSetID OR cr.ProductCostRuleSetupSetID IS NULL OR pb.IsCustom = 1)
			WHERE p.ChannelID		= @ChannelID  
			AND	 (p.ProductCrossPriceSetID  = @ProductCrossPriceSetID OR p.ProductCrossPriceSetID = 0) -- custom price will have ProductCrossPriceSetID = 0
			AND @Date BETWEEN p.CostRateEffectiveDate AND p.CostRateExpirationDate
			
			AND p.MarketID			= CASE WHEN @MarketID is NULL THEN  p.MarketID ELSE @MarketID END
			AND p.UtilityID			= CASE WHEN @UtilityID is NULL THEN  p.UtilityID ELSE @UtilityID END
			AND p.ProductBrandID	= CASE WHEN @ProductBrandID is NULL THEN p.ProductBrandID ELSE @ProductBrandID END
			AND p.SegmentID			= CASE WHEN @AccountTypeID is NULL THEN  p.SegmentID ELSE @AccountTypeID END
			AND p.ProductTypeID		= CASE WHEN @ProductTypeID is NULL Then p.ProductTypeID ELSE @ProductTypeID  END
		END
			--------------------------------------------------
		SELECT DISTINCT p.ID, p.ChannelID, p.ChannelGroupID, p.ChannelTypeID, p.ProductCrossPriceSetID, p.ProductTypeID, p.MarketID, p.UtilityID, p.SegmentID, p.ZoneID,   
			p.ServiceClassID, p.StartDate, p.Term, p.Price, p.CostRateEffectiveDate, p.CostRateExpirationDate, p.IsTermRange, p.DateCreated,  
			m.MarketCode, u.UtilityCode, at.AccountType AS Segment, pt.Name AS ProductTypeName, ct.Name AS ChannelType, z.zone AS ZoneCode,   
			s.service_rate_class AS ServiceClassCode
			,case when ltrim(rtrim(p.ServiceClassDisplayName)) = '' then s.service_rate_class else p.ServiceClassDisplayName end AS ServiceClassDisplayName
			, p.PriceTier, p.ProductBrandID, p.GrossMargin  
			, ISNULL(CAST(d.rate_submit_ind AS INT),2) AS LegacyStatus, d.ContractRate
			, p.ProductCrossPriceID, p.IsMultiTerm, dp.account_name AS RateDescription  
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
		WHERE (p.IsCustom = 0 OR d.rate_submit_ind = 0)
		OPTION (KEEP PLAN)
	END

	SET NOCOUNT OFF;
-- Copyright 2011 Liberty Power
