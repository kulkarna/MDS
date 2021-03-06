USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_AmerenScrapedUsageSelectMostRecent]    Script Date: 05/26/2016 15:59:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_AmerenScrapedUsageSelectMostRecent
 * Selects most recent usage from the Ameren scraped table based on dates and KWH
 *******************************************************************************
 * 10-16-2014 - CGHAZAL
 * Created.
 * usp_AmerenScrapedUsageSelectMostRecent '2956006210', '2009-1-1', '2014-10-16'
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_AmerenScrapedUsageSelectMostRecent] (
	@AccountNumber	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime )
AS

BEGIN
	SET NOCOUNT ON;
	
	 SELECT * INTO #TEMPACCOUNTS  
    FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@AccountNumber)  
	
		SELECT	DISTINCT BeginDate, EndDate, Days, TotalKwh, MAX(AccountId) as AccountId
		INTO	#A
		FROM	AmerenAccount (NOLOCK) t1 INNER JOIN
				AmerenUsage (NOLOCK) t2 ON AccountId = t1.Id
		WHERE	AccountNumber in (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
		AND		BeginDate >= @BeginDate
		AND		EndDate <= @EndDate
		GROUP	BY BeginDate, EndDate, Days, TotalKwh
	
		SELECT	DISTINCT t2.Id, t2.AccountId, t2.BeginDate, t2.EndDate, t2.Days, t2.TotalKwh, OnPeakKwh, OffPeakKwh, OnPeakDemandKw, OffPeakDemandKw, PeakReactivePowerKvar,
				@AccountNumber as AccountNumber, MeterNumber, t2.Created
		FROM	#A a
		INNER	JOIN AmerenAccount (NOLOCK) t1 
		ON		a.AccountId = t1.ID
		INNER	JOIN AmerenUsage (NOLOCK) t2 
		ON		t2.AccountId = t1.Id
		AND		t2.BeginDate=a.BeginDate
		AND		t2.EndDate=a.EndDate
		AND		t2.Days=a.Days
		AND		t2.TotalKwh=a.TotalKwh
		ORDER BY 2, 3 DESC, 4

	SET NOCOUNT OFF;
END

