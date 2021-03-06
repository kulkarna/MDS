/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_DeleteByReconID]    Script Date: 7/3/2014 2:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_RECONEDI_DeleteByReconID
 * Delete tables by ReconID.
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
CREATE procedure [dbo].[usp_RECONEDI_DeleteByReconID]
(@p_ReconID                                        int,
 @p_Process                                        char(01) = 'T')
as

set nocount on

if @p_Process                                     in ('T', 'I')
begin

   delete b
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_ForecastDates b with (nolock) 
   on  a.EnrollmentID                              = b.EnrollmentID  
   where a.ReconID                                 = @p_ReconID

   delete b
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_ForecastDaily b with (nolock) 
   on  a.EnrollmentID                              = b.EnrollmentID  
   where a.ReconID                                 = @p_ReconID

   delete b
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_ForecastWholesale b with (nolock) 
   on  a.EnrollmentID                              = b.EnrollmentID  
   where a.ReconID                                 = @p_ReconID

   delete b
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_ForecastWholesaleError b with (nolock) 
   on  a.EnrollmentID                              = b.EnrollmentID  
   where a.ReconID                                 = @p_ReconID

   delete b
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_MTM b with (nolock) 
   on  a.EnrollmentID                              = b.EnrollmentID  
   where a.ReconID                                 = @p_ReconID

   delete a
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   where a.ReconID                                 = @p_ReconID

   delete a
   from dbo.RECONEDI_EnrollmentVariable a with (nolock)
   where a.ReconID                                 = @p_ReconID

   delete a
   from dbo.RECONEDI_EDIResult a (nolock)
   inner join dbo.RECONEDI_EDIPendingControl b (nolock)
   on  a.ReconID                                   = b.ReconID
   and a.UtilityCode                               = b.Utility
   where a.ReconID                                 = @p_ReconID
   and   b.InactiveInd                             = 1

   delete a
   from RECONEDI_EDIPending a (nolock)
   where a.ReconID                                 = @p_ReconID
   and   not exists (select null
                     from dbo.RECONEDI_Tracking a (nolock)
                     inner join dbo.RECONEDI_Status b (nolock)
					 on  a.ProcessName             = b.Description
                     where a.ReconID               = @p_ReconID
				     and   b.StatusID              = 3
                     and   b.SubStatusID           = 7)

   delete a
   from RECONEDI_EDI a (nolock)
   where a.ReconID                                 = @p_ReconID
   and   not exists (select null
                     from dbo.RECONEDI_Tracking a (nolock)
                     inner join dbo.RECONEDI_Status b (nolock)
					 on  a.ProcessName             = b.Description
                     where a.ReconID               = @p_ReconID
				     and   b.StatusID              = 3
                     and   b.SubStatusID           = 7)

   delete a
   from RECONEDI_AccountChangePending a (nolock)
   where a.ReconID                                 = @p_ReconID
   and   not exists (select null
                     from dbo.RECONEDI_Tracking a (nolock)
                     inner join dbo.RECONEDI_Status b (nolock)
					 on  a.ProcessName             = b.Description
                     where a.ReconID               = @p_ReconID
				     and   b.StatusID              = 3
                     and   b.SubStatusID           = 7)

   delete dbo.RECONEDI_Tracking
   where RECONID                                   = @p_ReconID
  
   delete dbo.RECONEDI_Header
   where RECONID                                   = @p_ReconID

end

set nocount off

GO
