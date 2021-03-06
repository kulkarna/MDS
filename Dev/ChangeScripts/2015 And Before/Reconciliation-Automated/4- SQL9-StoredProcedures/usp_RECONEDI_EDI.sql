/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_EDI]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_EDI
 * Collect EDI Information.
 * Collect Account Changes Information.
 * History
 *******************************************************************************
 * 2014/04/01 - William Vilchez
 * Created.
 *******************************************************************************
 * <Date Modified,date,> - <Developer Name,,>
 * <Modification Description,,>
 *******************************************************************************
 */
CREATE procedure [dbo].[usp_RECONEDI_EDI]
(@p_ReconID                                        int,
 @p_ISO                                            varchar(50),
 @p_AsOfDate                                       date,
 @p_ProcessDate                                    datetime)
as
set nocount on

/***********************/

exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                   3,
								   2

exec dbo.usp_RECONEDI_Tracking @p_ReconID,
                               @p_ISO,
                               '*',
                               3,
					           2,
							   'Start'

/***********************/

if  exists (select null
            from dbo.RECONEDI_ISOControl (nolock)
            where ISO                              = @p_ISO
            and   LastEDI                          = convert(char(08), @p_ProcessDate, 112))
or exists(select null
          from dbo.RECONEDI_Header (nolock)
          where ReconID                            < @p_ReconID
          and   AsOfDate                          >= @p_AsOfDate
	      and   ((ISO                              = @p_ISO)
          or     (ISO                              = '*'))
		  and   StatusID                           = 5              
          and   SubStatusID                        = 0)
begin
   goto LabelEnd
end

begin try

   declare @w_814_Key                              int
      
   if exists(select null
             from dbo.RECONEDI_ISOControl (nolock)
             where ISO                        is not null
             and   LastEDI                         < convert(char(08), @p_ProcessDate, 112))
   or not exists (select null
                  from dbo.RECONEDI_ISOControl (nolock)
                  where len(ltrim(rtrim(ISO)))     = 0)
   begin

      begin tran

      select @w_814_Key                            = 0

      select @w_814_Key                            = [814_Key]
      from RECONEDI_ISOControl (nolock)
      where len(ltrim(rtrim(ISO)))                 = 0                            

      if @@rowcount                                = 0
      begin
         insert into RECONEDI_ISOControl 
         select '',
                0,
		        '19000101',
	   	        '19000101'
      end

      insert into dbo.RECONEDI_EDIPending
      select distinct a.[814_Key],
                      ISO                          = null,
                      esiid,
                      UtilityCode                  = z.UtilityCode,
                      TdspDuns,
                      TdspName,
                      TransactionType              = c.actioncode,
                      TransactionStatus            = a.actioncode,
                      Direction,
                      ChangeReason,
                      ChangeDescription            = case when ChangeReason = 'TD'
                                                          then ChangeDescription
                                                          else ''
                                                     end,            
                      TransactionDate              = convert(datetime, c.TransactionDate, 101),
                      TransactionEffectiveDate     = convert(datetime, case when (c.actioncode = 'E'
                                                                            or    c.actioncode = '5'
                                                                            or    c.actioncode = 'R'
                                                                            or    (c.actioncode = 'C'
                                                                            and    f.ChangeReason = 'DTM150')
                                                                            or    (c.actioncode = 'C'
                                                                            and    f.ChangeReason = 'TD'
                                                                            and    f.ChangeDescription = 'DTM150'))
                                                                            then case when len(ltrim(rtrim(EsiidStartDate))) > 0
                                                                                      then EsiidStartDate
                                                                                      else SpecialReadSwitchDate
                                                                                 end                                                  
                                                                            when (c.actioncode = 'D'
                                                                            or    c.actioncode = '25'
                                                                            or    c.actioncode = '6'
                                                                            or    (c.actioncode = 'C'
                                                                            and    f.ChangeReason = 'DTM151')
                                                                            or    (c.actioncode = 'C'
                                                                            and    f.ChangeReason = 'TD'
                                                                            and    f.ChangeDescription = 'DTM151'))
                                                                            then case when len(ltrim(rtrim(EsiidEndDate))) > 0
                                                                                      then EsiidEndDate
                                                                                      else SpecialReadSwitchDate
                                                                                 end 
                                                                       end, 101),          
               
                      EsiIdStartDate,
                      EsiIdEndDate,
                      SpecialReadSwitchDate,
                      EntityName,
                      MeterNumber,
                      PreviousESiId,
                      LDCBillingCycle,
                      TransactionSetId,
                      TransactionSetControlNbr,
                      TransactionSetPurposeCode,
                      TransactionNbr,
                      ReferenceNbr,
                      CrDuns,
                      CrName,
                      ProcessFlag,
                      ProcessDate,
                      ServiceTypeCode1,
                      ServiceType1,
                      ServiceTypeCode2,
                      ServiceType2,
                      ServiceTypeCode3,
                      ServiceType3,
                      ServiceTypeCode4,
                      ServiceType4,
                      MaintenanceTypeCode,
                      RejectCode,
                      RejectReason,
                      StatusCode,
                      StatusReason,
                      StatusType,
                      CapacityObligation,
                      TransmissionObligation,
                      LBMPZone,
                      PowerRegion,
                      stationid,
                      AssignId,
                     'ISTA',
                      @p_AsOfDate,
                      @p_ProcessDate,
					  @p_ReconID
      from ISTA_Market.dbo.tbl_814_header c (nolock) 
      left join ISTA_Market.dbo.tbl_814_Service a (nolock) 
      on a.[814_Key]                               = c.[814_key]
      left join ISTA_Market.dbo.tbl_814_Service_Meter d (nolock) 
      on a.Service_key                             = d.Service_key 
      left join ISTA_Market.dbo.tbl_814_Service_Reject e (nolock) 
      on e.Service_key                             = a.Service_key 
      left join ISTA_Market.dbo.tbl_814_Service_Account_Change f (nolock)
      on a.Service_key                             = f.Service_key 
      left join ISTA_Market.dbo.tbl_814_Service_Status g (nolock)
      on a.Service_key                             = g.Service_key 
      left join Libertypower.dbo.Utility z (nolock)
      on  TdspDuns                                 = z.DunsNumber
      left join (select [814_Key],      
                        EntityName                 = Max(EntityName),
                        EntityName2                = Max(EntityName2),
                        EntityName3                = Max(EntityName3),
                        EntityDuns                 = Max(EntityDuns),
                        Address1                   = Max(Address1),
                        Address2                   = Max(Address2),
                        City                       = Max(City),
                        State                      = Max(State), 
                        PostalCode                 = Max(PostalCode),
                        CountryCode                = Max(CountryCode),
                        ContactCode                = Max(ContactCode),
                        ContactName                = Max(ContactName),
                        ContactPhoneNbr1           = Max(ContactPhoneNbr1),
                        ContactPhoneNbr2           = Max(ContactPhoneNbr2)
                 from ISTA_Market.dbo.tbl_814_Name (nolock)
                 where [814_Key]                   > @w_814_Key
                 group by [814_Key]) b
      on a.[814_Key]                               = b.[814_key]
      where z.WholeSaleMktID                      is null
      and   Esiid                                 is not null
      and   len(ltrim(rtrim(Esiid)))               > 0
      and   c.Direction                            = 1
      and   c.ActionCode                      not in ('hu')
      and  (f.ChangeReason                        is null 
      or    f.ChangeReason                        in ('DTM150','DTM151','TD'))
      and   a.[814_Key]                            > @w_814_Key

 
      create table #EDINull
	 ([814_Key]                                    int,
	  ISO                                          varchar(50),
	  UtilityCode                                  varchar(50))

      insert into #EDINull
      select a.[814_Key],
             c.WholeSaleMktID,
		     c.UtilityCode
      from dbo.RECONEDI_EDIPending a (nolock)
      inner join Libertypower.dbo.Account b (nolock)  
      on a.esiid                                   = b.AccountNumber
      inner join Libertypower.dbo.Utility c (nolock) 
      on  b.UtilityID                              = c.ID
      where a.ISO                                 is null
	  and   c.WholeSaleMktID                       = @p_ISO
      and   c.InactiveInd                          = 0
      and  (select count(*)
            from Libertypower.dbo.Account x (nolock) 
            where x.AccountNumber       = a.esiid) = 1

      insert into #EDINull
      select d.[814_Key],
             b.WholeSaleMktID,
		     b.UtilityCode
      from libertypower.dbo.Account a (nolock)  
      inner join libertypower.dbo.Utility b (nolock)
      on  a.UtilityID                              = b.ID
      inner join lp_account.dbo.account_number_history c (nolock)
      on  a.AccountIDLegacy                        = c.Account_ID
      inner join dbo.RECONEDI_EDIPending d (nolock)
      on  c.old_Account_Number                     = d.Esiid
      where d.ISO                                 is null
	  and   b.WholeSaleMktID                       = @p_ISO
      and   b.InactiveInd                          = 0
      and  (select count(*)
            from Libertypower.dbo.Account x (nolock) 
            where x.AccountNumber                  = d.esiid) = 1
      and   not exists(select null
		               from #EDINull y (nolock)
		               where y.ISO                 = b.WholeSaleMktID
				       and   y.UtilityCode         = b.UtilityCode)

      update a set UtilityCode = b.UtilityCode,
                   ISO         = b.ISO
      from dbo.RECONEDI_EDIPending a (nolock)
      inner join #EDINull b (nolock)
      on a.[814_Key]                               = b.[814_Key]
	  where a.ISO                                 is null
	  and   b.ISO                             is not null

      update b set [814_Key] = b.[814_Key]
      from (select ISO,
                   [814_Key]                       = max([814_Key])
            from #EDINull (nolock)
			group by ISO) a
      inner join dbo.RECONEDI_ISOControl b (nolock)
	  on  a.ISO                                    = b.ISO
	  where a.ISO                             is not null
	  and   a.[814_Key]                            > b.[814_Key]

      select @w_814_Key                            = max(isnull([814_Key], 0))
      from dbo.RECONEDI_EDIPending (nolock)
      where ISO                                   is null

      update dbo.RECONEDI_ISOControl set [814_Key] = case when @w_814_Key > [814_Key]
	                                                      then @w_814_Key
														  else [814_Key]
												     end
      where len(ltrim(rtrim(ISO)))                 = 0

      commit tran

   end 

   if exists(select null
             from dbo.RECONEDI_ISOControl (nolock)
             where ISO                             = @p_ISO
             and   LastEDI                         < convert(char(08), @p_ProcessDate, 112))
   or not exists (select null
                  from dbo.RECONEDI_ISOControl (nolock)
                  where ISO                        = @p_ISO)
   begin
      begin tran

      select @w_814_Key                            = 0

      select @w_814_Key                            = [814_Key]
      from RECONEDI_ISOControl (nolock)
      where ISO                                    = @p_ISO                             

      if @@rowcount                                = 0
      begin
         insert into RECONEDI_ISOControl 
         select @p_ISO,
                0,
		        '19000101',
	   	        '19000101'
      end

      if  @w_814_Key                               = 0
      and @p_ISO                                   = 'NYISO'
      begin
         insert into dbo.RECONEDI_EDIPending
         select a.*,
                'RISK',
                @p_AsOfDate,
                @p_ProcessDate,
				@p_ReconID 
         from dbo.RECONEDI_NYISORisk a with (nolock)

         insert into dbo.RECONEDI_EDIPending
         select *,
                'OLDRECORDS',
                @p_AsOfDate,
                @p_ProcessDate,
				@p_ReconID
         from RECONEDI_NYISOOld_vw with (nolock)
      end

      insert into dbo.RECONEDI_EDIPending
      select distinct a.[814_Key],
                      @p_ISO,
                      esiid,
                      UtilityCode                  = z.UtilityCode,
                      TdspDuns,
                      TdspName,
                      TransactionType              = c.actioncode,
                      TransactionStatus            = a.actioncode,
                      Direction,
                      ChangeReason,
                      ChangeDescription            = case when ChangeReason = 'TD'
                                                          then ChangeDescription
                                                          else ''
                                                     end,            
                      TransactionDate              = convert(datetime, c.TransactionDate, 101),
                      TransactionEffectiveDate     = convert(datetime, case when (c.actioncode = 'E'
                                                                            or    c.actioncode = '5'
                                                                            or    c.actioncode = 'R'
                                                                            or    (c.actioncode = 'C'
                                                                            and    f.ChangeReason = 'DTM150')
                                                                            or    (c.actioncode = 'C'
                                                                            and    f.ChangeReason = 'TD'
                                                                            and    f.ChangeDescription = 'DTM150'))
                                                                            then case when len(ltrim(rtrim(EsiidStartDate))) > 0
                                                                                      then EsiidStartDate
                                                                                      else SpecialReadSwitchDate
                                                                                 end                                                  
                                                                            when (c.actioncode = 'D'
                                                                            or    c.actioncode = '25'
                                                                            or    c.actioncode = '6'
                                                                            or    (c.actioncode = 'C'
                                                                            and    f.ChangeReason = 'DTM151')
                                                                            or    (c.actioncode = 'C'
                                                                            and    f.ChangeReason = 'TD'
                                                                            and    f.ChangeDescription = 'DTM151'))
                                                                            then case when len(ltrim(rtrim(EsiidEndDate))) > 0
                                                                                      then EsiidEndDate
                                                                                      else SpecialReadSwitchDate
                                                                                 end 
                                                                       end, 101),          
               
                      EsiIdStartDate,
                      EsiIdEndDate,
                      SpecialReadSwitchDate,
                      EntityName,
                      MeterNumber                  = '',
                      PreviousESiId,
                      LDCBillingCycle,
                      TransactionSetId,
                      TransactionSetControlNbr,
                      TransactionSetPurposeCode,
                      TransactionNbr,
                      ReferenceNbr,
                      CrDuns,
                      CrName,
                      ProcessFlag,
                      ProcessDate,
                      ServiceTypeCode1,
                      ServiceType1,
                      ServiceTypeCode2,
                      ServiceType2,
                      ServiceTypeCode3,
                      ServiceType3,
                      ServiceTypeCode4,
                      ServiceType4,
                      MaintenanceTypeCode,
                      RejectCode,
                      RejectReason,
                      StatusCode,
                      StatusReason,
                      StatusType,
                      CapacityObligation,
                      TransmissionObligation,
                      LBMPZone,
                      PowerRegion,
                      stationid,
                      AssignId,
                      'ISTA',
                      @p_AsOfDate,
                      @p_ProcessDate,
					  @p_ReconID
      from ISTA_Market.dbo.tbl_814_header c (nolock) 
      left join ISTA_Market.dbo.tbl_814_Service a (nolock) 
      on a.[814_Key]                               = c.[814_key]
      left join ISTA_Market.dbo.tbl_814_Service_Meter d (nolock) 
      on a.Service_key                             = d.Service_key 
      left join ISTA_Market.dbo.tbl_814_Service_Reject e (nolock) 
      on e.Service_key                             = a.Service_key 
      left join ISTA_Market.dbo.tbl_814_Service_Account_Change f (nolock)
      on a.Service_key                             = f.Service_key 
      left join ISTA_Market.dbo.tbl_814_Service_Status g (nolock)
      on a.Service_key                             = g.Service_key 
      left join Libertypower.dbo.Utility z (nolock)
      on  TdspDuns                                 = z.DunsNumber
      left join (select [814_Key],      
                        EntityName                 = Max(EntityName),
                        EntityName2                = Max(EntityName2),
                        EntityName3                = Max(EntityName3),
                        EntityDuns                 = Max(EntityDuns),
                        Address1                   = Max(Address1),
                        Address2                   = Max(Address2),
                        City                       = Max(City),
                        State                      = Max(State), 
                        PostalCode                 = Max(PostalCode),
                        CountryCode                = Max(CountryCode),
                        ContactCode                = Max(ContactCode),
                        ContactName                = Max(ContactName),
                        ContactPhoneNbr1           = Max(ContactPhoneNbr1),
                        ContactPhoneNbr2           = Max(ContactPhoneNbr2)
                 from ISTA_Market.dbo.tbl_814_Name (nolock)
                 where [814_Key]                   > @w_814_Key
                 group by [814_Key]) b
      on a.[814_Key]                               = b.[814_key]
      where z.WholeSaleMktID                       = @p_ISO
      and   z.InactiveInd                          = 0
      and   Esiid                             is not null
      and   len(ltrim(rtrim(Esiid)))               > 0
      and   c.Direction                            = 1
      and   c.ActionCode                      not in ('hu')
      and  (f.ChangeReason                        is null 
      or    f.ChangeReason                        in ('DTM150','DTM151','TD'))
      and   a.[814_Key]                            > @w_814_Key

      if @@ROWCOUNT                               <> 0
      begin
         select @w_814_Key                         = max(isnull([814_Key], 0))
         from dbo.RECONEDI_EDIPending (nolock)
         where ISO                                 = @p_ISO
      end   

      update dbo.RECONEDI_ISOControl set [814_Key] = @w_814_Key,
                                         LastEDI   = convert(char(08), @p_ProcessDate, 112)
      where ISO                                    = @p_ISO

      commit tran
   end

   if exists(select null
             from dbo.RECONEDI_ISOControl (nolock)
             where ISO                             = @p_ISO
             and   LastAccountChanges              < convert(char(08), @p_ProcessDate, 112))
   begin

      begin tran

      declare @w_LastAccountChanges                date

      select @w_LastAccountChanges                 = LastAccountChanges
      from dbo.RECONEDI_ISOControl (nolock)
	  where ISO                                    = @p_ISO

      exec usp_RECONEDI_AccountChangePending @p_ReconID,
                                             @p_ISO,
                                             @p_AsOfDate,
                                             @p_ProcessDate,
                                             @w_LastAccountChanges
   
      update a set LastAccountChanges = convert(char(08), @p_ProcessDate, 112)
      from dbo.RECONEDI_ISOControl a (nolock)
      where a.ISO                                  = @p_ISO

      commit tran
   end
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
                               '*',
                               99,
					           0,
							   'Error',
							   @w_ErrorMessage

   select -1
   return -1
end catch

/***********************/

LabelEnd:

exec dbo.usp_RECONEDI_Tracking @p_ReconID,
                               @p_ISO,
                               '*',
                               3,
					           2,
							   'End'

select 0
return 0

/***********************/

set nocount off


GO
