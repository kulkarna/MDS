
/*******************************************************************************
 * usp_ProductMarkupRuleGetById
 *
 * Modified 4/10/13 - Rick Deigsler
 * Added product brand field 
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductMarkupRuleGetById]  
	@ProductMarkupRuleID					int
AS
	SELECT [ProductMarkupRuleID]
	  ,[ProductMarkupRuleSetID]
	  ,[ChannelTypeID]
	  ,[ChannelGroupID]
	  ,[SegmentID]
	  ,[MarketID]
	  ,[UtilityID]
	  ,[ServiceClassID]
	  ,[ZoneID]
	  ,[ProductTypeID]
	  ,[MinTerm]
	  ,[MaxTerm]
	  ,[Rate]
	  ,[CreatedBy]
	  ,[DateCreated]
	  ,[PriceTier]
	  ,[ProductTerm]
	  ,[ProductBrandID]
	FROM [LibertyPower].[dbo].[ProductMarkupRule] WITH (NOLOCK)
	WHERE [ProductMarkupRuleID] = @ProductMarkupRuleID                                                                                                                            
	
-- Copyright 2010 Liberty Power
