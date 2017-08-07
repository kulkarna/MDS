    create view vw_UtilityMappingSelect as 
    
	SELECT	top 1 m.ID, m.UtilityID, m.RateClassID, m.ServiceClassID, m.LoadProfileID, m.LoadShapeID, 
			m.TariffCodeID, m.VoltageID, m.MeterTypeID, m.AccountTypeID, m.LossFactor,
			r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode,
			t.Code AS TariffCode, v.VoltageCode, mt.MeterTypeCode, at.[Description] AS AccountTypeDesc, 
			u.UtilityCode, u.FullName AS UtilityFullName, u.MarketID, mkt.MarketCode, m.IsActive,m.ZoneID,z.ZoneCode
	FROM	LibertyPower..UtilityClassMapping m WITH (NOLOCK)
			LEFT JOIN LibertyPower..RateClass r WITH (NOLOCK) ON m.RateClassID = r.ID
			LEFT JOIN LibertyPower..ServiceClass s WITH (NOLOCK) ON m.ServiceClassID = s.ID
			LEFT JOIN LibertyPower..LoadProfile p on m.LoadProfileID = p.ID
			LEFT JOIN LibertyPower..LoadShape l WITH (NOLOCK) ON m.LoadShapeID = l.ID	
			LEFT JOIN LibertyPower..TariffCode t WITH (NOLOCK) ON m.TariffCodeID = t.ID		
			LEFT JOIN LibertyPower..Voltage v WITH (NOLOCK) ON m.VoltageID = v.ID
			LEFT JOIN LibertyPower..MeterType mt WITH (NOLOCK) ON m.MeterTypeID = mt.ID
			LEFT JOIN LibertyPower..AccountType at WITH (NOLOCK) ON m.AccountTypeID = at.ID	
			LEFT JOIN LibertyPower..Zone z WITH (NOLOCK) ON m.ZoneID = z.ID
			LEFT JOIN LibertyPower..Utility u WITH (NOLOCK) ON m.UtilityID = u.ID
			INNER JOIN LibertyPower..Market mkt WITH (NOLOCK) ON u.MarketID = mkt.ID	
	ORDER BY mkt.MarketCode, u.UtilityCode, r.RateClassCode, s.ServiceClassCode, p.LoadProfileCode, l.LoadShapeCode, t.Code