Use LibertyPower

GO

/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	10/10/2011																								*
 *	Descp:		get the ETP for a batch/quote number																	*
 *  To Run:		exec usp_MtMEnergyTransferPriceCreate '0c6d6340-d147-4f4f-ab8c-d0d5899e7b7a','DealCapture-2011-0002845' *
 *	Modified:																											*
 ************************************************************************************************************************/
ALTER	PROCEDURE usp_MtMEnergyTransferPriceCreate
(	@BatchNumber AS VARCHAR(50),
	@QuoteNumber AS VARCHAR(50),
	@StartDate AS DATETIME
)
AS

BEGIN

	/*
	components required in order to successfully calculate the account ETP are:
	1.	Energy curves
	2.	Supplier premiums
	3.	Shaping premium
	4.	Intraday premium
	5.	Daily wholesale account forecast
	*/

	-- Get the ISO, Zones and deal dates in question for non custom accounts with flow start date in the future 
	SELECT	DISTINCT
			u.WholeSaleMktID as ISO, zz.ZainetZone as Zone, c.SignedDate as DealDate
	INTO	#AccountData

	FROM	MtMAccount m (nolock)

	INNER	JOIN AccountContract ac (nolock)
	ON		m.AccountID = ac.AccountID
	AND		m.ContractID = ac.ContractID

	INNER	JOIN Account a (nolock)
	ON		ac.AccountID = a.AccountID

	INNER	JOIN	Contract c (nolock)
	ON		ac.ContractID = c.ContractID

	INNER	JOIN LibertyPower..Utility u (nolock)
	ON		u.ID = a.UtilityID
	
	INNER	JOIN MtMZainetZones zz (nolock)
	ON		u.ID = zz.UtilityID
	AND		m.Zone = zz.Zone

	INNER	JOIN AccountContractRate acr (nolock)
	ON		ac.AccountContractID = acr.AccountContractID
	AND		acr.IsContractedRate = 1
	
	INNER	JOIN Lp_common..common_product p (nolock)
	ON		acr.LegacyProductID = p.product_id

	WHERE	p.IsCustom = 0
	AND		c.StartDate > @StartDate
	AND		m.BatchNumber = @BatchNumber
	AND		m.QuoteNumber = @QuoteNumber
	/*
		the effective date in all the files should be matched to the date_deal of the contract. 
		The effective date should be the least great date than the date_deal. 
		If date_deal is 6/15, and effective dates are 7/1 and 8/1, the effective date to be used is 7/1.
		If no match was found, the effective date to be used, will the most recent one from the file.	
	*/

	--Get the Energy Curves-----------------------------------------------------------------
	SELECT	a.ISO, a.Zone, MIN(s.EffectiveDate) as EffectiveDate
	INTO	#E
	FROM	MtMEnergyCurves s
	RIGHT	JOIN #AccountData a
	ON		s.ISO = a.ISO
	AND		s.Zone = a.ZONE
	AND		s.EffectiveDate >= a.DealDate
	GROUP	BY a.ISO, a.Zone
								
	UPDATE	t1
	SET		t1.EffectiveDate = t2.EffectiveDate
	FROM	#E t1
	INNER	JOIN 
			(
				SELECT	l.ISO, l.Zone, MAX(EffectiveDate) as EffectiveDate
				FROM	MtMEnergyCurves l
				GROUP	BY l.ISO, l.Zone
			) t2
	ON		t1.ISO = t2.ISO
	AND		t1.Zone = t2.ZONE
	WHERE	t1.EffectiveDate IS NULL
			
	Select	t2.EffectiveDate, t2.UsageDate, t2.ISO, t2.Zone, 
			t2.Int1,
			t2.Int2,
			t2.Int3,
			t2.Int4,
			t2.Int5,
			t2.Int6,
			t2.Int7,
			t2.Int8,
			t2.Int9,
			t2.Int10,
			t2.Int11,
			t2.Int12,
			t2.Int13,
			t2.Int14,
			t2.Int15,
			t2.Int16,
			t2.Int17,
			t2.Int18,
			t2.Int19,
			t2.Int20,
			t2.Int21,
			t2.Int22,
			t2.Int23,
			t2.Int24	
	INTO	#EC
	FROM	#E t1
	INNER	JOIN MtMEnergyCurves t2
	ON		t1.ISO = t2.ISO
	AND		t1.Zone = t2.ZONE
	AND		t1.EffectiveDate = t2.EffectiveDate 

	DROP	TABLE #E

	--Get the Supplier Premiumns -------------------------------------------------
	SELECT	a.ISO, a.Zone, MIN(s.EffectiveDate) as EffectiveDate
	INTO	#S
	FROM	MtMSupplierPremiums s
	RIGHT	JOIN #AccountData a
	ON		s.Zone = a.ZONE
	AND		s.ISO = a.ISO
	AND		s.EffectiveDate >= a.DealDate		
	GROUP	BY a.ISO, a.Zone
								
	UPDATE	t1
	SET		t1.EffectiveDate = t2.EffectiveDate
	FROM	#S t1
	INNER	JOIN 
			(
				SELECT	l.ISO, l.Zone, MAX(EffectiveDate) as EffectiveDate
				FROM	MtMSupplierPremiums l
				GROUP	BY l.ISO, l.Zone
			) t2
	ON		t1.Zone = t2.ZONE
	AND		t1.ISO = t2.ISO
	WHERE	t1.EffectiveDate IS NULL
			
	Select	t2.EffectiveDate, t2.UsageDate, t2.ISO, t2.Zone, 
			t2.Int1,
			t2.Int2,
			t2.Int3,
			t2.Int4,
			t2.Int5,
			t2.Int6,
			t2.Int7,
			t2.Int8,
			t2.Int9,
			t2.Int10,
			t2.Int11,
			t2.Int12,
			t2.Int13,
			t2.Int14,
			t2.Int15,
			t2.Int16,
			t2.Int17,
			t2.Int18,
			t2.Int19,
			t2.Int20,
			t2.Int21,
			t2.Int22,
			t2.Int23,
			t2.Int24	
	INTO	#SupP
	FROM	#S t1
	INNER	JOIN MtMSupplierPremiums t2
	ON		t1.Zone = t2.ZONE
	AND		t1.ISO = t2.ISO
	AND		t1.EffectiveDate = t2.EffectiveDate 

	DROP	TABLE #S
	
	--GET the Shaping Premiums --------------------------------------------
	SELECT	a.ISO, a.Zone, MIN(s.EffectiveDate) as EffectiveDate
	INTO	#Sh
	FROM	MtMShaping s
	RIGHT	JOIN #AccountData a
	ON		s.ISO = a.ISO
	AND		s.Zone = a.ZONE
	AND		s.EffectiveDate >= a.DealDate		
	GROUP	BY a.ISO, a.Zone
								
	UPDATE	t1
	SET		t1.EffectiveDate = t2.EffectiveDate
	FROM	#Sh t1
	INNER	JOIN 
			(
				SELECT	l.ISO, l.Zone, MAX(EffectiveDate) as EffectiveDate
				FROM	MtMShaping l
				GROUP	BY l.ISO, l.Zone
			) t2
	ON		t1.ISO = t2.ISO
	AND		t1.Zone = t2.ZONE
	WHERE	t1.EffectiveDate IS NULL
			
	Select	t2.EffectiveDate, t2.UsageDate, t2.ISO, t2.Zone, 
			t2.Int1,
			t2.Int2,
			t2.Int3,
			t2.Int4,
			t2.Int5,
			t2.Int6,
			t2.Int7,
			t2.Int8,
			t2.Int9,
			t2.Int10,
			t2.Int11,
			t2.Int12,
			t2.Int13,
			t2.Int14,
			t2.Int15,
			t2.Int16,
			t2.Int17,
			t2.Int18,
			t2.Int19,
			t2.Int20,
			t2.Int21,
			t2.Int22,
			t2.Int23,
			t2.Int24	
	INTO	#ShP
	FROM	#Sh t1
	INNER	JOIN MtMShaping t2
	ON		t1.Zone = t2.ZONE
	AND		t1.ISO = t2.ISO
	AND		t1.EffectiveDate = t2.EffectiveDate 
	
	DROP	TABLE #Sh
	
	-- Get the Intraday Premiums-------------------------------------------------
	SELECT	a.ISO, a.Zone, MIN(s.EffectiveDate) as EffectiveDate
	INTO	#I
	FROM	MtMIntraday s
	RIGHT	JOIN #AccountData a
	ON		s.ISO = a.ISO
	AND		s.Zone = a.ZONE
	AND		s.EffectiveDate >= a.DealDate		
	GROUP	BY a.ISO, a.Zone
								
	UPDATE	t1
	SET		t1.EffectiveDate = t2.EffectiveDate
	FROM	#I t1
	INNER	JOIN 
			(
				SELECT	l.ISO, MAX(EffectiveDate) as EffectiveDate
				FROM	MtMIntraday l
				GROUP	BY l.ISO
			) t2
	ON		t1.ISO = t2.ISO
	WHERE	t1.EffectiveDate IS NULL

	Select	t2.EffectiveDate, t2.UsageDate, t2.ISO, t2.Zone, 
			t2.Int1,
			t2.Int2,
			t2.Int3,
			t2.Int4,
			t2.Int5,
			t2.Int6,
			t2.Int7,
			t2.Int8,
			t2.Int9,
			t2.Int10,
			t2.Int11,
			t2.Int12,
			t2.Int13,
			t2.Int14,
			t2.Int15,
			t2.Int16,
			t2.Int17,
			t2.Int18,
			t2.Int19,
			t2.Int20,
			t2.Int21,
			t2.Int22,
			t2.Int23,
			t2.Int24	
	INTO	#IP
	FROM	#I t1
	INNER	JOIN MtMIntraday t2
	ON		t1.Zone = t2.ZONE
	AND		t1.ISO = t2.ISO
	AND		t1.EffectiveDate = t2.EffectiveDate 

	DROP	TABLE #I
	
	-----------------------------------------------------------------------------
	-- Get the ETP
	-- ETP= SUM of (EC*(1+SuP)+ShP)*HWAF) of each hour, divided by SUM of HWAF of each hour
	-- Each account will have only one ETP value
	
	SELECT	l.MtMAccountID,
			(
			SUM((EC.Int1*(1+SupP.Int1+ShP.Int1+ IP.Int1))*l.Int1) + 
			SUM((EC.Int2*(1+SupP.Int2+ShP.Int2+ IP.Int2))*l.Int2) + 
			SUM((EC.Int3*(1+SupP.Int3+ShP.Int3+ IP.Int3))*l.Int3) + 
			SUM((EC.Int4*(1+SupP.Int4+ShP.Int4+ IP.Int4))*l.Int4) + 
			SUM((EC.Int5*(1+SupP.Int5+ShP.Int5+ IP.Int5))*l.Int5) + 
			SUM((EC.Int6*(1+SupP.Int6+ShP.Int6+ IP.Int6))*l.Int6) + 
			SUM((EC.Int7*(1+SupP.Int7+ShP.Int7+ IP.Int7))*l.Int7) + 
			SUM((EC.Int8*(1+SupP.Int8+ShP.Int8+ IP.Int8))*l.Int8) + 
			SUM((EC.Int9*(1+SupP.Int9+ShP.Int9+ IP.Int9))*l.Int9) + 
			SUM((EC.Int10*(1+SupP.Int10+ShP.Int10+ IP.Int10))*l.Int10) + 
			SUM((EC.Int11*(1+SupP.Int11+ShP.Int11+ IP.Int11))*l.Int11) + 
			SUM((EC.Int12*(1+SupP.Int12+ShP.Int12+ IP.Int12))*l.Int12) + 
			SUM((EC.Int13*(1+SupP.Int13+ShP.Int13+ IP.Int13))*l.Int13) + 
			SUM((EC.Int14*(1+SupP.Int14+ShP.Int14+ IP.Int14))*l.Int14) + 
			SUM((EC.Int15*(1+SupP.Int15+ShP.Int15+ IP.Int15))*l.Int15) + 
			SUM((EC.Int16*(1+SupP.Int16+ShP.Int16+ IP.Int16))*l.Int16) + 
			SUM((EC.Int17*(1+SupP.Int17+ShP.Int17+ IP.Int17))*l.Int17) + 
			SUM((EC.Int18*(1+SupP.Int18+ShP.Int18+ IP.Int18))*l.Int18) + 
			SUM((EC.Int19*(1+SupP.Int19+ShP.Int19+ IP.Int19))*l.Int19) + 
			SUM((EC.Int20*(1+SupP.Int20+ShP.Int20+ IP.Int20))*l.Int20) + 
			SUM((EC.Int21*(1+SupP.Int21+ShP.Int21+ IP.Int21))*l.Int21) + 
			SUM((EC.Int22*(1+SupP.Int22+ShP.Int22+ IP.Int22))*l.Int22) + 
			SUM((EC.Int23*(1+SupP.Int23+ShP.Int23+ IP.Int23))*l.Int23) + 
			SUM((EC.Int24*(1+SupP.Int24+ShP.Int24+ IP.Int24))*l.Int24)
			)/
			(SUM(l.Int1) + SUM(l.Int2) + SUM(l.Int3) + SUM(l.Int4) + 
			SUM(l.Int5) + SUM(l.Int6) + SUM(l.Int7) + SUM(l.Int8) + 
			SUM(l.Int9) + SUM(l.Int10) + SUM(l.Int11) + SUM(l.Int12) + 
			SUM(l.Int13) + SUM(l.Int14) + SUM(l.Int15) + SUM(l.Int16) + 
			SUM(l.Int17) + SUM(l.Int18) + SUM(l.Int19) + SUM(l.Int20) + 
			SUM(l.Int21) + SUM(l.Int22) + SUM(l.Int23) + SUM(l.Int24)) AS ETP
	INTO	#AcctETP
	FROM	MtMAccount m

	INNER	JOIN MtMDailyWholesaleLoadForecast l
	ON		m.ID = l.MtMAccountID

	INNER	JOIN AccountContract ac
	ON		m.AccountID = ac.AccountID
	AND		m.ContractID = ac.ContractID

	INNER	JOIN Account a
	ON		ac.AccountID = a.AccountID

	INNER	JOIN	Contract c
	ON		ac.ContractID = c.ContractID

	INNER	JOIN LibertyPower..Utility u
	ON		u.ID = a.UtilityID

	INNER	JOIN MtMZainetZones zz
	ON		u.ID = zz.UtilityID
	AND		m.Zone = zz.Zone
	
	INNER	JOIN AccountContractRate acr
	ON		ac.AccountContractID = acr.AccountContractID
	AND		acr.IsContractedRate = 1
	
	INNER	JOIN Lp_common..common_product p
	ON		acr.LegacyProductID = p.product_id
	
	INNER	JOIN #EC EC
	ON		EC.UsageDate = l.UsageDate
	AND		EC.ISO = u.WholeSaleMktID
	AND		EC.Zone = zz.ZainetZone

	INNER	JOIN #SupP SupP
	ON		SupP.UsageDate = l.UsageDate
	AND		SupP.Zone = zz.ZainetZone

	INNER	JOIN #ShP ShP
	ON		ShP.UsageDate = l.UsageDate
	AND		ShP.ISO = u.WholeSaleMktID
	AND		ShP.Zone = zz.ZainetZone

	INNER	JOIN #IP Ip
	ON		Ip.UsageDate = l.UsageDate
	AND		Ip.ISO = u.WholeSaleMktID
	AND		Ip.Zone = zz.ZainetZone

	WHERE	p.IsCustom = 0
	AND		c.StartDate > @StartDate
	AND		m.BatchNumber = @BatchNumber
	AND		m.QuoteNumber = @QuoteNumber	

	GROUP	BY 
			l.MtMAccountID
	
	-----------------------------------------------------------------------------
	-- Update the ETP - NON CUSTOM and StartDate > @StartDate (accounts that didn't start flowing yet)
	UPDATE	l
	SET		l.ETP = e.ETP
	FROM	MtMDailyWholesaleLoadForecast l
	INNER	JOIN #AcctETP e
	ON		l.MtMAccountID = e.MtMAccountID
	
	-- Update the ETP - CUSTOM and StartDate > @StartDate (accounts that didn't start flowing yet)
	UPDATE	l
	SET		l.ETP = d.ETP
	FROM	MtMDailyWholesaleLoadForecast l

	INNER	JOIN MtMAccount m
	ON		l.MtMAccountID = m.ID

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
	AND		acr.IsContractedRate = 1
	
	INNER	JOIN Lp_common..common_product p
	ON		acr.LegacyProductID = p.product_id

	INNER	JOIN lp_deal_capture.dbo.deal_pricing_detail d
	ON		p.product_id = d.product_id

	WHERE	p.IsCustom = 1
	AND		c.StartDate > @StartDate
	AND		m.BatchNumber = @BatchNumber
	AND		m.QuoteNumber = @QuoteNumber	


	-- Update the ETP - StartDate <= @StartDate (accounts that started flowing): copy the ETP from the previous batch
	-- first get the list of all the accounts that started flowing and need to be updated with the old ETP 
	-- (we get here only in the case when we did reforcasting due to proxy data)
	SELECT	Distinct m.AccountID, m.ContractID, l.MtMAccountID
	INTO	#Flowing
	FROM	MtMDailyWholesaleLoadForecast l
	
	INNER	JOIN MtMAccount m
	ON		l.MtMAccountID = m.ID	
	
	INNER	JOIN AccountContract ac
	ON		m.AccountID = ac.AccountID
	AND		m.ContractID = ac.ContractID

	INNER	JOIN	Contract c
	ON		ac.ContractID = c.ContractID
		
	WHERE	l.ETP IS NULL
	AND		c.StartDate > @StartDate
	AND		m.BatchNumber = @BatchNumber
	AND		m.QuoteNumber = @QuoteNumber	
	
	-- get the old ETP for the accounts that started flowing. 
	SELECT	Distinct m.AccountID, m.ContractID, l.ETP
	INTO	#OldETP
	FROM	MtMDailyWholesaleLoadForecast l
	
	INNER	JOIN MtMAccount m
	ON		l.MtMAccountID = m.ID	
	
	INNER	JOIN #Flowing f
	ON		f.AccountID = m.AccountID
	AND		f.ContractID = m.ContractID
	AND		f.MtMAccountID > m.ID
	
	WHERE	l.ETP IS NOT NULL
	AND		m.Status = 'ETPd'
	

	UPDATE	l
	SET		l.ETP = o.ETP
	FROM	MtMDailyWholesaleLoadForecast l

	INNER	JOIN #Flowing f
	ON		l.MtMAccountID = f.MtMAccountID
	
	INNER	JOIN #OldETP o
	ON		f.AccountID = o.AccountID
	AND		f.ContractID = o.ContractID
	
END

GO



