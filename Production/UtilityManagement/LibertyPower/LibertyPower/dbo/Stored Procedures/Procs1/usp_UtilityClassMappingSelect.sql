
/*******************************************************************************
 * usp_UtilityClassMappingSelect
 * Gets all utility class mappings
 *
 * History
 *******************************************************************************
 * 12/2/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_UtilityClassMappingSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT	m.ID, m.UtilityID, m.RateClassID, m.ServiceClassID, m.LoadProfileID, m.LoadShapeID, 
			m.TariffCodeID, m.VoltageID, m.MeterTypeID, m.AccountTypeID, m.LossFactor,m.ZoneID,
			r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode,
			t.Code AS TariffCode, v.VoltageCode, mt.MeterTypeCode, at.[Description] AS AccountTypeDesc, u.UtilityCode,
			z.ZoneCode
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
			LEFT JOIN LibertyPower..Zone z WITH (NOLOCK) ON m.ZoneID = z.ID
    ORDER BY u.UtilityCode, r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode, t.Code

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

