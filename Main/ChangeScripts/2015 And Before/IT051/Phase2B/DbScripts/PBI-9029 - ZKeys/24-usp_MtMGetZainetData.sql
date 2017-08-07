USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMGetZainetData]    Script Date: 10/03/2013 16:05:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	6/26/2012																								*
 *	Descp:		get the data for a zKey to be processed and sent to Zainet												*
 *  To Run:		exec usp_MtMGetZainetData '213422', 1	
  *	Modified:	Replace DealPricingID with CustomDealID																	*
 ************************************************************************************************************************/

ALTER PROCEDURE   [dbo].[usp_MtMGetZainetData] (
				@Zkey AS INT,
				@IsoId AS INT,
				@ISO AS VARCHAR(50),
				--@LocationInternalRefId AS INT, 
				@ZainetLocation AS VARCHAR(50),
				@CounterPartyId AS INT,
				@Year AS INT,
				@IsDaily AS BIT,
				@RunDate AS DATE= NULL)
AS

BEGIN
SET NOCOUNT ON; 

	DECLARE @Today AS DATETIME
	SET @Today = DATEADD(D, 0, DATEDIFF(D, 0, GETDATE()))
	
	IF (@RunDate IS NULL)
		SET	@RunDate = CAST (@Today AS DATE)

	CREATE TABLE #Account (
		MtMAccountID int,
		AccountID varchar(50),
		ContractID varchar(50),
		SignedDate datetime,
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
		Peak			Float, 
		OffPeak			Float,
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
		Int17			decimal(14, 4),Int18 decimal(14, 4),Int19 decimal(14, 4),Int20 decimal(14, 4),Int21 decimal(14, 4),Int22 decimal(14, 4),Int23 decimal(14, 4),Int24 decimal(14, 4),
		Peak			Float, 
		OffPeak			Float )
	
	CREATE TABLE #Final (
		UsageDate		datetime,
		ETP				float,
		Int1			decimal(14, 4),Int2  decimal(14, 4),Int3  decimal(14, 4),Int4  decimal(14, 4),Int5  decimal(14, 4),Int6  decimal(14, 4),Int7  decimal(14, 4),Int8  decimal(14, 4),
		Int9			decimal(14, 4),Int10 decimal(14, 4),Int11 decimal(14, 4),Int12 decimal(14, 4),Int13 decimal(14, 4),Int14 decimal(14, 4),Int15 decimal(14, 4),Int16 decimal(14, 4),
		Int17			decimal(14, 4),Int18 decimal(14, 4),Int19 decimal(14, 4),Int20 decimal(14, 4),Int21 decimal(14, 4),Int22 decimal(14, 4),Int23 decimal(14, 4),Int24 decimal(14, 4) )	
		
	CREATE TABLE #SUM (
		UsageDate		datetime,
		ETP				float,
		Int1			decimal(14, 4),Int2  decimal(14, 4),Int3  decimal(14, 4),Int4  decimal(14, 4),Int5  decimal(14, 4),Int6  decimal(14, 4),Int7  decimal(14, 4),Int8  decimal(14, 4),
		Int9			decimal(14, 4),Int10 decimal(14, 4),Int11 decimal(14, 4),Int12 decimal(14, 4),Int13 decimal(14, 4),Int14 decimal(14, 4),Int15 decimal(14, 4),Int16 decimal(14, 4),
		Int17			decimal(14, 4),Int18 decimal(14, 4),Int19 decimal(14, 4),Int20 decimal(14, 4),Int21 decimal(14, 4),Int22 decimal(14, 4),Int23 decimal(14, 4),Int24 decimal(14, 4)	)		
		
	-- Seperating the ZKey/Counterparty tables and getting all that info and storing it in a non-normalized table
	-- made the query run in a sec
	SELECT	DISTINCT
			rs.Status, rs.SubStatus
	INTO	#Statuses
	FROM	MtMReportStatus rs (nolock)
	INNER	JOIN MtMReport r (nolock)
	ON		rs.ReportID = r.ReportID
	AND		r.Inactive = 0
	INNER	JOIN MtMReportCounterParty rc (nolock)
	ON		r.CounterPartyID = rc.CounterPartyID
	WHERE	rc.CounterPartyID = @CounterPartyID
	AND		rs.Inactive = 0
	
	CREATE NONCLUSTERED INDEX idx_STATUS_ALL ON #Statuses ([Status],SubStatus)   WITH (FILLFACTOR = 100)

	-- Get the internal locations mapped to the Zainet zone passed
	SELECT	Distinct InternalRefId
	INTO	#InternalLocation
	FROM	LibertyPower..vw_ExternalEntityMapping e (NOLOCK) 
	WHERE	e.ExtEntityID = 9
	AND		e.ExtEntityPropertyID = 1
	AND		e.ExtEntityValue = @ZainetLocation
	
	-- Delete all the non Zkey ISO from the internal locations
	SELECT	l.*
	INTO	#InternalLocationIso
	FROM	#InternalLocation l
	INNER	JOIN LibertyPower..vw_ExternalEntityMapping e (NOLOCK) 
	ON		l.InternalRefId = e.InternalRefId
	WHERE	e.ExtEntityTypeId = 1
	AND		e.ExtEntityPropertyID = 1
	AND		e.ExtEntityId = @IsoId
	
	DROP	TABLE #InternalLocation
	
	--Getting non-custom deal
	INSERT INTO #Account
	SELECT	DISTINCT m.ID as MtMAccountID,
			m.AccountID, m.ContractID,act.SignedDate, 
			act.Status, act.SubStatus, ZainetStartDate as StartDate, ZainetEndDate as EndDate
	FROM	MtMZainetMaxAccount m (nolock)
	INNER	JOIN  MtMZainetAccountInfo act WITH (nolock, FORCESEEK )
	ON		m.ContractID = act.ContractID
	AND		m.AccountID = act.AccountID		
	INNER	JOIN #Statuses s
	ON		act.Status = s.Status
	AND		act.SubStatus = s.SubStatus
			
	-- in case the flow end date has a value, we need to use this date as this indicates that the accounts is set to de-enroll earlier than the contract end date
	WHERE	ZainetEndDate  >= @Today 
	--AND		m.SettlementLocationRefID = @LocationInternalRefId
	AND		m.SettlementLocationRefID IN (SELECT InternalRefId FROM #InternalLocationIso)
	AND		act.IsDaily = @IsDaily
	AND		act.ISOId = @ISOId
	AND		ISNULL(BackToBack,0) = 0
	
	IF (@IsDaily = 0 AND @CounterPartyID = 1)
		BEGIN		
			--Getting NEW custom deals with ContractID is NULL
			INSERT	INTO #Account
			SELECT	DISTINCT m.ID as MtMAccountID,								
					m.AccountID,m.ContractID,c.ContractStartDate as SignedDate,
					'Status' as Status,'SubStatus' as SubStatus,
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
			INNER	JOIN LibertyPower..WholesaleMarket w (nolock) 
			ON		u.WholeSaleMktID = w.WholeSaleMktID			
			WHERE	m.CustomDealID IS NOT NULL
			AND		m.ContractId IS NULL
			AND		w.Id = @IsoId
			--AND		m.SettlementLocationRefId = @LocationInternalRefId
			AND		m.SettlementLocationRefID IN (SELECT InternalRefId FROM #InternalLocationIso)
			AND		DATEADD(m, Term, c.ContractStartDate) >= @Today
			AND		m.CreatedBy <> 'Wolverine' -- Temp to remove once those accounts are submitted again
	END
	
	CREATE CLUSTERED INDEX idx_Account_ID ON #Account (MtMAccountID) WITH (FILLFACTOR = 100)
	CREATE NONCLUSTERED INDEX idx_Account_ST ON #Account (StartDate, EndDate) WITH (FILLFACTOR = 100)

	INSERT	into #UsageID
	SELECT	DL.MtMAccountID, UsageDate
	FROM	MtMDailyWholesaleLoadForecast DL WITH (NOLOCK, FORCESEEK) --index = idx_WLoadForecast_UD_MTMID )
	INNER	JOIN #Account  a 
	ON		a.MtMAccountID = DL.MtMAccountID   
	WHERE	YEAR(DL.UsageDate) = @Year
	AND		DL.UsageDate between a.StartDate AND a.EndDate

	CREATE CLUSTERED INDEX idx_UsageID_ID ON #UsageID (MtMAccountID,UsageDate ) WITH (FILLFACTOR = 100)

	INSERT	INTO #UsageData
	SELECT	DL.ID, DL.MtMAccountID,DL.UsageDate,ETP,Int1,Int2,Int3,Int4,Int5,Int6,Int7,Int8,Int9,Int10,Int11,Int12,Int13,Int14,Int15,Int16,Int17,Int18,Int19,Int20,Int21,Int22,Int23,Int24, 
			ISNULL(Peak,0) as Peal, ISNULL(OffPeak,0) as OffPeak
	FROM	MtMDailyWholesaleLoadForecast DL WITH (NOLOCK, FORCESEEK) --index = idx_WLoadForecast_UD_MTMID )
	INNER	JOIN #UsageID  a 
	ON		a.MtMAccountID = DL.MtMAccountID   
	AND		a.UsageDate = DL.UsageDate

	CREATE CLUSTERED INDEX idx_UsageData_ID ON #UsageData ( MtMAccountID ) WITH (FILLFACTOR = 100)

	INSERT	INTO #Usage
	SELECT	DL.*, a.StartDate, a.EndDate
	FROM	#UsageData DL WITH (NOLOCK, FORCESEEK)
	INNER	JOIN #Account  a 
	ON		a.MtMAccountID = DL.MtMAccountID   
	
	CREATE CLUSTERED INDEX idx_U_All ON #Usage (UsageDate) WITH (FILLFACTOR = 100)

	-- get the aggreated load and aggreated ETP
	INSERT	INTO #SUM
	SELECT	DISTINCT 
			UsageDate, 
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
	GROUP	BY 	UsageDate
	HAVING	SUM(DL.Int1+DL.Int2+DL.Int3+DL.Int4+DL.Int5+DL.Int6+DL.Int7+DL.Int8+DL.Int9+DL.Int10+
			   DL.Int11+DL.Int12+DL.Int13+DL.Int14+DL.Int15+DL.Int16+DL.Int17+DL.Int18+DL.Int19+DL.Int20+
			   DL.Int21+DL.Int22+DL.Int23+DL.Int24) > 0		
				   
	IF (@CounterPartyID = 1 OR @CounterPartyID = 2)
		BEGIN
		   --GET ATTRITION PERCENTAGE
			SELECT	MAX(s.EffectiveDate) as EffectiveDate--, a.SignedDate
			INTO	#ATT
			FROM	MtMAttritionMostRecentEffectiveDate s (nolock)
			WHERE	s.ISO = @ISO	  
			--AND		s.SettlementLocationRefID = @LocationInternalRefId
			AND		s.Zone = @ZainetLocation
			AND		s.EffectiveDate <= @Today

			--get the max date	   
			UPDATE	t1
			SET		t1.EffectiveDate = t2.EffectiveDate
			FROM	#ATT t1,
			(
				SELECT	MAX(EffectiveDate) as EffectiveDate
				FROM	MtMAttritionMostRecentEffectiveDate l (nolock)
				WHERE	l.ISO = @ISO	  
				AND		l.Zone = @ZainetLocation
				--AND		l.SettlementLocationRefID = @LocationInternalRefId
			) t2
			WHERE	t1.EffectiveDate IS NULL

			SELECT	DISTINCT t2.DeliveryMonth, t2.Attrition--, SignedDate
			INTO	#A
			FROM	#ATT t1
			INNER	JOIN MtMAttritionMostRecentEffectiveDate t3 (nolock)
			ON		t3.ISO = @ISO
			AND		t3.Zone = @ZainetLocation
			--AND		t3.SettlementLocationRefID = @LocationInternalRefId
			AND		t1.EffectiveDate = t3.EffectiveDate 
			INNER	JOIN MtMAttrition t2 (nolock)
			ON		t2.ISO = t3.ISO
			AND		t2.Zone = t3.Zone
			--AND		t2.SettlementLocationRefID = t3.SettlementLocationRefID
			AND		t2.EffectiveDate = t3.EffectiveDate 
			AND		t2.FileLogID = t3.FileLogID

			CREATE NONCLUSTERED INDEX idx_A_IZD ON #A (DeliveryMonth) WITH (FILLFACTOR = 100)

			CREATE NONCLUSTERED INDEX idx_S_IZD ON #Sum (UsageDate) WITH (FILLFACTOR = 100)
																
			-- get the load with the attrition applied
			INSERT	INTO #Final
			SELECT	DISTINCT 
					DL.UsageDate,ETP,
					Int1 = DL.Int1*t3.Attrition,Int2 = DL.Int2*t3.Attrition,Int3 = DL.Int3*t3.Attrition,Int4 = DL.Int4*t3.Attrition,Int5 = DL.Int5*t3.Attrition,
      				Int6 = DL.Int6*t3.Attrition,Int7 = DL.Int7*t3.Attrition,Int8 = DL.Int8*t3.Attrition,Int9 = DL.Int9*t3.Attrition,Int10 = DL.Int10*t3.Attrition,
      				Int11 = DL.Int11*t3.Attrition,Int12 = DL.Int12*t3.Attrition,Int13 = DL.Int13*t3.Attrition,Int14 = DL.Int14*t3.Attrition,Int15 = DL.Int15*t3.Attrition,
      				Int16 = DL.Int16*t3.Attrition,Int17 = DL.Int17*t3.Attrition,Int18 = DL.Int18*t3.Attrition,Int19 = DL.Int19*t3.Attrition,Int20 = DL.Int20*t3.Attrition,
      				Int21 = DL.Int21*t3.Attrition,Int22 = DL.Int22*t3.Attrition,Int23 = DL.Int23*t3.Attrition,Int24 = DL.Int24*t3.Attrition
			FROM	#Sum DL   --WITH (NOLOCK, FORCESEEK)
   			INNER    JOIN #A t3
			ON       YEAR(DL.UsageDate) = YEAR(t3.DeliveryMonth)
			AND      MONTH(DL.UsageDate) = MONTH(t3.DeliveryMonth)	    
		END
	ELSE	
		BEGIN
			INSERT INTO	#Final
			SELECT	DISTINCT 
					DL.UsageDate,ETP,
					Int1, Int2,Int3,Int4,Int5,Int6,Int7,Int8,Int9,Int10,Int11,Int12,Int13,Int14,Int15,
      				Int16,Int17,Int18,Int19,Int20,Int21,Int22,Int23,Int24
			FROM	#Sum DL   --WITH (NOLOCK, FORCESEEK)
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
		(Zkey, ISO, MtMAccountID,StartDate,EndDate,MonthUsage,YearUsage,TotalUsage,Peak, OffPeak,DateCreated, RunDate)
	SELECT	@Zkey AS ZKey, @ISO, MtMAccountID, StartDate, EndDate, MONTH(UsageDate) as MonthUsageDate, YEAR(UsageDate) as YearUsage, 
			SUM(DL.Int1+DL.Int2+DL.Int3+DL.Int4+DL.Int5+DL.Int6+DL.Int7+DL.Int8+DL.Int9+DL.Int10+DL.Int11+DL.Int12+
				DL.Int13+DL.Int14+DL.Int15+DL.Int16+DL.Int17+DL.Int18+DL.Int19+DL.Int20+ DL.Int21+DL.Int22+DL.Int23+DL.Int24) As TotalUsage, SUM(DL.Peak) as Peak, SUM(DL.OffPeak) as OffPeak,
				GETDATE() DateCreated, @RunDate
	FROM	#Usage DL
	INNER	Join #Dates f
	ON		YEAR(DL.UsageDate) = YearUsage
	AND     MONTH(DL.UsageDate) = MonthUsage
	
	Group	by MtMAccountID, StartDate, EndDate, MONTH(UsageDate), YEAR(UsageDate)

	--REtrun data to the API
	SELECT	*
	FROM	#Final		
		

SET NOCOUNT OFF; 

END
