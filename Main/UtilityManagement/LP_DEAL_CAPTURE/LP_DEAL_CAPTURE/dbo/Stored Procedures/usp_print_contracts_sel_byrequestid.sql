

-- exec usp_print_contracts_sel_byrequestid 'admin', ' '

 
CREATE procedure [dbo].[usp_print_contracts_sel_byrequestid] 
(@p_username                                        nchar(100),
 @p_request_id                                      varchar(20))
as
 
select request_id,
       contract_nbr,
       username,
       retail_mkt_id,
       puc_certification_number,
       utility_id,
       product_id,
       rate_id,
       rate,
       rate_descp,
       term_months,
       contract_eff_start_date,
       grace_period,
       date_created,
       contract_template
       , ratestring
from deal_contract_print with (NOLOCK INDEX =deal_contract_print_idx) 
where request_id                                    = @p_request_id
 



