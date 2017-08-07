USE [lp_LoadReconciliation]
GO
/****** Object:  View [dbo].[RECONEDI_StatusSubStatus_vw]    Script Date: 6/26/2014 4:24:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/******************************************************************************* 
 * RECONEDI_StatusSubStatus_vw
 * Select status from RECONEDI_MTMStatus without the 911000
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

CREATE VIEW [dbo].[RECONEDI_StatusSubStatus_vw]
AS
SELECT DISTINCT Status, SubStatus
from dbo.RECONEDI_MTMStatus (nolock)
where Status                                       <>'911000'







GO
