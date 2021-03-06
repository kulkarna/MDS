USE [Lp_deal_capture]
GO
/****** Object:  StoredProcedure [dbo].[usp_contract_renewal_account_ins]    Script Date: 09/17/2013 08:51:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Added: Sara 07/24/2013
--Copied from renewal to deal capture and altered few fields
--Modified Sara Lakshmanan Sept 17 2013
--While adding the accounts for renewal, the value for isforSave is set as false.
--The user should check the checkall feature on the page to select all the accounts for renewing
-- =============================================

ALTER PROCEDURE [dbo].[usp_contract_renewal_account_ins]

@p_contract_nbr                 char(12),
@p_account_number               varchar(30),
@p_account_id                   char(12),
@p_account_type			  int,
@p_account_nameID               int

AS

Set NoCount ON

DECLARE @w_contract_eff_start_date	datetime
DECLARE @w_date_end					datetime

DECLARE @w_product_id                   char(20)
DECLARE @w_rate_id                      int
DECLARE @w_rate                         float
DECLARE @w_inactive_ind					tinyint


--IF @p_account_eff_start_date is not null
--	SET @w_contract_eff_start_date = @p_account_eff_start_date
--ELSE
--	Begin
--		SET @w_contract_eff_start_date = DATEADD(dd, 1, @p_date_end)
---- per Douglas 6/5/2007, changed back to above line
----SET @w_contract_eff_start_date = (SELECT contract_eff_start_date FROM lp_common..common_product_rate WHERE product_id = @p_product_id AND rate_id = @p_rate_id)
--	End
	
--SET @w_date_end = DATEADD(mm, @p_term_months, DATEADD(dd, -1, @w_contract_eff_start_date))

--SET @w_product_id	= @p_product_id
--SET @w_rate_id		= @p_rate_id
--SET @w_rate			= @p_rate

---- determine if product is still active
--IF 
--(SELECT	inactive_ind
--FROM	lp_common..common_product
--WHERE	product_id = @p_product_id) = 1
--	BEGIN
--		SET @w_product_id	= ' '
--		SET @w_rate_id		= 0
--		SET @w_rate			= 0
--	END

IF NOT EXISTS(	SELECT	account_number
				FROM	deal_contract_account with (NoLock)
				WHERE	account_number	= @p_account_number
				AND		contract_nbr	= @p_contract_nbr )
	BEGIN
	print 'DEBUG: From usp_contract_renewal_account_ins, just before insert into deal_contract_account.'
    INSERT INTO [lp_deal_capture].[dbo].[deal_contract_account]
           ([contract_nbr]
           ,[contract_type]
           ,[account_number]
           ,[status]
           ,[account_id]
           ,[retail_mkt_id]
           ,[utility_id]
           ,[product_id]
           ,[rate_id]
           ,[rate]
           ,[account_name_link]
           ,[customer_name_link]
           ,[customer_address_link]
           ,[customer_contact_link]
           ,[billing_address_link]
           ,[billing_contact_link]
           ,[owner_name_link]
           ,[service_address_link]
           ,[business_type]
           ,[business_activity]
           ,[additional_id_nbr_type]
           ,[additional_id_nbr]
           ,[contract_eff_start_date]
           ,[term_months]
           ,[date_end]
           ,[date_deal]
           ,[date_created]
           ,[date_submit]
           ,[sales_channel_role]
           ,[username]
           ,[sales_rep]
           ,[origin]
          -- ,[annual_usage]
           ,[grace_period]
           ,[chgstamp]
         --  ,[renew]
			,[SSNClear]					-- IT002
			,[SSNEncrypted]				-- IT002
			,[CreditScoreEncrypted]		-- IT002
			--,[sales_manager]				--  Added Ticket # 1-1025061
			,[evergreen_option_id]			--  Added Ticket # 1-1025061
			,[residual_commission_end]		--  Added Ticket # 1-1025061
			,[evergreen_commission_rate]	--  Added Ticket # 1-1025061
			,[residual_option_id]			--  Added Ticket # 1-1025061
			,[evergreen_commission_end]		--  Added Ticket # 1-1025061
			,[initial_pymt_option_id]		--  Added Ticket # 1-1025061
			,account_type, enrollment_type,IsForSave
       )
     
		SELECT
			@p_contract_nbr, contract_type, @p_account_number, 'DRAFT', @p_account_id, retail_mkt_id,
			utility_id, product_id, rate_id, rate,@p_account_nameId,customer_name_link,
			customer_address_link, customer_contact_link, billing_address_link, billing_contact_link,
			owner_name_link, service_address_link, business_type, business_activity, additional_id_nbr_type,
			additional_id_nbr, contract_eff_start_date, term_months, date_end, GETDATE(), GETDATE(),
			GETDATE(), sales_channel_role, username, '', 'ONLINE',
			-- @p_annual_usage,
			  0, chgstamp,
			--   1			,
			   SSNClear, SSNEncrypted, CreditScoreEncrypted -- IT002	

			/*Ticket # 1-1025061 Begin */
			--,@p_sales_mgr 
			,
			evergreen_option_id ,residual_commission_end
			,evergreen_commission_rate ,residual_option_id
			,evergreen_commission_end ,initial_pymt_option_id, @p_account_type,1,0
			from deal_contract with (NoLock) where contract_nbr=@p_contract_nbr
			/*Ticket # 1-1025061 End */
			
Set NoCount OFF

	END



