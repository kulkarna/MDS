/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_EnrollmentCommon]    Script Date: 6/20/2014 4:29:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_EnrollmentCommon
 * Collect Enrollment Account List commom information (Fixed/Variable). 
 * (Ista Invoice, Annual Usage, Services Date, overlap date between contracts of the same account id.)
 * History
 *******************************************************************************
 * 2014/04/01 - William Vilchez
 * Created.
 *******************************************************************************
 * <Date Modified,date,> - <Developer Name,,>
 * <Modification Description,,>
 *******************************************************************************
 */
CREATE procedure [dbo].[usp_RECONEDI_EnrollmentCommon]
(@p_AsOfDate                                       datetime)
as

set nocount on

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
on  a.custid                                       = b.custid
inner join Ista.dbo.Consumption c with (NOLOCK) 
on  b.invoiceid                                    = c.invoiceid
inner join Ista.dbo.ConsumptionDetail d with (NOLOCK) 
on  c.consid                                       = d.consid
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
(AccountID                                         int not null primary key clustered,
 AccountIdLegacy                                   char(12))
 
insert into #Account
select distinct a.AccountID,
                a.AccountLegacyID
from #Enrollment a with (nolock)

/******** Services Dates ********/

create table #Services
(AccountID                                         int not null primary key clustered,
 ServiceStartDate                                  Datetime,
 ServiceEndDate                                    Datetime)
 
insert into #Services
select a.AccountID,
       a.ServiceStartDate,
       a.ServiceEndDate
from(select a.AccountID,
            ServiceStartDate                       = max(isnull(b.StartDate, '19000101')),
            ServiceEndDate                         = max(isnull(b.EndDate, '19000101'))
     from #Account a with (nolock) 
     inner join Libertypower.dbo.AccountService b with (nolock)
     on  a.AccountIdLegacy                         = b.account_id
     group by a.AccountID) a

/******** Annual Usages ********/

create table #AnnualUsages
(AccountID                                         int not null primary key clustered,
 AnnualUsage                                       int)

insert into #AnnualUsages
select a.AccountID,
       a.AnnualUsage
from (select a.AccountID,
             a.AnnualUsage
      from Libertypower.dbo.AccountUsage a with (nolock)
      inner join (select a.AccountID,
                         MaxEffectiveDate          = max(b.EffectiveDate)
                  from #Account a with (nolock)
                  inner join Libertypower.dbo.AccountUsage b with (nolock)
                  on  a.AccountID                  = b.AccountID
                  group by a.AccountID) b
      on  a.AccountID                              = b.AccountID
      and a.EffectiveDate                          = b.MaxEffectiveDate) a                

/******** Enrollment Header ********/

update #Enrollment set CriteriaStartDate = case when (len(ltrim(rtrim(LastServiceEndDate ))) = 0
                                                or    LastServiceEndDate                  is null
                                                or    LastServiceEndDate                     = '19000101')
                                                and  ContractRateEnd                         > CONVERT(char(08), @p_AsOfDate, 112)
                                                then ContractRateStart
                                                else case when LastServiceEndDate           <= ContractRateEnd
                                                          and  LastServiceEndDate            > CONVERT(char(08), @p_AsOfDate, 112)
                                                          and  LastServiceEndDate            > ContractRateStart
                                                          then ContractRateStart
                                                          when LastServiceEndDate           <= LastServiceStartDate
                                                          and  ContractRateEnd               > LastServiceStartDate
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_AsOfDate, 112)
                                                          then LastServiceStartDate
                                                          when ContractRateStart            >= LastServiceEndDate
                                                          and  ContractRateEnd               > CONVERT(char(08),@p_AsOfDate, 112)
                                                          then ContractRateStart
                                                          when LastServiceEndDate            > ContractRateEnd
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_AsOfDate, 112)                  
                                                          then ContractRateStart
                                                          else null
                                                     end
                                           end,
                       CriteriaEndDate   = case when (len(ltrim(rtrim(LastServiceEndDate ))) = 0
                                                or    LastServiceEndDate                  is null
                                                or    LastServiceEndDate                     = '19000101')
                                                and  ContractRateEnd                         > CONVERT(char(08), @p_AsOfDate, 112)
                                                then ContractRateEnd
                                                else case when LastServiceEndDate           <= ContractRateEnd
                                                          and  LastServiceEndDate            > CONVERT(char(08), @p_AsOfDate, 112)
                                                          and  LastServiceEndDate            > ContractRateStart
                                                          then ContractRateEnd
                                                          when LastServiceEndDate           <= LastServiceStartDate
                                                          and  ContractRateEnd               > LastServiceStartDate
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_AsOfDate, 112)
                                                          then LastServiceEndDate
                                                          when ContractRateStart            >= LastServiceEndDate
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_AsOfDate, 112)
                                                          then ContractRateEnd
                                                          when LastServiceEndDate            > ContractRateEnd
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_AsOfDate, 112)                  
                                                          then ContractRateEnd
                                                          else null
                                                     end
                                           end,
                       CriteriaStatus    = case when (len(ltrim(rtrim(LastServiceEndDate ))) = 0
                                                or    LastServiceEndDate                  is null
                                                or    LastServiceEndDate                     = '19000101')
                                                and  ContractRateEnd                         > CONVERT(char(08), @p_AsOfDate, 112)
                                                then 'ACTIVE'
                                                else case when LastServiceEndDate           <= ContractRateEnd
                                                          and  LastServiceEndDate            > CONVERT(char(08), @p_AsOfDate, 112)
                                                          and  LastServiceEndDate            > ContractRateStart
                                                          then 'ACTIVE'
                                                          when LastServiceEndDate           <= LastServiceStartDate
                                                          and  ContractRateEnd               > LastServiceStartDate
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_AsOfDate, 112)
                                                          then 'ACTIVE'
                                                          when ContractRateStart            >= LastServiceEndDate
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_AsOfDate, 112)
                                                          then 'ACTIVE'
                                                          when LastServiceEndDate            > ContractRateEnd
                                                          and  ContractRateEnd               > CONVERT(char(08), @p_AsOfDate, 112)                  
                                                          then 'ACTIVE'
                                                          else 'INACTIVE'
                                                     end
                                           end

/******** Forecast Header - Invoice ********/

update a set InvoiceID        = b.InvoiceID,
	         InvoiceFromDate  = b.FromDate,
	         InvoiceToDate    = b.ToDate
from #Enrollment a with (nolock)
inner join #Invoice b with (nolock)
on  a.Utility                                      = b.Utility
and a.AccountNumber                                = b.AccountNumber

/******** Forecast Header - Services Dates ********/

update a set ServiceStartDate                      = b.ServiceStartDate,
	         ServiceEndDate                        = b.ServiceEndDate
from #Enrollment a with (nolock)
inner join #Services b with (nolock)
on  a.AccountID                                    = b.AccountID

/******** Forecast Header - Annual Usages ********/

update a set AnnualUsage = b.AnnualUsage
from #Enrollment a with (nolock)
inner join #AnnualUsages b with (nolock)
on  a.AccountID                                   = b.AccountID

/******** Overlap ********/

create table #OverlapFrom
(ID                                                int identity(1, 1) not null primary key clustered,
 EnrollmentID                                      int,
 AccountID                                         int,
 ContractRateStart                                 datetime,
 ContractRateEnd                                   datetime) 

insert into #OverlapFrom
select a.EnrollmentID,
       a.AccountID,
       a.ContractRateStart,
       a.ContractRateEnd
from #Enrollment a with (nolock)
where not exists(select null
                 from #Expire b with (nolock)
                 where b.AccountID                 = a.AccountID
                 and   b.ContractID                = a.ContractID
                 and   b.Term                      = a.Term)
order by a.AccountID,
         a.SubmitDate,
         a.ContractID

create table #OverlapCompare
(ID                                                int identity(0, 1) not null primary key clustered,
 EnrollmentID                                      int,
 AccountID                                         int,
 ContractRateStart                                 datetime,
 ContractRateEnd                                   datetime) 

insert into #OverlapCompare
select EnrollmentID,
       AccountID,
       ContractRateStart,
       ContractRateEnd
from #OverlapFrom with (nolock)
order by ID

create table #OverlapTo
(EnrollmentID                                      int not null primary key clustered,
 OverlapType                                       char(01),
 OverlapDays                                       int) 

insert into #OverlapTo
select a.EnrollmentID,
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
from #OverlapFrom a with (nolock)
left join #OverlapCompare b with (nolock)
on  a.ID                                           = b.ID
and a.AccountID                                    = b.AccountID                                 

/******** Header - Overlap ********/

update a set OverlapType = b.OverlapType,
             OverlapDays = b.OverlapDays
from #Enrollment a with (nolock)
join #OverlapTo b with (nolock)
on  a.EnrollmentID                                 = b.EnrollmentID  
where not exists(select null
                 from #Expire c with (nolock)
                 where c.AccountID                 = a.AccountID
                 and   c.ContractID                = a.ContractID
                 and   c.Term                      = a.Term)

set nocount off

GO
