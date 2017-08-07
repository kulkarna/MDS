USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UtilityZoneMappingByUtilityIDSelect]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UtilityZoneMappingByUtilityIDSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_UtilityZoneMappingByUtilityIDSelect
 * Gets the utility zone mappings for specified utility
 *
 * History
 *******************************************************************************
 * 11/19/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityZoneMappingByUtilityIDSelect]
	@UtilityID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	m.ID, m.UtilityID, uz.ZoneID, z.ZoneCode, u.UtilityCode, Grid, LBMPZone, 
			LossFactor, u.MarketID, mkt.MarketCode, m.IsActive, m.RuleType
    FROM	UtilityZoneMapping m WITH (NOLOCK)
			LEFT JOIN LibertyPower..UtilityZone uz WITH (NOLOCK) ON m.UtilityZoneID = uz.ID
			LEFT JOIN LibertyPower..Zone z WITH (NOLOCK) ON uz.ZoneID = z.ID
			LEFT JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			INNER JOIN LibertyPower..Market mkt WITH (NOLOCK) ON u.MarketID = mkt.ID
    WHERE	m.UtilityID = @UtilityID
    ORDER BY mkt.MarketCode, u.UtilityCode, z.ZoneCode, LossFactor

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO