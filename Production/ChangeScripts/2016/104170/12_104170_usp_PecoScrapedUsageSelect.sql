USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_PecoScrapedUsageSelect]    Script Date: 02/09/2016 12:06:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************  
 * usp_PecoScrapedUsageSelect  
 * Selects usage from the peco scraped table  
 *  
 * History  
 *04-03-2014: add created  
 *******************************************************************************  
 * 02-03-2011 - Eduardo Patino  
 * Created.  
 * Modifed by : Vikas Sharma 05/27/2015  
 * Add Capability to Add the Consolidation Process for Old Account Also.  
 *******************************************************************************  
 */
ALTER PROCEDURE [dbo].[usp_PecoScrapedUsageSelect] (
	@AccountNumber VARCHAR(50)
	,@BeginDate DATETIME
	,@EndDate DATETIME
	)
AS
/*  
select * from PecoAccount (nolock) where accountnumber = '0217201203' order by 1 desc  
select * from PecoUsage (nolock) where accountnumber = '0217201203' order by 2, 3 desc  
usp_PecoScrapedUsageSelect '04411059126012', '2008-11-16', '2010-11-16'  
*/
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
		,Created
		,ROW_NUMBER() OVER (
			PARTITION BY FromDate
			,ToDate
			,Usage ORDER BY ToDate DESC
			) AS Row_Num
	INTO #PecoUsageTemp
	FROM PecoUsage(NOLOCK)
	WHERE ACCOUNTNUMBER IN (
			SELECT ACCOUNTNO AS ACCOUNTNUMBER
			FROM #TEMPACCOUNTS(NOLOCK)
			)
		AND FromDate >= @BeginDate
		AND ToDate <= @EndDate

	DELETE
	FROM #PecoUsageTemp
	WHERE Row_Num >1

	SELECT DISTINCT ID
		,AccountNumber
		,FromDate
		,ToDate
		,Usage
		,Demand
		,Created
	FROM #PecoUsageTemp
	ORDER BY 3 DESC

	--ORDER BY 3 DESC  
	SET NOCOUNT OFF;
END
	-- Copyright 2011 Liberty Power  
