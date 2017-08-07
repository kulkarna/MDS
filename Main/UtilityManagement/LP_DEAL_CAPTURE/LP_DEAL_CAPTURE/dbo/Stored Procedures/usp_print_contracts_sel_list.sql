
CREATE procedure [dbo].[usp_print_contracts_sel_list] 
(@p_username                                        nchar(100),
 @p_view                                            varchar(35) = 'ALL',
 @p_rec_sel                                         int = 50)
as

set rowcount @p_rec_sel
 
if @p_view                                          = 'ALL'
begin
   select a.request_id,
          a.contract_nbr,
          a.username,
          a.retail_mkt_id,
          a.puc_certification_number,
          a.utility_id,
          a.product_id,
          a.rate_id,
          a.rate,
          a.rate_descp,
          a.term_months,
          a.contract_eff_start_date,
          a.grace_period,
          a.date_created,
          a.contract_template,
          contract_template_directory
   from deal_contract_print a with (NOLOCK INDEX = deal_contract_print_idx2),
        deal_config b with (NOLOCK)
   where username                                   = @p_username
end
 
