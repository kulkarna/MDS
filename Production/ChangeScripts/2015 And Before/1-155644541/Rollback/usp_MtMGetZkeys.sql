USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMGetZkeys]    Script Date: 08/12/2013 11:36:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	6/26/2012																								*
 *	Descp:		get the list of all the Zkeys																			*
	 *  To Run:		exec usp_MtMGetZkeys	1																				*
 *	Modified:																											*
 ************************************************************************************************************************/
ALTER	PROCEDURE [dbo].[usp_MtMGetZkeys]
( @IsCustomDealUpload as bit = 0)
AS

BEGIN
SET NOCOUNT ON; 

	DECLARE @Today AS DATETIME
	SET @Today = DATEADD(D, 0, DATEDIFF(D, 0, GETDATE()))
	

IF @IsCustomDealUpload = 0
BEGIN

	-- GET the ISO/ZONe/Book for each ETPd account
	SELECT	Distinct
			maxA.ID, AccountCONtractID, ISO, zz.ZainetZONe,IsDaily, a.Status, a.SubStatus, r.CounterPartyID, a.ZainetStartDate, a.ZainetEndDate
	INTO	#Basic
	
	FROM	MtMZainetAccountInfo a (nolock)
	
	INNER	Join MtMZainetMaxAccount maxA (nolock)
	ON		a.CONtractID = maxA.CONtractID
	AND		a.AccountID = maxA.AccountID
	AND		PATINDEX('%CustomDealUpload%', maxA.QuoteNumber) = 0
	
	INNER	JOIN MtMZainetZONes zz (nolock)
	ON		a.UtilityID = zz.UtilityID
	AND		maxA.ZONe = zz.ZONe

	INNER	join MtMReportStatus rs (nolock)
	ON		a.status = rs.Status
	AND		a.substatus = rs.SubStatus
	AND		rs.Inactive = 0
	
	INNER	join MtMReport r (nolock)
	ON		rs.ReportID = r.ReportID
	
	WHERE	a.ZainetEndDate >= @Today
	and		a.IsDaily = ~@IsCustomDealUpload
	AND		ISNULL(a.BackToBack,0) = 0
	--AND		a.ISO IN ('PJM')
	
	CREATE NONCLUSTERED INDEX idx_Basic ON #Basic (AccountCONtractID)

--Get the different usage YEAR for each combination of ISO/Zone/Book/CounterParty. The whole thing will be unique and makes a Zkey
	SELECT	DISTINCT
			a.ISO, a.ZainetZONe, a.IsDaily, CounterPartyID, YEAR(UsageDate) as UsageYear
	INTO	#Usage
	FROM	#Basic a
	INNER	JOIN MtMDailyWholesaleLoadForecast f (nolock)
	ON		a.ID = f.MtMAccountID
	WHERE	/*f.UsageDate >= @Today
	AND		*/f.UsageDate BETWEEN a.ZainetStartDate AND a.ZainetEndDate

	CREATE NONCLUSTERED INDEX idx_Usage1 ON #Usage (IsDaily,ISO,UsageYear,ZainetZONe)
	CREATE NONCLUSTERED INDEX idx_Usage2 ON #Usage (CounterPartyID)

-- Get the Zkeys that will apply for the current dataset ISO/Zone/Book/CounterParty/UsageYear
	SELECT	DISTINCT
			--Top 2
			--rz.*, a.ISO, a.ZainetZONe, a.IsDaily, a.UsageYear, a.CounterPartyID, 
			rzd.Zkey
	FROM	MtMReportZkey rz (nolock)
	INNER	join #Usage a
	ON		rz.Book = ~a.IsDaily
	AND		rz.ISO = a.ISO
	AND		rz.Year  = a.UsageYear
	AND		rz.ZONe = a.ZainetZONe
	INNER	join MtMReportZkeyDetail rzd (nolock)
	ON		rz.ZkeyID = rzd.ZkeyID
	AND		rzd.CounterPartyID = a.CounterPartyID
	--WHERE	rzd.Zkey <> '138285'
	ORDER	by rzd.Zkey
END

ELSE

BEGIN
		DECLARE @PlContract_CpID as int
		
		select	@PlContract_CpID = cp.CounterPartyID
		from	MtMReportCounterParty cp (nolock)
		where	cp.CounterParty = 'PlContract'
		
		CREATE TABLE #TEMP (
			MtMAccountID int,
			IsDaily bit,
			ISO varchar(50),
			Zone varchar(50),
			UsageYear decimal(9,5),
			CounterPartyID int
		)
		--BEGIN: Getting NEW custom deals with ContractID is NULL
		/*
		SELECT DISTINCT
				m.ID as MtMAccountID, m.AccountID, m.ContractID, m.Zone, m.DealPricingID
		INTO	#M
		FROM	MtMAccount m (nolock)
		WHERE	m.Status = 'ETPd' and 
				PATINDEX('%CustomDealUpload%', m.QuoteNumber) >= 1 
		and		m.ContractId is null
		GROUP	BY m.AccountID, m.ContractID, m.Zone, m.DealPricingID
		*/
		INSERT INTO #TEMP (MtMAccountID, IsDaily, ISO, Zone, UsageYear, CounterPartyID)
		SELECT DISTINCT
				m.ID as MtMAccountID, 0,
				u.WholeSaleMktID, zz.ZainetZone, YEAR(forecast.UsageDate), @PlContract_CpID as CounterPartyID
		--FROM	#M m (nolock)
		FROM	MtMZainetMaxAccount  m (nolock)
		INNER	JOIN LibertyPower..Account act (nolock) ON m.AccountID = act.AccountID
		INNER	JOIN lp_deal_capture..deal_pricing d (nolock) ON m.DealPricingID = d.deal_pricing_id
		INNER	JOIN LibertyPower..Utility u (nolock) ON u.ID = act.UtilityID
		INNER	JOIN MtMZainetZones zz (nolock) ON u.ID = zz.UtilityID AND m.Zone = zz.Zone
		INNER	JOIN MtMDailyWholesaleLoadForecast forecast (nolock) ON (m.ID = forecast.MtMAccountID)
		--INNER	JOIN MtMAccount mtmAcct (nolock) on (mtmAcct.AccountID = m.AccountID)	
		WHERE	PATINDEX('%CustomDealUpload%', m.QuoteNumber) > 0 
		AND		m.ContractId is null
		AND		forecast.UsageDate >= @Today
		--AND		u.WholeSaleMktID = 'PJM'
		/*WHERE	mtmAcct.ContractID is null
		AND		forecast.UsageDate >= @Today
		*/
		--AND		u.WholeSaleMktID NOT IN ('PJM', 'PJM')

		--BEGIN: Getting OLD custom deals and NEW with ContractID is not NULL
		INSERT INTO #TEMP (MtMAccountID, IsDaily, ISO, Zone, UsageYear, CounterPartyID)
		SELECT Distinct
				maxA.ID, IsDaily, ISO, zz.ZainetZone, YEAR(forecast.UsageDate), r.CounterPartyID as CounterPartyID
		FROM	MtMZainetAccountInfo a (nolock)
		INNER	Join MtMZainetMaxAccount maxA (nolock) ON a.CONtractID = maxA.CONtractID AND a.AccountID = maxA.AccountID
		--INNER	JOIN MtMAccount m (nolock) ON	maxA.ID = m.ID
												--and ((PATINDEX('%CustomDealUpload%', m.QuoteNumber) = 0) or
												--	((PATINDEX('%CustomDealUpload%', m.QuoteNumber) >= 1) and (m.ContractId is not null)))
		INNER	JOIN MtMZainetZONes zz (nolock) ON a.UtilityID = zz.UtilityID AND maxA.ZONe = zz.ZONe 
		INNER	JOIN MtMDailyWholesaleLoadForecast forecast (nolock) ON (maxA.ID = forecast.MtMAccountID)
		INNER	join MtMReportStatus rs (nolock) ON a.status = rs.Status AND a.substatus = rs.SubStatus AND rs.Inactive = 0
		INNER	join MtMReport r (nolock) ON rs.ReportID = r.ReportID
		WHERE	a.ZainetEndDate > @Today
		AND		forecast.UsageDate >= @Today
		--AND		PATINDEX('%CustomDealUpload%', maxA.QuoteNumber) > 0
		AND		(		PATINDEX('%CustomDealUpload%', maxA.QuoteNumber) = 0
					OR	(PATINDEX('%CustomDealUpload%', maxA.QuoteNumber) > 0 	AND	maxA.ContractId is not null)
				)
		and		IsDaily = ~@IsCustomDealUpload
		--AND		a.ISO= 'PJM'
		--AND		ISNULL(a.BackToBack,0) = 0
		
		SELECT DISTINCT
				rzd.Zkey
		FROM	MtMReportZkey rz (nolock)
		INNER	join #TEMP a ON (rz.Book = ~a.IsDaily AND rz.ISO = a.ISO AND rz.Year = a.UsageYear AND rz.ZONe = a.Zone)
		INNER	join MtMReportZkeyDetail rzd (nolock) ON (rz.ZkeyID = rzd.ZkeyID AND rzd.CounterPartyID = a.CounterPartyID)
		--where	rzd.Zkey in (212198,212199)
		order	by rzd.Zkey
END	

SET NOCOUNT OFF; 

END
