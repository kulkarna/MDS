USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_DailyPricingMaxRelativeStartMonthSelect]    Script Date: 07/02/2013 08:36:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DailyPricingMaxRelativeStartMonthSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_DailyPricingMaxRelativeStartMonthSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_DailyPricingMaxRelativeStartMonthSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_DailyPricingMaxRelativeStartMonthSelect
 * Gets max relative start month for specified parameters
 *
 * History
 *******************************************************************************
 * 7/7/2010 - Rick Deigsler
 * Created.
 *
 * Modified 7/2/2013 - Rick Deigsler
 * Added default value
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingMaxRelativeStartMonthSelect]
	@MarketID		int,
	@UtilityID		int,
	@ZoneID			int,
	@ServiceClassID	int,
	@SegmentID		int,
	@ProductTypeID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ProductCostRuleSetupSetID	int,
			@MaxRelativeStartMonth		int
    
	SELECT	TOP 1 @ProductCostRuleSetupSetID = ProductCostRuleSetupSetID
    FROM	ProductCostRuleSetupSet WITH (NOLOCK)
	WHERE	UploadStatus = 2        --> 2 = Complete                                                                                                                      
	ORDER BY UploadedDate DESC  

	SELECT	DISTINCT @MaxRelativeStartMonth = MaxRelativeStartMonth
	FROM	ProductCostRuleSetup WITH (NOLOCK)
	WHERE	Market						= @MarketID
	AND		Utility						= @UtilityID
	AND		Zone						= @ZoneID
	AND		ServiceClass				= @ServiceClassID
	AND		Segment						= @SegmentID
	AND		ProductType					= @ProductTypeID
	AND		ProductCostRuleSetupSetID	= @ProductCostRuleSetupSetID
	
	SELECT CASE WHEN @MaxRelativeStartMonth IS NULL THEN 12 ELSE @MaxRelativeStartMonth END AS MaxRelativeStartMonth

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
' 
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'VirtualFolder_Path' , N'SCHEMA',N'dbo', N'PROCEDURE',N'usp_DailyPricingMaxRelativeStartMonthSelect', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'VirtualFolder_Path', @value=N'DailyPricing' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'usp_DailyPricingMaxRelativeStartMonthSelect'
GO
