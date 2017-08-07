USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountByIdSelect]    Script Date: 05/26/2015 03:31:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
    
/*******************************************************************************    
 * usp_GetConsolidatedUsage    
 * retrieves usage from the consolidated usage table    
 *    
 * History    
 *    
 *******************************************************************************    
 * 11/29/2010 - Eduardo Patino    
 * Created.    
 *******************************************************************************    
 */    
    
ALTER PROCEDURE [dbo].[usp_GetConsolidatedUsage]    
(    
 @AccountNumber varchar(50),    
 @UtilityCode varchar(50),    
 @BeginDate  datetime,    
 @EndDate  datetime    
)    
AS    
/*    
select 'UsageType', * from libertypower..usagetype    
select 'UsageSource', * from libertypower..usagesource    
select * from usageconsolidated where accountnumber = '6703762212' and fromdate >= '2008-05-01' and todate <= '2011-01-01'    
    
exec libertypower..usp_GetConsolidatedUsage '08012999170002153813', 'METED', '12/05/2013', '12/05/2015'     
    
declare  @AccountNumber varchar(50),    
 @UtilityCode varchar(50),    
 @BeginDate  datetime,    
 @EndDate  datetime    
set @AccountNumber = '08012999170002153813'    
set @UtilityCode = 'METED'    
set @BeginDate = '12/05/2013'    
set @EndDate = '12/05/2015'    
*/    
    
BEGIN    
 SET NOCOUNT ON;    
    
declare @estimate int    
select @estimate = value from usagetype where description = 'Estimated'    
--select @estimate    
   DECLARE @PREVACCOUNTNUMBER VARCHAR(50)  
   
    SELECT TOP 1  
      @PREVACCOUNTNUMBER=CASE WHEN   
     A.NEW_ACCOUNT_NUMBER=@AccountNumber THEN OLD_ACCOUNT_NUMBER   
           ELSE NEW_ACCOUNT_NUMBER   
    END  
     FROM LP_ACCOUNT..ACCOUNT_NUMBER_HISTORY(NOLOCK) A    
       WHERE (OLD_ACCOUNT_NUMBER=@AccountNumber OR NEW_ACCOUNT_NUMBER=@AccountNumber)  
                        ORDER  BY A.DATE_CREATED DESC 
                        
                        
                        
                        
-- note that i had to convert UT and US to int since they are defined as INTegers in the FWK    
 SELECT ID, AccountNumber, UtilityCode,    
   CAST(CAST(DATEPART(mm, FromDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, FromDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, FromDate) AS varchar(4)) AS datetime) AS FromDate,    
   CAST(CAST(DATEPART(mm, ToDate) AS varchar(2)) + '/' + CAST(DATEPART(dd, ToDate) AS varchar(2)) + '/' + CAST(DATEPART(yyyy, ToDate) AS varchar(4)) AS datetime) AS ToDate,    
   TotalKwh, DaysUsed, Created, CreatedBy, convert (int, UsageType) UsageType, convert (int, UsageSource) UsageSource, Active, ReasonCode, MeterNumber    
 FROM UsageConsolidated (nolock) UC  
 left outer join lp_account..account_number_history(NOLOCK)  ANH on   
 (UC.AccountNumber=ANH.new_account_number or UC.AccountNumber=ANH.old_account_number)  
 WHERE (accountnumber = @AccountNumber  or accountnumber=@PREVACCOUNTNUMBER)  
  AND UtilityCode = @UtilityCode    
  AND fromdate >= @BeginDate    
  AND todate <= @EndDate    
  AND UsageType <> @estimate    
  AND Active = 1    
--  AND fromdate >= '2009-01-01' -- no 2008 usage    
 ORDER BY fromdate DESC    
    
 SET NOCOUNT OFF;    
END    
    
-- Copyright 2010 Liberty Power  
GO


USE [ISTA]
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountByIdSelect]    Script Date: 05/26/2015 03:31:16 ******/
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
 Declare @PREVACCOUNTNUMBER varchar(50)
   
  SELECT TOP 1
      @PREVACCOUNTNUMBER=CASE WHEN 
					A.NEW_ACCOUNT_NUMBER=@AccountNumber THEN OLD_ACCOUNT_NUMBER 
					      ELSE NEW_ACCOUNT_NUMBER 
    END
     FROM LP_ACCOUNT..ACCOUNT_NUMBER_HISTORY(NOLOCK) A  
       WHERE (OLD_ACCOUNT_NUMBER=@AccountNumber OR NEW_ACCOUNT_NUMBER=@AccountNumber)
                        ORDER  BY A.DATE_CREATED DESC
  
  
  
 CREATE TABLE #METERREADS (UtilityCode varchar(50), AccountNumber varchar(50), FromDate datetime, ToDate datetime, TotalKWH int,  
  UsageType varchar(15), TransactionNbr varchar(200))  
  
 -- - - - - - - - - - - - - - - - - - - - - - - -   
 print '' print '* ' + dbo.ufn_datetime_format(getdate(), '(HH:MI:SS)') + '-- ticket 14435..'  
 -- - - - - - - - - - - - - - - - - - - - - - - -   
   
 INSERT INTO #METERREADS  
 SELECT DISTINCT utility, AccountNumber, FromDate, ToDate, TotalKWH, 'Billed', ''  
 FROM ista.dbo.vw_BilledUsage (NOLOCK)  
 WHERE (AccountNumber = @AccountNumber  or AccountNumber=@PREVACCOUNTNUMBER)
 -- SD 19685 - when NSTAR utility, only select by account number  
  AND utility = CASE WHEN @utilityCode LIKE '%NSTAR%' THEN utility ELSE @utilityCode END  
  
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
  SELECT DISTINCT RTRIM(UtilityCode) UtilityCode, AccountNumber, FromDate, ToDate, sum(TotalKWH) TotalKWH, UsageType, TransactionNbr TransactionNumber  
  FROM #METERREADS  
  WHERE fromdate >= @BeginDate  
   AND todate <= @EndDate  
  GROUP BY UtilityCode, AccountNumber, FromDate, ToDate, UsageType, TransactionNbr  
  ORDER BY FromDate DESC, UsageType DESC  
   END  
 ELSE  
   BEGIN  
  SELECT DISTINCT RTRIM(UtilityCode) UtilityCode, AccountNumber, FromDate, ToDate, sum(TotalKWH) TotalKWH, UsageType, TransactionNbr TransactionNumber  
  FROM #METERREADS  
  GROUP BY UtilityCode, AccountNumber, FromDate, ToDate, UsageType, TransactionNbr  
  ORDER BY FromDate DESC, UsageType DESC  
   END  
  
 SET NOCOUNT OFF;  
END  


GO


USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountByIdSelect]    Script Date: 05/26/2015 03:31:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************  
 * usp_AmerenScrapedUsageSelect  
 * Selects usage from the Ameren scraped table  
 *  
 * History  
 *04-03-2014: Return date created  
 *******************************************************************************  
 * 12-15-2010 - Eduardo Patino  
 * Created.  
 *******************************************************************************  
 */  
  
ALTER PROCEDURE [dbo].[usp_AmerenScrapedUsageSelect] (  
 @AccountNumber varchar(50),  
 @BeginDate  datetime,  
 @EndDate  datetime ,  
 @MeterNumber varchar(50) = '')  
AS  
  
/*  
select * from AmerenAccount order by 2, 6  
usp_AmerenScrapedUsageSelect '7865000116', '', '2008-11-16', '2011-01-16' -- Lighting  
*/  
BEGIN  
 SET NOCOUNT ON;
 
 DECLARE @PREVACCOUNTNUMBER VARCHAR(50)
 SELECT TOP 1
      @PREVACCOUNTNUMBER=CASE WHEN 
					A.NEW_ACCOUNT_NUMBER=@AccountNumber THEN OLD_ACCOUNT_NUMBER 
					      ELSE NEW_ACCOUNT_NUMBER 
    END
     FROM LP_ACCOUNT..ACCOUNT_NUMBER_HISTORY(NOLOCK) A  
       WHERE (OLD_ACCOUNT_NUMBER=@AccountNumber OR NEW_ACCOUNT_NUMBER=@AccountNumber)
                        ORDER  BY A.DATE_CREATED DESC
 
   
 IF @MeterNumber <> ''  
   BEGIN  
  SELECT DISTINCT t2.Id, AccountId, BeginDate, EndDate, Days, TotalKwh, OnPeakKwh, OffPeakKwh, OnPeakDemandKw, OffPeakDemandKw, PeakReactivePowerKvar,  
    AccountNumber, MeterNumber, t2.Created  
  FROM AmerenAccount (NOLOCK) t1 INNER JOIN  
    AmerenUsage (NOLOCK) t2 ON AccountId = t1.Id  
  WHERE (AccountNumber = @AccountNumber  or AccountNumber=@PREVACCOUNTNUMBER )
   AND MeterNumber = @MeterNumber  
   AND BeginDate >= @BeginDate  
   AND EndDate <= @EndDate  
  ORDER BY 3 DESC, 4  
   END  
 ELSE  
   BEGIN  
  SELECT DISTINCT t2.Id, AccountId, BeginDate, EndDate, Days, TotalKwh, OnPeakKwh, OffPeakKwh, OnPeakDemandKw, OffPeakDemandKw, PeakReactivePowerKvar,  
    AccountNumber, MeterNumber, t2.Created  
  FROM AmerenAccount (NOLOCK) t1 INNER JOIN  
    AmerenUsage (NOLOCK) t2 ON AccountId = t1.Id  
  WHERE (AccountNumber = @AccountNumber  or AccountNumber=@PREVACCOUNTNUMBER)
   AND BeginDate >= @BeginDate  
   AND EndDate <= @EndDate  
  ORDER BY 2, 3 DESC, 4  
   END  
  
 SET NOCOUNT OFF;  
END  
-- Copyright 2010 Liberty Power  

GO

USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountByIdSelect]    Script Date: 05/26/2015 03:31:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************  
 * usp_BgeScrapedUsageSelect  
 * Selects usage from the Bge scraped table  
 *  
 * History  
 *  
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
  
  DECLARE	@PREVACCOUNTNUMBER VARCHAR(50)
	
    SELECT TOP 1
      @PREVACCOUNTNUMBER=CASE WHEN 
					A.NEW_ACCOUNT_NUMBER=@AccountNumber THEN OLD_ACCOUNT_NUMBER 
					      ELSE NEW_ACCOUNT_NUMBER 
    END
     FROM LP_ACCOUNT..ACCOUNT_NUMBER_HISTORY(NOLOCK) A  
       WHERE (OLD_ACCOUNT_NUMBER=@AccountNumber OR NEW_ACCOUNT_NUMBER=@AccountNumber)
                        ORDER  BY A.DATE_CREATED DESC
                        
 SELECT DISTINCT Id, AccountNumber, MeterNumber, MeterType, BeginDate, EndDate, Days, TotalKwh, OnPeakKwh, OffPeakKwh, ReadingSource, IntermediatePeakKwh, SeasonalCrossOver, DeliveryDemandKw, GenTransDemandKw, UsageFactorNonTOU, UsageFactorOnPeak, 
 UsageFactorOffPeak, UsageFactorIntermediate, Created, CreatedBy, Modified, ModifiedBy  
 FROM BgeUsage (nolock)  
 WHERE (accountnumber = @AccountNumber  or accountnumber=@PREVACCOUNTNUMBER )
  AND BeginDate >= @BeginDate  
  AND EndDate <= @EndDate  
 ORDER BY 5 DESC  
  
 SET NOCOUNT OFF;  
END  
-- Copyright 2010 Liberty Power  

GO

USE [lp_transactions] 
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountByIdSelect]    Script Date: 05/26/2015 03:31:16 ******/
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
 *******************************************************************************
 * 02-03-2011 - Eduardo Patino
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_CmpScrapedUsageSelect] (
	@AccountNumber	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime )
AS
/*
select * from CmpAccount (nolock) where accountnumber = '04411059126012' order by 3, 1 desc
select * from CmpUsage (nolock) where accountnumber = '04411059126012' order by 4 desc
usp_CmpScrapedUsageSelect '04411059126012', '2008-11-16', '2010-11-16'
*/
BEGIN
	SET NOCOUNT ON;
DECLARE	@PREVACCOUNTNUMBER VARCHAR(50)
	
    SELECT TOP 1
      @PREVACCOUNTNUMBER=CASE WHEN 
					A.NEW_ACCOUNT_NUMBER=@AccountNumber THEN OLD_ACCOUNT_NUMBER 
					      ELSE NEW_ACCOUNT_NUMBER 
    END
     FROM LP_ACCOUNT..ACCOUNT_NUMBER_HISTORY(NOLOCK) A  
       WHERE (OLD_ACCOUNT_NUMBER=@AccountNumber OR NEW_ACCOUNT_NUMBER=@AccountNumber)
                        ORDER  BY A.DATE_CREATED DESC
                        
	SELECT	DISTINCT ID, AccountNumber, HighestDemandKw, RateCode, BeginDate, EndDate, Days, MeterNumber, TotalKwh, TotalUnmetered, TotalActiveUmetered, Created
	FROM	CmpUsage (nolock)
	WHERE	(accountnumber = @AccountNumber or accountnumber=@PREVACCOUNTNUMBER)
		AND BeginDate >= @BeginDate
		AND	EndDate <= @EndDate
	ORDER BY 3 DESC

	SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO

USE [lp_transactions] 
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountByIdSelect]    Script Date: 05/26/2015 03:31:16 ******/
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
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_ComedScrapedUsageSelect] (
	@AccountNumber	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime )
AS
/*
select * from ComedAccount (nolock) where accountnumber = '0010072045' order by 3, 1 desc
select * from ComedUsage (nolock) where accountnumber = '0010072045' order by 4 desc
usp_ComedScrapedUsageSelect '0010072045', '2008-11-16', '2010-11-16'
*/
BEGIN
	SET NOCOUNT ON;

DECLARE	@PREVACCOUNTNUMBER VARCHAR(50)
	
    SELECT TOP 1
      @PREVACCOUNTNUMBER=CASE WHEN 
					A.NEW_ACCOUNT_NUMBER=@AccountNumber THEN OLD_ACCOUNT_NUMBER 
					      ELSE NEW_ACCOUNT_NUMBER 
    END
     FROM LP_ACCOUNT..ACCOUNT_NUMBER_HISTORY(NOLOCK) A  
       WHERE (OLD_ACCOUNT_NUMBER=@AccountNumber OR NEW_ACCOUNT_NUMBER=@AccountNumber)
                        ORDER  BY A.DATE_CREATED DESC

	SELECT	DISTINCT AccountNumber, Rate, BeginDate, EndDate, Days, TotalKwh, OnPeakKwh, OffPeakKwh, BillingDemandKw, MonthlyPeakDemandKw, Created
	FROM	ComedUsage (nolock)
	WHERE	(AccountNumber = @AccountNumber or Accountnumber=@PREVACCOUNTNUMBER)
		AND BeginDate >= @BeginDate
		AND	EndDate <= @EndDate
	ORDER BY 1 DESC

	SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO

USE [lp_transactions] 
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountByIdSelect]    Script Date: 05/26/2015 03:31:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_ConedScrapedSelect
 * Selects usage from the coned scraped table
 *
 * History
 *
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
	
DECLARE	@PREVACCOUNTNUMBER VARCHAR(50)
	
    SELECT TOP 1
      @PREVACCOUNTNUMBER=CASE WHEN 
					A.NEW_ACCOUNT_NUMBER=@AccountNumber THEN OLD_ACCOUNT_NUMBER 
					      ELSE NEW_ACCOUNT_NUMBER 
    END
     FROM LP_ACCOUNT..ACCOUNT_NUMBER_HISTORY(NOLOCK) A  
       WHERE (OLD_ACCOUNT_NUMBER=@AccountNumber OR NEW_ACCOUNT_NUMBER=@AccountNumber)
                        ORDER  BY A.DATE_CREATED DESC
	SELECT	DISTINCT ID, AccountNumber, FromDate, ToDate, Usage, Demand, BillAmount, Created, CreatedBy, Modified, ModifiedBy
	FROM	ConedUsage (nolock)
	WHERE	(accountnumber = @AccountNumber or accountnumber = @PREVACCOUNTNUMBER)
		AND FromDate >= @BeginDate
		AND	ToDate <= @EndDate
	ORDER BY 3 DESC

	SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
GO

USE [lp_transactions] 
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountByIdSelect]    Script Date: 05/26/2015 03:31:16 ******/
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
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_PecoScrapedUsageSelect] (
	@AccountNumber	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime )
AS
/*
select * from PecoAccount (nolock) where accountnumber = '0217201203' order by 1 desc
select * from PecoUsage (nolock) where accountnumber = '0217201203' order by 2, 3 desc
usp_PecoScrapedUsageSelect '04411059126012', '2008-11-16', '2010-11-16'
*/
BEGIN
	SET NOCOUNT ON;

DECLARE	@PREVACCOUNTNUMBER VARCHAR(50)
	
    SELECT TOP 1
      @PREVACCOUNTNUMBER=CASE WHEN 
					A.NEW_ACCOUNT_NUMBER=@AccountNumber THEN OLD_ACCOUNT_NUMBER 
					      ELSE NEW_ACCOUNT_NUMBER 
    END
     FROM LP_ACCOUNT..ACCOUNT_NUMBER_HISTORY(NOLOCK) A  
       WHERE (OLD_ACCOUNT_NUMBER=@AccountNumber OR NEW_ACCOUNT_NUMBER=@AccountNumber)
                        ORDER  BY A.DATE_CREATED DESC
                        
	SELECT	DISTINCT ID, AccountNumber, FromDate, ToDate, Usage, Demand, Created
	FROM	PecoUsage (nolock)
	WHERE	(accountnumber = @AccountNumber or accountnumber=@PREVACCOUNTNUMBER)
		AND FromDate >= @BeginDate
		AND	ToDate <= @EndDate
	ORDER BY 3 DESC

	SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO

USE [lp_transactions] 
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountByIdSelect]    Script Date: 05/26/2015 03:31:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*******************************************************************************
 * usp_RgeScrapedUsageSelect
 * Selects usage from the peco scraped table
 *
 * History
 *04-03-2014: add created
 * 06-02-2011 - added meter number (from account table)..
 *******************************************************************************
 * 02-03-2011 - Eduardo Patino
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_RgeScrapedUsageSelect] (
	@AccountNumber	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime )
AS
/*
select * from RgeAccount (nolock) where accountnumber = 'R01000057083990' order by 1 desc
select * from RgeUsage (nolock) where kwh <> 0
usp_RgeScrapedUsageSelect 'R01000051132280', '2008-4-2', '2011-4-2'
*/
BEGIN
	SET NOCOUNT ON;

	SELECT	DISTINCT t1.Id, t1.AccountNumber, BeginDate, EndDate, ReadType, Kw, KwOn, KwOff,
			Kwh = (case when Kwh = 0 then KwhOn + KwhOff + KwhMid else Kwh end),
			KwhOn, KwhOff, KwhMid, Rkvah, Total, TotalTax, Days, MeterNumber, t1.Created
	FROM	RgeUsage (nolock) t1 inner join RgeAccount (nolock) t2 on t1.accountnumber = t2.accountnumber
	WHERE	t2.accountnumber = @AccountNumber
		AND BeginDate >= @BeginDate
		AND	EndDate <= @EndDate
		AND t2.id in (SELECT max(t3.id) FROM RgeAccount (nolock) t3 WHERE t3.accountnumber = t2.accountnumber)
	ORDER BY 3 DESC, 4

	SET NOCOUNT OFF;
END
-- Copyright 2011 Liberty Power

GO

USE [lp_transactions]  
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountByIdSelect]    Script Date: 05/26/2015 03:31:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*******************************************************************************
 * usp_NimoScrapedUsageSelect
 * Selects usage from the nimo scraped table
 *
 * History
 *
 *******************************************************************************
 * 11-18-2010 - Eduardo Patino
 * Created.
 *******************************************************************************
 */

ALTER PROCEDURE [dbo].[usp_NimoScrapedUsageSelect] (
	@AccountNumber	varchar(50),
	@BeginDate		datetime,
	@EndDate		datetime )
AS
-- usp_NimoScrapedUsageSelect '1309941223', '2008-11-16', '2010-11-16'
BEGIN
	SET NOCOUNT ON;

DECLARE	@PREVACCOUNTNUMBER VARCHAR(50)
	
    SELECT TOP 1
      @PREVACCOUNTNUMBER=CASE WHEN 
					A.NEW_ACCOUNT_NUMBER=@AccountNumber THEN OLD_ACCOUNT_NUMBER 
					      ELSE NEW_ACCOUNT_NUMBER 
    END
     FROM LP_ACCOUNT..ACCOUNT_NUMBER_HISTORY(NOLOCK) A  
       WHERE (OLD_ACCOUNT_NUMBER=@AccountNumber OR NEW_ACCOUNT_NUMBER=@AccountNumber)
                        ORDER  BY A.DATE_CREATED DESC

	SELECT	DISTINCT Id, AccountNumber, BeginDate, EndDate, BillCode, Days, BilledKwhTotal, MeteredPeakKw, MeteredOnPeakKw, BilledPeakKw, BilledOnPeakKw, BillDetailAmt, BilledRkva, OnPeakKwh, OffPeakKwh, ShoulderKwh, OffSeasonKwh, Created, CreatedBy, Modified

, ModifiedBy
	FROM	NimoUsage (nolock)
	WHERE	(accountnumber = @AccountNumber or accountnumber=@PREVACCOUNTNUMBER)
		AND BeginDate >= @BeginDate
		AND	EndDate <= @EndDate
	ORDER BY 3 DESC

	SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power






GO

USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[ComplaintAccountByIdSelect]    Script Date: 05/26/2015 03:31:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================  
-- AUTHOR:    <VIKAS SHARMA>  
-- CREATE DATE: <05-12-2014>  
-- DESCRIPTION:  <THE USP_GETIDRANNUALUSAGE GIVES THE ANNUAL USAGE FOR THE IDR DATA  . PBI-50187
-- THE USP_GETIDRANNUALUSAGE GIVES THE ANNUAL USAGE FOR THE ACCOUNT NO
-- MODIFIED BY : VIKAS SHARMA
-- DESCRIPTION  :  PBI 67644 MODIFIED FOR DUPLICATE DATA
-- EXEC [USP_GETIDRANNUALUSAGE] @ACCOUNTNO='08048076880000776226',@UTILITYCODE='JCP&L',@FROM='2010-04-02 06:51:59.733',@TO='2013-04-02 06:51:59.733'
-- EXEC [USP_GETIDRANNUALUSAGE] @ACCOUNTNO='145',@UTILITYCODE='COMED',@FROM='2012-12-05 06:51:59.733',@TO='2014-12-05 06:51:59.733'
-- EXEC [USP_GETIDRANNUALUSAGE] @ACCOUNTNO='00140060799255395',@UTILITYCODE='OHP',@FROM='2012-12-26 06:51:59.733',@TO='2014-12-26 06:51:59.733'  
-- =============================================  
ALTER PROCEDURE [dbo].[Usp_GetIDRAnnualUsage] @ACCOUNTNO VARCHAR(50),
@UTILITYCODE VARCHAR(50),
@FROM DATETIME,
@TO DATETIME

AS
BEGIN

	SET NOCOUNT ON;
	DECLARE
		@INSMULTIPLEMETERS SMALLINT = 0
		
	DECLARE	@PREVACCOUNTNUMBER VARCHAR(50)
	
    SELECT TOP 1
      @PREVACCOUNTNUMBER=CASE WHEN 
					A.NEW_ACCOUNT_NUMBER=@ACCOUNTNO THEN OLD_ACCOUNT_NUMBER 
					      ELSE NEW_ACCOUNT_NUMBER 
    END
     FROM LP_ACCOUNT..ACCOUNT_NUMBER_HISTORY(NOLOCK) A  
       WHERE (OLD_ACCOUNT_NUMBER=@ACCOUNTNO OR NEW_ACCOUNT_NUMBER=@ACCOUNTNO)
                        ORDER  BY A.DATE_CREATED DESC
     
     
     

	SELECT
		EA.UTILITYCODE,
		EA.ACCOUNTNUMBER,
		IUH.DATE,
		IUH.METERNUMBER,
		IUH.ID AS IDRHID,
		IUH.TIMESTAMPINSERT,

		(ISNULL(IUH.[15], 0) + ISNULL(IUH.[30], 0) + ISNULL(IUH.[45], 0) + ISNULL(IUH.[100], 0)) AS C100,

		(ISNULL(IUH.[115], 0) + ISNULL(IUH.[130], 0) + ISNULL(IUH.[145], 0) + ISNULL(IUH.[200], 0)) AS C200,

		(ISNULL(IUH.[215], 0) + ISNULL(IUH.[230], 0) + ISNULL(IUH.[245], 0) + ISNULL(IUH.[300], 0)) AS C300,

		(ISNULL(IUH.[315], 0) + ISNULL(IUH.[330], 0) + ISNULL(IUH.[345], 0) + ISNULL(IUH.[400], 0)) AS C400,

		(ISNULL(IUH.[415], 0) + ISNULL(IUH.[430], 0) + ISNULL(IUH.[445], 0) + ISNULL(IUH.[500], 0)) AS C500,

		(ISNULL(IUH.[515], 0) + ISNULL(IUH.[530], 0) + ISNULL(IUH.[545], 0) + ISNULL(IUH.[600], 0)) AS C600,

		(ISNULL(IUH.[615], 0) + ISNULL(IUH.[630], 0) + ISNULL(IUH.[645], 0) + ISNULL(IUH.[700], 0)) AS C700,

		(ISNULL(IUH.[715], 0) + ISNULL(IUH.[730], 0) + ISNULL(IUH.[745], 0) + ISNULL(IUH.[800], 0)) AS C800,

		(ISNULL(IUH.[815], 0) + ISNULL(IUH.[830], 0) + ISNULL(IUH.[845], 0) + ISNULL(IUH.[900], 0)) AS C900,

		(ISNULL(IUH.[915], 0) + ISNULL(IUH.[930], 0) + ISNULL(IUH.[945], 0) + ISNULL(IUH.[1000], 0)) AS C1000,

		(ISNULL(IUH.[1015], 0) + ISNULL(IUH.[1030], 0) + ISNULL(IUH.[1045], 0) + ISNULL(IUH.[1100], 0)) AS C1100,

		(ISNULL(IUH.[1115], 0) + ISNULL(IUH.[1130], 0) + ISNULL(IUH.[1145], 0) + ISNULL(IUH.[1200], 0)) AS C1200,

		(ISNULL(IUH.[1215], 0) + ISNULL(IUH.[1230], 0) + ISNULL(IUH.[1245], 0) + ISNULL(IUH.[1300], 0)) AS C1300,

		(ISNULL(IUH.[1315], 0) + ISNULL(IUH.[1330], 0) + ISNULL(IUH.[1345], 0) + ISNULL(IUH.[1400], 0)) AS C1400,

		(ISNULL(IUH.[1415], 0) + ISNULL(IUH.[1430], 0) + ISNULL(IUH.[1445], 0) + ISNULL(IUH.[1500], 0)) AS C1500,

		(ISNULL(IUH.[1515], 0) + ISNULL(IUH.[1530], 0) + ISNULL(IUH.[1545], 0) + ISNULL(IUH.[1600], 0)) AS C1600,

		(ISNULL(IUH.[1615], 0) + ISNULL(IUH.[1630], 0) + ISNULL(IUH.[1645], 0) + ISNULL(IUH.[1700], 0)) AS C1700,

		(ISNULL(IUH.[1715], 0) + ISNULL(IUH.[1730], 0) + ISNULL(IUH.[1745], 0) + ISNULL(IUH.[1800], 0)) AS C1800,

		(ISNULL(IUH.[1815], 0) + ISNULL(IUH.[1830], 0) + ISNULL(IUH.[1845], 0) + ISNULL(IUH.[1900], 0)) AS C1900,

		(ISNULL(IUH.[1915], 0) + ISNULL(IUH.[1930], 0) + ISNULL(IUH.[1945], 0) + ISNULL(IUH.[2000], 0)) AS C2000,

		(ISNULL(IUH.[2015], 0) + ISNULL(IUH.[2030], 0) + ISNULL(IUH.[2045], 0) + ISNULL(IUH.[2100], 0)) AS C2100,

		(ISNULL(IUH.[2115], 0) + ISNULL(IUH.[2130], 0) + ISNULL(IUH.[2145], 0) + ISNULL(IUH.[2200], 0)) AS C2200,

		(ISNULL(IUH.[2215], 0) + ISNULL(IUH.[2230], 0) + ISNULL(IUH.[2245], 0) + ISNULL(IUH.[2300], 0)) AS C2300,

		(ISNULL(IUH.[2315], 0) + ISNULL(IUH.[2330], 0) + ISNULL(IUH.[2345], 0) + ISNULL(IUH.[2359], 0) + ISNULL(IUH.[0], 0)) AS C2400 INTO #TEMPUTILITYHOURLYDATA1
	FROM LP_TRANSACTIONS..IDRUSAGEHORIZONTAL IUH WITH (NOLOCK)
	INNER JOIN LP_TRANSACTIONS..EDIACCOUNT EA WITH (NOLOCK)
	ON IUH.EDIACCOUNTID = EA.ID 
	WHERE EA.UTILITYCODE = @UTILITYCODE  --AND IUH.TRANSACTIONSETPURPOSECODE = 52  
	AND( EA.AccountNumber=@ACCOUNTNO or EA.AccountNumber=@PREVACCOUNTNUMBER)
	AND IUH.UNITOFMEASUREMENT IN ('KH')
	AND IUH.[DATE] >= CONVERT(VARCHAR(10), @FROM, 101)
	AND IUH.[DATE] <= CONVERT(VARCHAR(10), @TO, 101)
	ORDER BY EA.UTILITYCODE, EA.ACCOUNTNUMBER, IUH.DATE DESC

	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY
		[DATE]
	  ,ACCOUNTNUMBER
		ORDER BY
		[DATE] DESC,
		METERNUMBER DESC,
		TIMESTAMPINSERT DESC

		) AS ROW_NUM INTO #TEMPUTILITYHOURLYDATA
	FROM #TEMPUTILITYHOURLYDATA1(NOLOCK)
	
	
	/*  
	  If We have Records of Two Account Number 1 for which we have records on Current Date.2 For which we have records earlier. Then if we have date Conflict then 
	  we take one of them.
	*/

		DELETE FROM #TEMPUTILITYHOURLYDATA WHERE ROW_NUM>1


	/*
    GIVEN A DATE, IF THERE ARE MULTIPLE RECORDS PER METER NUMBER (METER NUMBER IS DEFINED), THE RECORD WITH THE LATEST RECORD ID IS SELECTED AND ALL OTHER RECORDS ARE DISCARDED.
  
  
  */


	DELETE
		TEMPHOURLYOUTERDATA
	FROM #TEMPUTILITYHOURLYDATA TEMPHOURLYOUTERDATA
	INNER JOIN (SELECT
		MAX(IDRHID) AS IDRHID,
		ACCOUNTNUMBER,
		[DATE],
		METERNUMBER
	FROM #TEMPUTILITYHOURLYDATA(NOLOCK)
	WHERE ISNULL(METERNUMBER, '') <> ''
	GROUP BY	ACCOUNTNUMBER,
						[DATE],
						METERNUMBER
	HAVING COUNT(1) > 1) TEMPHOURLYINNERDATA
		ON TEMPHOURLYOUTERDATA.ACCOUNTNUMBER = TEMPHOURLYINNERDATA.ACCOUNTNUMBER
		AND TEMPHOURLYOUTERDATA.DATE = TEMPHOURLYINNERDATA.DATE
		AND TEMPHOURLYOUTERDATA.IDRHID <> TEMPHOURLYINNERDATA.IDRHID
		AND ISNULL(TEMPHOURLYOUTERDATA.METERNUMBER, '') <> ''
		AND TEMPHOURLYINNERDATA.METERNUMBER = TEMPHOURLYOUTERDATA.METERNUMBER





	/*
 
 
  
  GIVEN A DATE, IF THERE ARE MULTIPLE RECORDS WITH UNDEFINED METER NUMBER, DE-DUPE THE RECORDS WITH THE SAME 24 HOURLY DATA (HOURLY DATA IS THE SUM OF ALL INTERVALS IN THE HOUR -- SEE BELOW FOR INTERVALS IN EACH HOUR).  THAT IS, IF THERE ARE MULTIPLE RECO
RDS WITH THE SAME HOURLY DATA FOR EACH HOUR, THEN ONE OF THE RECORD IS SELECTED AND ALL OTHER RECORDS ARE DISCARDED.
AFTER THE RECORDS WITH UNDEFINED METER NUMBER ARE DE-DUPED, IF THERE ARE RECORDS PER METER NUMBER, DE-DUPE THE RECORD OF UNDEFINED METER NUMBER AGAINST THE RECORD OF EACH METER NUMBER FOR EACH DAY WITH THE SAME 24 HOURLY DATA.
  
  
  
  */


	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY
		[DATE]
		,C100, C200, C300, C400
	  , C500, C600, C700, C800
	  , C900, C1000, C1100, C1200
	  , C1300, C1400, C1500, C1600
	  , C1700, C1800, C1900, C2000
	  , C2100, C2200, C2300, C2400
		ORDER BY
		[DATE] DESC,
		METERNUMBER DESC,
		TIMESTAMPINSERT DESC

		) AS MULTIPLEMETERCOUNT INTO #TEMP_HOURLYRECORD
	FROM #TEMPUTILITYHOURLYDATA(NOLOCK)





	CREATE TABLE #TEMPDAILYUSAGEFROMINTERVAL (
		ID INT IDENTITY,
		ACCOUNTNUMBER VARCHAR(50),
		SUMMARIZEDATE DATETIME,
		QUANTITY DECIMAL(18, 9),
		METERNUMBER VARCHAR(50),
	)

	INSERT INTO #TEMPDAILYUSAGEFROMINTERVAL (ACCOUNTNUMBER,
	SUMMARIZEDATE,
	QUANTITY,
	METERNUMBER)
		SELECT
			ACCOUNTNUMBER,
			[DATE] AS SUMMARIZEDATE,
			SUM([C100] + C200 + C300
			+ C400 + C500 + C600
			+ C700 + C800 + C900
			+ C1000 + C1100 + C1200
			+ C1300 + C1400 + C1500
			+ C1600 + C1700 + C1800
			+ C1900 + C2000 + C2100
			+ C2200 + C2300 + C2400) AS QUANTITY,
			METERNUMBER

		FROM #TEMP_HOURLYRECORD A(NOLOCK)
		WHERE MULTIPLEMETERCOUNT <= (SELECT
			CASE WHEN MAX(MULTIPLEMETERCOUNT) > 1 THEN
						MAX(MULTIPLEMETERCOUNT) ELSE
					1
			END
		FROM #TEMP_HOURLYRECORD(NOLOCK)
		WHERE A.ACCOUNTNUMBER = ACCOUNTNUMBER
		AND A.DATE = DATE
		AND ISNULL(METERNUMBER, '') <> '')
		GROUP BY	ACCOUNTNUMBER,
							[DATE],
							METERNUMBER




	-- SELECTING DATERANGE FOR MIN AND MAX  
	DECLARE
		@YEARMINDATE DATETIME
	DECLARE
		@YEARMAXDATE DATETIME

	SELECT
		@YEARMAXDATE = MAX(SUMMARIZEDATE),
		@YEARMINDATE = DATEADD(DD, -364, @YEARMAXDATE)
	FROM #TEMPDAILYUSAGEFROMINTERVAL


	DELETE
		FROM
			#TEMPDAILYUSAGEFROMINTERVAL
	WHERE SUMMARIZEDATE < @YEARMINDATE




	---   SUM OF USAGE ACCORDING TO THE METER NUMBER  


SELECT SUM(ANNUALUSAGE) as ANNUALUSAGE,
       @ACCOUNTNO as ACCOUNTNUMBER,
       max(ISIDRRESULTS) as ISIDRRESULTS
       From
	(SELECT
		CASE WHEN SUM(ANNUALUSAGE) > 0 THEN
					CAST(SUM(ANNUALUSAGE) AS INT) ELSE
				-1
		END AS ANNUALUSAGE,
		ACCOUNTNUMBER,
		1 as TempColumn,
		CASE WHEN COUNT(1) > 0 THEN
					1 ELSE
				0
		END AS ISIDRRESULTS
	FROM (SELECT
		CASE WHEN COUNT(1) > 0 THEN
					CAST(SUM(QUANTITY) / COUNT(1) AS DECIMAL(18, 9)) * 365 ELSE
				0
		END AS ANNUALUSAGE,
		METERNUMBER,
		ACCOUNTNUMBER
	FROM #TEMPDAILYUSAGEFROMINTERVAL A(NOLOCK)
	GROUP BY	A.METERNUMBER,
						A.ACCOUNTNUMBER) VW_SUMMETERNUMBER
	GROUP BY ACCOUNTNUMBER)VW_2




		SELECT TOP 1 * 
		      FROM #TEMPDAILYUSAGEFROMINTERVAL ORDER BY SUMMARIZEDATE DESC



	SET NOCOUNT OFF;
END

GO