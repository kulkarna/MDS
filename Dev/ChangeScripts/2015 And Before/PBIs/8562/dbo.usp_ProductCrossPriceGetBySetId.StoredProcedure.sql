USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceGetBySetId]    Script Date: 03/19/2013 10:59:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceGetBySetId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCrossPriceGetBySetId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceGetBySetId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * usp_ProductCrossPriceGetBySetId
 *
 * Modified 4/10/13 - Rick Deigsler
 * Added green rate field 
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceGetBySetId]  
	@ProductCrossPriceSetID					int
AS

	SELECT [ProductCrossPriceID]
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
	  ,CASE WHEN MarketID = 9 AND ChannelTypeID = 1 THEN --temporary fix for NJ SUT
			([Price] * .07) + [Price]
		ELSE
			[Price]
		END AS Price
	  ,[CreatedBy]
	  ,[DateCreated]
	  ,[RateCodeID]
	  ,[PriceTier]
      ,[ProductBrandID]
      ,[GreenRate]	  
	FROM LibertyPower..ProductCrossPrice WITH (NOLOCK)
	WHERE [ProductCrossPriceSetID] = @ProductCrossPriceSetID  
                                                                                                                           
	
-- Copyright 2010 Liberty Power
' 
END
GO
