/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_Process]    Script Date: 7/3/2014 2:50:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_Process
 * Excute the MTM process, EDI Result Process and the forecast Process. 
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
--exec usp_RECONEDI_Process 1, 'NEISO', '*', '20131209', '20140610', 0, 1, 1, 'T'
CREATE procedure [dbo].[usp_RECONEDI_Process]
(@p_ReconID                                        int,
 @p_ISO                                            varchar(50),
 @p_Utility                                        varchar(50),
 @p_AsOfDate                                       date,
 @p_ProcessDate                                    datetime,
 @p_MTM                                            bit = 1,
 @p_EDIResult                                      bit = 1,
 @p_Forecast                                       bit = 1,
 @p_Process                                        char(01) = 'T')
as

set nocount on

/********************************/
begin try 

   begin tran

   update a set ISO = b.ISO,
                LastEDI = b.LastEDI,
				LastAccountChanges = b.LastAccountChanges
   from dbo.RECONEDI_ISOControl a (nolock)
   inner join dbo.RECONEDI_ISOControl_Work b (nolock)
   on  a.ISO                                       = b.ISO

   insert into dbo.RECONEDI_ISOControl
   select *
   from dbo.RECONEDI_ISOControl_Work a (nolock)
   where not exists(select null
                    from dbo.RECONEDI_ISOControl b (nolock)
					where b.ISO                    = a.ISO)

   exec dbo.usp_RECONEDI_Tracking @p_ReconID,
                                  @p_ISO,
                                  @p_Utility,
                                  3,
			                      7,
							      'OK'

   commit tran
end try

begin catch

   if @@trancount                                  > 0
   begin
      rollback tran
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

   select -1
   return -1
end catch

declare @w_Return                                  int

declare @w_ParentReconID                           int

select @w_ParentReconID                            = ParentReconID
from dbo.RECONEDI_Header with (nolock)
where ReconID                                      = @p_ReconID
and   @p_Process                                   = 'I'

if  @w_ParentReconID                              <> 0
begin

   update a set ForecastType = 'PARENT',
                ParentEnrollmentID = b.EnrollmentID
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_EnrollmentFixed b with (nolock) 
   on  b.AccountID                                 = a.AccountID
   and b.ContractID                                = a.ContractID
   and b.Term                                      = a.Term
   and b.ContractRateStart                         = a.ContractRateStart
   and b.ContractRateEnd                           = a.ContractRateEnd
   where a.ReconID                                 = @p_ReconID
   and   b.ReconID                                 = @w_ParentReconID
   and   a.ISO                                     = @p_ISO
   and  (a.Utility                                 = @p_Utility
   or    @p_Utility                                = '*')

   update a set ForecastType = 'NEW_RATEDATE',
	            ParentEnrollmentID = 0
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join dbo.RECONEDI_EnrollmentFixed b with (nolock) 
   on   b.AccountID                                = a.AccountID
   and  b.ContractID                               = a.ContractID
   and  b.Term                                     = a.Term
   and (b.ContractRateStart                       <> a.ContractRateStart
   or   b.ContractRateEnd                         <> a.ContractRateEnd)
   where a.ReconID                                 = @p_ReconID
   and   b.ReconID                                 = @w_ParentReconID
   and   a.ISO                                     = @p_ISO
   and  (a.Utility                                 = @p_Utility
   or    @p_Utility                                = '*')

end

select @w_Return                                   = 0

if @p_MTM                                          = 1
begin
   exec @w_return                                  = usp_RECONEDI_MTM @p_ReconID,
                                                                      @p_ISO,
                                                                      @p_Utility,
                                                                      @p_AsOfDate,
                                                                      @p_ProcessDate,
                                                                      @p_Process

   if @w_Return                                   <> 0   
   begin
      update dbo.RECONEDI_Header set StatusID = 4
	  where ReconID                                = @p_ReconID
	  and   @w_Return                              = 1


--      exec usp_RECONEDI_DeleteByReconID @p_ReconID
      select -1
      return -1
   end
end

if @p_EDIResult                                    = 1
begin

   create table #Account
   (ID                                             int identity(1, 1) not null primary key clustered ,
    UtilityCode                                    varchar(50),
    Esiid                                          varchar(100)
	unique (UtilityCode, Esiid))

   create table #Utility                      
   (ID                                             int identity(1, 1) primary key clustered,
    Utility                                        varchar(50))

   create table #UtilityResult                      
   (ReconID                                        int,
    Utility                                        varchar(50),
    AsOfDate                                       date)

   if @p_Process                                   = 'F'
   begin
      insert into #Utility
      select distinct Utility
      from dbo.RECONEDI_Filter (nolock)
      where ISO                                    = @p_ISO
      and  (Utility                                = @p_Utility
      or    @p_Utility                             = '*')
   end

   if @p_Process                                  in ('T', 'I')
   begin
      insert into #Utility
      select distinct UtilityCode
      from Libertypower.dbo.Utility with (nolock)
      where InactiveInd = 0
      and   WholeSaleMktID                         = @p_ISO
      and  (UtilityCode                            = @p_Utility
      or    @p_Utility                             = '*')
   end

   if @p_Process                                   = 'T'
   begin

      insert into dbo.RECONEDI_EDIPendingControl
      select @p_ReconID,
             @p_ISO,
		     Utility,
             @p_AsOfDate,
		     1
      from #Utility (nolock)

      if  not exists(select null
                     from dbo.RECONEDI_EDIPendingControl (nolock)
                     where ReconID                 < @p_ReconID
                     and   AsOfDate               <= @p_AsOfDate
	   	 	         and   ISO                     = @p_ISO
					 and   InactiveInd             = 0)
      and exists(select null
                 from dbo.RECONEDI_EDIPendingControl (nolock)
                 where ReconID                     < @p_ReconID
                 and   AsOfDate                   >= @p_AsOfDate
	   	 	     and   ISO                         = @p_ISO
			     and   InactiveInd                 = 0)
      begin

         exec usp_RECONEDI_AccountChangePending @p_ReconID,
                                                @p_ISO,
                                                @p_AsOfDate,
                                                @p_AsOfDate,
                                                '19000101'

         insert into #Account
         select distinct 
                a.UtilityCode,
                a.Esiid
	     from dbo.RECONEDI_EDI a with (nolock)
         where a.ISO                               = @p_ISO
         and  (a.UtilityCode                       = @p_Utility
         or    @p_Utility                          = '*')
         and   a.Transactiondate                   < dateadd(dd, 1, @p_AsOFDate)
		 and not exists (select null
		                 from RECONEDI_AccountChangePending b
                 		 where b.UtilityCode       = a.UtilityCode
		                 and   b.Esiid             = a.Esiid)
      end

      if  exists(select null
                 from dbo.RECONEDI_EDIPendingControl (nolock)
                 where ReconID                     < @p_ReconID
                 and   AsOfDate                   <= @p_AsOfDate
 	 	         and   ISO                         = @p_ISO
				 and   InactiveInd                 = 0)
      begin
         create table #EDIResult
         (LineRef                                  int,
          Esiid                                    nvarchar(50),
          UtilityCode                              nvarchar(50),
          IDFrom                                   int,
          TransactionDateFrom                      datetime,
          TransactionEffectiveDateFrom             datetime,
          ReadCycleDateFrom                        datetime,
          OriginFrom                               varchar(100),
          ReferenceNbrFrom                         varchar(100),
          IDTo                                     int,
          TransactionDateTo                        datetime,
          TransactionEffectiveDateTo               datetime,
          ReadCycleDateTo                          datetime,
          OriginTo                                 varchar(100),
          ReferenceNbrTo                           varchar(100),
          Note                                     varchar(500),
          Status                                   varchar(8),
          DateCanRej                               datetime) 

		 create  index idx_#EDIResult on #EDIResult (Esiid, UtilityCode, LineRef)

       	 declare @w_ReconID                       int
		 declare @w_AsOfDate                      date

         select @w_ReconID                        = null
		 select @w_AsOfDate                       = null

         insert into #UtilityResult
         select max(a.ReconID),
		        a.Utility,
		        a.AsOfDate
         from dbo.RECONEDI_EDIPendingControl a (nolock)
         inner join (select b.Utility,
		                    AsOfDate              = max(a.AsOfDate)                       
                     from dbo.RECONEDI_EDIPendingControl a (nolock)
					 inner join #Utility b (nolock)
					 on  a.Utility                = b.Utility
					 where a.ReconID              < @p_ReconID
                     and   a.AsOfDate            <= @p_AsOfDate
                     and   a.ISO                  = @p_ISO
					 and   a.Utility              = b.Utility
					 and   a.InactiveInd          = 0
					 group by b.Utility) b
         on  a.AsOfDate                           = b.AsOfDate
		 and a.Utility                            = b.Utility
         where a.ReconID                          < @p_ReconID
		 and   ISO                                = @p_ISO
		 and   a.InactiveInd                      = 0
		 group by a.Utility,
		          a.AsOfaDate

	     truncate table #EDIResult

	     insert into #EDIResult
	     select a.LineRef,
                a.Esiid,
                a.UtilityCode,
                a.IDFrom,
                a.TransactionDateFrom,
                a.TransactionEffectiveDateFrom,
                a.ReadCycleDateFrom,
                a.OriginFrom,
                a.ReferenceNbrFrom,
                a.IDTo,
                a.TransactionDateTo,
                a.TransactionEffectiveDateTo,
                a.ReadCycleDateTo,
                a.OriginTo,
                a.ReferenceNbrTo,
                a.Note,
                a.Status,
                a.DateCanRej
         from dbo.RECONEDI_EDIResult a (nolock)
		 inner join (select ReconID                = max(a.ReconID),
		                    a.Utility
		             from #UtilityResult a (nolock)
					 inner join (select Utility,
					                    AsOfDate   = max(AsOfDate)
								 from #UtilityResult (nolock)
								 group by Utility) b
					 on  a.Utility                 = b.Utility
					 and a.AsOfDate                = b.AsOfDate) b                 
		 on    a.ReconID                           = b.ReconID
		 and   a.UtilityCode                       = b.Utility

         insert into dbo.RECONEDI_EDIResult 
         select @p_ReconID,
	            *,
		        @p_AsOfDate,
		        getdate()
         from #EDIResult (nolock)

         if  exists(select null
                    from dbo.RECONEDI_EDIPendingControl (nolock)
                    where ReconID                  < @p_ReconID
                    and   AsOfDate                >= @p_AsOfDate
                    and   ISO                      = @p_ISO
				    and   InactiveInd              = 0)
         begin

            exec usp_RECONEDI_AccountChangePending @p_ReconID,
                                                   @p_ISO,
                                                   @p_AsOfDate,
                                                   @p_AsOfDate,
                                                   @w_AsOfDate
                                                
            insert into #Account
            select distinct
                   b.UtilityCode,
                   b.Esiid
            from (select Esiid,
                         UtilityCode,
	                     MaxtTransactionDateFrom   = max(TransactiondateFrom),
	                     MaxtTransactionDateTo     = max(TransactiondateTo)
	              from #EDIResult (nolock)
		          group by Esiid,
	                       UtilityCode) a
	        inner join RECONEDI_EDI b (nolock)
            on  a.Esiid                            = b.Esiid
	        and a.UtilityCode                      = b.UtilityCode
	        and b.TransactionDate                 >= case when a.MaxtTransactionDateFrom > a.MaxtTransactionDateTo
	                                                      then a.MaxtTransactionDateFrom
									                      else a.MaxtTransactionDateTo
													 end
            and b.TransactionDate                  < dateadd(dd, 1, @p_AsOfDate)
   		    and not exists (select null
		                    from RECONEDI_AccountChangePending b
                            where b.UtilityCode    = a.UtilityCode
		                    and   b.Esiid          = a.Esiid)
         end
	  end
   end

   declare @w_ID                                   int
   declare @w_Utility                              varchar(50)

   declare @t_ID                                   int
   select @t_ID                                    = 1

   select @w_ID                                    = ID,
          @w_Utility                               = Utility 
   from #Utility (nolock)
   where ID                                        = @t_ID

   while @@rowcount                               <> 0
   begin
      select @t_ID                                 = @t_ID + 1

      select @w_Return                             = 0

      exec @w_return                               = usp_RECONEDI_EdiPending @p_ReconID,
                                                                             @p_ISO,
                                                                             @w_Utility,
                                                                             @p_AsOfDate,
                                                                             @p_ProcessDate,
																			 @p_Process


      if @w_Return                                <> 0
      begin
--          exec usp_RECONEDI_DeleteByReconID @p_ReconID
          select -1
          return -1
      end

      select @w_ID                                 = ID,
             @w_Utility                            = Utility 
      from #Utility (nolock)
      where ID                                     = @t_ID
   end
end

if @p_Forecast                                     = 1
begin

   select @w_Return                                = 0
   exec @w_return                                  = dbo.usp_RECONEDI_Forecast @p_ReconID,
                                                                               @p_ISO,
                                                                               @p_Utility,
                                                                               @p_AsOfDate,
                                                                               @p_ProcessDate,
                                                                               @p_Process

   if @w_Return                                   <> 0
   begin
      update dbo.RECONEDI_Header set StatusID = 4
	  where ReconID                                = @p_ReconID
	  and   @w_Return                              = 1
--      exec usp_RECONEDI_DeleteByReconID @p_ReconID
      select -1
      return -1
   end
end

exec usp_RECONEDI_HeaderUpdate @p_ReconID,
                               5,
							   0

select 0
return 0

set nocount off


GO
