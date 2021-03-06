USE [lp_MtM]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMGetZkeys]    Script Date: 03/14/2013 17:30:00 ******/
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

AS

BEGIN

	DECLARE @Today AS DATETIME
	SET @Today = DATEADD(D, 0, DATEDIFF(D, 0, GETDATE()))

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
	INNER	JOIN MtMZainetZONes zz (nolock)
	ON		a.UtilityID = zz.UtilityID
	AND		m.ZONe = zz.ZONe
	WHERE	a.EndDate > @Today
	and		a.ISO = 'MISO'
	
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
	FROM	MtMReportZkey rz
	INNER	join #Usage a
	ON		rz.Book = a.IsCustom
	AND		rz.ISO = a.ISO
	AND		rz.Year  = a.UsageYear
	AND		rz.ZONe = a.ZainetZONe
	INNER	join MtMReportZkeyDetail rzd
	ON		rz.ZkeyID = rzd.ZkeyID
	AND		rzd.CounterPartyID = a.CounterPartyID
	--WHERE	rzd.Zkey = '215576'
END