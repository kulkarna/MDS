USE [ISTA]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************    

 * usp_GetIstaMeterReads    

 * retrieves usage from ISTA    

 *    

 * History    

 * 12/05/2008 - added xtra @All parameter for usp_GetAccountUsage (fcm)    

 * 12/09/2008 - added code to handle cancels + usage type (historical/billed)    

 * 07/07/2009 - added code to handle summary vs detail records (since we were    

 *    getting duplicates for PEPCO)    

 * 07/15/2009 - adding unmetered + idr sources (EP)    

 * 07/22/2009 - added TransactionSetPurposeCode = 05 (estimated) per Douglas' request    

 * 09/09/2009 - ticket 9857 - created new UtilityDunsXref table..    

 * 03/03/2010 - ticket 14032 - added utility..    

 * 03/19/2010 - ticket 14435 - added two new sources in order to retrieve usage from..    

 * 11/15/2010 - Rick Deigsler    

 * SD 19685 - Update NSTAR utility code in OE to match EDI file    

 * 05/11/2011 - IT022 - per Douglas' request, getting rid off the different queries    

 *    and only leaving the vw_BilledUsage view    

 * 09/12/2011 - per Douglas, i have turned off ista as a source from the fmw, i am    

 *    now making sure nobody else uses it (jic)..    

 * 10/29/2012 - turning proc back on per Douglas request - 1-33626971    

 * 12/03/2012 - checking whether record already exists before updating it - 1-42120197  

 * Modifed by : Vikas Sharma 05/27/2015  

 * Add Capability to Add the Consolidation Process for Old Account Also.  

 * Modified BY: Srikanth Bachina 03/28/2017
 * Replace the ISTA.dbo.vw_BilledUsage with Inline Table valued function ([ISTA].[dbo].[tvf_BilledUsage])
 * Enrollment system was running slowly causing delays in accessing information due to Poorly designed table views 
 * So Replace the ISTA.dbo.vw_BilledUsage with Inline Table valued function ([ISTA].[dbo].[tvf_BilledUsage]) TFS-173475

 *******************************************************************************    

 * 11/25/2008 - Eduardo Patino    

 * Created.    

 *******************************************************************************    

 */    

    

ALTER PROCEDURE [dbo].[usp_GetIstaMeterReads]    

(    

 @AccountNumber varchar(50),    

 @utilityCode varchar(50),    

 @BeginDate  datetime,    

 @EndDate  datetime,    

 @All   varchar(10) = '0'    

)    

    

AS    

    

    

    

/*    

select distinct LDCID, LDCName, LDCShortName Utility, DUNS, getdate() Created, 'Eduardo' CreatedBy into lp_common..utility_duns_xref from ldc order by 2, 1    

    

select top 500 * from ista.dbo.vw_BilledUsage where accountnumber in ('0000018510155995', '0000532195001', '0005002917', '0006056015') order by 2, 1, 4    

select top 500 * from lp_Market867.dbo.vw_EDIusage    

    

select * from sys.procedures where name = 'usp_GetIstaMeterReads'    

-- 2011-09-12 17:37:37.693    

    

drop table #METERREADS    

select * from #METERREADS    

exec usp_GetIstaMeterReads '935232003', 'CL&P', '2011-10-30', '2012-12-22', '1'    

    

 INSERT INTO #METERREADS    

 SELECT DISTINCT utility, AccountNumber, FromDate, ToDate, TotalKWH, 'Billed', ''    

 FROM ista.dbo.vw_BilledUsage (NOLOCK)    

 WHERE AccountNumber = '935232003'    

    

declare @AccountNumber varchar(50),    

 @utilityCode varchar(50),    

 @BeginDate  datetime,    

 @EndDate  datetime,    

 @All   varchar(10)    

select @AccountNumber = '0005002917'    

select @utilityCode  = 'AMEREN'    

select @BeginDate  = '01/01/2005'    

select @EndDate   = '01/01/2009'    

select @All    = '0'    

*/    

BEGIN    

 SET NOCOUNT ON;  

 SELECT * INTO #TEMPACCOUNTS  

    FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@AccountNumber)  

    

    

    

 CREATE TABLE #METERREADS (UtilityCode varchar(50), AccountNumber varchar(50), FromDate datetime, ToDate datetime, TotalKWH int,    

  UsageType varchar(15), TransactionNbr varchar(200))    

    

 -- - - - - - - - - - - - - - - - - - - - - - - -     

 print '' print '* ' + dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + '-- ticket 14435..'    

 -- - - - - - - - - - - - - - - - - - - - - - - -     

     

 INSERT INTO #METERREADS    
 --Replace the ISTA.dbo.vw_BilledUsage with Inline Table valued function ([ISTA].[dbo].[tvf_BilledUsage])

 SELECT DISTINCT utility, AccountNumber, FromDate, ToDate, TotalKWH, 'Billed', ''    

 FROM [ISTA].[dbo].[tvf_BilledUsage] (@AccountNumber,@utilityCode,@BeginDate,@EndDate)  

 WHERE AccountNumber IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  

 -- SD 19685 - when NSTAR utility, only select by account number    

  AND utility = CASE WHEN @utilityCode LIKE 'NSTAR%' THEN utility ELSE @utilityCode END    

    

/*    

 -- - - - - - - - - - - - - - - - - - - - - - - -     

 print '' print '* ' + dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + '-- legacy i..'    

 -- - - - - - - - - - - - - - - - - - - - - - - -     

 INSERT INTO #METERREADS    

 SELECT  DISTINCT utility_id, u.esiid, u.ServicePeriodStart, u.ServicePeriodEnd, u.TotalKWH,    

    case TransactionSetPurposeCode when '00' then 'Billed' when '01' then 'Canceled' when '05' then 'Billed' else 'Historical' end, TransactionNbr    

 FROM    

 (    

  SELECT DISTINCT utility utility_id, h.esiid, d.ServicePeriodStart, d.ServicePeriodEnd, ROUND(CAST(q.Quantity AS float), 0) AS TotalKWH,    

    TransactionSetPurposeCode, '' TransactionNbr    

  FROM tbl_867_header h (nolock)    

    LEFT JOIN tbl_867_nonintervaldetail d (nolock) ON d.[867_key] = h.[867_key]    

    LEFT JOIN tbl_867_nonintervaldetail_qty q (nolock) ON q.[nonintervaldetail_key] = d.[nonintervaldetail_key]    

    LEFT JOIN lp_common..UtilityDunsXref ut (nolock) on TdspDuns = duns    

  WHERE h.esiid = @AccountNumber    

   -- SD 19685 - when NSTAR utility, only select by account number    

   AND utility = CASE WHEN @utilityCode LIKE '%NSTAR%' THEN utility ELSE @utilityCode END     

   AND h.esiid NOT IN (SELECT DISTINCT tmp.AccountNumber FROM #METERREADS tmp    

    WHERE tmp.ToDate = convert(datetime, d.ServicePeriodEnd) and tmp.FromDate = convert(datetime, d.ServicePeriodStart) and tmp.AccountNumber = h.esiid)    

   AND q.UOM = 'KH'    

   AND d.ServicePeriodStart IS NOT NULL     

   AND LEN(d.ServicePeriodStart) > 0    

   AND d.ServicePeriodEnd IS NOT NULL     

   AND LEN(d.ServicePeriodEnd) > 0    

   AND TransactionSetPurposeCode IN ('00', '52', 'SU', '01', '05')    

   AND q.MeasurementSignificanceCode IN ('22', '46', '51')    -- per Douglas, summary - 07/07/2009    

 ) u    

 WHERE (isdate(u.ServicePeriodStart) = 1 AND isdate(u.ServicePeriodEnd) = 1)    

    

 INSERT INTO #METERREADS    

 SELECT  DISTINCT utility_id, u.esiid, u.ServicePeriodStart, u.ServicePeriodEnd, u.TotalKWH,    

    case TransactionSetPurposeCode when '00' then 'Billed' when '01' then 'Canceled' when '05' then 'Billed' else 'Historical' end, TransactionNbr    

 FROM    

 (    

  SELECT DISTINCT utility utility_id, h.esiid, d.ServicePeriodStart, d.ServicePeriodEnd, ROUND(CAST(q.Quantity AS float), 0) AS TotalKWH,    

    TransactionSetPurposeCode, '' TransactionNbr    

  FROM tbl_867_header h (nolock)    

    LEFT JOIN tbl_867_nonintervaldetail d (nolock) ON d.[867_key] = h.[867_key]    

    LEFT JOIN tbl_867_nonintervaldetail_qty q (nolock) ON q.[nonintervaldetail_key] = d.[nonintervaldetail_key]    

    LEFT JOIN lp_common..UtilityDunsXref ut (nolock) on TdspDuns = duns    

  WHERE h.esiid = @AccountNumber    

   -- SD 19685 - when NSTAR utility, only select by account number    

   AND utility = CASE WHEN @utilityCode LIKE '%NSTAR%' THEN utility ELSE @utilityCode END       

   AND h.esiid NOT IN (SELECT DISTINCT tmp.AccountNumber FROM #METERREADS tmp    

    WHERE tmp.ToDate = convert(datetime, d.ServicePeriodEnd) and tmp.FromDate = convert(datetime, d.ServicePeriodStart) and tmp.AccountNumber = h.esiid)    

   AND q.UOM = 'KH'    

   AND d.ServicePeriodStart IS NOT NULL     

   AND LEN(d.ServicePeriodStart) > 0    

   AND d.ServicePeriodEnd IS NOT NULL     

   AND LEN(d.ServicePeriodEnd) > 0    

   AND TransactionSetPurposeCode IN ('00', '52', 'SU', '01', '05')    

   AND q.MeasurementSignificanceCode IN ('41', '42', '43')    

 ) u    

 WHERE (isdate(u.ServicePeriodStart) = 1 AND isdate(u.ServicePeriodEnd) = 1)    

    

 -- - - - - - - - - - - - - - - - - - - - - - - -     

 print '' print '* ' + dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + '-- legacy ii..'    

 -- - - - - - - - - - - - - - - - - - - - - - - -     

 INSERT INTO #METERREADS    

 SELECT  DISTINCT utility_id, u.esiid, u.ServicePeriodStart, u.ServicePeriodEnd, u.TotalKWH,    

    case TransactionSetPurposeCode when '00' then 'Billed' when '01' then 'Canceled' when '05' then 'Billed' else 'Historical' end, TransactionNbr    

 FROM    

 (    

  SELECT DISTINCT utility utility_id, h.esiid, sumq.ServicePeriodStart, sumq.ServicePeriodEnd, ROUND(CAST(sumq.Quantity as float), 0) AS TotalKWH,    

    TransactionSetPurposeCode, '' TransactionNbr    

  FROM ISTA..tbl_867_header h (nolock)    

    INNER JOIN tbl_867_nonintervalsummary sumd (nolock) on sumd.[867_key] = h.[867_key]    

    INNER JOIN tbl_867_nonintervalsummary_qty sumq (nolock) on sumq.[nonintervalsummary_key] = sumd.[nonintervalsummary_key]    

    LEFT JOIN lp_common..UtilityDunsXref ut (nolock) on TdspDuns = duns    

  WHERE h.esiid = @AccountNumber    

   -- SD 19685 - when NSTAR utility, only select by account number    

   AND utility = CASE WHEN @utilityCode LIKE '%NSTAR%' THEN utility ELSE @utilityCode END       

   AND h.esiid NOT IN (SELECT DISTINCT tmp.AccountNumber FROM #METERREADS tmp    

    WHERE tmp.ToDate = convert(datetime, sumq.ServicePeriodEnd) and tmp.FromDate = convert(datetime, sumq.ServicePeriodStart) and tmp.AccountNumber = h.esiid)    

   AND sumq.CompositeUOM = 'KH'    

   AND sumq.ServicePeriodStart IS NOT NULL     

   AND LEN(sumq.ServicePeriodStart) > 0    

   AND sumq.ServicePeriodEnd IS NOT NULL     

   AND LEN(sumq.ServicePeriodEnd) > 0    

   AND TransactionSetPurposeCode IN ('00', '52', 'SU', '01', '05')    

   AND sumq.MeasurementSignificanceCode IN ('22', '46', '51')    

 ) u    

 WHERE (isdate(u.ServicePeriodStart) = 1 AND isdate(u.ServicePeriodEnd) = 1)    

    

 INSERT INTO #METERREADS    

 SELECT  DISTINCT utility_id, u.esiid, u.ServicePeriodStart, u.ServicePeriodEnd, u.TotalKWH,    

    case TransactionSetPurposeCode when '00' then 'Billed' when '01' then 'Canceled' when '05' then 'Billed' else 'Historical' end, TransactionNbr    

 FROM    

 (    

  SELECT DISTINCT utility utility_id, h.esiid, sumq.ServicePeriodStart, sumq.ServicePeriodEnd, ROUND(CAST(sumq.Quantity as float), 0) AS TotalKWH,    

    TransactionSetPurposeCode, '' TransactionNbr    

  FROM ISTA..tbl_867_header h (nolock)    

    INNER JOIN tbl_867_nonintervalsummary sumd (nolock) on sumd.[867_key] = h.[867_key]    

    INNER JOIN tbl_867_nonintervalsummary_qty sumq (nolock) on sumq.[nonintervalsummary_key] = sumd.[nonintervalsummary_key]    

    LEFT JOIN lp_common..UtilityDunsXref ut (nolock) on TdspDuns = duns    

  WHERE h.esiid = @AccountNumber    

   -- SD 19685 - when NSTAR utility, only select by account number    

   AND utility = CASE WHEN @utilityCode LIKE '%NSTAR%' THEN utility ELSE @utilityCode END       

   AND h.esiid NOT IN (SELECT DISTINCT tmp.AccountNumber FROM #METERREADS tmp    

    WHERE tmp.ToDate = convert(datetime, sumq.ServicePeriodEnd) and tmp.FromDate = convert(datetime, sumq.ServicePeriodStart) and tmp.AccountNumber = h.esiid)    

   AND sumq.CompositeUOM = 'KH'    

   AND sumq.ServicePeriodStart IS NOT NULL     

   AND LEN(sumq.ServicePeriodStart) > 0    

   AND sumq.ServicePeriodEnd IS NOT NULL     

   AND LEN(sumq.ServicePeriodEnd) > 0    

   AND TransactionSetPurposeCode IN ('00', '52', 'SU', '01', '05')    

   AND sumq.MeasurementSignificanceCode IN ('41', '42', '43')   -- per Douglas, detail - 07/07/2009    

 ) u    

 WHERE (isdate(u.ServicePeriodStart) = 1 AND isdate(u.ServicePeriodEnd) = 1)    

    

 -- - - - - - - - - - - - - - - - - - - - - - - -     

 print '' print '* ' + dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + '-- legacy iii (unmetered)..'    

 -- - - - - - - - - - - - - - - - - - - - - - - -     

 INSERT INTO #METERREADS    

 SELECT  DISTINCT utility_id, u.esiid, u.ServicePeriodStart, u.ServicePeriodEnd, u.TotalKWH,    

    case TransactionSetPurposeCode when '00' then 'Billed' when '01' then 'Canceled' when '05' then 'Billed' else 'Historical' end, TransactionNbr    

 FROM    

 (    

  SELECT DISTINCT utility utility_id, h.esiid, sumd.ServicePeriodStart, sumd.ServicePeriodEnd, ROUND(CAST(sumq.Quantity as float), 0) AS TotalKWH,    

    TransactionSetPurposeCode, '' TransactionNbr    

  FROM tbl_867_header h (nolock)    

    INNER JOIN tbl_867_UnmeterDetail sumd (nolock) on sumd.[867_key] = h.[867_key]    

    INNER JOIN tbl_867_UnmeterDetail_Qty sumq (nolock) on sumq.UnmeterDetail_Key = sumd.UnmeterDetail_Key    

    LEFT JOIN lp_common..UtilityDunsXref ut (nolock) on TdspDuns = duns    

  WHERE h.esiid = @AccountNumber    

   -- SD 19685 - when NSTAR utility, only select by account number    

   AND utility = CASE WHEN @utilityCode LIKE '%NSTAR%' THEN utility ELSE @utilityCode END       

   AND h.esiid NOT IN (SELECT DISTINCT tmp.AccountNumber FROM #METERREADS tmp    

    WHERE tmp.ToDate = convert(datetime, sumd.ServicePeriodEnd) and tmp.FromDate = convert(datetime, sumd.ServicePeriodStart) and tmp.AccountNumber = h.esiid)    

   AND sumq.uom = 'KH'    

   AND sumd.ServicePeriodStart IS NOT NULL     

   AND LEN(sumd.ServicePeriodStart) > 0    

   AND sumd.ServicePeriodEnd IS NOT NULL     

   AND LEN(sumd.ServicePeriodEnd) > 0    

   AND TransactionSetPurposeCode IN ('00', '52', 'SU', '01', '05')    

 ) u    

 WHERE (isdate(u.ServicePeriodStart) = 1 AND isdate(u.ServicePeriodEnd) = 1)    

    

 -- - - - - - - - - - - - - - - - - - - - - - - -     

 print '' print '* ' + dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + '-- legacy iv (idr)..'    

 -- - - - - - - - - - - - - - - - - - - - - - - -     

 INSERT INTO #METERREADS    

 SELECT  DISTINCT utility_id, u.esiid, u.ServicePeriodStart, u.ServicePeriodEnd, u.TotalKWH,    

    case TransactionSetPurposeCode when '00' then 'Billed' when '01' then 'Canceled' when '05' then 'Billed' else 'Historical' end, TransactionNbr    

 FROM    

 (    

  SELECT DISTINCT utility utility_id, h.esiid, sumd.ServicePeriodStart, sumd.ServicePeriodEnd, ROUND(CAST(sumq.Quantity as float), 0) AS TotalKWH,    

    TransactionSetPurposeCode, '' TransactionNbr    

  FROM ISTA..tbl_867_header h (nolock)    

    INNER JOIN ISTA..tbl_867_IntervalDetail sumd (nolock) on sumd.[867_key] = h.[867_key]    

    INNER JOIN ISTA..tbl_867_IntervalDetail_Qty sumq (nolock) on sumq.IntervalDetail_key = sumd.IntervalDetail_key    

    LEFT JOIN lp_common..UtilityDunsXref ut (nolock) on TdspDuns = duns    

  WHERE h.esiid = @AccountNumber    

   -- SD 19685 - when NSTAR utility, only select by account number    

   AND utility = CASE WHEN @utilityCode LIKE '%NSTAR%' THEN utility ELSE @utilityCode END       

   AND h.esiid NOT IN (SELECT DISTINCT tmp.AccountNumber FROM #METERREADS tmp    

    WHERE tmp.ToDate = convert(datetime, sumd.ServicePeriodEnd) and tmp.FromDate = convert(datetime, sumd.ServicePeriodStart) and tmp.AccountNumber = h.esiid)    

   AND sumd.MeterUOM = 'KH'    

   AND sumd.ServicePeriodStart IS NOT NULL     

   AND LEN(sumd.ServicePeriodStart) > 0    

   AND sumd.ServicePeriodEnd IS NOT NULL     

   AND LEN(sumd.ServicePeriodEnd) > 0    

   AND TransactionSetPurposeCode IN ('00', '52', 'SU', '01', '05')    

 ) u    

 WHERE (isdate(u.ServicePeriodStart) = 1 AND isdate(u.ServicePeriodEnd) = 1)    

*/      

 -- SD 19685 - Update NSTAR utility code in OE to match EDI file    

 IF (SELECT COUNT(UtilityCode) FROM #METERREADS) > 0    

  BEGIN    

   -- change utility code variable to match EDI data    

   SELECT TOP 1 @utilityCode = UtilityCode    

   FROM #METERREADS    

   WHERE AccountNumber = @AccountNumber    

    

   IF (SELECT COUNT(Utility) FROM OfferEngineDB..OE_ACCOUNT WHERE ACCOUNT_NUMBER = @AccountNumber AND UTILITY = @utilityCode) = 0    

    BEGIN    

     -- update utility code in Offer Engine to match EDI data    

     UPDATE OfferEngineDB..OE_ACCOUNT    

     SET  UTILITY   = @utilityCode    

     WHERE ACCOUNT_NUMBER = @AccountNumber    

   END    

  END    

    

-- DELETE FROM #METERREADS WHERE TransactionNbr in (       -- 12/09/2008    

--  SELECT t2.OriginalTransactionNbr FROM #METERREADS t2    

--  WHERE #METERREADS.TransactionNbr = t2.OriginalTransactionNbr AND t2.usagetype = 'Invalid')    

-- DELETE FROM #METERREADS WHERE usagetype = 'Invalid'    

    

 -- - - - - - - - - - - - - - - - - - - - - - - -     

 print '' print '* ' + dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + '-- results..'    

 -- - - - - - - - - - - - - - - - - - - - - - - -    

 IF @All = '0'    

   BEGIN    

  SELECT DISTINCT RTRIM(UtilityCode) UtilityCode, @AccountNumber as AccountNumber, FromDate, ToDate, sum(TotalKWH) TotalKWH, UsageType, TransactionNbr TransactionNumber    

  FROM #METERREADS    

  WHERE fromdate >= @BeginDate    

   AND todate <= @EndDate    

  GROUP BY UtilityCode, AccountNumber, FromDate, ToDate, UsageType, TransactionNbr    

  ORDER BY FromDate DESC, UsageType DESC    

   END    

 ELSE    

   BEGIN    

  SELECT DISTINCT RTRIM(UtilityCode) UtilityCode, @AccountNumber AccountNumber, FromDate, ToDate, sum(TotalKWH) TotalKWH, UsageType, TransactionNbr TransactionNumber    

  FROM #METERREADS    

  GROUP BY UtilityCode, AccountNumber, FromDate, ToDate, UsageType, TransactionNbr    

  ORDER BY FromDate DESC, UsageType DESC    

   END    

    

 SET NOCOUNT OFF;    

END    

  
