
CREATE procedure [dbo].[usp_import_account_3]
as
update lp_account..account set status = '01000', sub_status = '10'
where status = '02000' and sub_status = '10'                               

CREATE TABLE [dbo].[#table_1](
status  varchar(15),
sub_status  varchar(15),
contract_type varchar(35),
contract_nbr  char(12),
account_type  varchar(35),
por_option varchar(03),
utility_id char(15))


insert into #table_1
select distinct
       a.status,
       a.sub_status,
       a.contract_type,
       a.contract_nbr,
       a.account_type,
       b.por_option,
       b.utility_id
from lp_account..account a with (NOLOCK INDEX = account_idx),
     lp_common..common_utility b with (NOLOCK INDEX = common_utility_idx)
where a.utility_id                 = b.utility_id
and   a.account_id              like 'ACC%'
AND (  a.contract_nbr              <> ' '
or    a.contract_nbr             is not null)

delete #table_1 where status > '06000'

select account_type,
       por_option, status, sub_status, count(*)
from #table_1
group by account_type,
       por_option,status, sub_status



insert into lp_enrollment..check_account
select DISTINCT
       a.contract_nbr,
       ' ',
       case when status = '04000' then 'LETTER' else 'ENROLLMENT CONSOLIDATED' END,
       'ENROLLMENT',
       case when a.utility_id = 'CONED' and status = '01000' then 'AWSCR' else 'PENDING' END,
       getdate(),
       ' ',
       getdate(),
       'ONLINE',
       ' ',
       ' ',
       ' ',
       ' ',
       ' ',
       ' ',
       ' ',
       'Libertypower\dmarino',
       getdate(),
       0
from #table_1 a
where ((a.status       = '04000'
and   a.sub_status       = '20'))
and   a.account_type     = 'SMB'
and   a.por_option        = 'YES'


insert into lp_enrollment..check_account
select distinct
       a.contract_nbr,
       ' ',
       b.check_type,
       'ENROLLMENT',
       case when a.utility_id = 'CONED' and status = '01000' then 'AWSCR' else 'PENDING' END,
       getdate(),
       a.utility_id,
       getdate(),
       'ONLINE',
       ' ',
       ' ',
       ' ',
       ' ',
       ' ',
       ' ',
       ' ',
       'Libertypower\dmarino',
       getdate(),
       0
from #table_1 a,
     lp_common..common_utility_check_type b
where a.status       = b.wait_status
and   a.sub_status       = b.wait_sub_status
and   a.contract_type    = b.contract_type
and   a.utility_id        = b.utility_id
and   b.[order] > 1
and   ltrim(rtrim(a.contract_nbr)) + ltrim(rtrim(b.check_type)) not in (select ltrim(rtrim(contract_nbr)) + ltrim(rtrim(check_type))
                                                                        from lp_enrollment..check_account)

