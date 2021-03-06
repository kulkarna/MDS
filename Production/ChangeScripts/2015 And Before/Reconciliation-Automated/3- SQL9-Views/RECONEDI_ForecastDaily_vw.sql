/****** Object:  View [dbo].[RECONEDI_ForecastDaily_vw]    Script Date: 6/20/2014 4:29:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************* 
 * RECONEDI_ForecastDaily_vw
 * Select result from reconciliation process with daily foracast information. 
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
 
CREATE view [dbo].[RECONEDI_ForecastDaily_vw]
as
select a.*,
       b.ActualStartDate,
       b.ActualEndDate,
       DatesOverlapIndicator                       = b.OverlapIndicator,
       DatesOverlapDays                            = b.OverlapDays,
       b.SearchActualStartDate,
       b.SearchActualEndDate,
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
from dbo.RECONEDI_EnrollmentMTM_vw a with (nolock)
inner join dbo.RECONEDI_ForecastDates b with (nolock)
on  a.EnrollmentID                                 = b.EnrollmentID
inner join dbo.RECONEDI_ForecastDaily c with (nolock)
on  b.EnrollmentID                                 = c.EnrollmentID
and b.FDatesID                                     = c.FDatesID





GO
