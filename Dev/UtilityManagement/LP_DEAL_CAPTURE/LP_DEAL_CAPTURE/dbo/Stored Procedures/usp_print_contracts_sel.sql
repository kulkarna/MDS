

--exec usp_print_contracts_sel 'admin', '2006-0000007'
 
CREATE procedure [dbo].[usp_print_contracts_sel] 
(@p_username                                        nchar(100),
 @p_contract_nbr                                    varchar(12),
 @p_rate_type										varchar(6) = 'SINGLE')
as

select a.request_id,
	a.contract_nbr,
	a.username,
	a.retail_mkt_id,
	a.puc_certification_number,
	a.utility_id,
	product_id                                   = c.product_descp,
	a.rate_id,
	a.rate,
	a.rate_descp,
	a.term_months,
	a.contract_eff_start_date,
	a.grace_period,
	a.date_created,
	a.contract_template,
	b.contract_template_directory,
	a.status
	,a.TemplateId
from 
	deal_contract_print a with (NOLOCK INDEX = deal_contract_print_idx1),
	deal_config b with (NOLOCK),
	lp_common..common_product c with (NOLOCK INDEX = common_product_idx)
where a.contract_nbr                                = @p_contract_nbr
and   a.username                                    = @p_username
and   a.product_id                                  = CASE WHEN @p_rate_type = 'SINGLE' THEN c.product_id ELSE 'NONE' END