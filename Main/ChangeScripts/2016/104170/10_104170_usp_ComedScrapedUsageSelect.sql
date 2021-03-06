USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_ComedScrapedUsageSelect]    Script Date: 02/09/2016 12:03:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************  
 * usp_ComedScrapedSelect  
 * Selects usage from the comed scraped table  
 *  
 * History  
 *04-03-2014: Return date created  
 *******************************************************************************  
 * 02-02-2011 - Eduardo Patino  
 * Created.  
 * Modifed by : Vikas Sharma 05/27/2015  
 * Add Capability to Add the Consolidation Process for Old Account Also.  
 *******************************************************************************  
 */
ALTER PROCEDURE [dbo].[usp_ComedScrapedUsageSelect] (
	@AccountNumber VARCHAR(50)
	,@BeginDate DATETIME
	,@EndDate DATETIME
	)
AS
/*  
select * from ComedAccount (nolock) where accountnumber = '0010072045' order by 3, 1 desc  
select * from ComedUsage (nolock) where accountnumber = '0010072045' order by 4 desc  
usp_ComedScrapedUsageSelect '0010072045', '2008-11-16', '2010-11-16'  
*/
BEGIN
	SET NOCOUNT ON;

	SELECT *
	INTO #TEMPACCOUNTS
	FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@AccountNumber)

	SELECT DISTINCT AccountNumber
		,Rate
		,BeginDate
		,EndDate
		,Days
		,TotalKwh
		,OnPeakKwh
		,OffPeakKwh
		,BillingDemandKw
		,MonthlyPeakDemandKw
		,Created
		,ROW_NUMBER() OVER (
			PARTITION BY BeginDate
			,EndDate
			,Days
			,TotalKwh ORDER BY enddate DESC
			) AS Row_Num
	INTO #ComedUsageTemp
	FROM ComedUsage(NOLOCK)
	WHERE ACCOUNTNUMBER IN (
			SELECT ACCOUNTNO AS ACCOUNTNUMBER
			FROM #TEMPACCOUNTS(NOLOCK)
			)
		AND BeginDate >= @BeginDate
		AND EndDate <= @EndDate

	DELETE
	FROM #ComedUsageTemp
	WHERE Row_Num >1

	SELECT DISTINCT AccountNumber
		,Rate
		,BeginDate
		,EndDate
		,Days
		,TotalKwh
		,OnPeakKwh
		,OffPeakKwh
		,BillingDemandKw
		,MonthlyPeakDemandKw
		,Created
	FROM #ComedUsageTemp
	ORDER BY 1 DESC

	SET NOCOUNT OFF;
END
	-- Copyright 2010 Liberty Power  
