USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_ConedScrapedUsageSelect]    Script Date: 02/09/2016 12:05:14 ******/
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
	@AccountNumber VARCHAR(50)
	,@BeginDate DATETIME
	,@EndDate DATETIME
	)
AS
-- usp_ConedScrapedUsageSelect '494011007300007', '2008-11-16', '2016-11-16'  
BEGIN
	SET NOCOUNT ON;

	SELECT *
	INTO #TEMPACCOUNTS
	FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@AccountNumber)

	SELECT DISTINCT ID
		,AccountNumber
		,FromDate
		,ToDate
		,Usage
		,Demand
		,BillAmount
		,Created
		,CreatedBy
		,Modified
		,ModifiedBy
		,ROW_NUMBER() OVER (
			PARTITION BY FromDate
			,ToDate
			,Usage ORDER BY ToDate DESC
			) AS Row_Num
	INTO #ConedUsageTemp
	FROM ConedUsage(NOLOCK)
	WHERE ACCOUNTNUMBER IN (
			SELECT ACCOUNTNO AS ACCOUNTNUMBER
			FROM #TEMPACCOUNTS(NOLOCK)
			)
		AND FromDate >= @BeginDate
		AND ToDate <= @EndDate

	DELETE
	FROM #ConedUsageTemp
	WHERE Row_Num >1

	SELECT DISTINCT ID
		,AccountNumber
		,FromDate
		,ToDate
		,Usage
		,Demand
		,BillAmount
		,Created
		,CreatedBy
		,Modified
		,ModifiedBy
	FROM #ConedUsageTemp
	ORDER BY 3 DESC

	SET NOCOUNT OFF;
END
	-- Copyright 2010 Liberty Power  
