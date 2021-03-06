/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_Delete]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_Delete
 * Delete or Truncate reconciliation table.
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
CREATE procedure [dbo].[usp_RECONEDI_Delete]
(@p_ReconID                                        int,
 @p_ISO                                            varchar(50),
 @p_Utility                                        varchar(50),
 @p_AsOfDate                                       date,
 @p_ProcessDate                                    datetime,
 @p_Process                                        char(01) = 'T')
as

set nocount on

truncate table dbo.RECONEDI_ISOControl_Work

create table #ReconID
(ReconID                                           int primary key)
   
insert into #ReconID
select distinct a.ReconID
from RECONEDI_Header a (nolock)
where a.ReconID                                    < @p_ReconID
and   a.StatusID                                  <> 5

delete a
from #ReconID a (nolock)
inner join dbo.RECONEDI_Tracking b (nolock)
on  a.ReconID                                      = b.ReconID
inner join dbo.RECONEDI_Status c (nolock)
on    b.ProcessName                                = c.Description
where c.StatusID                                   = 3
and   c.SubStatusID                                = 7

delete b
from #ReconID a (nolock)
inner join dbo.RECONEDI_EDIPending  b (nolock)
on  a.ReconID                                      = b.ReconID

delete b
from #ReconID a (nolock)
inner join RECONEDI_EDI b (nolock)
on  a.ReconID                                      = b.ReconID

delete b
from #ReconID a (nolock)
inner join RECONEDI_AccountChangePending b (nolock)
on  a.ReconID                                      = b.ReconID

if @p_Process                                      = 'F'
begin

   delete b
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_ForecastDates b with (nolock) 
   on  a.EnrollmentID                              = b.EnrollmentID  
   where a.ReconID                                 = @p_ReconID
   and   exists(select null
                from dbo.RECONEDI_Filter z with (nolock)
                where z.Utility                    = a.Utility
                and   z.AccountNumber              = a.AccountNumber)

   delete b
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_ForecastDaily b with (nolock) 
   on  a.EnrollmentID                              = b.EnrollmentID  
   where a.ReconID                                 = @p_ReconID
   and   exists(select null
                from dbo.RECONEDI_Filter z with (nolock)
                where z.Utility                    = a.Utility
                and   z.AccountNumber              = a.AccountNumber)

   delete b
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_ForecastWholesale b with (nolock) 
   on  a.EnrollmentID                              = b.EnrollmentID  
   where a.ReconID                                 = @p_ReconID
   and   exists(select null
                from dbo.RECONEDI_Filter z with (nolock)
                where z.Utility                    = a.Utility
                and   z.AccountNumber              = a.AccountNumber)

   delete b
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_ForecastWholesaleError b with (nolock) 
   on  a.EnrollmentID                              = b.EnrollmentID  
   where a.ReconID                                 = @p_ReconID
   and   exists(select null
                from dbo.RECONEDI_Filter z with (nolock)
                where z.Utility                    = a.Utility
                and   z.AccountNumber              = a.AccountNumber)

   delete b
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_MTM b with (nolock) 
   on  a.EnrollmentID                              = b.EnrollmentID  
   where a.ReconID                                 = @p_ReconID
   and   exists(select null
                from dbo.RECONEDI_Filter z with (nolock)
                where z.Utility                    = a.Utility
                and   z.AccountNumber              = a.AccountNumber)

   delete a
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   where a.ReconID                                 = @p_ReconID
   and   exists(select null
                from dbo.RECONEDI_Filter z with (nolock)
                where z.Utility                    = a.Utility
                and   z.AccountNumber              = a.AccountNumber)
end

select 0
return 0

set nocount off


GO
