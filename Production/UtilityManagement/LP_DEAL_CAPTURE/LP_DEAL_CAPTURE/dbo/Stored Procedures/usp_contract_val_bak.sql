CREATE procedure [dbo].[usp_contract_val_bak]
(@p_username                                        nchar(100),
 @p_action                                          char(01),
 @p_edit_type                                       varchar(100),
 @p_contract_nbr                                    char(12),
 @p_contract_type                                   varchar(15),
 @p_status                                          varchar(15),
 @p_username_contract                               nchar(100),
 @p_contract_type_contract                          varchar(15),
 @p_sales_channel_role_contract                     nvarchar(50),
 @p_application                                     varchar(20) output,
 @p_error                                           char(01) output,
 @p_msg_id                                          char(08) output,
 @p_process                                         varchar(15) = 'ONLINE')
as
 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_return                                   int
declare @w_descp_add                                varchar(20)

select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_return                                    = 0
select @w_descp_add                                 = ' '

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

if @p_process                                    like 'BATCH_%'
begin
   goto goto_next_01
end

exec @w_return = usp_contract_express_val @p_action,
                                          @p_contract_nbr,
                                          'CONTRACT',
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output

if @w_return                                       <> 0
begin
   goto goto_select
end

goto_next_01:

if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'CONTRACT_NBR'
begin
 
   if @p_contract_nbr                              is null
   or @p_contract_nbr                               = ' '
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000011'
      select @w_application                         = 'DEAL'
      select @w_return                              = 1
      goto goto_select
   end
 
   if @p_action                                     = 'I'
   begin
      if exists(select *
                from deal_contract with (NOLOCK INDEX = deal_contract_idx)
                where contract_nbr                  = @p_contract_nbr)
      begin
         print 'contract insert validation'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000010'
         select @w_application                      = 'DEAL'
         select @w_return                           = 1
         goto goto_select
      end

      if @p_process                                 = 'BATCH_RENEW'
      begin
         goto goto_next_02
      end
      if exists(select *
                from lp_account..account with (NOLOCK INDEX = account_idx2)
                where contract_nbr                  = @p_contract_nbr)
      begin
         print 'contract submitted validaton'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000010'
         select @w_application                      = 'DEAL'
         select @w_return                           = 1
         goto goto_select
      end

      if @p_process                                 = 'BATCH_LOAD'
      begin
         goto goto_next_02
      end

      if exists(select null
                from lp_account..account_renewal with (NOLOCK INDEX = account_idx2)
                where contract_nbr                    = @p_contract_nbr)
      begin
         print 'renewal submitted validaton'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000010'
         select @w_application                      = 'DEAL'
         select @w_return                           = 1
         goto goto_select
      end
   end
end
 
goto_next_02:

if @p_edit_type                                     = 'ALL'
or @p_edit_type                                     = 'CONTRACT_TYPE'
begin
 
   if @p_contract_type                             is null
   or @p_contract_type                              = ' '
   or @p_contract_type                              = 'Corparate'
   or @p_contract_type                              = 'Power Move'

   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000012'
      select @w_application                         = 'DEAL'
      select @w_return                              = 1
      goto goto_select
   end

   if @p_contract_type                              IN ('PAPER')
   or @p_contract_type                              = 'PRE-PRINTED'
   begin
      if  not exists(select contract_nbr
                     from deal_contract_print with (NOLOCK INDEX = deal_contract_print_idx1)
                     where contract_nbr             = @p_contract_nbr
                     and   status                   = 'COMPLETED')
      and exists(select contract_nbr
                 from deal_contract with (NOLOCK INDEX = deal_contract_idx)
                 where contract_nbr                 = @p_contract_nbr
                 and   origin                       = 'ONLINE')
      
      begin
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000003'
         select @w_application                      = 'DEAL'
         select @w_return                           = 1
         goto goto_select
      end
   end
   else if @p_contract_type                         NOT LIKE '%CORPORATE%'
   begin
      if exists(select contract_nbr
                from deal_contract_print with (NOLOCK INDEX = deal_contract_print_idx1)
                where contract_nbr                     = @p_contract_nbr)
      begin
         print 'number printed already'
         select @w_error                            = 'E'
         select @w_msg_id                           = '00000010'
         select @w_application                      = 'DEAL'
         select @w_return                           = 1
         goto goto_select
      end
   end
-- commented out 11/7/2007
-- causing issues with pre-printed contracts
--   if exists(select *
--             from deal_contract with (NOLOCK INDEX = deal_contract_idx)
--             where contract_nbr                     = @p_contract_nbr
--             and   contract_type                   <> @p_contract_type)
--   begin
--      select @w_error                               = 'E'
--      select @w_msg_id                              = '00000010'
--      select @w_application                         = 'DEAL'
--      select @w_return                              = 1
--      goto goto_select
--   end


end
 
if @p_action                                        = 'I'
begin
   goto goto_select
end

if @p_username                                      = @p_username_contract
begin
   goto goto_select
end

declare @w_user_id                                  int

select @w_user_id                                   = UserID
from lp_portal..Users with (NOLOCK INDEX = IX_Users)
where Username                                      = @p_username

if  not exists(select b.RoleName 
       from lp_portal..UserRoles a with (NOLOCK INDEX = IX_UserRoles),
               lp_portal..Roles b with (NOLOCK INDEX = IX_RoleName)
               where a.UserID                       = @w_user_id
               and   a.RoleID                       = b.RoleID
               and   b.RoleName                     = @p_sales_channel_role_contract)
	and not exists(select b.RoleName 
                 from lp_portal..UserRoles a with (NOLOCK),
                 lp_portal..Roles b with (NOLOCK)
                 where a.UserID                     = @w_user_id
                 and   a.RoleID                     = b.RoleID
                 and   b.RoleName                   = 'LibertyPowerSales')
--and @p_process                                     <> 'ONLINE'
begin
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000004'
   select @w_application                            = 'DEAL'
   select @w_return                                 = 1
   goto goto_select
end

goto_select:

select @p_error                                     = @w_error
select @p_msg_id                                    = @w_msg_id
select @p_application                               = @w_application

return @w_return

