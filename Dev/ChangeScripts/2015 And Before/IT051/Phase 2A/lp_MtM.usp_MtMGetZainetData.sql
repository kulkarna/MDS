USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMGetZainetData]    Script Date: 03/13/2013 13:46:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	6/26/2012																								*
 *	Descp:		get the data for a zKey to be processed and sent to Zainet												*
 *  To Run:		exec usp_MtMGetZainetData	'137251'															*
  *	Modified:																											*
 ************************************************************************************************************************/

ALTER PROCEDURE   [dbo].[usp_MtMGetZainetData] 
	@Zkey AS VARCHAR(50),
	@IsCustomDealUpload as bit = 0
AS

BEGIN
SET NOCOUNT ON; 

	DECLARE @CounterPartyID AS INT
	DECLARE @ZkeyYear AS INT
	DECLARE @Today AS DATETIME
	SET @Today = DATEADD(D, 0, DATEDIFF(D, 0, GETDATE()))

	CREATE TABLE #Account (
		MtMAccountID int,
		AccountID varchar(50),
		ContractID varchar(50),
		ZainetZone varchar(50),
		SignedDate datetime,
		ISO varchar(50),
		IsCustom VARCHAR(10),
		BackToBack int,
		AccountContractID varchar(50),
		CounterParty varchar(50),
		Zkey varchar(50),
		BuySell varchar(10),
		Book int,
		ZkeyYear int,
		Status varchar(50),
		SubStatus varchar(50),
		StartDate datetime,
		EndDate datetime,
		NextServiceDate datetime,
		ServiceEndDate datetime
	)

	-- The following was created because the query was taking a long time, a very long time (had to cancel it after 5 min)
	-- Seperating the ZKey/Counterparty tables and getting all that info and storing it in a non-normalized table
	-- made the query run in a sec
	SELECT	DISTINCT
			rs.Status, 
			rs.SubStatus, 
			r.CounterPartyID, 
			rc.CounterParty, 
			--rc.Book, 
			rc.BuySell,
			rz.ISO,
			rz.Zone,
			rz.Year,
			rz.Book,
			rzd.Zkey
	INTO	#Statuses
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

	WHERE	rzd.Zkey = @Zkey
	AND		rs.Inactive = 0

	CREATE NONCLUSTERED INDEX idx_STATUS_ALL ON #Statuses ([Status],SubStatus,ISO,Zone,Book )
--print '1- ' + CAST (GETDATE() AS VARCHAR(50))

	SELECT TOP 1 @CounterPartyID =  CounterPartyID, @ZkeyYear =  Year
	FROM	#Statuses
	
	SELECT	*
	INTO	#MtMAccount
	FROM	MtMAccount m (nolock)
	WHERE	m.Status = 'ETPd'

	--print '2- ' + CAST (GETDATE() AS VARCHAR(50))

	CREATE NONCLUSTERED INDEX idx_MtM_ID ON #MtMAccount (ID ASC)
	
	SELECT	m.*
	INTO	#MtMAccountMax
	FROM	#MtMAccount m
	INNER	JOIN MtMZainetMaxAccount maxAct (nolock)
	ON		m.ID = maxAct.ID
	
	--print '3- ' + CAST (GETDATE() AS VARCHAR(50))

	CREATE NONCLUSTERED INDEX idx_MtMMax_AccountID ON #MtMAccountMax (AccountID, ContractID)
	CREATE NONCLUSTERED INDEX idx_MtMMax_Zone ON #MtMAccountMax (Zone ASC)

	IF @IsCustomDealUpload = 0
		BEGIN
			--Getting non-custom deal
			INSERT INTO #Account

			SELECT	DISTINCT 
					m.ID as MtMAccountID,
					m.AccountID, 
					m.ContractID,
					zz.ZainetZone,
					act.SignedDate, 
					act.ISO,
					act.IsCustom, 
					act.BackToBack,
					act.AccountContractID,
					s.CounterParty,
					s.Zkey,
					s.BuySell,
					s.Book,
					s.Year as ZkeyYear,
					act.Status, act.SubStatus,
					act.StartDate,
					act.EndDate,
					act.NextServiceDate,
					act.ServiceEndDate
			FROM	#MtMAccountMax m
			
			INNER	JOIN  MtMZainetAccountInfo act (nolock)
			ON		m.ContractID = act.ContractID
			AND		m.AccountID = act.AccountID

			INNER	JOIN MtMZainetZones zz (nolock)
			ON		act.UtilityID = zz.UtilityID
			AND		m.Zone = zz.Zone	
			
			INNER	JOIN #Statuses s
			ON		act.Status = s.Status
			AND		act.SubStatus = s.SubStatus
			AND		s.ISO = act.ISO
			AND		s.Zone = zz.ZainetZone
			AND		s.Book = act.IsCustom

			-- in case the flow end date has a value, we need to use this date as this indicates that the accounts is set to de-enroll earlier than the contract end date
			WHERE	ISNULL(act.ServiceEndDate,act.EndDate)  >= @Today 
			AND		ISNULL(BackToBack,'0') = '0'
		END
	ELSE
		BEGIN
			/*****************************************************
			BEGIN: Getting NEW custom deals with ContractID is NULL
			******************************************************/
			INSERT	INTO #Account
			SELECT	DISTINCT
					m.ID as MtMAccountID,								
					m.AccountID,
					m.ContractID,
					zz.ZainetZone,
					c.ContractStartDate as SignedDate,
					u.WholeSaleMktID as ISO,
					1 as IsCustom,
					c.BackToBack,
					NULL as AccountContractID,
					s.CounterParty,
					s.Zkey,
					s.BuySell,
					s.Book,
					s.Year as ZkeyYear,
					'Status' as Status,
					'SubStatus' as SubStatus,
					c.ContractStartDate as StartDate,
					DATEADD(m, Term, c.ContractStartDate) as EndDate,
					c.ContractStartDate as NextServiceDate,
					NULL as ServiceEndDate
			FROM	MtMAccount m (nolock)
			INNER	JOIN lp_deal_capture..deal_pricing d (nolock) ON m.DealPricingID = d.deal_pricing_id
			INNER	JOIN MtMCustomDealHeader c (nolock) ON d.pricing_request_id = c.PricingRequest
			INNER	JOIN LibertyPower..Account act (nolock) ON m.AccountID = act.AccountID
			INNER	JOIN MtMCustomDealAccount ca (nolock) ON c.ID = ca.CustomDealID AND ca.AccountNumber = act.AccountNumber
			INNER	JOIN LibertyPower..Utility u (nolock) ON u.ID = act.UtilityID
			INNER	JOIN MtMZainetZones zz (nolock) ON act.UtilityID = zz.UtilityID AND m.Zone = zz.Zone
			INNER	JOIN #Statuses s ON s.ISO = u.WholeSaleMktID AND s.Zone = zz.ZainetZone AND s.Book = 1
			WHERE	m.ContractID is null
			and		PATINDEX('CustomDealUpload-%', m.QuoteNumber) >= 1
			/*****************************************************
			END: Getting NEW custom deals with ContractID is NULL
			******************************************************/
			/*******************************
			BEGIN: Getting OLD custom deals and NEW with ContractID is not NULL
			********************************/
			INSERT INTO #Account
			SELECT	DISTINCT
					m.ID as MtMAccountID,
					m.AccountID,
					m.ContractID,
					zz.ZainetZone,
					act.SignedDate,
					act.ISO,
					act.IsCustom,
					act.BackToBack,
					act.AccountContractID,
					s.CounterParty,
					s.Zkey,
					s.BuySell,
					s.Book,
					s.Year as ZkeyYear,
					act.Status, act.SubStatus,
					act.StartDate,
					act.EndDate,
					act.NextServiceDate,
					act.ServiceEndDate
			FROM	#MtMAccountMax m
			INNER	JOIN MtMZainetAccountInfo act (nolock) 
			ON		m.ContractID = act.ContractID
			AND		m.AccountID = act.AccountID
			INNER	JOIN MtMZainetZones zz (nolock) 
			ON		act.UtilityID = zz.UtilityID
			AND		m.Zone = zz.Zone
			INNER	JOIN #Statuses s 
			ON		act.Status = s.Status
			AND		act.SubStatus = s.SubStatus
			AND		s.ISO = act.ISO
			AND		s.Zone = zz.ZainetZone
			AND		s.Book = act.IsCustom
			-- in case the flow end date has a value, we need to use this date as this indicates that the accounts is set to de-enroll earlier than the contract end date
			WHERE	ISNULL(act.ServiceEndDate,act.EndDate) >= @Today
			and		(
					PATINDEX('CustomDealUpload-%', m.QuoteNumber) = 0
					or
					(	PATINDEX('CustomDealUpload-%', m.QuoteNumber) >= 1 
						and	m.ContractId is not null	)
					)
		/*****************************
		END: Getting OLD custom deals and NEW with ContractID is not NULL
		******************************/
	END
	
	--print '4- ' + CAST (GETDATE() AS VARCHAR(50))
	CREATE NONCLUSTERED INDEX idx_Account_IZ ON #Account (ISO, ZainetZone)
	CREATE NONCLUSTERED INDEX idx_Account_ID ON #Account (MtMAccountID)
	
	IF (@CounterPartyID = 1 OR @CounterPartyID = 2)
		BEGIN
	
	   --GET ATTRITION PERCENTAGE
		SELECT	a.ISO, a.ZainetZone,MAX(s.EffectiveDate) as EffectiveDate--, a.SignedDate
		INTO	#ATT
		FROM	#Account a
		LEFT	JOIN MtMAttritionMostRecentEffectiveDate s (nolock)
		ON		s.ISO = a.ISO	  
		AND		s.Zone = a.ZainetZone
		AND		s.EffectiveDate <= @Today
		GROUP	BY a.ISO, a.ZainetZone--, a.SignedDate

--print '5- ' + CAST (GETDATE() AS VARCHAR(50))

		--get the max date	   
		UPDATE	t1
		SET		t1.EffectiveDate = t2.EffectiveDate
		FROM	#ATT t1
		INNER	JOIN 
		(
			SELECT	l.ISO, l.Zone, MAX(EffectiveDate) as EffectiveDate
			FROM	MtMAttritionMostRecentEffectiveDate l (nolock)
			GROUP	BY l.ISO, l.Zone
		) t2
		ON		t1.ISO = t2.ISO
		AND		t1.ZainetZone = t2.Zone
		WHERE	t1.EffectiveDate IS NULL

--print '6- ' + CAST (GETDATE() AS VARCHAR(50))

		SELECT	DISTINCT /*t2.EffectiveDate,*/ t2.DeliveryMonth, t2.ISO, t2.Zone, t2.Attrition--, SignedDate
		INTO	#A
		FROM	#ATT t1
		INNER	JOIN MtMAttritionMostRecentEffectiveDate t3 (nolock)
		ON		t1.ISO = t3.ISO
		AND		t1.ZainetZone = t3.Zone
		AND		t1.EffectiveDate = t3.EffectiveDate 
		INNER	JOIN MtMAttrition t2 (nolock)
		ON		t2.ISO = t3.ISO
		AND		t2.Zone = t3.Zone
		AND		t2.EffectiveDate = t3.EffectiveDate 
		AND		t2.FileLogID = t3.FileLogID

--print '7- ' + CAST (GETDATE() AS VARCHAR(50))

		CREATE NONCLUSTERED INDEX idx_A_IZD ON #A (ISO, Zone, DeliveryMonth)	
		
		SELECT	DL.*, a.ISO, a.ZainetZone
		INTO	#Usage
		FROM	MtMDailyWholesaleLoadForecast DL (nolock)

		INNER	JOIN #Account  a 
		ON		a.MtMAccountID = DL.MtMAccountID   
	    WHERE	YEAR(DL.UsageDate) = @ZkeyYear
		AND		DL.UsageDate <= a.EndDate
		AND		DL.UsageDate >= CASE	WHEN a.StartDate >= ISNULL(a.NextServiceDate,@Today) AND a.StartDate >= @Today THEN a.StartDate  
										WHEN a.NextServiceDate > a.StartDate AND a.NextServiceDate > @Today THEN a.NextServiceDate
										ELSE @Today
								END
--print '8- ' + CAST (GETDATE() AS VARCHAR(50))

		CREATE NONCLUSTERED INDEX idx_U_ID ON #Usage (MtMAccountID ASC)
		CREATE NONCLUSTERED INDEX idx_U_Date ON #Usage (UsageDate ASC)
 		CREATE NONCLUSTERED INDEX idx_U_ISO ON #Usage (ISO ASC)
		CREATE NONCLUSTERED INDEX idx_U_Zone ON #Usage (ZainetZone ASC)
 
 
		SELECT	DISTINCT 
				--DL.ID,
				DL.MtMAccountID, DL.UsageDate, DL.ETP,
				Int1,Int2,Int3,Int4,Int5,Int6,Int7,Int8,Int9,Int10,Int11,Int12,Int13,Int14,Int15,Int16,Int17,Int18,Int19,Int20,Int21,Int22,Int23,Int24,
				AttInt1 = (DL.Int1)*t3.Attrition,
      			AttInt2 = (DL.Int2)*t3.Attrition,
      			AttInt3 = (DL.Int3)*t3.Attrition,
      			AttInt4 = (DL.Int4)*t3.Attrition,
      			AttInt5 = (DL.Int5)*t3.Attrition,
      			AttInt6 = (DL.Int6)*t3.Attrition,
      			AttInt7 = (DL.Int7)*t3.Attrition,
      			AttInt8 = (DL.Int8)*t3.Attrition,
      			AttInt9 = (DL.Int9)*t3.Attrition,
      			AttInt10 = (DL.Int10)*t3.Attrition,
      			AttInt11 = (DL.Int11)*t3.Attrition,
      			AttInt12 = (DL.Int12)*t3.Attrition,
      			AttInt13 = (DL.Int13)*t3.Attrition,
      			AttInt14 = (DL.Int14)*t3.Attrition,
      			AttInt15 = (DL.Int15)*t3.Attrition,
      			AttInt16 = (DL.Int16)*t3.Attrition,
      			AttInt17 = (DL.Int17)*t3.Attrition,
      			AttInt18 = (DL.Int18)*t3.Attrition,
      			AttInt19 = (DL.Int19)*t3.Attrition,
      			AttInt20 = (DL.Int20)*t3.Attrition,
      			AttInt21 = (DL.Int21)*t3.Attrition,
      			AttInt22 = (DL.Int22)*t3.Attrition,
      			AttInt23 = (DL.Int23)*t3.Attrition,
      			AttInt24 = (DL.Int24)*t3.Attrition
		INTO	#ATTValues
		FROM	#Usage DL (nolock)

		--INNER	JOIN #Account  a 
		--ON		a.MtMAccountID = DL.MtMAccountID
	     
		INNER     JOIN #A t3
		ON        DL.ISO	= t3.ISO
		AND       DL.ZainetZone = t3.Zone
		--AND		  a.SignedDate = t3.SignedDate
		AND       YEAR(DL.UsageDate) = YEAR(t3.DeliveryMonth)
		AND       MONTH(DL.UsageDate) = MONTH(t3.DeliveryMonth)	               

		CREATE NONCLUSTERED INDEX idx_ATTValues_ID ON #ATTValues (MtMAccountID)

--print '9- ' + CAST (GETDATE() AS VARCHAR(50))
	    
	 --   WHERE	YEAR(DL.UsageDate) = @ZkeyYear
		--AND		DL.UsageDate <= a.EndDate
		--AND		DL.UsageDate >= CASE	WHEN a.StartDate >= ISNULL(a.NextServiceDate,@Today) AND a.StartDate >= @Today THEN a.StartDate  
		--								WHEN a.NextServiceDate > a.StartDate AND a.NextServiceDate > @Today THEN a.NextServiceDate
		--								ELSE @Today
		--						END

	    --INSERT	INTO #MWAGF
		SELECT	DISTINCT 
				a.ISO, 
				a.ZainetZone, 
				a.Zkey,
				a.ZkeyYear, 
				--s.Book, 
				a.IsCustom,
				a.BackToBack,
				a.BuySell, 
				a.CounterParty, 
				DL.UsageDate, 
				SUM(DL.ETP*
				   (DL.Int1+DL.Int2+DL.Int3+DL.Int4+DL.Int5+DL.Int6+DL.Int7+DL.Int8+DL.Int9+DL.Int10+
				   DL.Int11+DL.Int12+DL.Int13+DL.Int14+DL.Int15+DL.Int16+DL.Int17+DL.Int18+DL.Int19+DL.Int20+
				   DL.Int21+DL.Int22+DL.Int23+DL.Int24))
				  /
				SUM(DL.Int1+DL.Int2+DL.Int3+DL.Int4+DL.Int5+DL.Int6+DL.Int7+DL.Int8+DL.Int9+DL.Int10+
				   DL.Int11+DL.Int12+DL.Int13+DL.Int14+DL.Int15+DL.Int16+DL.Int17+DL.Int18+DL.Int19+DL.Int20+
				   DL.Int21+DL.Int22+DL.Int23+DL.Int24)
				AS ETP,
				SUM(AttInt1) AS Int1,
				SUM(AttInt2) AS Int2,
				SUM(AttInt3) AS Int3,
				SUM(AttInt4) AS Int4,
				SUM(AttInt5) AS Int5,
				SUM(AttInt6) AS Int6,
				SUM(AttInt7) AS Int7,
				SUM(AttInt8) AS Int8,
				SUM(AttInt9) AS Int9,
				SUM(AttInt10) AS Int10,
				SUM(AttInt11) AS Int11,
				SUM(AttInt12) AS Int12,
				SUM(AttInt13) AS Int13,
				SUM(AttInt14) AS Int14,
				SUM(AttInt15) AS Int15,
				SUM(AttInt16) AS Int16,
				SUM(AttInt17) AS Int17,
				SUM(AttInt18) AS Int18,
				SUM(AttInt19) AS Int19,
				SUM(AttInt20) AS Int20,
				SUM(AttInt21) AS Int21,
				SUM(AttInt22) AS Int22,
				SUM(AttInt23) AS Int23,
				SUM(AttInt24) AS Int24
		FROM	#ATTValues DL /*attV*/ (nolock)

		--INNER	JOIN MtMDailyWholesaleLoadForecast DL (nolock)
		--ON		attV.ID = DL.ID
		
		INNER	JOIN #Account  a 
		ON		a.MtMAccountID = DL.MtMAccountID
    
		GROUP	BY 
				a.ISO, 
				a.ZainetZone, 
				a.Zkey,
				a.ZkeyYear,
				--s.Book, 
				a.IsCustom,
				a.BackToBack,
				a.BuySell, 
				a.CounterParty,
				DL.UsageDate

		HAVING	SUM(DL.Int1+DL.Int2+DL.Int3+DL.Int4+DL.Int5+DL.Int6+DL.Int7+DL.Int8+DL.Int9+DL.Int10+
				   DL.Int11+DL.Int12+DL.Int13+DL.Int14+DL.Int15+DL.Int16+DL.Int17+DL.Int18+DL.Int19+DL.Int20+
				   DL.Int21+DL.Int22+DL.Int23+DL.Int24) > 0				

--print '10- ' + CAST (GETDATE() AS VARCHAR(50))

		END
	ELSE	
		BEGIN
			
			SELECT	DL.*, a.ISO, a.ZainetZone
			INTO	#UsageAtt
			FROM	MtMDailyWholesaleLoadForecast DL (nolock)

			INNER	JOIN #Account  a 
			ON		a.MtMAccountID = DL.MtMAccountID   
			WHERE	YEAR(DL.UsageDate) = @ZkeyYear
    		-- in case the flow end date has a value, we need to use this date as this indicates that the account is set to de-enroll earlier than the contract end date
			AND		DL.UsageDate >= CASE WHEN a.StartDate > @Today THEN a.StartDate ELSE @Today END
			AND		DL.UsageDate <= ISNULL(a.ServiceEndDate,a.EndDate)   			


		CREATE NONCLUSTERED INDEX idx_U_ID ON #UsageAtt (MtMAccountID ASC)
		CREATE NONCLUSTERED INDEX idx_U_Date ON #UsageAtt (UsageDate ASC)
			
		--INSERT	INTO #MWAGF
		SELECT	
					a.ISO, 
					a.ZainetZone, 
					a.Zkey,
					a.ZkeyYear, 
					a.IsCustom,
					a.BackToBack,
					a.BuySell, 
					a.CounterParty, 
					DL.UsageDate, 
					SUM(DL.ETP*
					   (DL.Int1+DL.Int2+DL.Int3+DL.Int4+DL.Int5+DL.Int6+DL.Int7+DL.Int8+DL.Int9+DL.Int10+
					   DL.Int11+DL.Int12+DL.Int13+DL.Int14+DL.Int15+DL.Int16+DL.Int17+DL.Int18+DL.Int19+DL.Int20+
					   DL.Int21+DL.Int22+DL.Int23+DL.Int24))
					  /
					SUM(DL.Int1+DL.Int2+DL.Int3+DL.Int4+DL.Int5+DL.Int6+DL.Int7+DL.Int8+DL.Int9+DL.Int10+
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
			FROM	#UsageAtt DL (nolock)
		      
			INNER	JOIN #Account  a 
			ON		a.MtMAccountID = DL.MtMAccountID     
			--WHERE	YEAR(DL.UsageDate) = @ZkeyYear
   -- 		-- in case the flow end date has a value, we need to use this date as this indicates that the account is set to de-enroll earlier than the contract end date
			--AND		DL.UsageDate >= CASE WHEN a.StartDate > @Today THEN a.StartDate ELSE @Today END
			--AND		DL.UsageDate <= ISNULL(a.ServiceEndDate,a.EndDate)   			

			GROUP	BY 
					a.ISO, 
					a.ZainetZone, 
					a.Zkey,
					a.ZkeyYear,
					a.IsCustom,
					a.BackToBack,
					a.BuySell, 
					a.CounterParty,
					DL.UsageDate
			
			HAVING	SUM(DL.Int1+DL.Int2+DL.Int3+DL.Int4+DL.Int5+DL.Int6+DL.Int7+DL.Int8+DL.Int9+DL.Int10+
					   DL.Int11+DL.Int12+DL.Int13+DL.Int14+DL.Int15+DL.Int16+DL.Int17+DL.Int18+DL.Int19+DL.Int20+
					   DL.Int21+DL.Int22+DL.Int23+DL.Int24) > 0
		END			

SET NOCOUNT OFF; 

END



