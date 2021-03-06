USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_CenhudScrapedUsageSelect]    Script Date: 02/09/2016 12:10:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************    
 * usp_CenhudScrapedUsageSelect    
 * Selects usage from the Cenhud scraped table    
 *    
 * History    
 *    
 *******************************************************************************    
 * 12-16-2010 - Eduardo Patino    
 * Created.    
 *******************************************************************************    
 */
ALTER PROCEDURE [dbo].[usp_CenhudScrapedUsageSelect] (
	@AccountNumber VARCHAR(50)
	,@BeginDate DATETIME
	,@EndDate DATETIME
	)
AS
-- usp_CenhudScrapedUsageSelect '8667016000', '2008-11-16', '2016-11-16'    
BEGIN
	SET NOCOUNT ON;

	SELECT *
	INTO #TEMPACCOUNTS
	FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@AccountNumber)

	SELECT DISTINCT Id
		,AccountNumber
		,ReadCode
		,NumberOfMonths
		,BeginDate
		,EndDate
		,Days
		,MeterNumber
		,TotalKwh
		,DemandKw
		,OnPeakKwh
		,OffPeakKwh
		,TotalBilledAmount
		,SalesTax
		,Created
		,CreatedBy
		,ROW_NUMBER() OVER (
			PARTITION BY BeginDate
			,EndDate
			,TotalKwh
			,MeterNumber
			,Days ORDER BY EndDate DESC
			) AS Row_Num
	INTO #CenhudUsageTEMP
	FROM CenhudUsage(NOLOCK)
	WHERE ACCOUNTNUMBER IN (
			SELECT ACCOUNTNO AS ACCOUNTNUMBER
			FROM #TEMPACCOUNTS(NOLOCK)
			)
		AND BeginDate >= @BeginDate
		AND EndDate <= @EndDate

	DELETE
	FROM #CenhudUsageTEMP
	WHERE Row_Num > 1

	SELECT DISTINCT Id
		,AccountNumber
		,ReadCode
		,NumberOfMonths
		,BeginDate
		,EndDate
		,Days
		,MeterNumber
		,TotalKwh
		,DemandKw
		,OnPeakKwh
		,OffPeakKwh
		,TotalBilledAmount
		,SalesTax
		,Created
		,CreatedBy
	FROM #CenhudUsageTEMP(NOLOCK)
	ORDER BY 5 DESC
		,6

	SET NOCOUNT OFF;
END
	-- Copyright 2010 Liberty Power    
