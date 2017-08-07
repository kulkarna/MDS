USE LibertyPower
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[usp_UtilityMappingByUtilityIDSelect]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
    DROP PROCEDURE [dbo].[usp_UtilityMappingByUtilityIDSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * usp_UtilityMappingByUtilityIDSelect
 * Gets the utility mappings for specified utility
 *
 * History
 *******************************************************************************
 * 11/19/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityMappingByUtilityIDSelect]
	@UtilityID	int
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	m.ID, m.UtilityID, m.RateClassID, m.ServiceClassID, m.LoadProfileID, m.LoadShapeID, 
			m.TariffCodeID, m.VoltageID, m.MeterTypeID, m.AccountTypeID, m.LossFactor,
			r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode,
			t.Code AS TariffCode, v.VoltageCode, mt.MeterTypeCode, at.[Description] AS AccountTypeDesc, 
			u.UtilityCode, u.FullName AS UtilityFullName, u.MarketID, mkt.MarketCode, m.IsActive,m.ZoneID,z.ZoneCode, m.RuleType, m.Icap, m.Tcap
    FROM	UtilityClassMapping m WITH (NOLOCK)
			LEFT JOIN LibertyPower..RateClass r WITH (NOLOCK) ON m.RateClassID = r.ID
			LEFT JOIN LibertyPower..ServiceClass s WITH (NOLOCK) ON m.ServiceClassID = s.ID
			LEFT JOIN LibertyPower..LoadProfile p on m.LoadProfileID = p.ID
			LEFT JOIN LibertyPower..LoadShape l WITH (NOLOCK) ON m.LoadShapeID = l.ID	
			LEFT JOIN LibertyPower..TariffCode t WITH (NOLOCK) ON m.TariffCodeID = t.ID		
			LEFT JOIN LibertyPower..Voltage v WITH (NOLOCK) ON m.VoltageID = v.ID
			LEFT JOIN LibertyPower..MeterType mt WITH (NOLOCK) ON m.MeterTypeID = mt.ID
			LEFT JOIN LibertyPower..AccountType at WITH (NOLOCK) ON m.AccountTypeID = at.ID	
			LEFT JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			LEFT JOIN LibertyPower..Zone z WITH (NOLOCK) ON z.ID = m.ZoneID
			INNER JOIN LibertyPower..Market mkt WITH (NOLOCK) ON u.MarketID = mkt.ID
    WHERE	m.UtilityID = @UtilityID
    ORDER BY mkt.MarketCode, u.UtilityCode, r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode, t.Code

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power



GO
