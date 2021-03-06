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
      SELECT      DISTINCT
		rs.Status, 
		rs.SubStatus, 
		r.ReportDescription, 
		rc.CounterParty, 
		--rc.Book, 
		rc.BuySell,
		rz.ISO,
		rz.Zone,
		rz.ZoneAlias,
		rzd.Zkey
      INTO  #Static
      FROM  MtMReportStatus rs (nolock)

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

      ORDER BY 
		rs.Status, 
		rs.SubStatus, 
		rz.ISO,
		rz.Zone

		-- GET the list of accounts that are eligible to be included in the Zainet
		SELECT	AccountID, ContractID, MAX(ID) AS ID
		INTO	#Account
		FROM	MtMAccount
		WHERE	Status = 'ETPd'
		GROUP	BY AccountID, ContractID

      SELECT      DISTINCT 
		c.SignedDate, 
		u.WholeSaleMktID AS ISO, 
		w.TimeZone,
		s.ZoneAlias, 
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
		SUM(DL.Int24) AS Int24
      
      INTO  #MWAGF
      FROM  MtMDailyWholesaleLoadForecast DL (nolock)

      INNER JOIN #Account  a 
      ON	 a.ID = DL.MtMAccountID

      INNER JOIN MtMAccount  m (nolock)
      ON	 m.ID = a.ID

      INNER JOIN  Contract c (nolock)
      ON	 m.ContractID = c.ContractID

      INNER JOIN Account act (nolock)
      ON	 m.AccountID = act.AccountID

      INNER JOIN Utility u (nolock)
      ON	 act.UtilityID = u.ID

	  INNER	JOIN MtMZainetZones zz
	  ON		u.ID = zz.UtilityID
	  AND		m.Zone = zz.Zone
      
      INNER JOIN WholesaleMarket w (nolock)
      ON	 w.WholesaleMktId = u.WholeSaleMktID

      INNER JOIN AccountContract ac (nolock)
      ON	 act.AccountID = ac.AccountID
      AND	c.ContractID = ac.ContractID

      INNER JOIN AccountContractRate acr
      ON	ac.AccountContractID = acr.AccountContractID
      AND	acr.IsContractedRate = 1

      INNER JOIN Lp_common..common_product p
      ON	 acr.LegacyProductID = p.product_id

      LEFT  JOIN lp_deal_capture.dbo.deal_pricing_detail d
      ON	acr.RateID = d.rate_id
      AND	p.product_id = d.product_id
      AND	p.IsCustom = 1   
      --AND   d.BackToBack = 0

      INNER JOIN AccountStatus actS (nolock)
      ON	 actS.AccountContractID = ac.AccountContractID

      INNER	JOIN #Static s
      ON	actS.Status = s.Status
      AND	actS.SubStatus = s.SubStatus
      AND	s.ISO = u.WholeSaleMktID
      AND	s.Zone = zz.ZainetZone

	 -- WHERE	m.Status = 'ETPd'
	  
      --WHERE		p.IsCustom = 0
      --OR        (p.IsCustom = 1   AND   d.BackToBack = 0) 

      GROUP BY 
		c.SignedDate, 
		u.WholeSaleMktID, 
		w.TimeZone,
		s.ZoneAlias, 
		s.Zkey,
		--s.Book, 
		p.IsCustom,
		d.BackToBack,
		s.BuySell, 
		s.CounterParty, 
		DL.UsageDate


		DELETE	#MWAGF
		WHERE	IsCustom = 1   
		AND		BackToBack = 1

      -- GET ETP
      --SELECT    *
      --INTO      #ETF
      --FROM      #MWAGF
      --WHERE     CounterParty = 'PlDeenroll'
      
      --From the deenrolled accounts, only keep the ET: deenrolled date < contract end date and contract end date > today
      /*SELECT	*
      FROM		AccountLatestService  als
      INNER		JOIN #Account a
      ON		a.AccountID = als.AccountID
      INNER		JOIN Contract c
	  ON		a.ContractID = c.ContractID
	  WHERE		als.EndDate IS NOT NULL
	  AND		als.EndDate < c.EndDate
	  AND		c.EndDate > GETDATE()
	  */
      
      --GET ATTRITION PERCENTAGE
      SELECT      a.ISO, 
		a.ZoneAlias,
		MIN(s.EffectiveDate) as EffectiveDate
      INTO  #ATT
      FROM  #MWAGF a

      LEFT  JOIN MtMAttrition s
      ON	 s.ISO = a.ISO	  
      AND	s.Zone = a.ZoneAlias
      AND	s.EffectiveDate >= a.SignedDate
		
      GROUP BY a.ISO, a.ZoneAlias
      Order by MIN(s.EffectiveDate)

      --get the max date	   
      UPDATE      t1
      SET	t1.EffectiveDate = t2.EffectiveDate
      FROM  #ATT t1
      INNER JOIN 
		(
		      SELECT      l.ISO, l.Zone, MAX(EffectiveDate) as EffectiveDate
		      FROM  [LibertyPower].[dbo].[MtMAttrition] l
		      GROUP BY l.ISO, l.Zone
		) t2
      ON	 t1.ISO = t2.ISO
      AND	t1.ZoneAlias = t2.Zone

      WHERE t1.EffectiveDate IS NULL

      Select      t2.EffectiveDate, t2.DeliveryMonth, t2.ISO, t2.Zone, t2.Attrition
      INTO  #A
      FROM  #ATT t1
      INNER JOIN MtMAttrition t2
      ON	 t1.ISO = t2.ISO
      AND	t1.ZoneAlias = t2.Zone
      AND	t1.EffectiveDate = t2.EffectiveDate 
      
      --UPDATE THE MWAGF BY THE MWATF
      UPDATE    t1
      SET       
		 t1.Int1 = (t1.Int1)*t3.Attrition,
      	 t1.Int2 = (t1.Int2)*t3.Attrition,
      	 t1.Int3 = (t1.Int3)*t3.Attrition,
      	 t1.Int4 = (t1.Int4)*t3.Attrition,
      	 t1.Int5 = (t1.Int5)*t3.Attrition,
      	 t1.Int6 = (t1.Int6)*t3.Attrition,
      	 t1.Int7 = (t1.Int7)*t3.Attrition,
      	 t1.Int8 = (t1.Int8)*t3.Attrition,
      	 t1.Int9 = (t1.Int9)*t3.Attrition,
      	 t1.Int10 = (t1.Int10)*t3.Attrition,
      	 t1.Int11 = (t1.Int11)*t3.Attrition,
      	 t1.Int12 = (t1.Int12)*t3.Attrition,
      	 t1.Int13 = (t1.Int13)*t3.Attrition,
      	 t1.Int14 = (t1.Int14)*t3.Attrition,
      	 t1.Int15 = (t1.Int15)*t3.Attrition,
      	 t1.Int16 = (t1.Int16)*t3.Attrition,
      	 t1.Int17 = (t1.Int17)*t3.Attrition,
      	 t1.Int18 = (t1.Int18)*t3.Attrition,
      	 t1.Int19 = (t1.Int19)*t3.Attrition,
      	 t1.Int20 = (t1.Int20)*t3.Attrition,
      	 t1.Int21 = (t1.Int21)*t3.Attrition,
      	 t1.Int22 = (t1.Int22)*t3.Attrition,
      	 t1.Int23 = (t1.Int23)*t3.Attrition,
      	 t1.Int24 = (t1.Int24)*t3.Attrition
		
      FROM      #MWAGF t1
     
      INNER     JOIN #A t3
      ON        t1.ISO		= t3.ISO
      AND       t1.ZoneAlias      = t3.Zone
      AND       t1.UsageDate      = t3.DeliveryMonth
      AND       MONTH(t1.UsageDate)     = MONTH(t3.DeliveryMonth)
      AND       DAY(t1.UsageDate) = DAY(t3.DeliveryMonth)
      AND       YEAR(t1.UsageDate)      = YEAR(t3.DeliveryMonth)
		      
      WHERE     t1.CounterParty = 'PlAttriEST'
      
      
      
      SELECT      *
      FROM  #MWAGF
END

