/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_HeaderUpdateAll]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*******************************************************************************  
 * usp_RECONEDI_HeaderUpdate  
 * Update header information.   
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
CREATE procedure [dbo].[usp_RECONEDI_HeaderUpdateAll]  
(@p_ReconID                                        int,  
 @p_ISO                                            varchar(50),  
 @p_Utility                                        varchar(50),  
 @p_AsOfDate                                       date,  
 @p_EmailList                                      varchar(500),  
 @p_ParentReconID                                  int = 0)  
as  
  
set nocount on  
  
update dbo.RECONEDI_Header set ISO = @p_ISO,  
                               Utility = @p_Utility,  
                               AsOfDate = @p_AsOfDate,  
                               EmailList = @p_EmailList,  
                               ParentReconID = @p_ParentReconID  
where RECONID                                      = @p_ReconID  
  
set nocount off

GO
