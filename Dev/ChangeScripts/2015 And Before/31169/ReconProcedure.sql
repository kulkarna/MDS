
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_AccountChange]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_RECONEDI_AccountChange]
(@p_ISO                                            varchar(50),
 @p_AccountChange                                  datetime)
as 

update dbo.RECONEDI_ISOControl set AccountChange = @p_AccountChange
where ISO                                          = @p_ISO
and   @p_AccountChange                             > AccountChange

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_Delete]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC usp_RECONEDI_Delete 'MISO', '*', 'FIXED', 'f'

CREATE procedure [dbo].[usp_RECONEDI_Delete]
(@p_ISO                                            varchar(50),
 @p_ProcessType                                    varchar(50),
 @p_ProductCategory                                varchar(50),
 @p_Process                                        char(01),
 @p_EnrollmentStep                                 bit,
 @p_EDIStep                                        bit)
as

/******** Utility ********/


declare @Utility table                        
(Utility                                           varchar(50) primary key clustered)

if @p_Process                                      = 'F'
begin
   insert into @Utility
   select distinct Utility
   from dbo.RECONEDI_Filter (nolock)
   where ISO                                       = @p_ISO
end

if @p_Process                                     in ('T', 'I')
begin
 
   insert into @Utility
   select distinct UtilityCode
   from Libertypower.dbo.Utility with (nolock)
   where InactiveInd                               = 0
   and   WholeSaleMktID                            = @p_ISO
end

if @p_ProductCategory                              = 'FIXED'
begin


   if @p_EnrollmentStep                            = 1
   begin
      if  @p_Process                               = ('I')
      begin

         delete c
         from dbo.RECONEDI_EnrollmentChanges a with (nolock index = PK_RECONEDI_EnrollmentChanges)
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx3_RECONEDI_EnrollmentFixed)
         on  a.AccountID                           = b.AccountID
         and a.ContractID                          = b.ContractID
         and a.Term                                = b.Term
         inner join dbo.RECONEDI_ForecastDates c with (nolock index = idx_RECONEDI_ForecastDates) 
         on  b.ENID                                = c.ENID   
		  
         delete c
         from dbo.RECONEDI_EnrollmentChanges a with (nolock index = PK_RECONEDI_EnrollmentChanges)
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx3_RECONEDI_EnrollmentFixed)
         on  a.AccountID                           = b.AccountID
         and a.ContractID                          = b.ContractID
         and a.Term                                = b.Term
         inner join dbo.RECONEDI_ForecastDaily c with (nolock index = idx_RECONEDI_ForecastDaily)  
         on  b.ENID                                = c.ENID   

         delete c
         from dbo.RECONEDI_EnrollmentChanges a with (nolock index = PK_RECONEDI_EnrollmentChanges)
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx3_RECONEDI_EnrollmentFixed)
         on  a.AccountID                           = b.AccountID
         and a.ContractID                          = b.ContractID
         and a.Term                                = b.Term
         inner join dbo.RECONEDI_ForecastWholesale c with (nolock index = idx_RECONEDI_ForecastWholesale)  
         on  b.ENID                                = c.ENID   

         delete c
         from dbo.RECONEDI_EnrollmentChanges a with (nolock index = PK_RECONEDI_EnrollmentChanges)
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx3_RECONEDI_EnrollmentFixed)
         on  a.AccountID                           = b.AccountID
         and a.ContractID                          = b.ContractID
         and a.Term                                = b.Term
         inner join dbo.RECONEDI_MTM c with (nolock index = idx_RECONEDI_MTM)
         on  b.ENID                                = c.ENID   

         delete b
         from dbo.RECONEDI_EnrollmentChanges a with (nolock index = PK_RECONEDI_EnrollmentChanges)
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx3_RECONEDI_EnrollmentFixed)
         on  a.AccountID                           = b.AccountID
         and a.ContractID                          = b.ContractID
         and a.Term                                = b.Term
 
      end

      if  @p_Process                               = ('T')
      begin

         delete c
         from @Utility a
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
         on  a.Utility                             = b.Utility
         inner join dbo.RECONEDI_ForecastDates c with (nolock index = idx_RECONEDI_ForecastDates) 
         on  b.ENID                                = c.ENID   

         delete c
         from @Utility a
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
         on  a.Utility                             = b.Utility
         inner join dbo.RECONEDI_ForecastDaily c with (nolock index = idx_RECONEDI_ForecastDaily) 
         on  b.ENID                                = c.ENID   

         delete c
         from @Utility a
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
         on  a.Utility                             = b.Utility
         inner join dbo.RECONEDI_ForecastWholesale c with (nolock index = idx_RECONEDI_ForecastWholesale) 
         on  b.ENID                                = c.ENID   

         delete c
         from @Utility a
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
         on  a.Utility                             = b.Utility
         inner join dbo.RECONEDI_MTM c with (nolock index = idx_RECONEDI_MTM) 
         on  b.ENID                                = c.ENID   

         delete b
         from @Utility a
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
         on  a.Utility                             = b.Utility

         delete a
		 from dbo.RECONEDI_MTM a with (nolock index = idx_RECONEDI_MTM)
		 where not exists(select null
		                  from dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
                          where b.ENID             = a.ENID)

		 delete a
		 from dbo.RECONEDI_ForecastDates a with (nolock index = idx_RECONEDI_ForecastDates) 
		 where not exists(select null
		                  from dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
                          where b.ENID             = a.ENID)
	      
		 delete a
		 from dbo.RECONEDI_ForecastDates a with (nolock index = idx_RECONEDI_ForecastDates) 
		 where not exists(select null
		                  from dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
                          where b.ENID             = a.ENID)

		 delete a
		 from dbo.RECONEDI_ForecastDaily a with (nolock index = idx_RECONEDI_ForecastDaily) 
		 where not exists(select null
		                  from dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
                          where b.ENID             = a.ENID)

		 delete a
		 from dbo.RECONEDI_ForecastWholesale a with (nolock index = idx_RECONEDI_ForecastWholesale) 
		 where not exists(select null
		                  from dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
                          where b.ENID             = a.ENID)

	  end

      if  @p_Process                               = ('F')
      begin

         delete c
         from @Utility a
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
         on  a.Utility                             = b.Utility
         inner join dbo.RECONEDI_ForecastDates c with (nolock index = idx_RECONEDI_ForecastDates) 
         on  b.ENID                                = c.ENID   
         inner join dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
         on  z.Utility                             = b.Utility
         and z.AccountNumber                       = b.AccountNumber

         delete c
         from @Utility a
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
         on  a.Utility                             = b.Utility
         inner join dbo.RECONEDI_ForecastDaily c with (nolock index = idx_RECONEDI_ForecastDaily) 
         on  b.ENID                                = c.ENID   
         inner join dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
         on  z.Utility                             = b.Utility
         and z.AccountNumber                       = b.AccountNumber

         delete c
         from @Utility a
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
         on  a.Utility                             = b.Utility
         inner join dbo.RECONEDI_ForecastWholesale c with (nolock index = idx_RECONEDI_ForecastWholesale) 
         on  b.ENID                                = c.ENID   
         inner join dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
         on  z.Utility                             = b.Utility
         and z.AccountNumber                       = b.AccountNumber

         delete c
         from @Utility a
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
         on  a.Utility                             = b.Utility
         inner join dbo.RECONEDI_MTM c with (nolock index = idx_RECONEDI_MTM) 
         on  b.ENID                                = c.ENID   
         inner join dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
         on  z.Utility                             = b.Utility
         and z.AccountNumber                       = b.AccountNumber

         delete b
         from @Utility a
         inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
         on  a.Utility                             = b.Utility
         inner join dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
         on  z.Utility                             = b.Utility
         and z.AccountNumber                       = b.AccountNumber
   
	  end
   end

   if  @p_EdiStep                                  = 1
   begin

      declare @w_814_Key                           int
      select @w_814_Key                            = 0

      select @w_814_Key                            = [814_Key]
      from RECONEDI_ISOControl (nolock)
      where ISO                                    = @p_ISO                             

      if @@rowcount                                = 0
      begin

         delete dbo.RECONEDI_EDI
         where ISO                                 = @p_ISO

         delete dbo.RECONEDI_EDIPending
         where ISO                                 = @p_ISO

         delete a
         from dbo.RECONEDI_EDIResult a (nolock)
         inner join Libertypower.dbo.Utility b (nolock)
         on  a.UtilityCode                         = b.UtilityCode
         where b.WholeSaleMktID                    = @p_ISO
      end

      select @w_814_Key                            = 0

      select @w_814_Key                            = [814_Key]
      from RECONEDI_ISOControl (nolock)
      where ISO                                   is null                             

      if @@ROWCOUNT                                = 0
      begin
         delete dbo.RECONEDI_EDI
         where ISO                                is null

         delete dbo.RECONEDI_EDIPending
         where ISO                                is null
      end

      delete RECONEDI_ISOControl 
      where ISO                                    = @p_ISO
      or    ISO                                   is null
   end
end

if  @p_ProductCategory                             = 'VARIABLE'
and @p_EnrollmentStep                              = 1
begin
   delete b
   from @Utility a
   inner join dbo.RECONEDI_EnrollmentVariable b with (nolock index = idx_RECONEDI_EnrollmentVariable)
   on  a.Utility                                   = b.Utility
--Without Filter
   where ((@p_Process                              = 'T')
--Filter
   or     (@p_Process                              = 'F'
   and     exists(select null
                  from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
                  where z.Utility                  = b.Utility
                  and   z.AccountNumber            = b.AccountNumber)))
end

delete b
from @Utility a
inner join dbo.RECONEDI_Filter b with (nolock index = idx_RECONEDI_Filter)
on  a.Utility                                      = b.Utility
where @p_Process                                   = 'F'


GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_EDI]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_RECONEDI_EDI 'CAISO', '20140311', '20140311'
CREATE procedure [dbo].[usp_RECONEDI_EDI]
(@p_ISO                                            varchar(50),
 @p_ProcessDate                                    datetime,
 @p_ControlDate                                    datetime,
 @p_REHID                                          bigint)
as

/***********************/

update dbo.RECONEDI_Header set STID = 2,
                               Notes = ''
where REHID                                        = @p_REHID                            

insert into dbo.RECONEDI_Tracking
select @p_REHID,
       @p_ISO,
       '',
       'Start - EDI Process ',
       getdate(),
       'usp_RECONEDI_EDI'

/***********************/

declare @w_814_Key                                 int
select @w_814_Key                                  = 0

select @w_814_Key                                  = [814_Key]
from RECONEDI_ISOControl (nolock)
where ISO                                          = @p_ISO                             

if @@rowcount                                      = 0
begin
   insert into RECONEDI_ISOControl 
   select @p_ISO,
          0,
		  '19000101',
		  '19000101'
end

if  @w_814_Key                                     = 0
and @p_ISO                                         = 'NYISO'
begin
   insert into dbo.RECONEDI_EDIPending
   select a.*,
          'RISK',
          @p_ControlDate,
          getdate() 
   from dbo.RECONEDI_NYISORisk a with (nolock)

   insert into dbo.RECONEDI_EDIPending
   select *,
          'OLDRECORDS',
          @p_ControlDate,
          getdate() 
   from dbo.ufn_RECONEDI_NYISOOld()
end

insert into dbo.RECONEDI_EDIPending
select distinct a.[814_Key],
                @p_ISO,
                esiid,
                UtilityCode                        = z.UtilityCode,
                TdspDuns,
                TdspName,
                TransactionType                    = c.actioncode,
                TransactionStatus                  = a.actioncode,
                Direction,
                ChangeReason,
                ChangeDescription                  = case when ChangeReason = 'TD'
                                                          then ChangeDescription
                                                          else ''
                                                     end,            
                TransactionDate                    = convert(datetime, c.TransactionDate, 101),
                TransactionEffectiveDate           = convert(datetime, case when (c.actioncode = 'E'
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
                MeterNumber                        = '',
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
                @p_ControlDate,
                getdate()
from ISTA_Market.dbo.tbl_814_header c (nolock) 
left join ISTA_Market.dbo.tbl_814_Service a (nolock) 
on a.[814_Key]                                     = c.[814_key]
left join ISTA_Market.dbo.tbl_814_Service_Meter d (nolock) 
on a.Service_key                                   = d.Service_key 
left join ISTA_Market.dbo.tbl_814_Service_Reject e (nolock) 
on e.Service_key                                   = a.Service_key 
left join ISTA_Market.dbo.tbl_814_Service_Account_Change f (nolock)
on a.Service_key                                   = f.Service_key 
left join ISTA_Market.dbo.tbl_814_Service_Status g (nolock)
on a.Service_key                                   = g.Service_key 
left join Libertypower.dbo.Utility z (nolock)
on  TdspDuns                                       = z.DunsNumber
cross apply dbo.ufn_RECONEDI_EDI(a.[814_key]) b 
where z.WholeSaleMktID                             = @p_ISO
and   z.InactiveInd                                = 0
and   Esiid                                   is not null
and   len(ltrim(rtrim(Esiid)))                     > 0
and   c.Direction                                  = 1
and   c.ActionCode                            not in ('hu')
and  (f.ChangeReason                              is null 
or    f.ChangeReason                              in ('DTM150','DTM151','TD'))
and   a.[814_Key]                                  > @w_814_Key

if @@ROWCOUNT                                     <> 0
begin
   select @w_814_Key                               = max(isnull([814_Key], 0))
   from dbo.RECONEDI_EDIPending (nolock)
   where ISO                                       = @p_ISO
end

update dbo.RECONEDI_ISOControl set [814_Key] = @w_814_Key
where ISO                                          = @p_ISO

select @w_814_Key                                  = 0

select @w_814_Key                                  = [814_Key]
from RECONEDI_ISOControl (nolock)
where ISO                                         is null                             

if @@ROWCOUNT                                      = 0
begin
   insert into RECONEDI_ISOControl 
   select null,
          0,
		  '19000101',
		  '19000101'
end

insert into dbo.RECONEDI_EDIPending
select distinct a.[814_Key],
                ISO = null,
                esiid,
                UtilityCode                        = z.UtilityCode,
                TdspDuns,
                TdspName,
                TransactionType                    = c.actioncode,
                TransactionStatus                  = a.actioncode,
                Direction,
                ChangeReason,
                ChangeDescription                  = case when ChangeReason = 'TD'
                                                          then ChangeDescription
                                                          else ''
                                                     end,            
                TransactionDate                    = convert(datetime, c.TransactionDate, 101),
                TransactionEffectiveDate           = convert(datetime, case when (c.actioncode = 'E'
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
                @p_ControlDate,
                getdate()
from ISTA_Market.dbo.tbl_814_header c (nolock) 
left join ISTA_Market.dbo.tbl_814_Service a (nolock) 
on a.[814_Key]                                     = c.[814_key]
left join ISTA_Market.dbo.tbl_814_Service_Meter d (nolock) 
on a.Service_key                                   = d.Service_key 
left join ISTA_Market.dbo.tbl_814_Service_Reject e (nolock) 
on e.Service_key                                   = a.Service_key 
left join ISTA_Market.dbo.tbl_814_Service_Account_Change f (nolock)
on a.Service_key                                   = f.Service_key 
left join ISTA_Market.dbo.tbl_814_Service_Status g (nolock)
on a.Service_key                                   = g.Service_key 
left join Libertypower.dbo.Utility z (nolock)
on  TdspDuns                                       = z.DunsNumber
cross apply dbo.ufn_EdiReconAddress(a.[814_key]) b 
where z.WholeSaleMktID                            is null
and   Esiid                                   is not null
and   len(ltrim(rtrim(Esiid)))                     > 0
and   c.Direction                                  = 1
and   c.ActionCode                            not in ('hu')
and  (f.ChangeReason                              is null 
or    f.ChangeReason                              in ('DTM150','DTM151','TD'))
and   a.[814_Key]                                  > @w_814_Key

if @@ROWCOUNT                                     <> 0
begin
/*
   update a set UtilityCode = c.UtilityCode,
                ISO         = 'ERCOT'
   from dbo.RECONEDI_EDIPending a (nolock)
   inner join ERCOT.dbo.AccountInfoAccounts b (nolock) 
   on a.esiid                                     = b.ESIID 
   inner join Libertypower.dbo.Utility c (nolock) 
   on  b.DUNS                                     = c.DunsNumber 
   where a.UtilityCode                           is null
   and   c.InactiveInd                            = 0
*/
   update a set a.UtilityCode = c.UtilityCode,
                a.ISO         = c.WholeSaleMktID
   from dbo.RECONEDI_EDIPending a (nolock)
   inner join Libertypower.dbo.Account b (nolock)  
   on a.esiid                                      = b.AccountNumber
   inner join Libertypower.dbo.Utility c (nolock) 
   on  b.UtilityID                                 = c.ID
   where a.UtilityCode                            is null
   and   c.InactiveInd                             = 0
   and  (select count(*)
         from Libertypower.dbo.Account x (nolock) 
         where x.AccountNumber                     = a.esiid) = 1

   update d set d.UtilityCode = b.UtilityCode,
                d.ISO         = b.WholeSaleMktID
   from libertypower.dbo.Account a (nolock)  
   inner join libertypower.dbo.Utility b (nolock)
   on  a.UtilityID                                 = b.ID
   inner join lp_account.dbo.account_number_history c (nolock)
   on  a.AccountIDLegacy                           = c.Account_ID
   inner join dbo.RECONEDI_EDIPending d (nolock)
   on  c.old_Account_Number                        = d.Esiid
   where d.UtilityCode                            is null
   and   b.InactiveInd                             = 0
   and  (select count(*)
         from Libertypower.dbo.Account x (nolock) 
         where x.AccountNumber                     = d.esiid) = 1
        
   select @w_814_Key                               = case when max(isnull([814_Key], 0)) > @w_814_Key
                                                          then max(isnull([814_Key], 0))
                                                          else @w_814_Key
                                                     end     
   from dbo.RECONEDI_EDIPending (nolock)
   where ISO                                      is null

end 

update dbo.RECONEDI_ISOControl set [814_Key] = @w_814_Key
where ISO                                         is null

/***********************/

insert into dbo.RECONEDI_Tracking
select @p_REHID,
       @p_ISO,
       '',
       'End - EDI Process ',
       getdate(),
       'usp_RECONEDI_EDI'

/***********************/
GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_EDIPending]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_RECONEDI_EDIPending 'ALLEGMD', '20131011', '20131011', '20131011', 'F'
CREATE procedure [dbo].[usp_RECONEDI_EDIPending] 
(@p_Utility                                        varchar(50),
 @p_ProcessDate                                    datetime,
 @p_ControlDate                                    datetime,
 @p_AccountChange                                  datetime,
 @p_Process                                        char(01))
as

/******** AccountChanges ********/

create table #AccountChange
(UtilityCode                                       varchar(50),
 Esiid                                             varchar(50),
 EsiidOld                                          varchar(50))

create index idx_#AccountChange on #AccountChange
(UtilityCode asc,
 EsiidOld asc)

insert into #AccountChange
select distinct
       b.UtilityCode,
       c.new_Account_Number,
       ''
from Libertypower.dbo.Account a (nolock)
inner join libertypower.dbo.Utility b (nolock)
on  a.UtilityID                                    = b.ID
inner join lp_account.dbo.account_number_history c (nolock)
on  a.AccountIDLegacy                              = c.Account_ID
where b.UtilityCode                                = @p_Utility
and   c.date_created                               > @p_AccountChange
and   c.date_created                              <= @p_ProcessDate
--Without Filter
and ((@p_Process                                  in ('T', 'I'))
--Filter
or   (@p_Process                                   = 'F'
and   exists(select null
             from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
             where z.Utility                       = b.UtilityCode
             and   z.AccountNumber                 = a.AccountNumber)))

insert into #AccountChange
select distinct
       c.UtilityCode,
       d.new_Account_Number,
       d.old_Account_Number
from #AccountChange a with (nolock index = idx_#AccountChange)
inner join Libertypower.dbo.Account b (nolock)
on  a.Esiid                                        = b.AccountNumber                                
inner join Libertypower.dbo.Utility c (nolock)
on  b.UtilityID                                    = c.ID
and a.UtilityCode                                  = c.UtilityCode
inner join lp_account..account_number_history d (nolock)
on  b.AccountIDLegacy                              = d.Account_ID
where a.EsiidOld                                   = ''
and   d.date_created                               > @p_AccountChange
and   d.date_created                              <= @p_ProcessDate

/******** Pending Account Transaction ********/

create table #Account
(ID                                                int identity(1, 1) not null,
 UtilityCode                                       varchar(50),
 Esiid                                             varchar(100))

alter table #Account add constraint PK_#Account primary key clustered 
(ID asc)

create index idx_#Account on #Account
(UtilityCode,
 Esiid)
 
if @p_Process                                     in ('F', 'I')
begin
   insert into #Account
   select distinct 
          a.Utility,
          a.AccountNumber
   from dbo.RECONEDI_Filter a (nolock)
   where a.Utility                                 = @p_Utility
   and   not exists(select null
                    from #Account b with (nolock index = idx_#Account)
                    where b.UtilityCode            = a.Utility
                    and   b.Esiid                  = a.AccountNumber)
end
 
insert into #Account
select distinct 
       a.UtilityCode,
       a.Esiid
from dbo.RECONEDI_EDIPending a with (nolock index = idx_RECONEDI_EDIPending)
where a.UtilityCode                                    = @p_Utility
and   not exists(select null
                 from #Account b with (nolock index = idx_#Account)
                 where b.UtilityCode               = a.UtilityCode
                 and   b.Esiid                     = a.Esiid)
--Without Filter
and   ((@p_Process                                in ('T', 'I'))
--Filter
or     (@p_Process                                 = 'F'
and     exists(select null
               from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
               where z.Utility                     = a.UtilityCode
               and   z.AccountNumber               = a.Esiid)))

insert into #Account
select distinct 
       a.UtilityCode,
       a.Esiid
from dbo.RECONEDI_EDIResult a with (nolock index = idx_RECONEDI_EDIResult)
where a.UtilityCode                                = @p_Utility
and  (a.TransactionDateFrom                       >= @p_ProcessDate
or    a.TransactionDateTo                         >= @p_ProcessDate)
and   not exists(select null
                 from #Account b with (nolock index = idx_#Account)
                 where b.UtilityCode               = a.UtilityCode
                 and   b.Esiid                     = a.Esiid)
--Without Filter
and ((@p_Process                                  in ('T', 'I'))
--Filter
or   (@p_Process                                   = 'F'
and   exists(select null
             from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
             where z.Utility                       = a.UtilityCode
             and   z.AccountNumber                 = a.Esiid)))

insert into #Account
select distinct a.UtilityCode,
                a.Esiid
from #AccountChange a with (nolock index = idx_#AccountChange)
where a.EsiidOld                                   = ''
and   not exists(select null
                 from #Account b with (nolock index = idx_#Account)
                 where b.UtilityCode               = a.UtilityCode
                 and   b.Esiid                     = a.Esiid)

insert into #Account
select distinct a.UtilityCode,
                a.Esiid
from #AccountChange a with (nolock index = idx_#AccountChange)
where a.EsiidOld                                  <> ''
and   not exists(select null
                 from #Account b with (nolock index = idx_#Account)
                 where b.UtilityCode               = a.UtilityCode
                 and   b.Esiid                     = a.Esiid)

delete b
from #Account a with (nolock index = idx_#Account)
inner join dbo.RECONEDI_EDIResult b with (nolock index = idx_RECONEDI_EDIResult)
on  a.UtilityCode                                  = b.UtilityCode
and a.Esiid                                        = b.Esiid

/******** Pending EDI Transaction ********/

truncate table dbo.RECONEDI_EDIPending_Work

insert into dbo.RECONEDI_EDIPending_Work
select distinct
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
       b.Origin
from #Account a with (nolock index = idx_#Account)
inner join dbo.RECONEDI_EDI b with (nolock index = idx_RECONEDI_EDI)
on  a.UtilityCode                                  = b.UtilityCode
and a.Esiid                                        = b.Esiid
where substring(a.UtilityCode, 1, 5)              <> 'NSTAR'

insert into dbo.RECONEDI_EDIPending_Work
select distinct
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
       b.Origin
from #Account a with (nolock index = idx_#Account)
inner join dbo.RECONEDI_EDI b with (nolock index = idx_RECONEDI_EDI)
on  substring(a.UtilityCode, 1, 5)                 = substring(b.UtilityCode, 1, 5)
and a.Esiid                                        = b.Esiid
where substring(a.UtilityCode, 1, 5)               = 'NSTAR'

insert into dbo.RECONEDI_EDIPending_Work
select distinct
       b.[814_Key],
       a.Esiid,
       b.UtilityCode,
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
       b.Origin
from #AccountChange a with (nolock index = idx_#AccountChange)
inner join dbo.RECONEDI_EDI b with (nolock index = idx_RECONEDI_EDI)
on  a.UtilityCode                                  = b.UtilityCode
and a.EsiidOld                                     = b.Esiid
where substring(a.UtilityCode, 1, 5)              <> 'NSTAR'
and   a.EsiidOld                                  <> ''

insert into dbo.RECONEDI_EDIPending_Work
select distinct
       b.[814_Key],
       a.Esiid,
       b.UtilityCode,
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
       b.Origin
from #AccountChange a with (nolock index = idx_#AccountChange)
inner join dbo.RECONEDI_EDI b with (nolock index = idx_RECONEDI_EDI)
on  substring(a.UtilityCode, 1, 5)                 = substring(b.UtilityCode, 1, 5)
and a.EsiidOld                                     = b.Esiid
where substring(a.UtilityCode, 1, 5)               = 'NSTAR'
and   a.EsiidOld                                  <> ''

insert into #Account
select distinct a.UtilityCode,
                a.Esiid
from dbo.RECONEDI_EDIPending_Work a with (nolock index = idx_RECONEDI_EDIPending_Work)
where not exists(select null
                 from #Account b with (nolock index = idx_#Account)
                 where b.UtilityCode               = a.UtilityCode
                 and   b.Esiid                     = a.Esiid)

if @p_Process                                      = 'I'
begin
   insert into dbo.RECONEDI_Filter
   select distinct 
          b.WholeSaleMktID,
          a.UtilityCode,
          a.Esiid,
          ''
   from #Account a
   inner join libertypower..Utility b (nolock)
   on  a.UtilityCode                               = b.UtilityCode
   where not exists(select null
                    from dbo.RECONEDI_Filter c (nolock)
                    where c.Utility                = a.UtilityCode
                    and   c.AccountNumber          = a.Esiid)
end

/******** EDI Result ********/

declare @w_Set                                     int
select @w_Set                                      = 5000

declare @w_Rowcount                                int

create table #Pending
(ID                                                int not null,
 UtilityCode                                       varchar(50),
 Esiid                                             varchar(100))

alter table #Pending add constraint PK_#Pending primary key clustered 
(ID asc)

set rowcount @w_Set

insert into #Pending
select distinct a .*
from #Account a with (nolock index = idx_#Account)
where a.UtilityCode                               = @p_Utility
--Without Filter
and ((@p_Process                                  = 'T')
--Filter
or   (@p_Process                                 in ('F', 'I')
and   exists(select null
             from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
             where z.Utility                      = a.UtilityCode
             and   z.AccountNumber                = a.Esiid)))

select @w_Rowcount                                = @@rowcount

while @w_Rowcount                                <> 0
begin

   set rowcount 0

   insert into dbo.RECONEDI_EDIResult
   select b.*,
          @p_ProcessDate,
          @p_ControlDate,
          getdate()
   from #Pending a with (nolock)
   cross apply ufn_RECONEDI_EDIResult (a.UtilityCode, a.Esiid, @p_ProcessDate) b

   delete c
   from #Pending a with (nolock index = PK_#Pending) 
   inner join #Account b with (nolock index = PK_#Account)
   on  a.ID                                         = b.ID
   inner join dbo.RECONEDI_EDIPending c with (nolock index = idx_RECONEDI_EDIPending)
   on  b.UtilityCode                                = c.UtilityCode
   and b.Esiid                                      = c.Esiid

   delete b
   from #Pending a with (nolock index = PK_#Pending) 
   inner join #Account b with (nolock index = PK_#Account)
   on  a.ID                                         = b.ID
   
   truncate table #Pending

   set rowcount @w_Set
   
   insert into #Pending
   select distinct a.*
   from #Account a with (nolock index = idx_#Account)
   where a.UtilityCode                             = @p_Utility
   --Without Filter
   and ((@p_Process                                = 'T')
   --Filter
   or   (@p_Process                               in ('F', 'I')
   and   exists(select null
                from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
                where z.Utility                    = a.UtilityCode
                and   z.AccountNumber              = a.Esiid)))

   select @w_Rowcount                              = @@rowcount
end

set rowcount 0

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_EDI-res]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_RECONEDI_EDI-res]
(@p_ISO                                            varchar(50),
 @p_ProcessDate                                    datetime,
 @p_ControlDate                                    datetime)
as

declare @w_814_Key                                 int
select @w_814_Key                                  = 0

select @w_814_Key                                  = [814_Key]
from RECONEDI_ISOControl (nolock)
where ISO                                          = @p_ISO                             

if @@rowcount                                      = 0
begin
   insert into RECONEDI_ISOControl 
   select @p_ISO,
          0,
		  19000101,
		  19000101
end

--select @w_814_Key                                  = 999999999

if @w_814_Key                                      = 0
begin
   delete dbo.RECONEDI_EDI
   where ISO                                       = @p_ISO

   delete dbo.RECONEDI_EDIPending
   where ISO                                       = @p_ISO

end

if  @w_814_Key                                     = 0
and @p_ISO                                         = 'NYISO'
begin
   insert into dbo.RECONEDI_EDIPending
   select a.*,
          'RISK',
          @p_ControlDate,
          getdate() 
   from ufn_RECONEDI_EDIRisk('NYISO', 'CONED', @p_ProcessDate) a
   left join dbo.RECONEDI_EDIResult b
   on   a.Esiid                                    = b.Esiid
   where b.Esiid                                  is null
   or   (b.Esiid                                  is not null
   and   b.TransactionEffectiveDateTo             is null)
   and   a.TransactionEffectiveDate                < '20070101'

   insert into dbo.RECONEDI_EDIPending
   select *,
          'OLDRECORDS',
          @p_ControlDate,
          getdate() 
   from dbo.ufn_RECONEDI_NYISOOld()
end

if @w_814_Key                                      = 0
begin
   delete a
   from dbo.RECONEDI_EDIResult a (nolock)
   inner join Libertypower.dbo.Utility b (nolock)
   on  a.UtilityCode                               = b.UtilityCode
   where b.WholeSaleMktID                          = @p_ISO
end

insert into dbo.RECONEDI_EDIPending
select distinct a.[814_Key],
                @p_ISO,
                esiid,
                UtilityCode                        = z.UtilityCode,
                TdspDuns,
                TdspName,
                TransactionType                    = c.actioncode,
                TransactionStatus                  = a.actioncode,
                Direction,
                ChangeReason,
                ChangeDescription                  = case when ChangeReason = 'TD'
                                                          then ChangeDescription
                                                          else ''
                                                     end,            
                TransactionDate                    = convert(datetime, c.TransactionDate, 101),
                TransactionEffectiveDate           = convert(datetime, case when (c.actioncode = 'E'
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
                MeterNumber                        = '',
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
                @p_ControlDate,
                getdate()
from ISTA_Market.dbo.tbl_814_header c (nolock) 
left join ISTA_Market.dbo.tbl_814_Service a (nolock) 
on a.[814_Key]                                     = c.[814_key]
left join ISTA_Market.dbo.tbl_814_Service_Meter d (nolock) 
on a.Service_key                                   = d.Service_key 
left join ISTA_Market.dbo.tbl_814_Service_Reject e (nolock) 
on e.Service_key                                   = a.Service_key 
left join ISTA_Market.dbo.tbl_814_Service_Account_Change f (nolock)
on a.Service_key                                   = f.Service_key 
left join ISTA_Market.dbo.tbl_814_Service_Status g (nolock)
on a.Service_key                                   = g.Service_key 
left join Libertypower.dbo.Utility z (nolock)
on  TdspDuns                                       = z.DunsNumber
cross apply dbo.ufn_RECONEDI_EDI(a.[814_key]) b 
where z.WholeSaleMktID                             = @p_ISO
and   z.InactiveInd                                = 0
and   Esiid                                   is not null
and   len(ltrim(rtrim(Esiid)))                     > 0
and   c.Direction                                  = 1
and   c.ActionCode                            not in ('hu')
and  (f.ChangeReason                              is null 
or    f.ChangeReason                              in ('DTM150','DTM151','TD'))
and   a.[814_Key]                                  > @w_814_Key

if @@ROWCOUNT                                     <> 0
begin

   select @w_814_Key                               = max(isnull([814_Key], 0))
   from dbo.RECONEDI_EDIPending (nolock)
   where ISO                                       = @p_ISO

   insert into dbo.RECONEDI_EDI
   select distinct a.* 
   from dbo.RECONEDI_EDIPending a with (nolock index = idx1_RECONEDI_EDIPending)
   where a.ISO                                       = @p_ISO
   and   a.ControlDate                               = @p_ControlDate
end

update dbo.RECONEDI_ISOControl set [814_Key] = @w_814_Key
where ISO                                          = @p_ISO

select @w_814_Key                                  = 0

select @w_814_Key                                  = [814_Key]
from RECONEDI_ISOControl (nolock)
where ISO                                         is null                             

--select @w_814_Key                                  = 999999999

if @@ROWCOUNT                                      = 0
begin
   delete dbo.RECONEDI_EDI
   where ISO                                      is null

   delete dbo.RECONEDI_EDIPending
   where ISO                                      is null

   insert into RECONEDI_ISOControl 
   select null,
          0,
		  19000101,
		  19000101
end

insert into dbo.RECONEDI_EDIPending
select distinct a.[814_Key],
                ISO = null,
                esiid,
                UtilityCode                        = z.UtilityCode,
                TdspDuns,
                TdspName,
                TransactionType                    = c.actioncode,
                TransactionStatus                  = a.actioncode,
                Direction,
                ChangeReason,
                ChangeDescription                  = case when ChangeReason = 'TD'
                                                          then ChangeDescription
                                                          else ''
                                                     end,            
                TransactionDate                    = convert(datetime, c.TransactionDate, 101),
                TransactionEffectiveDate           = convert(datetime, case when (c.actioncode = 'E'
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
                @p_ControlDate,
                getdate()
from ISTA_Market.dbo.tbl_814_header c (nolock) 
left join ISTA_Market.dbo.tbl_814_Service a (nolock) 
on a.[814_Key]                                     = c.[814_key]
left join ISTA_Market.dbo.tbl_814_Service_Meter d (nolock) 
on a.Service_key                                   = d.Service_key 
left join ISTA_Market.dbo.tbl_814_Service_Reject e (nolock) 
on e.Service_key                                   = a.Service_key 
left join ISTA_Market.dbo.tbl_814_Service_Account_Change f (nolock)
on a.Service_key                                   = f.Service_key 
left join ISTA_Market.dbo.tbl_814_Service_Status g (nolock)
on a.Service_key                                   = g.Service_key 
left join Libertypower.dbo.Utility z (nolock)
on  TdspDuns                                       = z.DunsNumber
cross apply dbo.ufn_EdiReconAddress(a.[814_key]) b 
where z.WholeSaleMktID                            is null
and   Esiid                                   is not null
and   len(ltrim(rtrim(Esiid)))                     > 0
and   c.Direction                                  = 1
and   c.ActionCode                            not in ('hu')
and  (f.ChangeReason                              is null 
or    f.ChangeReason                              in ('DTM150','DTM151','TD'))
and   a.[814_Key]                                  > @w_814_Key

if @@ROWCOUNT                                     <> 0
begin
/*
   update a set UtilityCode = c.UtilityCode,
                ISO         = 'ERCOT'
   from dbo.RECONEDI_EDIPending a (nolock)
   inner join ERCOT.dbo.AccountInfoAccounts b (nolock) 
   on a.esiid                                     = b.ESIID 
   inner join Libertypower.dbo.Utility c (nolock) 
   on  b.DUNS                                     = c.DunsNumber 
   where a.UtilityCode                           is null
   and   c.InactiveInd                            = 0
*/
   update a set a.UtilityCode = c.UtilityCode,
                a.ISO         = c.WholeSaleMktID
   from dbo.RECONEDI_EDIPending a (nolock)
   inner join Libertypower.dbo.Account b (nolock)  
   on a.esiid                                      = b.AccountNumber
   inner join Libertypower.dbo.Utility c (nolock) 
   on  b.UtilityID                                 = c.ID
   where a.UtilityCode                            is null
   and   c.InactiveInd                             = 0
   and  (select count(*)
         from Libertypower.dbo.Account x (nolock) 
         where x.AccountNumber                     = a.esiid) = 1

   update d set d.UtilityCode = b.UtilityCode,
                d.ISO         = b.WholeSaleMktID
   from libertypower.dbo.Account a (nolock)  
   inner join libertypower.dbo.Utility b (nolock)
   on  a.UtilityID                                 = b.ID
   inner join lp_account.dbo.account_number_history c (nolock)
   on  a.AccountIDLegacy                           = c.Account_ID
   inner join dbo.RECONEDI_EDIPending d (nolock)
   on  c.old_Account_Number                        = d.Esiid
   where d.UtilityCode                            is null
   and   b.InactiveInd                             = 0
   and  (select count(*)
         from Libertypower.dbo.Account x (nolock) 
         where x.AccountNumber                     = d.esiid) = 1
         
   select @w_814_Key                               = case when max(isnull([814_Key], 0)) > @w_814_Key
                                                          then max(isnull([814_Key], 0))
                                                          else @w_814_Key
                                                     end     
   from dbo.RECONEDI_EDIPending (nolock)
   where ISO                                      is null

   insert into dbo.RECONEDI_EDI
   select distinct * 
   from dbo.RECONEDI_EDIPending with (nolock index = idx1_RECONEDI_EDIPending)
   where ISO                                      is null
   and   ControlDate                               = @p_ControlDate

end 

update dbo.RECONEDI_ISOControl set [814_Key] = @w_814_Key
where ISO                                         is null

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_Enrollment]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_RECONEDI_Enrollment 'CAISO', '*', '20140312', '20140312', 'FIXED', '20140312', 'I'
CREATE procedure [dbo].[usp_RECONEDI_Enrollment]
(@p_ISO                                            varchar(50),
 @p_ProcessType                                    varchar(50),
 @p_ProcessDate                                    datetime,
 @p_SubmitDate                                     datetime,
 @p_ProductCategory                                varchar(50),
 @p_ControlDate                                    datetime,
 @p_Process                                        char(01),
 @p_REHID                                          bigint)
as

/***********************/

update dbo.RECONEDI_Header set STID = 2,
                               Notes = ''
where REHID                                        = @p_REHID                            

insert into dbo.RECONEDI_Tracking
select @p_REHID,
       @p_ISO,
       '',
       'Start - Enrollment Process ',
       getdate(),
       'usp_RECONEDI_Enrollment'

/***********************/

/******** Utility ********/

declare @Utility table                        
(Utility                                           varchar(50) primary key clustered)


if @p_Process                                      = 'F'
begin
   insert into @Utility
   select distinct Utility
   from dbo.RECONEDI_Filter (nolock)
   where ISO                                       = @p_ISO
end

if @p_Process                                     in ('T', 'I')
begin

   insert into @Utility
   select distinct UtilityCode
   from Libertypower.dbo.Utility with (nolock)
   where InactiveInd = 0
   and   WholeSaleMktID                            = @p_ISO
end

create table #Incremental
(AccountID                                         int,
 ContractID                                        int,
 Term                                              int,
 Action                                            char(01))

create index idx_#Incremental on #Incremental
(AccountID,
 ContractID,
 Term,
 Action)

/******** #Enrollment ********/

create table #Enrollment
(ENID                                              int identity (1, 1),
 ProcessType                                       varchar(50),
 ISO                                               varchar(50),
 AccountID                                         int,
 AccountType                                       varchar(50),
 AccountLegacyID                                   char(12),
 Utility                                           varchar(50),
 UtilityID                                         int,
 AccountNumber                                     varchar(50),
 ContractID                                        int,
 ContractNumber                                    varchar(50),
 Term                                              int,
 Status                                            varchar(15),
 SubStatus                                         varchar(15),
 BeginDate                                         datetime,
 EndDate                                           datetime,
 ContractStartDate                                 datetime,
 ContractEndDate                                   datetime,
 ContractRateStart                                 datetime,
 ContractRateEnd                                   datetime,
 LastServiceStartDate                              datetime,
 LastServiceEndDate                                datetime,
 ServiceStartDate                                  datetime,
 ServiceEndDate                                    datetime,
 CriteriaStartDate                                 datetime,
 CriteriaEndDate                                   datetime,
 CriteriaStatus                                    varchar(20),
 SubmitDate                                        datetime,
 Zone                                              varchar(50),
 ContractStatusID                                  int,
 ProductID                                         varchar(20),
 ProductCategory                                   varchar(20),
 ProductSubCategory                                varchar(50),
 RateID                                            int,
 Rate                                              float,
 IsContractedRate                                  int,
 PricingRequestID                                  varchar(50),
 BackToBack                                        int,
 AnnualUsage                                       int,
 InvoiceID                                         varchar(100),
 InvoiceFromDate                                   datetime,
 InvoiceToDate                                     datetime,
 OverlapType                                       char(1),
 OverlapDays                                       int)

alter table #Enrollment add constraint PK_#Enrollment primary key clustered 
(ENID asc)

create index idx_#Enrollment on #Enrollment
(AccountID,
 ContractID)

if @p_ProductCategory                              = 'FIXED'
begin
   goto FIXED
end

/******** Variable ********/

--Max Variable 0

create table #VariableRateEnd_0
(AccountID                                         int,
 RateEnd                                           datetime)

create index idx_#VariableRateEnd_0 on #VariableRateEnd_0
(AccountID asc)


insert into #VariableRateEnd_0
select a.AccountID,
       RateEnd                                     = MAX(m.RateEnd)
from LibertyPower.dbo.Account a with (nolock) 
inner join Libertypower.dbo.Utility b with (nolock) 
on  a.UtilityID                                    = b.ID
inner join Libertypower.dbo.AccountContract i with (nolock)
on  a.AccountID                                    = i.AccountID  
inner join Libertypower.dbo.Contract j with (nolock)
on  i.ContractID                                   = j.ContractID
inner join Libertypower.dbo.AccountContractRate m with (nolock) 
on  i.AccountContractID                            = m.AccountContractID
inner join lp_common.dbo.common_product n with (nolock)
on  m.LegacyProductID                              = n.Product_id
inner join @Utility o
on  b.UtilityCode                                  = o.Utility
where b.InactiveInd                                = 0
and   n.Product_Category                           = 'VARIABLE'
and   m.IsContractedRate                           = 0
and   m.DateCreated                               <= @p_ProcessDate
--Without Filter
and ((@p_Process                                   = 'T')
--Filter
or   (@p_Process                                   = 'F'
and   exists(select null
             from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
             where z.Utility                       = b.UtilityCode
             and   z.AccountNumber                 = a.AccountNumber)))
group by a.AccountID

--Max Variable 1

create table #VariableRateEnd_1
(AccountID                                         int,
 RateEnd                                           datetime)

create index idx_#VariableRateEnd_1 on #VariableRateEnd_1
(AccountID asc)

insert into #VariableRateEnd_1
select a.AccountID,
       RateEnd                                     = MAX(m.RateEnd)
from LibertyPower.dbo.Account a with (nolock) 
inner join Libertypower.dbo.Utility b with (nolock) 
on  a.UtilityID                                    = b.ID
inner join Libertypower.dbo.AccountContract i with (nolock)
on  a.AccountID                                    = i.AccountID  
inner join Libertypower.dbo.Contract j with (nolock)
on  i.ContractID                                   = j.ContractID
inner join Libertypower.dbo.AccountContractRate m with (nolock) 
on  i.AccountContractID                            = m.AccountContractID
inner join lp_common.dbo.common_product n with (nolock)
on  m.LegacyProductID                              = n.Product_id
inner join @Utility o
on  b.UtilityCode                                  = o.Utility
inner join #VariableRateEnd_0 x with (nolock index = idx_#VariableRateEnd_0)
on  a.AccountID                                    = x.AccountID
where b.InactiveInd                                = 0
and   j.ContractStatusID                          in (1, 3)
and   m.IsContractedRate                           = 1
and   j.SubmitDate                                <= @p_SubmitDate
group by a.AccountID

--Variable 0 Contracts

create table #Variable_0
(AccountID                                         int,
 ContractID                                        int,
 RateStart                                         datetime,
 RateEnd                                           datetime)

create index idx_#Variable_0 on #Variable_0 
(AccountID asc,
 ContractID asc,
 RateStart asc,
 RateEnd asc)

insert into #Variable_0
select distinct
       a.AccountID,
       i.ContractID,
       m.RateStart,
       m.RateEnd
from #VariableRateEnd_0 x (nolock)
inner join LibertyPower.dbo.Account a with (nolock) 
on  x.AccountID                                    = a.AccountID
inner join Libertypower.dbo.Utility b with (nolock) 
on  a.UtilityID                                    = b.ID
inner join Libertypower.dbo.AccountContract i with (nolock)
on  a.AccountID                                    = i.AccountID  
inner join Libertypower.dbo.Contract j with (nolock)
on  i.ContractID                                   = j.ContractID
inner join Libertypower.dbo.AccountContractRate m with (nolock) 
on  i.AccountContractID                            = m.AccountContractID
and x.RateEnd                                      = m.RateEnd
inner join lp_common.dbo.common_product n with (nolock)
on  m.LegacyProductID                              = n.Product_id
inner join @Utility o
on  b.UtilityCode                                  = o.Utility
where b.InactiveInd                                = 0
and   n.Product_Category                           = 'VARIABLE'
and   m.IsContractedRate                           = 0

--Variable 1 Contracts

create table #Variable_1
(AccountID                                         int,
 RateStart                                         datetime,
 RateEnd                                           datetime)

create index idx_#Variable_1 on #Variable_1
(AccountID asc)

insert into #Variable_1
select distinct
       a.AccountID,
       m.RateStart,
       m.RateEnd
from #VariableRateEnd_1 x (nolock)
inner join LibertyPower.dbo.Account a with (nolock) 
on  x.AccountID                                    = a.AccountID
inner join Libertypower.dbo.Utility b with (nolock) 
on  a.UtilityID                                    = b.ID
inner join Libertypower.dbo.AccountContract i with (nolock)
on  a.AccountID                                    = i.AccountID  
inner join Libertypower.dbo.Contract j with (nolock)
on  i.ContractID                                   = j.ContractID
inner join Libertypower.dbo.AccountContractRate m with (nolock) 
on  i.AccountContractID                            = m.AccountContractID
and x.RateEnd                                      = m.RateEnd
inner join lp_common.dbo.common_product n with (nolock)
on  m.LegacyProductID                              = n.Product_id
inner join @Utility o
on  b.UtilityCode                                  = o.Utility
where b.InactiveInd                                = 0
and   j.ContractStatusID                          in (1, 3)
and   m.IsContractedRate                           = 1
and   j.SubmitDate                                <= @p_SubmitDate

--Delete Variable O VS Variable 1

delete a
from #Variable_0 a with (nolock index = idx_#Variable_0)
where exists(select null
             from #Variable_1 b with (nolock index = idx_#Variable_1)
             where b.AccountID                     = a.AccountID
             and ((b.RateStart                     > a.RateEnd
             and   a.RateEnd                       < @p_ProcessDate)
             or   (b.RateStart                    >= a.RateStart
             and   b.RateStart                     < a.RateEnd)
             or   (b.RateEnd                       > a.RateStart
             and   b.RateEnd                       > @p_ProcessDate
             and   b.RateEnd                      <= a.RateEnd)
             or   (a.RateStart                    >= b.RateStart
             and   b.RateEnd                       > @p_ProcessDate
             and   a.RateStart                     < b.RateEnd)
             or   (a.RateEnd                      >= b.RateStart
             and   b.RateEnd                       > @p_ProcessDate
             and   a.RateEnd                      <= b.RateEnd)))  

--/--

insert into #Enrollment
select distinct
       ProcessType,
       a.ISO,
       a.AccountID,
       a.AccountType,
       a.AccountIdLegacy,
       a.Utility,
       a.UtilityID,
       a.AccountNumber,
       a.ContractID,
       a.ContractNumber,
       a.Term,
       a.Status,
       a.SubStatus,
       a.BeginDate,
       a.EndDate,
       a.ContractStartDate,
       a.ContractEndDate,
       a.ContractRateStart,
       a.ContractRateEnd,
       a.LastServiceStartDate,
       a.LastServiceEndDate,
       ServiceStartDate                            = null,
       ServiceEndDate                              = null,
       CriteriaStartDate                           = null,
       CriteriaEndDate                             = null,
       CriteriaStatus                              = null,
       a.SubmitDate,
       a.Zone,
       a.ContractStatusID,
       a.ProductID,
       a.ProductCategory,
       a.ProductSubCategory,
       a.RateID,
       a.Rate,
       a.IsContractedRate,
       a.PricingRequestID,
       a.BackToBack,
       AnnualUsage                                 = null,
       InvoiceID                                   = null,
       InvoiceFromDate                             = null,
       InvoiceToDate                               = null,
       OverlapType                                 = null,
       OverlapDays                                 = null
from (select distinct
             ProcessType                           = 'VARIABLE',
             ISO                                   = b.WholeSaleMktID,
             a.AccountID,
             a.AccountIdLegacy,
             y.AccountType,
             a.UtilityID,
             Utility                               = b.UtilityCode,
             a.AccountNumber,
             j.ContractID,
             ContractNumber                        = j.Number,
             m.Term,
             k.Status,
             k.SubStatus,
             BeginDate                             = m.RateStart,
             EndDate                               = case when ((k.Status    = '911000'
                                                          and    k.SubStatus = '10')
                                                          or    (k.Status    = '11000'
                                                          and    k.SubStatus = '10'))
                                                          then e.EndDate
                                                          when k.Status    = '999998'
                                                          and  k.SubStatus = '10'
                                                          then m.RateStart
                                                          else m.RateEnd
                                                     end,
             ContractStartDate                     = j.StartDate,
             ContractEndDate                       = j.EndDate,
             ContractRateStart                     = m.RateStart,
             ContractRateEnd                       = m.RateEnd,
             LastServiceStartDate                  = e.StartDate,
             LastServiceEndDate                    = e.EndDate,
             j.SubmitDate,
             a.Zone,
             j.ContractStatusID,
             ProductID                             = n.Product_id,
             ProductCategory                       = n.Product_category,
             ProductSubCategory                    = n.product_sub_category,
             m.RateID,
             m.Rate,
             m.IsContractedRate,                   
             PricingRequestID                      = p.pricing_request_id,
             o.BackToBack
      from LibertyPower.dbo.Account a with (nolock) 
      inner join Libertypower.dbo.AccountType y (nolock)  
      on  a.AccountTypeID                          = y.ID
      inner join Libertypower.dbo.Utility b with (nolock) 
      on  a.UtilityID                              = b.ID
      left join Libertypower.dbo.AccountLatestService e with (nolock)
      on a.AccountID                               = e.AccountID
      inner join Libertypower.dbo.Customer f with (nolock)
      on a.CustomerID                              = f.CustomerID
      inner join Libertypower.dbo.AccountContract i with (nolock)
      on  a.AccountID                              = i.AccountID  
      inner join Libertypower.dbo.Contract j with (nolock)
      on i.ContractID                              = j.ContractID
      inner join Libertypower.dbo.AccountStatus k with (nolock)
      on i.AccountContractID                       = k.AccountContractID
      inner join Libertypower.dbo.AccountContractRate m with (nolock) 
      on i.AccountContractID                       = m.AccountContractID
      inner join lp_common.dbo.common_product n with (nolock)
      on m.LegacyProductID                         = n.Product_id
      left join lp_deal_capture.dbo.deal_pricing_detail o with (NOLOCK)
      on  n.Product_id                             = o.Product_id
      and m.RateID                                 = o.Rate_ID
      left join lp_deal_capture.dbo.deal_pricing p with (NOLOCK)
      on  o.deal_pricing_id                        = p.deal_pricing_id 
      inner join @Utility r
      on  b.UtilityCode                            = r.Utility
--Variable 1
      where  b.InactiveInd                         = 0
      and    n.Product_Category                    = 'VARIABLE'
      and  ((j.ContractStatusID                   in (1, 3)
      and    m.RateEnd                             > @p_ProcessDate
      and    m.IsContractedRate                    = 1)
--Variable 0      
      or    (exists (select null
                     from #Variable_0 x
                     where x.AccountID             = a.AccountID
                     and   x.ContractID            = i.ContractID
                     and   x.RateStart             = m.RateStart
                     and   x.RateEnd               = m.RateEnd)
      and    m.IsContractedRate                    = 0))
--Without Filter
      and ((@p_Process                        = 'T')
--Filter
      or   (@p_Process                        = 'F'
      and   exists(select null
                   from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
                   where z.Utility                 = b.UtilityCode
                   and   z.AccountNumber           = a.AccountNumber)))) a
order by a.Utility,
         a.AccountID,
         a.AccountNumber,
         a.ContractID,
         a.ContractRateStart,
         a.SubmitDate

goto INVOICE

/******** Fixed ********/

FIXED:

insert into #Enrollment
select distinct
       ProcessType,
       a.ISO,
       a.AccountID,
       a.AccountType,
       a.AccountIdLegacy,
       a.Utility,
       a.UtilityID,
       a.AccountNumber,
       a.ContractID,
       a.ContractNumber,
       a.Term,
       a.Status,
       a.SubStatus,
       a.BeginDate,
       a.EndDate,
       a.ContractStartDate,
       a.ContractEndDate,
       a.ContractRateStart,
       a.ContractRateEnd,
       a.LastServiceStartDate,
       a.LastServiceEndDate,
       ServiceStartDate                            = null,
       ServiceEndDate                              = null,
       CriteriaStartDate                           = null,
       CriteriaEndDate                             = null,
       CriteriaStatus                              = null,
       a.SubmitDate,
       a.Zone,
       a.ContractStatusID,
       a.ProductID,
       a.ProductCategory,
       a.ProductSubCategory,
       a.RateID,
       a.Rate,
       a.IsContractedRate,
       a.PricingRequestID,
       a.BackToBack,
       AnnualUsage                                 = null,
       InvoiceID                                   = null,
       InvoiceFromDate                             = null,
       InvoiceToDate                               = null,
       OverlapType                                 = null,
       OverlapDays                                 = null
from (select distinct
             ProcessType                           = case when p.pricing_request_id is not null
                                                          and  len(rtrim(ltrim(p.pricing_request_id))) > 0
                                                          then 'CUSTOM'
                                                          else 'DAILY'
                                                     end,
             ISO                                   = b.WholeSaleMktID,
             a.AccountID,
             a.AccountIdLegacy,
             y.AccountType,
             a.UtilityID,
             Utility                               = b.UtilityCode,
             a.AccountNumber,
             j.ContractID,
             ContractNumber                        = j.Number,
             m.Term,
             k.Status,
             k.SubStatus,
             BeginDate                             = m.RateStart,
             EndDate                               = case when ((k.Status    = '911000'
                                                          and    k.SubStatus = '10')
                                                          or    (k.Status    = '11000'
                                                          and    k.SubStatus = '10'))
                                                          then e.EndDate
                                                          when k.Status    = '999998'
                                                          and  k.SubStatus = '10'
                                                          then m.RateStart
                                                          else m.RateEnd
                                                     end,
             ContractStartDate                     = j.StartDate,
             ContractEndDate                       = j.EndDate,
             ContractRateStart                     = m.RateStart,
             ContractRateEnd                       = m.RateEnd,
             LastServiceStartDate                  = e.StartDate,
             LastServiceEndDate                    = e.EndDate,
             j.SubmitDate,
             a.Zone,
             j.ContractStatusID,
             ProductID                             = n.Product_id,
             ProductCategory                       = n.Product_category,
             ProductSubCategory                    = n.product_sub_category,
             m.RateID,
             m.Rate,
             m.IsContractedRate,                   
             PricingRequestID                      = p.pricing_request_id,
             o.BackToBack
      from LibertyPower.dbo.Account a with (nolock) 
      inner join Libertypower.dbo.AccountType y (nolock)  
      on  a.AccountTypeID                          = y.ID
      inner join Libertypower.dbo.Utility b with (nolock) 
      on  a.UtilityID                              = b.ID
      left join Libertypower.dbo.AccountLatestService e with (nolock)
      on a.AccountID                               = e.AccountID
      inner join Libertypower.dbo.Customer f with (nolock)
      on a.CustomerID                              = f.CustomerID
      inner join Libertypower.dbo.AccountContract i with (nolock)
      on  a.AccountID                              = i.AccountID  
      inner join Libertypower.dbo.Contract j with (nolock)
      on i.ContractID                              = j.ContractID
      inner join Libertypower.dbo.AccountStatus k with (nolock)
      on i.AccountContractID                       = k.AccountContractID
      inner join Libertypower.dbo.AccountContractRate m with (nolock) 
      on i.AccountContractID                       = m.AccountContractID
      inner join lp_common.dbo.common_product n with (nolock)
      on m.LegacyProductID                         = n.Product_id
      left join lp_deal_capture.dbo.deal_pricing_detail o with (NOLOCK)
      on  n.Product_id                             = o.Product_id
      and m.RateID                                 = o.Rate_ID
      left join lp_deal_capture.dbo.deal_pricing p with (NOLOCK)
      on  o.deal_pricing_id                        = p.deal_pricing_id 
      inner join @Utility r
      on  b.UtilityCode                            = r.Utility
      where j.ContractStatusID                    in (1, 3)
      and   b.InactiveInd                          = 0
      and   n.Product_Category                     = 'FIXED'
      and   m.IsContractedRate                     = 1
      and   m.RateEnd                              > CONVERT(char(08), @p_ProcessDate, 112)
      and   j.SubmitDate                           < dateadd(dd, 1, @p_SubmitDate)
--Custom
      and (((@p_ProcessType                        = 'CUSTOM'
      or     @p_ProcessType                        = '*')
      and    (p.pricing_request_id                is not null
      and     len(rtrim(ltrim(p.pricing_request_id))) > 0
      and     n.IsCustom                           = 1))
--Daily
      or   ((@p_ProcessType                        = 'DAILY'
      or     @p_ProcessType                        = '*')
      and    (p.pricing_request_id                is null
      or      len(rtrim(ltrim(p.pricing_request_id))) = 0))) 
--Without Filter
      and ((@p_Process                            in ('I', 'T'))
--Filter
      or   (@p_Process                             = 'F'
      and   exists(select null
                   from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
                   where z.Utility                 = b.UtilityCode
                   and   z.AccountNumber           = a.AccountNumber)))) a
order by a.Utility,
         a.AccountID,
         a.AccountNumber,
         a.ContractID,
         a.ContractRateStart,
         a.SubmitDate

/******** Changes ********/

declare @w_IncrementalDate                         datetime
   
select @w_IncrementalDate                          = getdate()

if @p_Process                                      = 'T'
begin
   truncate table dbo.RECONEDI_Filter 
end

if @p_Process                                      = 'I'
begin

   insert into #Incremental
   select distinct 
          b.AccountID, 
          b.ContractID,
          b.Term,
          'D'
   from @Utility a 
   inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx2_RECONEDI_EnrollmentFixed)
   on  a.Utility                                   = b.Utility
   where not exists (select null
                     from #Enrollment c with (nolock index = idx_#Enrollment)
                     where c.AccountID             = b.AccountID
                     and   c.ContractID            = b.ContractID
                     and   c.Term                  = b.Term)
   
   insert into #Incremental
   select distinct 
          a.AccountID, 
          a.ContractID,
          a.Term,
          'I'
   from #Enrollment a (nolock)
   where not exists (select null
                     from dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx3_RECONEDI_EnrollmentFixed)
                     where b.AccountID             = a.AccountID
                     and   b.ContractID            = a.ContractID
                     and   b.Term                  = a.Term)

   insert into #Incremental
   select distinct 
          a.AccountID, 
          a.ContractID,
          a.Term,
          'E'
   from #Enrollment a (nolock)
   where exists (select null
                 from dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx3_RECONEDI_EnrollmentFixed)
                 where b.AccountID                 = a.AccountID
                 and   b.ContractID                = a.ContractID
                 and   b.Term                      = a.Term
                 and  (b.ContractRateStart        <> a.ContractRateStart
                 or    b.ContractRateEnd          <> a.ContractRateEnd))

   insert into #Incremental
   select distinct 
          a.AccountID, 
          a.ContractID,
          a.Term,
          'U'
   from #Enrollment a (nolock)
   where not exists (select null
                     from #Incremental b with (nolock index = idx_#Incremental) 
                     where b.AccountID             = a.AccountID
                     and   b.ContractID            = a.ContractID
                     and   b.Term                  = a.Term)

   truncate table dbo.RECONEDI_EnrollmentIncremental

   insert into dbo.RECONEDI_EnrollmentIncremental
   select b.ENID,
          b.ProcessType,
          b.ISO,
          b.AccountID,
          b.AccountType,
          b.Utility,
          b.AccountNumber,
          b.ContractID,
          b.ContractNumber,
          b.Term,
          b.Status,
          b.SubStatus,
          b.BeginDate,
          b.EndDate,
          b.ContractStartDate,
          b.ContractEndDate,
          b.ContractRateStart,
          b.ContractRateEnd,
          b.LastServiceStartDate,
          b.LastServiceEndDate,
          b.ServiceStartDate,
          b.ServiceEndDate,
          b.CriteriaStartDate,
          b.CriteriaEndDate,
          b.CriteriaStatus,
          b.SubmitDate,
          b.Zone,
          b.ContractStatusID,
          b.ProductID,
          b.ProductCategory,
          b.ProductSubCategory,
          b.RateID,
          b.Rate,
          b.IsContractedRate,
          b.PricingRequestID,
          b.BackToBack,
          b.AnnualUsage,
          b.InvoiceID,
          b.InvoiceFromDate,
          b.InvoiceToDate,
          b.OverlapType,
          b.OverlapDays,
          ProcessDate                              = @p_ProcessDate,
          ControlDate                              = @p_ControlDate,
          DateProcessed                            = GETDATE(),
          a.Action
   from #Incremental a with (nolock index = idx_#Incremental) 
   inner join #Enrollment b with (nolock index = idx_#Enrollment)
   on  a.AccountID                                 = b.AccountID
   and a.ContractID                                = b.ContractID
   and a.Term                                      = b.Term
   and a.Action                                   in ('I', 'E')

   insert into dbo.RECONEDI_EnrollmentIncremental
   select c.ENID,
          b.ProcessType,
          b.ISO,
          b.AccountID,
          b.AccountType,
          b.Utility,
          b.AccountNumber,
          b.ContractID,
          b.ContractNumber,
          b.Term,
          b.Status,
          b.SubStatus,
          b.BeginDate,
          b.EndDate,
          b.ContractStartDate,
          b.ContractEndDate,
          b.ContractRateStart,
          b.ContractRateEnd,
          b.LastServiceStartDate,
          b.LastServiceEndDate,
          b.ServiceStartDate,
          b.ServiceEndDate,
          b.CriteriaStartDate,
          b.CriteriaEndDate,
          b.CriteriaStatus,
          b.SubmitDate,
          b.Zone,
          b.ContractStatusID,
          b.ProductID,
          b.ProductCategory,
          b.ProductSubCategory,
          b.RateID,
          b.Rate,
          b.IsContractedRate,
          b.PricingRequestID,
          b.BackToBack,
          b.AnnualUsage,
          b.InvoiceID,
          b.InvoiceFromDate,
          b.InvoiceToDate,
          b.OverlapType,
          b.OverlapDays,
          ProcessDate                              = @p_ProcessDate,
          ControlDate                              = @p_ControlDate,
          DateProcessed                            = GETDATE(),
          a.Action
   from #Incremental a with (nolock index = idx_#Incremental) 
   inner join #Enrollment b with (nolock index = idx_#Enrollment)
   on  a.AccountID                                 = b.AccountID
   and a.ContractID                                = b.ContractID
   and a.Term                                      = b.Term
   inner join dbo.RECONEDI_EnrollmentFixed c with (nolock index = idx3_RECONEDI_EnrollmentFixed)
   on  a.AccountID                                 = c.AccountID
   and a.ContractID                                = c.ContractID
   and a.Term                                      = c.Term
   and a.Action                                    = 'U'

   insert into dbo.RECONEDI_EnrollmentIncremental
   select b.ENID,
          b.ProcessType,
          b.ISO,
          b.AccountID,
          b.AccountType,
          b.Utility,
          b.AccountNumber,
          b.ContractID,
          b.ContractNumber,
          b.Term,
          b.Status,
          b.SubStatus,
          b.BeginDate,
          b.EndDate,
          b.ContractStartDate,
          b.ContractEndDate,
          b.ContractRateStart,
          b.ContractRateEnd,
          b.LastServiceStartDate,
          b.LastServiceEndDate,
          b.ServiceStartDate,
          b.ServiceEndDate,
          b.CriteriaStartDate,
          b.CriteriaEndDate,
          b.CriteriaStatus,
          b.SubmitDate,
          b.Zone,
          b.ContractStatusID,
          b.ProductID,
          b.ProductCategory,
          b.ProductSubCategory,
          b.RateID,
          b.Rate,
          b.IsContractedRate,
          b.PricingRequestID,
          b.BackToBack,
          b.AnnualUsage,
          b.InvoiceID,
          b.InvoiceFromDate,
          b.InvoiceToDate,
          b.OverlapType,
          b.OverlapDays,
          ProcessDate                              = @p_ProcessDate,
          ControlDate                              = @p_ControlDate,
          DateProcessed                            = GETDATE(),
          a.Action
   from #Incremental a with (nolock index = idx_#Incremental) 
   inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx3_RECONEDI_EnrollmentFixed)
   on  a.AccountID                                 = b.AccountID
   and a.ContractID                                = b.ContractID
   and a.Term                                      = b.Term
   and a.Action                                    = 'D'

   truncate table dbo.RECONEDI_Filter

   insert into dbo.RECONEDI_Filter
   select distinct
          b.ISO,
          b.Utility,
          b.AccountNumber,
          ''
   from #Incremental a with (nolock index = idx_#Incremental) 
   inner join #Enrollment b with (nolock index = idx_#Enrollment)
   on  a.AccountID                                 = b.AccountID
   and a.ContractID                                = b.ContractID
   and a.Term                                      = b.Term
   and a.Action                                   in ('I', 'E')
end
/******** Invoice ********/

INVOICE:

create table #Invoice
(ISO                                               varchar(50),
 Utility                                           varchar(50),
 AccountNumber                                     varchar(50),
 FromDate                                          datetime,
 ToDate                                            datetime,
 InvoiceID                                         varchar(100))

create clustered index idx_#Invoice on #Invoice
(Utility,
 AccountNumber)
 
insert into #Invoice
select distinct
       x.ISO,
       Utility                                     = x.Utility,
       AccountNumber                               = x.AccountNumber,
       FromDate                                    = b.ServiceFrom,
       ToDate                                      = b.ServiceTo,
	   InvoiceID                                   = b.invoiceID
from (select distinct x.ISO,
                      x.Utility, 
                      x.AccountNumber
      from #Enrollment x (nolock)) x
inner join Ista.dbo.premise a with (NOLOCK) 
on  x.AccountNumber                                = a.PremNo
inner join Ista.dbo.invoice b with (NOLOCK) 
on a.custid                                        = b.custid
inner join Ista.dbo.Consumption c with (NOLOCK) 
on b.invoiceid                                     = c.invoiceid
inner join Ista.dbo.ConsumptionDetail d with (NOLOCK) 
on c.consid                                        = d.consid
inner join lp_common.dbo.common_utility f with (NOLOCK) 
on  x.Utility                                      = f.utility_id
inner join (select x.ISO,
                   Utility                         = x.Utility,
                   AccountNumber                   = x.AccountNumber,
                   ServiceFrom                     = max(b.ServiceFrom)
            from (select distinct x.ISO,
                                  x.Utility, 
                                  x.AccountNumber
                  from #Enrollment x (nolock)) x
            inner join Ista.dbo.premise a with (NOLOCK) 
            on  x.AccountNumber                    = a.PremNo
            inner join Ista.dbo.invoice b with (NOLOCK) 
            on a.custid                            = b.custid
            inner join Ista.dbo.Consumption c with (NOLOCK) 
            on b.invoiceid                         = c.invoiceid
            inner join Ista.dbo.ConsumptionDetail d with (NOLOCK) 
            on c.consid                            = d.consid
            inner join lp_common.dbo.common_utility f with (NOLOCK) 
            on  x.Utility               = f.utility_id
            where d.ConsUnitID                     = 5 
            and   f.inactive_ind                   = 0 
            group by x.ISO,
                     x.Utility,
                     x.AccountNumber) z
on  x.ISO                                          = z.ISO
and x.Utility                                      = z.Utility
and x.AccountNumber                                = z.AccountNumber
and b.ServiceFrom                                  = z.ServiceFrom
where d.ConsUnitID                                 = 5 
and   f.inactive_ind                               = 0

-- Invoice Old Accountid

insert into #Invoice
select distinct
       x.ISO,
       Utility                                     = x.Utility,
       AccountNumber                               = x.AccountNumber,
       FromDate                                    = b.ServiceFrom,
	   ToDate                                      = b.ServiceTo,
	   InvoiceID                                   = b.invoiceID
from (select distinct x.ISO,
                      x.Utility, 
                      x.AccountNumber, 
                      c.old_account_number
      from #Invoice x (nolock)
      inner join Libertypower.dbo.Account a with (nolock)
      on  x.AccountNumber                          = a.AccountNumber
      inner join Libertypower.dbo.Utility b with (nolock)
      on  x.Utility                                = b.UtilityCode
      and a.UtilityID                              = b.ID
      inner join lp_account.dbo.account_number_history c with (nolock)
      on  a.AccountIDLegacy                        = c.Account_ID) x
inner join Ista.dbo.premise a with (NOLOCK) 
on  x.old_account_number                           = a.PremNo
inner join Ista.dbo.invoice b with (NOLOCK) 
on a.custid                                        = b.custid
inner join Ista.dbo.Consumption c with (NOLOCK) 
on b.invoiceid                                     = c.invoiceid
inner join Ista.dbo.ConsumptionDetail d with (NOLOCK) 
on c.consid                                        = d.consid
inner join lp_common.dbo.common_utility f with (NOLOCK) 
on  x.Utility                                      = f.utility_id
inner join (select x.ISO,
                   Utility                         = x.Utility,
                   AccountNumber                   = x.AccountNumber,
                   ServiceFrom                     = max(b.ServiceFrom)
            from (select distinct x.ISO,
                                  x.Utility, 
                                  x.AccountNumber, 
                                  c.old_account_number
                  from #Enrollment x (nolock)
                  inner join Libertypower.dbo.Account a with (nolock)
                  on  x.AccountNumber              = a.AccountNumber
                  inner join Libertypower.dbo.Utility b with (nolock)
                  on  x.Utility                    = b.UtilityCode
                  and a.UtilityID                  = b.ID
                  inner join lp_account.dbo.account_number_history c with (nolock)
                  on  a.AccountIDLegacy            = c.Account_ID) x
            inner join Ista.dbo.premise a with (NOLOCK)
            on  x.old_account_number               = a.PremNo
            inner join Ista.dbo.invoice b with (NOLOCK) 
            on a.custid                            = b.custid
            inner join Ista.dbo.Consumption c with (NOLOCK) 
            on b.invoiceid                         = c.invoiceid
            inner join Ista.dbo.ConsumptionDetail d with (NOLOCK) 
            on c.consid                            = d.consid
            inner join lp_common.dbo.common_utility f with (NOLOCK) 
            on  x.Utility                          = f.utility_id
            where d.ConsUnitID                     = 5 
            and   f.inactive_ind                   = 0 
            group by x.ISO,
                     x.Utility,
                     x.AccountNumber) z
on  x.ISO                                          = z.ISO
and x.Utility                                      = z.Utility
and x.AccountNumber                                = z.AccountNumber
and b.ServiceFrom                                  = z.ServiceFrom
where d.ConsUnitID                                 = 5 
and   f.inactive_ind                               = 0
and   not exists(select null
                 from #Invoice z (nolock)
                 where z.Utility                   = x.Utility
                 and   z.AccountNumber             = x.AccountNumber)

/******** Temporal Accounts ********/

create table #Account
(AccountID                                         int not null,
 AccountIdLegacy                                   char(12))
 
alter table #Account add constraint PK_#Account primary key clustered 
(AccountID asc)

insert into #Account
select distinct a.AccountID,
                a.AccountLegacyID
from #Enrollment a with (nolock)

/******** Services Dates ********/

create table #Services
(AccountID                                         int not null,
 ServiceStartDate                                  Datetime,
 ServiceEndDate                                    Datetime)
 
alter table #Services add constraint PK_#Services primary key clustered 
(AccountID asc)
 
insert into #Services
select a.AccountID,
       a.ServiceStartDate,
       a.ServiceEndDate
from(select a.AccountID,
            ServiceStartDate                       = max(isnull(b.StartDate, '19000101')),
            ServiceEndDate                         = max(isnull(b.EndDate, '19000101'))
     from #Account a with (nolock index = PK_#Account) 
     inner join Libertypower.dbo.AccountService b with (nolock)
     on  a.AccountIdLegacy                         = b.account_id
     group by a.AccountID) a

/******** Annual Usages ********/

create table #AnnualUsages
(AccountID                                         int not null,
 AnnualUsage                                       int)

alter table #AnnualUsages add constraint PK_#AnnualUsages primary key clustered 
(AccountID asc)

insert into #AnnualUsages
select a.AccountID,
       a.AnnualUsage
from (select a.AccountID,
             a.AnnualUsage
      from Libertypower.dbo.AccountUsage a with (nolock)
      inner join (select a.AccountID,
                         MaxEffectiveDate          = max(b.EffectiveDate)
                  from #Account a with (nolock index = PK_#Account)
                  inner join Libertypower.dbo.AccountUsage b with (nolock)
                  on  a.AccountID                  = b.AccountID
                  group by a.AccountID) b
      on  a.AccountID                              = b.AccountID
      and a.EffectiveDate                          = b.MaxEffectiveDate) a                

/******** Enrollment Header ********/

update #Enrollment set CriteriaStartDate = case when (len(ltrim(rtrim(LastServiceEndDate ))) = 0
                                                or    LastServiceEndDate                  is null
                                                or    LastServiceEndDate                     = '19000101')
                                                and  ContractRateEnd                         > CONVERT(char(08), @p_ProcessDate, 112)
                                                then ContractRateStart
                                                else case when LastServiceEndDate           <= ContractRateEnd
                                                          and  LastServiceEndDate            > CONVERT(char(08), @p_ProcessDate, 112)
                                                          and  LastServiceEndDate            > ContractRateStart
                                                          then ContractRateStart
                                                          when LastServiceEndDate           <= LastServiceStartDate
                                                          and  ContractRateEnd               > LastServiceStartDate
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_ProcessDate, 112)
                                                          then LastServiceStartDate
                                                          when ContractRateStart            >= LastServiceEndDate
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_ProcessDate, 112)
                                                          then ContractRateStart
                                                          when LastServiceEndDate            > ContractRateEnd
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_ProcessDate, 112)                  
                                                          then ContractRateStart
                                                          else null
                                                     end
                                           end,
                       CriteriaEndDate   = case when (len(ltrim(rtrim(LastServiceEndDate ))) = 0
                                                or    LastServiceEndDate                  is null
                                                or    LastServiceEndDate                     = '19000101')
                                                and  ContractRateEnd                         > CONVERT(char(08), @p_ProcessDate, 112)
                                                then ContractRateEnd
                                                else case when LastServiceEndDate           <= ContractRateEnd
                                                          and  LastServiceEndDate            > CONVERT(char(08), @p_ProcessDate, 112)
                                                          and  LastServiceEndDate            > ContractRateStart
                                                          then ContractRateEnd
                                                          when LastServiceEndDate           <= LastServiceStartDate
                                                          and  ContractRateEnd               > LastServiceStartDate
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_ProcessDate, 112)
                                                          then LastServiceEndDate
                                                          when ContractRateStart            >= LastServiceEndDate
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_ProcessDate, 112)
                                                          then ContractRateEnd
                                                          when LastServiceEndDate            > ContractRateEnd
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_ProcessDate, 112)                  
                                                          then ContractRateEnd
                                                          else null
                                                     end
                                           end,
                       CriteriaStatus    = case when (len(ltrim(rtrim(LastServiceEndDate ))) = 0
                                                or    LastServiceEndDate                  is null
                                                or    LastServiceEndDate                     = '19000101')
                                                and  ContractRateEnd                         > CONVERT(char(08), @p_ProcessDate, 112)
                                                then 'ACTIVE'
                                                else case when LastServiceEndDate           <= ContractRateEnd
                                                          and  LastServiceEndDate            > CONVERT(char(08), @p_ProcessDate, 112)
                                                          and  LastServiceEndDate            > ContractRateStart
                                                          then 'ACTIVE'
                                                          when LastServiceEndDate           <= LastServiceStartDate
                                                          and  ContractRateEnd               > LastServiceStartDate
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_ProcessDate, 112)
                                                          then 'ACTIVE'
                                                          when ContractRateStart            >= LastServiceEndDate
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_ProcessDate, 112)
                                                          then 'ACTIVE'
                                                          when LastServiceEndDate            > ContractRateEnd
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_ProcessDate, 112)                  
                                                          then 'ACTIVE'
                                                          else 'INACTIVE'
                                                     end
                                           end

/******** Forecast Header - Invoice ********/

update a set InvoiceID        = b.InvoiceID,
	         InvoiceFromDate  = b.FromDate,
	         InvoiceToDate    = b.ToDate
from #Enrollment a with (nolock index = idx_#Enrollment)
inner join #Invoice b with (nolock index = idx_#Invoice)
on  a.Utility                                      = b.Utility
and a.AccountNumber                                = b.AccountNumber

/******** Forecast Header - Services Dates ********/

update a set ServiceStartDate                      = b.ServiceStartDate,
	         ServiceEndDate                        = b.ServiceEndDate
from #Enrollment a with (nolock index = idx_#Enrollment)
inner join #Services b with (nolock index = PK_#Services)
on  a.AccountID                                    = b.AccountID

/******** Forecast Header - Annual Usages ********/

update a set AnnualUsage = b.AnnualUsage
from #Enrollment a with (nolock index = idx_#Enrollment)
inner join #AnnualUsages b with (nolock index = PK_#AnnualUsages)
on  a.AccountID                                   = b.AccountID


/******** Expire ********/

create table #Expire
(AccountID                                         int,
 ContractID                                        int,
 Term                                              int)

create index idx_#Expire on #Expire
(AccountID,
 ContractID,
 Term)
 
insert into #Expire
select distinct
       zz.AccountID,
       zz.ContractID,
       zz.Term
from LibertyPower.dbo.Account a with (nolock) 
inner join Libertypower.dbo.Utility b with (nolock)  
on  a.UtilityID                                    = b.ID
inner join Libertypower.dbo.AccountContract i with (nolock)
on  a.AccountID                                    = i.AccountID  
inner join Libertypower.dbo.Contract j with (nolock)
on i.ContractID                                    = j.ContractID
inner join Libertypower.dbo.AccountContractRate m with (nolock) 
on i.AccountContractID                             = m.AccountContractID
inner join lp_common.dbo.common_product n with (nolock)
on m.LegacyProductID                               = n.Product_id
inner join dbo.RECONEDI_EnrollmentFixed zz with (nolock index = idx3_RECONEDI_EnrollmentFixed)
on  a.AccountID                                    = zz.AccountID
where j.ContractStatusID                          in (1, 3)
and   b.InactiveInd                                = 0
and   n.Product_Category                           = 'FIXED'
and   m.IsContractedRate                           = 1
and   m.RateEnd                                   <= CONVERT(char(08), @p_ProcessDate, 112)
and   j.SubmitDate                                 > zz.SubmitDate
and ((zz.ContractRateStart                        >= m.RateStart  
and   zz.ContractRateEnd                          <= m.RateEnd)
or   (zz.ContractRateStart                        >= m.RateStart  
and   zz.ContractRateStart                        <= m.RateEnd)
or   (zz.ContractRateEnd                          >= m.RateStart 
and   zz.ContractRateEnd                          <= m.RateEnd)
or   (zz.ContractRateStart                        <= m.RateStart 
and   zz.ContractRateEnd                          >= m.RateStart))

update a set OverlapType = 'E',
             OverlapDays = null
from #Enrollment a with (nolock index = idx_#Enrollment)
inner join #Expire b with (nolock index = idx_#Expire)
on  a.AccountID                                    = b.AccountID
and a.ContractID                                   = b.ContractID
and a.Term                                         = b.Term

/******** Overlap ********/

create table #OverlapFrom
(ID                                                int identity(1, 1) not null,
 ENID                                              int,
 AccountID                                         int,
 ContractRateStart                                 datetime,
 ContractRateEnd                                   datetime) 

insert into #OverlapFrom
select a.ENID,
       a.AccountID,
       a.ContractRateStart,
       a.ContractRateEnd
from #Enrollment a with (nolock index = idx_#Enrollment)
where not exists(select null
                 from #Expire b with (nolock index = idx_#Expire)
                 where b.AccountID                 = a.AccountID
                 and   b.ContractID                = a.ContractID
                 and   b.Term                      = a.Term)
order by a.AccountID,
         a.SubmitDate,
         a.ContractID

alter table #OverlapFrom add constraint PK_#OverlapFrom primary key clustered 
(ID asc)

create table #OverlapCompare
(ID                                                int identity(0, 1) not null,
 ENID                                              int,
 AccountID                                         int,
 ContractRateStart                                 datetime,
 ContractRateEnd                                   datetime) 

insert into #OverlapCompare
select ENID,
       AccountID,
       ContractRateStart,
       ContractRateEnd
from #OverlapFrom with (nolock)
order by ID

alter table #OverlapCompare add constraint PK_#OverlapCompare primary key clustered 
(ID asc)

create table #OverlapTo
(ENID                                              int not null,
 OverlapType                                       char(01),
 OverlapDays                                       int) 

alter table #OverlapTo add constraint PK_#OverlapTo primary key clustered 
(ENID asc)

insert into #OverlapTo
select a.ENID,
       case when a.ContractRateStart              >= b.ContractRateStart  
            and  a.ContractRateEnd                <= b.ContractRateEnd
            then 'T'
            when a.ContractRateStart              >= b.ContractRateStart  
            and  a.ContractRateStart              <= b.ContractRateEnd 
            then 'P'
            when a.ContractRateEnd                >= b.ContractRateStart 
            and  a.ContractRateEnd                <= b.ContractRateEnd
            then 'P'
            when a.ContractRateStart              <= b.ContractRateStart 
            and  a.ContractRateEnd                >= b.ContractRateStart
            then 'P'
            else null
       end,
       case when a.ContractRateStart              >= b.ContractRateStart  
            and  a.ContractRateEnd                <= b.ContractRateEnd
            then DATEDIFF(dd, a.ContractRateStart, a.ContractRateEnd)
            when a.ContractRateStart              >= b.ContractRateStart  
            and  a.ContractRateStart              <= b.ContractRateEnd 
            then DATEDIFF(dd, b.ContractRateStart, a.ContractRateEnd)
            when a.ContractRateEnd                >= b.ContractRateStart 
            and  a.ContractRateEnd                <= b.ContractRateEnd
            then DATEDIFF(dd, b.ContractRateStart, a.ContractRateEnd)
            when a.ContractRateStart              <= b.ContractRateStart 
            and  a.ContractRateEnd                >= b.ContractRateStart
            then DATEDIFF(dd, b.ContractRateStart, a.ContractRateEnd)
            else null
       end
from #OverlapFrom a with (nolock index = PK_#OverlapFrom)
left join #OverlapCompare b with (nolock index = PK_#OverlapCompare)
on  a.ID                                           = b.ID
and a.AccountID                                    = b.AccountID                                 

/******** Header - Overlap ********/

update a set OverlapType = b.OverlapType,
             OverlapDays = b.OverlapDays
from #Enrollment a with (nolock index = PK_#Enrollment)
join #OverlapTo b with (nolock index = PK_#OverlapTo)
on  a.ENID                                         = b.ENID   
where not exists(select null
                 from #Expire c with (nolock index = idx_#Expire)
                 where c.AccountID                 = a.AccountID
                 and   c.ContractID                = a.ContractID
                 and   c.Term                      = a.Term)

select a.ProcessType,
       a.ISO,
       a.AccountID,
       a.AccountType,
       a.Utility,
       a.AccountNumber,
       a.ContractID,
       a.ContractNumber,
       a.Term,
       a.Status,
       a.SubStatus,
       a.BeginDate,
       a.EndDate,
       a.ContractStartDate,
       a.ContractEndDate,
       a.ContractRateStart,
       a.ContractRateEnd,
       a.LastServiceStartDate,
       a.LastServiceEndDate,
       a.ServiceStartDate,
       a.ServiceEndDate,
       a.CriteriaStartDate,
       a.CriteriaEndDate,
       a.CriteriaStatus,
       a.SubmitDate,
       a.Zone,
       a.ContractStatusID,
       a.ProductID,
       a.ProductCategory,
       a.ProductSubCategory,
       a.RateID,
       a.Rate,
       a.IsContractedRate,
       a.PricingRequestID,
       a.BackToBack,
       a.AnnualUsage,
       a.InvoiceID,
       a.InvoiceFromDate,
       a.InvoiceToDate,
       a.OverlapType,
       a.OverlapDays,
       ProcessDate                                 = @p_ProcessDate,
       ControlDate                                 = @p_ControlDate,
       DateProcessed                               = GETDATE()
into #EnrollmentInsert
from #Enrollment a with (nolock index = idx_#Enrollment)
where ((@p_Process                                in ('T', 'F'))
or     (@p_Process                                 = 'I'
and     exists (select null
                from #Incremental b with (nolock index = idx_#Incremental)
                where b.AccountID                  = a.AccountID
                and   b.ContractID                 = a.ContractID
                and   b.Term                       = a.Term
                and   b.Action                    in ('I', 'E'))))

/******** Delete Tables ********/

if @p_ProductCategory                              = 'FIXED'
begin

   if @p_Process                                   = 'I'
   begin
      truncate table dbo.RECONEDI_EnrollmentFixed
   end

   insert into dbo.RECONEDI_EnrollmentFixed
   select *
   from #EnrollmentInsert

   truncate table dbo.RECONEDI_EnrollmentChanges

   insert into dbo.RECONEDI_EnrollmentChanges
   select distinct
          a.*
   from #Incremental a with (nolock index = idx_#Incremental) 
   where a.Action                                 in ('E', 'D')
   and   @p_Process                                = 'I'
      
end

if @p_ProductCategory                              = 'VARIABLE'
begin
   delete b
   from @Utility a
   inner join dbo.RECONEDI_EnrollmentVariable b with (nolock index = idx_RECONEDI_EnrollmentVariable)
   on  a.Utility                                   = b.Utility
--Without Filter
   where ((@p_Process                              = 'T')
--Filter
   or     (@p_Process                              = 'F'
   and     exists(select null
                  from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
                  where z.Utility                  = b.Utility
                  and   z.AccountNumber            = b.AccountNumber)))

   insert into dbo.RECONEDI_EnrollmentVariable
   select *
   from #EnrollmentInsert
end

/***********************/

insert into dbo.RECONEDI_Tracking
select @p_REHID,
       @p_ISO,
       '',
       'End - Enrollment Process ',
       getdate(),
       'usp_RECONEDI_Enrollment'

/***********************/
GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_EnrollmentChangesSelect]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_RECONEDI_EnrollmentChangesSelect]
 as

select AccountID,
       ContractID,
       Term,
       Action
from dbo.RECONEDI_EnrollmentChanges with (nolock index = PK_RECONEDI_EnrollmentChanges)


GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_EnrollmentChangesTruncate]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_RECONEDI_EnrollmentChangesTruncate]
 as

truncate table RECONEDI_EnrollmentChanges

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_EnrollmentDelete]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros	
-- Create date: 01/21/2014
-- Description:	Delete all data from EnrollmentFixed table
-- =============================================
CREATE PROCEDURE [dbo].[usp_RECONEDI_EnrollmentDelete]
AS
BEGIN
	
	SET NOCOUNT ON;

    DELETE FROM dbo.RECONEDI_EnrollmentFixed
END

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_Forecast]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_RECONEDI_Forecast 'PJM', '20140103', 'F'
CREATE procedure [dbo].[usp_RECONEDI_Forecast]
(@p_ISO                                            varchar(50),
 @p_ProcessDate                                    datetime,
 @p_Process                                        char(01) = 'F')
as
set nocount                                        on

/******** Utility ********/

declare @Utility table                        
(Utility                                           varchar(50) primary key clustered)


if @p_Process                                     in ('F', 'I')
begin
   insert into @Utility
   select distinct Utility
   from dbo.RECONEDI_Filter (nolock)
   where ISO                                       = @p_ISO
end

if @p_Process                                      = 'T'
begin
   insert into @Utility
   select distinct UtilityCode
   from Libertypower.dbo.Utility with (nolock)
   where InactiveInd = 0
   and   WholeSaleMktID                            = @p_ISO
end

delete c
from @Utility a
inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx2_RECONEDI_EnrollmentFixed)
on  a.Utility                                      = b.Utility
inner join dbo.RECONEDI_ForecastDates c with (nolock index = idx_RECONEDI_ForecastDates) 
on  b.ENID                                         = c.ENID   
--Without Filter
where ((@p_Process                                 = 'T')
--Filter
or     (@p_Process                                in ('F', 'I')
and     exists(select null
               from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
               where z.Utility                     = b.Utility
               and   z.AccountNumber               = b.AccountNumber)))

delete c
from @Utility a
inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx2_RECONEDI_EnrollmentFixed)
on  a.Utility                                      = b.Utility
inner join dbo.RECONEDI_ForecastDaily c with (nolock index = idx_RECONEDI_ForecastDaily) 
on  b.ENID                                         = c.ENID   
--Without Filter
where ((@p_Process                                 = 'T')
--Filter
or     (@p_Process                                in ('F', 'I')
and     exists(select null
               from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
               where z.Utility                     = b.Utility
               and   z.AccountNumber               = b.AccountNumber)))

delete c
from @Utility a
inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx2_RECONEDI_EnrollmentFixed)
on  a.Utility                                      = b.Utility
inner join dbo.RECONEDI_ForecastWholesale c with (nolock index = idx_RECONEDI_ForecastWholesale) 
on  b.ENID                                         = c.ENID   
--Without Filter
where ((@p_Process                                 = 'T')
--Filter
or     (@p_Process                                in ('F', 'I')
and     exists(select null
               from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
               where z.Utility                     = b.Utility
               and   z.AccountNumber               = b.AccountNumber)))

delete d
from @Utility a
inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx2_RECONEDI_EnrollmentFixed)
on  a.Utility                                      = b.Utility
inner join dbo.RECONEDI_MTM c with (nolock index = idx_RECONEDI_MTM) 
on  b.ENID                                         = c.ENID   
inner join dbo.RECONEDI_ForecastWholesaleError d with (nolock index = idx_RECONEDI_ForecastWholesaleError)
on  b.ENID                                         = d.ENID
--Without Filter
where ((@p_Process                                in ('T', 'I'))
--Filter
or     (@p_Process                                 = 'F'
and     exists(select null
               from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
               where z.Utility                     = b.Utility
               and   z.AccountNumber               = b.AccountNumber)))

/******** Forecast Header - Dates ********/

create table #ForecastDateFrom
(ID                                                int identity(1, 1) not null, 
 ENID                                              bigint,
 AccountID                                         int,
 ActualStartDate                                   datetime,
 ActualEndDate                                     datetime,
 SearchActualStartDate                             datetime,
 SearchActualEndDate                               datetime)

alter table #ForecastDateFrom add constraint PK_#ForecastDateFrom primary key clustered 
(ID asc)

create index idx_#ForecastDateFrom on #ForecastDateFrom
(ENID asc)

create table #EnrollmentFixed
(ENID                                              bigint not null,
 Utility                                           varchar(50),
 AccountNumber                                     varchar(50),
 AccountID                                         int,
 SubmitDate                                        datetime,
 ContractID                                        int,
 ContractRateStart                                 datetime,
 ContractRateEnd                                   datetime,
 ContractRateStartOverlap                          datetime,
 OverlapDays                                       int,
 OverlapType                                       char(01))

alter table #EnrollmentFixed add constraint PK_#EnrollmentFixed primary key clustered 
(ENID asc)

create index idx_#EnrollmentFixed on #EnrollmentFixed
(AccountID,
 SubmitDate,
 ContractID)

create index idx1_#EnrollmentFixed on #EnrollmentFixed
(OverlapType)

insert into #EnrollmentFixed
select distinct
       b.ENID,
       b.Utility,
       b.AccountNumber,
       b.AccountID,
       b.SubmitDate,
       b.ContractID,
       b.ContractRateStart,
       b.ContractRateEnd,
       null,
       b.OverlapDays,
       b.OverlapType
from @Utility a
inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx2_RECONEDI_EnrollmentFixed)
on  a.Utility                                      = b.Utility
--Without Filter
where ((@p_Process                                 = 'T')
--Filter
or     (@p_Process                                in ('F', 'I')
and     exists(select null
               from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
               where z.Utility                     = b.Utility
               and   z.AccountNumber               = b.AccountNumber)))

/******** Overlap ********/

create table #EDISearch
(AccountID                                         int,
 Utility                                           varchar(50),
 AccountNumber                                     varchar(50),
 ContractRateStart                                 datetime,
 ContractRateEnd                                   datetime)

insert into #EDISearch
select distinct 
       AccountID,
       Utility,
       AccountNumber,
       ContractRateStart,
       ContractRateEnd
from #EnrollmentFixed with (nolock index = idx1_#EnrollmentFixed)
where OverlapType                                 <> 'E'
or    OverlapType                                 is null
         
create table #EDIResult
(AccountID                                         int,
 ContractID                                        int,
 Utility                                           varchar(50),
 AccountNumber                                     varchar(50),
 ActualStartDate                                   datetime,
 ActualEndDate                                     datetime,
 SearchActualStartDate                             datetime,
 SearchActualEndDate                               datetime)

create index idx_#EDIResult on #EDIResult
(AccountID)

insert into #EDIResult
select b.AccountID,
       b.ContractID,
       a.Utility,
       a.AccountNumber,
       b.ActualStartDate,
       b.ActualEndDate,
       b.SearchActualStartDate,
       b.SearchActualEndDate
from (select distinct 
             Utility,
             AccountNumber
      from #EDISearch a (nolock)) a
cross apply (select distinct
                    AccountID,
                    ContractID, 
                    ActualStartDate,
                    ActualEndDate,
                    SearchActualStartDate,
                    SearchActualEndDate 
             from dbo.ufn_RECONEDI_EDIResultSelect(a.Utility, a.AccountNumber, @p_ProcessDate)) b
order by b.AccountID,
         year(b.ActualStartDate),
         b.ActualStartDate

insert into #ForecastDateFrom
select a.ENID,
       a.AccountID,
       a.ActualStartDate,
       a.ActualEndDate,
       a.SearchActualStartDate,
       a.SearchActualEndDate
from (select distinct       
             a.ENID,
             a.Utility,
             a.AccountID,
             a.ContractID,
             a.SubmitDate,
             ActualStartDate                       = case when a.ContractRateStart              > b.ActualStartDate
                                                          then a.ContractRateStart
                                                          when a.ContractRateStart             <= b.ActualStartDate
                                                          then b.ActualStartDate
                                                          when b.ActualStartDate               is null
                                                          then a.ContractRateStart
                                                     end,
             ActualEndDate                         = case when a.ContractRateEnd                > b.ActualEndDate
                                                          and  b.ActualEndDate                 >= a.ContractRateStart
                                                          then b.ActualEndDate
                                                          when a.ContractRateEnd                > b.ActualEndDate
                                                          and  b.ActualEndDate                  < a.ContractRateStart
                                                          then a.ContractRateEnd
                                                          when a.ContractRateEnd               <= b.ActualEndDate
                                                          then a.ContractRateEnd
                                                          when b.ActualEndDate                 is null
                                                          then a.ContractRateEnd
                                                     end,
             SearchActualStartDate                 = case when a.ContractRateStart              > b.ActualStartDate
                                                          and  b.SearchActualStartDate     is not null
                                                          then a.ContractRateStart
                                                          when a.ContractRateStart             <= b.ActualStartDate
                                                          and  b.SearchActualStartDate     is not null
                                                          then b.ActualStartDate
                                                          else b.SearchActualStartDate
                                                     end,
             SearchActualEndDate                   = case when a.ContractRateEnd                > b.ActualEndDate
                                                          and  b.ActualEndDate                 >= a.ContractRateStart
                                                          and  b.SearchActualEndDate       is not null
                                                          then b.ActualEndDate
                                                          when a.ContractRateEnd                > b.ActualEndDate
                                                          and  b.SearchActualEndDate       is not null
                                                          and  b.ActualEndDate                  < a.ContractRateStart
                                                          then a.ContractRateEnd
                                                          when a.ContractRateEnd               <= b.ActualEndDate
                                                          and  b.SearchActualEndDate       is not null
                                                          then a.ContractRateEnd
                                                          else b.SearchActualEndDate
                                                     end
      from #EnrollmentFixed a with (nolock index = idx_#EnrollmentFixed)
      inner join #EDIResult b with (nolock index = idx_#EDIResult)
      on  a.AccountID                              = b.AccountID
      and a.ContractID                             = b.ContractID
      where ((b.ActualStartDate                   >= a.ContractRateStart
      and     b.ActualStartDate                   <= a.ContractRateEnd)
      or     (b.ActualEndDate                     >= a.ContractRateStart
      and     b.ActualEndDate                     <= a.ContractRateEnd))) a
order by a.Utility,
         a.AccountID,
         year(a.ActualStartDate),
         a.ActualStartDate,
         a.SubmitDate,
         a.ContractID

create table #ForecastDateCompare
(ID                                                int identity(0, 1) not null, 
 ENID                                              bigint,
 AccountID                                         int,
 ActualStartDate                                   datetime,
 ActualEndDate                                     datetime,
 SearchActualStartDate                             datetime,
 SearchActualEndDate                               datetime)

alter table #ForecastDateCompare add constraint PK_#ForecastDateCompare primary key clustered 
(ID asc)

insert into #ForecastDateCompare
select ENID,
       AccountID,
       ActualStartDate,
       ActualEndDate,
       SearchActualStartDate,
       SearchActualEndDate
from #ForecastDateFrom (nolock)
order by ID

create table #ForecastDateTo
(ID                                                int identity(1, 1) not null, 
 ENID                                              bigint,
 ActualStartDate                                   datetime,
 ActualEndDate                                     datetime,
 OverlapType                                       char(01),
 OverlapDays                                       int,
 SearchActualStartDate                             datetime,
 SearchActualEndDate                               datetime)

create index idx_#ForecastDateTo on #ForecastDateTo
(ENID asc)

insert into #ForecastDateTo
select a.ENID,
       a.ActualStartDate,
       a.ActualEndDate,
       OverlapType                                 = case when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualEndDate          <= b.ActualEndDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then 'T'
                                                          when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualStartDate        <= b.ActualEndDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then 'P'
                                                          when a.ActualEndDate          >= b.ActualStartDate 
                                                          and  a.ActualEndDate          <= b.ActualEndDate     
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then 'P'
                                                          when a.ActualStartDate        <= b.ActualStartDate
                                                          and  a.ActualEndDate          >= b.ActualStartDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then 'P'
                                                          else null
                                                     end,
       OverlapDays                                 = case when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualEndDate          <= b.ActualEndDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then DATEDIFF(dd, a.ActualStartDate, a.ActualEndDate) + 1
                                                          when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualStartDate        <= b.ActualEndDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then DATEDIFF(dd, b.ActualStartDate, a.ActualEndDate) + 1
                                                          when a.ActualEndDate          >= b.ActualStartDate 
                                                          and  a.ActualEndDate          <= b.ActualEndDate     
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then DATEDIFF(dd, b.ActualStartDate, a.ActualEndDate) + 1
                                                          when a.ActualStartDate        <= b.ActualStartDate
                                                          and  a.ActualEndDate          >= b.ActualStartDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then DATEDIFF(dd, b.ActualStartDate, a.ActualEndDate) + 1
                                                          else null
                                                     end,
       SearchActualStartDate                       = case when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualEndDate          <= b.ActualEndDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then null
                                                          when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualStartDate        <= b.ActualEndDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then null
                                                          when a.ActualEndDate          >= b.ActualStartDate 
                                                          and  a.ActualEndDate          <= b.ActualEndDate     
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then a.ActualStartDate
                                                          when a.ActualStartDate        <= b.ActualStartDate
                                                          and  a.ActualEndDate          >= b.ActualStartDate
                                                          and  a.SearchActualStartDate  is not null
                                                          and  b.SearchActualStartDate  is not null
                                                          then a.ActualStartDate
                                                          else a.SearchActualStartDate
                                                     end,
       SearchActualEndDate                         = case when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualEndDate          <= b.ActualEndDate
                                                          and  a.SearchActualEndDate    is not null
                                                          and  b.SearchActualEndDate    is not null
                                                          then null
                                                          when a.ActualStartDate        >= b.ActualStartDate  
                                                          and  a.ActualStartDate        <= b.ActualEndDate
                                                          and  a.SearchActualEndDate    is not null
                                                          and  b.SearchActualEndDate    is not null
                                                          then null
                                                          when a.ActualEndDate          >= b.ActualStartDate 
                                                          and  a.ActualEndDate          <= b.ActualEndDate     
                                                          and  a.SearchActualEndDate    is not null
                                                          and  b.SearchActualEndDate    is not null
                                                          then DATEADD(dd, -1, b.ActualStartDate)
                                                          when a.ActualStartDate        <= b.ActualStartDate
                                                          and  a.ActualEndDate          >= b.ActualStartDate
                                                          and  a.SearchActualEndDate    is not null
                                                          and  b.SearchActualEndDate    is not null
                                                          then DATEADD(dd, -1, b.ActualStartDate)
                                                          else a.SearchActualEndDate
                                                     end
from #ForecastDateFrom a with (nolock index = PK_#ForecastDateFrom)
left join #ForecastDateCompare b with (nolock index = PK_#ForecastDateCompare)
on  a.ID                                           = b.ID 
and a.AccountID                                    = b.AccountID                                 

insert into dbo.RECONEDI_ForecastDates
select a.ENID,
       a.ActualStartDate,
       a.ActualEndDate,
       a.OverlapType,
       a.OverlapDays,
       a.SearchActualStartDate,
       a.SearchActualEndDate
from #ForecastDateTo a (nolock)
order by a.ENID,
         a.ActualStartDate

insert into dbo.RECONEDI_ForecastDates
select a.ENID,
       null,
       null,
       a.OverlapType,
       a.OverlapDays,
       null,
       null
from #EnrollmentFixed a with (nolock index = idx1_#EnrollmentFixed)
where OverlapType                                  = 'E'

/******** Forecast ********/

create table #ISOForecast
(ENID                                              bigint,
 FDatesID                                          bigint,
 ID                                                int,
 SearchActualStartDate                             datetime,
 SearchActualEndDate                               datetime)

insert into #ISOForecast
select a.ENID,
       b.FDatesID,
       c.ID,
       b.SearchActualStartDate,
       b.SearchActualEndDate
from #EnrollmentFixed a with (nolock index = PK_#EnrollmentFixed)
inner join dbo.RECONEDI_ForecastDates b with (nolock index = idx_RECONEDI_ForecastDates)
on  a.ENID                                         = b.ENID   
left join dbo.RECONEDI_MTM c with (nolock index = idx_RECONEDI_MTM)
on  a.ENID                                         = c.ENID

create clustered index idx_#ISOFOrecast on #ISOFOrecast
(ID asc,
 SearchActualStartDate asc)

create index idx1_#ISOFOrecast on #ISOFOrecast
(ENID asc,
 FDatesID asc)


/******** Forecast Daily ********/

insert into dbo.RECONEDI_ForecastDaily
select a.ENID,
       a.FdatesID,
       0,
       null,
       null,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0
from #ISOFOrecast a with (nolock index = idx_#ISOFOrecast)
where a.ID                                      is null

select a.ENID,
       a.FDatesID,
       e.UsageDate,
       UsageYear                                   = year(e.UsageDate),
       UsageMonth                                  = month(e.UsageDate),
       e.Peak,
       e.OffPeak
into #Daily       
from #ISOFOrecast a with (nolock index = idx_#ISOFOrecast)
inner join lp_MtM.dbo.MtMDailyLoadForecast e with (nolock)
on  a.ID                                           = e.MTMAccountID
where a.ID                                         > 0
and   a.SearchActualStartDate                 is not null
and   e.UsageDate                                 >= a.SearchActualStartDate 
and   e.UsageDate                                 <= a.SearchActualEndDate

insert into dbo.RECONEDI_ForecastDaily
select a.ENID,
       a.FDatesID,
       a.UsageYear,
       min(a.UsageDate),
       max(a.UsageDate),
       sum(case when UsageMonth = 1
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 1
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 2
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 2
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 3
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 3
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 4
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 4
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 5
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 5
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 6
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 6
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 7
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 7
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 8
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 8
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 9
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 9
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 10
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 10
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 11
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 11
                then a.OffPeak
                else 0
           end),
       sum(case when UsageMonth = 12
                then a.Peak
                else 0
           end),
       sum(case when UsageMonth = 12
                then a.OffPeak
                else 0
           end)
from #Daily a (nolock)
group by a.ENID,
         a.FdatesID,
         a.UsageYear

insert into dbo.RECONEDI_ForecastDaily
select a.ENID,
       a.FDatesID,
       0,
       null,
       null,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0
from #ISOFOrecast a with (nolock index = idx1_#ISOFOrecast)
where not exists(select null
                 from dbo.RECONEDI_ForecastDaily b with (nolock index = idx_RECONEDI_ForecastDaily)
                 where b.ENID                      = a.ENID   
                 and   b.FDatesID                  = a.FDatesID)

/******** Forecast Forecast ********/

insert into dbo.RECONEDI_ForecastWholesale
select a.ENID,
       a.FdatesID,
       0,
       null,
       null,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0
from #ISOFOrecast a with (nolock index = idx_#ISOFOrecast)
where a.ID                                      is null

select a.ENID,
       a.FDatesID,
       e.UsageDate,
       UsageYear                                   = year(e.UsageDate),
       UsageMonth                                  = month(e.UsageDate),
       e.ETP,
       e.Int1,
       e.Int2,
       e.Int3,
       e.Int4,
       e.Int5,
       e.Int6,
       e.Int7,
       e.Int8,
       e.Int9,
       e.Int10,
       e.Int11,
       e.Int12,                                                                 
       e.Int13,
       e.Int14,
       e.Int15,
       e.Int16,
       e.Int17,
       e.Int18,
       e.Int19,
       e.Int20,
       e.Int21,
       e.Int22,                                                                 
       e.Int23,
       e.Int24,
       e.Peak,
       e.OffPeak,
       NullInd                                     = case when e.Int1  is null
                                                          or   e.Int2  is null
                                                          or   e.Int3  is null
                                                          or   e.Int4  is null
                                                          or   e.Int5  is null
                                                          or   e.Int6  is null
                                                          or   e.Int7  is null
                                                          or   e.Int8  is null
                                                          or   e.Int9  is null
                                                          or   e.Int10 is null
                                                          or   e.Int11 is null
                                                          or   e.Int12 is null
                                                          or   e.Int13 is null
                                                          or   e.Int14 is null
                                                          or   e.Int15 is null
                                                          or   e.Int16 is null
                                                          or   e.Int17 is null
                                                          or   e.Int18 is null
                                                          or   e.Int19 is null
                                                          or   e.Int20 is null
                                                          or   e.Int21 is null
                                                          or   e.Int22 is null
                                                          or   e.Int23 is null
                                                          or   e.Int24 is null
                                                          then 1
                                                          else 0
                                                     end
into #Wholesale       
from #ISOFOrecast a with (nolock index = idx_#ISOFOrecast)
inner join lp_MtM.dbo.MtMDailyWholesaleLoadForecast e with (nolock)
on  a.ID                                           = e.MTMAccountID
where a.ID                                         > 0
and   a.SearchActualStartDate                 is not null
and   e.UsageDate                                 >= a.SearchActualStartDate 
and   e.UsageDate                                 <= a.SearchActualEndDate

select distinct 
       a.ENID
into #WholesaleDuplicate
from (select ENID,
             --ID,
             UsageDate
      from #Wholesale      
      group by ENID,
               --ID,
               UsageDate      
      having count(*) > 1) a

select distinct 
       ENID
into #WholesaleNull
from #Wholesale      
where NullInd                                      = 1

insert into dbo.RECONEDI_ForecastWholesale
select a.ENID,
       a.FDatesID,
       a.UsageYear,
       min(a.UsageDate),
       max(a.UsageDate),
       a.ETP,
       sum(case when UsageMonth = 1
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 2
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
           else 0
           end),
       sum(case when UsageMonth = 3
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 4
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 5
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 6
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 7
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 8
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 9
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 10
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 11
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 12
                then isnull(a.Int1, 0)
                   + isnull(a.Int2, 0)
                   + isnull(a.Int3, 0)
                   + isnull(a.Int4, 0)
                   + isnull(a.Int5, 0)
                   + isnull(a.Int6, 0)
                   + isnull(a.Int7, 0)
                   + isnull(a.Int8, 0)
                   + isnull(a.Int9, 0)
                   + isnull(a.Int10, 0)
                   + isnull(a.Int11, 0)
                   + isnull(a.Int12, 0)
                   + isnull(a.Int13, 0)
                   + isnull(a.Int14, 0)
                   + isnull(a.Int15, 0)
                   + isnull(a.Int16, 0)
                   + isnull(a.Int17, 0)
                   + isnull(a.Int18, 0)
                   + isnull(a.Int19, 0)
                   + isnull(a.Int20, 0)
                   + isnull(a.Int21, 0)
                   + isnull(a.Int22, 0)
                   + isnull(a.Int23, 0)
                   + isnull(a.Int24, 0)
                else 0
           end),
       sum(case when UsageMonth = 1
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 2
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 3
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 4
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 5
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 6
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 7
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 8
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 9
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 10
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 11
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 12
                then isnull(a.Peak, 0)
                else 0
           end),
       sum(case when UsageMonth = 1
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 2
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 3
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 4
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 5
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 6
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 7
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 8
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 9
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 10
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 11
                then isnull(a.OffPeak, 0)
                else 0
           end),
       sum(case when UsageMonth = 12
                then isnull(a.OffPeak, 0)
                else 0
           end)
from #WholeSale a (nolock)
group by a.ENID,
         a.FDatesID,
         a.UsageYear,
         a.ETP
         
insert into dbo.RECONEDI_ForecastWholesale
select a.ENID,
       a.FdatesID,
       0,
       null,
       null,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0,
       0
from #ISOFOrecast a with (nolock index = idx1_#ISOFOrecast)
where not exists(select null
                 from dbo.RECONEDI_ForecastWholesale b with (nolock index = idx_RECONEDI_ForecastWholesale)
                 where b.ENID                      = a.ENID   
                 and   b.FDatesID                  = a.FDatesID)

                 
insert into RECONEDI_ForecastWholesaleError
select *,
       'Duplicate Dates'     
from #WholesaleDuplicate

if @@rowcount                                     <> 0
begin
   delete c
   from @Utility a
   inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx2_RECONEDI_EnrollmentFixed)
   on  a.Utility                                   = b.Utility
   inner join dbo.RECONEDI_ForecastWholesale c with (nolock index = idx_RECONEDI_ForecastWholesale) 
   on  b.ENID                                      = c.ENID   
   inner join (select distinct 
                      ENID
               from #WholesaleDuplicate (nolock)) d
   on  b.ENID                                      = d.ENID 

   insert into dbo.RECONEDI_ForecastWholesale
   select a.ENID,
          a.FDatesID,
          b.UsageYear,
          min(b.UsageDate),
          max(b.UsageDate),
          b.ETP,
          sum(case when UsageMonth = 1
                   then isnull(b.Int1, 0)
                      + isnull(b.Int2, 0)
                      + isnull(b.Int3, 0)
                      + isnull(b.Int4, 0)
                      + isnull(b.Int5, 0)
                      + isnull(b.Int6, 0)
                      + isnull(b.Int7, 0)
                      + isnull(b.Int8, 0)
                      + isnull(b.Int9, 0)
                      + isnull(b.Int10, 0)
                      + isnull(b.Int11, 0)
                      + isnull(b.Int12, 0)
                      + isnull(b.Int13, 0)
                      + isnull(b.Int14, 0)
                      + isnull(b.Int15, 0)
                      + isnull(b.Int16, 0)
                      + isnull(b.Int17, 0)
                      + isnull(b.Int18, 0)
                      + isnull(b.Int19, 0)
                      + isnull(b.Int20, 0)
                      + isnull(b.Int21, 0)
                      + isnull(b.Int22, 0)
                      + isnull(b.Int23, 0)
                      + isnull(b.Int24, 0)
                   else 0
              end),
          sum(case when UsageMonth = 2
                   then isnull(b.Int1, 0)
                      + isnull(b.Int2, 0)
                      + isnull(b.Int3, 0)
                      + isnull(b.Int4, 0)
                      + isnull(b.Int5, 0)
                      + isnull(b.Int6, 0)
                      + isnull(b.Int7, 0)
                      + isnull(b.Int8, 0)
                      + isnull(b.Int9, 0)
                      + isnull(b.Int10, 0)
                      + isnull(b.Int11, 0)
                      + isnull(b.Int12, 0)
                      + isnull(b.Int13, 0)
                      + isnull(b.Int14, 0)
                      + isnull(b.Int15, 0)
                      + isnull(b.Int16, 0)
                      + isnull(b.Int17, 0)
                      + isnull(b.Int18, 0)
                      + isnull(b.Int19, 0)
                      + isnull(b.Int20, 0)
                      + isnull(b.Int21, 0)
                      + isnull(b.Int22, 0)
                      + isnull(b.Int23, 0)
                      + isnull(b.Int24, 0)
              else 0
              end),
          sum(case when UsageMonth = 3
                   then isnull(b.Int1, 0)
                      + isnull(b.Int2, 0)
                      + isnull(b.Int3, 0)
                      + isnull(b.Int4, 0)
                      + isnull(b.Int5, 0)
                      + isnull(b.Int6, 0)
                      + isnull(b.Int7, 0)
                      + isnull(b.Int8, 0)
                      + isnull(b.Int9, 0)
                      + isnull(b.Int10, 0)
                      + isnull(b.Int11, 0)
                      + isnull(b.Int12, 0)
                      + isnull(b.Int13, 0)
                      + isnull(b.Int14, 0)
                      + isnull(b.Int15, 0)
                      + isnull(b.Int16, 0)
                      + isnull(b.Int17, 0)
                      + isnull(b.Int18, 0)
                      + isnull(b.Int19, 0)
                      + isnull(b.Int20, 0)
                      + isnull(b.Int21, 0)
                      + isnull(b.Int22, 0)
                      + isnull(b.Int23, 0)
                      + isnull(b.Int24, 0)
                   else 0
              end),
          sum(case when UsageMonth = 4
                   then isnull(b.Int1, 0)
                      + isnull(b.Int2, 0)
                      + isnull(b.Int3, 0)
                      + isnull(b.Int4, 0)
                      + isnull(b.Int5, 0)
                      + isnull(b.Int6, 0)
                      + isnull(b.Int7, 0)
                      + isnull(b.Int8, 0)
                      + isnull(b.Int9, 0)
                      + isnull(b.Int10, 0)
                      + isnull(b.Int11, 0)
                      + isnull(b.Int12, 0)
                      + isnull(b.Int13, 0)
                      + isnull(b.Int14, 0)
                      + isnull(b.Int15, 0)
                      + isnull(b.Int16, 0)
                      + isnull(b.Int17, 0)
                      + isnull(b.Int18, 0)
                      + isnull(b.Int19, 0)
                      + isnull(b.Int20, 0)
                      + isnull(b.Int21, 0)
                      + isnull(b.Int22, 0)
                      + isnull(b.Int23, 0)
                      + isnull(b.Int24, 0)
                    else 0
              end),
          sum(case when UsageMonth = 5
                   then isnull(b.Int1, 0)
                      + isnull(b.Int2, 0)
                      + isnull(b.Int3, 0)
                      + isnull(b.Int4, 0)
                      + isnull(b.Int5, 0)
                      + isnull(b.Int6, 0)
                      + isnull(b.Int7, 0)
                      + isnull(b.Int8, 0)
                      + isnull(b.Int9, 0)
                      + isnull(b.Int10, 0)
                      + isnull(b.Int11, 0)
                      + isnull(b.Int12, 0)
                      + isnull(b.Int13, 0)
                      + isnull(b.Int14, 0)
                      + isnull(b.Int15, 0)
                      + isnull(b.Int16, 0)
                      + isnull(b.Int17, 0)
                      + isnull(b.Int18, 0)
                      + isnull(b.Int19, 0)
                      + isnull(b.Int20, 0)
                      + isnull(b.Int21, 0)
                      + isnull(b.Int22, 0)
                      + isnull(b.Int23, 0)
                      + isnull(b.Int24, 0)
              end),
          sum(case when UsageMonth = 6
                   then isnull(b.Int1, 0)
                      + isnull(b.Int2, 0)
                      + isnull(b.Int3, 0)
                      + isnull(b.Int4, 0)
                      + isnull(b.Int5, 0)
                      + isnull(b.Int6, 0)
                      + isnull(b.Int7, 0)
                      + isnull(b.Int8, 0)
                      + isnull(b.Int9, 0)
                      + isnull(b.Int10, 0)
                      + isnull(b.Int11, 0)
                      + isnull(b.Int12, 0)
                      + isnull(b.Int13, 0)
                      + isnull(b.Int14, 0)
                      + isnull(b.Int15, 0)
                      + isnull(b.Int16, 0)
                      + isnull(b.Int17, 0)
                      + isnull(b.Int18, 0)
                      + isnull(b.Int19, 0)
                      + isnull(b.Int20, 0)
                      + isnull(b.Int21, 0)
                      + isnull(b.Int22, 0)
                      + isnull(b.Int23, 0)
                      + isnull(b.Int24, 0)
                    else 0
              end),
          sum(case when UsageMonth = 7
                   then isnull(b.Int1, 0)
                      + isnull(b.Int2, 0)
                      + isnull(b.Int3, 0)
                      + isnull(b.Int4, 0)
                      + isnull(b.Int5, 0)
                      + isnull(b.Int6, 0)
                      + isnull(b.Int7, 0)
                      + isnull(b.Int8, 0)
                      + isnull(b.Int9, 0)
                      + isnull(b.Int10, 0)
                      + isnull(b.Int11, 0)
                      + isnull(b.Int12, 0)
                      + isnull(b.Int13, 0)
                      + isnull(b.Int14, 0)
                      + isnull(b.Int15, 0)
                      + isnull(b.Int16, 0)
                      + isnull(b.Int17, 0)
                      + isnull(b.Int18, 0)
                      + isnull(b.Int19, 0)
                      + isnull(b.Int20, 0)
                      + isnull(b.Int21, 0)
                      + isnull(b.Int22, 0)
                      + isnull(b.Int23, 0)
                      + isnull(b.Int24, 0)
                    else 0
              end),
          sum(case when UsageMonth = 8
                   then isnull(b.Int1, 0)
                      + isnull(b.Int2, 0)
                      + isnull(b.Int3, 0)
                      + isnull(b.Int4, 0)
                      + isnull(b.Int5, 0)
                      + isnull(b.Int6, 0)
                      + isnull(b.Int7, 0)
                      + isnull(b.Int8, 0)
                      + isnull(b.Int9, 0)
                      + isnull(b.Int10, 0)
                      + isnull(b.Int11, 0)
                      + isnull(b.Int12, 0)
                      + isnull(b.Int13, 0)
                      + isnull(b.Int14, 0)
                      + isnull(b.Int15, 0)
                      + isnull(b.Int16, 0)
                      + isnull(b.Int17, 0)
                      + isnull(b.Int18, 0)
                      + isnull(b.Int19, 0)
                      + isnull(b.Int20, 0)
                      + isnull(b.Int21, 0)
                      + isnull(b.Int22, 0)
                      + isnull(b.Int23, 0)
                      + isnull(b.Int24, 0)
                    else 0
              end),
          sum(case when UsageMonth = 9
                   then isnull(b.Int1, 0)
                      + isnull(b.Int2, 0)
                      + isnull(b.Int3, 0)
                      + isnull(b.Int4, 0)
                      + isnull(b.Int5, 0)
                      + isnull(b.Int6, 0)
                      + isnull(b.Int7, 0)
                      + isnull(b.Int8, 0)
                      + isnull(b.Int9, 0)
                      + isnull(b.Int10, 0)
                      + isnull(b.Int11, 0)
                      + isnull(b.Int12, 0)
                      + isnull(b.Int13, 0)
                      + isnull(b.Int14, 0)
                      + isnull(b.Int15, 0)
                      + isnull(b.Int16, 0)
                      + isnull(b.Int17, 0)
                      + isnull(b.Int18, 0)
                      + isnull(b.Int19, 0)
                      + isnull(b.Int20, 0)
                      + isnull(b.Int21, 0)
                      + isnull(b.Int22, 0)
                      + isnull(b.Int23, 0)
                      + isnull(b.Int24, 0)
                    else 0
              end),
          sum(case when UsageMonth = 10
                   then isnull(b.Int1, 0)
                      + isnull(b.Int2, 0)
                      + isnull(b.Int3, 0)
                      + isnull(b.Int4, 0)
                      + isnull(b.Int5, 0)
                      + isnull(b.Int6, 0)
                      + isnull(b.Int7, 0)
                      + isnull(b.Int8, 0)
                      + isnull(b.Int9, 0)
                      + isnull(b.Int10, 0)
                      + isnull(b.Int11, 0)
                      + isnull(b.Int12, 0)
                      + isnull(b.Int13, 0)
                      + isnull(b.Int14, 0)
                      + isnull(b.Int15, 0)
                      + isnull(b.Int16, 0)
                      + isnull(b.Int17, 0)
                      + isnull(b.Int18, 0)
                      + isnull(b.Int19, 0)
                      + isnull(b.Int20, 0)
                      + isnull(b.Int21, 0)
                      + isnull(b.Int22, 0)
                      + isnull(b.Int23, 0)
                      + isnull(b.Int24, 0)
                    else 0
              end),
          sum(case when UsageMonth = 11
                   then isnull(b.Int1, 0)
                      + isnull(b.Int2, 0)
                      + isnull(b.Int3, 0)
                      + isnull(b.Int4, 0)
                      + isnull(b.Int5, 0)
                      + isnull(b.Int6, 0)
                      + isnull(b.Int7, 0)
                      + isnull(b.Int8, 0)
                      + isnull(b.Int9, 0)
                      + isnull(b.Int10, 0)
                      + isnull(b.Int11, 0)
                      + isnull(b.Int12, 0)
                      + isnull(b.Int13, 0)
                      + isnull(b.Int14, 0)
                      + isnull(b.Int15, 0)
                      + isnull(b.Int16, 0)
                      + isnull(b.Int17, 0)
                      + isnull(b.Int18, 0)
                      + isnull(b.Int19, 0)
                      + isnull(b.Int20, 0)
                      + isnull(b.Int21, 0)
                      + isnull(b.Int22, 0)
                      + isnull(b.Int23, 0)
                      + isnull(b.Int24, 0)
                    else 0
              end),
          sum(case when UsageMonth = 12
                   then isnull(b.Int1, 0)
                      + isnull(b.Int2, 0)
                      + isnull(b.Int3, 0)
                      + isnull(b.Int4, 0)
                      + isnull(b.Int5, 0)
                      + isnull(b.Int6, 0)
                      + isnull(b.Int7, 0)
                      + isnull(b.Int8, 0)
                      + isnull(b.Int9, 0)
                      + isnull(b.Int10, 0)
                      + isnull(b.Int11, 0)
                      + isnull(b.Int12, 0)
                      + isnull(b.Int13, 0)
                      + isnull(b.Int14, 0)
                      + isnull(b.Int15, 0)
                      + isnull(b.Int16, 0)
                      + isnull(b.Int17, 0)
                      + isnull(b.Int18, 0)
                      + isnull(b.Int19, 0)
                      + isnull(b.Int20, 0)
                      + isnull(b.Int21, 0)
                      + isnull(b.Int22, 0)
                      + isnull(b.Int23, 0)
                      + isnull(b.Int24, 0)
                    else 0
              end),
          sum(case when UsageMonth = 1
                   then isnull(a.Peak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 2
                   then isnull(a.Peak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 3
                   then isnull(a.Peak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 4
                   then isnull(a.Peak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 5
                   then isnull(a.Peak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 6
                   then isnull(a.Peak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 7
                   then isnull(a.Peak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 8
                   then isnull(a.Peak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 9
                   then isnull(a.Peak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 10
                   then isnull(a.Peak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 11
                   then isnull(a.Peak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 12
                   then isnull(a.Peak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 1
                   then isnull(a.OffPeak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 2
                   then isnull(a.OffPeak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 3
                   then isnull(a.OffPeak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 4
                   then isnull(a.OffPeak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 5
                   then isnull(a.OffPeak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 6
                   then isnull(a.OffPeak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 7
                   then isnull(a.OffPeak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 8
                   then isnull(a.OffPeak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 9
                   then isnull(a.OffPeak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 10
                   then isnull(a.OffPeak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 11
                   then isnull(a.OffPeak, 0)
                   else 0
              end),
          sum(case when UsageMonth = 12
                   then isnull(a.OffPeak, 0)
                   else 0
              end)              
   from #ISOFOrecast a with (nolock index = idx_#ISOFOrecast)
   inner join (select b.*
               from (select ID                     = max(b.ID),
                            b.MTMAccountID,
                            b.UsageDate
                     from #WholesaleDuplicate a (nolock)
                     inner join lp_MtM.dbo.MtMDailyWholesaleLoadForecast b with (nolock)
                     on  a.ID                      = b.MTMAccountID
                     group by b.MTMAccountID,
                              b.UsageDate) a
               inner join lp_MtM.dbo.MtMDailyWholesaleLoadForecast b with (nolock)
               on  a.ID                           = b.ID
               and a.MTMAccountID                 = b.MTMAccountID
               and a.UsageDate                    = b.UsageDate) b
   on  a.ID                                       = b.MTMAccountID
   and a.SearchActualStartDate               is not null
   and b.UsageDate                                >= a.SearchActualStartDate 
   and b.UsageDate                                <= a.SearchActualEndDate
end

insert into RECONEDI_ForecastWholesaleError
select *,
       'NULL'     
from #WholesaleNull

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_ISOProcess]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_RECONEDI_ISOProcess]
(@p_ISO                                            varchar(50),
 @p_Process                                        char(01))
as

truncate table RECONEDI_ISOProcess

if @p_Process                                      = 'F'
begin
   insert into RECONEDI_ISOProcess
   select distinct ISO
   from dbo.RECONEDI_Filter (nolock)
   return
end

if  @p_Process                                    in ('T', 'I')
and @p_ISO                                         = '*'
begin
   insert into RECONEDI_ISOProcess
   select distinct Wholesalemktid
   from Libertypower.dbo.Utility with (nolock)
   where InactiveInd                               = 0
   return
end

if  @p_Process                                    in ('T', 'I')
and @p_ISO                                        <> '*'
begin
   insert into RECONEDI_ISOProcess
   select distinct Wholesalemktid
   from Libertypower.dbo.Utility with (nolock)
   where Wholesalemktid                            = @p_ISO
   and   InactiveInd                               = 0
   return
end



GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_ListReconciliationHeader]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 01/24/2014
-- Description:	List all reconciliation header
-- =============================================
CREATE PROCEDURE [dbo].[usp_RECONEDI_ListReconciliationHeader]
	@p_headerId AS BIGINT = NULL
AS
BEGIN
	SET NOCOUNT ON;

    SELECT * FROM RECONEDI_Header A (NOLOCK)
    WHERE REHID = ISNULL(@p_headerId, REHID)
	
	SET NOCOUNT OFF;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_ListTrackingByHeaderId]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[usp_RECONEDI_ListTrackingByHeaderId]
	@p_headerId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM RECONEDI_Tracking A (NOLOCK) WHERE A.REHID = @p_headerId
	
	SET NOCOUNT OFF;
END

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_MTM]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_RECONEDI_MTM] 
(@p_ISO                                            varchar(50),
 @p_ProcessDate                                    datetime,
 @p_Process                                        char(01) = 'F')
as


/******** Utility ********/

declare @Utility table                        
(Utility                                           varchar(50) primary key clustered)


if @p_Process                                      = 'F'
begin
   insert into @Utility
   select distinct Utility
   from dbo.RECONEDI_Filter (nolock)
   where ISO                                       = @p_ISO
end

if @p_Process                                     in ('T', 'I')
begin

   insert into @Utility
   select distinct UtilityCode
   from Libertypower.dbo.Utility with (nolock)
   where InactiveInd = 0
   and   WholeSaleMktID                            = @p_ISO
end

delete c
from @Utility a
inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx2_RECONEDI_EnrollmentFixed)
on  a.Utility                                      = b.Utility
inner join dbo.RECONEDI_MTM c with (nolock index = idx_RECONEDI_MTM) 
on  b.ENID                                         = c.ENID   
--Without Filter
where ((@p_Process                                in ('T', 'I'))
--Filter
or     (@p_Process                                 = 'F'
and     exists(select null
               from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
               where z.Utility                     = b.Utility
               and   z.AccountNumber               = b.AccountNumber)))

declare @w_Forecast                                datetime

select @w_Forecast                                 = Forecast
from dbo.RECONEDI_ISOControl               
where ISO                                          = @p_ISO

/******** Temporal Account ********/

create table #Account
(ENID                                              int,
 AccountID                                         int,
 ContractID                                        int)
 
create index idx_#Account on #Account
(AccountID,
 ContractID) 

insert into #Account
select distinct
       b.ENID,
       b.AccountID,
       b.ContractID
from @Utility a
inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx1_RECONEDI_EnrollmentFixed)
on  a.Utility                                     = b.Utility
--Without Filter
where ((@p_Process                               in ('T', 'I'))
--Filter
or     (@p_Process                                = 'F'
and     exists(select null
               from dbo.RECONEDI_Filter z with (nolock index = idx_RECONEDI_Filter)
               where z.Utility                    = b.Utility
               and   z.AccountNumber              = b.AccountNumber)))

/******** Temporal MTMAccount ********/

create table #MTMAccount
(ENID                                              int,
 AccountID                                         int,
 ContractID                                        int,
 DateCreated                                       datetime)
 
create index idx_#MTMAccount on #MTMAccount
(AccountID,
 ContractID) 

insert into #MTMAccount
select a.ENID,
       a.AccountID,
       a.ContractID,
       DateCreated                                 = max(b.DateCreated)
from #Account a with (nolock index = idx_#Account)
inner join lp_MtM.dbo.MtMAccount b with (nolock)
on  a.AccountID                                    = b.AccountID
and a.ContractID                                   = b.ContractID
group by a.ENID,
         a.AccountID,
         a.ContractID

create table #MTM
(ENID                                              bigint,
 ID                                                int,
 BatchNumber                                       varchar(50),
 QuoteNumber                                       varchar(50),
 AccountID                                         int,
 ContractID                                        int,
 Zone                                              varchar(50),
 LoadProfile                                       varchar(50),
 ProxiedZone                                       bit,
 ProxiedProfile                                    bit,
 ProxiedUsage                                      bit,
 MeterReadCount                                    int,
 Status                                            varchar(50),
 DateCreated                                       datetime,
 CreatedBy                                         varchar(50),
 DateModified                                      datetime)

create clustered index idx_#MTM on #MTM
(AccountID,
 ContractID)

insert into #MTM
select a.ENID,
       b.ID,
       b.BatchNumber,
       b.QuoteNumber,
       b.AccountID,
       b.ContractID,
       b.Zone,
       b.LoadProfile,
       null,--b.ProxiedZone,
       b.ProxiedProfile,
       b.ProxiedUsage,
       b.MeterReadCount,
       b.Status,
       b.DateCreated,
       b.CreatedBy,
       b.DateModified   
from #MTMAccount a with (nolock index = idx_#MTMAccount)
left join lp_MtM.dbo.MtMAccount b (nolock)
on  a.AccountID                                    = b.AccountID  
and a.ContractID                                   = b.ContractID
and a.DateCreated                                  = b.DateCreated

/******** Changes ********/

if @p_Process                                      = 'I'
begin

   insert into dbo.RECONEDI_Filter
   select distinct
          b.ISO,
          b.Utility,
          b.AccountNumber,
          ''
   from @Utility a 
   inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx2_RECONEDI_EnrollmentFixed)
   on  a.Utility                                   = b.Utility
   inner join dbo.RECONEDI_MTM c with (nolock index = idx_RECONEDI_MTM) 
   on  b.ENID                                      = c.ENID   
   inner join #MTM d with (nolock index = idx_#MTM)
   on  c.AccountID                                 = d.AccountID
   and c.ContractID                                = d.ContractID
   where ((c.ID                                    <> d.ID)
   or     (c.ID                                 is null
   and     d.ID                             is not null)
   or     (c.ID                             is not null
   and     d.ID                                 is null))
   and   not exists (select null
                     from dbo.RECONEDI_Filter e with (nolock index = idx1_RECONEDI_Filter)
                     where e.ISO                   = b.ISO
                     and   e.Utility               = b.Utility
                     and   e.AccountNumber         = b.AccountNumber)
  
  insert into dbo.RECONEDI_Filter 
  select distinct
          a.ISO,
          a.Utility,
          a.AccountNumber,
          ''
   from dbo.RECONEDI_EnrollmentFixed a with (nolock)
   inner join #MTM b with (nolock index = idx_#MTM)
   on  a.AccountID                                 = b.AccountID
   and a.ContractID                                = b.ContractID
   where (b.DateCreated                            > @w_Forecast
   or     b.DateModified                           > @w_Forecast)
   and   not exists (select null
                     from dbo.RECONEDI_Filter e with (nolock index = idx1_RECONEDI_Filter)
                     where e.ISO                   = a.ISO
                     and   e.Utility               = a.Utility
                     and   e.AccountNumber         = a.AccountNumber)
end

/******** MTM ********/

insert into dbo.RECONEDI_MTM
select a.ENID,
       a.ID,
       a.BatchNumber,
       a.QuoteNumber,
       a.AccountID,
       a.ContractID,
       a.Zone,
       a.LoadProfile,
       a.ProxiedZone,
       a.ProxiedProfile,
       a.ProxiedUsage,
       a.MeterReadCount,
       a.Status,
       a.DateCreated,
       a.CreatedBy,
       a.DateModified   
from #MTM a with (nolock)

update dbo.RECONEDI_ISOControl set Forecast = @p_Processdate                 
where ISO                                          = @p_ISO
and   @P_Processdate                               > Forecast

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_Process]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_RECONEDI_Process 'CAISO', '*', 'FIXED', '*', 'T', '20140313', '20140313', '20140313', 1, 1, 1, 
CREATE procedure [dbo].[usp_RECONEDI_Process]
(@p_ISO                                            varchar(50),
 @p_Utility                                        varchar(50),
 @p_ProductCategory                                varchar(50),
 @p_ProcessType                                    varchar(50),
 @p_Process                                        char(1),
 @p_ReconProcessDate                               datetime,
 @p_ReconSubmitDate                                datetime,
 @p_ReconAccountChangeDate                         datetime,
 @p_MTMStep                                        bit,
 @p_EDIResultStep                                  bit,
 @p_ForecastStep                                   bit,
 @p_REHID                                          bigint)
as

update dbo.RECONEDI_Header set STID = 2,
                               Notes = ''
where REHID                                        = @p_REHID                            

insert into dbo.RECONEDI_Tracking
select @p_REHID,
       @p_ISO,
       '',
       'Start - ISO Process ',
       getdate(),
       'usp_RECONEDI_Process'

declare @w_Return                                  int

declare @w_ControlDate                             datetime
select @w_ControlDate                              = getdate()

declare @w_UID                                     int
declare @w_UCriteria                               varchar(80)
declare @t_UID                                     int

if @p_MTMStep                                      = 1
begin

   select @w_Return                                = 0

   update dbo.RECONEDI_Header set STID = 2,
                                  Notes = 'MTM Process - '
                                        + ltrim(rtrim(@p_ISO))
   where REHID                                     = @p_REHID                            

   insert into dbo.RECONEDI_Tracking
   select @p_REHID,
          @p_ISO,
          '',
          'Start - MTM Process',
          getdate(),
          'usp_RECONEDI_MTM'

   exec @w_return                                  = usp_RECONEDI_MTM @p_ISO,
                                                                      @p_ReconProcessDate,
                                                                      @p_Process

   if @w_Return                                   <> 0
   begin
      update dbo.RECONEDI_Header set STID = 4,
                                     Notes = 'MTM Process - '
                                           + ltrim(rtrim(@p_ISO))
      where REHID                                  = @p_REHID                            

      insert into dbo.RECONEDI_Tracking
      select @p_REHID,
             @p_ISO,
             '',
             'Error - MTM Process',
             getdate(),
             'usp_RECONEDI_MTM'
      return
   end

   insert into dbo.RECONEDI_Tracking
   select @p_REHID,
          @p_ISO,
          '',
          'End - MTM Process',
          getdate(),
          'usp_RECONEDI_MTM'

end

if @p_EDIResultStep                                = 1
begin

   select @w_Return                                = 0

   update dbo.RECONEDI_Header set STID = 2,
                                  Notes = 'Utility Process'
   where REHID                                     = @p_REHID                            

   insert into dbo.RECONEDI_Tracking
   select @p_REHID,
          @p_ISO,
          '',
          'Start - Utility Process',
          getdate(),
          'usp_RECONEDI_UtilityProcess'
                                                                                                
   exec @w_return                                  = dbo.usp_RECONEDI_UtilityProcess @p_ISO,
                                                                                     @p_Utility,
                                                                                     @p_Process

   if @w_Return                                   <> 0
   begin
      update dbo.RECONEDI_Header set STID = 4,
                                     Notes = 'Utility Process'
      where REHID                                  = @p_REHID                            

      insert into dbo.RECONEDI_Tracking
      select @p_REHID,
             @p_ISO,
             '',
            'Error - Utility Process',
             getdate(),
             'usp_RECONEDI_UtilityProcess'
      return
   end

   insert into dbo.RECONEDI_Tracking
   select @p_REHID,
          @p_ISO,
          '',
          'End - Utility Process',
          getdate(),
          'usp_RECONEDI_UtilityProcess'

   select @t_UID                                   = 0

   set rowcount 1

   select @w_UID                                   = ID,
          @w_UCriteria                             = Criteria
   from RECONEDI_UtilityProcess (nolock)
   where ID                                        > @t_UID

   while @@rowcount                               <> 0
   begin
      set rowcount 0
   
      select @t_UID                                = @w_UID
	   
      select @w_Return                             = 0

      update dbo.RECONEDI_Header set STID = 2,
                                        Notes = 'EdiResult Process - '
                                              + ltrim(rtrim(@w_UCriteria))
      where REHID                                  = @p_REHID                            

      insert into dbo.RECONEDI_Tracking
      select @p_REHID,
             @p_ISO,
             @w_UCriteria,
             'Start - EdiResult Process',
             getdate(),
             'usp_RECONEDI_EdiPending'

      exec @w_return                               = usp_RECONEDI_EdiPending @w_UCriteria,
                                                                             @p_ReconProcessDate,
                                                                             @w_ControlDate,
                                                                             @p_ReconAccountChangeDate,
                                                                             @p_Process

      if @w_Return                                <> 0
      begin
         
         update dbo.RECONEDI_Header set STID = 4,
                                        Notes = 'EdiResult Process - '
                                              + ltrim(rtrim(@w_UCriteria))
         where REHID                              = @p_REHID                            

         insert into dbo.RECONEDI_Tracking
         select @p_REHID,
                @p_ISO,
                @w_UCriteria,
                'Error - EdiResult Process',
                getdate(),
                'usp_RECONEDI_EdiPending'
         return
      end

      insert into dbo.RECONEDI_Tracking
      select @p_REHID,
             @p_ISO,
             @w_UCriteria,
             'End - EdiResult Process',
             getdate(),
             'usp_RECONEDI_EdiPending'

      set rowcount 1

      select @w_UID                                = ID,
             @w_UCriteria                          = Criteria
      from RECONEDI_UtilityProcess (nolock)
      where ID                                     > @t_UID
   end
end

set rowcount 0

if  @p_EDIResultStep                               = 1
and (@p_Process                                    = 'T'
or   @p_Process                                    = 'I')
begin

   select @w_Return                                = 0

   update dbo.RECONEDI_Header set STID = 2,
                                  Notes = 'Account Change Process - '
                                        + ltrim(rtrim(@p_ISO))
   where REHID                                     = @p_REHID                            

   insert into dbo.RECONEDI_Tracking
   select @p_REHID,
          @p_ISO,
          '',
          'Start - Account Change Process',
          getdate(),
          'usp_RECONEDI_AccountChange'

   exec @w_return                                  = usp_RECONEDI_AccountChange @w_UCriteria,
                                                                                @p_ReconAccountChangeDate

   if @w_Return                                   <> 0
   begin
      update dbo.RECONEDI_Header set STID = 4,
                                     Notes = 'EdiResult Process - '
                                           + ltrim(rtrim(@p_ISO))
      where REHID                                  = @p_REHID                            

      insert into dbo.RECONEDI_Tracking
      select @p_REHID,
             @p_ISO,
             '',
             'Error - Account Change Process',
             getdate(),
             'usp_RECONEDI_AccountChange'
      return
   end

   insert into dbo.RECONEDI_Tracking
   select @p_REHID,
          @p_ISO,
          '',
          'End - Account Change Process',
          getdate(),
          'usp_RECONEDI_AccountChange'

   set rowcount 1

   select @w_UID                                   = ID,
          @w_UCriteria                             = Criteria
   from RECONEDI_UtilityProcess (nolock)
   where ID                                        > @t_UID

end

if @p_ForecastStep                              = 1
begin

   select @w_Return                             = 0

   update dbo.RECONEDI_Header set STID = 2,
                                  Notes = 'Forecast Process - '
                                        + ltrim(rtrim(@p_ISO))
   where REHID                                  = @p_REHID                            

   insert into dbo.RECONEDI_Tracking
   select @p_REHID,
          @p_ISO,
          '',
          'Start - Forecast Process',
          getdate(),
          'usp_RECONEDI_Forecast'
                                                                                                
   exec @w_return                                  = dbo.usp_RECONEDI_Forecast @p_ISO,
                                                                               @p_ReconProcessDate,
                                                                               @p_Process

   if @w_Return                                   <> 0
   begin
      update dbo.RECONEDI_Header set STID = 4,
                                     Notes = 'Forecast Process - '
                                           + ltrim(rtrim(@p_ISO))
      where REHID                                  = @p_REHID                            

      insert into dbo.RECONEDI_Tracking
      select @p_REHID,
             @p_ISO,
             '',
             'Error - Forecast Process',
             getdate(),
             'usp_RECONEDI_Forecast'
      return
   end

   insert into dbo.RECONEDI_Tracking
   select @p_REHID,
          @p_ISO,
          '',
          'End - Forecast Process',
          getdate(),
          'usp_RECONEDI_Forecast'

end

insert into dbo.RECONEDI_Tracking
select @p_REHID,
       @p_ISO,
       '',
       'End - ISO Process',
       getdate(),
       'usp_RECONEDI_Process'

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_ProcessHeader]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_RECONEDI_Process 'MISO', '*', '*', '*', 'T', '20140101', '20140101', '20140101', 1, 1, 0, 1, 1
CREATE procedure [dbo].[usp_RECONEDI_ProcessHeader]
(@p_ISO                                            varchar(50),
 @p_Utility                                        varchar(50),
 @p_ProductCategory                                varchar(50),
 @p_ProcessType                                    varchar(50),
 @p_Process                                        char(1),
 @p_ReconProcessDate                               datetime,
 @p_ReconSubmitDate                                datetime,
 @p_ReconAccountChangeDate                         datetime,
 @p_EnrollmentStep                                 bit,
 @p_MTMStep                                        bit,
 @p_EDIStep                                        bit,
 @p_EDIResultStep                                  bit,
 @p_ForecastStep                                   bit,
 @p_REHID                                          bigint output)
as

insert into dbo.RECONEDI_Header
select @p_ISO,
       @p_Utility,
       @p_ProductCategory,
       @p_ProcessType,
       @p_Process,
       @p_ReconProcessDate,
       @p_ReconSubmitDate,
       @p_ReconAccountChangeDate,
       @p_EnrollmentStep,
       @p_MTMStep,
       @p_EDIStep,
       @p_EDIResultStep,
       @p_ForecastStep,
       1,
       '',
       getdate()

select @p_REHID                                    = @@IDENTITY

insert into dbo.RECONEDI_Tracking
select @p_REHID,
       '',
       '',
       'Start - Process',
       getdate(),
       'usp_RECONEDI_ProcessHeader'

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_ProcessHeaderEnd]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_RECONEDI_Process 'MISO', '*', '*', '*', 'T', '20140101', '20140101', '20140101', 1, 1, 0, 1, 1
CREATE procedure [dbo].[usp_RECONEDI_ProcessHeaderEnd]
(@p_REHID                                          bigint output)
as

insert into dbo.RECONEDI_Tracking
select @p_REHID,
       '',
       '',
       'End - Process',
       getdate(),
       'usp_RECONEDI_ProcessHeader'


update dbo.RECONEDI_Header set STID = 3,
                               Notes = ''
where REHID                                        = @p_REHID                            

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_SelectAfter]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[usp_RECONEDI_SelectAfter]
(@p_ProductCategory                                varchar(50))
 as

if @p_ProductCategory                              = 'FIXED'
begin
   select ProcessType,
          ISO,
          AccountID,
          AccountType,
          Utility,
          AccountNumber,
          ContractID,
          ContractNumber,
          Term,
          Status,
          SubStatus,
          BeginDate,
          EndDate,
          ContractStartDate,
          ContractEndDate,
          ContractRateStart,
          ContractRateEnd,
          LastServiceStartDate,
          LastServiceEndDate,
          ServiceStartDate,
          ServiceEndDate,
          CriteriaStartDate,
          CriteriaEndDate,
          CriteriaStatus,
          SubmitDate,
          Zone,
          ContractStatusID,
          ProductID,
          ProductCategory,
          ProductSubCategory,
          RateID,
          Rate,
          IsContractedRate,
          PricingRequestID,
          BackToBack,
          AnnualUsage,
          InvoiceID,
          InvoiceFromDate,
          InvoiceToDate,
          OverlapType,
          OverlapDays,
          ProcessDate,
          ControlDate,
          DateProcessed
   from dbo.RECONEDI_EnrollmentFixed with (nolock index = PK_RECONEDI_EnrollmentFixed)

   select *
   from dbo.RECONEDI_ISOControl (nolock)

   select *
   from dbo.RECONEDI_EDIPending with (nolock index = idx_RECONEDI_EDIPending)

   select * 
   from dbo.RECONEDI_EnrollmentIncremental with (nolock index = idx_RECONEDI_EnrollmentIncremental)

end

if @p_ProductCategory                              = 'VARIABLE'
begin
   select ProcessType,
          ISO,
          AccountID,
          AccountType,
          Utility,
          AccountNumber,
          ContractID,
          ContractNumber,
          Term,
          Status,
          SubStatus,
          BeginDate,
          EndDate,
          ContractStartDate,
          ContractEndDate,
          ContractRateStart,
          ContractRateEnd,
          LastServiceStartDate,
          LastServiceEndDate,
          ServiceStartDate,
          ServiceEndDate,
          CriteriaStartDate,
          CriteriaEndDate,
          CriteriaStatus,
          SubmitDate,
          Zone,
          ContractStatusID,
          ProductID,
          ProductCategory,
          ProductSubCategory,
          RateID,
          Rate,
          IsContractedRate,
          PricingRequestID,
          BackToBack,
          AnnualUsage,
          InvoiceID,
          InvoiceFromDate,
          InvoiceToDate,
          OverlapType,
          OverlapDays,
          ProcessDate,
          ControlDate,
          DateProcessed
   from dbo.RECONEDI_EnrollmentVariable with (nolock index = PK_RECONEDI_EnrollmentVariable)

   select *
   from dbo.RECONEDI_ISOControl (nolock)
   where 1                                         = 2

   select *
   from dbo.RECONEDI_EDIPending with (nolock index = idx_RECONEDI_EDIPending)
   where 1                                         = 2

   select * 
   from dbo.RECONEDI_EnrollmentIncremental with (nolock index = idx_RECONEDI_EnrollmentIncremental)
   where 1                                         = 2

end

select ISO,
       Utility,
       AccountNumber,
       Action
from dbo.RECONEDI_Filter with (nolock index = PK_RECONEDI_Filter)

select REHID,
       ISO,
       Utility,
       StepName,
       StepDate,
       Notes
from dbo.RECONEDI_Tracking with (nolock index = PK_RECONEDI_Tracking)
GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_SelectBefore]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec usp_RECONEDI_SelectBefore 'CAISO', '*', 'FIXED', 'F', 0, 0
CREATE procedure [dbo].[usp_RECONEDI_SelectBefore]
(@p_ISO                                            varchar(50),
 @p_ProcessType                                    varchar(50),
 @p_ProductCategory                                varchar(50),
 @p_Process                                        char(01),
 @p_EnrollmentStep                                 bit,
 @p_EDIStep                                        bit)
as
/******** Utility ********/

declare @Utility table                        
(Utility                                           varchar(50) primary key clustered)

if @p_Process                                      = 'F'
begin
   insert into @Utility
   select distinct Utility
   from dbo.RECONEDI_Filter (nolock)   
   where ISO                                       = @p_ISO

end

if @p_Process                                     in ('T', 'I')
begin
   insert into @Utility
   select distinct UtilityCode
   from Libertypower.dbo.Utility with (nolock)
   where InactiveInd                               = 0
   and   WholeSaleMktID                            = @p_ISO
end

if  @p_ProductCategory                             = 'FIXED'
begin

   select b.*
   from @Utility a
   inner join dbo.RECONEDI_EnrollmentFixed b with (nolock index = idx_RECONEDI_EnrollmentFixed)
   on  a.Utility                                   = b.Utility
--Without Filter
   where @p_Process                                = 'I'
   and  (b.ProcessType                             = @p_ProcessType
   or    @p_ProcessType                            = '*')
   and  @p_EnrollmentStep                          = 1

   select *
   from RECONEDI_ISOControl (nolock)
   where (ISO                                      = @p_ISO
   or     ISO                                     is null)
   and   @p_EDIStep                                = 1
end

if  @p_ProductCategory                             = 'VARIABLE'
begin
   select b.*
   from @Utility a
   inner join dbo.RECONEDI_EnrollmentVariable b with (nolock index = idx_RECONEDI_EnrollmentVariable)
   on  a.Utility                                   = b.Utility
   where 1                                         = 2

   select *
   from RECONEDI_ISOControl (nolock)
   where 1                                         = 2

end

select b.*
from @Utility a
inner join dbo.RECONEDI_Filter b with (nolock index = idx_RECONEDI_Filter)
on  a.Utility                                      = b.Utility
where @p_Process                                   = 'F'

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_Truncate]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_RECONEDI_Truncate]
as

truncate table dbo.RECONEDI_EnrollmentFixed
truncate table dbo.RECONEDI_EnrollmentVariable
truncate table dbo.RECONEDI_EnrollmentIncremental
truncate table dbo.RECONEDI_EnrollmentChanges

truncate table dbo.RECONEDI_ISOControl

truncate table dbo.RECONEDI_EDI
truncate table dbo.RECONEDI_EDIPending
truncate table dbo.RECONEDI_EDIResult
truncate table dbo.RECONEDI_EDIPending_Work

truncate table dbo.RECONEDI_MTM

truncate table dbo.RECONEDI_ForecastDates
truncate table dbo.RECONEDI_ForecastDaily
truncate table dbo.RECONEDI_ForecastWholesale
truncate table dbo.RECONEDI_ForecastWholesaleError

truncate table dbo.RECONEDI_ISOProcess
truncate table dbo.RECONEDI_UtilityProcess

truncate table dbo.RECONEDI_Filter
truncate table dbo.RECONEDI_Tracking
truncate table dbo.RECONEDI_Header

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_Update]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[usp_RECONEDI_Update]
(@p_ISO                                            varchar(50),
 @p_ProcessType                                    varchar(50),
 @p_ProductCategory                                varchar(50),
 @p_Process                                        char(01),
 @p_ControlDate                                    datetime,
 @p_EnrollmentStep                                 bit,
 @p_EDIStep                                        bit)
as

if  @p_ProductCategory                             = 'FIXED'
and @p_Process                                     = 'I'
and @p_EnrollmentStep                              = 1
begin
   update a set ProcessType = b.ProcessType,
                ISO = b.ISO,
                AccountID = b.AccountID,
                AccountType = b.AccountType,
                Utility = b.Utility,
                AccountNumber = b.AccountNumber,
                ContractID = b.ContractID,
                ContractNumber = b.ContractNumber,
                Term = b.Term,
                Status = b.Status,
                SubStatus = b.SubStatus,
                BeginDate = b.BeginDate,
                EndDate = b.EndDate,
                ContractStartDate = b.ContractStartDate,
                ContractEndDate = b.ContractEndDate,
                ContractRateStart = b.ContractRateStart,
                ContractRateEnd = b.ContractRateEnd,
                LastServiceStartDate = b.LastServiceStartDate,
                LastServiceEndDate = b.LastServiceEndDate,
                ServiceStartDate = b.ServiceStartDate,
                ServiceEndDate = b.ServiceEndDate,
                CriteriaStartDate = b.CriteriaStartDate,
                CriteriaEndDate = b.CriteriaEndDate,
                CriteriaStatus = b.CriteriaStatus,
                SubmitDate = b.SubmitDate,
                Zone = b.Zone,
                ContractStatusID = b.ContractStatusID,
                ProductID = b.ProductID,
                ProductCategory = b.ProductCategory,
                ProductSubCategory = b.ProductSubCategory,
                RateID = b.RateID,
                Rate = b.Rate,
                IsContractedRate = b.IsContractedRate,
                PricingRequestID = b.PricingRequestID,
                BackToBack = b.BackToBack,
                AnnualUsage = b.AnnualUsage,
                InvoiceID = b.InvoiceID,
                InvoiceFromDate = b.InvoiceFromDate,
                InvoiceToDate = b.InvoiceToDate,
                OverlapType = b.OverlapType,
                OverlapDays = b.OverlapDays,
                ProcessDate = b.ProcessDate,
                ControlDate = b.ControlDate
   from dbo.RECONEDI_EnrollmentFixed a with (nolock index = PK_RECONEDI_EnrollmentFixed)
   inner join dbo.RECONEDI_EnrollmentIncremental b with (nolock index = idx2_RECONEDI_EnrollmentIncremental)
   on  a.ENID                                      = b.ENID
   where b.ISO                                     = @p_ISO
   and   b.ControlDate                             = @p_ControlDate
   and   b.Action                                  = 'U'
end


GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_UpdateHeaderStatus]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_RECONEDI_UpdateHeaderStatus]
(@p_Status                                         int,
 @p_REHID                                          bigint)
as

update dbo.RECONEDI_Header set STID = 2,
                               Notes = ''
where REHID                                        = @p_REHID                            

GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_UtilityProcess]    Script Date: 3/19/2014 8:57:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_RECONEDI_UtilityProcess]
(@p_ISO                                            varchar(50),
 @p_Utility                                        varchar(50),
 @p_Process                                        char(01))
as

truncate table RECONEDI_UtilityProcess

if @p_Process                                     in ('F', 'I')
begin
   insert into RECONEDI_UtilityProcess
   select distinct Utility
   from dbo.RECONEDI_Filter (nolock)
   where ISO                                       = @p_ISO
   return
end

if  @p_Process                                    in ('T')
and @p_Utility                                     = '*'
begin
   insert into RECONEDI_UtilityProcess
   select distinct UtilityCode
   from Libertypower.dbo.Utility with (nolock)
   where InactiveInd                               = 0
   and   Wholesalemktid                            = @p_ISO 
   return
end

if  @p_Process                                    in ('T')
and @p_Utility                                    <> '*'
begin
   insert into RECONEDI_UtilityProcess
   select @p_Utility
   return
end

GO
