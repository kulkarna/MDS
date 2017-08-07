-- Batch submitted through debugger: SQLQuery4.sql|7|0|C:\Users\sjena\AppData\Local\Temp\~vs5852.sql












-- exec usp_contact_ins 'WVILCHEZ', '2006-0000121', 'CUSTOMER', 0, 'William', 'Vilchez', 'CEO', '985-20002002', ' ', 'W@COM', '01/01', '123456'

CREATE procedure [dbo].[usp_contract_contact_ins]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_contact_type                                    varchar(15),
 @p_contact_link                                    int,
 @p_first_name                                      varchar(50),
 @p_last_name                                       varchar(50),
 @p_title                                           varchar(20),
 @p_phone                                           varchar(20),
 @p_fax                                             varchar(20),
 @p_email                                           nvarchar(256),
 @p_birthday                                        varchar(05),
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
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ''
select @w_return                                    = 0

declare @w_descp_add                                varchar(20)
select @w_descp_add                                 = ''

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

declare @w_contact_link                             int

select @p_contract_nbr                              = upper(@p_contract_nbr)
/*
select @p_first_name                                = @p_first_name
select @p_last_name                                 = @p_last_name
select @p_title                                     = @p_title
select @p_phone                                     = @p_phone
select @p_fax                                       = @p_fax
select @p_email                                     = @p_email
select @p_birthday                                  = @p_birthday
*/
declare @w_phone                                    varchar(20)

select @w_phone                                     = @p_phone

exec lp_common..usp_phone @w_phone output

select @p_phone                                     = @w_phone

if (@p_title = 'NONE' AND @p_fax = 'NONE' AND @p_email = 'NONE' AND @p_birthday = 'NONE')
begin 
 select @p_title = title,
		@p_fax = fax,
		@p_email = email,
		@p_birthday = birthday 
 from deal_contact
 where contract_nbr = @p_contract_nbr
 and contact_link = 1
end

exec @w_return = usp_contract_contact_val @p_username,
                                          'I',
                                          'ALL',
                                          @p_contract_nbr,
                                          @p_account_number,
                                          @p_first_name,
                                          @p_last_name,
                                          @p_title,
                                          @p_phone,
                                          @p_fax,
                                          @p_email,
                                          @p_birthday,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output

if @w_return                                       <> 0
begin
   goto goto_select
end

begin tran
select @w_contact_link                              = @p_contact_link

if @w_contact_link                                  = 0

begin

   select @w_contact_link                           = isnull(max(contact_link), 0) + 1
   from deal_contact with (NOLOCK INDEX = deal_contact_idx)
   where contract_nbr                               = @p_contract_nbr

   insert into deal_contact 
   select @p_contract_nbr,
          @w_contact_link,
          @p_first_name,
          @p_last_name,
          @p_title,
          @p_phone,
          @p_fax,
          @p_email,
          case when @p_birthday in ('NONE', '') then '01/01' when @p_birthday is null then '01/01' else @p_birthday end,
          0

   if @@error                                      <> 0
   or @@rowcount                                    = 0
   begin
      rollback tran
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = '(Contact)'
      goto goto_select
   end

end
else
begin
--Update the contact details of the linked contact 
	Update deal_contact set 
	first_name = @p_first_name,
	last_name = @p_last_name,
	title = @p_title,
	phone = @p_phone,
	fax = @p_fax,
	email = @p_email,
	birthday = case when @p_birthday in ('NONE', '') then '01/01' when @p_birthday is null then '01/01' else @p_birthday end
	where contract_nbr = @p_contract_nbr and contact_link = @p_contact_link

end


if not exists(select contact_link
              from deal_contact with (NOLOCK INDEX = deal_contact_idx)
              where contract_nbr                    = @p_contract_nbr
              and   contact_link                    = @w_contact_link)
begin
   select @w_contact_link                           = 0
end

declare @w_contact_type                             varchar(15)
select @w_contact_type                              = @p_contact_type

commit tran

if @p_account_number                                = 'CONTRACT'
begin
   if @w_contact_type                               = 'CUSTOMER'
   begin
      update deal_contract set customer_contact_link = @w_contact_link
      from deal_contract with (NOLOCK INDEX = deal_contract_idx)
      where contract_nbr                            = @p_contract_nbr

      if @@error                                   <> 0
      or @@rowcount                                 = 0
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Customer)'
         goto goto_select
      end

      update deal_contract_account set customer_contact_link = @w_contact_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr                            = @p_contract_nbr
      --and   customer_contact_link                   = 0

      if @@error                                   <> 0
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Customer - Account)'
         goto goto_select
      end

      select @w_contact_type                        = 'BILLING'

   end

   if @w_contact_type                               = 'BILLING'
   begin
      update deal_contract set billing_contact_link = @w_contact_link
      from deal_contract with (NOLOCK INDEX = deal_contract_idx)
      where contract_nbr                            = @p_contract_nbr
      and  (@p_contact_type                         = @w_contact_type
      or   (@p_contact_type                        <> @w_contact_type
      and   billing_contact_link                    = 0))

      if @@error                                   <> 0
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Billing)'
         goto goto_select
      end

      update deal_contract_account set billing_contact_link = @w_contact_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr                            = @p_contract_nbr
      --and   billing_contact_link                    = 0

      if @@error                                   <> 0
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Billing - Account)'
         goto goto_select
      end
   end
end
else
begin
   if @w_contact_type                               = 'CUSTOMER'
   begin
      update deal_contract_account set customer_contact_link = @w_contact_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr                            = @p_contract_nbr
      and   account_number                          = @p_account_number

      if @@error                                   <> 0
      or @@rowcount                                 = 0
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Customer - Account)'
         goto goto_select
      end

      select @w_contact_type                        = 'BILLING'

   end

   if @w_contact_type                               = 'BILLING'
   begin
      update deal_contract_account set billing_contact_link = @w_contact_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr                            = @p_contract_nbr
      and   account_number                          = @p_account_number
      and  (@p_contact_type                         = @w_contact_type
      or   (@p_contact_type                        <> @w_contact_type
      and   billing_contact_link                    = 0))

      if @@error                                   <> 0
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Billing - Account)'
         goto goto_select
      end

   end

end

goto_select:

if @w_error                                        <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp output,
                                    @w_application

   select @w_descp                                  = ltrim(rtrim(@w_descp ))
                                                    + ' '
                                                    + @w_descp_add
end
 
if @p_result_ind                                    = 'Y'
begin
   select flag_error                                = @w_error,
          code_error                                = @w_msg_id,
          message_error                             = @w_descp
   goto goto_return
end
 
select @p_error                                     = @w_error,
       @p_msg_id                                    = @w_msg_id,
       @p_descp                                     = @w_descp
 
goto_return:
return @w_return