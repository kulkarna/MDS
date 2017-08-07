




--exec usp_contract_contact_sel 'WVILCHEZ', '2006-0000121', 'BILLING', '123456'

CREATE procedure [dbo].[usp_contract_contact_sel]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_contact_type                                    varchar(15),
 @p_account_number                                  varchar(30) = ' ')
as


declare @w_customer_contact_link                    int
declare @w_billing_contact_link                     int

select @w_customer_contact_link                     = 0
select @w_billing_contact_link                      = 0

if @p_account_number                                = 'CONTRACT'
begin
   select @w_customer_contact_link                  = case when @p_contact_type = 'CUSTOMER'
                                                           then customer_contact_link
                                                           else 0
                                                      end,
          @w_billing_contact_link                   = case when @p_contact_type = 'BILLING'
                                                           then billing_contact_link
                                                           else 0
                                                      end
   from deal_contract with (NOLOCK INDEX = deal_contract_idx)
   where contract_nbr                               = @p_contract_nbr

end
else
begin

   select @w_customer_contact_link                  = case when @p_contact_type = 'CUSTOMER'
                                                           then customer_contact_link
                                                           else 0
                                                      end,
          @w_billing_contact_link                   = case when @p_contact_type = 'BILLING'
                                                           then billing_contact_link
                                                           else 0
                                                      end
   from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
   where contract_nbr                               = @p_contract_nbr
   and   account_number                             = @p_account_number
end

if @w_customer_contact_link                        <> 0
begin
   select contact_link,
          first_name,
          last_name,
          title,
          phone,
          fax,
          email,
          birthday
   from deal_contact with (NOLOCK INDEX = deal_contact_idx)
   where contract_nbr                               = @p_contract_nbr
   and   contact_link                               = @w_customer_contact_link
   return
end

if @w_billing_contact_link                         <> 0
begin
   select contact_link,
          first_name,
          last_name,
          title,
          phone,
          fax,
          email,
          birthday
   from deal_contact with (NOLOCK INDEX = deal_contact_idx)
   where contract_nbr                               = @p_contract_nbr
   and   contact_link                               = @w_billing_contact_link
   return
end

select contact_link                                 = 0,
       first_name                                   = '',
       last_name                                    = '',
       title                                        = '',
       phone                                        = '',
       fax                                          = '',
       email                                        = '',
       birthday                                     = 'NONE'




