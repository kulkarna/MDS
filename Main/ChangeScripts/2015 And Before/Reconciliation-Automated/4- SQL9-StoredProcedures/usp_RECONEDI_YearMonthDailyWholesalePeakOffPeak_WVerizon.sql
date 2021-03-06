/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_YearMonthDailyWholesalePeakOffPeak_WVerizon]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************  
 * usp_RECONEDI_YearMonthDailyWholesalePeakOffPeak_WVerizon
 * Collect result peak and off peak values between daily and wholesale forecast information, without Verizon account.
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
CREATE procedure [dbo].[usp_RECONEDI_YearMonthDailyWholesalePeakOffPeak_WVerizon]
(@p_ReconID                                        int,
 @p_ISO                                            varchar(20))
as
set nocount on

create table #WholeSale
(ReconID                                           int,
 ISO                                               varchar(50),
 ProcessType                                       varchar(50),
 Utility                                           varchar(50),
 Zone                                              varchar(50),
 AccountType                                       varchar(50),
 UsagesYear                                        int,
 UsagesMonth                                       int,
 TotalVolume                                       float,
 Peak                                              float,
 OffPeak                                           float)

create index idx_#WholeSale on #WholeSale
(ReconID,
 ISO,
 ProcessType,
 Zone,
 Utility,
 AccountType,
 UsagesYear,
 UsagesMonth)

create table #Detail
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

create index idx_#Detail on #Detail
(ReconID,
 ISO,
 ProcessType,
 Zone,
 Utility,
 AccountType,
 UsagesYear,
 UsagesMonth)


insert into #WholeSale
exec usp_RECONEDI_YearMonthWholeSale_WVerizon @p_ReconID, @p_Iso

insert into #Detail
exec usp_RECONEDI_YearMonthDaily_WVerizon @p_ReconID, @p_Iso

select a.*,  
       round(b.Peak * (1 + case when (b.Peak + b.OffPeak) <> 0
                                then (a.TotalVolume -(b.Peak + b.OffPeak)) /(b.Peak + b.OffPeak)
                                else 0
                           end), 4),
       round(b.offPeak * (1 + case when (b.Peak + b.OffPeak) <> 0
                                   then (a.TotalVolume -(b.Peak + b.OffPeak)) /(b.Peak + b.OffPeak)
                                   else 0
                              end), 4)
from #WholeSale a
inner join #Detail b
on  a.ReconID                                      = b.ReconID
and a.ISO                                          = b.ISO
and a.ProcessType                                  = b.ProcessType
and a.Zone                                         = b.Zone
and a.Utility                                      = b.Utility  
and a.AccountType                                  = b.AccountType
and a.UsagesYear                                   = b.UsagesYear
and a.UsagesMonth                                  = b.UsagesMonth

set nocount off




GO
