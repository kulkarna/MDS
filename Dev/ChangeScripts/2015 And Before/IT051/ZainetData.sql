	-- HWETF -------------------------------
	SELECT	p.IsCustom, m.Zone, l.UsageDate,
			SUM(l.Int1) as Int1,
			SUM(l.Int2) as Int2,
			SUM(l.Int3) as Int3,
			SUM(l.Int4) as Int4,
			SUM(l.Int5) as Int5,
			SUM(l.Int6) as Int6,
			SUM(l.Int7) as Int7,
			SUM(l.Int8) as Int8,
			SUM(l.Int9) as Int9,
			SUM(l.Int10) as Int10,
			SUM(l.Int11) as Int11,
			SUM(l.Int12) as Int12,
			SUM(l.Int13) as Int13,
			SUM(l.Int14) as Int14,
			SUM(l.Int15) as Int15,
			SUM(l.Int16) as Int16,
			SUM(l.Int17) as Int17,
			SUM(l.Int18) as Int18,
			SUM(l.Int19) as Int19,
			SUM(l.Int20) as Int20,
			SUM(l.Int21) as Int21,
			SUM(l.Int22) as Int22,
			SUM(l.Int23) as Int23,
			SUM(l.Int24) as Int24
	INTO	#ETF
	FROM	MtMDailyWholesaleLoadForecast l

	INNER	JOIN MtMAccount m
	ON		l.MtMAccountID = m.ID

	INNER	JOIN AccountContract ac
	ON		m.AccountID = ac.AccountID
	AND		m.ContractID = ac.ContractID

	INNER	JOIN AccountStatus s
	ON		s.AccountContractID = ac.AccountContractID
	--AND		s.Status = '911000'
	--AND		s.SubStatus = '10'
	
	INNER	JOIN MtMReportStatus rs
	ON		rs.Status = s.Status
	AND		rs.SubStatus = s.SubStatus
	AND		ReportID = 4 --De-Enrolled Early Termination

	INNER	JOIN AccountEtf e
	ON		ac.AccountID = e.AccountID
	AND		e.DeenrollmentDate > GETDATE()
	
	INNER	JOIN AccountContractRate acr
	ON		ac.AccountContractID = acr.AccountContractID

	INNER	JOIN Lp_common..common_product p
	ON		acr.LegacyProductID = p.product_id

	GROUP	BY p.IsCustom, m.Zone, l.UsageDate

	-- HWAGF -------------------------------
	SELECT	p.IsCustom, m.Zone, l.UsageDate,
			SUM(l.Int1) as Int1,
			SUM(l.Int2) as Int2,
			SUM(l.Int3) as Int3,
			SUM(l.Int4) as Int4,
			SUM(l.Int5) as Int5,
			SUM(l.Int6) as Int6,
			SUM(l.Int7) as Int7,
			SUM(l.Int8) as Int8,
			SUM(l.Int9) as Int9,
			SUM(l.Int10) as Int10,
			SUM(l.Int11) as Int11,
			SUM(l.Int12) as Int12,
			SUM(l.Int13) as Int13,
			SUM(l.Int14) as Int14,
			SUM(l.Int15) as Int15,
			SUM(l.Int16) as Int16,
			SUM(l.Int17) as Int17,
			SUM(l.Int18) as Int18,
			SUM(l.Int19) as Int19,
			SUM(l.Int20) as Int20,
			SUM(l.Int21) as Int21,
			SUM(l.Int22) as Int22,
			SUM(l.Int23) as Int23,
			SUM(l.Int24) as Int24
	INTO	#HWAGF
	FROM	MtMDailyWholesaleLoadForecast l

	INNER	JOIN MtMAccount m
	ON		l.MtMAccountID = m.ID

	INNER	JOIN AccountContract ac
	ON		m.AccountID = ac.AccountID
	AND		m.ContractID = ac.ContractID

	INNER	JOIN AccountStatus s
	ON		s.AccountContractID = ac.AccountContractID
	
	INNER	JOIN MtMReportStatus rs
	ON		rs.Status = s.Status
	AND		rs.SubStatus = s.SubStatus
	AND		ReportID = 1 --Fixed Price Load Obligation Position Reports Account List
	
	INNER	JOIN AccountContractRate acr
	ON		ac.AccountContractID = acr.AccountContractID

	INNER	JOIN Lp_common..common_product p
	ON		acr.LegacyProductID = p.product_id

	GROUP	BY p.IsCustom, m.Zone, l.UsageDate
	
	--Get the Attrition -------------------------------------------------
	SELECT	DISTINCT
			u.WholeSaleMktID as ISO, a.zone as Zone, c.SignedDate as DealDate
	INTO	#AccountData

	FROM	MtMAccount m

	INNER	JOIN AccountContract ac
	ON		m.AccountID = ac.AccountID
	AND		m.ContractID = ac.ContractID

	INNER	JOIN Account a
	ON		ac.AccountID = a.AccountID

	INNER	JOIN	Contract c
	ON		ac.ContractID = c.ContractID

	INNER	JOIN LibertyPower..Utility u
	ON		u.ID = a.UtilityID

	INNER	JOIN AccountContractRate acr
	ON		ac.AccountContractID = acr.AccountContractID

	INNER	JOIN Lp_common..common_product p
	ON		acr.LegacyProductID = p.product_id
	
	SELECT	a.ISO, a.Zone, MIN(s.EffectiveDate) as EffectiveDate
	INTO	#Att
	FROM	MtMAttrition s
	RIGHT	JOIN #AccountData a
	ON		s.ISO = a.ISO
	AND		s.Zone = a.ZONE
	AND		s.EffectiveDate >= a.DealDate
				
	GROUP	BY a.ISO, a.Zone
								
	UPDATE	t1
	SET		t1.EffectiveDate = t2.EffectiveDate
	FROM	#Att t1
	INNER	JOIN 
			(
				SELECT	l.ISO, l.Zone, MAX(EffectiveDate) as EffectiveDate
				FROM	MtMAttrition l
				GROUP	BY l.ISO, l.Zone
			) t2
	ON		t1.ISO = t2.ISO
	AND		t1.Zone = t2.ZONE
	WHERE	t1.EffectiveDate IS NULL
		
	Select	t2.EffectiveDate, t2.DeliveryMonth, t2.ISO, t2.Zone, t2.Attrition
	INTO	#Attrition
	FROM	#Att t1
	INNER	JOIN MtMAttrition t2
	ON		t1.ISO = t2.ISO
	AND		t1.Zone = t2.ZONE
	AND		t1.EffectiveDate = t2.EffectiveDate 

	DROP	TABLE #Att

	--------------------------------------------------------------------------
	-- GET HWATF = (HWAGF - HWETF)*Attrition factor
	SELECT	 ag.UsageDate, ag.IsCustom, ag.Zone, 	
			(ag.Int1 - ISNULL(et.Int1,0))*at.Attrition as Int1,
			(ag.Int2 - ISNULL(et.Int2,0))*at.Attrition as Int2,
			(ag.Int3 - ISNULL(et.Int3,0))*at.Attrition as Int3,
			(ag.Int4 - ISNULL(et.Int4,0))*at.Attrition as Int4,
			(ag.Int5 - ISNULL(et.Int5,0))*at.Attrition as Int5,
			(ag.Int6 - ISNULL(et.Int6,0))*at.Attrition as Int6,
			(ag.Int7 - ISNULL(et.Int7,0))*at.Attrition as Int7,
			(ag.Int8 - ISNULL(et.Int8,0))*at.Attrition as Int8,
			(ag.Int9 - ISNULL(et.Int9,0))*at.Attrition as Int9,
			(ag.Int10 - ISNULL(et.Int10,0))*at.Attrition as Int10,
			(ag.Int11 - ISNULL(et.Int11,0))*at.Attrition as Int11,
			(ag.Int12 - ISNULL(et.Int12,0))*at.Attrition as Int12,
			(ag.Int13 - ISNULL(et.Int13,0))*at.Attrition as Int13,
			(ag.Int14 - ISNULL(et.Int14,0))*at.Attrition as Int14,
			(ag.Int15 - ISNULL(et.Int15,0))*at.Attrition as Int15,
			(ag.Int16 - ISNULL(et.Int16,0))*at.Attrition as Int16,
			(ag.Int17 - ISNULL(et.Int17,0))*at.Attrition as Int17,
			(ag.Int18 - ISNULL(et.Int18,0))*at.Attrition as Int18,
			(ag.Int19 - ISNULL(et.Int19,0))*at.Attrition as Int19,
			(ag.Int20 - ISNULL(et.Int20,0))*at.Attrition as Int20,
			(ag.Int21 - ISNULL(et.Int12,0))*at.Attrition as Int21,
			(ag.Int22 - ISNULL(et.Int22,0))*at.Attrition as Int22,
			(ag.Int23 - ISNULL(et.Int23,0))*at.Attrition as Int23,
			(ag.Int24 - ISNULL(et.Int24,0))*at.Attrition as Int24
			
	FROM	#HWAGF ag
	
	LEFT	JOIN #ETF et
	ON		ag.IsCustom = et.IsCustom
	AND		ag.Zone = et.Zone
	AND		ag.UsageDate = et.UsageDate
	
	Inner	JOIN #Attrition at
	ON		ag.Zone = at.Zone
	AND		MONTH(ag.UsageDate) = MONTH(at.DeliveryMonth)
	AND		YEAR(ag.UsageDate) = YEAR(at.DeliveryMonth)

select * from #Attrition
