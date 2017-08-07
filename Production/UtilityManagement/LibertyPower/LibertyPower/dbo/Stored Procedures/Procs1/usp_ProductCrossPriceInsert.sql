
/*******************************************************************************
 * usp_ProductCrossPriceInsert
 *
 * Modified 4/10/13 - Rick Deigsler
 * Added green rate field 
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceInsert]  
	@ProductCrossPriceSetID 	int,
	@ProductMarkupRuleID		int,
	@ProductCostRuleID			int,
	@ProductTypeID					int,
	@MarketID					int,
	@UtilityID					int,
	@SegmentID					int,
	@ZoneID						int,
	@ServiceClassID				int,
	@ChannelTypeID				int,
	@ChannelGroupID				int,
	@CostRateEffectiveDate		datetime,
	@StartDate					datetime,
	@Term						int,
	@CostRateExpirationDate		datetime,
	@MarkupRate					decimal(18,10),
	@CostRate					decimal(18,10),
	@CommissionsRate			decimal(18,10),
	@POR						decimal(18,10),
	@GRT						decimal(18,10),
	@SUT						decimal(18,10),
	@Price						decimal(18,10),
	@CreatedBy					int,
	@RateCodeID					int,
	@PriceTier					tinyint,
	@ProductBrandID				int				= 0,
	@GreenRate					decimal(18,10)	= 0
AS
DECLARE @ProductCrossPriceID int

INSERT INTO [LibertyPower].[dbo].[ProductCrossPrice]
           ([ProductCrossPriceSetID]
           ,[ProductMarkupRuleID]
           ,[ProductCostRuleID]
           ,[ProductTypeID]
           ,[MarketID]
           ,[UtilityID]
           ,[SegmentID]
           ,[ZoneID]
           ,[ServiceClassID]
		   ,[ChannelTypeID]
		   ,[ChannelGroupID]
           ,[CostRateEffectiveDate]
           ,[StartDate]
           ,[Term]
           ,[CostRateExpirationDate]
           ,[MarkupRate]
           ,[CostRate]
           ,[CommissionsRate]
           ,[POR]
           ,[GRT]
           ,[SUT]
           ,[Price]
           ,[CreatedBy]
           ,[DateCreated]
           ,[RateCodeID]
           ,[PriceTier]
		   ,[ProductBrandID]
		   ,[GreenRate])
     VALUES
           (
			@ProductCrossPriceSetID 
			,@ProductMarkupRuleID	
			,@ProductCostRuleID	
			,@ProductTypeID		
			,@MarketID		
			,@UtilityID	
			,@SegmentID	
			,@ZoneID			
			,@ServiceClassID
		    ,@ChannelTypeID
		    ,@ChannelGroupID		
			,@CostRateEffectiveDate	
			,@StartDate		
			,@Term			
			,@CostRateExpirationDate	
			,@MarkupRate		
			,@CostRate		
			,@CommissionsRate	
			,@POR			
			,@GRT
			,@SUT			
			,@Price			
			,@CreatedBy
			,getDate()
			,@RateCodeID
			,@PriceTier
			,@ProductBrandID
			,@GreenRate
			)

SET @ProductCrossPriceID = SCOPE_IDENTITY()

SELECT	[ProductCrossPriceID]
		,[ProductCrossPriceSetID]
		,[ProductMarkupRuleID]
		,[ProductCostRuleID]
		,[ProductTypeID]
		,[MarketID]
		,[UtilityID]
		,[SegmentID]
		,[ZoneID]
		,[ServiceClassID]
		,[ChannelTypeID]
		,[ChannelGroupID]
		,[CostRateEffectiveDate]
		,[StartDate]
		,[Term]
		,[CostRateExpirationDate]
		,[MarkupRate]
		,[CostRate]
		,[CommissionsRate]
		,[POR]
		,[GRT]
		,[SUT]
		,[Price]
		,[CreatedBy]
		,[DateCreated]
		,[RateCodeID]
		,[PriceTier]
		,[ProductBrandID]
		,[GreenRate]      
FROM	[LibertyPower].[dbo].[ProductCrossPrice] WITH (NOLOCK)
WHERE	[ProductCrossPriceID] = @ProductCrossPriceID                                                                                                                                
	
-- Copyright 2010 Liberty Power

