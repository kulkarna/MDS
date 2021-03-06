USE [Lp_Account]
GO
/****** Object:  StoredProcedure [dbo].[usp_account_update]    Script Date: 10/23/2013 15:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =======================================
-- Modified 10/23/2013 - Rick Deigsler
-- Ticket # 1-233737521 (TFS 21092)
-- Added payment terms data selection
-- =======================================

ALTER procedure [dbo].[usp_account_update]
(
 @p_username nchar(100) ,
 @p_account_id char(12) ,
 @p_account_number varchar(30) ,
 @p_account_type varchar(25) ,
 @p_status varchar(15) ,
 @p_sub_status varchar(15) ,
 @p_customer_id char(10) ,
 @p_entity_id char(15) ,
 @p_contract_nbr char(12) ,
 @p_contract_type varchar(25) ,
 @p_retail_mkt_id char(02) ,
 @p_utility_id char(15) ,
 @p_product_id char(20) ,
 @p_rate_id int ,
 @p_rate float ,
 @p_account_name_link int ,
 @p_customer_name_link int ,
 @p_customer_address_link int ,
 @p_customer_contact_link int ,
 @p_billing_address_link int ,
 @p_billing_contact_link int ,
 @p_owner_name_link int ,
 @p_service_address_link int ,
 @p_business_type varchar(35) ,
 @p_business_activity varchar(35) ,
 @p_additional_id_nbr_type varchar(10) ,
 @p_additional_id_nbr varchar(30) ,
 @p_contract_eff_start_date datetime ,
 @p_term_months int ,
 @p_date_end datetime ,
 @p_date_deal datetime ,
 @p_date_created datetime ,
 @p_date_submit datetime ,
 @p_sales_channel_role nvarchar(50) ,
 @p_sales_rep varchar(100) ,
 @p_origin varchar(50) ,
 @p_annual_usage int ,
 @p_date_flow_start datetime = '19000101' ,
 @p_date_por_enrollment datetime = '19000101' ,
 @p_date_deenrollment datetime = '19000101' ,
 @p_date_reenrollment datetime = '19000101' ,
 @p_tax_status varchar(20) = 'FULL' ,
 @p_tax_float int = 0 ,
 @p_credit_score real = 0 ,
 @p_credit_agency varchar(30) = 'NONE' ,
 @p_por_option varchar(03) = '' ,
 @p_billing_type varchar(15) = '' ,
 @p_zone varchar(15) = '' ,
 @p_service_rate_class varchar(15) = '' ,
 @p_stratum_variable varchar(15) = '' ,
 @p_billing_group varchar(15) = '' ,
 @p_icap varchar(15) = '' ,
 @p_tcap varchar(15) = '' ,
 @p_load_profile varchar(15) = '' ,
 @p_loss_code varchar(15) = '' ,
 @p_meter_type varchar(15) = '' ,
 @p_requested_flow_start_date datetime = '19000101' ,
 @p_deal_type char(20) = '' ,
 @p_enrollment_type int = 0 OUTPUT,
 @p_customer_code char(05) = '' ,
 @p_customer_group char(100) = '' ,
 @p_error char(01) = '' OUTPUT ,
 @p_msg_id char(08) = '' OUTPUT ,
 @p_descp varchar(250) = '' OUTPUT,
 @p_result_ind char(01) = 'Y',
 @p_paymentTerm int = 0,
 @p_SSNEncrypted nvarchar(100) = '',
 @p_HeatIndexSourceID	int	= null,			-- Project IT037
 @p_HeatRate			decimal	(9,2) = null -- Project IT037 
 ,@p_sales_manager									varchar(100)  = null -- Project IT021
 ,@p_evergreen_option_id							int = null			-- Project IT021
 ,@p_evergreen_commission_end						datetime = null		-- Project IT021
 ,@p_evergreen_commission_rate						float = null		-- Project IT021
 ,@p_residual_option_id								int = null			-- Project IT021
 ,@p_residual_commission_end						datetime = null		-- Project IT021
 ,@p_initial_pymt_option_id							int = null			-- Project IT021
 ,@p_original_tax_designation						int = null
)
as
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare	@w_utilityIDR								bit
declare @w_metery_type								varchar(15)
declare @w_status									varchar(15)
declare @w_date_deenrollment						datetime

SELECT
    @w_error = 'I'
SELECT
    @w_msg_id = '00000001'
SELECT
    @w_descp = ' '
SELECT
    @w_return = 0



--Insert into DebugMessages(DebugMessage) values ('Test')

IF EXISTS(SELECT account_id FROM lp_account..account WITH (NOLOCK)
			WHERE account_number = @p_account_number 
			AND utility_id = @p_utility_id )
BEGIN
	SELECT @p_account_id = account_id, @w_status = status, @w_date_deenrollment = date_deenrollment FROM lp_account..account WITH (NOLOCK)
			WHERE account_number = @p_account_number 
			AND utility_id = @p_utility_id
	
	IF @w_status = '911000'
	BEGIN
		SELECT @p_date_deenrollment = @w_date_deenrollment
	END	
END

-- The sales channel enters an expected start date.  In order to hit that date, we have to consider the lead time for the utility.

-- If the enrollment type is non-standard, then we set the "date to send" according to certain busines rules.
declare @w_lead_time                                int
SELECT
    @w_lead_time = 0

declare @w_date_por_enrollment                      datetime
SELECT
    @w_date_por_enrollment = @p_date_por_enrollment


-- The sales channel enters an expected start date.  In order to hit that date, we have to consider the lead time for the utility.
-- We take the expected start date, derive the beginning of that month, then subtract the lead time.
declare @start_date datetime

if @p_retail_mkt_id = 'TX' and  @p_requested_flow_start_date <> '19000101' and @p_requested_flow_start_date is not null
begin
	set @start_date = @p_requested_flow_start_date
end
else
begin
	set @start_date = @p_contract_eff_start_date
end

SELECT @w_date_por_enrollment = dateadd(dd, -enrollment_lead_days, dateadd(m,datediff(m,0,@start_date),0))
FROM lp_common.dbo.common_utility (NOLOCK)
WHERE utility_id = @p_utility_id

-- Ticket 17198, if day lands on Saturday or Sunday, set it to the prior Friday.
if datename(dw,@w_date_por_enrollment) = 'saturday'
	set @w_date_por_enrollment = dateadd(dd,-1,@w_date_por_enrollment)
if datename(dw,@w_date_por_enrollment) = 'sunday'
	set @w_date_por_enrollment = dateadd(dd,-2,@w_date_por_enrollment)

-- Get the meter type: if the utiltiy is IDR EDI and the account number exists in the IDR acocunts table, then meter type should be IDR
SELECT	@w_utilityIDR=u.isIDR_EDI_Capable
FROM	LibertyPower..Utility u
WHERE	u.UtilityCode = @p_utility_id

SELECT	@w_metery_type = 'IDR'
FROM	LibertyPower..IDRAccounts a
WHERE	@w_utilityIDR = 1
AND		a.AccountNumber = @p_account_number
AND		a.UtilityID = 'IDR_' + @p_utility_id

IF (@w_metery_type!= '')
	SET @p_meter_type = @w_metery_type
------------------------------------------------------------------------------------------------------------------------------------------
--begin IT0051
DECLARE @w_BillingTypeID int	
DECLARE @w_BillingType varchar(15)
SELECT @w_BillingTypeID = BillingTypeID FROM lp_common..common_product_rate WITH (NOLOCK) WHERE product_id = @p_product_id and rate_id = @p_rate_id
SELECT @w_BillingType = [Type] FROM libertypower..billingtype WITH (NOLOCK) where BillingTypeID = @w_BillingTypeID 
SELECT @p_billing_type = ISNULL(@w_BillingType,@p_billing_type)
--end IT0051

UPDATE
    lp_account..account set                     
		[account_number] =@p_account_number,
		[account_type] =@p_account_type,
		[status] =@p_status,
		[sub_status] =@p_sub_status,
		[customer_id] =@p_customer_id,
		[entity_id] =@p_entity_id,
		[contract_nbr] =@p_contract_nbr,
		[contract_type] = @p_contract_type,
		[retail_mkt_id] =@p_retail_mkt_id,
		[utility_id] =@p_utility_id,
		[product_id] =@p_product_id,
		[rate_id] =@p_rate_id,
		[rate] =@p_rate,
		[account_name_link] =@p_account_name_link,
		[customer_name_link] =@p_customer_name_link,
		[customer_address_link]=@p_customer_address_link,
		[customer_contact_link] =@p_customer_contact_link,
		[billing_address_link] =@p_billing_address_link,
		[billing_contact_link] =@p_billing_contact_link,
		[owner_name_link] =@p_owner_name_link,
		[service_address_link]=@p_service_address_link,
		[business_type] =@p_business_type,
		[business_activity]=@p_business_activity,
		[additional_id_nbr_type] =upper(@p_additional_id_nbr_type),
		[additional_id_nbr]=@p_additional_id_nbr,
		[contract_eff_start_date] =@p_contract_eff_start_date,
		[term_months]=@p_term_months,
		[date_end]=@p_date_end,
		[date_deal]=@p_date_deal,
		[date_created]=@p_date_created,
		[date_submit] =@p_date_submit,
		[sales_channel_role] = ltrim(rtrim(@p_sales_channel_role)),
		[username]=@p_username,
		[sales_rep]=@p_sales_rep,
		[origin] =@p_origin,
		[annual_usage]=@p_annual_usage,
		[date_flow_start]=@p_date_flow_start,
		[date_por_enrollment]=@w_date_por_enrollment,
		[date_deenrollment]=@p_date_deenrollment,
		[date_reenrollment] =@p_date_reenrollment,		
		[tax_status]=@p_tax_status,
		[tax_rate] =@p_tax_float,
		[credit_score] =@p_credit_score,
		[credit_agency]=@p_credit_agency,
		[por_option]=@p_por_option,
		[billing_type] =@p_billing_type,
		[chgstamp] =0,
		[usage_req_status]='Pending',
		[Created]=getdate(),
		[CreatedBy]=@p_username,
		[Modified]='19000101',
		[ModifiedBy]=' ',
		[rate_code] =' ',
		[zone]=@p_zone,
		[service_rate_class] =@p_service_rate_class,
		[stratum_variable]=@p_stratum_variable,
		[billing_group]=@p_billing_group,
		[icap] =@p_icap,
		[tcap]=@p_tcap,
		[load_profile]=@p_load_profile,
		[loss_code] =@p_loss_code,
		[meter_type] =@p_meter_type,
		[requested_flow_start_date]=@p_requested_flow_start_date,
		[deal_type]='NEW CONTRACT',
		[enrollment_type]=@p_enrollment_type,
		[customer_code]=@p_customer_code,
		[customer_group]=@p_customer_group,
		[SSNEncrypted]=@p_SSNEncrypted,
		HeatIndexSourceID=@p_HeatIndexSourceID,
		HeatRate=@p_HeatRate,
		evergreen_option_id=@p_evergreen_option_id,
		evergreen_commission_end=@p_evergreen_commission_end,
		residual_option_id=@p_residual_option_id, 
		residual_commission_end=@p_residual_commission_end, 
		initial_pymt_option_id=@p_initial_pymt_option_id, 
		sales_manager=@p_sales_manager, 
		evergreen_commission_rate=@p_evergreen_commission_rate,
		original_tax_designation=@p_original_tax_designation
    where account_id = @p_account_id
       
IF @@error <> 0 OR @@rowcount = 0
begin
         SELECT
             @w_error = 'E'
         SELECT
             @w_msg_id = '00000002'
         SELECT
             @w_return = 1
end

       
--mark the custom rate as used (rate_submit_ind = 1)
UPDATE lp_deal_capture..deal_pricing_detail 
SET rate_submit_ind = 1, date_modified = getdate(), modified_by = @p_username
WHERE product_id = @p_product_id and rate_id = @p_rate_id

--If its custom, update the effective date so it matches the contract's deal date.  6/22/2011
IF EXISTS (select * from lp_common..common_product WITH (NOLOCK) where product_id = @p_product_id and IsCustom = 1)
BEGIN
	UPDATE lp_common..common_product_rate
	SET eff_date = @p_date_deal
	WHERE product_id = @p_product_id and rate_id = @p_rate_id
	
END

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

INSERT INTO AccountPaymentTerm
VALUES
(@p_account_id,@p_paymentTerm,getdate())
       
 
if @w_error                                        <> 'N'
begin
         EXEC lp_common..usp_messages_sel @w_msg_id , @w_descp OUTPUT
end
 
if @p_result_ind                                    = 'Y'
begin
         SELECT
             flag_error = @w_error ,
          code_error                                = @w_msg_id,
          message_error                             = @w_descp
   goto goto_return
end
 
SELECT
    @p_error = @w_error ,
       @p_msg_id                                    = @w_msg_id,
       @p_descp                                     = @w_descp
 
goto_return:
return @w_return
