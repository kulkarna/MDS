
CREATE procedure [dbo].[usp_contract_account_sel]
(
	@p_account_number                  varchar(30),
	@p_contract_nbr                    char(12)
 )
as

Select
		contract_nbr
		, contract_type
		, account_number
		, sales_channel_role
		, evergreen_option_id 
		, evergreen_commission_end 
		, residual_option_id 
		, residual_commission_end 
		, initial_pymt_option_id  
		, evergreen_commission_rate 
		, PriceID
       
From deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
Where contract_nbr = @p_contract_nbr
And account_number = @p_account_number
