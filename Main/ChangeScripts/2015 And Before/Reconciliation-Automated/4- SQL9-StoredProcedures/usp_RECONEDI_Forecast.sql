/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_Forecast]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_Forecast
 * Collect Forecast Information. 
 * 
 * History
 *******************************************************************************
 * 2014/04/01 - William Vilchez
 * Created.
 *******************************************************************************
 * <Date Modified,date,> - <Developer Name,,>
 * <Modification Description,,>
 *******************************************************************************
 */
CREATE procedure [dbo].[usp_RECONEDI_Forecast]
(@p_ReconID                                        int,
 @p_ISO                                            varchar(50),
 @p_Utility                                        varchar(50),
 @p_AsOfDate                                       date,
 @p_ProcessDate                                    datetime,
 @p_Process                                        char(01) = 'T')
as

set nocount                                        on

if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 
begin
   exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                      4,
								      0
   return 1
end

exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                   3,
								   4

exec dbo.usp_RECONEDI_Tracking @p_ReconID,
                               @p_ISO,
                               @p_Utility,
                               3,
					           4,
							   'Start'

if @p_Process                                      = 'F'
begin

   delete b
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_ForecastDates b with (nolock) 
   on  a.EnrollmentID                              = b.EnrollmentID   
   where a.ReconID                                 = @p_ReconID
   and   exists(select null
                from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
                where z.Utility                    = a.Utility
                and   z.AccountNumber              = a.AccountNumber)

   delete b
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_ForecastDaily b with (nolock) 
   on  a.EnrollmentID                              = b.EnrollmentID   
   where a.ReconID                                 = @p_ReconID
   and   exists(select null
                from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
                where z.Utility                    = a.Utility
                and   z.AccountNumber              = a.AccountNumber)

   delete b
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_ForecastWholesale b with (nolock) 
   on  a.EnrollmentID                              = b.EnrollmentID   
   where a.ReconID                                 = @p_ReconID
   and   exists(select null
                from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
                where z.Utility                    = a.Utility
                and   z.AccountNumber              = a.AccountNumber)

   delete b
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_ForecastWholesaleError b with (nolock) 
   on  a.EnrollmentID                              = b.EnrollmentID   
   where a.ReconID                                 = @p_ReconID
   and   exists(select null
                from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
                where z.Utility                    = a.Utility
                and   z.AccountNumber              = a.AccountNumber)
end

/******** Forecast Header - Dates ********/

create table #ForecastDateFrom
(ID                                                int identity(1, 1) not null primary key clustered, 
 EnrollmentID                                      int,
 AccountID                                         int,
 ActualStartDate                                   datetime,
 ActualEndDate                                     datetime,
 SearchActualStartDate                             datetime,
 SearchActualEndDate                               datetime)


create index idx_#ForecastDateFrom on #ForecastDateFrom
(EnrollmentID asc)

create table #EnrollmentFixed
(EnrollmentID                                      int not null primary key clustered,
 Utility                                           varchar(50),
 AccountNumber                                     varchar(50),
 AccountID                                         int,
 SubmitDate                                        datetime,
 ContractID                                        int,
 ContractRateStart                                 datetime,
 ContractRateEnd                                   datetime,
 ContractRateStartOverlap                          datetime,
 OverlapDays                                       int,
 OverlapType                                       char(01))

create index idx_#EnrollmentFixed on #EnrollmentFixed
(AccountID,
 SubmitDate,
 ContractID)

create index idx1_#EnrollmentFixed on #EnrollmentFixed
(OverlapType)

insert into #EnrollmentFixed
select distinct
       a.EnrollmentID,
       a.Utility,
       a.AccountNumber,
       a.AccountID,
       a.SubmitDate,
       a.ContractID,
       a.ContractRateStart,
       a.ContractRateEnd,
       null,
       a.OverlapDays,
       a.OverlapType
from dbo.RECONEDI_EnrollmentFixed a with (nolock)
--Without Filter
where a.ReconID                                    = @p_ReconID
and   a.ISO                                        = @p_ISO
and  (a.Utility                                    = @p_Utility
or    @p_Utility                                   = '*')
--Without Filter
and  ((@p_Process                                 in ('T', 'I'))
--Filter
or    (@p_Process                                  = 'F'
and    exists(select null
              from dbo.RECONEDI_Filter z with (nolock)
              where z.Utility                      = a.Utility
              and   z.AccountNumber                = a.AccountNumber)))
and   a.ForecastType                            like 'NEW%'


/******** Overlap ********/

create table #EDIResult
(AccountID                                         int,
 ContractID                                        int,
 Utility                                           varchar(50),
 AccountNumber                                     varchar(50),
 ActualStartDate                                   datetime,
 ActualEndDate                                     datetime,
 SearchActualStartDate                             datetime,
 SearchActualEndDate                               datetime)

create index idx_#EDIResult on #EDIResult
(AccountID)

create table #EDISearch
(ID                                                int identity(1, 1) primary key clustered,
 AccountID                                         int,
 Utility                                           varchar(50),
 AccountNumber                                     varchar(50),
 ContractRateStart                                 datetime,
 ContractRateEnd                                   datetime)

insert into #EDISearch
select distinct 
       AccountID,
       Utility,
       AccountNumber,
       ContractRateStart,
       ContractRateEnd
from #EnrollmentFixed with (nolock)
where OverlapType                                 <> 'E'
or    OverlapType                                 is null

declare @w_ID                                      int
declare @w_AccountID                               int
declare @w_Utility                                 varchar(50)
declare @w_AccountNumber                           varchar(50)
declare @w_ContractRateStart                       datetime
declare @w_ContractRateEnd                         datetime

declare @t_ID                                      int
select @t_ID                                       = 1

declare @w_RowCount                                int

select @w_ID                                       = ID,
       @w_AccountID                                = AccountID,
       @w_Utility                                  = Utility,
       @w_AccountNumber                            = AccountNumber,
       @w_ContractRateStart                        = ContractRateStart,
       @w_ContractRateEnd                          = ContractRateEnd
from #EDISearch (nolock)
where ID                                           = @t_ID

select @w_RowCount                                 = @@RowCount

while @w_RowCount                                 <> 0
begin
   select @t_ID                                    = @t_ID + 1

   exec dbo.usp_RECONEDI_EDIResultSelect @p_ReconID,
                                         @w_Utility,
                                         @w_AccountNumber

   select @w_ID                                    = ID,
          @w_AccountID                             = AccountID,
          @w_Utility                               = Utility,
          @w_AccountNumber                         = AccountNumber,
          @w_ContractRateStart                     = ContractRateStart,
          @w_ContractRateEnd                       = ContractRateEnd
   from #EDISearch (nolock)
   where ID                                        = @t_ID

   select @w_RowCount                              = @@RowCount
end

insert into #ForecastDateFrom
select a.EnrollmentID,
       a.AccountID,
       a.ActualStartDate,
       a.ActualEndDate,
       a.SearchActualStartDate,
       a.SearchActualEndDate
from (select distinct       
             a.EnrollmentID,
             a.Utility,
             a.AccountID,
             a.ContractID,
             a.SubmitDate,
             ActualStartDate                       = case when a.ContractRateStart              > b.ActualStartDate
                                                          then a.ContractRateStart
                                                          when a.ContractRateStart             <= b.ActualStartDate
                                                          then b.ActualStartDate
                                                          when b.ActualStartDate               is null
                                                          then a.ContractRateStart
                                                     end,
             ActualEndDate                         = case when a.ContractRateEnd                > b.ActualEndDate
                                                          and  b.ActualEndDate                 >= a.ContractRateStart
                                                          then b.ActualEndDate
                                                          when a.ContractRateEnd                > b.ActualEndDate
                                                          and  b.ActualEndDate                  < a.ContractRateStart
                                                          then a.ContractRateEnd
                                                          when a.ContractRateEnd               <= b.ActualEndDate
                                                          then a.ContractRateEnd
                                                          when b.ActualEndDate                 is null
                                                          then a.ContractRateEnd
                                                     end,
             SearchActualStartDate                 = case when a.ContractRateStart              > b.ActualStartDate
                                                          and  b.SearchActualStartDate     is not null
                                                          then a.ContractRateStart
                                                          when a.ContractRateStart             <= b.ActualStartDate
                                                          and  b.SearchActualStartDate     is not null
                                                          then b.ActualStartDate
                                                          else b.SearchActualStartDate
                                                     end,
             SearchActualEndDate                   = case when a.ContractRateEnd                > b.ActualEndDate
                                                          and  b.ActualEndDate                 >= a.ContractRateStart
                                                          and  b.SearchActualEndDate       is not null
                                                          then b.ActualEndDate
                                                          when a.ContractRateEnd                > b.ActualEndDate
                                                          and  b.SearchActualEndDate       is not null
                                                          and  b.ActualEndDate                  < a.ContractRateStart
                                                          then a.ContractRateEnd
                                                          when a.ContractRateEnd               <= b.ActualEndDate
                                                          and  b.SearchActualEndDate       is not null
                                                          then a.ContractRateEnd
                                                          else b.SearchActualEndDate
                                                     end
      from #EnrollmentFixed a with (nolock)
      inner join #EDIResult b with (nolock)
      on  a.AccountID                              = b.AccountID
      and a.ContractID                             = b.ContractID
      where ((b.ActualStartDate                   >= a.ContractRateStart
      and     b.ActualStartDate                   <= a.ContractRateEnd)
      or     (b.ActualEndDate                     >= a.ContractRateStart
      and     b.ActualEndDate                     <= a.ContractRateEnd))) a
order by a.Utility,
         a.AccountID,
         year(a.ActualStartDate),
         a.ActualStartDate,
         a.SubmitDate,
         a.ContractID

create table #ForecastDateCompare
(ID                                                int identity(0, 1) not null primary key clustered, 
 EnrollmentID                                      int,
 AccountID                                         int,
 ActualStartDate                                   datetime,
 ActualEndDate                                     datetime,
 SearchActualStartDate                             datetime,
 SearchActualEndDate                               datetime)

insert into #ForecastDateCompare
select EnrollmentID,
       AccountID,
       ActualStartDate,
       ActualEndDate,
       SearchActualStartDate,
       SearchActualEndDate
from #ForecastDateFrom (nolock)
order by ID

create table #ForecastDateTo
(ID                                                int identity(1, 1) not null primary key clustered, 
 EnrollmentID                                      int,
 ActualStartDate                                   datetime,
 ActualEndDate                                     datetime,
 OverlapType                                       char(01),
 OverlapDays                                       int,
 SearchActualStartDate                             datetime,
 SearchActualEndDate                               datetime)

insert into #ForecastDateTo
select a.EnrollmentID,
       a.ActualStartDate,
       a.ActualEndDate,
       OverlapType                                 = case when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualEndDate          <= b.ActualEndDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then 'T'
                                                          when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualStartDate        <= b.ActualEndDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then 'P'
                                                          when a.ActualEndDate          >= b.ActualStartDate 
                                                          and  a.ActualEndDate          <= b.ActualEndDate     
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then 'P'
                                                          when a.ActualStartDate        <= b.ActualStartDate
                                                          and  a.ActualEndDate          >= b.ActualStartDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then 'P'
                                                          else null
                                                     end,
       OverlapDays                                 = case when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualEndDate          <= b.ActualEndDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then DATEDIFF(dd, a.ActualStartDate, a.ActualEndDate) + 1
                                                          when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualStartDate        <= b.ActualEndDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then DATEDIFF(dd, b.ActualStartDate, a.ActualEndDate) + 1
                                                          when a.ActualEndDate          >= b.ActualStartDate 
                                                          and  a.ActualEndDate          <= b.ActualEndDate     
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then DATEDIFF(dd, b.ActualStartDate, a.ActualEndDate) + 1
                                                          when a.ActualStartDate        <= b.ActualStartDate
                                                          and  a.ActualEndDate          >= b.ActualStartDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then DATEDIFF(dd, b.ActualStartDate, a.ActualEndDate) + 1
                                                          else null
                                                     end,
       SearchActualStartDate                       = case when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualEndDate          <= b.ActualEndDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then null
                                                          when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualStartDate        <= b.ActualEndDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then null
                                                          when a.ActualEndDate          >= b.ActualStartDate 
                                                          and  a.ActualEndDate          <= b.ActualEndDate     
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then a.ActualStartDate
                                                          when a.ActualStartDate        <= b.ActualStartDate
                                                          and  a.ActualEndDate          >= b.ActualStartDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then a.ActualStartDate
                                                          else a.SearchActualStartDate
                                                     end,
       SearchActualEndDate                         = case when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualEndDate          <= b.ActualEndDate
                                                          and  a.SearchActualEndDate    is not null
                                                          and  b.SearchActualEndDate    is not null
                                                          then null
                                                          when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualStartDate        <= b.ActualEndDate
                                                          and  a.SearchActualEndDate    is not null
                                                          and  b.SearchActualEndDate    is not null
                                                          then null
                                                          when a.ActualEndDate          >= b.ActualStartDate 
                                                          and  a.ActualEndDate          <= b.ActualEndDate     
                                                          and  a.SearchActualEndDate    is not null
                                                          and  b.SearchActualEndDate    is not null
                                                          then DATEADD(dd, -1, b.ActualStartDate)
                                                          when a.ActualStartDate        <= b.ActualStartDate
                                                          and  a.ActualEndDate          >= b.ActualStartDate
                                                          and  a.SearchActualEndDate    is not null
                                                          and  b.SearchActualEndDate    is not null
                                                          then DATEADD(dd, -1, b.ActualStartDate)
                                                          else a.SearchActualEndDate
                                                     end
from #ForecastDateFrom a with (nolock)
left join #ForecastDateCompare b with (nolock)
on  a.ID                                           = b.ID 
and a.AccountID                                    = b.AccountID                                 

if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 
begin
   exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                      4,
								      0
   return 1
end

insert into RECONEDI_ForecastDates
select a.EnrollmentID,
       a.ActualStartDate,
       a.ActualEndDate,
       a.OverlapType,
       a.OverlapDays,
       a.SearchActualStartDate,
       a.SearchActualEndDate
from #ForecastDateTo a (nolock)
order by a.EnrollmentID,
         a.ActualStartDate

insert into RECONEDI_ForecastDates
select a.EnrollmentID,
       null,
       null,
       a.OverlapType,
       a.OverlapDays,
       null,
       null
from #EnrollmentFixed a with (nolock)
where OverlapType                                  = 'E'


/******** Forecast ********/

create table #ISOForecast
(EnrollmentID                                      int,
 FDatesID                                          int,
 ID                                                int,
 SearchActualStartDate                             datetime,
 SearchActualEndDate                               datetime)

insert into #ISOForecast
select a.EnrollmentID,
       b.FDatesID,
       c.ID,
       b.SearchActualStartDate,
       b.SearchActualEndDate
from #EnrollmentFixed a with (nolock)
inner join RECONEDI_ForecastDates b with (nolock)
on  a.EnrollmentID                                 = b.EnrollmentID   
left join dbo.RECONEDI_MTM c with (nolock)
on  a.EnrollmentID                                 = c.EnrollmentID

create clustered index idx_#ISOFOrecast on #ISOFOrecast
(ID asc,
 SearchActualStartDate asc)

create index idx1_#ISOFOrecast on #ISOFOrecast
(EnrollmentID asc,
 FDatesID asc)


/******** Forecast Daily ********/

insert into dbo.RECONEDI_ForecastDaily
select a.EnrollmentID,
       a.FdatesID,
       0,
       null,
       null,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0
from #ISOFOrecast a with (nolock)
where a.ID                                      is null

select a.EnrollmentID,
       a.FDatesID,
       e.UsageDate,
       UsageYear                                   = year(e.UsageDate),
       UsageMonth                                  = month(e.UsageDate),
       e.Peak,
       e.OffPeak
into #Daily       
from #ISOFOrecast a with (nolock)
inner join lp_MtM.dbo.MtMDailyLoadForecast e with (nolock)
on  a.ID                                           = e.MTMAccountID
where a.ID                                         > 0
and   a.SearchActualStartDate                 is not null
and   e.UsageDate                                 >= a.SearchActualStartDate 
and   e.UsageDate                                 <= a.SearchActualEndDate

if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 
begin
   exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                      4,
								      0
   return 1
end

insert into dbo.RECONEDI_ForecastDaily
select a.EnrollmentID,
       a.FDatesID,
       a.UsageYear,
       min(a.UsageDate),
       max(a.UsageDate),
       sum(case when UsageMonth = 1
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 1
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 2
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 2
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 3
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 3
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 4
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 4
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 5
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 5
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 6
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 6
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 7
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 7
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 8
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 8
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 9
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 9
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 10
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 10
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 11
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 11
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 12
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 12
                then a.OffPeak
                else 0
           end)
from #Daily a (nolock)
group by a.EnrollmentID,
         a.FdatesID,
         a.UsageYear

if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 
begin
   exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                      4,
								      0
   return 1
end

insert into dbo.RECONEDI_ForecastDaily
select a.EnrollmentID,
       a.FDatesID,
       0,
       null,
       null,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0
from #ISOFOrecast a with (nolock)
where not exists(select null
                 from dbo.RECONEDI_ForecastDaily b with (nolock)
                 where b.EnrollmentID              = a.EnrollmentID   
                 and   b.FDatesID                  = a.FDatesID)

/******** Forecast Forecast ********/

insert into dbo.RECONEDI_ForecastWholesale
select a.EnrollmentID,
       a.FdatesID,
       0,
       null,
       null,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0
from #ISOFOrecast a with (nolock)
where a.ID                                      is null

select a.EnrollmentID,
       a.FDatesID,
       e.UsageDate,
       UsageYear                                   = year(e.UsageDate),
       UsageMonth                                  = month(e.UsageDate),
       e.ETP,
       e.Int1,
       e.Int2,
       e.Int3,
       e.Int4,
       e.Int5,
       e.Int6,
       e.Int7,
       e.Int8,
       e.Int9,
       e.Int10,
       e.Int11,
       e.Int12,                                                                 
       e.Int13,
       e.Int14,
       e.Int15,
       e.Int16,
       e.Int17,
       e.Int18,
       e.Int19,
       e.Int20,
       e.Int21,
       e.Int22,                                                                 
       e.Int23,
       e.Int24,
       e.Peak,
       e.OffPeak,
       NullInd                                     = case when e.Int1  is null
                                                          or   e.Int2  is null
                                                          or   e.Int3  is null
                                                          or   e.Int4  is null
                                                          or   e.Int5  is null
                                                          or   e.Int6  is null
                                                          or   e.Int7  is null
                                                          or   e.Int8  is null
                                                          or   e.Int9  is null
                                                          or   e.Int10 is null
                                                          or   e.Int11 is null
                                                          or   e.Int12 is null
                                                          or   e.Int13 is null
                                                          or   e.Int14 is null
                                                          or   e.Int15 is null
                                                          or   e.Int16 is null
                                                          or   e.Int17 is null
                                                          or   e.Int18 is null
                                                          or   e.Int19 is null
                                                          or   e.Int20 is null
                                                          or   e.Int21 is null
                                                          or   e.Int22 is null
                                                          or   e.Int23 is null
                                                          or   e.Int24 is null
                                                          then 1
                                                          else 0
                                                     end
into #Wholesale       
from #ISOFOrecast a with (nolock)
inner join lp_MtM.dbo.MtMDailyWholesaleLoadForecast e with (nolock)
on  a.ID                                           = e.MTMAccountID
where a.ID                                         > 0
and   a.SearchActualStartDate                 is not null
and   e.UsageDate                                 >= a.SearchActualStartDate 
and   e.UsageDate                                 <= a.SearchActualEndDate

if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 
begin
   exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                      4,
								      0
   return 1
end

select distinct 
       a.EnrollmentID
into #WholesaleDuplicate
from (select EnrollmentID,
             UsageDate
      from #Wholesale      
      group by EnrollmentID,
               UsageDate      
      having count(*) > 1) a

select distinct 
       EnrollmentID
into #WholesaleNull
from #Wholesale      
where NullInd                                      = 1

insert into dbo.RECONEDI_ForecastWholesale
select a.EnrollmentID,
       a.FDatesID,
       a.UsageYear,
       min(a.UsageDate),
       max(a.UsageDate),
       a.ETP,
       sum(case when UsageMonth = 1
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 2
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
           else 0
           end),
       sum(case when UsageMonth = 3
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 4
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 5
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 6
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 7
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 8
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 9
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 10
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 11
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 12
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 1
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 2
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 3
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 4
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 5
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 6
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 7
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 8
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 9
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 10
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 11
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 12
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 1
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 2
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 3
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 4
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 5
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 6
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 7
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 8
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 9
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 10
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 11
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 12
                then isnull(a.OffPeak, 0)
                else 0
           end)
from #WholeSale a (nolock)
group by a.EnrollmentID,
         a.FDatesID,
         a.UsageYear,
         a.ETP

if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 
begin
   exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                      4,
								      0
   return 1
end
         
insert into dbo.RECONEDI_ForecastWholesale
select a.EnrollmentID,
       a.FdatesID,
       0,
       null,
       null,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0
from #ISOFOrecast a with (nolock)
where not exists(select null
                 from dbo.RECONEDI_ForecastWholesale b with (nolock)
                 where b.EnrollmentID              = a.EnrollmentID   
                 and   b.FDatesID                  = a.FDatesID)

if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 
begin
   exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                      4,
								      0
   return 1
end
                 
insert into RECONEDI_ForecastWholesaleError
select *,
       'Duplicate Dates'     
from #WholesaleDuplicate

if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 
begin
   exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                      4,
								      0
   return 1
end

declare @w_ParentReconID                           int

select @w_ParentReconID                            = 0

select @w_ParentReconID                            = ParentReconID
from dbo.RECONEDI_Header with (nolock)
where ReconID                                      = @p_ReconID

if @w_ParentReconID                               <> 0
begin

   create table #parent
   (ParentEnrollmentID                             int primary key clustered,
    EnrollmentID                                   int)

   insert into #Parent
   select a.ParentEnrollmentID,
          a.EnrollmentID
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   where a.ReconID                                 = @p_ReconID
   and   a.ISO                                     = @p_ISO   
   and  (a.Utility                                 = @p_Utility
   or    @p_Utility                                = '*')
   and   a.ForecastType                            = 'PARENT'

   insert into dbo.RECONEDI_ForecastDates
   select a.EnrollmentID,
          b.ActualStartDate,
          b.ActualEndDate,
          b.OverlapIndicator,
          b.OverlapDays,
          b.SearchActualStartDate,
          b.SearchActualEndDate
   from #Parent a (nolock)
   inner join dbo.RECONEDI_ForecastDates b (nolock)
   on  a.ParentEnrollmentID                        = b.EnrollmentID

   insert into dbo.RECONEDI_ForecastDaily
   select a.EnrollmentID,
          b.FDatesID,
          c.UsagesYear,
          c.MinDate,
          c.Maxdate,
          c.Month01Peak,
          c.Month01OffPeak,
          c.Month02Peak,
          c.Month02OffPeak,
          c.Month03Peak,
          c.Month03OffPeak,
          c.Month04Peak,
          c.Month04OffPeak,
          c.Month05Peak,
          c.Month05OffPeak,
          c.Month06Peak,
          c.Month06OffPeak,
          c.Month07Peak,
          c.Month07OffPeak,
          c.Month08Peak,
          c.Month08OffPeak,
          c.Month09Peak,
          c.Month09OffPeak,
          c.Month10Peak,
          c.Month10OffPeak,
          c.Month11Peak,
          c.Month11OffPeak,
          c.Month12Peak,
          c.Month12OffPeak
   from #Parent a (nolock)
   inner join dbo.RECONEDI_ForecastDates b (nolock)
   on  a.EnrollmentID                              = b.EnrollmentID
   inner join dbo.RECONEDI_ForecastDaily c (nolock)
   on  a.ParentEnrollmentID                        = c.EnrollmentID

   insert into dbo.RECONEDI_ForecastWholesale
   select a.EnrollmentID,
          b.FDatesID,
          c.UsagesYear,
          c.MinDate,
          c.Maxdate,
          c.ETP,
          c.Month01TotalVolume,
          c.Month02TotalVolume,
          c.Month03TotalVolume,
          c.Month04TotalVolume,
          c.Month05TotalVolume,
          c.Month06TotalVolume,
          c.Month07TotalVolume,
          c.Month08TotalVolume,
          c.Month09TotalVolume,
          c.Month10TotalVolume,
          c.Month11TotalVolume,
          c.Month12TotalVolume,
          c.Month01TotalPeak,
          c.Month02TotalPeak,
          c.Month03TotalPeak,
          c.Month04TotalPeak,
          c.Month05TotalPeak,
          c.Month06TotalPeak,
          c.Month07TotalPeak,
          c.Month08TotalPeak,
          c.Month09TotalPeak,
          c.Month10TotalPeak,
          c.Month11TotalPeak,
          c.Month12TotalPeak,
          c.Month01TotalOffPeak,
          c.Month02TotalOffPeak,
          c.Month03TotalOffPeak,
          c.Month04TotalOffPeak,
          c.Month05TotalOffPeak,
          c.Month06TotalOffPeak,
          c.Month07TotalOffPeak,
          c.Month08TotalOffPeak,
          c.Month09TotalOffPeak,
          c.Month10TotalOffPeak,
          c.Month11TotalOffPeak,
          c.Month12TotalOffPeak
   from #Parent a (nolock)
   inner join dbo.RECONEDI_ForecastDates b (nolock)
   on  a.EnrollmentID                              = b.EnrollmentID
   inner join dbo.RECONEDI_ForecastWholesale c (nolock)
   on  a.ParentEnrollmentID                        = c.EnrollmentID
end

insert into RECONEDI_ForecastWholesaleError
select *,
       'NULL'     
from #WholesaleNull

if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 
begin
   exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                      4,
								      0
   return 1
end

exec dbo.usp_RECONEDI_Tracking @p_ReconID,
                               @p_ISO,
                               @p_Utility,
                               3,
					           4,
							   'End'

return 0

set nocount off

GO
