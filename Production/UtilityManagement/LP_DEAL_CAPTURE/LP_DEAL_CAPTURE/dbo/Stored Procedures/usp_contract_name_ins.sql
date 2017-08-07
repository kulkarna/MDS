



















--exec usp_name_ins 'WVILCHEZ', '2006-0000121', 'CUSTOMER', 0, 'cachirulo', '123456'

CREATE procedure [dbo].[usp_contract_name_ins]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_name_type                                       varchar(15),
 @p_name_link                                       int,
 @p_full_name                                       varchar(100),
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

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

declare @w_descp_add                                varchar(20)
select @w_descp_add                                 = ''

declare @w_name_link                                int

select @p_contract_nbr                              = upper(@p_contract_nbr)

select @p_full_name                                 = @p_full_name

exec @w_return = usp_contract_name_val @p_username,
                                       'I',
                                       'ALL',
                                       @p_contract_nbr,
                                       @p_account_number,
                                       @p_full_name,
                                       @w_application output,
                                       @w_error output,
                                       @w_msg_id output


if @w_return                                       <> 0
begin
   goto goto_select
end

begin tran

select @w_name_link                                 = @p_name_link

if @w_name_link                                     = 0
begin

   select @w_name_link                              = isnull(max(name_link), 0) + 1
   from deal_name with (NOLOCK INDEX = deal_name_idx)
   where contract_nbr                               = @p_contract_nbr

   insert into deal_name 
   select @p_contract_nbr,
          @w_name_link,
          @p_full_name,
          0

   if @@error                                      <> 0
   or @@rowcount                                    = 0
   begin
      rollback tran
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = '(Name)'
      goto goto_select
   end

end

if @w_name_link                                     <> 0
begin
   update deal_name 
   set	full_name = @p_full_name
   where contract_nbr	= @p_contract_nbr
   and   name_link		= @w_name_link
       

   if @@error                                      <> 0
   or @@rowcount                                    = 0
   begin
      rollback tran
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = '(Name)'
      goto goto_select
   end

end

if not exists(select name_link
              from deal_name with (NOLOCK INDEX = deal_name_idx)
              where contract_nbr                    = @p_contract_nbr
              and   name_link                       = @w_name_link)
begin
   select @w_name_link                              = 0
end

declare @w_name_type                                varchar(15)
select @w_name_type                                 = @p_name_type

commit tran

if @p_account_number                                = 'CONTRACT'
begin
   if @w_name_type                                  = 'CUSTOMER'
   begin
      update deal_contract set customer_name_link = @w_name_link
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

      update deal_contract_account set customer_name_link = @w_name_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr                            = @p_contract_nbr
      --and   customer_name_link                      = 0

      if @@error                                   <> 0
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Customer - Account)'
         goto goto_select
      end

      update deal_contract_account set account_name_link = @w_name_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr                            = @p_contract_nbr
      --and   account_name_link                       = 0

      if @@error                                   <> 0
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Account - Account)'
         goto goto_select
      end

      select @w_name_type                           = 'OWNER'
   end

   if @w_name_type                                  = 'OWNER'
   begin
      update deal_contract set owner_name_link = @w_name_link
      from deal_contract with (NOLOCK INDEX = deal_contract_idx)
      where contract_nbr                            = @p_contract_nbr
      and  (@p_name_type                            = @w_name_type
      or   (@p_name_type                           <> @w_name_type
      and   owner_name_link                         = 0))

      if @@error                                   <> 0
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Owner)'
         goto goto_select
      end

      update deal_contract_account set owner_name_link = @w_name_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr                            = @p_contract_nbr
      --and   owner_name_link                         = 0

      if @@error                                   <> 0
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Owner - Account)'
         goto goto_select
      end


   end
end
else
begin
   if @w_name_type                                  = 'CUSTOMER'
   begin
      update deal_contract_account set customer_name_link = @w_name_link
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

      select @w_name_type                           = 'OWNER'

   end
   if @w_name_type                                  = 'OWNER'
   begin
      update deal_contract_account set owner_name_link = @w_name_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr                            = @p_contract_nbr
      and   account_number                          = @p_account_number
      and  (@p_name_type                            = @w_name_type
      or   (@p_name_type                           <> @w_name_type
      and   owner_name_link                         = 0))

      if @@error                                   <> 0
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Owner - Account)'
         goto goto_select
      end

      if @p_name_type                               = 'OWNER'
      begin
         select @w_name_type                        = 'ACCOUNT'
      end

   end
   if @w_name_type                                  = 'ACCOUNT'
   begin
      update deal_contract_account set account_name_link = @w_name_link
      from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
      where contract_nbr                            = @p_contract_nbr
      and   account_number                          = @p_account_number
      and  (@p_name_type                            = @w_name_type
      or   (@p_name_type                           <> @w_name_type
      and   account_name_link                       = 0))

      if @@error                                   <> 0
      begin
         select @w_application                      = 'COMMON'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000051'
         select @w_return                           = 1
         select @w_descp_add                        = '(Account - Account)'
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
                                                    + ''
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


