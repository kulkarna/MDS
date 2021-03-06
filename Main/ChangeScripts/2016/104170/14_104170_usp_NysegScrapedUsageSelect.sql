USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_ComedScrapedUsageSelect]    Script Date: 02/09/2016 12:03:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************  
 * usp_NysegScrapedUsageSelect  
 * Selects usage from the Nyseg scraped table  
 *  
 * History  
 *  
 * 05-03-2011 - added meter number (from account table)..  
 * 04-03-2014: add created  
 *******************************************************************************  
 * 12-15-2010 - Eduardo Patino  
 * Created.  
 *******************************************************************************  
 */
ALTER PROCEDURE [dbo].[usp_NysegScrapedUsageSelect] (
	@AccountNumber VARCHAR(50)
	,@BeginDate DATETIME
	,@EndDate DATETIME
	)
AS
-- usp_NysegScrapedUsageSelect 'N01000020816450', '2008-11-16', '2016-11-16'  
BEGIN
	SET NOCOUNT ON;

	DECLARE @PREVACCOUNTNUMBER VARCHAR(50)

	SELECT *
	INTO #TEMPACCOUNTS
	FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@AccountNumber)

	SELECT DISTINCT t1.Id
		,t1.AccountNumber
		,BeginDate
		,EndDate
		,Days
		,ReadType
		,Kw
		,KwOn
		,KwOff
		,Kwh
		,KwhOn
		,KwhOff
		,KwhMid
		,Rkvah
		,Total
		,TotalTax
		,MeterNumber
		,t1.Created
		,ROW_NUMBER() OVER (
			PARTITION BY BeginDate
			,EndDate
			,Days
			,Total
			,MeterNumber ORDER BY MeterNumber DESC
			) AS Row_Num
	INTO #NysegUsageTemp
	FROM NysegUsage(NOLOCK) t1
	INNER JOIN NysegAccount(NOLOCK) t2 ON t1.accountnumber = t2.accountnumber
	WHERE t2.ACCOUNTNUMBER IN (
			SELECT ACCOUNTNO AS ACCOUNTNUMBER
			FROM #TEMPACCOUNTS(NOLOCK)
			)
		AND BeginDate >= @BeginDate
		AND EndDate <= @EndDate
		AND t2.id IN (
			SELECT max(t3.id)
			FROM NysegAccount(NOLOCK) t3
			WHERE t3.accountnumber = t2.accountnumber
			)

	DELETE
	FROM #NysegUsageTemp
	WHERE row_num > 1

	SELECT DISTINCT Id
		,AccountNumber
		,BeginDate
		,EndDate
		,Days
		,ReadType
		,Kw
		,KwOn
		,KwOff
		,Kwh
		,KwhOn
		,KwhOff
		,KwhMid
		,Rkvah
		,Total
		,TotalTax
		,MeterNumber
		,Created
	FROM #NysegUsageTemp(NOLOCK)
	ORDER BY 3 DESC
		,4

	SET NOCOUNT OFF;
END
	-- Copyright 2010 Liberty Power  
