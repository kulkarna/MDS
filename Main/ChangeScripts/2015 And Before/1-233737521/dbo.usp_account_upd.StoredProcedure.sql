USE [Lp_Account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_upd]    Script Date: 10/23/2013 15:35:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Modified: Jose Munoz 1/28/2010
-- add HeatIndexSourceID and HeatRate for account table  
-- Project IT037
-- =================================================
-- Isabelle Tamanini
-- Modified: 04/21/2010 to add the Encrypted Fields
-- =================================================
-- Sofia Melo
-- Modified: 06/24/2010 to add the Tax Details insert or update
-- =============================================
-- Modified: Jose Munoz 11/03/2010
-- Ticket 19390
-- Change update to avoid update the contract type if is '' 
--  contract_type                    = @p_contract_type,
--  to
--  contract_type                    = case when ltrim(rtrim(@p_contract_type)) = '' 
--										then contract_type 
--										else ltrim(rtrim(@p_contract_type)) End,
-- =============================================
-- Isabelle Tamanini
-- Modified: 12/15/2010 to fix the insert / update of tax details 
-- (only the first detail was being inserted)
-- =============================================
-- Thiago Nogueira
-- Modified: 01/05/2011 to fix the insert / update of tax details when parameters are empty
-- (getting error converting)
-- =============================================
-- Thiago Nogueira
-- Ticket 20866
-- Modified: 01/19/2011 to update flow and deenrollment dates in AccountService table
-- =============================================
-- Isabelle Tamanini
-- Ticket 23527 
-- Modified: 06/06/2011 to update the size of sales rep parameter
-- =============================================
-- José Muñoz
-- Ticket 24169 
-- Modified: 07/08/2011 
-- Compare @p_rate with the rate_cap value in the table lp_deal_capture..deal_rate
-- throw an exception similar to the exception if the rate is too low.
-- =============================================
-- José Muñoz
-- Ticket 24345
-- Modified: 07/18/2011 
-- change in the ticket 24169 definition.
-- =============================================
-- =============================================
-- Modified: Diogo Lima 8/2/2011
-- Fields regards sales channel were added. 
-- initial_pymt_option_id, residual_option_id, evergreen_option_id and sales_manager 
-- will be changed when the sales channel was changed
-- Ticket 1-920833
-- =================================================
-- Modified: Jaime Forero
-- Added this check:
-- IF NOT EXISTS (SELECT * FROM LibertyPower..AccountService WHERE account_id = @p_account_id AND StartDate = @p_date_flow_start AND EndDate = @p_date_deenrollment)
-- To fix for ticket # 20866, it prevents duplicate values to be added to the
--
-- =================================================
-- Modified: Isabelle Tamanini
-- Updates the payment term for the whole contract if it is
-- changed for one account
-- SR 1-25299925
-- =================================================
-- Modified: 2/6/2013 - Rick Deigsler
-- 1-56646248
-- insert payment term record if one does not exist
-- =================================================
-- Modified 10/23/2013 - Rick Deigsler
-- Ticket # 1-233737521 (TFS 21092)
-- Added payment terms data selection
-- =================================================

ALTER procedure [dbo].[usp_account_upd]
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
 @p_enrollmenttype_int								int = 1,
 @p_business_activity                               varchar(35),
 @p_db_group_id										int = null,
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
 @p_annual_usage                                    int,
 @p_date_flow_start                                 datetime,
 @p_date_por_enrollment                             datetime,
 @p_date_deenrollment                               datetime,
 @p_date_reenrollment                               datetime,
 @p_tax_status                                      varchar(20),
 @p_tax_rate                                        float,
 @p_credit_score                                    real,
 @p_credit_agency                                   varchar(30),
 @p_por_option                                      varchar(03) = '',
 @p_billing_type                                    varchar(15) = '',
 @p_requested_flow_start_date                       datetime = '19000101',
 @p_deal_type                                       char(20) = '',
 @p_enrollment_type                                 int = 0,
 @p_customer_code                                   char(05) = '',
 @p_customer_group                                  char(100) = '',
 @p_old_chgstamp                                    smallint,
 @p_error                                           char(01),
 @p_msg_id                                          char(08),
 @p_descp                                           varchar(250),
 @p_result_ind                                      char(01) = 'Y',
 @p_paymentTerm										int = 0,
 @p_ssnEncrypted									nvarchar(512) = null, --added for IT002
 @p_credit_score_encrypted							nvarchar(512) = null,  --added for IT002
 @p_heat_index_source_ID							int = 0,  -- Project IT037
 @p_heat_rate										float = 0, -- Project IT037
 --ticket 15504
 @p_tax_type_id1									int = 0,
 @p_percent_taxable1								varchar(10) = '',
 @p_tax_type_id2									int = 0,
 @p_percent_taxable2								varchar(10) = '',
 @p_tax_type_id3									int = 0,
 @p_percent_taxable3								varchar(10) = '',
 @p_tax_type_id4									int = 0,
 @p_percent_taxable4								varchar(10) = '',
 @p_tax_type_id5									int = 0,
 @p_percent_taxable5								varchar(10) = '',
 @p_tax_type_id6									int = 0,
 @p_percent_taxable6								varchar(10) = '',
 @p_tax_type_id7									int = 0,
 @p_percent_taxable7								varchar(10) = ''
 )
as
 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(200)
	  ,@w_rate_cap									float -- ADDED ticket 24169


 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ''
select @w_return                   					= 0
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
declare @p_rate_plus_tax                            float
declare @w_business_type                            varchar(35)
declare @w_business_activity                        varchar(35)
declare @w_additional_id_nbr_type                   varchar(10)
declare @w_additional_id_nbr                        varchar(30)
declare @w_contract_eff_start_date                  datetime
declare @w_sales_rep                                varchar(100)
declare @w_date_end                                 datetime
declare @w_date_deal                                datetime
declare @w_date_submit                              datetime
declare @w_sales_channel_role                       nvarchar(50)
declare @w_grace_period                             int
declare @w_invalid_rate								int

declare @w_evergreen_option_id						int
declare @w_residual_option_id						int
declare @w_initial_pymt_option_id					int
declare @w_sales_manager							varchar(100)

--begin ticket 1-920833
select	@w_initial_pymt_option_id = initial_pymt_option_id,
		@w_residual_option_id = residual_option_id, 
		@w_evergreen_option_id = evergreen_option_id,
		@w_sales_manager = u.FirstName + ' ' + u.LastName	
from lp_commissions..vendor v
left join LibertyPower..SalesChannel sc on v.ChannelId = sc.ChannelID
left join LibertyPower..[User] u on sc.ChannelDevelopmentManagerID = u.UserId
where vendor_system_name = @p_sales_channel_role
--end ticket 1-920833

-- Check the rate being updated is not lower than the transfer rate in the history table
set @w_invalid_rate = 0

print 'evaluating history rate'

Select @w_rate					=	rate
  from lp_common..product_rate_history (nolock)
 where product_id				=	@p_product_id
   and rate_id					=	@p_rate_id
   and eff_date					=	dateadd(d, 0, datediff(d, 0, @p_date_deal))					-- Update Jose Muñoz
   and contract_eff_start_date	=	dateadd(d, 0, datediff(d, 0, @p_contract_eff_start_date))	-- Update Jose Muñoz
   --and eff_date					=	convert(varchar(8), @p_date_deal,112)
   --and contract_eff_start_date	=	convert(varchar(8), @p_contract_eff_start_date, 112)
 
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
 Begin
	print 'Unable to update the rate value.  The contract rate ' + convert(nvarchar(15),@p_rate) + ' is lower than the transfer rate ' + convert(nvarchar(15),@w_rate)
  
	set @w_error										= 'E'
	set @w_msg_id										= '00001078'
	set @w_descp_add									= 'Unable to update the rate value.  The contract rate ' + convert(nvarchar(15),@p_rate) + ' is lower than the transfer rate ' + convert(nvarchar(15),@w_rate)
	goto goto_select 

 End
 
 -- End check rate validity against history data
/* Ticket 24169 Begin */
Select Top 1
 @w_rate_cap    = rate_cap
from lp_deal_capture..deal_rate (nolock)
order by 1 desc

If @p_rate > (@w_rate_cap + @w_rate) -- Changed with ticket 24345
Begin
	set @w_error			= 'E'
	set @w_msg_id			= '00001078'
	set @w_descp_add		= 'Unable to update the rate value.  The contract rate ' + convert(nvarchar(15),@p_rate) + ' is higher than the max rate cap allowed' + convert(nvarchar(15),(@w_rate_cap + @w_rate))
	goto goto_select 
End
/* Ticket 24169 End */ 


if  @w_contract_type									= 'VOICE'
begin
   select	@p_contract_eff_start_date					= contract_eff_start_date,
			@p_term_months								= term_months
   from		lp_common..common_product_rate WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_product_rate_idx)
   where	product_id									= @p_product_id
   and		rate_id										= @p_rate_id
   and		convert(char(08), getdate(), 112)			>= eff_date
   and		convert(char(08), getdate(), 112)			< due_date
   and		inactive_ind								= '0'
end

exec @w_return = usp_account_val @p_username,
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
                                @p_contract_eff_start_date,
                                @p_term_months,
                                @p_date_end,
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
                                @p_por_option,
                                @p_billing_type,
                                @p_requested_flow_start_date,
                                @p_deal_type,
                                @p_enrollment_type,
                                @p_customer_code,
                                @p_customer_group,
                                @w_application output,
                                @w_error output,
                                @w_msg_id output,
                                @w_descp_add output

if @w_return                                       <> 0
begin
   goto goto_select
end

if  @w_contract_type                                = 'VOICE'
begin
   select @w_grace_period                           = grace_period
   from lp_common..common_product_rate WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = common_product_rate_idx)
   where product_id                                 = @p_product_id
   and   rate_id                                    = @p_rate_id
   and   inactive_ind                               = '0'
   and   eff_date                                  <= convert(char(08), getdate(), 112)
   and   due_date                                  >= convert(char(08), getdate(), 112)
end

-- If the enrollment type is non-standard, then we set the "date to send" according to certain busines rules.
declare @w_lead_time                                int
select @w_lead_time                                 = 0

declare @w_date_por_enrollment                      datetime
select @w_date_por_enrollment                       = @p_date_por_enrollment

if @p_enrollment_type                              <> 1
begin
   if @p_enrollment_type                            = 5
   begin
      set @w_lead_time                              = -15
   end
   else 
   begin
      if @p_enrollment_type                        in (3,4)
      begin	   
         set @w_lead_time                           = -4
      end
   end
end

update account set chgstamp                         = @w_new_chgstamp,
                   account_number                   = @p_account_number,
                   contract_nbr                     = @p_contract_nbr,
                   account_type                     = @p_account_type,
                   /* ticket 13390 begin 
                   contract_type                    = @p_contract_type,
                   */
                   contract_type                    = case when ltrim(rtrim(@p_contract_type)) = '' 
															then contract_type 
															else ltrim(rtrim(@p_contract_type)) End,
					/* ticket 13390 End */ 											
                   retail_mkt_id                    = @p_retail_mkt_id,
                   customer_id                      = @p_customer_id,
                   utility_id                       = @p_utility_id,
				   entity_id                        = @p_entity_id,
                   product_id                       = @p_product_id,
                   rate_id                          = @p_rate_id,
                   rate                             = @p_rate,
                   business_type                    = @p_business_type,
                   business_activity                = @p_business_activity,
                   additional_id_nbr_type           = @p_additional_id_nbr_type,
                   additional_id_nbr                = @p_additional_id_nbr,
                   contract_eff_start_date          = @p_contract_eff_start_date,
                   term_months                      = @p_term_months,
                   date_end                         = @p_date_end,
                   date_deal                        = @p_date_deal,
                   date_submit                      = @p_date_submit,
                   sales_channel_role               = @p_sales_channel_role,
                   sales_rep                        = @p_sales_rep,
                   annual_usage                     = @p_annual_usage,
                   date_flow_start                  = @p_date_flow_start,
                   date_por_enrollment              = case when @w_lead_time = 0
                                                           then @w_date_por_enrollment
                                                           else dateadd(dd, @w_lead_time, @p_contract_eff_start_date)
                                                      end,
                   date_deenrollment                = @p_date_deenrollment,
                   date_reenrollment                = @p_date_reenrollment,
                   tax_status                       = @p_tax_status,
                   tax_rate                         = @p_tax_rate,
                   credit_score                     = @p_credit_score,
                   credit_agency                    = @p_credit_agency,
                   por_option                       = case when @p_por_option <> ''
                                                           then @p_por_option
                                                           else por_option
                                                      end,
                   billing_type                     = case when @p_billing_type <> ''
                                                           then @p_billing_type
                                                           else billing_type
                                                      end,
                   requested_flow_start_date        = @p_requested_flow_start_date,
                   deal_type                        = @p_deal_type,
                   enrollment_type                  = @p_enrollment_type,
                   customer_code                    = @p_customer_code,
                   customer_group                   = @p_customer_group,
                   ModifiedBy						= @p_username,
				    SSNEncrypted						= case when @p_ssnEncrypted is not null
                                                           then @p_ssnEncrypted
                                                           else SSNEncrypted
                                                      end, --added for IT002
                   CreditScoreEncrypted				= case when @p_credit_score_encrypted is not null
                                                           then @p_credit_score_encrypted
                                                           else CreditScoreEncrypted
                                                      end --added for IT002
					,HeatIndexSourceID				= @p_heat_index_source_ID -- Project IT037
					,HeatRate						= @p_heat_rate -- Project IT037
					
					--begin ticket 1-920833
					,initial_pymt_option_id			= @w_initial_pymt_option_id 
					,residual_option_id				= @w_residual_option_id
					,evergreen_option_id			= @w_evergreen_option_id
					,sales_manager					= ISNULL(@w_sales_manager,sales_manager)	
					--end ticket 1-920833
					
from account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_idx)
where account_id                                    = @p_account_id 
--and   chgstamp                                      = @p_old_chgstamp

if @@rowcount                                       = 0 
begin 
   if exists(select * from account WITH (NOLOCK) --REMOVE INDEX USE. TICKET 18281 with (NOLOCK INDEX = account_idx) 
   where account_id = @p_account_id)
   begin
      select @w_error                               = 'E', 
             @w_msg_id                              = '00000003', 
             @w_return                              = 1
   end
   else
   begin
      select @w_error                               = 'E', 
             @w_msg_id                              = '00000004', 
             @w_return                              = 1
   end
   goto goto_select 
end 

-- Ticket # 1-233737521 (TFS 21092)  ---------------------------------
IF @p_paymentTerm = 0 AND LEN(@p_billing_type) > 0
	BEGIN
		DECLARE	@BillingTypeID	int,
				@UtilityID		int
				
		SELECT	@BillingTypeID = BillingTypeID FROM LibertyPower..BillingType WITH (NOLOCK) WHERE LOWER([Type]) = LOWER(LTRIM(RTRIM(@p_billing_type)))
		SELECT	@UtilityID = ID FROM LibertyPower..Utility WITH (NOLOCK) WHERE UtilityCode = @p_utility_id
		
		IF @BillingTypeID > 0 AND @UtilityID > 0
			BEGIN
				SELECT	@p_paymentTerm = ISNULL(ARTerms, @p_paymentTerm)
				FROM	Libertypower..UtilityPaymentTerms WITH (NOLOCK)
				WHERE	UtilityId = @UtilityID
				AND		((@BillingTypeID = BillingTypeID) OR (BillingTypeID IS NULL))
			END	
	END
----------------------------------------------------------------------

-- 1-56646248
-- insert payment term record if one does not exist
INSERT INTO AccountPaymentTerm
select a.AccountIdLegacy, @p_paymentTerm, GETDATE()
from libertypower..account    a (nolock)
join libertypower..[contract] c (nolock) on a.currentcontractid = c.contractid
where c.number = @p_contract_nbr
and a.AccountIdLegacy not in
(
	select apt.accountId
	from lp_account..AccountPaymentTerm apt (nolock)
	join libertypower..account    a (nolock) on a.AccountIdLegacy = apt.accountid
	join libertypower..[contract] c (nolock) on a.currentcontractid = c.contractid
	where c.number = @p_contract_nbr
)

--ticket 8139 - update payment term
--SR1-25299925 --update payment term for the whole contract
update AccountPaymentTerm 
set paymentTerm = @p_paymentTerm
from lp_account..AccountPaymentTerm apt
join libertypower..account    a (nolock) on a.AccountIdLegacy = apt.accountid
join libertypower..[contract] c (nolock) on a.currentcontractid = c.contractid
where c.number = @p_contract_nbr

-- Update any account's usage that has been added to a renewal
update account_renewal set annual_usage = @p_annual_usage
where account_id                                    = @p_account_id

-- We remove the DB relationships that the account has and insert the one that was just saved.
delete from account_deutsche_link 
where account_id                                    = @p_account_id
insert into account_deutsche_link (account_id, deutsche_bank_group_id) 
values (@p_account_id, @p_db_group_id)

-- ticket 15504
-- Insert or update 'account tax detail'
--if @p_tax_type_id <> 0 
--	begin
-- ticket 20278	
-- ticket 20582  
if @p_percent_taxable1 <> ''
begin
	exec LibertyPower..usp_AccountTaxDetailInsertUpdate @p_tax_type_id1, @p_percent_taxable1, @p_account_id
end
if @p_percent_taxable2 <> ''
begin
	exec LibertyPower..usp_AccountTaxDetailInsertUpdate @p_tax_type_id2, @p_percent_taxable2, @p_account_id
end
if @p_percent_taxable3 <> ''
begin	
	exec LibertyPower..usp_AccountTaxDetailInsertUpdate @p_tax_type_id3, @p_percent_taxable3, @p_account_id
end
if @p_percent_taxable4 <> ''
begin	
	exec LibertyPower..usp_AccountTaxDetailInsertUpdate @p_tax_type_id4, @p_percent_taxable4, @p_account_id
end
if @p_percent_taxable5 <> ''
begin	
	exec LibertyPower..usp_AccountTaxDetailInsertUpdate @p_tax_type_id5, @p_percent_taxable5, @p_account_id
end
if @p_percent_taxable6 <> ''
begin	
	exec LibertyPower..usp_AccountTaxDetailInsertUpdate @p_tax_type_id6, @p_percent_taxable6, @p_account_id
end
if @p_percent_taxable7 <> ''
begin	
	exec LibertyPower..usp_AccountTaxDetailInsertUpdate @p_tax_type_id7, @p_percent_taxable7, @p_account_id
end
--end
	
-- Ticket 20866 	
-- Added this line since we shouldnt have multiple of these records if they are the same
IF NOT EXISTS (SELECT * FROM LibertyPower..AccountService WHERE account_id = @p_account_id AND StartDate = @p_date_flow_start AND EndDate = @p_date_deenrollment)
	INSERT INTO LibertyPower..AccountService (account_id, StartDate, EndDate) VALUES (@p_account_id,@p_date_flow_start,@p_date_deenrollment)	
	
select @w_return = 0

goto_select:

if @w_error <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id, 
                                    @w_descp output, 
                                    @w_application

   select @w_descp                                  = ltrim(rtrim(@w_descp)) 
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


select @p_error                                      = @w_error, 
       @p_msg_id                                     = @w_msg_id, 
       @p_descp                                      = @w_descp
 
goto_return:
return @w_return

