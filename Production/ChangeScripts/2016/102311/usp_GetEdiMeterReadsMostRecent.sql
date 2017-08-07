
Use [lp_transactions] 
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
----/*******************************************************************************
---- * usp_GetEdiMeterReads
---- * retrieves most recent usage from the transacton's database (edi)
---- * usp_GetEdiMeterReadsMostRecent '1001775447001', 'DUQ', '10/16/2023', '10/16/2014'
---- *
---- *******************************************************************************
---- * 10/20/2014 - Cathy Ghazal
---- * Created.
---- * 01/15/2016 -- Santosh Rao
---- * Modified for Utiltiy PSEG
---- *******************************************************************************
---- */

Alter PROCEDURE [dbo].[usp_GetEdiMeterReadsMostRecent]
(
   @AccountNumber       varchar(50),
   @utilityCode  varchar(50),
   @BeginDate           datetime,
   @EndDate             datetime
)

AS

BEGIN
       SET NOCOUNT ON;     

  
  /* For Testing Start 
       
              if object_id('tempdb..#usage') is not null
                     drop table #usage
          
              if object_id('tempdb..#usage2') is not null
                     drop table #usage2
          
              if object_id('tempdb..#M') is not null
                     drop table #M
          
              if object_id('tempdb..#ONE') is not null
                     drop table #ONE
          
              if object_id('tempdb..#U') is not null
                     drop table #U
                 
              if object_id('tempdb..#Unique') is not null
                     drop table #Unique

              if object_id('tempdb..#TEMPACCOUNTS') is not null
                     drop table #TEMPACCOUNTS

                     Declare @AccountNumber     varchar(50)
                     Declare @utilityCode		varchar(50)
                     Declare @BeginDate         datetime
                     Declare @EndDate           datetime

                     SET @AccountNumber='PE000010032295748518'
                     SET @utilityCode ='PSEG'
                     SET @BeginDate='2013-10-01 00:00:00.000'
                     SET @EndDate='2013-10-29 00:00:00.000'
                     --SET @BeginDate='2014-07-02 00:00:00.000'
                     --SET @EndDate='2014-07-31 00:00:00.000'
       
        For Testing End */

       
       declare       @multipleMeters      smallint

       select @multipleMeters      = multipleMeters from libertyPower..Utility where UtilityCode = @utilityCode

       
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
       from   [vw_edi_historical_usage] (NOLOCK)
       where  accountnumber IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK)) 
              and @utilityCode Not In('AMEREN','PSEG')
                       and utilityCode = @utilityCode
              and TransactionSetPurposeCode in ('52', '00', '01')
              and MeasurementSignificanceCode in ('51', '22', '46')

              UNION
/*Start Modification*/
                              
       select distinct UsageID,
              AccountNumber,
                     UtilityCode,
                     BeginDate,
                     EndDate,
                     abs(Quantity),
                     '',
                     MeterNumber,
                     TransactionSetPurposeCode
       from   [vw_edi_historical_usage] t1 (NOLOCK)
       where  accountnumber IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK)) 
              and @utilityCode ='PSEG'
                       and utilityCode = @utilityCode
              and TransactionSetPurposeCode in ('52', '00', '01')
			  and MeasurementSignificanceCode in ('51', '22', '46')
                     and not Exists (Select 1 from [vw_edi_historical_usage]  t2 (NOLOCK)
                                                       where  t2.accountnumber = t1.AccountNumber --IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK)) 
                                                        and t2.TransactionSetPurposeCode in ('52', '00', '01')
                                                       and t2.MeasurementSignificanceCode in ('41','42','43') and t1.BeginDate =t2.BeginDate and t1.EndDate=t2.EndDate)
	
                    
/*End Modification*/
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
       where  accountnumber IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
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
       from   [vw_edi_historical_usage] (NOLOCK)
       where  accountnumber IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
              and @utilityCode in (select distinct t3.utilitycode from libertypower..utility t3 where WholeSaleMktID = 'ERCOT')
           and utilityCode = @utilityCode
              and TransactionSetPurposeCode in ('05')
              and MeasurementSignificanceCode in ('51')

       IF @@ROWCOUNT > 0
         BEGIN
              DELETE FROM #usage
              WHERE  AccountNumber IN (
                                  SELECT DISTINCT t1.AccountNumber FROM #usage t1
                                  WHERE t1.BeginDate = #usage.BeginDate AND t1.EndDate = #usage.EndDate AND t1.TransactionSetPurposeCode = '05')
                     AND TransactionSetPurposeCode = '00'

              UPDATE #usage SET TransactionSetPurposeCode = '00' WHERE TransactionSetPurposeCode = '05'
         END
		 
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
       from   [vw_edi_historical_usage] t1 (NOLOCK)
       where  accountnumber IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK)) 
              and @utilityCode ='PSEG'
                       and utilityCode = @utilityCode
			  and accountnumber not in (select distinct t2.accountnumber
                     from #usage t2 where t1.accountnumber = t2.accountnumber and t1.BeginDate = t2.BeginDate and t1.EndDate = t2.EndDate)
              and TransactionSetPurposeCode in ( '00')
              and MeasurementSignificanceCode in ('51', '22', '46')

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
       from   [vw_edi_historical_usage] (NOLOCK) t1
       where  accountnumber IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
         and @utilityCode <> 'AMEREN'
              and accountnumber not in (select distinct t2.accountnumber
                     from #usage t2 where t1.accountnumber = t2.accountnumber and t1.BeginDate = t2.BeginDate and t1.EndDate = t2.EndDate)
              and utilityCode = @utilityCode
              and TransactionSetPurposeCode in ('52', '00', '01')
              and MeasurementSignificanceCode in ('41','42','43')
       
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
       where  accountnumber IN (SELECT ACCOUNTNO AS ACCOUNTNUMBER FROM #TEMPACCOUNTS(NOLOCK))  
              and accountnumber not in (select distinct t2.accountnumber
                     from #usage t2 where a.accountnumber = t2.accountnumber and b.BeginDate = t2.BeginDate and b.EndDate = t2.EndDate)
              and UnitOfMeasurement = 'kh'
              and b.MeterNumber <> ''
              and @utilityCode  = 'AMEREN'
              and TransactionSetPurposeCode in ('52', '00', '01')
              and MeasurementSignificanceCode in ('41','42','43')

--Select @multipleMeters;

       if @multipleMeters = 0
         begin
         print '@multipleMeters=0 IF'
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
              from   #usage
              where  beginDate >= @BeginDate
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
         print '@multipleMeters=1 IF'
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
              INTO   #M
              from   #usage
              where  beginDate >= @BeginDate
                     and endDate <= @EndDate
              group by
                           --AccountNumber,
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
              INTO   #ONE
              FROM   #M
              GROUP  BY BeginDate, EndDate,Quantity,
                           TransactionSetPurposeCode

              SELECT distinct m.*
              FROM   #M m
              INNER  JOIN #ONE o
              ON            m.UsageID=o.UsageID
              ORDER  BY 4, 7
              
         end
       else
         begin
         --print '@multipleMeters=1 Else'
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
              INTO   #U
              from   #usage2
              where  beginDate >= @BeginDate
                     and endDate <= @EndDate
              group by
                           --AccountNumber,
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
              INTO   #Unique
              FROM   #U
              GROUP  BY BeginDate, EndDate,Quantity,
                           TransactionSetPurposeCode

              SELECT distinct m.*
              FROM   #U m
              INNER  JOIN #Unique o
              ON            m.UsageID=o.UsageID
              ORDER  BY 4, 7


         end

       SET NOCOUNT OFF;
END

