﻿/*
 *******************************************************************************
 * Modified by Eric Hernandez
 * 9/2/2010
 * Applied grace period restiction to ABC channels.
 *******************************************************************************
 * 04/26/2012 - Jose Munoz - SWCS
 * Modify : Remove the views fot query (lp_portal..users or lp_portal..roles)
			and use the new table in libertypower database
 *******************************************************************************
*/   
 
CREATE procedure [dbo].[usp_contract_express_val_jmunoz]
(@p_action                                          char(01),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30),
 @p_application                                     varchar(20) output,
 @p_error                                           char(01) output,
 @p_msg_id                                          char(08) output,
 @p_product_id                                      varchar(20) = ' ',
 @p_rate_id                                         int = 0,
 @p_contract_type                                   varchar(15) = ' ',
 @p_status                                          varchar(15) = ' ',
 @p_grace_period                                    int = 0,
 @p_date_created                                    datetime = '19000101',
 @p_date_submit                                     datetime = '19000101',
 @p_origin                                          varchar(50) = ' ',
 @p_process                                         varchar(15) = 'ONLINE')
as

declare @w_error									char(01)
	,@w_msg_id										char(08)
	,@w_application									varchar(20)
	,@w_return										int
	,@w_username									nchar(100)
	,@w_user_id										int
	,@w_status										varchar(15)
	,@w_grace_period								int
	,@w_contract_type								varchar(15)
	,@w_date_created								datetime
	,@w_date_deal									datetime
	,@w_date_submit									datetime
	,@w_origin										varchar(50)
	,@w_product_id									varchar(20)
	,@w_rate_id										int
 
select @w_error										= 'I'
	,@w_msg_id										= '00000001'
	,@w_application									= 'COMMON'
	,@w_return										= 0

if @p_action                                       <> 'V'
begin
	if @p_status                                     = ' '
	begin
		select @w_status                            = 'DRAFT'
			,@w_grace_period                        = 0
			,@w_contract_type                       = ' '
			,@w_date_created                        = '19000101'
			,@w_date_submit                         = '19000101'
			,@w_origin                              = ' '
			,@w_product_id                          = ' '
			,@w_rate_id                             = 0

		if @p_account_number                        = 'CONTRACT'
			or not exists(	select a.account_number
							from deal_contract_account a with (NOLOCK INDEX = deal_contract_account_idx)
							inner join deal_contract b with (NOLOCK INDEX = deal_contract_idx)
							on b.contract_nbr						= a.contract_nbr
							where a.contract_nbr					= @p_contract_nbr
							and   a.account_number					= @p_account_number)
      begin
         select @w_product_id                       = product_id,
                @w_rate_id                          = rate_id,
                @w_status                           = [status],
                @w_grace_period                     = grace_period,
                @w_contract_type                    = contract_type,
				@w_date_deal						= date_deal,
                @w_date_created                     = date_created,
                @w_date_submit                      = date_submit,
                @w_origin                           = origin,
				@w_username							= username
         from deal_contract with (NOLOCK INDEX = deal_contract_idx)
         where contract_nbr                         = @p_contract_nbr
      end
      else
      begin
         select @w_product_id                       = a.product_id,
                @w_rate_id                          = a.rate_id,
                @w_status                           = b.[status],
                @w_grace_period                     = a.grace_period,
                @w_contract_type                    = a.contract_type,
				@w_date_deal						= b.date_deal,
                @w_date_created                     = a.date_created,
                @w_date_submit                      = a.date_submit,
                @w_origin                           = a.origin,
				@w_username							= a.username
         from deal_contract_account a with (NOLOCK INDEX = deal_contract_account_idx)
         inner join deal_contract b with (NOLOCK INDEX = deal_contract_idx)
         on b.contract_nbr							= a.contract_nbr
         where a.contract_nbr                       = @p_contract_nbr
         and   a.account_number                     = @p_account_number
      end
   end
   else
   begin
      select @w_status                              = @p_status
			,@w_grace_period                        = @p_grace_period
			,@w_contract_type                       = @p_contract_type
			,@w_date_created                        = @p_date_created
			,@w_date_submit                         = @p_date_submit
			,@w_origin                              = @p_origin
			,@w_product_id                          = @p_product_id
			,@w_rate_id                             = @p_rate_id
   end

   if @p_account_number                            <> 'CONTRACT'
   begin

      if exists(select status
                from deal_contract with (NOLOCK INDEX = deal_contract_idx)
                where contract_nbr                  = @p_contract_nbr
                and  (customer_name_link            = 0
                or  customer_address_link			= 0
                or  customer_contact_link			= 0
				or	retail_mkt_id					= 'NN'
				or	retail_mkt_id					is null
				or	utility_id						= 'NONE'
				or	utility_id						is null
				or	product_id						= 'NONE'
				or	product_id						is null
				or	rate_id							= 999999999
				or	rate_id							is null))
      and @p_action                                <> 'D'                        
      begin
         select @w_application                      = 'DEAL'
				,@w_error                           = 'E'
				,@w_msg_id                          = '00000005'
				,@w_return                          = 1
         goto goto_select
      end
   end
 
   select @w_user_id                                = UserID
   from	libertypower..[User] with (NOLOCK)
   where Username                                   = (select isnull(replace(sales_channel_role,'sales channel/','libertypower\'),username)
													   from deal_contract with (NOLOCK INDEX = deal_contract_idx)
													   where contract_nbr = @p_contract_nbr)

-- Removed the IF block below after code review.  This logic is no longer valid.  EH 2010-09-02
--	-- do not validate grace period on ABC channels
--   if not exists (select a.UserRoleID
--                  from lp_portal..UserRoles a with (NOLOCK),
--                       lp_portal..Roles b with (NOLOCK),
--                       lp_security..security_role_activity c with (NOLOCK)
--                  where a.UserID                    = @w_user_id
--                  and   a.RoleID                    = b.RoleID
--                  and   b.RoleName                  = 'ABC flexible pricing')
--   begin
      if @w_grace_period                    = 0
      and @w_contract_type                          = 'VOICE' 
      begin
         select @w_grace_period                     = grace_period
         from lp_common..common_product_rate with (NOLOCK INDEX = common_product_rate_idx)
         where product_id                           = @w_product_id
         and   rate_id                              = @w_rate_id
         and   eff_date                            <= convert(char(08), getdate(), 112)
         and   due_date                            >= convert(char(08), getdate(), 112)
      end

		print 'grace_period is '
		print @w_grace_period

      if (@w_contract_type                          = 'VOICE' 
      or  @w_contract_type                          = 'PAPER'
      or  @p_contract_type                          = 'PRE-PRINTED')
      and @w_grace_period                          <> 0
      begin
         if @w_origin                               = 'ONLINE'
         begin
            if dateadd(dd, @w_grace_period, @w_date_deal) <= convert(char(08), getdate(), 112)
            begin
               select @w_application               = 'DEAL'
					,@w_error                      = 'E'
               		,@w_msg_id                     = '00000036'
               		,@w_return                     = 1
               goto goto_select
            end
         end
         else
         begin
            if dateadd(dd, @w_grace_period, @w_date_deal) <= convert(char(08), getdate(), 112)
            begin
               select @w_application               = 'DEAL'
               		,@w_error                      = 'E'
               		,@w_msg_id                     = '00000036'
               		,@w_return                     = 1
               goto goto_select
            end
         end
      end
--   end

   if exists(select status
             from deal_contract with (NOLOCK INDEX = deal_contract_idx)
             where contract_nbr                     = @p_contract_nbr
             and   status                           = 'SENT')
   begin
      select @w_error                               = 'E'
      		,@w_msg_id                              = '00000042'
      		,@w_application                         = 'DEAL'
      		,@w_return                              = 1
      goto goto_select
   end

   if @p_process                                    = 'BATCH_RENEW'
   begin
      goto goto_select
   end

   if exists(select *
             from lp_account..account with (NOLOCK)
             where contract_nbr                    = @p_contract_nbr)
   begin
      select @w_error                               = 'E'
      		,@w_msg_id                              = '00000010'
      		,@w_application                         = 'DEAL'
      		,@w_return                              = 1
      goto goto_select
   end
end

goto_select:

select @p_error                                   = @w_error
	,@p_msg_id                                    = @w_msg_id
	,@p_application                               = @w_application

return @w_return