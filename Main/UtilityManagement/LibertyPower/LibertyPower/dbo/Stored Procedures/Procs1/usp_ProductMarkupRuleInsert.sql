
/*******************************************************************************
 * usp_ProductMarkupRuleInsert
 *
 * Modified 4/10/13 - Rick Deigsler
 * Added product brand field  
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductMarkupRuleInsert]  
	@ProductMarkupRuleSetID int
	,@ChannelTypeID			int
	,@ChannelGroupID		int
	,@SegmentID				int
	,@MarketID				int
	,@UtilityID				int
	,@ServiceClassID		int
	,@ZoneID				int
	,@ProductTypeID			int
	,@MinTerm				int
	,@MaxTerm				int
	,@Rate					decimal(18,10)
	,@CreatedBy				int
	,@PriceTier				tinyint
	,@ProductTerm			int				= NULL
	,@ProductBrandID		int				= -1
AS

INSERT INTO [LibertyPower].[dbo].[ProductMarkupRule]
           ([ProductMarkupRuleSetID]
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
			,[ProductBrandID])
     VALUES
           (@ProductMarkupRuleSetID
			,@ChannelTypeID
			,@ChannelGroupID
			,@SegmentID		
			,@MarketID		
			,@UtilityID		
			,@ServiceClassID	
			,@ZoneID		
			,@ProductTypeID		
			,@MinTerm
			,@MaxTerm
			,@Rate	
			,@CreatedBy		
			,getDate()
			,@PriceTier
			,@ProductTerm
			,@ProductBrandID)

SELECT	SCOPE_IDENTITY() AS ProductMarkupRuleID                                                                                                                        
	
-- Copyright 2010 Liberty Power
