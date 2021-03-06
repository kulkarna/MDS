USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_NimoScrapedUsageSelect]    Script Date: 02/09/2016 12:07:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************  
 * usp_NimoScrapedUsageSelect  
 * Selects usage from the nimo scraped table  
 *  
 * History  
 * Modifed by : Vikas Sharma 05/27/2015  
 * Add Capability to Add the Consolidation Process for Old Account Also.  
 *******************************************************************************  
 * 11-18-2010 - Eduardo Patino  
 * Created.  
 *******************************************************************************  
 */
ALTER PROCEDURE [dbo].[usp_NimoScrapedUsageSelect] (
	@AccountNumber VARCHAR(50)
	,@BeginDate DATETIME
	,@EndDate DATETIME
	)
AS
-- usp_NimoScrapedUsageSelect '0006056015', '2008-11-16', '2016-11-16'  
BEGIN
	SET NOCOUNT ON;

	SELECT *
	INTO #TEMPACCOUNTS
	FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@AccountNumber)

	SELECT DISTINCT Id
		,AccountNumber
		,BeginDate
		,EndDate
		,BillCode
		,Days
		,BilledKwhTotal
		,MeteredPeakKw
		,MeteredOnPeakKw
		,BilledPeakKw
		,BilledOnPeakKw
		,BillDetailAmt
		,BilledRkva
		,OnPeakKwh
		,OffPeakKwh
		,ShoulderKwh
		,OffSeasonKwh
		,Created
		,CreatedBy
		,Modified
		,ModifiedBy
		,ROW_NUMBER() OVER (
			PARTITION BY BeginDate
			,EndDate
			,Days
			,BilledKwhTotal ORDER BY EndDate DESC
			) AS Row_Num
	INTO #NimoUsageTemp
	FROM NimoUsage(NOLOCK)
	WHERE ACCOUNTNUMBER IN (
			SELECT ACCOUNTNO AS ACCOUNTNUMBER
			FROM #TEMPACCOUNTS(NOLOCK)
			)
		AND BeginDate >= @BeginDate
		AND EndDate <= @EndDate

	DELETE
	FROM #NimoUsageTemp
	WHERE Row_Num >1

	SELECT DISTINCT Id
		,AccountNumber
		,BeginDate
		,EndDate
		,BillCode
		,Days
		,BilledKwhTotal
		,MeteredPeakKw
		,MeteredOnPeakKw
		,BilledPeakKw
		,BilledOnPeakKw
		,BillDetailAmt
		,BilledRkva
		,OnPeakKwh
		,OffPeakKwh
		,ShoulderKwh
		,OffSeasonKwh
		,Created
		,CreatedBy
		,Modified
	FROM #NimoUsageTemp
	ORDER BY 3 DESC

	SET NOCOUNT OFF;
END
	-- Copyright 2010 Liberty Power  
