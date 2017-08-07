--exec usp_contract_general_sel 'WVILCHEZ', '2006-0000121', '123456'

CREATE procedure [dbo].[usp_contract_general_sel]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30) = ' ')
as
if @p_contract_nbr                                  = 'CONTRACT'
begin

   select business_type,
          business_activity,
          additional_id_nbr_type,
          date_deal,
          sales_rep,
          deal_type
   from deal_contract with (NOLOCK INDEX = deal_contract_idx)
   where contract_nbr                               = @p_contract_nbr 


end   
else
begin
   select business_type,
          business_activity,
          additional_id_nbr_type,
          date_deal,
          sales_rep,
          deal_type
   from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
   where contract_nbr                               = @p_contract_nbr 
   and   account_number                             = @p_account_number

end
