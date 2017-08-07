



-- exec usp_address_ins 'WVILCHEZ', '2006-0000121', 'BILLING', 0, '30104 Butternut DR', ' ', 'slidell', 'LA', '70458', '123456'

CREATE procedure [dbo].[usp_contract_address_ins]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_address_type                                    varchar(15),
 @p_address_link                                    int,
 @p_address                                         char(50),
 @p_suite                                           char(10),
 @p_city                                            char(28),
 @p_state                                           char(02),
 @p_zip                                             char(10),
 @p_account_number                                  varchar(30) = '',
 @p_error                                           char(01) = '',
 @p_msg_id                                          char(08) = '',
 @p_descp                                           varchar(250) = '',
 @p_result_ind                                      char(01) = 'Y')
as

declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(150)
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ''
select @w_return                                    = 0
select @w_descp_add                                 = ''

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

declare @w_address_link                             int

select @p_contract_nbr                              = upper(@p_contract_nbr)

select @p_address                                   = @p_address
select @p_suite                                     = @p_suite
select @p_city                                      = @p_city
select @p_state                                     = @p_state
select @p_zip                                       = @p_zip

declare @w_address_type                             varchar(15)
select @w_address_type                              = @p_address_type

if @w_address_type <> 'SERVICE'
begin
	exec @w_return = lp_deal_capture.dbo.usp_contract_address_val @p_username,
											  'I',
											  'ALL',
											  @p_contract_nbr,
											  @p_account_number,
											  @p_address,
											  @p_city,
											  @p_state,
											  @p_zip,
											  @w_application output,
											  @w_error output,
											  @w_msg_id output,
											  @w_descp_add output

	if @w_return <> 0
	begin
	   goto goto_select
	end
end


begin tran

select @w_address_link = @p_address_link

if @w_address_link = 0
begin

   select @w_address_link = isnull(max(address_link), 0) + 1
   from deal_address with (NOLOCK INDEX = deal_address_idx)
   where contract_nbr = @p_contract_nbr

   insert into deal_address 
   select @p_contract_nbr,
          @w_address_link,
          @p_address,
          @p_suite,
          @p_city,
          @p_state,
          @p_zip,
          '',
          '',
          '',
          0

   if @@error <> 0 or @@rowcount = 0
   begin
      rollback tran
      select @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000051', @w_return = 1, @w_descp_add = '(Address)'
      goto goto_select
   end

end

if @w_address_link <> 0
begin
   update deal_address 
   set	  [address]	= @p_address,
          suite		= @p_suite,
          city		= @p_city,
          [state]	= @p_state,
          zip		= @p_zip
   where  contract_nbr = @p_contract_nbr
   and	  address_link = @w_address_link
   
   if @@error <> 0 or @@rowcount = 0
   begin
      rollback tran
      select @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000051', @w_return = 1, @w_descp_add = '(Address)'
      goto goto_select
   end

end

if not exists(select address_link
              from deal_address with (NOLOCK INDEX = deal_address_idx)
              where contract_nbr = @p_contract_nbr and address_link = @w_address_link)
begin
   select @w_address_link = 0
end


commit tran

if @p_account_number = 'CONTRACT'
begin

   if @w_address_type = 'CUSTOMER'
   begin
      update deal_contract set customer_address_link = @w_address_link
      from deal_contract with (NOLOCK INDEX = deal_contract_idx)
      where contract_nbr                            = @p_contract_nbr

      if @@error <> 0 or @@rowcount = 0
      begin
         select @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000051', @w_return = 1, @w_descp_add = '(Customer)'
         goto goto_select
      end

      update deal_contract_account set customer_address_link = @w_address_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr                            = @p_contract_nbr
      --and   customer_address_link                   = 0

      if @@error                                   <> 0
      begin
         select @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000051', @w_return = 1, @w_descp_add = '(Customer - Account)'
         goto goto_select
      end

      select @w_address_type = 'BILLING'
   end

   if @w_address_type = 'BILLING'
   begin
      update deal_contract set billing_address_link = @w_address_link
      from deal_contract with (NOLOCK INDEX = deal_contract_idx)
      where contract_nbr = @p_contract_nbr
      and  (@p_address_type = @w_address_type or (@p_address_type <> @w_address_type and billing_address_link = 0))

      if @@error <> 0
      begin
         select @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000051', @w_return = 1, @w_descp_add = '(Billing)'
         goto goto_select
      end

      update deal_contract_account set billing_address_link = @w_address_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr                            = @p_contract_nbr
      --and   billing_address_link                    = 0

      if @@error                                   <> 0
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Billing - Account)'
         goto goto_select
      end

      if @p_address_type                            = 'CUSTOMER'
      begin
         select @w_address_type                     = 'SERVICE'
      end

   end

   if @w_address_type                               = 'SERVICE'
   begin
      update deal_contract set service_address_link = @w_address_link
      from deal_contract with (NOLOCK INDEX = deal_contract_idx)
      where contract_nbr = @p_contract_nbr
      and (@p_address_type = @w_address_type or (@p_address_type <> @w_address_type and service_address_link = 0))

      if @@error <> 0
      begin
         select @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000051', @w_return = 1, @w_descp_add = '(Service)'
         goto goto_select
      end

      update deal_contract_account set service_address_link = @w_address_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr = @p_contract_nbr and service_address_link = 0

      if @@error <> 0
      begin
         select @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000051', @w_return = 1, @w_descp_add = '(Service - Account)'
         goto goto_select
      end
      
   end
end
else
begin

   if @w_address_type = 'CUSTOMER'
   begin
      update deal_contract_account set customer_address_link = @w_address_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr = @p_contract_nbr
      and account_number = @p_account_number

      if @@error <> 0 or @@rowcount = 0
      begin
         select @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000051', @w_return = 1, @w_descp_add = '(Customer - Account)'
         goto goto_select
      end

      select @w_address_type = 'BILLING'

   end

   if @w_address_type = 'BILLING'
   begin
      update deal_contract_account set billing_address_link = @w_address_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr = @p_contract_nbr
      and   account_number = @p_account_number
      and (@p_address_type = @w_address_type or (@p_address_type <> @w_address_type and billing_address_link = 0))

      if @@error <> 0
      begin
         select @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000051', @w_return = 1, @w_descp_add = '(Billing - Account)'
         goto goto_select
      end      

      if @p_address_type = 'CUSTOMER'
      begin
         select @w_address_type = 'SERVICE'
      end

   end

   if @w_address_type = 'SERVICE'
   begin
      update deal_contract_account set service_address_link = @w_address_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr = @p_contract_nbr
      and   account_number = @p_account_number
      and  (@p_address_type = @w_address_type or (@p_address_type <> @w_address_type and service_address_link = 0))

      if @@error <> 0
      begin
         select @w_application = 'COMMON', @w_error = 'E', @w_msg_id = '00000051', @w_return = 1, @w_descp_add = '(Service - Account)'
         goto goto_select
      end

   end
end

goto_select:

if @w_error <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id, @w_descp output, @w_application

   select @w_descp = ltrim(rtrim(@w_descp)) + ' ' + @w_descp_add
end
 
if @p_result_ind = 'Y'
begin
   select flag_error = @w_error,
          code_error = @w_msg_id,
          message_error = @w_descp
   goto goto_return
end
 
select @p_error = @w_error,
       @p_msg_id = @w_msg_id,
       @p_descp = @w_descp
 
goto_return:
return @w_return

