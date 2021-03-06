USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceGetById]    Script Date: 03/19/2013 10:59:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceGetById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCrossPriceGetById]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceGetById]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * usp_ProductCrossPriceGetById
 *
 * Modified 4/10/13 - Rick Deigsler
 * Added green rate field
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceGetById]  
	@ProductCrossPriceID					int
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
      ,[Price]
      ,[CreatedBy]
      ,[DateCreated]
      ,[RateCodeID]
      ,[PriceTier]
      ,[ProductBrandID]
      ,[GreenRate]
	FROM [LibertyPower].[dbo].[ProductCrossPrice] WITH (NOLOCK)
	WHERE [ProductCrossPriceID] = @ProductCrossPriceID                                                                                                                                
	
-- Copyright 2010 Liberty Power

' 
END
GO
