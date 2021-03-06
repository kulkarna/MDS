/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_EnrollmentFixed]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_EnrollmentFixed
 * Create Enrollment Account List (Product Category = Fixed)
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
CREATE procedure [dbo].[usp_RECONEDI_EnrollmentFixed]
(@p_ReconID                                        int,
 @p_ISO                                            varchar(50),
 @p_Utility                                        varchar(50),
 @p_AsOfDate                                       date,
 @p_ProcessDate                                    datetime,
 @p_Process                                        char(01) = 'T')
as

set nocount on

/***********************/

exec dbo.usp_RECONEDI_HeaderUpdate @p_ReconID,
                                   3,
								   1

exec dbo.usp_RECONEDI_Tracking @p_ReconID,
                               @p_ISO,
                               @p_Utility,
                               3,
					           1,
							   'Start',
							   'Fixed'

/******** #Enrollment ********/

create table #Enrollment
(EnrollmentID                                      int identity (1, 1) primary key clustered,
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

create index idx_#Enrollment on #Enrollment
(AccountID,
 ContractID)

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
      left join (select distinct 
                        a.InternalRefId,
                        Zone                       = a.InternalRef
                 from LibertyPower.. vw_ExternalEntityMapping a) w2
                 on a.DeliveryLocationRefID        = w2.InternalRefID
      where b.WholesaleMktID                       = @p_ISO
      and  (b.UtilityCode                          = @p_Utility
	  or    @p_Utility                             = '*')
      and   j.ContractStatusID                    in (1, 3)
      and   b.InactiveInd                          = 0
      and   n.Product_Category                     = 'FIXED'
      and   m.IsContractedRate                     = 1
      and   m.RateEnd                              > convert(char(08), @p_AsOfDate, 112)
      and   j.SubmitDate                           < dateadd(dd, 1, @p_AsOfDate)
      and  (((p.pricing_request_id                is not null
      and     len(rtrim(ltrim(p.pricing_request_id))) > 0
      and     n.IsCustom                           = 1))
      or    ((p.pricing_request_id                is null
      or      len(rtrim(ltrim(p.pricing_request_id))) = 0)))
--Without Filter
      and ((@p_Process                       in ('T', 'I'))
--Filter
      or   (@p_Process                        = 'F'
      and   exists(select null
                   from dbo.RECONEDI_Filter z with (nolock)
                   where z.Utility                 = b.UtilityCode
                   and   z.AccountNumber           = a.AccountNumber)))) a
order by a.Utility,
         a.AccountID,
         a.AccountNumber,
         a.ContractID,
         a.ContractRateStart,
         a.SubmitDate

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
inner join #Enrollment zz with (nolock)
on  a.AccountID                                    = zz.AccountID
where j.ContractStatusID                          in (1, 3)
and   b.InactiveInd                                = 0
and   m.IsContractedRate                           = 1
and   m.RateEnd                                   <= convert(char(08), @p_AsOfDate, 112)
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
from #Enrollment a with (nolock)
inner join #Expire b with (nolock)
on  a.AccountID                                    = b.AccountID
and a.ContractID                                   = b.ContractID
and a.Term                                         = b.Term

/*******************************/

exec usp_RECONEDI_EnrollmentCommon @p_AsOfDate

/*******************************/

begin try
   begin transaction

   insert into dbo.RECONEDI_EnrollmentFixed
   select @p_ReconID,
          a.ProcessType,
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
          AsOfDate                                 = @p_AsOfDate,
          ProcessDate                              = @p_ProcessDate,
		  'NEW_ENR',
		  0
   from #Enrollment a with (nolock)

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
   select -1
   return -1
end catch

/***********************/

exec dbo.usp_RECONEDI_Tracking @p_ReconID,
                               @p_ISO,
                               @p_Utility,
                               3,
					           1,
							   'End',
							   'Fixed'
/***********************/

select 0
return 0

set nocount off


GO
