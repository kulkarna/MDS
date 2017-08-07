
CREATE procedure [dbo].[usp_contract_account_val]
(@p_username                                        nchar(100),
 @p_action                                          char(01),
 @p_edit_type                                       varchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30),
 @p_application                                     varchar(20) output,
 @p_error                                           char(01) output,
 @p_msg_id                                          char(08) output,
 @p_process                                         varchar(15) = 'ONLINE',
 @p_utility_id										char(15) = null) --ticket 14801
as
 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(10)
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ' '
select @w_return                                    = 0
select @w_descp_add                                 = ' '
 
declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

declare @w_utility_id                               char(15)
declare @w_status                                   varchar(15)
declare @w_grace_period                             int
declare @w_contract_type                            varchar(15)
declare @w_date_created                             datetime
declare @w_date_submit                              datetime
declare @w_origin                                   varchar(50)
declare @w_product_id                               varchar(20)
declare @w_rate_id                                  int

select @w_utility_id                                = ' '
select @w_status                                    = 'DRAFT'
select @w_grace_period                              = 0
select @w_contract_type                             = ' '
select @w_date_created                              = '19000101'
select @w_date_submit                               = '19000101'
select @w_origin                                    = ' '
select @w_product_id                                = ' '
select @w_rate_id                                   = 0

print 'starting usp_contract_account_val'

if @p_action                                        = 'I'
begin
   select @w_utility_id                             = utility_id,
          @w_product_id                             = product_id,
          @w_rate_id                                = rate_id,
          @w_status                                 = status,
          @w_grace_period                           = grace_period,
          @w_contract_type                          = contract_type,
          @w_date_created                           = date_created,
          @w_date_submit                            = date_submit,
          @w_origin                                 = origin
   from deal_contract with (NOLOCK INDEX = deal_contract_idx)
   where contract_nbr                               = @p_contract_nbr
end
else
begin
   select @w_utility_id                             = a.utility_id,
          @w_product_id                             = a.product_id,
          @w_rate_id                                = a.rate_id,
          @w_status                                 = b.status,
          @w_grace_period                           = a.grace_period,
          @w_contract_type                          = a.contract_type,
          @w_date_created                           = a.date_created,
          @w_date_submit                            = a.date_submit,
          @w_origin                                 = a.origin
   from deal_contract_account a with (NOLOCK INDEX = deal_contract_account_idx),
        deal_contract b with (NOLOCK INDEX = deal_contract_idx)
   where a.contract_nbr                             = @p_contract_nbr
   and   a.account_number                           = @p_account_number
   and   a.contract_nbr                             = b.contract_nbr
end

exec @w_return = usp_contract_express_val @p_action,
                                          @p_contract_nbr,
                                          @p_account_number,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output,
                                          @w_product_id,
                                          @w_rate_id,
                                          @w_contract_type,
                                          @w_status,
                                          @w_grace_period,
                                          @w_date_created,
                                          @w_date_submit,
                                          @w_origin

--print 'error from usp_contract_express_val' 
--print @w_return

if @w_return                                       <> 0
begin
   if @p_process                                    = 'BATCH'
   begin
      select @w_descp_add                           = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

      exec usp_contract_error_ins 'DEAL_CAPTURE',
                                  @p_contract_nbr,
                                  @p_account_number,
                                  @w_application,
                                  @w_error,
                                  @w_msg_id,
                                  @w_descp_add
   end
   else
   begin
      goto goto_select
   end
end

declare @w_account_length                           int
declare @w_account_number_prefix                    varchar(10)
  
if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'ACCOUNT_NUMBER'
begin
 
   if @p_account_number                            is null
   or @p_account_number                             = ' '
   begin
      select @w_application                         = 'DEAL'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000033'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '('
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         goto goto_select
      end
   end

   if @p_action                                     = 'I'
   begin
      if exists(select contract_nbr
                from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
                where contract_nbr                  = @p_contract_nbr 
                and   account_number                = @p_account_number)
      begin
         select @w_application                      = 'DEAL'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000002'
         select @w_return                           = 1

         if @p_process                              = 'BATCH'
         begin

            select @w_descp_add                     = '('
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

            exec usp_contract_error_ins 'DEAL_CAPTURE',
                                        @p_contract_nbr,
                                        @p_account_number,
                                        @w_application,
                                        @w_error,
                                        @w_msg_id,
                                        @w_descp_add
         end
         else
         begin
            goto goto_select
         end
      end
   end

   if exists(select a.contract_nbr
             from deal_contract_account a with (NOLOCK INDEX = deal_contract_account_idx1),
                  deal_contract b with (NOLOCK INDEX = deal_contract_idx)
             where a.account_number                 = @p_account_number
             and   a.contract_nbr                  <> @p_contract_nbr
             and   a.contract_nbr                   = b.contract_nbr
             and  (b.status                         = 'RUNNING'
             or    b.status                         = 'SENT'))
   begin
      select @w_application                         = 'DEAL'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000002'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '('
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         goto goto_select
      end

   end

   declare @t_status                                varchar(15)
   declare @t_sub_status                            varchar(15)

   select @t_status                                 = ' '
   select @t_sub_status                             = ' '

   select @t_status                                 = status,
          @t_sub_status                             = sub_status
   from lp_account..account with (NOLOCK INDEX = account_idx1)
   where account_number                             = @p_account_number
		 and utility_id								= @w_utility_id
		 
   --print 'checkpoint 10'		 

   if   @@rowcount                                 <> 0
   and  ltrim(rtrim(@t_status))
   +    ltrim(rtrim(@t_sub_status))                <> '91100010'
   and  ltrim(rtrim(@t_status))
   +    ltrim(rtrim(@t_sub_status))                <> '99999810'
   and  ltrim(rtrim(@t_status))
   +    ltrim(rtrim(@t_sub_status))                <> '99999910'
   begin
      select @w_application                         = 'COMMON'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00001013'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '('
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         goto goto_select
      end
   end
end

--if exists(select contract_type
--          from deal_contract with (NOLOCK INDEX = deal_contract_idx)
--          where contract_nbr                        = @p_contract_nbr
--          and  (contract_type                       = 'PAPER'
--          or    contract_type                       = 'VOICE'
--		  or    contract_type                       = 'CORPORATE'))
--begin

   select @w_account_length                         = 0
   select @w_account_number_prefix                  = ' '
   
    if @p_utility_id is not null
	begin 
	select @w_utility_id = @p_utility_id
	end

   select @w_account_length                         = account_length,
          @w_account_number_prefix                  = account_number_prefix
   from lp_common..common_utility
   where utility_id                                 = @w_utility_id
   
   set @w_account_number_prefix = right(@w_account_number_prefix, (len(@w_account_number_prefix) - charindex('+', ltrim(rtrim(@w_account_number_prefix)))))

   set @p_account_number = ltrim(rtrim(@p_account_number))
   if @w_utility_id = 'CMP' and (len(@p_account_number) <= 13 OR left(@p_account_number,1) <> '0')
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000055'
      select @w_application                         = 'DEAL'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '('
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         goto goto_select
      end
   end   

   if  @w_account_length                            > 0
   and len(ltrim(rtrim(@p_account_number)))        <> @w_account_length
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000034'
      select @w_application                         = 'DEAL'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '('
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         goto goto_select
      end
   end

   if  len(ltrim(rtrim(@w_account_number_prefix))) <> 0
   and charindex(ltrim(rtrim(@w_account_number_prefix)), ltrim(rtrim(@p_account_number))) <> 1
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000035'
      select @w_application                         = 'DEAL'
      select @w_return                              = 1

      if @p_process                                 = 'BATCH'
      begin
         select @w_descp_add                        = '('
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'

         exec usp_contract_error_ins 'DEAL_CAPTURE',
                                     @p_contract_nbr,
                                     @p_account_number,
                                     @w_application,
                                     @w_error,
                                     @w_msg_id,
                                     @w_descp_add
      end
      else
      begin
         goto goto_select
      end
   end
--end
 
goto_select:

select @p_error                                     = @w_error
select @p_msg_id                                    = @w_msg_id
select @p_application                               = @w_application

return @w_return



