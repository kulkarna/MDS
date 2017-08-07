-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/10/2007
-- Description:	Select pricing
-- =============================================
CREATE PROCEDURE [dbo].[usp_contract_pricing_sel]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30) = ' ')
as
 
if @p_contract_nbr                                  = 'CONTRACT'
begin

   select retail_mkt_id,
          utility_id,
          product_id,
          rate_id,
          rate,
          contract_eff_start_date,
          term_months,
          date_end,
          contract_eff_start_date,
          enrollment_type,
          customer_code,
          customer_group
   from deal_contract with (NOLOCK INDEX = deal_contract_idx)
   where contract_nbr                               = @p_contract_nbr 


end   
else
begin
   select retail_mkt_id,
          utility_id,
          product_id,
          rate_id,
          rate,
          contract_eff_start_date,
          term_months,
          date_end,
          contract_eff_start_date,
          enrollment_type,
          customer_code,
          customer_group
   from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
   where contract_nbr                               = @p_contract_nbr 
   and   account_number                             = @p_account_number

end
