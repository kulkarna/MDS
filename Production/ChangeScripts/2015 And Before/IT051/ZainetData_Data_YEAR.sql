USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetZainetData]    Script Date: 03/22/2012 14:57:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  /************************************************************************************************/
/*****************************  usp_GetZainetData ***********************************************/
/************************************************************************************************/

ALTER PROCEDURE   [dbo].[usp_MtMGetZainetData]
AS

BEGIN
	-- The following was created because the query was taking a long time, a very long time (had to cancel it after 5 min)
	-- Seperating the ZKey/Counterparty tables and getting all that info and storing it in a non-normalized table
	-- made the query run in a sec
	SELECT	DISTINCT
			rs.Status, 
			rs.SubStatus, 
			r.ReportDescription, 
			rc.CounterParty, 
			--rc.Book, 
			rc.BuySell,
			rz.ISO,
			rz.Zone,
			rz.Year,
			rzd.Zkey
	INTO	#Static
	FROM	MtMReportStatus rs (nolock)

	INNER JOIN MtMReport r (nolock)
	ON	 rs.ReportID = r.ReportID
	AND	r.Inactive = 0

	INNER JOIN MtMReportCounterParty rc (nolock)
	ON	 r.CounterPartyID = rc.CounterPartyID

	INNER JOIN MtMReportZkeyDetail rzd (nolock)
	ON	 rzd.CounterPartyID = r.CounterPartyID

	INNER JOIN MtMReportZkey rz (nolock)
	ON	 rzd.ZkeyID = rz.ZkeyID

	WHERE rs.Inactive = 0

	-- GET the list of accounts that are eligible to be included in the Zainet
	SELECT	DISTINCT 
			c.SignedDate, 
			u.WholeSaleMktID AS ISO, 
			u.ID as UtilityID,
			zz.ZainetZone,
			m.Zone,
			T.*
	INTO	#Account
	FROM	MtMAccount m
	INNER	JOIN 
	(	
		SELECT	AccountID, ContractID, MAX(ID) AS ID
		FROM	MtMAccount
		WHERE	Status = 'ETPd'
		GROUP	BY AccountID, ContractID
	)T
	ON		m.ID = T.ID

	INNER	JOIN  Contract c (nolock)
	ON		m.ContractID = c.ContractID

	INNER	JOIN Account act (nolock)
	ON		m.AccountID = act.AccountID

	INNER	JOIN Utility u (nolock)
	ON		act.UtilityID = u.ID

	INNER	JOIN MtMZainetZones zz
	ON		u.ID = zz.UtilityID
	AND		m.Zone = zz.Zone		

   --GET ATTRITION PERCENTAGE
	SELECT	a.ISO, a.ZainetZone,MIN(s.EffectiveDate) as EffectiveDate
	INTO	#ATT
	FROM	#Account a
	LEFT	JOIN MtMAttrition s
	ON		s.ISO = a.ISO	  
	AND		s.Zone = a.ZainetZone
	AND		s.EffectiveDate >= a.SignedDate
	GROUP	BY a.ISO, a.ZainetZone

	--get the max date	   
	UPDATE	t1
	SET		t1.EffectiveDate = t2.EffectiveDate
	FROM	#ATT t1
	INNER	JOIN 
	(
		SELECT	l.ISO, l.Zone, MAX(EffectiveDate) as EffectiveDate
		FROM	MtMAttrition l
		GROUP	BY l.ISO, l.Zone
	) t2
    ON		t1.ISO = t2.ISO
	AND		t1.ZainetZone = t2.Zone
	WHERE	t1.EffectiveDate IS NULL

	SELECT	t2.EffectiveDate, t2.DeliveryMonth, t2.ISO, t2.Zone, t2.Attrition
	INTO	#A
	FROM	#ATT t1
	INNER	JOIN MtMAttrition t2
	ON		t1.ISO = t2.ISO
	AND		t1.ZainetZone = t2.Zone
	AND		t1.EffectiveDate = t2.EffectiveDate 

	SELECT	DISTINCT 
			DL.ID,
			Int1 = (DL.Int1)*t3.Attrition,
      		Int2 = (DL.Int2)*t3.Attrition,
      		Int3 = (DL.Int3)*t3.Attrition,
      		Int4 = (DL.Int4)*t3.Attrition,
      		Int5 = (DL.Int5)*t3.Attrition,
      		Int6 = (DL.Int6)*t3.Attrition,
      		Int7 = (DL.Int7)*t3.Attrition,
      		Int8 = (DL.Int8)*t3.Attrition,
      		Int9 = (DL.Int9)*t3.Attrition,
      		Int10 = (DL.Int10)*t3.Attrition,
      		Int11 = (DL.Int11)*t3.Attrition,
      		Int12 = (DL.Int12)*t3.Attrition,
      		Int13 = (DL.Int13)*t3.Attrition,
      		Int14 = (DL.Int14)*t3.Attrition,
      		Int15 = (DL.Int15)*t3.Attrition,
      		Int16 = (DL.Int16)*t3.Attrition,
      		Int17 = (DL.Int17)*t3.Attrition,
      		Int18 = (DL.Int18)*t3.Attrition,
      		Int19 = (DL.Int19)*t3.Attrition,
      		Int20 = (DL.Int20)*t3.Attrition,
      		Int21 = (DL.Int21)*t3.Attrition,
      		Int22 = (DL.Int22)*t3.Attrition,
      		Int23 = (DL.Int23)*t3.Attrition,
      		Int24 = (DL.Int24)*t3.Attrition
	INTO	#ATTValues
	FROM	MtMDailyWholesaleLoadForecast DL (nolock)

	INNER	JOIN #Account  a 
	ON		a.ID = DL.MtMAccountID
     
	INNER	JOIN AccountContract ac (nolock)
	ON		a.AccountID = ac.AccountID
	AND		a.ContractID = ac.ContractID

	INNER	JOIN AccountStatus actS (nolock)
	ON		actS.AccountContractID = ac.AccountContractID

	INNER	JOIN #Static s
	ON		actS.Status = s.Status
	AND		actS.SubStatus = s.SubStatus
	AND		s.ISO = a.ISO
	AND		s.Zone = a.ZainetZone
	AND		s.Year = YEAR(DL.UsageDate)

	INNER     JOIN #A t3
	ON        a.ISO	= t3.ISO
	AND       a.ZainetZone = t3.Zone
	AND       DL.UsageDate = t3.DeliveryMonth	      
	WHERE     s.CounterParty = 'PlAttriEST'
       
	SELECT	DISTINCT 
			a.SignedDate, 
			a.ISO, 
			a.ZainetZone, 
			s.Zkey,
			--s.Book, 
			p.IsCustom,
			d.BackToBack,
			s.BuySell, 
			s.CounterParty, 
			DL.UsageDate, 
			SUM(DL.ETP*
			   (DL.Int1+DL.Int2+DL.Int3+DL.Int4+DL.Int4+DL.Int5+DL.Int6+DL.Int7+DL.Int7+DL.Int8+DL.Int9+DL.Int10+
			   DL.Int11+DL.Int12+DL.Int13+DL.Int14+DL.Int15+DL.Int16+DL.Int17+DL.Int18+DL.Int19+DL.Int20+
			   DL.Int21+DL.Int22+DL.Int23+DL.Int24))
		      /
			SUM(DL.Int1+DL.Int2+DL.Int3+DL.Int4+DL.Int4+DL.Int5+DL.Int6+DL.Int7+DL.Int7+DL.Int8+DL.Int9+DL.Int10+
			   DL.Int11+DL.Int12+DL.Int13+DL.Int14+DL.Int15+DL.Int16+DL.Int17+DL.Int18+DL.Int19+DL.Int20+
			   DL.Int21+DL.Int22+DL.Int23+DL.Int24)
			AS ETP,
			SUM(DL.Int1) AS Int1,
			SUM(DL.Int2) AS Int2,
			SUM(DL.Int3) AS Int3,
			SUM(DL.Int4) AS Int4,
			SUM(DL.Int5) AS Int5,
			SUM(DL.Int6) AS Int6,
			SUM(DL.Int7) AS Int7,
			SUM(DL.Int8) AS Int8,
			SUM(DL.Int9) AS Int9,
			SUM(DL.Int10) AS Int10,
			SUM(DL.Int11) AS Int11,
			SUM(DL.Int12) AS Int12,
			SUM(DL.Int13) AS Int13,
			SUM(DL.Int14) AS Int14,
			SUM(DL.Int15) AS Int15,
			SUM(DL.Int16) AS Int16,
			SUM(DL.Int17) AS Int17,
			SUM(DL.Int18) AS Int18,
			SUM(DL.Int19) AS Int19,
			SUM(DL.Int20) AS Int20,
			SUM(DL.Int21) AS Int21,
			SUM(DL.Int22) AS Int22,
			SUM(DL.Int23) AS Int23,
			SUM(DL.Int24) AS Int24,
		
			SUM(attV.Int1) AS Int1Att,
			SUM(attV.Int2) AS Int2Att,
			SUM(attV.Int3) AS Int3Att,
			SUM(attV.Int4) AS Int4Att,
			SUM(attV.Int5) AS Int5Att,
			SUM(attV.Int6) AS Int6Att,
			SUM(attV.Int7) AS Int7Att,
			SUM(attV.Int8) AS Int8Att,
			SUM(attV.Int9) AS Int9Att,
			SUM(attV.Int10) AS Int10Att,
			SUM(attV.Int11) AS Int11Att,
			SUM(attV.Int12) AS Int12Att,
			SUM(attV.Int13) AS Int13Att,
			SUM(attV.Int14) AS Int14Att,
			SUM(attV.Int15) AS Int15Att,
			SUM(attV.Int16) AS Int16Att,
			SUM(attV.Int17) AS Int17Att,
			SUM(attV.Int18) AS Int18Att,
			SUM(attV.Int19) AS Int19Att,
			SUM(attV.Int20) AS Int20Att,
			SUM(attV.Int21) AS Int21Att,
			SUM(attV.Int22) AS Int22Att,
			SUM(attV.Int23) AS Int23Att,
			SUM(attV.Int24) AS Int24Att		
	INTO	#MWAGF
	FROM	MtMDailyWholesaleLoadForecast DL (nolock)
      
	LEFT	JOIN #ATTValues attV
	ON		DL.ID = attV.ID

	INNER	JOIN #Account  a 
	ON		a.ID = DL.MtMAccountID
     
	INNER	JOIN AccountContract ac (nolock)
	ON		a.AccountID = ac.AccountID
	AND		a.ContractID = ac.ContractID

	INNER	JOIN AccountContractRate acr
	ON		ac.AccountContractID = acr.AccountContractID
	AND		acr.IsContractedRate = 1

	INNER	JOIN Lp_common..common_product p
	ON		acr.LegacyProductID = p.product_id

	LEFT	JOIN lp_deal_capture.dbo.deal_pricing_detail d
	ON		acr.RateID = d.rate_id
	AND		p.product_id = d.product_id
	AND		p.IsCustom = 1   
	--AND   d.BackToBack = 0

	INNER	JOIN AccountStatus actS (nolock)
	ON		actS.AccountContractID = ac.AccountContractID

	INNER	JOIN #Static s
	ON		actS.Status = s.Status
	AND		actS.SubStatus = s.SubStatus
	AND		s.ISO = a.ISO
	AND		s.Zone = a.ZainetZone
	AND		s.Year = YEAR(DL.UsageDate)
 -- WHERE	m.Status = 'ETPd'
 --	WHERE	p.IsCustom = 0
 --	OR		(p.IsCustom = 1   AND   d.BackToBack = 0) 

	GROUP	BY 
			a.SignedDate, 
			a.ISO, 
			a.ZainetZone, 
			s.Zkey,
			--s.Book, 
			p.IsCustom,
			d.BackToBack,
			s.BuySell, 
			s.CounterParty, 
			DL.UsageDate
		
	DELETE	#MWAGF
	WHERE	/*IsCustom = 1   
	AND		*/BackToBack = 1
     
       
      
	--UPDATE THE MWAGF BY THE Attrition values
	UPDATE	#MWAGF
	SET     Int1 = Int1Att,
      		Int2 = Int2Att,
	      	Int3 = Int3Att,
		  	Int4 = Int4Att,
      		Int5 = Int5Att,
	      	Int6 = Int6Att,
		  	Int7 = Int7Att,
      		Int8 = Int8Att,
      		Int9 = Int9Att,
      		Int10 = Int10Att,
      		Int11 = Int11Att,
      		Int12 = Int12Att,
      		Int13 = Int13Att,
      		Int14 = Int14Att,
      		Int15 = Int15Att,
      		Int16 = Int16Att,
      		Int17 = Int17Att,
      		Int18 = Int18Att,
      		Int19 = Int19Att,
      		Int20 = Int20Att,
      		Int21 = Int21Att,
      		Int22 = Int22Att,
      		Int23 = Int23Att,
      		Int24 = Int24Att
	FROM	#MWAGF t1      
	WHERE	CounterParty = 'PlAttriEST'
      
      
	ALTER TABLE #MWAGF DROP COLUMN Int1Att
	ALTER TABLE #MWAGF DROP COLUMN Int2Att
	ALTER TABLE #MWAGF DROP COLUMN Int3Att
	ALTER TABLE #MWAGF DROP COLUMN Int4Att
	ALTER TABLE #MWAGF DROP COLUMN Int5Att
	ALTER TABLE #MWAGF DROP COLUMN Int6Att
	ALTER TABLE #MWAGF DROP COLUMN Int7Att
	ALTER TABLE #MWAGF DROP COLUMN Int8Att
	ALTER TABLE #MWAGF DROP COLUMN Int9Att
	ALTER TABLE #MWAGF DROP COLUMN Int10Att
	ALTER TABLE #MWAGF DROP COLUMN Int11Att
	ALTER TABLE #MWAGF DROP COLUMN Int12Att
	ALTER TABLE #MWAGF DROP COLUMN Int13Att
	ALTER TABLE #MWAGF DROP COLUMN Int14Att
	ALTER TABLE #MWAGF DROP COLUMN Int15Att
	ALTER TABLE #MWAGF DROP COLUMN Int16Att
	ALTER TABLE #MWAGF DROP COLUMN Int17Att
	ALTER TABLE #MWAGF DROP COLUMN Int18Att
	ALTER TABLE #MWAGF DROP COLUMN Int19Att
	ALTER TABLE #MWAGF DROP COLUMN Int20Att
	ALTER TABLE #MWAGF DROP COLUMN Int21Att
	ALTER TABLE #MWAGF DROP COLUMN Int22Att
	ALTER TABLE #MWAGF DROP COLUMN Int23Att
	ALTER TABLE #MWAGF DROP COLUMN Int24Att
      
	SELECT	*
	FROM	#MWAGF
	
END



