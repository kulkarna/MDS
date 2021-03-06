/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_ISORisk]    Script Date: 6/20/2014 4:29:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_ISORisk
 * Create EDI Information from Risk Information. 
 * (Use only when run for the first time)
 * History
 *******************************************************************************
 * 2014/04/01 - William Vilchez
 * Created.
 *******************************************************************************
 * <Date Modified,date,> - <Developer Name,,>
 * <Modification Description,,>
 *******************************************************************************
 */
CREATE procedure [dbo].[usp_RECONEDI_ISORisk]
(@p_ISO                                            varchar(50),
 @p_UtilityCode                                    varchar(50),
 @p_ProcessDate                                    datetime)
as
set nocount on

truncate table  dbo.RECONEDI_NYISORisk

insert into dbo.RECONEDI_NYISORisk
select distinct a.*
from (select ISO                                   = @p_ISO,
             Esiid                                 = ltrim(rtrim(Account_Number)),
             UtilityCode                           = utility_id,
             TdspDuns                              = null,
             TdspName                              = null,
             TransactionType                       = 'E',
             TransactionStatus                     = 'A',
             Direction                             = null,
             ChangeReason                          = null,
             ChangeDescription                     = null,                                                                  
             TransactionDate                       = convert(datetime, enroll_date, 101),
             TransactionEffectiveDate              = convert(datetime, enroll_date, 101),          
             EsiIdStartDate                        = null,
             EsiIdEndDate                          = null,
             SpecialReadSwitchDate                 = null,
             EntityName                            = null,
             MeterNumber                           = null,
             PreviousESiId                         = null,
             LDCBillingCycle                       = null,
             TransactionSetId                      = null,
             TransactionSetControlNbr              = null,
             TransactionSetPurposeCode             = null,
             TransactionNbr                        = null,
             ReferenceNbr                          = null,
             CrDuns                                = null,
             CrName                                = null,
             ProcessFlag                           = null,
             ProcessDate                           = null,
             ServiceTypeCode1                      = null,
             ServiceType1                          = null,
             ServiceTypeCode2                      = null,
             ServiceType2                          = null,
             ServiceTypeCode3                      = null,
             ServiceType3                          = null,
             ServiceTypeCode4                      = null,
             ServiceType4                          = null,
             MaintenanceTypeCode                   = null,
             RejectCode                            = null,
             RejectReason                          = null,
             StatusCode                            = null,
             StatusReason                          = null,
             StatusType                            = null,
             CapacityObligation                    = null,
             TransmissionObligation                = null,
             LBMPZone                              = null,
             PowerRegion                           = null,
             stationid                             = null,
             AssignId                              = null
      from lp_risk..risk_accounts_listing (nolock)
      where status                                 = 'open' 
      and   effective_date                        <= @p_ProcessDate
      union
      select ISO                                   = @p_ISO,
             Esiid                                 = ltrim(rtrim(Account_Number)),
             UtilityCode                           = utility_id,
             TdspDuns                              = null,
             TdspName                              = null,
             TransactionType                       = 'E',
             TransactionStatus                     = 'A',
             Direction                             = null,
             ChangeReason                          = null,
             ChangeDescription                     = null,                                                                  
             TransactionDate                       = convert(datetime, enroll_date, 101),
             TransactionEffectiveDate              = convert(datetime, enroll_date, 101),          
             EsiIdStartDate                        = null,
             EsiIdEndDate                          = null,
             SpecialReadSwitchDate                 = null,
             EntityName                            = null,
             MeterNumber                           = null,
             PreviousESiId                         = null,
             LDCBillingCycle                       = null,
             TransactionSetId                      = null,
             TransactionSetControlNbr              = null,
             TransactionSetPurposeCode             = null,
             TransactionNbr                        = null,
             ReferenceNbr                          = null,
             CrDuns                                = null,
             CrName                                = null,
             ProcessFlag                           = null,
             ProcessDate                           = null,
             ServiceTypeCode1                      = null,
             ServiceType1                          = null,
             ServiceTypeCode2                      = null,
             ServiceType2                          = null,
             ServiceTypeCode3                      = null,
             ServiceType3                          = null,
             ServiceTypeCode4                      = null,
             ServiceType4                          = null,
             MaintenanceTypeCode                   = null,
             RejectCode                            = null,
             RejectReason                          = null,
             StatusCode                            = null,
             StatusReason                          = null,
             StatusType                            = null,
             CapacityObligation                    = null,
             TransmissionObligation                = null,
             LBMPZone                              = null,
             PowerRegion                           = null,
             stationid                             = null,
             AssignId                              = null
      from lp_risk..risk_accounts_listing (nolock)
      where status                                 = 'removed' 
      and   enroll_date                           <= @p_ProcessDate
      and   effective_date                         > @p_ProcessDate) a
where not exists(select Null
                 from RECONEDI_UtilityResult b
                 where b.Esiid                     = a.Esiid
                 and   b.UtilityCode               = @p_UtilityCode                 
                 and   b.TransactionEffectiveDateFrom <= @p_ProcessDate
                 and  (b.TransactionEffectiveDateTo    > @p_ProcessDate
                 or    b.TransactionEffectiveDateTo   is null
                 or    b.TransactionEffectiveDateTo    = '19000101'))      

delete a
from dbo.RECONEDI_NYISORisk a
where exists(select null                        
             from libertypower.. Account b (nolock)
             inner join libertypower.. Utility c (nolock)
             on  b.UtilityID                       = c.ID
             inner join lp_account..account_number_history d (nolock)
             on  b.AccountIDLegacy                 = d.Account_ID
             where b.AccountNumber                 = a.Esiid
             and   c.UtilityCode                   = @p_UtilityCode
             and   exists(select Null
                          from RECONEDI_UtilityResult e
                          where e.Esiid                         = d.old_account_number
                          and   e.UtilityCode                   = @p_UtilityCode                 
                          and   e.IDFrom                   is not null
                          and   e.TransactionEffectiveDateFrom <= @p_ProcessDate
                          and  (e.TransactionEffectiveDateTo    > @p_ProcessDate 
                          or    e.TransactionEffectiveDateTo   is null
                          or    e.TransactionEffectiveDateTo    = '19000101')))  

set nocount off
GO
