/****** Object:  View [dbo].[RECONEDI_EnrollmentMTM_vw]    Script Date: 6/20/2014 4:29:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************* 
 * RECONEDI_EnrollmentMTM_vw
 * Select data between the RECONEDI_EnrollmentFixed and RECONEDI_MTM. 
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

CREATE view [dbo].[RECONEDI_EnrollmentMTM_vw]
as
select a.*,
       b.ID,
       b.BatchNumber,
       b.QuoteNumber,
       MTMAccountID                                = b.AccountID,
       MTMContractID                               = b.ContractID,
       MTMZone                                     = b.Zone,
       b.LoadProfile,
       b.ProxiedZone,
       b.ProxiedProfile,
       b.ProxiedUsage,
       b.MeterReadCount,
       MTMStatus                                   = b.Status,
       b.DateCreated,
       b.CreatedBy,
       b.DateModified
from 
dbo.RECONEDI_EnrollmentFixed a with (nolock) 
left join dbo.RECONEDI_MTM b with (nolock)
on  a.ReconID                                      = b.ReconID
and a.EnrollmentID                                 = b.EnrollmentID
where (a.OverlapType is null or a.OverlapType ='p')
--and a.AccountID=6474








GO
