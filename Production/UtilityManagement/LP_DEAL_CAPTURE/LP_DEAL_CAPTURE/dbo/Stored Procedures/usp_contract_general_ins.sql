/*
exec usp_contract_general_ins 
@p_username=N'LIBERTYPOWER\dmarino',
@p_contract_nbr=N'646464646',
@p_retail_mkt_id=N'NY',
@p_utility_id=N'Select...',
@p_product_id=N'',
@p_rate_id=N'Select...',
@p_rate=N'',
@p_business_type=N'CORPORATION',
@p_business_activity=N'SUPERMARKET',
@p_additional_id_nbr_type=N'TAX ID',
@p_additional_id_nbr=N'7373737',
@p_contract_eff_start_date=N'01/01/1900',
@p_term_months=N'7',
@p_sales_channel_role=N'Sales Channel/Test',
@p_sales_rep=N'64646',
@p_account_number=N'CONTRACT',
@p_error=N'',
@p_msg_id=N'',
@p_descp=N'',
@p_result_ind=N'Y'
*/
--exec usp_contract_ins 'WVILCHEZ', '2006-0000121', 'PRINT'
--exec usp_contract_ins 'WVILCHEZ', '20060405 - W', 'VOICE'

CREATE procedure [dbo].[usp_contract_general_ins]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_business_type                                   varchar(35) = '',
 @p_business_activity                               varchar(35) = '',
 @p_additional_id_nbr_type                          varchar(10) = '',
 @p_additional_id_nbr                               varchar(30) = '',
 @p_sales_channel_role                              nvarchar(50) = '',
 @p_sales_rep                                       varchar(100) = '',
 @p_account_number                                  varchar(30) = '',
 @p_date_submit                                     datetime = '19000101',
 @p_deal_type                                       char(20) = '',
 @p_error                                           char(01) = '',
 @p_msg_id                                          char(08) = '',
 @p_descp                                           varchar(250) = '',
 @p_result_ind                                      char(01) = 'Y',
 @p_ssnClear										nvarchar(100) = NULL,
 @p_ssnEncrypted									nvarchar(512) = NULL,
 @p_sales_mgr										varchar(30) = '',
 @p_initial_pymt_option_id							int = 0,
 @p_residual_option_id								int = 0,
 @p_evergreen_option_id								int = 0,
 @p_residual_commission_end							datetime = null,
 @p_evergreen_commission_end						datetime = null,
 @p_evergreen_commission_rate						float = null,
 @p_tax_exempt										int = null

 )
as
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(20)
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ''
select @w_return                                    = 0
select @w_descp_add                                 = ''

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

select @p_contract_nbr                              = upper(@p_contract_nbr)

select @p_business_type                             = upper(@p_business_type)
select @p_business_activity                         = upper(@p_business_activity)
select @p_additional_id_nbr_type                    = upper(@p_additional_id_nbr_type)
select @p_additional_id_nbr                         = upper(@p_additional_id_nbr)
select @p_sales_rep                                 = upper(@p_sales_rep)

declare @w_contract_type                            varchar(15)
declare @w_business_type                            varchar(35)
declare @w_business_activity                        varchar(35)
declare @w_additional_id_nbr_type                   varchar(10)
declare @w_additional_id_nbr                        varchar(30)
declare @w_utility_id                               char(15)

declare @w_sales_rep                                varchar(100)
declare @w_sales_mgr                                varchar(30)
declare @w_date_deal                                datetime
declare @w_date_submit                              datetime
declare @w_sales_channel_role                       nvarchar(50)

declare @w_initial_pymt_option_id					int
declare @w_residual_option_id						int
declare @w_evergreen_option_id						int
declare @w_residual_commission_end					datetime
declare @w_evergreen_commission_end					datetime
declare @w_evergreen_commission_rate				float
declare @w_tax_exempt								int

select @w_contract_type                             = contract_type,
       @w_business_type                             = @p_business_type,
       @w_business_activity                         = @p_business_activity,
       @w_additional_id_nbr_type                    = @p_additional_id_nbr_type,
       @w_additional_id_nbr                         = @p_additional_id_nbr,
       @w_date_deal                                 = date_deal,
       @w_sales_rep                                 = @p_sales_rep,
       @w_date_submit                               = date_submit,
       @w_sales_channel_role                        = @p_sales_channel_role,
       @w_utility_id                                = utility_id,
       @w_sales_mgr									= @p_sales_mgr,
       @w_initial_pymt_option_id					=	 @p_initial_pymt_option_id,
       @w_residual_option_id						=	 @p_residual_option_id,
       @w_evergreen_option_id						=	 @p_evergreen_option_id,
       @w_residual_commission_end					=	 @p_residual_commission_end,
       @w_evergreen_commission_end					=	 @p_evergreen_commission_end,
       @w_evergreen_commission_rate					=	 @p_evergreen_commission_rate,
       @w_tax_exempt								=	@p_tax_exempt


from deal_contract with (NOLOCK INDEX = deal_contract_idx)
where contract_nbr                                  = @p_contract_nbr 

exec @w_return = usp_contract_general_val @p_username,
                                          'I',  
                                          'ALL',
                                          @p_contract_nbr,
                                          @p_account_number, 
                                          @p_business_type,
                                          @p_business_activity,
                                          @p_additional_id_nbr_type,
                                          @p_additional_id_nbr,
                                          @p_date_submit,
                                          @p_sales_channel_role,
                                          @p_sales_rep,
                                          @p_deal_type,
                                          @w_utility_id,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output

if @w_return                                       <> 0
begin
   goto goto_select
end

if @p_account_number                                = 'CONTRACT'
begin

   update deal_contract set business_type = @p_business_type,
                            business_activity = @p_business_activity,
                            additional_id_nbr_type = @p_additional_id_nbr_type,
                            additional_id_nbr = @p_additional_id_nbr,
                            date_submit = @w_date_submit,
                            sales_rep = @p_sales_rep,
                            sales_channel_role = @w_sales_channel_role,
                            deal_type = @p_deal_type,
                            ssnClear	 = case when @p_ssnClear is not null
                                             then @p_ssnClear
                                             else ssnClear
                                           end, --added for IT002
							ssnEncrypted = case when @p_ssnEncrypted is not null
                                             then @p_ssnEncrypted
                                             else ssnEncrypted
                                           end, --added for IT002

							sales_manager = @p_sales_mgr,
							initial_pymt_option_id = @p_initial_pymt_option_id,
							residual_option_id = @p_residual_option_id,
							evergreen_option_id = @p_evergreen_option_id,
							residual_commission_end = @p_residual_commission_end,
							evergreen_commission_end = @p_evergreen_commission_end,
							evergreen_commission_rate = @p_evergreen_commission_rate,
							TaxStatus = @p_tax_exempt
							
   from deal_contract with (NOLOCK INDEX = deal_contract_idx)
   where contract_nbr                               = @p_contract_nbr 

   if @@error                                      <> 0
   or @@rowcount                                    = 0
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = '(Contract)'
      goto goto_select
   end

   update deal_contract_account set contract_type = @w_contract_type,
									business_type = @p_business_type,
									business_activity = @p_business_type,
									additional_id_nbr_type = @p_additional_id_nbr_type,
									additional_id_nbr = @p_additional_id_nbr,
									date_deal = @w_date_deal,
                                    date_submit = @w_date_submit,
                                    sales_channel_role = @p_sales_channel_role,
                                    sales_rep = @p_sales_rep,
                                    deal_type = @p_deal_type,
                                    ssnClear	 = case when @p_ssnClear is not null
													 then @p_ssnClear
													 else ssnClear
												   end, --added for IT002
									ssnEncrypted = case when @p_ssnEncrypted is not null
													 then @p_ssnEncrypted
													 else ssnEncrypted
												   end --added for IT002
							-- Added Munoz 05/11/2010 begin
							,initial_pymt_option_id = @p_initial_pymt_option_id
							,residual_option_id = @p_residual_option_id
							,evergreen_option_id = @p_evergreen_option_id
							,residual_commission_end = @p_residual_commission_end
							,evergreen_commission_end = @p_evergreen_commission_end
							,evergreen_commission_rate = @p_evergreen_commission_rate
							,TaxStatus					= @p_tax_exempt
							
							-- Added Munoz 05/11/2010 End
--                                    business_type = case when business_type = 'NONE'
--                                                         then @p_business_type
--                                                         else business_type
--                                                    end,
--                                    business_activity = case when business_activity = 'NONE'
--                                                             then @p_business_activity
--                                                             else business_activity
--                                                        end,
--                                    additional_id_nbr_type = case when additional_id_nbr_type = 'NONE'
--                                                                  then @p_additional_id_nbr_type
--                                                                  else additional_id_nbr_type
--                                                             end,
--                                    additional_id_nbr = case when additional_id_nbr = ''
--                                                             then @p_additional_id_nbr
--                                                             else additional_id_nbr
--                                                        end,
--                                    date_deal = @w_date_deal,
--                                    date_submit = @w_date_submit,
--                                    sales_channel_role = case when sales_channel_role = ''
--                                                              then @p_sales_channel_role
--                                                              else sales_channel_role
--                                                         end,
--                                    sales_rep = case when sales_rep = ''
--                                                     then @p_sales_rep
--                                                     else sales_rep
--                                                end,
--                                    deal_type = case when deal_type = ''
--                                                     then @p_deal_type
--                                                     else deal_type
--                                                end
   from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
   where contract_nbr                               = @p_contract_nbr 

   if @@error                                      <> 0
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = '(Account)'
      goto goto_select
   end
end   
else
begin

   update deal_contract_account set contract_type = @w_contract_type,
                                    business_type = @w_business_type,
                                    business_activity = @w_business_activity,
                                    additional_id_nbr_type = @w_additional_id_nbr_type,
                                    additional_id_nbr = @w_additional_id_nbr,
                                    date_deal = @w_date_deal,
                                    date_submit = @w_date_submit,
                                    deal_type = @p_deal_type,
                                    sales_channel_role = @p_sales_channel_role,
                                    sales_rep          = @p_sales_rep,
                                    ssnClear	 = case when @p_ssnClear is not null
													 then @p_ssnClear
													 else ssnClear
												   end, --added for IT002
									ssnEncrypted = case when @p_ssnEncrypted is not null
													 then @p_ssnEncrypted
													 else ssnEncrypted
												   end --added for IT002

							-- Added Munoz 05/11/2010 Begin
							,initial_pymt_option_id = @p_initial_pymt_option_id
							,residual_option_id = @p_residual_option_id
							,evergreen_option_id = @p_evergreen_option_id
							,residual_commission_end = @p_residual_commission_end
							,evergreen_commission_end = @p_evergreen_commission_end
							,evergreen_commission_rate = @p_evergreen_commission_rate
							-- Added Munoz 05/11/2010 End
   from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
   where contract_nbr                               = @p_contract_nbr 
   and   account_number                             = @p_account_number

   if @@error                                      <> 0
   or @@rowcount                                    = 0
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = '(Contract - Account)'
      goto goto_select
   end

--   update deal_contract_account set sales_channel_role = @p_sales_channel_role,
--                                    sales_rep          = @p_sales_rep
--   where contract_nbr                               = @p_contract_nbr 

   insert into deal_contract_troubleshoot 
   (contract_nbr, sales_channel_role, sales_rep, username, line, sproc, rows_affected)
   values (@p_contract_nbr, @w_sales_channel_role, @p_sales_rep, @p_username, 118, 'usp_contract_general_ins', @@rowcount)

--   update deal_contract set sales_channel_role = @p_sales_channel_role,
--                            sales_rep          = @p_sales_rep
--   where contract_nbr                               = @p_contract_nbr 


   insert into deal_contract_troubleshoot 
   (contract_nbr, sales_channel_role, sales_rep, username, line, sproc, rows_affected)
   values (@p_contract_nbr, @w_sales_channel_role, @p_sales_rep, @p_username, 118, 'usp_contract_general_ins', @@rowcount)

   if @@error                                      <> 0
   or @@rowcount                                    = 0
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = '(Contract - Account)'
      goto goto_select
   end
end

select @w_return                                    = 0

goto_select:

if @w_error                                        <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp output,
                                    @w_application
   select @w_descp                                  = ltrim(rtrim(@w_descp))
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
--- END of procedure [dbo].[usp_contract_general_ins] -----------------------------------------------------------------

