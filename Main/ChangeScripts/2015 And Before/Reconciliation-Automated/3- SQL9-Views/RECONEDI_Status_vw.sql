/****** Object:  View [dbo].[RECONEDI_Status_vw]    Script Date: 6/20/2014 4:29:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************* 
 * RECONEDI_Status_vw
 * Select data from the dbo.RECONEDI_Status tables. 
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

CREATE view [dbo].[RECONEDI_Status_vw]
as

select a.*
from RECONEDI_Status a (nolock)
where a.SubStatusID                                = 0
union
select a.StatusID,
       SubStatusID                                 = isnull(b.SubStatusID, 0),
	   Description                                 = ltrim(rtrim(a.Description))
	                                               + case when b.SubStatusID = 0
												          then ''
														  else ' - '
												             + ltrim(rtrim(b.Description))
											         end
from (select a.StatusID,
	         a.Description
      from RECONEDI_Status a (nolock)
	  where a.SubStatusID                          = 0) a
inner join RECONEDI_Status b (nolock)
on  a.StatusID                                     = b.StatusID
where b.SubStatusID                               <> 0




GO
