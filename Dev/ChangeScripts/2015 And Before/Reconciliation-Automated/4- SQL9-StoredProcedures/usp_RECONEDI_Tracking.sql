/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_Tracking]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_Tracking
 * Insert tracking information.
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
CREATE procedure [dbo].[usp_RECONEDI_Tracking]  
(@p_ReconID                                        int,
 @p_ISO                                            varchar(50),
 @p_Utility                                        varchar(50),
 @p_StatusID                                       int,
 @p_SubStatusID                                    int,
 @p_ProcessStep                                    varchar(10),
 @p_AddDescp                                       varchar(200) = null)
as  

set nocount on

insert into dbo.RECONEDI_Tracking  
select @p_ReconID,  
       @p_ISO,
	   @p_Utility,
       @p_ProcessStep,  
	   case when @p_Utility = '*'
	        then ltrim(rtrim(@p_ISO))
			   + '-'
		    else ltrim(rtrim(@p_ISO))
			   + '-'
			   + ltrim(rtrim(@p_Utility))
			   + '-'
       end 
     + ltrim(rtrim(Description))
	 + case when @p_AddDescp is null
	        then ''
		    else '-'
	           + ltrim(rtrim(@p_AddDescp))
       end, 
getdate()
from dbo.RECONEDI_Status (nolock)
where StatusID                                     = @p_StatusID
and   SubStatusID                                  = @p_SubStatusID

set nocount off


GO
