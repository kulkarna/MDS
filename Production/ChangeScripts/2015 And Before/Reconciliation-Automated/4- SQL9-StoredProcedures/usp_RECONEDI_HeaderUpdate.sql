/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_HeaderUpdate]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 /*******************************************************************************
 * usp_RECONEDI_HeaderUpdate
 * Update header information (Status and Substatus). 
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
 CREATE procedure [dbo].[usp_RECONEDI_HeaderUpdate]
(@p_ReconID                                        int,
 @p_StatusID                                       int,
 @p_SubStatusID                                    int = 0)
as

set nocount on

update dbo.RECONEDI_Header set StatusID = @p_StatusID,
                               SubStatusID = @p_SubStatusID
where RECONID                                      = @p_ReconID

set nocount off

GO
