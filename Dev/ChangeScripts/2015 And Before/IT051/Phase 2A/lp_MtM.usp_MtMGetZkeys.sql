USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMGetZkeys]    Script Date: 03/13/2013 13:50:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* **********************************************************************************************************************
 *	Author:		Cghazal																									*
 *	Created:	6/26/2012																								*
 *	Descp:		get the list of all the Zkeys																			*
 *  To Run:		exec usp_MtMGetZkeys																					*
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
			maxA.ID, AccountCONtractID, ISO, zz.ZainetZONe,IsCustom
	INTO	#Basic
	FROM	MtMZainetAccountInfo a (nolock)
	INNER	Join MtMZainetMaxAccount maxA (nolock)
	ON		a.CONtractID = maxA.CONtractID
	AND		a.AccountID = maxA.AccountID
	INNER	JOIN MtMAccount m (nolock)
	ON		maxA.ID = m.ID
	AND		PATINDEX('CustomDealUpload-%', m.QuoteNumber) = 0
	INNER	JOIN MtMZainetZONes zz (nolock)
	ON		a.UtilityID = zz.UtilityID
	AND		m.ZONe = zz.ZONe
	and		IsCustom = @IsCustomDealUpload
	WHERE	a.EndDate > @Today
	
	CREATE NONCLUSTERED INDEX idx_Basic ON #Basic (AccountCONtractID)
	
-- Get the Statuses of the accounts found in order to get the counter party they belong to
	SELECT	act.AccountCONtractID, actS.Status, actS.SubStatus
	INTO	#AccountStatus
	FROM	#Basic act
	INNER	JOIN LibertyPower..AccountStatus actS (nolock)
	ON		actS.AccountCONtractID = act.AccountCONtractID
	
	CREATE NONCLUSTERED INDEX idx_AccountStatus ON #AccountStatus ([status],substatus)
	
	SELECT	DISTINCT AccountCONtractID, r.CounterPartyID
	INTO	#Status
	FROM	#AccountStatus ast
	INNER	join MtMReportStatus rs (nolock)
	ON		ast.status = rs.Status
	AND		ast.substatus = rs.SubStatus
	AND		rs.Inactive = 0
	INNER	join MtMReport r (nolock)
	ON		rs.ReportID = r.ReportID
	
	CREATE NONCLUSTERED INDEX idx_Status ON #Status (AccountCONtractID)
	
-- GET the final list of the accounts based on ISO/Zone/Book/CounterParty
	SELECT	ID, ISO, ZainetZONe,IsCustom, ast.CounterPartyID
	INTO	#Final
	FROM	#Basic act
	INNER	JOIN #Status ast
	ON		act.AccountCONtractID = ast.AccountCONtractID

	CREATE CLUSTERED INDEX idx_Final ON #Final (ID)
--Get the different usage YEAR for each combination of ISO/Zone/Book/CounterParty. The whole thing will be unique and makes a Zkey
	SELECT	DISTINCT
			a.ISO, a.ZainetZONe, a.IsCustom, CounterPartyID, YEAR(UsageDate) as UsageYear
	INTO	#Usage
	FROM	#Final a
	INNER	JOIN MtMDailyWholesaleLoadForecast f (nolock)
	ON		a.ID = f.MtMAccountID
	WHERE	f.UsageDate >= @Today

	CREATE NONCLUSTERED INDEX idx_Usage1 ON #Usage (IsCustom,ISO,UsageYear,ZainetZONe)
	CREATE NONCLUSTERED INDEX idx_Usage2 ON #Usage (CounterPartyID)

-- Get the Zkeys that will apply for the current dataset ISO/Zone/Book/CounterParty/UsageYear
	SELECT	DISTINCT
			--Top 2
			--rz.*, a.ISO, a.ZainetZONe, a.IsCustom, a.UsageYear, a.CounterPartyID, 
			rzd.Zkey
	FROM	MtMReportZkey rz (nolock)
	INNER	join #Usage a
	ON		rz.Book = a.IsCustom
	AND		rz.ISO = a.ISO
	AND		rz.Year  = a.UsageYear
	AND		rz.ZONe = a.ZainetZONe
	INNER	join MtMReportZkeyDetail rzd (nolock)
	ON		rz.ZkeyID = rzd.ZkeyID
	AND		rzd.CounterPartyID = a.CounterPartyID
	--WHERE	rzd.Zkey <> '138285'
END
ELSE
BEGIN
		DECLARE @PlContract_CpID as int
		
		select	@PlContract_CpID = cp.CounterPartyID
		from	MtMReportCounterParty cp (nolock)
		where	cp.CounterParty = 'PlContract'
		
		CREATE TABLE #TEMP (
			MtMAccountID int,
			IsCustom int,
			ISO varchar(50),
			Zone varchar(50),
			UsageYear decimal(9,5),
			CounterPartyID int
		)
		/*****************************************************
		BEGIN: Getting NEW custom deals with ContractID is NULL
		******************************************************/
		SELECT DISTINCT
				max(m.ID) as MtMAccountID, m.AccountID, m.ContractID, m.Zone, m.DealPricingID
		INTO	#M
		FROM	MtMAccount m (nolock)
		WHERE	m.Status = 'ETPd' and PATINDEX('CustomDealUpload-%', m.QuoteNumber) >= 1 and m.ContractId is null
		GROUP	BY m.AccountID, m.ContractID, m.Zone, m.DealPricingID
		
		INSERT INTO #TEMP (MtMAccountID, IsCustom, ISO, Zone, UsageYear, CounterPartyID)
		SELECT DISTINCT
				m.MtMAccountID, 1,
				u.WholeSaleMktID, zz.ZainetZone, YEAR(forecast.UsageDate), @PlContract_CpID as CounterPartyID
		FROM	#M m (nolock)
		INNER	JOIN LibertyPower..Account act (nolock) ON m.AccountID = act.AccountID
		INNER	JOIN lp_deal_capture..deal_pricing d (nolock) ON m.DealPricingID = d.deal_pricing_id
		INNER	JOIN LibertyPower..Utility u (nolock) ON u.ID = act.UtilityID
		INNER	JOIN MtMZainetZones zz (nolock) ON u.ID = zz.UtilityID AND m.Zone = zz.Zone
		INNER	JOIN MtMDailyWholesaleLoadForecast forecast (nolock) ON (m.MtMAccountID = forecast.MtMAccountID)
		INNER	JOIN MtMAccount mtmAcct (nolock) on (mtmAcct.AccountID = m.AccountID)
		WHERE	mtmAcct.ContractID is null
		
		/*****************************************************
		END: Getting NEW custom deals with ContractID is NULL
		******************************************************/
		/******************************
		BEGIN: Getting OLD custom deals and NEW with ContractID is not NULL
		*******************************/
		INSERT INTO #TEMP (MtMAccountID, IsCustom, ISO, Zone, UsageYear, CounterPartyID)
		SELECT Distinct
				maxA.ID, isCustom, ISO, m.Zone, YEAR(forecast.UsageDate), r.CounterPartyID as CounterPartyID
		FROM	MtMZainetAccountInfo a (nolock)
		INNER	Join MtMZainetMaxAccount maxA (nolock) ON a.CONtractID = maxA.CONtractID AND a.AccountID = maxA.AccountID
		INNER	JOIN MtMAccount m (nolock) ON	maxA.ID = m.ID
												and ((PATINDEX('CustomDealUpload-%', m.QuoteNumber) = 0) or
													((PATINDEX('CustomDealUpload-%', m.QuoteNumber) >= 1) and (m.ContractId is not null)))
		INNER	JOIN MtMZainetZONes zz (nolock) ON a.UtilityID = zz.UtilityID AND m.ZONe = zz.ZONe and IsCustom = @IsCustomDealUpload
		INNER	JOIN MtMDailyWholesaleLoadForecast forecast (nolock) ON (m.ID = forecast.MtMAccountID)
		INNER	join MtMReportStatus rs (nolock) ON a.status = rs.Status AND a.substatus = rs.SubStatus AND rs.Inactive = 0
		INNER	join MtMReport r (nolock) ON rs.ReportID = r.ReportID
		WHERE	a.EndDate > @Today
		
		/******************************
		END: Getting OLD custom deals and NEW with ContractID is not NULL
		*******************************/
		SELECT DISTINCT
				rzd.Zkey
		FROM	MtMReportZkey rz (nolock)
		INNER	join #TEMP a ON (rz.Book = a.IsCustom AND rz.ISO = a.ISO AND rz.Year = a.UsageYear AND rz.ZONe = a.Zone)
		INNER	join MtMReportZkeyDetail rzd (nolock) ON (rz.ZkeyID = rzd.ZkeyID AND rzd.CounterPartyID = a.CounterPartyID)
END	

SET NOCOUNT OFF; 

END
