







--exec usp_contract_address_sel 'WVILCHEZ', '2006-0000121', 'BILLING', '123456'

CREATE procedure [dbo].[usp_contract_address_sel]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_address_type                                    varchar(15),
 @p_account_number                                  varchar(30) = ' ')
as

declare @w_customer_address_link                    int
declare @w_billing_address_link                     int
declare @w_service_address_link                     int

select @w_customer_address_link                     = 0
select @w_billing_address_link                      = 0
select @w_service_address_link                      = 0

if @p_account_number                                = 'CONTRACT'
begin
   select @w_customer_address_link                  = case when @p_address_type = 'CUSTOMER'
                                                           then customer_address_link
                                                           else 0
                                                      end,
          @w_billing_address_link                   = case when @p_address_type = 'BILLING'
                                                           then billing_address_link
                                                           else 0
                                                      end,
          @w_service_address_link                   = case when @p_address_type = 'SERVICE'
                                                           then service_address_link
                                                           else 0
                                                      end
   from deal_contract with (NOLOCK INDEX = deal_contract_idx)
   where contract_nbr                               = @p_contract_nbr

end
else
begin

   select @w_customer_address_link                  = case when @p_address_type = 'CUSTOMER'
                                                           then customer_address_link
                                                           else 0
                                                      end,
          @w_billing_address_link                   = case when @p_address_type = 'BILLING'
                                                           then billing_address_link
                                                           else 0
                                                      end,
          @w_service_address_link                   = case when @p_address_type = 'SERVICE'
                                                           then service_address_link
                                                           else 0
                                                      end
   from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
   where contract_nbr                               = @p_contract_nbr
   and   account_number                             = @p_account_number

end

if @w_customer_address_link                        <> 0
begin
   select address_link,
          address,
          suite,
          city,
          state,
          zip
   from deal_address with (NOLOCK INDEX = deal_address_idx)
   where contract_nbr                               = @p_contract_nbr
   and   address_link                               = @w_customer_address_link
   return
end

if @w_billing_address_link                         <> 0
begin
   select address_link,
          address,
          suite,
          city,
          state,
          zip
   from deal_address with (NOLOCK INDEX = deal_address_idx)
   where contract_nbr                               = @p_contract_nbr
   and   address_link                               = @w_billing_address_link
   return
end

if @w_service_address_link                         <> 0
begin
   select address_link,
          address,
          suite,
          city,
          state,
          zip
   from deal_address with (NOLOCK INDEX = deal_address_idx)
   where contract_nbr                               = @p_contract_nbr
   and   address_link                               = @w_service_address_link
   return
end

select address_link                                 = 0,
       address                                      = '',
       suite                                        = '',
       city                                         = '',
       state                                        = 'NN',
       zip                                          = ''







