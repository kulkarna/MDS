USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetEdiMeterReadsMostRecent]    Script Date: 01/13/2016 08:55:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************  
 * usp_GetEdiMeterReads  
 * retrieves most recent usage from the transacton's database (edi)  
 * usp_GetEdiMeterReadsMostRecent '1001775447001', 'DUQ', '10/16/2023', '10/16/2014'  
 *  
 *******************************************************************************  
 * 10/20/2014 - Cathy Ghazal  
 * Created.  
 *******************************************************************************  
 */  
  
CREATE PROCEDURE [dbo].[usp_GetEdiMeterReadsMostRecent]  
(  
 @AccountNumber varchar(50),  
 @utilityCode varchar(50),  
 @BeginDate  datetime,  
 @EndDate  datetime  
)  
  
AS  
  
BEGIN  
 SET NOCOUNT ON;  
  
 declare @multipleMeters smallint  
 select @multipleMeters = multipleMeters from libertyPower..Utility where UtilityCode = @utilityCode  
  
  SELECT * INTO #TEMPACCOUNTS  
    FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@accountnumber)
  
 create table #usage (UsageID BIGINT,  
  AccountNumber varchar(30), UtilityCode varchar(20), BeginDate datetime,  
  EndDate datetime, Quantity int, MeasurementSignificanceCode varchar (5),  
  MeterNumber varchar(50), TransactionSetPurposeCode varchar(5))  
  
 create table #usage2 (UsageID BIGINT,  
  AccountNumber varchar(30), UtilityCode varchar(20), BeginDate datetime,  
  EndDate datetime, Quantity int, MeasurementSignificanceCode varchar (5),  
  MeterNumber varchar(50), TransactionSetPurposeCode varchar(5))  
  
 insert into #usage  
 select distinct UsageID,  
   AccountNumber,  
   UtilityCode,  
   BeginDate,  
   EndDate,  
   abs(Quantity),  
   '',  
   MeterNumber,  
   TransactionSetPurposeCode  
 from [vw_edi_historical_usage] (NOLOCK)  
 where accountnumber IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
  and @utilityCode <> 'AMEREN'  
  and utilityCode = @utilityCode  
  and TransactionSetPurposeCode in ('52', '00', '01')  
  and MeasurementSignificanceCode in ('51', '22', '46')  
 UNION  
 SELECT distinct  
   b.ID as UsageID,  
   a.AccountNumber  
   ,a.UtilityCode  
   ,b.BeginDate  
   ,b.EndDate  
   ,abs(b.Quantity)  
   ,'' MeasurementSignificanceCode  
   ,b.MeterNumber  
   ,b.TransactionSetPurposeCode  
 FROM   
  EdiAccount a (NOLOCK) inner join  
  EdiUsageDetail b (NOLOCK) on a.id = b.ediaccountid  
 where accountnumber IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
  and UnitOfMeasurement = 'kh'  
  and b.MeterNumber <> ''  
  and @utilityCode = 'AMEREN'  
  and TransactionSetPurposeCode in ('52', '00', '01')  
  and MeasurementSignificanceCode in ('51', '')  
  
 -- ERCOT Re-Bills  
 insert into #usage  
 select distinct   
   UsageID,  
   AccountNumber,  
   UtilityCode,  
   BeginDate,  
   EndDate,  
   abs(Quantity),  
   '',  
   MeterNumber,  
   TransactionSetPurposeCode  
 from [vw_edi_historical_usage] (NOLOCK)  
 where accountnumber IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
  and @utilityCode in (select distinct t3.utilitycode from libertypower..utility t3 where WholeSaleMktID = 'ERCOT')  
  and utilityCode = @utilityCode  
  and TransactionSetPurposeCode in ('05')  
  and MeasurementSignificanceCode in ('51')  
  
 IF @@ROWCOUNT > 0  
   BEGIN  
  DELETE FROM #usage  
  WHERE AccountNumber IN (  
     SELECT DISTINCT t1.AccountNumber FROM #usage t1  
     WHERE t1.BeginDate = #usage.BeginDate AND t1.EndDate = #usage.EndDate AND t1.TransactionSetPurposeCode = '05')  
   AND TransactionSetPurposeCode = '00'  
  
  UPDATE #usage SET TransactionSetPurposeCode = '00' WHERE TransactionSetPurposeCode = '05'  
   END  
  
 insert into #usage  
 select distinct   
   UsageID,  
   AccountNumber,  
   UtilityCode,  
   BeginDate,  
   EndDate,  
   abs(Quantity),  
   MeasurementSignificanceCode,  
   MeterNumber,  
   TransactionSetPurposeCode  
 from [vw_edi_historical_usage] (NOLOCK) t1  
 where accountnumber IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
  and @utilityCode <> 'AMEREN'  
  and accountnumber not in (select distinct t2.accountnumber  
   from #usage t2 where t1.accountnumber = t2.accountnumber and t1.BeginDate = t2.BeginDate and t1.EndDate = t2.EndDate)  
  and utilityCode = @utilityCode  
  and TransactionSetPurposeCode in ('52', '00', '01')  
  and MeasurementSignificanceCode in ('41','42','43')  
 UNION  
 SELECT distinct  
   b.ID as UsageID,  
   a.AccountNumber     ,a.UtilityCode  
   ,b.BeginDate  
   ,b.EndDate  
   ,abs(b.Quantity)  
   ,'' MeasurementSignificanceCode  
   ,b.MeterNumber  
   ,b.TransactionSetPurposeCode  
 FROM   
  EdiAccount a (NOLOCK) inner join  
  EdiUsageDetail b (NOLOCK) on a.id = b.ediaccountid  
 where accountnumber IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
  and accountnumber not in (select distinct t2.accountnumber  
   from #usage t2 where a.accountnumber = t2.accountnumber and b.BeginDate = t2.BeginDate and b.EndDate = t2.EndDate)  
  and UnitOfMeasurement = 'kh'  
  and b.MeterNumber <> ''  
  and @utilityCode = 'AMEREN'  
  and TransactionSetPurposeCode in ('52', '00', '01')  
  and MeasurementSignificanceCode in ('41','42','43')  
  
 if @multipleMeters = 0  
   begin  
  insert into #usage2  
  select distinct   
    MAx(UsageID) as UsageID,  
    @AccountNumber as AccountNumber,  
    UtilityCode,  
    BeginDate,  
    EndDate,  
    Quantity,  
    MeasurementSignificanceCode,  
    max(MeterNumber) MeterNumber,  
    TransactionSetPurposeCode  
  from #usage  
  where beginDate >= @BeginDate  
   and endDate <= @EndDate  
  group by  
   -- AccountNumber,  
    UtilityCode,  
    Quantity,  
    BeginDate,  
    EndDate,  
    MeasurementSignificanceCode,  
    TransactionSetPurposeCode  
   end  
  
 if @multipleMeters = 1  
   begin  
  select   
    MAX(UsageID) as UsageID,  
    @AccountNumber as AccountNumber,  
    UtilityCode,  
    BeginDate,  
    EndDate,  
    Sum(Quantity) as Quantity,  
    '' MeasurementSignificanceCode,  
    MeterNumber,  
    TransactionSetPurposeCode  
  INTO #M  
  from #usage  
  where beginDate >= @BeginDate  
   and endDate <= @EndDate  
  group by  
   -- AccountNumber,  
    UtilityCode,  
    BeginDate,  
    EndDate,  
    MeterNumber,  
    TransactionSetPurposeCode  
  order by 4, 7  
    
  SELECT MAX(UsageID) as UsageID,  
    BeginDate,  
    EndDate,  
    Quantity,  
    TransactionSetPurposeCode  
  INTO #ONE  
  FROM #M  
  GROUP BY BeginDate, EndDate,Quantity,  
    TransactionSetPurposeCode  
  
  SELECT distinct m.*  
  FROM #M m  
  INNER JOIN #ONE o  
  ON  m.UsageID=o.UsageID  
  ORDER BY 4, 7  
    
   end  
 else  
   begin  
  select   
    MAX(UsageID) as UsageID,  
    @AccountNumber as AccountNumber,  
    UtilityCode,  
    BeginDate,  
    EndDate,  
    Sum(Quantity) as Quantity,  
    '' MeasurementSignificanceCode,  
    max(MeterNumber) MeterNumber,  
    TransactionSetPurposeCode  
  INTO #U  
  from #usage2  
  where beginDate >= @BeginDate  
   and endDate <= @EndDate  
  group by  
   -- AccountNumber,  
    UtilityCode,  
    BeginDate,  
    EndDate,  
    TransactionSetPurposeCode  
  order by 4, 7  
    
  SELECT MAX(UsageID) as UsageID,  
    BeginDate,  
    EndDate,  
    Quantity,  
    TransactionSetPurposeCode  
  INTO #Unique  
  FROM #U  
  GROUP BY BeginDate, EndDate,Quantity,  
    TransactionSetPurposeCode  
  
  SELECT distinct m.*  
  FROM #U m  
  INNER JOIN #Unique o  
  ON  m.UsageID=o.UsageID  
  ORDER BY 4, 7  
  
  
   end  
  
 SET NOCOUNT OFF;  
END  
-- Copyright 2010 Liberty Power
GO
/****** Object:  StoredProcedure [dbo].[usp_GetEdiMeterReads]    Script Date: 01/13/2016 08:55:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************  
 * usp_GetEdiMeterReads  
 * retrieves usage from the transacton's database (edi)  
 *  
 * History  
 * 08/09/2010 - using the summary view instead of the regular one 8-|  
 * 08/11/2010 - ticket 17577  
 * 01/19/2011 - Rick Deigsler - added 51, 22 in first query  
 * 02/09/2011 - ticket 21116 (rolled back Rick's changes + split up query between  
 *    detail and summary per Douglas request  
 * 06/10/2011 - IT022 - added multiple meter to sp..  
 * 07/28/2011 - Wholesale discovered a couple of bugs.. adjusting..  
 * 08/02/2011 - per Igancio's/Douglas' request, checking for summary, then detail..  
 * 08/11/2011 - bug found by Rick: it wasn't adding up the details (41, 42, 43)..  
 * 09/06/2011 - same bug, but for mm acct's..  
 * 09/14/2011 - per Rick/Eric/Douglas, we should include TransactionSetPurposeCode = 05  
 *    which means replace (i.e. utility messed up)..  
 * 09/19/2011 - ameren sends meter numbers at the detail level  
 * 10/11/2011 - SD24256 - nyseg/rge send cancels with negative values..  
 *  
 *******************************************************************************  
 * 04/27/2010 - Eduardo Patino  
 * Created.  
 *******************************************************************************  
 */  
  
CREATE PROCEDURE [dbo].[usp_GetEdiMeterReads]  
(  
 @AccountNumber varchar(50),  
 @utilityCode varchar(50),  
 @BeginDate  datetime,  
 @EndDate  datetime  
)  
  
AS  
/*  
select * from sys.procedures where name = 'usp_GetEdiMeterReads'  
usp_GetEdiMeterReads 'R01000058597550', 'RGE', '01/01/2009', '10/01/2011'  
select * from #usage order by 3 -- drop table #usage  drop table #usage2  
select * from [vw_edi_historical_usage] where accountnumber = '08048195820006272047'  
  
declare @accountnumber varchar(50),  
 @utilityCode varchar(50),  
 @BeginDate  datetime,  
 @EndDate  datetime  
  
set @accountnumber = '0307208973'  
set @utilityCode = 'AMEREN'  
set @BeginDate = '01/01/2009'  
set @EndDate = '10/01/2011'  
*/  
BEGIN  
 SET NOCOUNT ON;  
  
 declare @multipleMeters smallint  
 select @multipleMeters = multipleMeters from libertyPower..Utility where UtilityCode = @utilityCode  
  
  SELECT * INTO #TEMPACCOUNTS  
    FROM LP_ACCOUNT.DBO.UFNGETCHANGEDTABLEVALUE(@accountnumber)
  
 create table #usage (  
  AccountNumber varchar(30), UtilityCode varchar(20), BeginDate datetime,  
  EndDate datetime, Quantity int, MeasurementSignificanceCode varchar (5),  
  MeterNumber varchar(50), TransactionSetPurposeCode varchar(5))  
  
 create table #usage2 (  
  AccountNumber varchar(30), UtilityCode varchar(20), BeginDate datetime,  
  EndDate datetime, Quantity int, MeasurementSignificanceCode varchar (5),  
  MeterNumber varchar(50), TransactionSetPurposeCode varchar(5))  
  
 insert into #usage  
 select distinct AccountNumber,  
   UtilityCode,  
   BeginDate,  
   EndDate,  
   abs(Quantity),  
   '',  
   MeterNumber,  
   TransactionSetPurposeCode  
 from [vw_edi_historical_usage] (NOLOCK)  
 where accountnumber  IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
  and @utilityCode <> 'AMEREN'  
  and utilityCode = @utilityCode  
  and TransactionSetPurposeCode in ('52', '00', '01')  
  and MeasurementSignificanceCode in ('51', '22', '46')  
 UNION  
 SELECT distinct  
   a.AccountNumber  
   ,a.UtilityCode  
   ,b.BeginDate  
   ,b.EndDate  
   ,abs(b.Quantity)  
   ,'' MeasurementSignificanceCode  
   ,b.MeterNumber  
   ,b.TransactionSetPurposeCode  
 FROM   
  EdiAccount a (NOLOCK) inner join  
  EdiUsageDetail b (NOLOCK) on a.id = b.ediaccountid  
 where accountnumber  IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
  and UnitOfMeasurement = 'kh'  
  and b.MeterNumber <> ''  
  and @utilityCode = 'AMEREN'  
  and TransactionSetPurposeCode in ('52', '00', '01')  
  and MeasurementSignificanceCode in ('51', '')  
  
 -- ERCOT Re-Bills  
 insert into #usage  
 select distinct AccountNumber,  
   UtilityCode,  
   BeginDate,  
   EndDate,  
   abs(Quantity),  
   '',  
   MeterNumber,  
   TransactionSetPurposeCode  
 from [vw_edi_historical_usage] (NOLOCK)  
 where accountnumber  IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
  and @utilityCode in (select distinct t3.utilitycode from libertypower..utility t3 where WholeSaleMktID = 'ERCOT')  
  and utilityCode = @utilityCode  
  and TransactionSetPurposeCode in ('05')  
  and MeasurementSignificanceCode in ('51')  
  
 IF @@ROWCOUNT > 0  
   BEGIN  
  DELETE FROM #usage  
  WHERE AccountNumber IN (  
     SELECT DISTINCT t1.AccountNumber FROM #usage t1  
     WHERE t1.BeginDate = #usage.BeginDate AND t1.EndDate = #usage.EndDate AND t1.TransactionSetPurposeCode = '05')  
   AND TransactionSetPurposeCode = '00'  
  
  UPDATE #usage SET TransactionSetPurposeCode = '00' WHERE TransactionSetPurposeCode = '05'  
   END  
  
 insert into #usage  
 select distinct AccountNumber,  
   UtilityCode,  
   BeginDate,  
   EndDate,  
   abs(Quantity),  
   MeasurementSignificanceCode,  
   MeterNumber,  
   TransactionSetPurposeCode  
 from [vw_edi_historical_usage] (NOLOCK) t1  
 where accountnumber  IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
  and @utilityCode <> 'AMEREN'  
  and accountnumber not in (select distinct t2.accountnumber  
   from #usage t2 where t1.accountnumber = t2.accountnumber and t1.BeginDate = t2.BeginDate and t1.EndDate = t2.EndDate)  
  and utilityCode = @utilityCode  
  and TransactionSetPurposeCode in ('52', '00', '01')  
  and MeasurementSignificanceCode in ('41','42','43')  
 UNION  
 SELECT distinct  
   a.AccountNumber  
   ,a.UtilityCode  
   ,b.BeginDate  
   ,b.EndDate  
   ,abs(b.Quantity)  
   ,'' MeasurementSignificanceCode  
   ,b.MeterNumber  
   ,b.TransactionSetPurposeCode  
 FROM   
  EdiAccount a (NOLOCK) inner join  
  EdiUsageDetail b (NOLOCK) on a.id = b.ediaccountid  
 where accountnumber  IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
  and accountnumber not in (select distinct t2.accountnumber  
   from #usage t2 where a.accountnumber = t2.accountnumber and b.BeginDate = t2.BeginDate and b.EndDate = t2.EndDate)  
  and UnitOfMeasurement = 'kh'  
  and b.MeterNumber <> ''  
  and @utilityCode = 'AMEREN'  
  and TransactionSetPurposeCode in ('52', '00', '01')  
  and MeasurementSignificanceCode in ('41','42','43')  
  
 if @multipleMeters = 0  
   begin  
  insert into #usage2  
  select distinct @AccountNumber as AccountNumber,  
    UtilityCode,  
    BeginDate,  
    EndDate,  
    Quantity,  
    MeasurementSignificanceCode,  
    max(MeterNumber) MeterNumber,  
    TransactionSetPurposeCode  
  from #usage  
  where beginDate >= @BeginDate  
   and endDate <= @EndDate  
  group by  
    --AccountNumber,  
    UtilityCode,  
    Quantity,  
    BeginDate,  
    EndDate,  
    MeasurementSignificanceCode,  
    TransactionSetPurposeCode  
   end  
  
 if @multipleMeters = 1  
   begin  
  select @AccountNumber as AccountNumber,  
    UtilityCode,  
    BeginDate,  
    EndDate,  
    Sum(Quantity) as Quantity,  
    '' MeasurementSignificanceCode,  
    MeterNumber,  
    TransactionSetPurposeCode  
  from #usage  
  where beginDate >= @BeginDate  
   and endDate <= @EndDate  
  group by  
    --AccountNumber,  
    UtilityCode,  
    BeginDate,  
    EndDate,  
    MeterNumber,  
    TransactionSetPurposeCode  
  order by 3, 6  
   end  
 else  
   begin  
  select @AccountNumber as AccountNumber,  
    UtilityCode,  
    BeginDate,  
    EndDate,  
    Sum(Quantity) as Quantity,  
    '' MeasurementSignificanceCode,  
    max(MeterNumber) MeterNumber,  
    TransactionSetPurposeCode  
  from #usage2  
  where beginDate >= @BeginDate  
   and endDate <= @EndDate  
  group by  
    --AccountNumber,  
    UtilityCode,  
    BeginDate,  
    EndDate,  
    TransactionSetPurposeCode  
  order by 3, 6  
   end  
  
 SET NOCOUNT OFF;  
END  
-- Copyright 2010 Liberty Power
GO
