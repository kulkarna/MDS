
--delete lp_common..common_views where seq >= 21000

CREATE procedure [dbo].[usp_import_account_BUSSINESS]
as
declare @w_seq                                 int
select @w_seq                                  = max(seq) + 1
from lp_common..common_views
where process_id = 'BUSINESS TYPE'

CREATE TABLE [dbo].[#table_1](
	[seq] [int] IDENTITY(21016,1) NOT NULL,
	[business] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]

insert into #table_1
select distinct upper(business_type)
from lp_account..account
where upper(business_type) not in (select upper(option_id)
                                   from lp_common..common_views
                                   where process_id = 'BUSINESS TYPE')

select @w_seq                                  = max(seq) + 1
from lp_common..common_views
where process_id = 'BUSINESS ACTIVITY'

CREATE TABLE [dbo].[#table_2](
	[seq] [int] IDENTITY(21274,1) NOT NULL,
	[business] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]

insert into #table_2
select distinct upper(business_activity)
from lp_account..account
where upper(business_activity) not in (select upper(option_id)
                                       from lp_common..common_views
                                       where process_id = 'BUSINESS ACTIVITY')


insert into lp_common..common_views
select distinct
       'BUSINESS TYPE',
       [seq],
       [business],
       ' '
from #table_1 
where [business] not in (select upper(option_id)
                                   from lp_common..common_views
                                   where process_id = 'BUSINESS TYPE')


insert into lp_common..common_views
select distinct
       'BUSINESS ACTIVITY',
       [seq],
       [business],
       ' '
from #table_2
where [business] not in (select upper(option_id)
                                       from lp_common..common_views
                                       where process_id = 'BUSINESS ACTIVITY')
