USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_CmpScrapedUsageSelect]    Script Date: 02/09/2016 12:03:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************  
 * usp_CmpScrapedSelect  
 * Selects usage from the cmp scraped table  
 *  
 * History  
 * 4-03-2014: add Created  
 * Modifed by : Vikas Sharma 05/27/2015  
 * Add Capability to Add the Consolidation Process for Old Account Also.  
 *******************************************************************************  
 * 02-03-2011 - Eduardo Patino  
 * Created.  
 *******************************************************************************  
 */
ALTER PROCEDURE [dbo].[usp_CmpScrapedUsageSelect] (
	@AccountNumber VARCHAR(50)
	,@BeginDate DATETIME
	,@EndDate DATETIME
	)
AS
/*  
select * from CmpAccount (nolock) where accountnumber = '04411059126012' order by 3, 1 desc  
select * from CmpUsage (nolock) where accountnumber = '04411059126012' order by 4 desc  
usp_CmpScrapedUsageSelect '04411059126012', '2008-11-16', '2016-11-16'  
*/
BEGIN
	SET NOCOUNT ON;

	SELECT *
	INTO #TEMPACCOUNTS
	FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@AccountNumber)

	SELECT DISTINCT ID
		,AccountNumber
		,HighestDemandKw
		,RateCode
		,BeginDate
		,EndDate
		,Days
		,MeterNumber
		,TotalKwh
		,TotalUnmetered
		,TotalActiveUmetered
		,Created
		,ROW_NUMBER() OVER (
			PARTITION BY BeginDate
			,EndDate
			,Days
			,TotalKwh
			,MeterNumber ORDER BY MeterNumber DESC
			) AS Row_Num
	INTO #CmpUsageTemp
	FROM CmpUsage(NOLOCK)
	WHERE ACCOUNTNUMBER IN (
			SELECT ACCOUNTNO AS ACCOUNTNUMBER
			FROM #TEMPACCOUNTS(NOLOCK)
			)
		AND BeginDate >= @BeginDate
		AND EndDate <= @EndDate

	--ORDER BY 3 DESC  
	DELETE
	FROM #CmpUsageTemp
	WHERE Row_Num >1

	SELECT DISTINCT ID
		,AccountNumber
		,HighestDemandKw
		,RateCode
		,BeginDate
		,EndDate
		,Days
		,MeterNumber
		,TotalKwh
		,TotalUnmetered
		,TotalActiveUmetered
		,Created
	FROM #CmpUsageTemp(NOLOCK)
	ORDER BY 3 DESC

	SET NOCOUNT OFF;
END
	-- Copyright 2011 Liberty Power  
