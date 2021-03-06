/****** Object:  View [dbo].[RECONEDI_ForecastWholesale_vw]    Script Date: 6/20/2014 4:29:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************* 
 * RECONEDI_ForecastWholeSale_vw
 * Select result from reconciliation process with wholesale foracast information. 
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
CREATE view [dbo].[RECONEDI_ForecastWholesale_vw]
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
from dbo.RECONEDI_EnrollmentMTM_vw a with (nolock)
inner join dbo.RECONEDI_ForecastDates b with (nolock)
on  a.EnrollmentID                                 = b.EnrollmentID
inner join dbo.RECONEDI_ForecastWholeSale c with (nolock)
on  b.EnrollmentID                                 = c.EnrollmentID
and b.FDatesID                                     = c.FDatesID







GO
