USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductConfigurationPriceTiersSelect]    Script Date: 04/09/2013 07:59:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductConfigurationPriceTiersSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_ProductConfigurationPriceTiersSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_ProductConfigurationPriceTiersSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_ProductConfigurationPriceTiersSelect
 * Gets price tiers for product configuration
 *
 * History
 *******************************************************************************
 * 4/5/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductConfigurationPriceTiersSelect]
	@ProductConfigurationID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	p.ID, p.ProductConfigurationID, p.PriceTierID, t.Name,
			t.[Description], t.MinMwh, t.MaxMwh, t.IsActive, t.SortOrder
    FROM	ProductConfigurationPriceTiers p WITH (NOLOCK)
			INNER JOIN  DailyPricingPriceTier t WITH (NOLOCK)
			ON p.PriceTierID = t.ID
    WHERE	p.ProductConfigurationID = CASE WHEN @ProductConfigurationID = -1 THEN p.ProductConfigurationID ELSE @ProductConfigurationID END

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
