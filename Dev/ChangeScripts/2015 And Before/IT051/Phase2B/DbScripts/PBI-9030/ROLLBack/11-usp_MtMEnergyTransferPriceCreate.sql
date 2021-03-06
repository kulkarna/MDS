USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMEnergyTransferPriceCreate]    Script Date: 12/09/2013 15:59:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER	PROCEDURE [dbo].[usp_MtMEnergyTransferPriceCreate]
(	@BatchNumber AS VARCHAR(50),
	@QuoteNumber AS VARCHAR(50),
	@StartDate AS DATETIME
)
AS

BEGIN
	/*	components required in order to successfully calculate the account ETP are:
	1.	Energy curves	2.	Supplier premiums	3.	Shaping premium	4.	Intraday premium	5.	Daily wholesale account forecast*/
	--Calculate the ETP for everything except for the accounts uploaded with the custom template. Including the custom daily deals.
	SELECT	DISTINCT
			m.ID as MtMAccountID, m.AccountID, m.ContractID, m.Zone
	INTO	#M
	FROM	MtMAccount m (nolock)
	WHERE	m.BatchNumber = @BatchNumber
	AND		m.QuoteNumber = @QuoteNumber
	--AND		m.QuoteNumber NOT LIKE '%CustomDealUpload%'
	
	SELECT	DISTINCT
			m.MtMAccountID, a.product_id, a.IsCustom, a.RateID,
			a.ISO, zz.ZainetZone as Zone, DATEADD(D, 0, DATEDIFF(D, 0, a.SignedDate)) as DealDate, a.StartDate, a.EndDate
	INTO	#Accounts
	FROM	#M m (nolock)
	INNER	JOIN MtMZainetAccountInfo a (nolock)
	ON		m.AccountID = a.AccountID
	AND		m.ContractID = a.ContractID
	INNER	JOIN MtMZainetZones zz (nolock)
	ON		a.UtilityID = zz.UtilityID
	AND		m.Zone = zz.Zone
	AND		a.IsDaily = 1
	--WHERE	a.IsCustom = 0 -- AS OF 6/13/2013: we need to calculate the ETP for the custom daily deals
	--WHERE	a.StartDate > @StartDate

	
	CREATE CLUSTERED INDEX idx_Accounts_ID ON #Accounts (MtMAccountID)
	CREATE NONCLUSTERED INDEX idx_Accounts_IZ ON #Accounts (ISO,Zone)
	CREATE NONCLUSTERED INDEX idx_Accounts_D ON #Accounts (StartDate,EndDate)
	
	-- Get the ISO, Zones and deal dates in question for non custom accounts with flow start date in the future 
	SELECT	DISTINCT
			m.ISO, m.Zone, m.DealDate
	INTO	#AccountData
	FROM	#Accounts m (nolock)
	
	/*	the effective date in all the files should be matched to the date_deal of the contract. 
		The effective date should be the least great date than the date_deal. 
		If date_deal is 6/15, and effective dates are 7/1 and 8/1, the effective date to be used is 7/1.
		If no match was found, the effective date to be used, will the most recent one from the file.	
		UPDATE: PBI 7314: effective date should the max date <= signed date. if no match is found, error
		For Energy Curves, we should match agaisnt the actual dealDate and Effective date, if not found, error	*/

	--Get the Energy Curves-----------------------------------------------------------------		
	Select	DISTINCT
			t2.EffectiveDate, t2.UsageDate, t2.ISO, t2.Zone, 
			t2.Int1,t2.Int2,t2.Int3,t2.Int4,t2.Int5,t2.Int6,t2.Int7,t2.Int8,t2.Int9,t2.Int10,t2.Int11,t2.Int12,
			t2.Int13,t2.Int14,t2.Int15,t2.Int16,t2.Int17,t2.Int18,t2.Int19,t2.Int20,t2.Int21,t2.Int22,t2.Int23,t2.Int24	
	INTO	#EC
	FROM	#AccountData t1
	INNER	JOIN MtMEnergyCurvesMostRecentEffectiveDate t3 (nolock)
	ON		t1.ISO = t3.ISO
	AND		t1.Zone = t3.ZONE
	AND		t1.DealDate = t3.EffectiveDate
	INNER	JOIN MtMEnergyCurves t2 (nolock)
	ON		t3.ISO = t2.ISO
	AND		t3.Zone = t2.ZONE
	AND		t3.EffectiveDate = t2.EffectiveDate
	AND		t3.FileLogID = t2.FileLogID

	CREATE CLUSTERED INDEX idx_ED ON #EC (UsageDate,ISO,Zone)

	--Get the Supplier Premiumns -------------------------------------------------
	SELECT	a.ISO, a.Zone, MAX(s.EffectiveDate) as EffectiveDate
	INTO	#S
	FROM	MtMSupplierPremiumsMostRecentEffectiveDate s (nolock)
	INNER	JOIN #AccountData a
	ON		s.Zone = a.ZONE
	AND		s.ISO = a.ISO
	AND		s.EffectiveDate <= a.DealDate		
	GROUP	BY a.ISO, a.Zone
								
	Select	DISTINCT
			t2.EffectiveDate, t2.UsageDate, t2.ISO, t2.Zone, 
			t2.Int1,t2.Int2,t2.Int3,t2.Int4,t2.Int5,t2.Int6,t2.Int7,t2.Int8,t2.Int9,t2.Int10,t2.Int11,t2.Int12,
			t2.Int13,t2.Int14,t2.Int15,t2.Int16,t2.Int17,t2.Int18,t2.Int19,t2.Int20,t2.Int21,t2.Int22,t2.Int23,t2.Int24	
	INTO	#SupP
	FROM	#S t1
	INNER	JOIN MtMSupplierPremiumsMostRecentEffectiveDate t3 (nolock)
	ON		t1.ISO = t3.ISO
	AND		t1.Zone = t3.ZONE
	AND		t1.EffectiveDate = t3.EffectiveDate 
	INNER	JOIN MtMSupplierPremiums t2 (nolock)
	ON		t2.ISO = t3.ISO
	AND		t2.Zone = t3.ZONE
	AND		t2.EffectiveDate = t3.EffectiveDate 
	AND		t2.FileLogID = t3.FileLogID
	
	DROP	TABLE #S
	
	CREATE CLUSTERED INDEX idx_SupP ON #SupP (UsageDate,ISO,Zone)
	
	--GET the Shaping Premiums --------------------------------------------
	SELECT	a.ISO, a.Zone, MAX(s.EffectiveDate) as EffectiveDate
	INTO	#Sh
	FROM	MtMShapingMostRecentEffectiveDate s (nolock)
	INNER	JOIN #AccountData a
	ON		s.ISO = a.ISO
	AND		s.Zone = a.ZONE
	AND		s.EffectiveDate <= a.DealDate		
	GROUP	BY a.ISO, a.Zone
										
	Select	DISTINCT
			t2.EffectiveDate, t2.UsageDate, t2.ISO, t2.Zone, 
			t2.Int1,t2.Int2,t2.Int3,t2.Int4,t2.Int5,t2.Int6,t2.Int7,t2.Int8,t2.Int9,t2.Int10,t2.Int11,t2.Int12,
			t2.Int13,t2.Int14,t2.Int15,t2.Int16,t2.Int17,t2.Int18,t2.Int19,t2.Int20,t2.Int21,t2.Int22,t2.Int23,t2.Int24	
	INTO	#ShP
	FROM	#Sh t1
	INNER	JOIN MtMShapingMostRecentEffectiveDate t3 (nolock)
	ON		t1.ISO = t3.ISO
	AND		t1.Zone = t3.ZONE
	AND		t1.EffectiveDate = t3.EffectiveDate 
	INNER	JOIN MtMShaping t2 (nolock)
	ON		t2.ISO = t3.ISO
	AND		t2.Zone = t3.ZONE
	AND		t2.EffectiveDate = t3.EffectiveDate 
	AND		t2.FileLogID = t3.FileLogID
		
	DROP	TABLE #Sh
	
	CREATE CLUSTERED INDEX idx_ShP ON #ShP (UsageDate,ISO,Zone)
	
	-- Get the Intraday Premiums-------------------------------------------------
	SELECT	a.ISO, a.Zone, MAX(s.EffectiveDate) as EffectiveDate
	INTO	#I
	FROM	MtMIntradayMostRecentEffectiveDate s (nolock)
	INNER	JOIN #AccountData a
	ON		s.ISO = a.ISO
	AND		s.Zone = a.ZONE
	AND		s.EffectiveDate <= a.DealDate		
	GROUP	BY a.ISO, a.Zone
								
	Select	DISTINCT
			t2.EffectiveDate, t2.UsageDate, t2.ISO, t2.Zone, 
			t2.Int1,t2.Int2,t2.Int3,t2.Int4,t2.Int5,t2.Int6,t2.Int7,t2.Int8,t2.Int9,t2.Int10,t2.Int11,t2.Int12,
			t2.Int13,t2.Int14,t2.Int15,t2.Int16,t2.Int17,t2.Int18,t2.Int19,t2.Int20,t2.Int21,t2.Int22,t2.Int23,t2.Int24	
	INTO	#IP
	FROM	#I t1
	INNER	JOIN MtMIntradayMostRecentEffectiveDate t3 (nolock)
	ON		t1.ISO = t3.ISO
	AND		t1.Zone = t3.ZONE
	AND		t1.EffectiveDate = t3.EffectiveDate 	
	INNER	JOIN MtMIntraday t2 (nolock)
	ON		t2.ISO = t3.ISO
	AND		t2.Zone = t3.ZONE
	AND		t2.EffectiveDate = t3.EffectiveDate 
	AND		t2.FileLogID = t3.FileLogID
	
	DROP	TABLE #I
	
	CREATE CLUSTERED INDEX idx_IP ON #IP (UsageDate,ISO,Zone)
	-------------------------------------------------------------------------------------------
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
			(SUM(l.Int1) + SUM(l.Int2) + SUM(l.Int3) + SUM(l.Int4) + SUM(l.Int5) + SUM(l.Int6) + SUM(l.Int7) + SUM(l.Int8) + 
			SUM(l.Int9) + SUM(l.Int10) + SUM(l.Int11) + SUM(l.Int12) + SUM(l.Int13) + SUM(l.Int14) + SUM(l.Int15) + SUM(l.Int16) + 
			SUM(l.Int17) + SUM(l.Int18) + SUM(l.Int19) + SUM(l.Int20) + SUM(l.Int21) + SUM(l.Int22) + SUM(l.Int23) + SUM(l.Int24)) AS ETP
	INTO	#AcctETP
	FROM	#Accounts m
	INNER	JOIN MtMDailyWholesaleLoadForecast l
	ON		m.MtMAccountID = l.MtMAccountID
	INNER	JOIN #EC EC
	ON		EC.UsageDate = l.UsageDate
	AND		EC.ISO = m.ISO
	AND		EC.Zone = m.Zone
	INNER	JOIN #SupP SupP
	ON		SupP.UsageDate = l.UsageDate
	AND		SupP.ISO = m.ISO
	AND		SupP.Zone = m.Zone
	INNER	JOIN #ShP ShP
	ON		ShP.UsageDate = l.UsageDate
	AND		ShP.ISO = m.ISO
	AND		ShP.Zone = m.Zone
	INNER	JOIN #IP Ip
	ON		Ip.UsageDate = l.UsageDate
	AND		Ip.ISO = m.ISO
	AND		Ip.Zone = m.Zone
	WHERE	l.UsageDate BETWEEN m.StartDate AND m.EndDate
	GROUP	BY 
			l.MtMAccountID
	HAVING	(SUM(l.Int1) + SUM(l.Int2) + SUM(l.Int3) + SUM(l.Int4) + SUM(l.Int5) + SUM(l.Int6) + SUM(l.Int7) + SUM(l.Int8) + 
			SUM(l.Int9) + SUM(l.Int10) + SUM(l.Int11) + SUM(l.Int12) + SUM(l.Int13) + SUM(l.Int14) + SUM(l.Int15) + SUM(l.Int16) + 
			SUM(l.Int17) + SUM(l.Int18) + SUM(l.Int19) + SUM(l.Int20) + SUM(l.Int21) + SUM(l.Int22) + SUM(l.Int23) + SUM(l.Int24)) > 0
	
	-----------------------------------------------------------------------------
	-- Update the ETP - NON CUSTOM and StartDate > @StartDate (accounts that didn't start flowing yet)
	UPDATE	l
	SET		l.ETP = e.ETP
	FROM	MtMDailyWholesaleLoadForecast l
	INNER	JOIN #AcctETP e
	ON		l.MtMAccountID = e.MtMAccountID

END

