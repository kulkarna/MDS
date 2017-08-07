





--exec usp_contract_name_sel 'WVILCHEZ', '2006-0000121', 'CUSTOMER', '123456'

CREATE procedure [dbo].[usp_contract_name_sel]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_name_type                                       varchar(15),
 @p_account_number                                  varchar(30) = ' ')
as

declare @w_account_name_link                        int
declare @w_customer_name_link                       int
declare @w_owner_name_link                          int

select @w_account_name_link                         = 0
select @w_customer_name_link                        = 0
select @w_owner_name_link                           = 0

if @p_account_number                                = 'CONTRACT'
begin
   select @w_customer_name_link                     = case when @p_name_type = 'CUSTOMER'
                                                           then customer_name_link
                                                           else 0
                                                      end,
          @w_owner_name_link                        = case when @p_name_type = 'OWNER'
                                                           then owner_name_link
                                                           else 0
                                                      end
   from deal_contract with (NOLOCK INDEX = deal_contract_idx)
   where contract_nbr                               = @p_contract_nbr
end
else
begin
   select @w_account_name_link                      = case when @p_name_type = 'ACCOUNT'
                                                           then account_name_link
                                                           else 0
                                                      end,
          @w_customer_name_link                     = case when @p_name_type = 'CUSTOMER'
                                                           then customer_name_link
                                                           else 0
                                                      end,
          @w_owner_name_link                        = case when @p_name_type = 'OWNER'
                                                           then owner_name_link
                                                           else 0
                                                      end
   from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
   where contract_nbr                               = @p_contract_nbr
   and   account_number                             = @p_account_number
end

if @w_account_name_link                            <> 0
begin
   select name_link,
          full_name
   from deal_name with (NOLOCK INDEX = deal_name_idx)
   where contract_nbr                               = @p_contract_nbr
   and   name_link                                  = @w_account_name_link
   return
end

if @w_customer_name_link                           <> 0
begin
   select name_link,
          full_name
   from deal_name with (NOLOCK INDEX = deal_name_idx)
   where contract_nbr                               = @p_contract_nbr
   and   name_link                                  = @w_customer_name_link
   return
end

if @w_owner_name_link                              <> 0
begin
   select name_link,
          full_name
   from deal_name with (NOLOCK INDEX = deal_name_idx)
   where contract_nbr                               = @p_contract_nbr
   and   name_link                                  = @w_owner_name_link
   return
end

select name_link                                    = 0,
       full_name                                    = ''


