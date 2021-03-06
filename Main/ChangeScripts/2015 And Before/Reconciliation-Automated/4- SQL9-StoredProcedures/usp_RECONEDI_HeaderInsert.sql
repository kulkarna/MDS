/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_HeaderInsert]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_HeaderInsert
 * Insert header information.
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
CREATE procedure [dbo].[usp_RECONEDI_HeaderInsert]    
(@p_ISO                                            varchar(50),    
 @p_Utility                                        varchar(50),    
 @p_AsOfDate                                       date,   
 @p_RequestDate                                    datetime,  
 @p_EmailList                                      varchar(500),  
 @p_ReconID                                        int output,  
 @p_ParentReconID                                  int = 0)    
as    
    
set nocount on    
    
insert into dbo.RECONEDI_Header    
select @p_ISO,    
       @p_Utility,    
       @p_AsOfDate,    
       2,  
       0,  
       getdate(),  
       '19000101',  
       @p_EmailList,  
    @p_ParentReconID  
  
select @p_ReconID                                  = @@IDENTITY    
    
set nocount off

GO
