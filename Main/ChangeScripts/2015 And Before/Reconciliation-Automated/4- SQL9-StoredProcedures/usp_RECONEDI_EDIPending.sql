/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_EDIPending]    Script Date: 7/3/2014 2:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_EDIPending
 * Process EDI Information.  
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
 CREATE procedure [dbo].[usp_RECONEDI_EDIPending] 
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
								   3

exec dbo.usp_RECONEDI_Tracking @p_ReconID,
                               @p_ISO,
                               @p_Utility,
                               3,
					           3,
							   'Start'

/******** Pending Account Transaction ********/


create table #AccountWork
(ID                                                int identity(1, 1) not null primary key clustered ,
 UtilityCode                                       varchar(50),
 Esiid                                             varchar(100)
 unique (UtilityCode, Esiid))

insert into #AccountWork
select distinct
       a.UtilityCode,
       a.Esiid
from #Account a with (nolock)
inner join Libertypower..Utility b (nolock)
on  a.UtilityCode                                  = b.UtilityCode
where b.WholeSaleMktID                             = @p_ISO
and  (b.UtilityCode                                = @p_Utility
or    @p_Utility                                   = '*')

if @p_Process                                      = 'F'
begin
   insert into #AccountWork
   select distinct 
          a.Utility,
          a.AccountNumber
   from dbo.RECONEDI_Filter a (nolock)
   where a.ISO                                     = @p_ISO
   and  (a.Utility                                 = @p_Utility
   or    @p_Utility                                = '*')
   and   not exists(select null
                    from #AccountWork b with (nolock)
                    where b.UtilityCode            = a.Utility
                    and   b.Esiid                  = a.AccountNumber)
end

insert into #AccountWork
select distinct a.UtilityCode,
                a.Esiid
from dbo.RECONEDI_AccountChangePending a with (nolock)
where a.ISO                                        = @p_ISO
and  (a.UtilityCode                                = @p_Utility
or    @p_Utility                                   = '*')
--Without Filter
and   ((@p_Process                                in ('T', 'I'))
--Filter
or     (@p_Process                                 = 'F'
and     exists(select null
               from dbo.RECONEDI_Filter z with (nolock)
               where z.Utility                     = a.UtilityCode
               and   z.AccountNumber               = a.Esiid)))
and   not exists(select null
                 from #AccountWork b with (nolock)
                 where b.UtilityCode               = a.UtilityCode
                 and   b.Esiid                     = a.Esiid)
and   not exists(select null
                 from dbo.RECONEDI_Header (nolock)
                 where ReconID                     < @p_ReconID
                 and   AsOfDate                   >= @p_AsOfDate
      	         and   ((ISO                       = @p_ISO)
                 or     (ISO                       = '*'))
		         and   StatusID                    = 5              
                 and   SubStatusID                 = 0)

insert into #AccountWork
select distinct 
       a.UtilityCode,
       a.Esiid
from dbo.RECONEDI_EDIPending a with (nolock)
where a.ISO                                        = @p_ISO
and  (a.UtilityCode                                = @p_Utility
or    @p_Utility                                   = '*')
and   a.Transactiondate                            < dateadd(dd, 1, @p_AsOFDate)
--Without Filter
and  ((@p_Process                                 in ('T', 'I'))
--Filter
or   (@p_Process                                   = 'F'
and   exists(select null
             from dbo.RECONEDI_Filter z with (nolock)
             where z.Utility                       = a.UtilityCode
             and   z.AccountNumber                 = a.Esiid)))
and   not exists(select null
                 from #AccountWork b with (nolock)
                 where b.UtilityCode               = a.UtilityCode
                 and   b.Esiid                     = a.Esiid)

/******** EDI Result ********/

declare @w_ParentReconID                           int

select @w_ParentReconID                            = 0

select @w_ParentReconID                            = ParentReconID
from dbo.RECONEDI_Header with (nolock)
where ReconID                                      = @p_ReconID
and   @p_Process                                   = 'I'

declare @w_ID                                      int
declare @w_UtilityCode                             varchar(50)
declare @w_Esiid                                   varchar(100)

declare @w_RowCount                                int
declare @t_ID                                      int
select @t_ID                                       = 1

if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 
begin
   exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                      4,
								      0
   return 1
end

begin try 

   truncate table dbo.RECONEDI_EDIPending_Work

   insert into dbo.RECONEDI_EDIPending_Work
   select distinct
          b.ID,
          b.[814_Key],
          b.Esiid,
          a.UtilityCode,
          b.TransactionType,
          b.TransactionStatus,
          b.ChangeReason,
          b.ChangeDescription,
          b.StatusCode,
          b.TransactionDate,
          b.TransactionEffectiveDate,
          b.ReferenceNbr,
          b.TransactionNbr,
          b.AssignId,
          b.Origin,
          b.TransactionSetControlNbr
   from #AccountWork a with (nolock) 
   inner join dbo.RECONEDI_EDI b with (nolock)
   on  a.UtilityCode                               = b.UtilityCode
   and a.Esiid                                     = b.Esiid
   where b.Transactiondate                         < dateadd(dd, 1, @p_AsOFDate)
   and   substring(a.UtilityCode, 1, 5)           <> 'NSTAR'
   and   not exists(select null
                    from dbo.RECONEDI_EDIPending_Work w (nolock)
					where w.ID                     = b.ID
					and   w.[814_Key]              = b.[814_Key]
					and   w.[Esiid]                = b.Esiid)

   insert into dbo.RECONEDI_EDIPending_Work
   select distinct
          b.ID,
          b.[814_Key],
          b.Esiid,
          a.UtilityCode,
          b.TransactionType,
          b.TransactionStatus,
          b.ChangeReason,
          b.ChangeDescription,
          b.StatusCode,
          b.TransactionDate,
          b.TransactionEffectiveDate,
          b.ReferenceNbr,
          b.TransactionNbr,
          b.AssignId,
          b.Origin,
          b.TransactionSetControlNbr
   from #AccountWork a with (nolock)
   inner join dbo.RECONEDI_EDI b with (nolock)
   on  substring(a.UtilityCode, 1, 5)              = substring(b.UtilityCode, 1, 5)
   and a.Esiid                                     = b.Esiid
   where b.Transactiondate                         < dateadd(dd, 1, @p_AsOFDate)
   and   substring(a.UtilityCode, 1, 5)            = 'NSTAR'
   and   not exists(select null
                    from dbo.RECONEDI_EDIPending_Work w (nolock)
					where w.ID                     = b.ID
					and   w.[814_Key]              = b.[814_Key]
					and   w.[Esiid]                = b.Esiid)

   insert into dbo.RECONEDI_EDIPending_Work
   select distinct
          b.ID,
          b.[814_Key],
          a.Esiid,
          a.UtilityCode,
          b.TransactionType,
          b.TransactionStatus,
          b.ChangeReason,
          b.ChangeDescription,
          b.StatusCode,
          b.TransactionDate,
          b.TransactionEffectiveDate,
          b.ReferenceNbr,
          b.TransactionNbr,
          b.AssignId,
          b.Origin,
          b.TransactionSetControlNbr
   from (select distinct
                a.UtilityCode,
                a.Esiid,
                a.EsiidOld
         from dbo.RECONEDI_AccountChangePending a with (nolock)
		 where a.ISO                                = @p_ISO
         and  (a.UtilityCode                        = @p_Utility
         or    @p_Utility                           = '*')
         and   substring(a.UtilityCode, 1, 5)      <> 'NSTAR'
         and   a.EsiidOld                          <> '') a
   inner join dbo.RECONEDI_EDI b with (nolock)
   on  a.UtilityCode                               = b.UtilityCode
   and a.EsiidOld                                  = b.Esiid
   where b.Transactiondate                         < dateadd(dd, 1, @p_AsOFDate)
   --Without Filter
   and ((@p_Process                               in ('T', 'I'))
   --Filter
   or   (@p_Process                                = 'F'
   and   exists(select null
                from dbo.RECONEDI_Filter z with (nolock)
                where z.Utility                    = a.UtilityCode
                and   z.AccountNumber              = a.Esiid)))
   and   not exists(select null
                    from dbo.RECONEDI_EDIPending_Work w (nolock)
					where w.ID                     = b.ID
					and   w.[814_Key]              = b.[814_Key]
					and   w.[Esiid]                = a.Esiid)
   and   not exists(select null
                    from dbo.RECONEDI_Header (nolock)
                    where ReconID                  < @p_ReconID
                    and   AsOfDate                >= @p_AsOfDate
	                and   ((ISO                    = @p_ISO)
                    or     (ISO                    = '*'))
		            and   StatusID                 = 5              
                    and   SubStatusID              = 0)

   insert into dbo.RECONEDI_EDIPending_Work
   select distinct
          b.ID,
          b.[814_Key],
          a.Esiid,
          a.UtilityCode,
          b.TransactionType,
          b.TransactionStatus,
          b.ChangeReason,
          b.ChangeDescription,
          b.StatusCode,
          b.TransactionDate,
          b.TransactionEffectiveDate,
          b.ReferenceNbr,
          b.TransactionNbr,
          b.AssignId,
          b.Origin,
          b.TransactionSetControlNbr
   from (select distinct
                a.UtilityCode,
                a.Esiid,
                a.EsiidOld
         from dbo.RECONEDI_AccountChangePending a with (nolock)
		 where a.ISO                                = @p_ISO
         and  (a.UtilityCode                        = @p_Utility
         or    @p_Utility                           = '*')
         and   substring(a.UtilityCode, 1, 5)       = 'NSTAR'
         and   a.EsiidOld                          <> '') a
   inner join dbo.RECONEDI_EDI b with (nolock)
   on  substring(a.UtilityCode, 1, 5)              = substring(b.UtilityCode, 1, 5)
   and a.EsiidOld                                  = b.Esiid
   where b.Transactiondate                         < dateadd(dd, 1, @p_AsOFDate)
   --Without Filter
   and ((@p_Process                               in ('T', 'I'))
   --Filter
   or   (@p_Process                                = 'F'
   and   exists(select null
                from dbo.RECONEDI_Filter z with (nolock)
                where z.Utility                    = a.UtilityCode
                and   z.AccountNumber              = a.Esiid)))
   and   not exists(select null
                    from dbo.RECONEDI_EDIPending_Work w (nolock)
					where w.ID                     = b.ID
					and   w.[814_Key]              = b.[814_Key]
					and   w.[Esiid]                = a.Esiid)
   and   not exists(select null
                    from dbo.RECONEDI_Header (nolock)
                    where ReconID                  < @p_ReconID
                    and   AsOfDate                >= @p_AsOfDate
	                and   ((ISO                    = @p_ISO)
                    or     (ISO                    = '*'))
		            and   StatusID                 = 5              
                    and   SubStatusID              = 0)

   if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 
   begin
      exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                         4,
		                                 0
      return 1
   end

   select @w_ID                                    = ID,     
          @w_UtilityCode                           = UtilityCode,
		  @w_Esiid                                 = Esiid
   from #AccountWork (nolock)
   where ID                                        = @t_ID

   select @w_RowCount                              = @@RowCount

   while @w_RowCount                              <> 0
   begin

      delete b
      from #AccountWork a with (nolock)
      inner join dbo.RECONEDI_EDIResult b with (nolock)
      on  a.UtilityCode                            = b.UtilityCode
      and a.Esiid                                  = b.Esiid
      where b.ReconID                              = @p_ReconID
      and   a.ID                                   = @w_ID

      exec dbo.usp_RECONEDI_EDIResult @p_ReconID,
		                              @w_UtilityCode,
                                      @w_Esiid, 
	                                  @p_AsOfDate,
		                              @p_ProcessDate

      if  @w_ParentReconID                        <> 0
      begin
	     update b set ForecastType = 'NEW_EDI',
	                  ParentEnrollmentID = 0
         from #AccountWork a with (nolock) 
         inner join dbo.RECONEDI_EnrollmentFixed b (nolock)
         on  a.UtilityCode                         = b.Utility
         and a.Esiid                               = b.AccountNumber
         where b.ReconID                           = @p_ReconID
   	     and   a.ID                                = @w_ID
      end

      if (dbo.ufn_RECONEDI_CheckProcessCancel(@p_ReconID)) <> 0 
      begin
         exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                            4,
				                            0
         return 1
      end

      select @t_ID                                 = @t_ID + 1

      select @w_ID                                 = ID,     
             @w_UtilityCode                        = UtilityCode,
             @w_Esiid                              = Esiid
      from #AccountWork (nolock)
      where ID                                     = @t_ID

      select @w_RowCount                           = @@RowCount

   end

   begin transaction

   if not exists(select null
                 from dbo.RECONEDI_Header (nolock)
                 where ReconID                     < @p_ReconID
                 and   AsOfDate                   >= @p_AsOfDate
                 and   ((ISO                       = @p_ISO)
                 or     (ISO                       = '*'))
	             and   StatusID                    = 5              
                 and   SubStatusID                 = 0)
   begin
      delete b
      from #AccountWork a with (nolock) 
      inner join dbo.RECONEDI_AccountChangePending b (nolock)
      on  a.UtilityCode                            = b.UtilityCode
      and a.Esiid                                  = b.Esiid

      delete b
      from #AccountWork a with (nolock) 
      inner join dbo.RECONEDI_EDIPending b with (nolock)
      on  a.UtilityCode                            = b.UtilityCode
      and a.Esiid                                  = b.Esiid
      where b.Transactiondate                      < dateadd(dd, 1, @p_AsOFDate)
   end
   
   update a set InactiveInd = 0
   from dbo.RECONEDI_EDIPendingControl a
   where a.ReconID                                 = @p_ReconID
   and   a.Utility                                 = @p_Utility
   and   a.AsOfDate                                = @p_AsOfDate
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
					           3,
							   'End'


return 0

set nocount off

GO
