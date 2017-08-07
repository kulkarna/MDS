USE [Lp_Account]
GO

/****** Object:  StoredProcedure [dbo].[usp_account_renewal_upd]    Script Date: 02/18/2013 10:00:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_account_renewal_upd]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_account_renewal_upd]
GO

USE [Lp_Account]
GO

/****** Object:  StoredProcedure [dbo].[usp_account_renewal_upd]    Script Date: 02/18/2013 10:00:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- drop procedure usp_account_renewal_upd
-- =================================================
-- Author:		Rick Deigsler
-- Create date: 3/26/2007
-- Description:	Update account renewal data
-- =================================================
-- Isabelle Tamanini
-- Modified: 04/21/2010 to add the Encrypted Fields
-- =============================================
-- Modified: Jose Munoz 8/4/2011
-- Fields regards sales channel were added. 
-- initial_pymt_option_id, residual_option_id, evergreen_option_id and sales_manager 
-- will be changed when the sales channel was changed
-- Ticket 1-1025061
-- =============================================
-- José Muñoz
-- Ticket 1-4825517
-- Modified: 11/23/2011 
-- Rate restriction needed for Renewal contract entry
-- =============================================
-- Jikku Joseph John
-- Product Backlog Item: 7357
-- Modified: 2/14/2013 
-- Section added to set payment term. This is similar to what is done for account updates
-- =============================================
CREATE procedure [dbo].[usp_account_renewal_upd]
(@p_username                                        nchar(100),
 @p_account_id                                      char(12),
 @p_account_number                                  varchar(30),
 @p_account_type                                    varchar(25),
 @p_status                                          varchar(15),
 @p_sub_status                                      varchar(15),
 @p_customer_id                                     varchar(10),
 @p_entity_id                                       char(15),
 @p_contract_nbr                                    char(12),
 @p_contract_type                                   varchar(25),
 @p_retail_mkt_id                                   char(02),
 @p_utility_id                                      char(15),
 @p_product_id                                      char(20),
 @p_rate_id                                         int,
 @p_rate                                            float,
 @p_business_type                                   varchar(35),
 @p_business_activity                               varchar(35),
 @p_additional_id_nbr_type                          varchar(10),
 @p_additional_id_nbr                               varchar(30),
 @p_contract_eff_start_date                         datetime,
 @p_term_months                                     int,
 @p_date_end                                        datetime,
 @p_date_deal                                       datetime,
 @p_date_created                                    datetime,
 @p_date_submit                                     datetime,
 @p_sales_channel_role                              nvarchar(50),
 @p_sales_rep                                       varchar(100),
 @p_origin                                          varchar(50),
 @p_annual_usage                                    int = NULL,
 @p_date_flow_start                                 datetime,
 @p_date_por_enrollment                             datetime,
 @p_date_deenrollment                               datetime,
 @p_date_reenrollment                               datetime,
 @p_tax_status                                      varchar(20),
 @p_tax_rate                                        float,
 @p_credit_score                                    real,
 @p_credit_agency                                   varchar(30),
 @p_por_option                                      varchar(03) = ' ',
 @p_billing_type                                    varchar(15) = ' ',
 @p_old_chgstamp                                    smallint,
 @p_error                                           char(01),
 @p_msg_id                                          char(08),
 @p_descp                                           varchar(250),
 @p_result_ind                                      char(01) = 'Y',
 @p_ssnEncrypted									nvarchar(512) = null, --added for IT002
 @p_credit_score_encrypted							nvarchar(512) = null,  --added for IT002
 @p_paymentTerm										int = 0)
as
 
--print 'disabled due to production issues' -- Eric Hernandez  20100507


declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(200)
declare @w_rate_cap									float		-- Added Ticket 1-4825517
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ''
select @w_return									= 0
select @w_descp_add                                 = ''

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

declare @w_new_chgstamp                             smallint 


exec lp_common..usp_calc_chgstamp @p_old_chgstamp, 
                                  @w_new_chgstamp output 


select @p_retail_mkt_id                             = upper(@p_retail_mkt_id)
select @p_utility_id                                = upper(@p_utility_id)
select @p_product_id                                = upper(@p_product_id)
select @p_business_type                             = upper(@p_business_type)
select @p_business_activity                         = upper(@p_business_activity)
select @p_additional_id_nbr_type                    = upper(@p_additional_id_nbr_type)
select @p_additional_id_nbr                         = upper(@p_additional_id_nbr)

declare @w_contract_type                            varchar(15)
declare @w_retail_mkt_id                            char(02)
declare @w_utility_id                               char(15)
declare @w_product_id                               char(20)
declare @w_rate_id                                  int
declare @w_rate                                     float
declare @p_rate_plus_tax							float
declare @w_business_type                            varchar(35)
declare @w_business_activity                        varchar(35)
declare @w_additional_id_nbr_type                   varchar(10)
declare @w_additional_id_nbr                        varchar(30)
declare @w_contract_eff_start_date                  datetime
declare @w_term_months                              int
declare @w_sales_rep                                varchar(100)
declare @w_date_end                                 datetime
declare @w_date_deal                                datetime
declare @w_date_submit                              datetime
declare @w_sales_channel_role                       nvarchar(50)
declare @w_grace_period                             int
declare @w_invalid_rate								int

declare @w_evergreen_option_id						int				-- Added Ticket # 1-1025061
declare @w_residual_option_id						int				-- Added Ticket # 1-1025061
declare @w_initial_pymt_option_id					int				-- Added Ticket # 1-1025061
declare @w_sales_manager							varchar(100)	-- Added Ticket # 1-1025061

--Begin Ticket # 1-1025061
select	@w_initial_pymt_option_id		= initial_pymt_option_id,
		@w_residual_option_id			= residual_option_id, 
		@w_evergreen_option_id			= evergreen_option_id,
		@w_sales_manager				= u.FirstName + ' ' + u.LastName	
from lp_commissions..vendor v with (nolock)
left join LibertyPower..SalesChannel sc with (nolock)
on v.ChannelId						= sc.ChannelID
left join LibertyPower..[User] u with (nolock)
on sc.ChannelDevelopmentManagerID	= u.UserId
where vendor_system_name			= @p_sales_channel_role
--End Ticket # 1-1025061


-- Check the rate being updated is not lower than the transfer rate in the history table
set @w_invalid_rate = 0

print 'evaluating history rate'

Select @w_rate					=	rate
  from lp_common..product_rate_history (nolock)
 where product_id				=	@p_product_id
   and rate_id					=	@p_rate_id
   and eff_date					=	dateadd(d, 0, datediff(d, 0, @p_date_deal))					-- Added Ticket 1-4825517
   and contract_eff_start_date	=	dateadd(m, datediff(m, 0, @p_contract_eff_start_date),0)	-- Added Ticket 1-4825517
   --and eff_date					=	convert(varchar(8), @p_date_deal,112)					-- Commented Ticket 1-4825517
   --and contract_eff_start_date	=	convert(varchar(8), @p_contract_eff_start_date, 112)	-- Commented Ticket 1-4825517
 
 print 'The contract rate ' + convert(nvarchar(15),@p_rate) + ' and the transfer rate ' + convert(nvarchar(15),@w_rate)
   
DECLARE @Tax FLOAT
SELECT @Tax = SalesTax
FROM LibertyPower..Market M
JOIN LibertyPower..MarketSalesTax MST ON M.ID = MST.MarketID
WHERE M.MarketCode = @p_retail_mkt_id

IF @Tax IS NULL
	SET @Tax = 0.0
	
SET @p_rate_plus_tax = ROUND(@p_rate * (1 + @Tax),5)
 
 If @p_rate_plus_tax < @w_rate
 -- If @p_rate < @w_rate
  
 Begin
	set @w_error										= 'E'
	set @w_msg_id										= '00001078'
	set @w_descp_add									= 'Unable to update the rate value.  The contract rate ' + convert(nvarchar(15),@p_rate) + ' is lower than the transfer rate ' + convert(nvarchar(15),@w_rate)
	goto goto_select 
 End
 

 -- End check rate validity against history data
/* Ticket 1-4825517 Begin */
Select Top 1
 @w_rate_cap    = rate_cap
from lp_deal_capture..deal_rate (nolock)
order by 1 desc

If @p_rate > (@w_rate_cap + @w_rate) 
Begin
	set @w_error			= 'E'
	set @w_msg_id			= '00001078'
	set @w_descp_add		= 'Unable to update the rate value.  The contract rate ' + convert(nvarchar(15),@p_rate) + ' is higher than the max rate cap allowed' + convert(nvarchar(15),(@w_rate_cap + @w_rate))
	goto goto_select 
End
/* Ticket 1-4825517 End */ 

 -- End check rate validity against history data

SET @w_contract_eff_start_date = @p_contract_eff_start_date
SET @w_date_end = DATEADD(mm, @p_term_months, DATEADD(dd, -1, @w_contract_eff_start_date))

if  @w_contract_type                                = 'VOICE RENEWAL'
begin
   select @p_term_months                            = term_months
   from lp_common..common_product WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_product_idx)
   where product_id                                 = @p_product_id
   and   inactive_ind                               = '0'

   select @p_contract_eff_start_date                = contract_eff_start_date
   from lp_common..common_product_rate WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_product_rate_idx)
   where product_id                                 = @p_product_id
   and   rate_id                                    = @p_rate_id
   and   convert(char(08), getdate(), 112)         >= eff_date
   and   convert(char(08), getdate(), 112)          < due_date
   and   inactive_ind                               = '0'
end

exec @w_return = usp_account_renewal_val @p_username,
                                'U',  
                                'ALL',
                                @p_account_id,
                                @p_account_number,
                                @p_account_type,
                                @p_status,
                                @p_sub_status,
                                @p_customer_id,
                                @p_entity_id,
                                @p_contract_nbr,
                                @p_contract_type,
                                @p_retail_mkt_id,
                                @p_utility_id,
                                @p_product_id,
                                @p_rate_id,
                                @p_rate,
                                @p_business_type,
                                @p_business_activity,
                                @p_additional_id_nbr_type,
                                @p_additional_id_nbr,
          @w_contract_eff_start_date,
                                @p_term_months,
                                @w_date_end,
                                @p_date_deal,
                                @p_date_created,
                                @p_date_submit,
                                @p_sales_channel_role,
                                @p_sales_rep,
                                @p_origin,
                                @p_annual_usage,
                                @p_date_flow_start,
                                @p_date_por_enrollment,
                                @p_date_deenrollment,
                                @p_date_reenrollment,
                                @p_tax_status,
                                @p_tax_rate,
                                @p_credit_score,
                                @p_credit_agency,
                                @w_application output,
                                @w_error output,
                                @w_msg_id output

if @w_return                                       <> 0
begin
   goto goto_select
end

if  @w_contract_type                                = 'VOICE RENEWAL'
begin
   select @w_grace_period                           = grace_period
   from lp_common..common_product_rate WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_product_rate_idx)
   where product_id                                 = @p_product_id
   and   rate_id                                    = @p_rate_id
   and   inactive_ind                               = '0'
   and   eff_date                                  <= convert(char(08), getdate(), 112)
   and   due_date                                  >= convert(char(08), getdate(), 112)
end

update account_renewal set chgstamp = @w_new_chgstamp,
                   account_number = @p_account_number,
                   contract_nbr = @p_contract_nbr,
                   account_type = @p_account_type,
                   contract_type = @p_contract_type,
                   retail_mkt_id = @p_retail_mkt_id,
                   customer_id = @p_customer_id,
                   utility_id = @p_utility_id,
                   product_id = @p_product_id,
                   rate_id = @p_rate_id,
                   rate = @p_rate,
                   business_type = @p_business_type,
                   business_activity = @p_business_activity,
                   additional_id_nbr_type = @p_additional_id_nbr_type,
                   additional_id_nbr = @p_additional_id_nbr,
                   contract_eff_start_date = @w_contract_eff_start_date,
                   term_months = @p_term_months,
                   date_end = @w_date_end,
                   date_deal = @p_date_deal,
                   date_submit = @p_date_submit,
                   sales_channel_role = @p_sales_channel_role,
                   sales_rep = @p_sales_rep,
                   annual_usage = @p_annual_usage,
                   date_flow_start = @p_date_flow_start,
                   date_por_enrollment = @p_date_por_enrollment,
                   date_deenrollment = @p_date_deenrollment,
                   date_reenrollment = @p_date_reenrollment,
                   tax_status = @p_tax_status,
                   tax_rate = @p_tax_rate,
                   credit_score = @p_credit_score,
                   credit_agency = @p_credit_agency,
                   por_option = case when @p_por_option <> ' '
                                     then @p_por_option
                                     else por_option
                                end,
                   billing_type = case when @p_billing_type <> ' '
                                       then @p_billing_type
                                       else billing_type
  end,
				    SSNEncrypted = case when @p_ssnEncrypted is not null
                                       then @p_ssnEncrypted
                                       else SSNEncrypted
                                   end, --added for IT002
                   CreditScoreEncrypted	= case when @p_credit_score_encrypted is not null
                                              then @p_credit_score_encrypted
                                              else CreditScoreEncrypted
                                          end --added for IT002
                                          
					-- Begin Ticket # 1-1025061
					,initial_pymt_option_id			= @w_initial_pymt_option_id 
					,residual_option_id				= @w_residual_option_id
					,evergreen_option_id			= @w_evergreen_option_id
					,sales_manager					= ISNULL(@w_sales_manager,sales_manager)	
					-- End Ticket # 1-1025061                                          
                                          
from account_renewal with (NOLOCK)
where account_id                                    = @p_account_id
and   chgstamp                                      = @p_old_chgstamp

if @@rowcount                                       = 0 
begin 
   if exists(select * 
             from account_renewal with (NOLOCK)
             where account_id                       = @p_account_id)
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000045'
      select @w_return                              = 1
      goto goto_select 
   end
   else
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000046'
      select @w_return                              = 1
      goto goto_select 
   end
end 

-- As part of PBI: 7357
INSERT INTO AccountPaymentTerm
select a.AccountIdLegacy, @p_paymentTerm, GETDATE()
from libertypower..account    a (nolock)
join libertypower..[contract] c (nolock) on a.CurrentRenewalContractID = c.contractid
left join lp_account..AccountPaymentTerm apt on apt.accountId = a.AccountIdLegacy
where c.number = @p_contract_nbr
and apt.accountId is null

update AccountPaymentTerm 
set paymentTerm = @p_paymentTerm
from lp_account..AccountPaymentTerm apt
join libertypower..account    a (nolock) on a.AccountIdLegacy = apt.accountid
join libertypower..[contract] c (nolock) on a.CurrentRenewalContractID = c.contractid
where c.number = @p_contract_nbr

--end of addition for PBI: 7357

select @w_return                                    = 0

goto_select:

if @w_error                                        <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp output,
                                    @w_application
   select @w_descp                                  = ltrim(rtrim(@w_descp))
                                                    + ': '
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


GO


