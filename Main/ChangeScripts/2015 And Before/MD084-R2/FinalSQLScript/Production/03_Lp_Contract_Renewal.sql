USE [lp_contract_renewal]
Go
BEGIN TRAN 
IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'deal_contract_account'             
	AND		COLUMN_NAME = 'RatesString'
) 
ALTER TABLE deal_contract_account
ADD RatesString varchar(200) Null;
GO

IF NOT EXISTS
( 
	SELECT	* 
	FROM	INFORMATION_SCHEMA.COLUMNS              
	WHERE	TABLE_NAME = 'deal_contract'             
	AND		COLUMN_NAME = 'RatesString'
)
ALTER TABLE deal_contract
ADD RatesString varchar(200) Null;
GO


/*CREATE PROCEDURE lp_contract_renewal.dbo.usp_deal_contract_sel*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lev Rosenblum
-- Create date: 1/28/2013
-- Description:	select records corresponding @ContractNmbr
-- =============================================
CREATE PROCEDURE dbo.usp_deal_contract_sel
(
	@ContractNmbr char(12)
)
AS
BEGIN

SET NOCOUNT ON;

SELECT [contract_nbr]
      ,[contract_type]
      ,[status]
      ,[retail_mkt_id]
      ,[utility_id]
      ,[account_type]
      ,[product_id]
      ,[rate_id]
      ,[rate]
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
      ,[anual_usage]
      ,[grace_period]
      ,[chgstamp]
      ,[renew]
      ,[original_contract_nbr]
      ,[SSNClear]
      ,[SSNEncrypted]
      ,[CreditScoreEncrypted]
      ,[HeatIndexSourceID]
      ,[HeatRate]
      ,[evergreen_option_id]
      ,[evergreen_commission_end]
      ,[residual_option_id]
      ,[residual_commission_end]
      ,[initial_pymt_option_id]
      ,[sales_manager]
      ,[evergreen_commission_rate]
      ,[PriceID]
      ,[PriceTier]
      , RatesString
  FROM [lp_contract_renewal].[dbo].[deal_contract] with (nolock)
  WHERE Contract_nbr=@ContractNmbr
END
GO

/****** Object:  StoredProcedure [dbo].[usp_contract_account_sel]    Script Date: 01/28/2013 17:24:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------
/*
alter by Lev Rosenblum
Date: 1/29/2013
description: Rate and RatesString has been added to output
*/
---------------------------------------------------------

ALTER PROCEDURE [dbo].[usp_contract_account_sel]
(
	@p_account_number                  varchar(30),
	@p_contract_nbr                    char(12)
 )
as

Select
		contract_nbr
		, contract_type
		, account_number
		, sales_channel_role
		, evergreen_option_id 
		, evergreen_commission_end 
		, residual_option_id 
		, residual_commission_end 
		, initial_pymt_option_id  
		, evergreen_commission_rate
		, rate
		, RatesString 
   
From deal_contract_account with (NOLOCK)
Where contract_nbr = @p_contract_nbr
And account_number = @p_account_number
GO


/****** Object:  StoredProcedure [lp_contract_renewal].[dbo].[usp_contract_general_ins]    Script Date: 01/21/2013 16:42:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Modified GM 10/29/2007
-- Update Sales Channel Role on the deal_contract table as well 
-- =============================================
-- Modified: Gail Mangaroo 3/28/2008
-- get COMMCAP rate from Custom Pricing if the rate is a custom rate 
-- altered update of rate_submit_ind 
-- =============================================
-- Modified: Jose Munoz 3/12/2010
-- add HeatIndexSourceID and HeatRate for updates in the tables 
-- deal_contract, deal_contract_account and deal_pricing_detail
-- Project IT037
-- =============================================
-- Modified: George Worthington 4/30/2010
-- added Sales Channel Settings overrided fields
-- Project IT021
-- =============================================
-- Modified: Isabelle Tamanini 6/28/2010
-- @w_contract_eff_start_date removed, the account update will
-- use the parameter given to the usp (@p_contract_eff_start_date)
-- SD16410
-- =============================================
-- Modified: Diogo Lima 8/13/2010
-- @w_account_id validation added
-- SD17630 
-- =============================================
-- Modified: Isabelle Tamanini 11/17/2010
-- Removed code that updates rate_submit_ind for custom rates:
-- this is now handled by lp_contract_renewal..usp_contract_submit_ins
-- SD19106  
-- =============================================
-- Modified: Isabelle Tamanini 11/17/2010
-- Saving the value of parameter @p_ContractDate
-- in deal_contract_account table
-- SD19615 
-- =============================================
-- Modified: Isabelle Tamanini 7/7/2011
-- Saving the value of parameter @p_sales_mgr
-- in deal_contract_account table
-- SD24135 
-- =============================================
-- Modified: Isabelle Tamanini 8/5/2011
-- Validates the eff start date to be saved per account
-- SR1-1025061
-- =============================================
-- Modified: Jose Munoz 8/16/2011
-- Validates the eff start date to be saved per account
-- New rules.
-- ticket # 1-1430369
-- =============================================
-- Modified by: Isabelle Tamanini 10/10/2011
-- Logic to get pricing was changed based on the
-- contract date
-- SR1-4243484
-- =============================================
-- Modified: Isabelle Tamanini 12/16/2011
-- SR1-4955209
-- Date end will be terms + eff start date - 1 day
-- =============================================
-- Modified: Lev Rosenblum 1/22/2013
-- PBI3561(task 4619)
-- add @RatesString input parameter
-- =============================================

ALTER procedure [dbo].[usp_contract_general_ins]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_retail_mkt_id                                   char(02) = '',
 @p_utility_id                                      char(15) = '',
 @p_account_type									int = 0,
 @p_product_id                                      char(20) = '',
 @p_rate_id                                         int = 0,
 @p_rate                                            float = 0,
 @p_business_type                                   varchar(35) = '',
 @p_business_activity                               varchar(35) = '',
 @p_additional_id_nbr_type                          varchar(10) = '',
 @p_additional_id_nbr                               varchar(30) = '',
 @p_contract_eff_start_date                         datetime = '19000101',
 @p_term_months                                     int = 0,
 @p_sales_channel_role                              nvarchar(50) = '',
 @p_sales_rep                                       varchar(100) = '',
 @p_account_number                                  varchar(30) = '',
 @p_date_submit                                     datetime = '19000101',
 @p_meter_number									varchar(2000)	= 'NONE',
 @p_error                                           char(01) = '',
 @p_msg_id                                          char(08) = '',
 @p_descp                                           varchar(250) = '',
 @p_result_ind                                      char(01) = 'Y',
 @p_comm_cap										float	 = 0,
 @p_SSNClear										nvarchar	(100) = ''		-- IT002
,@p_SSNEncrypted									nvarchar	(512) = ''		-- IT002
,@p_CreditScoreEncrypted							nvarchar	(512) = ''		-- IT002
,@p_HeatIndexSourceID								int	= null			-- Project IT037
,@p_HeatRate										decimal	(9,2) = null -- Project IT037 
,@p_sales_mgr									    varchar(100) = null		-- IT021
,@p_evergreen_option_id								int = null				-- IT021
,@p_evergreen_commission_end						datetime = null			-- IT021
,@p_evergreen_commission_rate						float = null			-- IT021
,@p_residual_option_id								int = null				-- IT021
,@p_residual_commission_end							datetime = null			-- IT021
,@p_initial_pymt_option_id							int = null				-- IT021
,@p_ContractDate									datetime = null			-- Ticket 17543
,@PriceID											int				= 0 -- IT106
,@PriceTier											int				= 0 -- IT106
,@RatesString										varchar(200)	= null
)
as
declare @w_error                                    char(01)
		,@w_msg_id                                  char(08)
		,@w_descp                                   varchar(250)
		,@w_return                                  int
		,@w_descp_add                               varchar(20)
		,@w_due_date								datetime
		,@w_fixed_end_date							tinyint
		,@w_application                             varchar(20)

		,@w_contract_type                           varchar(20)
		,@w_retail_mkt_id                           char(02)
		,@w_utility_id                              char(15)
		,@w_product_id                              char(20)
		,@w_rate_id                                 int
		,@w_rate                                    float
		,@w_business_type                           varchar(35)
		,@w_business_activity                       varchar(35)
		,@w_additional_id_nbr_type                  varchar(10)
		,@w_additional_id_nbr                       varchar(30)
--declare @w_contract_eff_start_date                datetime SD16410
		,@w_term_months                             int
		,@w_sales_rep                               varchar(100)
		,@w_date_end                                datetime
		,@w_date_deal                               datetime
		,@w_date_submit                             datetime
		,@w_sales_channel_role                      nvarchar(50)
		,@w_grace_period                            int
		,@w_account_id                              char(12)
		,@w_product_rate							float
		,@w_custom_cap								float 
		,@w_org_product_id							varchar(20)  
		,@w_org_rate_id								int 
		,@w_sales_mgr								varchar(100)
		,@w_initial_pymt_option_id					int
		,@w_residual_option_id						int
		,@w_evergreen_option_id						int
		,@w_residual_commission_end					datetime
		,@w_evergreen_commission_end				datetime
		,@w_evergreen_commission_rate				float


		
select @w_error                                     = 'I'
		,@w_msg_id                                  = '00000001'
		,@w_descp                                   = ''
		,@w_return                                  = 0
		,@w_descp_add                               = ''
		,@w_application                             = 'COMMON'

select @p_contract_nbr                              = upper(@p_contract_nbr)
		,@p_retail_mkt_id                           = upper(@p_retail_mkt_id)
		,@p_utility_id                              = upper(@p_utility_id)
		,@p_product_id                              = upper(@p_product_id)
		,@p_business_type                           = upper(@p_business_type)
		,@p_business_activity                       = upper(@p_business_activity)
		,@p_additional_id_nbr_type                  = upper(@p_additional_id_nbr_type)
		,@p_additional_id_nbr                       = upper(@p_additional_id_nbr)
		,@p_sales_rep                               = upper(@p_sales_rep)

select @w_account_id                                = ''

-- get current rate
--SELECT @w_product_rate = rate--, @w_contract_eff_start_date = ISNULL(contract_eff_start_date, GETDATE()) 
--FROM lp_common..common_product_rate
--WHERE product_id = @p_product_id AND rate_id = @p_rate_id

SELECT top 1 @w_product_rate = rate--, @w_contract_eff_start_date = ISNULL(contract_eff_start_date, GETDATE()) 
FROM lp_common..product_rate_history with (nolock)
WHERE product_id = @p_product_id AND rate_id = @p_rate_id
AND eff_date = @p_ContractDate
AND contract_eff_start_date <= @p_contract_eff_start_date
ORDER BY contract_eff_start_date DESC

---- rate entered is lower than current transfer rate, update rate
--IF @p_rate < @w_product_rate
--	BEGIN
--		SET @p_rate = @w_product_rate
--	END
--
---- rate entered exceeds transfer rate plus commission cap
--IF @p_rate > (@w_product_rate + @p_comm_cap)
--	BEGIN
--		SET @p_rate = @w_product_rate
--
----		select @w_error			= 'E'
----		select @w_msg_id		= '00000044'
----		select @w_return		= 1
----		select @w_descp_add		= ''
----		select @w_application	= 'DEAL'
----		goto goto_select
--	END

-- rate entered is lower than current transfer rate and product is flexible
IF (@p_rate < @w_product_rate) and (( SELECT is_flexible FROM lp_common..common_product with (nolock) WHERE product_id = @p_product_id ) = 1)
	BEGIN
		select @w_error			= 'E'
		select @w_msg_id		= '00000045'
		select @w_return		= 1
		select @w_descp_add		= ''
		select @w_application	= 'COMMON'
		goto goto_select
	END

-- get custom cap 
SELECT @w_custom_cap = isnull(d.commission_rate, 0) 
	FROM lp_deal_capture..deal_pricing d with (nolock) 
		JOIN lp_deal_capture..deal_pricing_detail dd with (nolock) ON d.deal_pricing_id = dd.deal_pricing_id 
	WHERE dd.product_id = @p_product_id and dd.rate_id = @p_rate_id

IF isnull(@w_custom_cap, 0) = 0 
	-- no custom cap exsits, use passed in comm_cap
	BEGIN 
		SET @w_custom_cap = @p_comm_cap
	END 

-- rate entered exceeds transfer rate plus commission cap
print @p_rate
print @w_product_rate
print @w_custom_cap
--IF (@p_rate > (@w_product_rate + @w_custom_cap)) and (( SELECT is_flexible FROM lp_common..common_product WHERE product_id = @p_product_id ) = 1)
--	BEGIN
--		select @w_error			= 'E'
--		select @w_msg_id		= '00000044'
--		select @w_return		= 1
--		select @w_descp_add		= ''
--		select @w_application	= 'DEAL'
--		goto goto_select
--	END


-- get original product and rate 
if @p_account_number                                = 'CONTRACT'
	begin 
		SELECT @w_org_product_id = product_id , @w_org_rate_id = rate_id 
		FROM deal_contract with (nolock)
		WHERE contract_nbr   = @p_contract_nbr 
	end 
else
	begin 
		SELECT @w_org_product_id = product_id , @w_org_rate_id = rate_id 
		FROM deal_contract_account with (NOLOCK)
		WHERE contract_nbr   = @p_contract_nbr 
		AND   account_number = @p_account_number
	end 

select @w_contract_type                             = contract_type,
       @w_retail_mkt_id                             = @p_retail_mkt_id,
       @w_utility_id                                = @p_utility_id,
       @w_product_id                                = @p_product_id,
       @w_rate_id                                   = @p_rate_id,
       @w_rate                                      = @p_rate,
       @w_business_type                             = @p_business_type,
       @w_business_activity                         = @p_business_activity,
       @w_additional_id_nbr_type                    = @p_additional_id_nbr_type,
       @w_additional_id_nbr                         = @p_additional_id_nbr,
       @w_term_months                               = @p_term_months,
       @w_date_end                                  = date_end,
       @w_date_deal                                 = @p_ContractDate,
       @w_sales_rep                                 = @p_sales_rep,
       @w_date_submit                               = date_submit,
       @w_sales_channel_role                        = @p_sales_channel_role,
       @w_grace_period                              = grace_period,
       @w_sales_mgr									= @p_sales_mgr,
       @w_initial_pymt_option_id					=	 @p_initial_pymt_option_id,
       @w_residual_option_id						=	 @p_residual_option_id,
       @w_evergreen_option_id						=	 @p_evergreen_option_id,
       @w_residual_commission_end					=	 @p_residual_commission_end,
       @w_evergreen_commission_end					=	 @p_evergreen_commission_end,
       @w_evergreen_commission_rate					=	 @p_evergreen_commission_rate
from deal_contract with (NOLOCK)
where contract_nbr                                  = @p_contract_nbr 

	
--SR1-4243484
IF @p_ContractDate is null
BEGIN
	select	@w_term_months							= term_months,
			@w_due_date								= due_date,
			@w_fixed_end_date						= fixed_end_date
	from	lp_common..common_product_rate with (NOLOCK)
	where	product_id								= @p_product_id
	and		rate_id									= @p_rate_id
	and		inactive_ind							= '0'
END
ELSE
BEGIN	
	select	@w_term_months = prh.term_months,
			@w_due_date = pr.due_date,
			@w_fixed_end_date = pr.fixed_end_date
	from	lp_common..product_rate_history prh with (NOLOCK)
	join    lp_common..common_product_rate pr with (NOLOCK) on prh.rate_id = pr.rate_id
														   and prh.product_id = pr.product_id
	where	pr.product_id   = @p_product_id
	and		pr.rate_id	 	= @p_rate_id
	and		pr.inactive_ind	= '0'
	and		prh.eff_date	= @p_ContractDate
END

if len(@p_contract_eff_start_date) = 0
	select @p_contract_eff_start_date			= getdate()
	
--SR1-4955209
SET @w_date_end = dateadd(mm, @w_term_months, dateadd(dd, -1, @p_contract_eff_start_date))

exec @w_return = usp_contract_general_val @p_username,
                                          'I',  
                                          'ALL',
                                          @p_contract_nbr,
                                          @p_account_number, 
                                          @p_retail_mkt_id,  
                                          @p_utility_id,     
                                          @p_product_id,     
                                          @p_rate_id,
                                          @p_rate,
                                          @p_business_type,
                                          @p_business_activity,
                                          @p_additional_id_nbr_type,
                                          @p_additional_id_nbr,
                                          @w_term_months,
                                          @p_date_submit,
                                          @p_sales_channel_role,
                                          @p_sales_rep,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output

if @w_return                                       <> 0
begin
   goto goto_select
end

if  @w_grace_period                                 = 0
begin
   select @w_grace_period                           = grace_period
   from lp_common..common_product_rate with (NOLOCK INDEX = common_product_rate_idx)
   where product_id                                 = @p_product_id
   and   rate_id                                    = @p_rate_id
   and   inactive_ind                               = '0'
   and   eff_date                                  <= convert(char(08), getdate(), 112)
   and   due_date                                  >= convert(char(08), getdate(), 112)
end

if @p_account_number                                = 'CONTRACT'
begin

	SET @p_contract_eff_start_date = CAST(CAST(YEAR(@p_contract_eff_start_date) AS VARCHAR) + '-' + CAST(MONTH(@p_contract_eff_start_date) AS VARCHAR) + '-01' AS DATETIME)
	
	--SR1-4955209
	SET @w_date_end = dateadd(mm, @w_term_months, dateadd(dd, -1, @p_contract_eff_start_date))
	
   update deal_contract set retail_mkt_id = @p_retail_mkt_id,
							account_type = @p_account_type,
                            utility_id = @p_utility_id,
                            product_id = @p_product_id,
                            rate_id = @p_rate_id,
                            rate = @p_rate,
                            business_type = @p_business_type,
                            business_activity = @p_business_activity,
                            additional_id_nbr_type = @p_additional_id_nbr_type,
                            additional_id_nbr = @p_additional_id_nbr,
                            contract_eff_start_date = @p_contract_eff_start_date,
                            term_months = @w_term_months,
                            date_end = case when @w_fixed_end_date = 1 then @w_due_date else @w_date_end end,
                            date_submit = @w_date_submit,
                            sales_rep = @p_sales_rep,
                            sales_channel_role = @w_sales_channel_role,
                            grace_period = @w_grace_period
                            ,SSNClear				= @p_SSNClear					-- IT002
							,SSNEncrypted			= @p_SSNEncrypted				-- IT002
							,CreditScoreEncrypted	= @p_CreditScoreEncrypted		-- IT002
							,HeatIndexSourceID		= @p_HeatIndexSourceID  -- Project IT037
							,HeatRate				= @p_HeatRate			-- Project IT037  
                            ,sales_manager = @p_sales_mgr,								-- IT021
							initial_pymt_option_id = @p_initial_pymt_option_id,			-- IT021
							residual_option_id = @p_residual_option_id,					-- IT021
							evergreen_option_id = @p_evergreen_option_id,				-- IT021
							residual_commission_end = @p_residual_commission_end,		-- IT021
							evergreen_commission_end = @p_evergreen_commission_end,		-- IT021
							evergreen_commission_rate = @p_evergreen_commission_rate,	-- IT021
                            PriceID = @PriceID, -- IT106
							PriceTier = @PriceTier -- IT106
							, RatesString=@RatesString
   from deal_contract with (NOLOCK)
   where contract_nbr                               = @p_contract_nbr 
   
   if @@error                                      <> 0
   or @@rowcount                                    = 0
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = '(Contract)'
      goto goto_select
   END

   ------------------------------------------------------------------
   -- Update accounts as well.
		DECLARE @AccountID CHAR(12)
		DECLARE c_Accounts CURSOR FOR 
		SELECT ca.account_id
		FROM lp_contract_renewal..deal_contract_account ca with (nolock)
		WHERE ca.contract_nbr=@p_contract_nbr
		
		OPEN c_Accounts

		FETCH NEXT FROM c_Accounts 
		INTO @AccountID

		WHILE @@FETCH_STATUS=0
		BEGIN
			
			DECLARE @w_account_date_start			DATETIME
					,@w_account_date_end			DATETIME
					,@w_account_date_end_account	DATETIME -- Add ticket # 1-1430369
					,@w_DateTempChar				VARCHAR(10)
			/* commented ticket # 1-1430369 
			IF (DATEDIFF(month,@w_account_date_start,@p_contract_eff_start_date) >= 1)
			BEGIN
				SET @w_account_date_start = DATEADD(month,DATEDIFF(month,@w_account_date_start,@p_contract_eff_start_date),@w_account_date_start)
			END
			ELSE
			BEGIN
				SET @w_account_date_start = @w_account_date_start
			END
			*/

			/* Ticket # 1-1430369  Begin */
			SELECT @w_account_date_end_account = DATEADD(dd,1,date_end)
			FROM lp_account..account with (nolock)
			WHERE account_id = @AccountID

			if @w_account_date_end_account is null
				set @w_account_date_end_account = '1900/01/01'
				
			if month(@w_account_date_end_account) in (3,8,11) and day(@w_account_date_end_account) = '31'
				set @w_account_date_end_account = '1900/01/01'				
			
			SET @w_DateTempChar	= LTRIM(RTRIM(STR(YEAR(@p_contract_eff_start_date)))) 
					+ Right(STR( 100 + MONTH(@p_contract_eff_start_date)),2)
					+ Right(STR( 100 + DAY(@w_account_date_end_account)),2)
			
			IF ISDATE(@w_DateTempChar) = 1
				SET @w_account_date_start = @w_DateTempChar
			ELSE
				SET @w_account_date_start = LTRIM(RTRIM(STR(YEAR(@p_contract_eff_start_date)))) 
					+ Right(STR( 100 + MONTH(@p_contract_eff_start_date)),2)
					+ '01'
			
			/* Ticket # 1-1430369  End */

			SET @w_account_date_end = DATEADD(month, @w_term_months,DATEADD(dd,-1,@w_account_date_start))
		
			UPDATE deal_contract_account 
			   SET --contract_nbr =  @p_contract_nbr
				  retail_mkt_id = @p_retail_mkt_id
				  ,[utility_id] = @p_utility_id
				  ,[product_id] = @p_product_id
				  ,[rate_id] = @p_rate_id
				  ,[rate] = @p_rate
				  ,[business_type] = @p_business_type
				  ,[business_activity] = @p_business_activity
				  ,[additional_id_nbr_type] = @p_additional_id_nbr_type
				  ,[additional_id_nbr] = @p_additional_id_nbr
				  ,[term_months] = @p_term_months
				  ,[sales_channel_role] = @p_sales_channel_role
				  ,[username] = @p_username
				  ,[sales_rep] = @p_sales_rep
                  --,[contract_eff_start_date] = case when @p_contract_eff_start_date > @w_account_start_date then @p_contract_eff_start_date else @w_account_start_date end 
                  ,[contract_eff_start_date] = @w_account_date_start
                  ,[date_end] = case when @w_fixed_end_date = 1 then @w_due_date else @w_account_date_end end
                  ,SSNClear				= @p_SSNClear					-- IT002
				  ,SSNEncrypted			= @p_SSNEncrypted				-- IT002
				  ,CreditScoreEncrypted	= @p_CreditScoreEncrypted		-- IT002
				  ,[HeatIndexSourceID]			= @p_HeatIndexSourceID  -- Project IT037
				  ,[HeatRate]					= @p_HeatRate			-- Project IT037 
				  ,[date_deal] = @p_ContractDate,
                    PriceID = @PriceID, -- IT106
					PriceTier = @PriceTier -- IT106
					, RatesString=@RatesString				  
			 WHERE [account_id] = @AccountID
			
			FETCH NEXT FROM c_Accounts INTO @AccountID
		END
		CLOSE c_Accounts
		DEALLOCATE c_Accounts
		---------------------------------------------------------------------   
end   
else
begin

   update deal_contract_account set contract_type = @w_contract_type,
                                    retail_mkt_id = case when retail_mkt_id = 'SELECT...'
                                                         then 'NN'
                                                         else @p_retail_mkt_id
                                                    end, 
                                    utility_id = case when utility_id = 'SELECT...'
                                                      then 'NONE'
                                                      else @p_utility_id
                                                 end, 
									account_type = @p_account_type,
                                    product_id = case when product_id = 'SELECT...'
                                                      then 'NONE'
                                                      else @p_product_id
                                                 end,
                                    rate_id = case when product_id = 'SELECT...'
                                                   then 999999999
                                                   else @p_rate_id
                                              end,
                                    rate = @p_rate,
                                    business_type = @p_business_type,
                                    business_activity = @p_business_activity,
                                    additional_id_nbr_type = @p_additional_id_nbr_type,
                                    additional_id_nbr = @p_additional_id_nbr,
                                    contract_eff_start_date = @p_contract_eff_start_date,
                                    term_months = @w_term_months,
                                    date_deal = @p_ContractDate,
                                    date_end = case when @w_fixed_end_date = 1 then @w_due_date else @w_date_end end,
                                    date_submit = @p_date_submit,
                                    grace_period = case when grace_period = 0
                                                        then @w_grace_period
                                                        else grace_period
                                                   end
                                                   ,SSNClear				= @p_SSNClear					-- IT002
									,SSNEncrypted			= @p_SSNEncrypted				-- IT002
									,CreditScoreEncrypted	= @p_CreditScoreEncrypted		-- IT002
									,HeatIndexSourceID			= @p_HeatIndexSourceID  -- Project IT037
									,HeatRate					= @p_HeatRate			-- Project IT037 
									,initial_pymt_option_id = @p_initial_pymt_option_id				-- IT021
									,residual_option_id = @p_residual_option_id						-- IT021
									,evergreen_option_id = @p_evergreen_option_id					-- IT021
									,residual_commission_end = @p_residual_commission_end			-- IT021
									,evergreen_commission_end = @p_evergreen_commission_end			-- IT021
									,evergreen_commission_rate = @p_evergreen_commission_rate		-- IT021
									,PriceID = @PriceID -- IT106
									,PriceTier = @PriceTier -- IT106
									, RatesString=@RatesString										
   from deal_contract_account with (NOLOCK)
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

	update deal_contract_account set	sales_channel_role	= @p_sales_channel_role,
										sales_rep			= @p_sales_rep,
										sales_manager       = @p_sales_mgr
	where contract_nbr										= @p_contract_nbr 

	-- added GM 10/29/2007
	update deal_contract set	sales_channel_role	= @p_sales_channel_role,
										sales_rep			= @p_sales_rep,
										sales_manager       = @p_sales_mgr
	where contract_nbr										= @p_contract_nbr 


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

IF LEN(@p_meter_number) = 0 or @p_meter_number <> 'NONE'
	BEGIN
		SET @w_account_id = (SELECT	distinct account_id
							FROM	deal_contract_account WITH (NOLOCK)
							WHERE	account_number = @p_account_number)

		DELETE FROM account_meters
		WHERE		account_id = @w_account_id
	END

-- meter number required
IF LEN(@p_meter_number) = 0
	BEGIN
		select @w_error			= 'E'
		select @w_msg_id		= '00000046'
		select @w_return		= 1
		select @w_descp_add		= ''
		select @w_application	= 'DEAL'
		goto goto_select
	END

IF @p_meter_number <> 'NONE' and @w_account_id is not null
	BEGIN
		DECLARE @w_id			int
		DECLARE @w_value		varchar(500)
		DECLARE @w_rowcount		int

		SELECT	id, value 
		INTO	#meter_numbers
		FROM	lp_account.dbo.ufn_split_delimited_string (@p_meter_number, ',')

		SELECT TOP 1	@w_id = id, @w_value = value
		FROM			#meter_numbers
		ORDER BY		id
		SET				@w_rowcount = @@ROWCOUNT

		WHILE @w_rowcount <> 0
			BEGIN
				IF LEN(@w_value) > 0
					BEGIN
						INSERT INTO		account_meters
						SELECT			@w_account_id, @w_value
					END
				
				DELETE FROM		#meter_numbers
				WHERE			id = @w_id

				SELECT TOP 1	@w_id = id, @w_value = value
				FROM			#meter_numbers
				ORDER BY		id
				SET				@w_rowcount = @@ROWCOUNT
			END
	END



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

GO

/****** Object:  StoredProcedure [dbo].[usp_contract_general_sel]    Script Date: 01/21/2013 23:10:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[usp_contract_general_sel]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30) = ' ')
as
 
if @p_contract_nbr                                  = 'CONTRACT'
begin

   select retail_mkt_id,
          utility_id,
          product_id,
          rate_id,
          rate,
          business_type,
          business_activity,
          additional_id_nbr_type,
          contract_eff_start_date,
          term_months,
          date_deal,
          date_end,
          sales_rep
          , RatesString
   from deal_contract with (NOLOCK)
   where contract_nbr                               = @p_contract_nbr 


end   
else
begin
   select retail_mkt_id,
          utility_id,
          product_id,
          rate_id,
          rate,
          business_type,
          business_activity,
          additional_id_nbr_type,
          contract_eff_start_date,
          term_months,
          date_deal,
          date_end,
          sales_rep
          , RatesString
   from deal_contract_account with (NOLOCK)
   where contract_nbr                               = @p_contract_nbr 
   and   account_number                             = @p_account_number

end

GO

-- ROLLBACK
COMMIT
