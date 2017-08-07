--exec usp_contract_tracking_details_sel_list 'libertypower\msalmeirao'

CREATE  procedure [dbo].[usp_contract_tracking_details_sel_list]
(@p_username                                        nchar(100),
 @p_view                                            varchar(35) = 'ALL',
 @p_transaction_id_filter                           char(12) = 'ALL',
 @p_account_number_filter                           varchar(30) = 'ALL',
 @p_contract_nbr_filter                             char(12)= 'ALL',
 @p_rec_sel                                         int = 50,
 @p_current_page	                                int = 1,
 @p_page_size                                       int = 100)
as

if @p_account_number_filter = '' begin select @p_account_number_filter = 'ALL' end
if @p_contract_nbr_filter = '' begin select @p_contract_nbr_filter = 'ALL' end

declare @w_return                                   int

declare @w_record_count                             int
declare @w_start_row_index                          int

select @w_start_row_index                           = ((@p_current_page * @p_page_size) - @p_page_size) + 1

declare @w_select_count                             nvarchar(100)
select @w_select_count                              = 'select count(transaction_id) '

declare @w_with                                     nvarchar(1000)
declare @w_select                                   nvarchar(1000)
declare @w_from                                     nvarchar(200)
declare @w_where                                    nvarchar(1000)
declare @w_order_by                                 nvarchar(1000)

declare @w_sql                                      nvarchar(4000)

select @w_with                                      = 'with result_table '
                                                    + 'as '

select @w_select                                    = 'select rowid = row_number() over (order by submit_date desc), '
                                                    +        'a.transaction_id, '
                                                    +        'a.account_number, '
                                                    +        'a.account_name, '
                                                    +        'a.retail_mkt_id, '
                                                    +        'a.utility_id, '
                                                    +        'a.entity_id, '
                                                    +        'a.product_id, '
                                                    +        'a.rate_id, '
                                                    +        'a.rate, '
                                                    +        'a.por_option, '
                                                    +        'a.account_type, '
                                                    +        'a.business_activity, '
                                                    +        'a.customer_id, '
                                                    +        'a.contract_type, '
                                                    +        'a.contract_nbr, '
                                                    +        'a.sales_rep, '
                                                    +        'a.sales_channel_role, '
                                                    +        'a.eff_start_date, '
                                                    +        'a.end_date, '
                                                    +        'a.term_months, '
                                                    +        'a.deal_date, '
                                                    +        'a.submit_date, '
                                                    +        'a.flow_start_date, '
                                                    +        'a.enrollment_type, '
                                                    +        'a.tax_status, '
                                                    +        'a.tax_float, '
                                                    +        'a.annual_usage, '
                                                    +        'a.date_created, '
                                                    +        'a.service_address, '
                                                    +        'a.service_suite, '
                                                    +        'a.service_city, '
                                                    +        'a.service_state, '
                                                    +        'a.service_zip, '
                                                    +        'a.billing_address, '
                                                    +        'a.billing_suite, '
                                                    +        'a.billing_city, '
                                                    +        'a.billing_state, '
                                                    +        'a.billing_zip, '
                                                    +        'a.origin, '
                                                    +        'a.status '
select @w_from                                      = 'from contract_tracking_details a with (NOLOCK INDEX = contract_tracking_detials_ndx), '
                                                    +      'ufn_account_sales_channel(' + '''' + ltrim(rtrim(@p_username)) + '''' + ') b '

select @w_order_by                                  = ''

select @w_where                                     = 'where a.sales_channel_role = b.sales_channel_role '

if @p_transaction_id_filter                    not in ('NONE','','ALL')
begin

   select @w_where                                  = ltrim(rtrim(@w_where))
                                                    + ' '
                                                    + 'and   a.transaction_id     = ' 
                                                    + '''' 
                                                    + @p_transaction_id_filter 
                                                    + '''' 
                                                    + ' '
end 

if @p_account_number_filter                    not in ('NONE','','ALL')
begin
   select @w_where                                  = ltrim(rtrim(@w_where))
                                                    + ' '
                                                    + 'and   a.account_number     = ' 
                                                    + '''' 
                                                    + @p_account_number_filter
                                                    + '''' 
                                                    + ' '
end 

if @p_contract_nbr_filter                      not in ('NONE','','ALL')
begin
   select @w_where                                  = ltrim(rtrim(@w_where))
                                                    + ' '
                                                    + 'and   a.contract_nbr       = ' 
                                                    + '''' 
                                                    + @p_contract_nbr_filter
                                                    + '''' 
                                                    + ' '
end

if @p_view                                          = 'SUBMIT DATE'
begin
   select @w_order_by                               = 'order by submit_date desc '
end

if @p_view                                          = 'FLOW START DATE'
begin
   select @w_order_by                               = 'order by flow_start_date desc'
end

if @p_view                                          = 'EFF START DATE'
begin
   select @w_order_by                               = 'order by eff_start_date desc'
end

if @p_view                                          = 'DEAL DATE'
begin
   select @w_order_by                               = 'order by deal_date desc'
end

if @p_view                                          = 'END DATE'
begin
   select @w_order_by                               = 'order by end_date desc'
end

if @p_view                                          = 'TRANSACTION ID'
begin
   select @w_order_by                               = 'order by transaction_id desc'
end

select @w_sql                                       = ltrim(rtrim(@w_select_count))
                                                    + ' '
                                                    + ltrim(rtrim(@w_from))
                                                    + ' '
                                                    + ltrim(rtrim(@w_where))
                                                    + ' '
                                                    + ltrim(rtrim(@w_order_by))

create table #count
(row_count                                          int)

insert into #count
exec sp_executesql @w_sql

select @w_record_count                              = row_count
from #count

select @w_sql                                       = ltrim(rtrim(@w_with))
                                                    + ' ('
                                                    + ltrim(rtrim(@w_select))
                                                    + ' '
                                                    + ltrim(rtrim(@w_from))
                                                    + ' '
                                                    + ltrim(rtrim(@w_where))
                                                    + ') '
                                                    + 'select *, '
                                                    +         ltrim(rtrim(convert(varchar(26), @w_record_count))) + ' RecordCount, '
                                                    +         'ceiling(cast(' + ltrim(rtrim(convert(varchar(26), @w_record_count))) + ' as float) '
                                                    +                 '/ '
                                                    +                 'cast(' + ltrim(rtrim(convert(varchar(26), @p_page_size))) + ' as float)) PageCount '
                                                    + 'from result_table '
                                                    + 'where rowid     between ' + ltrim(rtrim(convert(varchar(26), @w_start_row_index))) + ' '
                                                    +                 'and '     + ltrim(rtrim(convert(varchar(26), ((@w_start_row_index + @p_page_size) - 1)))) + ' '
                                                    + ltrim(rtrim(@w_order_by))


exec @w_return                                      = sp_executesql @w_sql
