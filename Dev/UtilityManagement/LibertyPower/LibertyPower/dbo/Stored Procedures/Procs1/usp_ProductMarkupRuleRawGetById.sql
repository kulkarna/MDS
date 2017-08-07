
/*******************************************************************************
 * [usp_ProductMarkupRuleRawGetById]
 *
 * Modified 4/10/13 - Rick Deigsler
 * Added product brand field  
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductMarkupRuleRawGetById]  
	@ProductMarkupRuleRawID					int
AS
	SELECT  [ProductMarkupRuleRawID]
      ,[ProductMarkupRuleSetID]
      ,[ChannelType]
      ,[MarketCode]
      ,[UtilityCode]
      ,[ChannelGroup]
      ,[Segment]
      ,[Product]
      ,[Zone]
      ,[UtilityServiceClass]
      ,[minTerm]
      ,[maxTerm]
      ,[Rate]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[PriceTier]
      ,[ProductTerm]
      ,[ProductBrandID]
	FROM [LibertyPower].[dbo].[ProductMarkupRuleRaw] WITH (NOLOCK)
	WHERE [ProductMarkupRuleRawID] = @ProductMarkupRuleRawID                                                                                                                           
	
-- Copyright 2010 Liberty Power
