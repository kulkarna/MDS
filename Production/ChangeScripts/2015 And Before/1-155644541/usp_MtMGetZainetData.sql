USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMGetZainetData]    Script Date: 07/25/2013 15:24:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	6/26/2012																								*
 *	Descp:		get the data for a zKey to be processed and sent to Zainet												*
 *  To Run:		exec usp_MtMGetZainetData '214457', 1	
  *	Modified:	Replace DealPricingID with CustomDealID																	*
 ************************************************************************************************************************/

ALTER PROCEDURE   [dbo].[usp_MtMGetZainetData] 
	@Zkey AS VARCHAR(50),
	@IsCustomDealUpload as bit = 0,
	@RunDate AS DATE= NULL
AS

BEGIN
SET NOCOUNT ON; 

	DECLARE @CounterPartyID AS INT
	DECLARE @ZkeyYear AS INT
	DECLARE @Today AS DATETIME
	SET @Today = DATEADD(D, 0, DATEDIFF(D, 0, GETDATE()))
	
	IF (@RunDate IS NULL)
		SET	@RunDate = CAST (@Today AS DATE)

	CREATE TABLE #Account (
		MtMAccountID int,
		AccountID varchar(50),
		ContractID varchar(50),
		ZainetZone varchar(50),
		SignedDate datetime,
		ISO varchar(50),
		IsDaily bit,
		CounterParty varchar(50),
		Zkey varchar(50),
		BuySell varchar(10),
		Book bit,
		ZkeyYear int,
		Status varchar(50),
		SubStatus varchar(50),
		StartDate datetime,
		EndDate datetime	)

	CREATE TABLE #Usage (
		ID				int,
		MtMAccountID	int,
		UsageDate		datetime,
		ETP				float,
		Int1			decimal(14, 4),Int2  decimal(14, 4),Int3  decimal(14, 4),Int4  decimal(14, 4),Int5  decimal(14, 4),Int6  decimal(14, 4),Int7  decimal(14, 4),Int8  decimal(14, 4),
		Int9			decimal(14, 4),Int10 decimal(14, 4),Int11 decimal(14, 4),Int12 decimal(14, 4),Int13 decimal(14, 4),Int14 decimal(14, 4),Int15 decimal(14, 4),Int16 decimal(14, 4),
		Int17			decimal(14, 4),Int18 decimal(14, 4),Int19 decimal(14, 4),Int20 decimal(14, 4),Int21 decimal(14, 4),Int22 decimal(14, 4),Int23 decimal(14, 4),Int24 decimal(14, 4),
		ISO				varchar(50),
		ZainetZone		varchar(50),
		Zkey			varchar(50),
		ZkeyYear		int,
		IsDaily			bit,
		BuySell			varchar(10),
		CounterParty	varchar(50),	
		StartDate		Datetime,
		EndDate			DateTime	)		
		
	CREATE TABLE #UsageID (
		MtMAccountID	int,
		UsageDate		datetime )
		
	CREATE TABLE #UsageData (
		ID				int,
		MtMAccountID	int,
		UsageDate		datetime,
		ETP				float,
		Int1			decimal(14, 4),Int2  decimal(14, 4),Int3  decimal(14, 4),Int4  decimal(14, 4),Int5  decimal(14, 4),Int6  decimal(14, 4),Int7  decimal(14, 4),Int8  decimal(14, 4),
		Int9			decimal(14, 4),Int10 decimal(14, 4),Int11 decimal(14, 4),Int12 decimal(14, 4),Int13 decimal(14, 4),Int14 decimal(14, 4),Int15 decimal(14, 4),Int16 decimal(14, 4),
		Int17			decimal(14, 4),Int18 decimal(14, 4),Int19 decimal(14, 4),Int20 decimal(14, 4),Int21 decimal(14, 4),Int22 decimal(14, 4),Int23 decimal(14, 4),Int24 decimal(14, 4) )
	
	CREATE TABLE #Final (
		ISO				varchar(50),
		ZainetZone		varchar(50),
		Zkey			varchar(50),
		ZkeyYear		int,
		IsDaily			bit,
		BuySell			varchar(10),
		CounterParty	varchar(50),
		UsageDate		datetime,
		ETP				float,
		Int1			decimal(14, 4),Int2  decimal(14, 4),Int3  decimal(14, 4),Int4  decimal(14, 4),Int5  decimal(14, 4),Int6  decimal(14, 4),Int7  decimal(14, 4),Int8  decimal(14, 4),
		Int9			decimal(14, 4),Int10 decimal(14, 4),Int11 decimal(14, 4),Int12 decimal(14, 4),Int13 decimal(14, 4),Int14 decimal(14, 4),Int15 decimal(14, 4),Int16 decimal(14, 4),
		Int17			decimal(14, 4),Int18 decimal(14, 4),Int19 decimal(14, 4),Int20 decimal(14, 4),Int21 decimal(14, 4),Int22 decimal(14, 4),Int23 decimal(14, 4),Int24 decimal(14, 4)	)		
		
	CREATE TABLE #SUM (
		ISO				varchar(50),
		ZainetZone		varchar(50),
		Zkey			varchar(50),
		ZkeyYear		int,
		IsDaily			bit,
		BuySell			varchar(10),
		CounterParty	varchar(50),
		UsageDate		datetime,
		ETP				float,
		Int1			decimal(14, 4),Int2  decimal(14, 4),Int3  decimal(14, 4),Int4  decimal(14, 4),Int5  decimal(14, 4),Int6  decimal(14, 4),Int7  decimal(14, 4),Int8  decimal(14, 4),
		Int9			decimal(14, 4),Int10 decimal(14, 4),Int11 decimal(14, 4),Int12 decimal(14, 4),Int13 decimal(14, 4),Int14 decimal(14, 4),Int15 decimal(14, 4),Int16 decimal(14, 4),
		Int17			decimal(14, 4),Int18 decimal(14, 4),Int19 decimal(14, 4),Int20 decimal(14, 4),Int21 decimal(14, 4),Int22 decimal(14, 4),Int23 decimal(14, 4),Int24 decimal(14, 4)	)		
		
	-- The following was created because the query was taking a long time, a very long time (had to cancel it after 5 min)
	-- Seperating the ZKey/Counterparty tables and getting all that info and storing it in a non-normalized table
	-- made the query run in a sec
	SELECT	DISTINCT
			rs.Status, rs.SubStatus, r.CounterPartyID, rc.CounterParty, rc.BuySell,	rz.ISO,	rz.Zone, rz.Year, rz.Book, rzd.Zkey
	INTO	#Statuses
	FROM	MtMReportStatus rs (nolock)
	INNER	JOIN MtMReport r (nolock)
	ON		rs.ReportID = r.ReportID
	AND		r.Inactive = 0
	INNER	JOIN MtMReportCounterParty rc (nolock)
	ON		r.CounterPartyID = rc.CounterPartyID
	INNER	JOIN MtMReportZkeyDetail rzd (nolock)
	ON		rzd.CounterPartyID = r.CounterPartyID
	INNER	JOIN MtMReportZkey rz (nolock)
	ON		rzd.ZkeyID = rz.ZkeyID
	WHERE	rzd.Zkey = @Zkey
	AND		rs.Inactive = 0

	CREATE NONCLUSTERED INDEX idx_STATUS_ALL ON #Statuses ([Status],SubStatus,ISO,Zone,Book )   WITH (FILLFACTOR = 100)

	SELECT TOP 1 @CounterPartyID =  CounterPartyID, @ZkeyYear =  Year
	FROM	#Statuses

	IF @IsCustomDealUpload = 0
		BEGIN
			--Getting non-custom deal
			INSERT INTO #Account
			SELECT	DISTINCT m.ID as MtMAccountID,
					m.AccountID, m.ContractID,zz.ZainetZone,act.SignedDate, act.ISO,act.IsDaily, s.CounterParty, s.Zkey,s.BuySell,s.Book,s.Year as ZkeyYear,
					act.Status, act.SubStatus, ZainetStartDate as StartDate, ZainetEndDate as EndDate
			FROM	MtMZainetMaxAccount m (nolock)
			INNER	JOIN  MtMZainetAccountInfo act WITH (nolock, FORCESEEK )
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
			AND		s.Book = ~act.IsDaily
			-- in case the flow end date has a value, we need to use this date as this indicates that the accounts is set to de-enroll earlier than the contract end date
			WHERE	ZainetEndDate  >= @Today 
			AND		ISNULL(BackToBack,0) = 0
		END
	ELSE
		BEGIN
			--Getting NEW custom deals with ContractID is NULL
			INSERT	INTO #Account
			SELECT	DISTINCT m.ID as MtMAccountID,								
					m.AccountID,m.ContractID,zz.ZainetZone,c.ContractStartDate as SignedDate,u.WholeSaleMktID as ISO,0 as IsDaily,s.CounterParty,s.Zkey,s.BuySell,s.Book,
					s.Year as ZkeyYear,'Status' as Status,'SubStatus' as SubStatus,
					--c.ContractStartDate as StartDate,
					--c.ContractStartDate as NextServiceDate,NULL as ServiceEndDate,				
					StartDate = CASE	WHEN c.ContractStartDate >= @Today THEN c.ContractStartDate  
									ELSE @Today
								END,
					DATEADD(m, Term, c.ContractStartDate) as EndDate				
			FROM	MtMZainetMaxAccount m (nolock)
			INNER	JOIN LibertyPower..Account act (nolock) 
			ON		m.AccountID = act.AccountID
			INNER	JOIN MtMCustomDealAccount ca (nolock) 
			ON		m.CustomDealID = ca.CustomDealID 
			AND		ca.AccountNumber = act.AccountNumber
			INNER	JOIN MtMCustomDealHeader c (nolock) 
			ON		c.ID = ca.CustomDealID
			INNER	JOIN LibertyPower..Utility u (nolock) 
			ON		u.ID = act.UtilityID
			INNER	JOIN MtMZainetZones zz (nolock) 
			ON		act.UtilityID = zz.UtilityID
			AND		m.Zone = zz.Zone
			INNER	JOIN #Statuses s 
			ON		s.ISO = u.WholeSaleMktID 
			AND		s.Zone = zz.ZainetZone 
			AND		s.Book = 1
			WHERE	@CounterPartyID = 1
			AND		m.ContractID is null
			and		PATINDEX('%CustomDealUpload%', m.QuoteNumber) > 0
			AND		DATEADD(m, Term, c.ContractStartDate) >= @Today
			
			--Getting OLD custom deals and NEW with ContractID is not NULL
			INSERT INTO #Account
			SELECT	DISTINCT
					m.ID as MtMAccountID,
					m.AccountID,m.ContractID,zz.ZainetZone,act.SignedDate,act.ISO,act.IsDaily,s.CounterParty,s.Zkey,s.BuySell,s.Book,s.Year as ZkeyYear,
					act.Status, act.SubStatus,ZainetStartDate as StartDate, ZainetEndDate as EndDate			
			FROM	MtMZainetMaxAccount m
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
			AND		s.Book = ~act.IsDaily
			-- in case the flow end date has a value, we need to use this date as this indicates that the accounts is set to de-enroll earlier than the contract end date
			WHERE	ZainetEndDate >= @Today
			AND		(	PATINDEX('%CustomDealUpload%', m.QuoteNumber) = 0
					OR	(		PATINDEX('%CustomDealUpload%', m.QuoteNumber) > 0
							AND	m.ContractId is not null	
						)
					)
	END
	
	CREATE NONCLUSTERED INDEX idx_Account_IZ ON #Account (ISO, ZainetZone) WITH (FILLFACTOR = 100)
	CREATE CLUSTERED INDEX idx_Account_ID ON #Account (MtMAccountID) WITH (FILLFACTOR = 100)
	CREATE NONCLUSTERED INDEX idx_Account_ST ON #Account (StartDate, EndDate) WITH (FILLFACTOR = 100)

	INSERT	into #UsageID
	SELECT	DL.MtMAccountID, UsageDate
	FROM	MtMDailyWholesaleLoadForecast DL WITH (NOLOCK, FORCESEEK) --index = idx_WLoadForecast_UD_MTMID )
	INNER	JOIN #Account  a 
	ON		a.MtMAccountID = DL.MtMAccountID   
	WHERE	YEAR(DL.UsageDate) = @ZkeyYear
	AND		DL.UsageDate between a.StartDate AND a.EndDate

	CREATE CLUSTERED INDEX idx_UsageID_ID ON #UsageID (MtMAccountID,UsageDate ) WITH (FILLFACTOR = 100)

	INSERT	INTO #UsageData
	SELECT	DL.ID, DL.MtMAccountID,DL.UsageDate,ETP,Int1,Int2,Int3,Int4,Int5,Int6,Int7,Int8,Int9,Int10,Int11,Int12,Int13,Int14,Int15,Int16,Int17,Int18,Int19,Int20,Int21,Int22,Int23,Int24
	FROM	MtMDailyWholesaleLoadForecast DL WITH (NOLOCK, FORCESEEK) --index = idx_WLoadForecast_UD_MTMID )
	INNER	JOIN #UsageID  a 
	ON		a.MtMAccountID = DL.MtMAccountID   
	AND		a.UsageDate = DL.UsageDate

	CREATE CLUSTERED INDEX idx_UsageData_ID ON #UsageData ( MtMAccountID ) WITH (FILLFACTOR = 100)

	INSERT	INTO #Usage
	SELECT	DL.*, a.ISO, a.ZainetZone, a.Zkey,a.ZkeyYear, a.IsDaily,a.BuySell, a.CounterParty,a.StartDate, a.EndDate
	FROM	#UsageData DL WITH (NOLOCK, FORCESEEK)
	INNER	JOIN #Account  a 
	ON		a.MtMAccountID = DL.MtMAccountID   
	
	CREATE CLUSTERED INDEX idx_U_All	 ON #Usage (ISO, ZainetZone, Zkey, ZkeyYear, IsDaily, BuySell, CounterParty, UsageDate) WITH (FILLFACTOR = 100)
	/*CREATE CLUSTERED INDEX idx_U_ID	 ON #Usage (MtMAccountID ASC) WITH (FILLFACTOR = 100)
	CREATE NONCLUSTERED INDEX idx_U_Date ON #Usage (UsageDate ASC) WITH (FILLFACTOR = 100)
	CREATE NONCLUSTERED INDEX idx_U_ISO	 ON #Usage (ISO ASC) WITH (FILLFACTOR = 100)
	CREATE NONCLUSTERED INDEX idx_U_Zone ON #Usage (ZainetZone ASC) WITH (FILLFACTOR = 100)*/

	-- get the aggreated load and aggreated ETP
	INSERT	INTO #SUM
	SELECT	DISTINCT 
			ISO, ZainetZone, Zkey, ZkeyYear, IsDaily, BuySell, CounterParty, UsageDate, 
			SUM(DL.ETP*
			   (DL.Int1+DL.Int2+DL.Int3+DL.Int4+DL.Int5+DL.Int6+DL.Int7+DL.Int8+DL.Int9+DL.Int10+
			   DL.Int11+DL.Int12+DL.Int13+DL.Int14+DL.Int15+DL.Int16+DL.Int17+DL.Int18+DL.Int19+DL.Int20+
			   DL.Int21+DL.Int22+DL.Int23+DL.Int24))
			  /
			SUM(DL.Int1+DL.Int2+DL.Int3+DL.Int4+DL.Int5+DL.Int6+DL.Int7+DL.Int8+DL.Int9+DL.Int10+
			   DL.Int11+DL.Int12+DL.Int13+DL.Int14+DL.Int15+DL.Int16+DL.Int17+DL.Int18+DL.Int19+DL.Int20+
			   DL.Int21+DL.Int22+DL.Int23+DL.Int24)
			AS ETP,
			Int1 = SUM(DL.Int1),Int2 = SUM(DL.Int2),Int3 = SUM(DL.Int3),Int4 = SUM(DL.Int4),Int5 = SUM(DL.Int5),Int6 = SUM(DL.Int6),Int7 = SUM(DL.Int7),
			Int8 = SUM(DL.Int8),Int9 = SUM(DL.Int9),Int10 = SUM(DL.Int10),Int11 = SUM(DL.Int11),Int12 = SUM(DL.Int12),Int13 = SUM(DL.Int13),Int14 = SUM(DL.Int14),
			Int15 = SUM(DL.Int15),Int16 = SUM(DL.Int16),Int17 = SUM(DL.Int17),Int18 = SUM(DL.Int18),Int19 = SUM(DL.Int19),Int20 = SUM(DL.Int20),Int21 = SUM(DL.Int21),
			Int22 = SUM(DL.Int22),Int23 = SUM(DL.Int23),Int24 = SUM(DL.Int24)
	FROM	#Usage DL (nolock)
	--INNER	JOIN #Account  a 
	--ON		a.MtMAccountID = DL.MtMAccountID      
	GROUP	BY 	ISO, ZainetZone, Zkey, ZkeyYear, IsDaily, BuySell, CounterParty, UsageDate
	HAVING	SUM(DL.Int1+DL.Int2+DL.Int3+DL.Int4+DL.Int5+DL.Int6+DL.Int7+DL.Int8+DL.Int9+DL.Int10+
			   DL.Int11+DL.Int12+DL.Int13+DL.Int14+DL.Int15+DL.Int16+DL.Int17+DL.Int18+DL.Int19+DL.Int20+
			   DL.Int21+DL.Int22+DL.Int23+DL.Int24) > 0		
				   
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

			CREATE NONCLUSTERED INDEX idx_A_IZD ON #A (ISO, Zone, DeliveryMonth) WITH (FILLFACTOR = 100)

			CREATE NONCLUSTERED INDEX idx_S_IZD ON #Sum (ISO, ZainetZone, UsageDate) WITH (FILLFACTOR = 100)
																
			-- get the load with the attrition applied
			INSERT	INTO #Final
			SELECT	DISTINCT 
					DL.ISO, DL.ZainetZone, DL.Zkey,DL.ZkeyYear,DL.IsDaily,DL.BuySell, DL.CounterParty,DL.UsageDate,ETP,
					Int1 = DL.Int1*t3.Attrition,Int2 = DL.Int2*t3.Attrition,Int3 = DL.Int3*t3.Attrition,Int4 = DL.Int4*t3.Attrition,Int5 = DL.Int5*t3.Attrition,
      				Int6 = DL.Int6*t3.Attrition,Int7 = DL.Int7*t3.Attrition,Int8 = DL.Int8*t3.Attrition,Int9 = DL.Int9*t3.Attrition,Int10 = DL.Int10*t3.Attrition,
      				Int11 = DL.Int11*t3.Attrition,Int12 = DL.Int12*t3.Attrition,Int13 = DL.Int13*t3.Attrition,Int14 = DL.Int14*t3.Attrition,Int15 = DL.Int15*t3.Attrition,
      				Int16 = DL.Int16*t3.Attrition,Int17 = DL.Int17*t3.Attrition,Int18 = DL.Int18*t3.Attrition,Int19 = DL.Int19*t3.Attrition,Int20 = DL.Int20*t3.Attrition,
      				Int21 = DL.Int21*t3.Attrition,Int22 = DL.Int22*t3.Attrition,Int23 = DL.Int23*t3.Attrition,Int24 = DL.Int24*t3.Attrition
			FROM	#Sum DL   WITH (NOLOCK, FORCESEEK)
   			INNER     JOIN #A t3
			ON        DL.ISO	= t3.ISO
			AND       DL.ZainetZone = t3.Zone
			AND       YEAR(DL.UsageDate) = YEAR(t3.DeliveryMonth)
			AND       MONTH(DL.UsageDate) = MONTH(t3.DeliveryMonth)	    
		END
	ELSE	
		BEGIN
			INSERT INTO	#Final
			SELECT	* FROM #SUM
		END	
					
	--Save the account data into a permanent table for future reconciliation: there should be only one entry per zkey/date
	DELETE	MtMZainetDailyData
	WHERE	Zkey = @Zkey
	AND		RunDate = @RunDate

	-- Save the accounts that made into the final step. those accounts should have matching Attrition therefore we need to join to the Final table
	SELECT	DISTINCT MONTH(USageDate) as MonthUsage, YEAR(UsageDate) as YEarUsage
	INTO	#Dates
	FROM	#Final

	INSERT	INTO MtMZainetDailyData 
		(Zkey, ISO, MtMAccountID,StartDate,EndDate,MonthUsage,YearUsage,TotalUsage,DateCreated, RunDate)
	SELECT	@Zkey AS ZKey, ISO, MtMAccountID, StartDate, EndDate, MONTH(UsageDate) as MonthUsageDate, YEAR(UsageDate) as YearUsage, 
			SUM(DL.Int1+DL.Int2+DL.Int3+DL.Int4+DL.Int5+DL.Int6+DL.Int7+DL.Int8+DL.Int9+DL.Int10+DL.Int11+DL.Int12+
				DL.Int13+DL.Int14+DL.Int15+DL.Int16+DL.Int17+DL.Int18+DL.Int19+DL.Int20+ DL.Int21+DL.Int22+DL.Int23+DL.Int24) As TotalUsage,
				GETDATE() DateCreated, @RunDate
	FROM	#Usage DL
	INNER	Join #Dates f
	ON		YEAR(DL.UsageDate) = YearUsage
	AND     MONTH(DL.UsageDate) = MonthUsage
	Group	by ISO, MtMAccountID, StartDate, EndDate, MONTH(UsageDate), YEAR(UsageDate)

	--REtrun data to the API
	SELECT	*
	FROM	#Final		
		

SET NOCOUNT OFF; 

END
