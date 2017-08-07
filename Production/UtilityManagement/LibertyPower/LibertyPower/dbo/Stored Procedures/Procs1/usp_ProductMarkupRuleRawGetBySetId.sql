
/*******************************************************************************
 * [usp_ProductMarkupRuleRawGetBySetId]
 *
 * Modified 4/10/13 - Rick Deigsler
 * Added product brand field  
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductMarkupRuleRawGetBySetId]  
	@ProductMarkupRuleSetID				int
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
	WHERE [ProductMarkupRuleSetID] = @ProductMarkupRuleSetID                                                                                                                           
	
-- Copyright 2010 Liberty Power
