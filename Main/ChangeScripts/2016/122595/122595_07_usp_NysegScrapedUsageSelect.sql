USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_NysegScrapedUsageSelect]    Script Date: 05/26/2016 16:10:34 ******/
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
	@AccountNumber	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime )
AS
-- usp_NysegScrapedUsageSelect 'N01000020816450', '2008-11-16', '2010-11-16'
BEGIN
	SET NOCOUNT ON;

DECLARE	@PREVACCOUNTNUMBER VARCHAR(50)
	
		
		SELECT * INTO #TEMPACCOUNTS
				FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@AccountNumber)

	SELECT	DISTINCT t1.Id, @AccountNumber AccountNumber, BeginDate, EndDate, Days, ReadType, Kw, KwOn, KwOff, Kwh, KwhOn, KwhOff, KwhMid, Rkvah, Total, TotalTax, MeterNumber, t1.Created
	FROM	NysegUsage (nolock) t1 inner join NysegAccount (nolock) t2 on t1.accountnumber = t2.accountnumber
	WHERE	t2.ACCOUNTNUMBER IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))
		AND BeginDate >= @BeginDate
		AND	EndDate <= @EndDate
		AND t2.id in (SELECT max(t3.id) FROM NysegAccount (nolock) t3 WHERE t3.accountnumber = t2.accountnumber)
	ORDER BY 3 DESC, 4

	SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power



