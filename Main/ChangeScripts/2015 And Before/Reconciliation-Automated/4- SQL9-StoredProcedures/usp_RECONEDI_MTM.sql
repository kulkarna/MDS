/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_MTM]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_MTM
 * Collect Mark to Market Information 
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
CREATE procedure [dbo].[usp_RECONEDI_MTM] 
(@p_ReconID                                        int,
 @p_ISO                                            varchar(50),
 @p_Utility                                        varchar(50),
 @p_AsOfDate                                       date,
 @p_ProcessDate                                    datetime,
 @p_Process                                        char(01) = 'T')
as

set nocount on

if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 
begin
   exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                      4,
								      0
   return 1
end

/***********************/

exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                   3,
								   5

exec dbo.usp_RECONEDI_Tracking @p_ReconID,
                               @p_ISO,
                               @p_Utility,
                               3,
					           5,
							   'Start'

/***********************/

create table #Account
(EnrollmentID                                      int,
 ReconID                                           int,
 AccountID                                         int,
 ContractID                                        int)
 
create index idx_#Account on #Account
(AccountID,
 ContractID) 

insert into #Account
select distinct
       a.EnrollmentID,
       a.ReconID,
       a.AccountID,
       a.ContractID
from dbo.RECONEDI_EnrollmentFixed a with (nolock)
where a.ReconID                                    = @p_ReconID
and   a.ISO                                        = @p_ISO
and  (a.Utility                                    = @p_Utility
or    @p_Utility                                   = '*')
--Without Filter
and  ((@p_Process                                 in ('T', 'I'))
--Filter
or    (@p_Process                                  = 'F'
and    exists(select null
              from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
              where z.Utility                      = a.Utility
              and   z.AccountNumber                = a.AccountNumber)))

/******** Temporal MTMAccount ********/

create table #MTMAccount
(EnrollmentID                                      int,
 ReconID                                           int,
 AccountID                                         int,
 ContractID                                        int,
 DateCreated                                       datetime)
 
create index idx_#MTMAccount on #MTMAccount
(AccountID,
 ContractID) 

insert into #MTMAccount
select a.EnrollmentID,
       a.ReconID,
       a.AccountID,
       a.ContractID,
       DateCreated                                 = max(b.DateCreated)
from #Account a with (nolock)
inner join lp_MtM.dbo.MtMAccount b with (nolock)
on  a.AccountID                                    = b.AccountID
and a.ContractID                                   = b.ContractID
group by a.EnrollmentID,
         a.ReconID,
         a.AccountID,
         a.ContractID

/******** MTM ********/

begin try
   begin transaction

   if @p_Process                                   = 'F'
   begin
      delete b
      from dbo.RECONEDI_EnrollmentFixed a with (nolock)
      inner join dbo.RECONEDI_ForecastDates b with (nolock) 
      on  a.EnrollmentID                           = b.EnrollmentID  
      where a.ReconID                              = @p_ReconID
      and   exists(select null
                   from dbo.RECONEDI_Filter z with (nolock)
                   where z.Utility                 = a.Utility
                   and   z.AccountNumber           = a.AccountNumber)

      delete b
      from dbo.RECONEDI_EnrollmentFixed a with (nolock)
      inner join dbo.RECONEDI_ForecastDaily b with (nolock) 
      on  a.EnrollmentID                           = b.EnrollmentID  
      where a.ReconID                              = @p_ReconID
      and   exists(select null
                   from dbo.RECONEDI_Filter z with (nolock)
                   where z.Utility                 = a.Utility
                   and   z.AccountNumber           = a.AccountNumber)

      delete b
      from dbo.RECONEDI_EnrollmentFixed a with (nolock)
      inner join dbo.RECONEDI_ForecastWholesale b with (nolock) 
      on  a.EnrollmentID                           = b.EnrollmentID  
      where a.ReconID                              = @p_ReconID
      and   exists(select null
                   from dbo.RECONEDI_Filter z with (nolock)
                   where z.Utility                 = a.Utility
                   and   z.AccountNumber           = a.AccountNumber)

      delete b
      from dbo.RECONEDI_EnrollmentFixed a with (nolock)
      inner join dbo.RECONEDI_ForecastWholesaleError b with (nolock) 
      on  a.EnrollmentID                           = b.EnrollmentID   
      where a.ReconID                              = @p_ReconID
      and   exists(select null
                   from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
                   where z.Utility                 = a.Utility
                   and   z.AccountNumber           = a.AccountNumber)

      delete b
      from dbo.RECONEDI_EnrollmentFixed a with (nolock)
      inner join dbo.RECONEDI_MTM b with (nolock) 
      on  a.EnrollmentID                           = b.EnrollmentID  
      where a.ReconID                              = @p_ReconID
      and   exists(select null
                   from dbo.RECONEDI_Filter z with (nolock)
                   where z.Utility                 = a.Utility
                   and   z.AccountNumber           = a.AccountNumber)
   end

   insert into dbo.RECONEDI_MTM
   select a.EnrollmentID,
          a.ReconID,
		  b.ID,
          b.BatchNumber,
          b.QuoteNumber,
          b.AccountID,
          b.ContractID,
          b.Zone,
          b.LoadProfile,
          null,
          b.ProxiedProfile,
          b.ProxiedUsage,
          b.MeterReadCount,
          b.Status,
          b.DateCreated,
          b.CreatedBy,
          b.DateModified   
   from #MTMAccount a with (nolock)
   left join lp_MtM.dbo.MtMAccount b (nolock)
   on  a.AccountID                                 = b.AccountID  
   and a.ContractID                                = b.ContractID
   and a.DateCreated                               = b.DateCreated

   declare @w_ParentReconID                        int

   select @w_ParentReconID                         = 0

   select @w_ParentReconID                         = ParentReconID
   from dbo.RECONEDI_Header with (nolock)
   where ReconID                                   = @p_ReconID

   if @w_ParentReconID                            <> 0
   begin
      update a set ForecastType = 'NEW_MTM',
	               ParentEnrollmentID = 0
      from dbo.RECONEDI_EnrollmentFixed a with (nolock)
	  inner join dbo.RECONEDI_MTM b with (nolock)
	  on  a.EnrollmentID                           = b.EnrollmentID
      inner join dbo.RECONEDI_MTM c with (nolock) 
      on  b.AccountID                              = c.AccountID
      and b.ContractID                             = c.ContractID
      where b.ReconID                              = @p_ReconID
	  and   c.ReconID                              = @w_ParentReconID
      and   a.ISO                                  = @p_ISO
      and  (a.Utility                              = @p_Utility
      or    @p_Utility                             = '*')
	  and   ((b.ID                                <> c.ID)
      or     (b.ID                                is null
      and     c.ID                            is not null)
      or     (b.ID                            is not null
      and     c.ID                                is null))
   end

   commit transaction
end try

begin catch
   if @@trancount                                  > 0
   begin
      rollback transaction
   end

   declare @w_ErrorMessage                         varchar(200)

   select @w_ErrorMessage                          = substring(error_message(), 1, 200)

   exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                      99,
								      0

   exec dbo.usp_RECONEDI_Tracking @p_ReconID,
                                  @p_ISO,
                                  @p_Utility,
                                  99,
			                      0,
							      'Error',
							      @w_ErrorMessage
   return -1
end catch

/***********************/

if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 
begin
   exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                      4,
								      0
   return 1
end

exec dbo.usp_RECONEDI_Tracking @p_ReconID,
                               @p_ISO,
                               @p_Utility,
                               3,
					           5,
							   'End'

return 0

set nocount off


GO
