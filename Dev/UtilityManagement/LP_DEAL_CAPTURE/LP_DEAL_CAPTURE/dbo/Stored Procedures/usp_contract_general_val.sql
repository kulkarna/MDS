CREATE procedure [dbo].[usp_contract_general_val]
(@p_username                                        nchar(100),
 @p_action                                          char(01),
 @p_edit_type                                       varchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30),
 @p_business_type                                   varchar(35),
 @p_business_activity                               varchar(35),
 @p_additional_id_nbr_type                          varchar(10),
 @p_additional_id_nbr                               varchar(30),
 @p_date_submit                                     datetime,
 @p_sales_channel_role                              nvarchar(50),
 @p_sales_rep                                       varchar(100),
 @p_deal_type                                       char(20) = '',
 @p_utility_id                                      char(15) = '',
 @p_application                                     varchar(20) output,
 @p_error                                           char(01) output,
 @p_msg_id                                          char(08) output,
 @p_process                                         varchar(15) = 'ONLINE')
as

declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(100)
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ' '
select @w_return                                    = 0
select @w_descp_add                                 = ' '
 
declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

exec @w_return = usp_contract_express_val @p_action,
                                          @p_contract_nbr,
                                          @p_account_number,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output,
                                          ' ',
                                          0,
                                          ' ',
                                          ' ',
                                          0,
                                          '19000101',
                                          '19000101',
                                          ' ',
                                          @p_process

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
--New Contract - start
      if @p_process                              like 'BATCH_%'
      begin
          select @w_descp_add                       = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
         insert into #contract_error
         select @p_contract_nbr,
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
--New Contract - end
end

 
if (@p_edit_type                                    = 'ALL'
or  @p_edit_type                                    = 'ACCOUNT_NUMBER')
and @p_account_number                              <> 'CONTRACT'
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
--New Contract - start
         if @p_process                           like 'BATCH_%'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
            insert into #contract_error
            select @p_contract_nbr,
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
--New Contract - end
   end
end

if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'ADDITIONAL_ID_NBR'
begin
   if (@p_additional_id_nbr                        is null
   or  @p_additional_id_nbr                         = ' ')
   and @p_additional_id_nbr_type                   <> 'NONE'
   begin
      select @w_application                         = 'DEAL'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000029'
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
--New Contract - start
         if @p_process                           like 'BATCH_%'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
            insert into #contract_error
            select @p_contract_nbr,
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
--New Contract - end
   end
 
end

if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'ADDITIONAL_ID_NBR_TYPE'
begin
 
   if (@p_additional_id_nbr_type                   is null
   or  @p_additional_id_nbr_type                    = ' '
   or  @p_additional_id_nbr_type                    = ''
   or  @p_additional_id_nbr_type                    = 'NONE') 
   and (@p_additional_id_nbr                       <> ' '
--New Contract - start
   and  @p_additional_id_nbr                       <> 'NONE'
--New Contract - end
   and  @p_additional_id_nbr                   is not null)
   begin
      select @w_application                         = 'DEAL'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000028'
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
--New Contract - start
         if @p_process                           like 'BATCH_%'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
            insert into #contract_error
            select @p_contract_nbr,
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
--New Contract - end
   end
 
end
  
if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'SALES_CHANNEL_ROLE'
begin
 
   if @p_sales_channel_role                        is null
   or @p_sales_channel_role                         = ' '
   or @p_sales_channel_role                         = 'NONE'
   begin
      select @w_application                         = 'DEAL'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000032'
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
--New Contract - start
         if @p_process                           like 'BATCH_%'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
            insert into #contract_error
            select @p_contract_nbr,
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
--New Contract - end
   end

   declare @w_user_id                               int

   select @w_user_id                                = UserID
   from lp_portal..Users with (NOLOCK INDEX = IX_Users)
   where Username                                   = @p_username

   if not exists(select b.RoleName 
                 from lp_portal..UserRoles a with (NOLOCK INDEX = IX_UserRoles),
                 lp_portal..Roles b with (NOLOCK INDEX = IX_RoleName)
                 where a.UserID                     = @w_user_id
                 and   a.RoleID                     = b.RoleID
                 and   b.RoleName                   = @p_sales_channel_role)
	and not exists(select b.RoleName 
                 from lp_portal..UserRoles a with (NOLOCK),
                 lp_portal..Roles b with (NOLOCK)
                 where a.UserID                     = @w_user_id
                 and   a.RoleID                     = b.RoleID
                 and   b.RoleName                   = 'LibertyPowerEmployes')
   begin
      select @w_application                         = 'DEAL'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000041'
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
--New Contract - start
         if @p_process                           like 'BATCH_%'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
            insert into #contract_error
            select @p_contract_nbr,
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
--New Contract - end
   end

end

if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'SALES_REP'
begin
 
   if @p_sales_rep                                 is null
   or @p_sales_rep                                  = ' '
   begin
      select @w_application                         = 'DEAL'
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000031'
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
--New Contract - start
         if @p_process                           like 'BATCH_%'
         begin
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
            insert into #contract_error
            select @p_contract_nbr,
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
--New Contract - end
   end
end

if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'METER_NUMBER'
begin
   if  @p_process                                like 'BATCH_%'
   and @p_account_number                           <> 'CONTRACT'
   begin

      declare @w_account_id                         char(12)

      select @w_account_id                          = ''

      select @w_account_id                          = account_id
      from lp_deal_capture..deal_contract_account (NOLOCK)
      where contract_nbr                            = @p_contract_nbr
      and   account_number                          = @p_account_number

      declare @w_meter_number_required              smallint
      declare @w_meter_number_length                smallint

      select @w_meter_number_required               = 0
      select @w_meter_number_length                 = 0

      select @w_meter_number_required               = meter_number_required,
             @w_meter_number_length                 = meter_number_length
      from lp_common..common_utility 
      where utility_id                              = @p_utility_id
      
      if @w_meter_number_required                   = 1
      begin   
         if not exists(select top 1
                              account_id
                       from lp_deal_capture..account_meters (NOLOCK)
                       where account_id             = @w_account_id)
         begin
            select @w_descp_add                     = ''
            select @w_application                   = 'DEAL'
            select @w_error                         = 'E'
            select @w_msg_id                        = '00000046'
            select @w_return                        = 1
 
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
            insert into #contract_error
            select @p_contract_nbr,
                   @p_account_number,
                   @w_application,
                   @w_error,
                   @w_msg_id,
                   @w_descp_add

            goto goto_select
         end

         declare @w_count                           int

         select @w_count                            = 0

         select @w_count                            = count(*)
         from lp_deal_capture..account_meters (NOLOCK)
         where account_id                           = @w_account_id
         and   len(ltrim(rtrim(meter_number)))      > 0
         and   len(ltrim(rtrim(meter_number)))     <> @w_meter_number_length
         
         if @w_count                                > 0
         begin
            select @w_descp_add                     = ', please enter the ('
                                                    + ltrim(rtrim(convert(char(10), @w_meter_number_length)))
                                                    + ') digit value for this account ('
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
                                                    
            select @w_application                   = 'COMMON'
            select @w_error                         = 'E'
            select @w_msg_id                        = '00001071'
         
            select @w_return                        = 1

            insert into #contract_error
            select @p_contract_nbr,
                   @p_account_number,
                   @w_application,
                   @w_error,
                   @w_msg_id,
                   @w_descp_add
            goto goto_select
         end
      end
      else
      begin
         if exists (select top 1
                           account_id
                    from lp_deal_capture..account_meters (NOLOCK)
                    where account_id                = @w_account_id)
         begin
            select @w_descp_add                     = ''
            select @w_application                   = 'DEAL'
            select @w_error                         = 'E'
            select @w_msg_id                        = '00000054'
            select @w_return                        = 1
 
            select @w_descp_add                     = '(' 
                                                    + case when @p_account_number = 'CONTRACT'
                                                           then ' ' 
                                                           else ' Account Number '
                                                      end
                                                    + ltrim(rtrim(@p_account_number)) + ')'
            insert into #contract_error
            select @p_contract_nbr,
                   @p_account_number,
                   @w_application,
                   @w_error,
                   @w_msg_id,
                   @w_descp_add

            goto goto_select
         end
      end
   end
end

goto_select:

select @p_error                                     = @w_error
select @p_msg_id                                    = @w_msg_id
select @p_application                               = @w_application

return @w_return

