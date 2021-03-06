USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_BgeScrapedUsageSelect]    Script Date: 05/26/2016 16:04:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************  
 * usp_BgeScrapedUsageSelect  
 * Selects usage from the Bge scraped table  
 *  
 * History  
 * Modifed by : Vikas Sharma 05/27/2015
 * Add Capability to Add the Consolidation Process for Old Account Also.
 *******************************************************************************  
 * 12-16-2010 - Eduardo Patino  
 * Created.  
 *******************************************************************************  
 */  
  
ALTER PROCEDURE [dbo].[usp_BgeScrapedUsageSelect] (  
 @AccountNumber varchar(50),  
 @BeginDate  datetime,  
 @EndDate  datetime )  
AS  
-- usp_BgeScrapedUsageSelect '3744640858', '2008-11-16', '2010-11-16'  
BEGIN  
 SET NOCOUNT ON;  
  
  
	
    SELECT * INTO #TEMPACCOUNTS
				FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@AccountNumber)
                        
 SELECT DISTINCT Id, @AccountNumber AccountNumber, MeterNumber, MeterType, BeginDate, EndDate, Days, TotalKwh, OnPeakKwh, OffPeakKwh, ReadingSource, IntermediatePeakKwh, SeasonalCrossOver, DeliveryDemandKw, GenTransDemandKw, UsageFactorNonTOU, UsageFactorOnPeak, 
 UsageFactorOffPeak, UsageFactorIntermediate, Created, CreatedBy, Modified, ModifiedBy  
 FROM BgeUsage (nolock)  
 WHERE  ACCOUNTNUMBER IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))
  AND BeginDate >= @BeginDate  
  AND EndDate <= @EndDate  
 ORDER BY 5 DESC  
  
 SET NOCOUNT OFF;  
END  
-- Copyright 2010 Liberty Power  

