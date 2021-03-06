USE [lp_contract_renewal]
GO
/****** Object:  StoredProcedure [dbo].[usp_contract_general_sel]    Script Date: 01/21/2013 23:10:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







--exec usp_contract_general_sel 'WVILCHEZ', '2006-0000121', '123456'

ALTER procedure [dbo].[usp_contract_general_sel]
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
          business_type,
          business_activity,
          additional_id_nbr_type,
          contract_eff_start_date,
          term_months,
          date_deal,
          date_end,
          sales_rep
          , RatesString
   from deal_contract with (NOLOCK)
   where contract_nbr                               = @p_contract_nbr 


end   
else
begin
   select retail_mkt_id,
          utility_id,
          product_id,
          rate_id,
          rate,
          business_type,
          business_activity,
          additional_id_nbr_type,
          contract_eff_start_date,
          term_months,
          date_deal,
          date_end,
          sales_rep
          , RatesString
   from deal_contract_account with (NOLOCK)
   where contract_nbr                               = @p_contract_nbr 
   and   account_number                             = @p_account_number

end




