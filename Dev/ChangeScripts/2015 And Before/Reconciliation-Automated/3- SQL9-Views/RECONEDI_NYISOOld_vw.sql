/****** Object:  View [dbo].[RECONEDI_NYISOOld_vw]    Script Date: 6/20/2014 4:29:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/******************************************************************************* 
 * RECONEDI_NYISOOld_vw
 * View from the table dbo.RECONEDI_Header table. 
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

CREATE view [dbo].[RECONEDI_NYISOOld_vw]
as
select [814_key]                                   = ROW_NUMBER() OVER (ORDER BY a.ISO),
       a.*
from (select ISO                                   = 'NYISO',
             Esiid                                 = ltrim(rtrim(UtilAcct)),
             UtilityCode                           = case when ltrim(rtrim(Utility)) = 'CONSOLIDATED EDISON OF NEW YORK(006982359)'
                                                          then 'CONED'
                                                          else 'NIMO'
                                                     end,
             TdspDuns                              = null,
             TdspName                              = null,
             TransactionType                       = case when ltrim(rtrim(TrnsType)) = '21'
                                                          and  ltrim(rtrim(TrnsPurp)) = '11'
                                                          and  ltrim(rtrim(Comments)) = 'ACCEPTANCE CONNECTION'
                                                          then 'E'
                                                          when ltrim(rtrim(TrnsType)) = '1'
                                                          and  ltrim(rtrim(TrnsPurp)) = '13'
                                                          then 'C'
                                                          when ltrim(rtrim(TrnsType)) = '24'
                                                          and  ltrim(rtrim(TrnsPurp)) = '11'
                                                          and  ltrim(rtrim(Comments)) = 'ACCEPTANCE CANCELATION'
                                                          then 'D'
                                                          when ltrim(rtrim(TrnsType)) = '24'
                                                          and  ltrim(rtrim(TrnsPurp)) = '13'
                                                          then 'D'
                                                          when ltrim(rtrim(TrnsType)) = '25'
                                                          and  ltrim(rtrim(TrnsPurp)) = '13'
                                                          then 'R'
                                                          else null
                                                     end,
             TransactionStatus                     = case when ltrim(rtrim(TrnsType)) = '21'
                                                          and  ltrim(rtrim(TrnsPurp)) = '11'
                                                          and  ltrim(rtrim(Comments)) = 'ACCEPTANCE CONNECTION'
                                                          then 'A'
                                                          when ltrim(rtrim(TrnsType)) = '1'
                                                          and  ltrim(rtrim(TrnsPurp)) = '13'
                                                          then '7'
                                                          when ltrim(rtrim(TrnsType)) = '24'
                                                          and  ltrim(rtrim(TrnsPurp)) = '11'
                                                          and  ltrim(rtrim(Comments)) = 'ACCEPTANCE CANCELATION'
                                                          then 'A'
                                                          when ltrim(rtrim(TrnsType)) = '24'
                                                          and  ltrim(rtrim(TrnsPurp)) = '13'
                                                          then '7'
                                                          when ltrim(rtrim(TrnsType)) = '25'
                                                          and  ltrim(rtrim(TrnsPurp)) = '13'
                                                          then 'A'
                                                          else null
                                                     end,
             Direction                             = null,
             ChangeReason                          = case when ltrim(rtrim(TrnsType)) = '1'
                                                          and  ltrim(rtrim(TrnsPurp)) = '13'
                                                          then ltrim(rtrim(Reason))
                                                          else null
                                                     end,
             ChangeDescription                     = null,                                                                  
             TransactionDate                       = convert(datetime, TransmissionDate, 101),
             TransactionEffectiveDate              = convert(datetime, TransEffDate, 101),          
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
             TransactionNbr                        = TrackingNumber,
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
      from dbo.RECONEDI_NYISOOld (nolock)
      where isdate(TransmissionDate)               = 1
      and   isdate(TransEffDate)                   = 1) a
where TransactionType                         is not null
and   (a.ChangeReason                             is null 
or     a.ChangeReason                             in ('DTM150','DTM151'))




GO
