/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_HeaderTrackingByPass]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_HeaderTrackingByPass
 * Update header information and insert tracking information.
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
CREATE procedure [dbo].[usp_RECONEDI_HeaderTrackingByPass]  
(@p_ReconID                                        int,
 @p_ISO                                            varchar(50),
 @p_Utility                                        varchar(50),
 @p_Return                                         int = 0)
as  

set nocount on

if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 return 1

declare @w_StatusID                                int
declare @w_ProcessStep                             varchar(10)
declare @w_SubStatusID                             int
declare @w_AddDescp                                varchar(200)

select @w_StatusID                                = case when @p_Return <> 0
                                                         then 99
						                                 else 3
													end

select @w_ProcessStep                             = 'Error'                             
select @w_SubStatusID                             = 0
select @w_AddDescp                                = null

select @w_ProcessStep                             = case when count(*) in (0, 2, 4)
                                                         then 'Start'
														 else 'End'
                                                    end,
       @w_SubStatusID                             = case when count(*) in (0, 1)
                                                         then 2
														 else 1
                                                    end,
       @w_AddDescp                                = case when count(*) in (0, 1)
                                                         then null
														 when count(*) in (2, 3)
														 then 'Fixed'
														 else 'Variable'
                                                    end
from dbo.RECONEDI_Tracking (nolock)
where ReconID                                      = @p_ReconID
and   @p_Return                                    = 0

exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                   @w_StatusID,
                                   @w_SubStatusID

exec dbo.usp_RECONEDI_Tracking @p_ReconID,
                               @p_ISO,
                               @p_Utility,
                               @w_StatusID,
                               @w_SubStatusID,
                               @w_ProcessStep,
					           @w_AddDescp

if @w_StatusID                                     = 99 
begin
   select -1
   return -1
end

select 0
return 0

set nocount off


GO
