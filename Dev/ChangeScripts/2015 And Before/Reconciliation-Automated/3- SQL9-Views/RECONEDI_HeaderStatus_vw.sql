/****** Object:  View [dbo].[RECONEDI_HeaderStatus_vw]    Script Date: 6/20/2014 4:29:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************* 
 * RECONEDI_HeaderStatus_vw
 * Select data between dbo.RECONEDI_Header and dbo.RECONEDI_Status tables. 
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

CREATE view [dbo].[RECONEDI_HeaderStatus_vw]
as

select a.ReconID,
       a.ISO,
       a.Utility,
       a.AsOfDate,
       a.StatusID,
       a.SubStatusID,
	   Description                                 = ltrim(rtrim(b.Description))
	                                               + case when c.SubStatusID = 0
												          then ''
														  else ' - '
												             + ltrim(rtrim(c.Description))
											         end,
       a.RequestDate,
       a.ProcessDate,
       a.EmailList
from RECONEDI_Header a (nolock)
inner join RECONEDI_Status b (nolock)
on  a.StatusID                                     = b.StatusID
and a.SubStatusID                                  = 0
inner join RECONEDI_Status c (nolock)
on  a.StatusID                                     = c.StatusID
and a.SubStatusID                                  = c.SubStatusID




GO
