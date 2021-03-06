/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_YearMonthDaily_WVerizon]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*******************************************************************************  
 * usp_RECONEDI_YearMonthDaily_WVerizon
 * Collect reconciliation result from forecast daily information without Verizon account.  
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
CREATE procedure [dbo].[usp_RECONEDI_YearMonthDaily_WVerizon]
(@p_ReconID                                        int,
 @p_ISO                                            varchar(20))
as

set nocount on

declare @asOfDate                                  datetime

select @asOfDate = AsOfDate
from dbo.RECONEDI_Header (nolock)
where ReconID                                      = @p_Reconid

declare @ISO table
(ISO varchar(50) primary key clustered)

insert into @ISO
select distinct 
       a.WholeSaleMktID
from Libertypower..Utility a with (nolock)
cross join dbo.RECONEDI_Header b (nolock)
where b.ReconID                                    = @p_Reconid
and (a.WholeSaleMktID                              = b.ISO
or   b.ISO                                         = '*')
and  a.InactiveInd                                 = 0 

create table #ReconSort
(ReconID                                           int,
 ISO                                               varchar(50),
 ProcessType                                       varchar(50),
 Utility                                           varchar(50),
 Zone                                              varchar(50),
 AccountType                                       varchar(50),
 UsagesYear                                        int,
 UsagesMonth                                       int,
 Peak                                              float,
 OffPeak                                           float)

create table #ReconTemp
(ReconID                                           int,
 ISO                                               varchar(50),
 ProcessType                                       varchar(50),
 Utility                                           varchar(50),
 Zone                                              varchar(50),
 AccountType                                       varchar(50),
 UsagesYear                                        int,
 Month01Peak                                       float,
 Month01OffPeak                                    float,
 Month02Peak                                       float,
 Month02OffPeak                                    float,
 Month03Peak                                       float,
 Month03OffPeak                                    float,
 Month04Peak                                       float,
 Month04OffPeak                                    float,
 Month05Peak                                       float,
 Month05OffPeak                                    float,
 Month06Peak                                       float,
 Month06OffPeak                                    float,
 Month07Peak                                       float,
 Month07OffPeak                                    float,
 Month08Peak                                       float,
 Month08OffPeak                                    float,
 Month09Peak                                       float,
 Month09OffPeak                                    float,
 Month10Peak                                       float,
 Month10OffPeak                                    float,
 Month11Peak                                       float,
 Month11OffPeak                                    float,
 Month12Peak                                       float,
 Month12OffPeak                                    float)
 
insert into #ReconTemp
select a.ReconID,
       a.ISO,
       a.ProcessType,
       a.Utility,
       a.Zone,
       a.AccountType,
       a.UsagesYear,
       Month01Peak                                 = sum(a.Month01Peak),
       Month01OffPeak                              = sum(a.Month01OffPeak),
       Month02Peak                                 = sum(a.Month02Peak),
       Month02OffPeak                              = sum(a.Month02OffPeak),
       Month03Peak                                 = sum(a.Month03Peak),
       Month03OffPeak                              = sum(a.Month03OffPeak),
       Month04Peak                                 = sum(a.Month04Peak),
       Month04OffPeak                              = sum(a.Month04OffPeak),
       Month05Peak                                 = sum(a.Month05Peak),
       Month05OffPeak                              = sum(a.Month05OffPeak),
       Month06Peak                                 = sum(a.Month06Peak),
       Month06OffPeak                              = sum(a.Month06OffPeak),
       Month07Peak                                 = sum(a.Month07Peak),
       Month07OffPeak                              = sum(a.Month07OffPeak),
       Month08Peak                                 = sum(a.Month08Peak),
       Month08OffPeak                              = sum(a.Month08OffPeak),
       Month09Peak                                 = sum(a.Month09Peak),
       Month09OffPeak                              = sum(a.Month09OffPeak),
       Month10Peak                                 = sum(a.Month10Peak),
       Month10OffPeak                              = sum(a.Month10OffPeak),
       Month11Peak                                 = sum(a.Month11Peak),
       Month11OffPeak                              = sum(a.Month11OffPeak),
       Month12Peak                                 = sum(a.Month12Peak),
       Month12OffPeak                              = sum(a.Month12OffPeak)
from dbo.RECONEDI_ForecastDaily_vw a (nolock)
inner join RECONEDI_StatusSubStatus_vw l (nolock)
on  a.Status                                       = l.Status
and a.SubStatus                                    = l.SubStatus
inner join @ISO i                                   
on  i.ISO                                          = a.ISO
where a.ReconID                                    = @p_ReconID
and   a.SearchActualEndDate                        > @asOfDate                                       --Added by Douglas 7/16/2013
and   not exists (select null
                  from dbo.RECONEDI_AccountOut y (nolock)
                  where y.AccountNumber            = a.AccountNumber
                  and   y.ContractNumber           = a.ContractNumber
                  and   y.UtilityCode              = a.Utility)
group by a.ReconID,
         a.ISO,
         a.ProcessType,
         a.Utility,
         a.Zone,
         a.AccountType,
         a.UsagesYear

insert into #ReconSort
select a.ReconID,
       a.ISO,
       a.ProcessType,
       a.Utility,
       a.Zone,
       a.AccountType,
       a.UsagesYear,
       UsagesMonth = max(1),
       Peak                                        = sum(a.Month01Peak),
       OffPeak                                     = sum(a.Month01OffPeak)
from #ReconTemp a
group by a.ReconID,
         a.ISO,
         a.ProcessType,
         a.Utility,
         a.Zone,
         a.AccountType,
         a.UsagesYear
union
select a.ReconID,
       a.ISO,
       a.ProcessType,
       a.Utility,
       a.Zone,
       a.AccountType,
       a.UsagesYear,
       UsagesMonth = max(2),
       Peak                                        = sum(a.Month02Peak),
       OffPeak                                     = sum(a.Month02OffPeak)
from #ReconTemp a
group by a.ReconID,
         a.ISO,
         a.ProcessType,
         a.Utility,
         a.Zone,
         a.AccountType,
         a.UsagesYear
union
select a.ReconID,
       a.ISO,
       a.ProcessType,
       a.Utility,
       a.Zone,
       a.AccountType,
       a.UsagesYear,
       UsagesMonth = max(3),
       Peak                                        = sum(a.Month03Peak),
       OffPeak                                     = sum(a.Month03OffPeak)
from #ReconTemp a
group by a.ReconID,
         a.ISO,
         a.ProcessType,
         a.Utility,
         a.Zone,
         a.AccountType,
         a.UsagesYear
union
select a.ReconID,
       a.ISO,
       a.ProcessType,
       a.Utility,
       a.Zone,
       a.AccountType,
       a.UsagesYear,
       UsagesMonth = max(4),
       Peak                                        = sum(a.Month04Peak),
       OffPeak                                     = sum(a.Month04OffPeak)
from #ReconTemp a
group by a.ReconID,
         a.ISO,
         a.ProcessType,
         a.Utility,
         a.Zone,
         a.AccountType,
         a.UsagesYear
union
select a.ReconID,
       a.ISO,
       a.ProcessType,
       a.Utility,
       a.Zone,
       a.AccountType,
       a.UsagesYear,
       UsagesMonth = max(5),
       Peak                                        = sum(a.Month05Peak),
       OffPeak                                     = sum(a.Month05OffPeak)
from #ReconTemp a
group by a.ReconID,
         a.ISO,
         a.ProcessType,
         a.Utility,
         a.Zone,
         a.AccountType,
         a.UsagesYear
union
select a.ReconID,
       a.ISO,
       a.ProcessType,
       a.Utility,
       a.Zone,
       a.AccountType,
       a.UsagesYear,
       UsagesMonth = max(6),
       Peak                                        = sum(a.Month06Peak),
       OffPeak                                     = sum(a.Month06OffPeak)
from #ReconTemp a
group by a.ReconID,
         a.ISO,
         a.ProcessType,
         a.Utility,
         a.Zone,
         a.AccountType,
         a.UsagesYear
union
select a.ReconID,
       a.ISO,
       a.ProcessType,
       a.Utility,
       a.Zone,
       a.AccountType,
       a.UsagesYear,
       UsagesMonth = max(7),
       Peak                                        = sum(a.Month07Peak),
       OffPeak                                     = sum(a.Month07OffPeak)
from #ReconTemp a
group by a.ReconID,
         a.ISO,
         a.ProcessType,
         a.Utility,
         a.Zone,
         a.AccountType,
         a.UsagesYear
union
select a.ReconID,
       a.ISO,
       a.ProcessType,
       a.Utility,
       a.Zone,
       a.AccountType,
       a.UsagesYear,
       UsagesMonth = max(8),
       Peak                                        = sum(a.Month08Peak),
       OffPeak                                     = sum(a.Month08OffPeak)
from #ReconTemp a
group by a.ReconID,
         a.ISO,
         a.ProcessType,
         a.Utility,
         a.Zone,
         a.AccountType,
         a.UsagesYear
union
select a.ReconID,
       a.ISO,
       a.ProcessType,
       a.Utility,
       a.Zone,
       a.AccountType,
       a.UsagesYear,
       UsagesMonth = max(9),
       Peak                                        = sum(a.Month09Peak),
       OffPeak                                     = sum(a.Month09OffPeak)
from #ReconTemp a
group by a.ReconID,
         a.ISO,
         a.ProcessType,
         a.Utility,
         a.Zone,
         a.AccountType,
         a.UsagesYear
union
select a.ReconID,
       a.ISO,
       a.ProcessType,
       a.Utility,
       a.Zone,
       a.AccountType,
       a.UsagesYear,
       UsagesMonth = max(10),
       Peak                                        = sum(a.Month10Peak),
       OffPeak                                     = sum(a.Month10OffPeak)
from #ReconTemp a
group by a.ReconID,
         a.ISO,
         a.ProcessType,
         a.Utility,
         a.Zone,
         a.AccountType,
         a.UsagesYear
union
select a.ReconID,
       a.ISO,
       a.ProcessType,
       a.Utility,
       a.Zone,
       a.AccountType,
       a.UsagesYear,
       UsagesMonth = max(11),
       Peak                                        = sum(a.Month11Peak),
       OffPeak                                     = sum(a.Month11OffPeak)
from #ReconTemp a
group by a.ReconID,
         a.ISO,
         a.ProcessType,
         a.Utility,
         a.Zone,
         a.AccountType,
         a.UsagesYear
union
select a.ReconID,
       a.ISO,
       a.ProcessType,
       a.Utility,
       a.Zone,
       a.AccountType,
       a.UsagesYear,
       UsagesMonth = max(12),
       Peak                                        = sum(a.Month12Peak),
       OffPeak                                     = sum(a.Month12OffPeak)
from #ReconTemp a
group by a.ReconID,
         a.ISO,
         a.ProcessType,
         a.Utility,
         a.Zone,
         a.AccountType,
         a.UsagesYear

select * 
from #ReconSort a
order by a.ISO, a.ProcessType, a.Utility, a.Zone, a.UsagesYear, a.UsagesMonth

set nocount off




GO
