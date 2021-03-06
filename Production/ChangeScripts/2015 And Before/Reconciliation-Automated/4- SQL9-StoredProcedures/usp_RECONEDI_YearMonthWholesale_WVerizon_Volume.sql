/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_YearMonthWholesale_WVerizon_Volume]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************  
 * usp_RECONEDI_YearMonthWholesale_WVerizon_Volume
 * Collect reconciliation result from forecast wholesale volume information without Verizon account.
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

CREATE procedure [dbo].[usp_RECONEDI_YearMonthWholesale_WVerizon_Volume]
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
 TotalVolume                                       float)

create table #ReconTemp 
(ReconID                                           int,
 ISO                                               varchar(50),
 ProcessType                                       varchar(50),
 Utility                                           varchar(50),
 Zone                                              varchar(50),
 AccountType                                       varchar(50),
 UsagesYear                                        int,
 TotalVolume01                                     float,
 TotalVolume02                                     float,
 TotalVolume03                                     float,
 TotalVolume04                                     float,
 TotalVolume05                                     float,
 TotalVolume06                                     float,
 TotalVolume07                                     float,
 TotalVolume08                                     float,
 TotalVolume09                                     float,
 TotalVolume10                                     float,
 TotalVolume11                                     float,
 TotalVolume12                                     float)
 
insert into #ReconTemp
select a.ReconID,
       a.ISO,
       a.ProcessType,
       a.Utility,
       a.Zone,
       a.AccountType,
       a.UsagesYear,
       TotalVolume01                               = sum(a.Month01TotalVolume),
       TotalVolume02                               = sum(a.Month02TotalVolume),
       TotalVolume03                               = sum(a.Month03TotalVolume),
       TotalVolume04                               = sum(a.Month04TotalVolume),
       TotalVolume05                               = sum(a.Month05TotalVolume),
       TotalVolume06                               = sum(a.Month06TotalVolume),
       TotalVolume07                               = sum(a.Month07TotalVolume),
       TotalVolume08                               = sum(a.Month08TotalVolume),
       TotalVolume09                               = sum(a.Month09TotalVolume),
       TotalVolume10                               = sum(a.Month10TotalVolume),
       TotalVolume11                               = sum(a.Month11TotalVolume),
       TotalVolume12                               = sum(a.Month12TotalVolume)
from dbo.RECONEDI_ForecastWholesale_vw a (nolock)
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
       TotalVolume                                 = sum(a.TotalVolume01)
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
       TotalVolume                                 = sum(a.TotalVolume02)
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
       TotalVolume                                 = sum(a.TotalVolume03)
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
       TotalVolume                                 = sum(a.TotalVolume04)
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
       TotalVolume                                 = sum(a.TotalVolume05)
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
       TotalVolume                                 = sum(a.TotalVolume06)
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
       TotalVolume                                 = sum(a.TotalVolume07)
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
       TotalVolume                                 = sum(a.TotalVolume08)
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
       TotalVolume                                 = sum(a.TotalVolume09)
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
       TotalVolume                                 = sum(a.TotalVolume10)
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
       TotalVolume                                 = sum(a.TotalVolume11)
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
       TotalVolume                                 = sum(a.TotalVolume12)
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
