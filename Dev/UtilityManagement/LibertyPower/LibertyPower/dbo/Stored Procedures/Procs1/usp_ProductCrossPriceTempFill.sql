
/*******************************************************************************
 * usp_ProductCrossPriceTempFill
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceTempFill]  

AS

--	write to log
EXEC usp_DailyPricingLogInsert_New 3, 6, 'Pricing sheet prices: Begin price loading.', NULL, 0	

-- drop and create temp table
EXEC usp_DailyPricingRecreateProductCrossPriceTempTable

INSERT INTO Libertypower..DailyPricingProductCrossPriceTemp
           (ProductCrossPriceSetID
           ,ProductMarkupRuleID
           ,ProductCostRuleID
           ,ProductTypeID
           ,MarketID
           ,UtilityID
           ,SegmentID
           ,ZoneID
           ,ServiceClassID
           ,ChannelTypeID
           ,ChannelGroupID
           ,CostRateEffectiveDate
           ,StartDate
           ,Term
           ,CostRateExpirationDate
           ,MarkupRate
           ,CostRate
           ,CommissionsRate
           ,POR
           ,GRT
           ,SUT
           ,Price
           ,CreatedBy
           ,DateCreated
           ,RateCodeID)
           
	SELECT ProductCrossPriceSetID
      ,ProductMarkupRuleID
      ,ProductCostRuleID
      ,ProductTypeID
      ,MarketID
      ,UtilityID
      ,SegmentID
      ,ZoneID
      ,ServiceClassID
      ,ChannelTypeID
      ,ChannelGroupID
      ,CostRateEffectiveDate
      ,StartDate
      ,Term
      ,CostRateExpirationDate
      ,MarkupRate
      ,CostRate
      ,CommissionsRate
      ,POR
	  ,GRT
      ,SUT
      ,Price
      ,CreatedBy
      ,DateCreated
      ,RateCodeID
	FROM LibertyPower..ProductCrossPrice WITH (NOLOCK)
	WHERE ProductCrossPriceSetID = (	SELECT	ProductCrossPriceSetID
										FROM	LibertyPower..ProductCrossPriceSet WITH (NOLOCK)
										WHERE	EffectiveDate = (	SELECT	MAX(EffectiveDate)
																	FROM	LibertyPower..ProductCrossPriceSet  WITH (NOLOCK)
																	WHERE	EffectiveDate <= GETDATE()  
																) 
									)
	
-- create index to speed up searches	
EXEC usp_DailyPricingCreatePricingProductCrossIndex	

--	write to log
EXEC usp_DailyPricingLogInsert_New 3, 6, 'Pricing sheet prices: Price loading completed.', NULL, 0		                                                                                                                           
	
-- Copyright 2010 Liberty Power

