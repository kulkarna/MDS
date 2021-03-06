USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductCrossPriceForMultiTermSelect]    Script Date: 05/13/2013 11:24:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceForMultiTermSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductCrossPriceForMultiTermSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductCrossPriceForMultiTermSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_ProductCrossPriceForMultiTermSelect
 * Gets product cross prices that are multi-term product type for specified set ID
 *
 * History
 *******************************************************************************
 * 9/19/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductCrossPriceForMultiTermSelect]
	@ProductCrossPriceSetID	int
AS
BEGIN
    SET NOCOUNT ON;
    
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
	FROM	LibertyPower..ProductCrossPrice WITH (NOLOCK)
	WHERE	[ProductCrossPriceSetID] = @ProductCrossPriceSetID  
	AND		[ProductTypeID] = 7

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
