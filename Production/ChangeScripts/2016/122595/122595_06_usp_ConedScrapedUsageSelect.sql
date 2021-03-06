USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_ConedScrapedUsageSelect]    Script Date: 05/26/2016 16:08:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_ConedScrapedSelect
 * Selects usage from the coned scraped table
 *
 * History
 * Modifed by : Vikas Sharma 05/27/2015
 * Add Capability to Add the Consolidation Process for Old Account Also.
 *******************************************************************************
 * 11-16-2010 - Eduardo Patino
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_ConedScrapedUsageSelect] (
	@AccountNumber	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime )
AS
-- usp_ConedScrapedUsageSelect '494011007300007', '2008-11-16', '2010-11-16'
BEGIN
	SET NOCOUNT ON;
	
		SELECT * INTO #TEMPACCOUNTS
				FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@AccountNumber)
	SELECT	DISTINCT ID, @AccountNumber AccountNumber, FromDate, ToDate, Usage, Demand, BillAmount, Created, CreatedBy, Modified, ModifiedBy
	FROM	ConedUsage (nolock)
	WHERE	ACCOUNTNUMBER IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))
		AND FromDate >= @BeginDate
		AND	ToDate <= @EndDate
	ORDER BY 3 DESC

	SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
