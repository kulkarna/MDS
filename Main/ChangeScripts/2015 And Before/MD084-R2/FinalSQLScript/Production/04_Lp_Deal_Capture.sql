USE [lp_deal_capture]
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

/*CREATE Stored Procedure lp_deal_capture.dbo.usp_contract_account_override_rates*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lev Rosenblum
-- Create date: <01/15/2013>
-- Description:	Overrides rates into dbo.deal_contract_account table
-- =============================================
CREATE PROCEDURE [dbo].[usp_contract_account_override_rates]
(
	@ContractNumber                                 char(12)
	, @AccountNumber                                varchar(30)
	, @Rate                                         float
	, @RatesString									varchar(200)
)
AS
BEGIN
	UPDATE dbo.deal_contract_account
	SET rate=@Rate, RatesString=@RatesString
	WHERE account_number=@AccountNumber and contract_nbr=@ContractNumber

END
GO

/****** Object:  StoredProcedure [dbo].[usp_contract_pricing_ins]    Script Date: 01/11/2013 16:52:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 4/9/2007
-- Description:	Insert / update pricing data
-- =============================================
-- Modified: Gail Mangaroo 1/25/2008
-- update deal_pricing_detail when rate is submitted
-- =============================================
-- Modified: Gail Mangaroo 3/28/2008
-- get COMMCAP rate from Custom Pricing if the rate is a custom rate 
-- altered update of rate_submit_ind 
-- =============================================
-- Modified: Eric Hernandez 4/30/2008
-- added customer_type to table, so parameters had to be added for this insert.
-- =============================================
-- Modified: Jose Munoz 1/14/2010
-- add HeatIndexSourceID and HeatRate for updates in the tables 
-- deal_contract, deal_contract_account and deal_pricing_detail
-- =============================================
-- Modified: Gail Mangaroo 2/18/2010
-- Added rate cap validation 
-- =============================================
-- Modified: Jose Munoz 5/11/2010
-- Add evergreen_option_id, evergreen_commission_end, residual_option_id, residual_commission_end
--     initial_pymt_option_id, sales_manager, evergreen_commission_rate Columns
-- Project IT021
-- =============================================
-- =============================================
-- Modified: Diogo Lima 10/26/2010
--  update product/rate. all account have to have the same product
-- Ticket 17697 
-- =============================================
-- Modified: Isabelle Tamanini 11/17/2010
-- Removed code that updates rate_submit_ind for custom rates:
-- this is now handled by lp_deal_capture..usp_contract_submit_ins
-- SD19106  
-- =============================================
-- =============================================
-- Modified: Jaime Forero 3/22/2011
-- TICKET # 21693
-- Terms were not consistent with UI, users selected terms and once saved the terms were different.
-- Changed SP, look in comments for changed code
-- =============================================
-- Modified: Isabelle Tamanini 12/16/2011
-- SR1-4955209
-- Date end will be terms + eff start date - 1 day
-- =============================================
-- =============================================
-- Modified: Isabelle Tamanini 3/28/2012
-- SR1-11994972
-- Modified so that it doesn't try to get the rate by the deal date
-- if the rate is custom (as in the proc that gets the rates)
-- =============================================

ALTER PROCEDURE [dbo].[usp_contract_pricing_ins]

(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_retail_mkt_id                                   char(02)		= '',
 @p_utility_id                                      char(15)		= '',
 @p_account_type									varchar(50)		= '',
 @p_product_id                                      char(20)		= '',
 @p_rate_id                                         int				= 0,
 @p_rate                                            float			= 0,
 @p_contract_eff_start_date                         datetime		= '19000101',
 @p_term_months                                     int				= 0,
 @p_account_number                                  varchar(30)		= '',
 @p_enrollment_type                                 int             = 1,
 @p_requested_flow_start_date                       datetime        = '19000101',
 @p_contract_date									datetime        = NULL,
 @p_comm_cap										float           = 0,
 @p_customer_code                                   char(05)        = '',
 @p_customer_group                                  char(100)       = '',
 @p_error                                           char(01)		= '',
 @p_msg_id                                          char(08)		= '',
 @p_descp                                           varchar(250)	= '',
 @p_result_ind                                      char(01)		= 'Y',
 @p_HeatIndexSourceID								int				= 0, -- Project IT037
 @p_HeatRate										float			= 0,  -- Project IT037
 @p_transfer_rate									float			= 0 
,@evergreen_option_id								int				= null	-- IT021
,@evergreen_commission_end							datetime		= null	-- IT021
,@residual_option_id								int				= null	-- IT021
,@residual_commission_end							datetime		= null	-- IT021
,@initial_pymt_option_id							int				= null	-- IT021
,@sales_manager										varchar(100)	= null	-- IT021
,@evergreen_commission_rate							float			= null	-- IT021
,@p_zone varchar(20) = null -- IT092
,@PriceID											int				= 0 -- IT106
,@PriceTier											int				= 0 -- IT106
, @RatesString										varchar(200)	= null
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

declare @w_application               varchar(20)
select @w_application                               = 'COMMON'

select @p_contract_nbr                              = upper(@p_contract_nbr)

select @p_retail_mkt_id                             = upper(@p_retail_mkt_id)
select @p_utility_id                                = upper(@p_utility_id)
select @p_product_id                                = upper(@p_product_id)

declare @w_contract_type                            varchar(15)
declare @w_retail_mkt_id                            char(02)
declare @w_utility_id                               char(15)
declare @w_product_id                               char(20)
declare @w_rate_id                                  int
declare @w_rate                                     float
declare @w_ratesString                              nvarchar(200)
declare @w_changeProduct							char(1)
declare @w_contract_eff_start_date                  datetime
declare @w_term_months                              int
declare @w_term_months2                              int
declare @w_date_end                                 datetime
declare @w_grace_period                             int
declare @w_due_date                                 datetime
declare @w_fixed_end_date                           tinyint
declare @w_rate_cap									float,
		@Today										datetime 

SET	@Today	= DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))

if @p_account_number                                = 'CONTRACT'
begin
   select @w_contract_type                          = contract_type,
          @w_retail_mkt_id                          = retail_mkt_id,
          @w_utility_id                             = utility_id,
          @w_product_id                             = product_id,
          @w_rate_id                                = rate_id,
          @w_rate                                   = rate,
          @w_contract_eff_start_date                = contract_eff_start_date,
          @w_term_months2                            = term_months,
          @w_grace_period                           = grace_period
   from deal_contract with (NOLOCK INDEX = deal_contract_idx)
   where contract_nbr                               = @p_contract_nbr 
end
else
begin
   select @w_contract_type                          = contract_type,
          @w_retail_mkt_id                          = retail_mkt_id,
          @w_utility_id                             = utility_id,
          @w_product_id                             = product_id,
          @w_rate_id                                = rate_id,
          @w_rate                                   = rate,
          @w_contract_eff_start_date                = contract_eff_start_date,
          @w_term_months2                            = term_months,
          @w_grace_period                           = grace_period
   from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
   where contract_nbr                               = @p_contract_nbr 
   and	 account_number                             = @p_account_number
end


-- TICKET # 21693, Rates were not matching selected rats in Deal Capture, 
-- the selection criteria did not take into account the effective date of the contract

-- This date can me null sometimes, we need a reference date always, if not supplied then just use todays date:
DECLARE @w_temp_contract_date DATETIME;

print 'today ' + cast(@Today as varchar(50))
print 'contract date ' + cast(@p_contract_date as varchar(50))

SET @w_temp_contract_date = @p_contract_date;

IF @w_temp_contract_date IS NULL OR @w_temp_contract_date = ''
BEGIN
	SET @w_temp_contract_date = CAST(FLOOR( CAST( GETDATE() AS FLOAT ) ) AS DATETIME); -- set today's date
END

-- IT106
-- history
IF @w_temp_contract_date < @Today
	BEGIN
print 'getting history term months'	
		SELECT 	 
				@w_term_months		= h.term_months,
				@w_due_date			= r.due_date, 
				@w_fixed_end_date	= r.fixed_end_date
		FROM lp_common..product_rate_history h (NOLOCK)
		JOIN lp_common..common_product		 p (NOLOCK) ON h.product_id = p.product_id
		JOIN lp_common..common_product_rate  r (NOLOCK) ON h.rate_id = r.rate_id AND h.product_id = r.product_id
		WHERE (p.iscustom = 1 OR h.eff_date = @w_temp_contract_date) --SR1-11994972
		AND		h.rate_id  = @p_rate_id 
		AND		h.product_id = @p_product_id
		AND		(	
					p.iscustom = 1 -- For custom products, start month matching is not enforced.
				OR	@p_contract_eff_start_date = '19000101'
				OR	h.contract_eff_start_date = dateadd(mm,datediff(mm,0,@p_contract_eff_start_date),0) -- gets first day of the month out 
				)
	END
-- current
ELSE
	BEGIN
	print 'getting current term months'
		SELECT 	 
				@w_term_months		= @p_term_months,
				@w_due_date			= r.due_date, 
				@w_fixed_end_date	= r.fixed_end_date
		FROM lp_common..common_product		 p (NOLOCK)
		JOIN lp_common..common_product_rate  r (NOLOCK) ON p.product_id = r.product_id
		WHERE	r.rate_id  = @p_rate_id 
		AND		r.product_id = @p_product_id
		AND		(
					p.iscustom = 1 -- For custom products, start month matching is not enforced.
				OR	@p_contract_eff_start_date = '19000101'
				OR	r.contract_eff_start_date = dateadd(mm,datediff(mm,0,@p_contract_eff_start_date),0) -- gets first day of the month out 
				)	
	END
	
if @w_term_months is null
	begin	
		SELECT	@w_term_months = Term
		FROM	Libertypower..Price WITH (NOLOCK)
		WHERE	ID = @PriceID
	end
else
	print 'term months ' + cast(@w_term_months as varchar(20))
--SR1-4955209
SET @w_date_end = dateadd(mm, @w_term_months, dateadd(dd, -1, @p_contract_eff_start_date))


-- START COMMENTED SECTION TICKET # 21693 -- REPLACED BY CODE ABOVE

--
--select @w_term_months                               = term_months,
--       @w_due_date                                  = due_date, 
--       @w_fixed_end_date                            = fixed_end_date
--from lp_common..common_product_rate with (NOLOCK)
--where product_id                                    = @p_product_id 
--and   rate_id                                       = @p_rate_id 


-- END COMMENTED SECTION TICKET # 21693

--and   inactive_ind                                  = '0'  -- Comments Ticket 19194




if @p_utility_id <> @w_utility_id
begin 
	delete from deal_contract_account
	where contract_nbr = @p_contract_nbr
end

if (@p_product_id <> @w_product_id) or (@p_term_months <> @w_term_months2)
begin 
	select @w_changeProduct = 'Y'
end
else
begin 
	select @w_changeProduct = 'N'
end

print 'before val'
exec @w_return = usp_contract_pricing_val @p_username,
                                          'I',  
                                          'ALL',
                                          @p_contract_nbr,
                                          @p_account_number, 
                                          @p_retail_mkt_id,  
                                          @p_utility_id,     
                                          @p_product_id,     
                                          @p_rate_id,
										  @p_rate,
                                          @w_term_months,
                                          @p_enrollment_type,
                                          @p_requested_flow_start_date,
                                          @p_contract_date,
                                          @p_customer_code,
                                          @p_customer_group,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output,
                                          'ONLINE',
                                          @PriceID
if @w_return                                       <> 0
begin
	print 'after val error'
   goto goto_select
end

print 'after val'

if len(@p_contract_eff_start_date)                  = 0
begin
   select @p_contract_eff_start_date                = getdate()
end

if  @w_grace_period                                 = 0
begin
   select @w_grace_period                           = grace_period
   from lp_common..common_product_rate with (NOLOCK INDEX = common_product_rate_idx)
   where product_id                                 = @p_product_id
   and   rate_id                                    = @p_rate_id
   and   inactive_ind                               = '0'
end

-- Rate Cap Validation SD# 10854 Gail Mangaroo 
-- ===============================
SET @w_rate_cap = 0 
SELECT @w_rate_cap = rate_cap FROM lp_deal_capture..deal_rate with (nolock)

If @p_transfer_rate = 0 
	BEGIN 
		-- get transfer rate 
		SELECT @p_transfer_rate =  isnull(dpd.ContractRate , a.rate)  -- a.rate, a.term_months, dpd.ContractRate, dpd.Commission
			FROM lp_common..common_product_rate a with (nolock)
				LEFT JOIN lp_deal_capture.dbo.deal_pricing_detail dpd with (nolock) on a.product_id = dpd.product_id and a.rate_id = dpd.rate_id 
				JOIN lp_common..common_product p with (nolock) on p.product_id = a.product_id

			WHERE a.product_id = @p_product_id
				AND a.rate_id= @p_rate_id
				AND convert(char(08), getdate(), 112) >= a.eff_date
				AND convert(char(08), getdate(), 112) < a.due_date
				AND a.term_months = isnull(@p_term_months,a.term_months)
				AND a.inactive_ind = '0'
	END 

If @p_rate > @p_transfer_rate + @w_rate_cap AND @w_rate_cap > 0 AND @p_transfer_rate > 0
BEGIN
	select @w_error			= 'E'
	select @w_msg_id		= '00000044'
	select @w_return		= 1
	select @w_descp_add		= ''
	select @w_application	= 'DEAL'
	goto goto_select
END

-- ============================================

if @p_account_number = 'CONTRACT'
begin
   print 'DEBUG: from usp_contract_pricing_ins, just before updating deal_contract'
   update deal_contract set retail_mkt_id = @p_retail_mkt_id,
                            utility_id = @p_utility_id,
							account_type = @p_account_type,
                            product_id = @p_product_id,
                            rate_id = @p_rate_id,
                            rate = @p_rate,
                            RatesString=@RatesString,
                            contract_eff_start_date = @p_contract_eff_start_date,
                            term_months = @w_term_months,
                            date_end = case when @w_fixed_end_date = 1 
                                            then @w_due_date 
                                            else @w_date_end 
                                       end,
                            grace_period = @w_grace_period,
                            enrollment_type = @p_enrollment_type,
                            requested_flow_start_date = @p_requested_flow_start_date,
                            customer_code = @p_customer_code,
                            customer_group = @p_customer_group,
                            HeatIndexSourceID = @p_HeatIndexSourceID, -- Project IT037
                            HeatRate = @p_HeatRate -- Project IT037
							,evergreen_option_id		= case when @evergreen_option_id		is null then evergreen_option_id		else @evergreen_option_id		end -- IT021
							,evergreen_commission_end	= case when @evergreen_commission_end	is null then evergreen_commission_end	else @evergreen_commission_end	end -- IT021
							,residual_option_id			= case when @residual_option_id			is null then residual_option_id			else @residual_option_id		end -- IT021
							,residual_commission_end	= case when @residual_commission_end	is null then residual_commission_end	else @residual_commission_end	end -- IT021
							,initial_pymt_option_id		= case when @initial_pymt_option_id		is null then initial_pymt_option_id		else @initial_pymt_option_id	end -- IT021
							,sales_manager				= case when @sales_manager				is null then sales_manager				else @sales_manager				end -- IT021
							,evergreen_commission_rate	= case when @evergreen_commission_rate	is null	then evergreen_commission_rate	else @evergreen_commission_rate	end -- IT021
							,PriceID	= @PriceID -- IT106
							,PriceTier	= @PriceTier -- IT106
   from deal_contract with (NOLOCK INDEX = deal_contract_idx)
   where contract_nbr                               = @p_contract_nbr 

   if @@error <> 0 or @@rowcount = 0
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = '(Contract)'
      goto goto_select
   end

   print 'DEBUG: from usp_contract_pricing_ins, just before updating deal_contract_account'
   update deal_contract_account set contract_type = @w_contract_type,
                                    retail_mkt_id = case when retail_mkt_id = 'NN' 
                                                         or   utility_id    = 'NONE' 
                                                         or   product_id    = 'NONE' 
                                                         or   rate_id       = 0 
                                                         or   rate          = 0
                                                         then @p_retail_mkt_id
                                                         when retail_mkt_id = 'SELECT...'
                                                         then 'NN'
                                                         else retail_mkt_id 
                                                    end,
		                            account_type = @p_account_type,
                                    utility_id = case when retail_mkt_id = 'NN' 
                                                      or   utility_id    = 'NONE' 
                                                      or   product_id    = 'NONE' 
                                                      or   rate_id       = 0 
                                                      or   rate          = 0
                                                      then @p_utility_id
                                                      when utility_id    = 'SELECT...'
                                                      then 'NONE'
                                                      else utility_id 
                                                 end, 
                                    --product_id = case when retail_mkt_id = 'NN' 
                                    --                  or   utility_id    = 'NONE' 
                                    --                  or   product_id    = 'NONE' 
                                    --                  or   rate_id       = 0 
                                    --                  or   rate          = 0
                                    --                  then @p_product_id
                                    --                  when product_id    = 'SELECT...'
                                    --                  then 'NONE'
                                    --                  else @p_product_id --changed to updated all accounts of the contract
                                    --             end,
                                    --rate_id = case when retail_mkt_id = 'NN' 
                                    --               or   utility_id    = 'NONE' 
                                    --               or   product_id    = 'NONE' 
                                    --               or   rate_id       = 0 
                                    --               or   rate          = 0
                                    --               or   @w_changeProduct = 'Y'
                                    --               then @p_rate_id
                                    --               when product_id    = 'SELECT...'
                                    --               then 999999999
                                    --               else rate_id --changed to updated all accounts of the contract
                                    --          end,
                                    --rate = case when retail_mkt_id = 'NN' 
                                    --            or   utility_id    = 'NONE' 
                                    --            or   product_id    = 'NONE' 
                                    --            or   rate_id       = 0 
                                    --            or   rate          = 0
                                    --            or   @w_changeProduct = 'Y'
                                    --            then @p_rate
                                    --            else rate --changed to updated all accounts of the contract
                                    --       end,
                                    contract_eff_start_date = case when contract_eff_start_date = '19000101'
                                                                   then @p_contract_eff_start_date
                                                                   else contract_eff_start_date
                                                              end,
                                    term_months = case when term_months = 0
                                                       then @w_term_months
                                                       else @w_term_months
                                                  end,
                                    date_end = case when @w_fixed_end_date = 1 
                                                    then @w_due_date 
                                                    else @w_date_end 
                                               end,
                                    grace_period = case when grace_period = 0
                                                        then grace_period
                                                        else grace_period
                                                   end,
                                    customer_code = case when customer_code = ''
                                                         then @p_customer_code
                                                         else customer_code
                                                    end,
                                    customer_group = case when customer_group = ''
                                                          then @p_customer_group
                                                          else customer_group
                                                     end,
                                    HeatIndexSourceID = @p_HeatIndexSourceID, -- Project IT037
									HeatRate = @p_HeatRate -- Project IT037
									,evergreen_option_id		= case when @evergreen_option_id		is null then evergreen_option_id		else @evergreen_option_id		end -- IT021
									,evergreen_commission_end	= case when @evergreen_commission_end	is null then evergreen_commission_end	else @evergreen_commission_end	end -- IT021
									,residual_option_id			= case when @residual_option_id			is null then residual_option_id			else @residual_option_id		end -- IT021
									,residual_commission_end	= case when @residual_commission_end	is null then residual_commission_end	else @residual_commission_end	end -- IT021
									,initial_pymt_option_id		= case when @initial_pymt_option_id		is null then initial_pymt_option_id		else @initial_pymt_option_id	end -- IT021
									,evergreen_commission_rate	= case when @evergreen_commission_rate	is null	then evergreen_commission_rate	else @evergreen_commission_rate	end -- IT021
									--,PriceID	= @PriceID -- IT106
   from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
   where contract_nbr = @p_contract_nbr 
   print 'DEBUG: from usp_contract_pricing_ins, just after updating deal_contract_account'

   if @@error <> 0
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
                                    retail_mkt_id = case when retail_mkt_id = 'SELECT...'
                                                         then 'NN'
                                                         else @p_retail_mkt_id
                                                    end, 
									account_type = @p_account_type,
                                    utility_id = case when utility_id = 'SELECT...'
                                                      then 'NONE'
                                                      else @p_utility_id
                                                 end, 
                                    product_id = case when product_id = 'SELECT...'
                                                      then 'NONE'
                                                      else @p_product_id
                                                 end,
                                    rate_id = case when product_id = 'SELECT...'
                                                   then 999999999
                                                   else @p_rate_id
                                              end,
                                    rate = @p_rate,
                                    RatesString=@RatesString,
                                    zone = @p_zone,
                                    contract_eff_start_date = @p_contract_eff_start_date,
                                    term_months = @w_term_months,
                                    date_end = case when @w_fixed_end_date = 1 then @w_due_date else @w_date_end end,
                                    grace_period = case when grace_period = 0
                                                        then @w_grace_period
                                                        else grace_period
                                                   end,
                                    customer_code = @p_customer_code,
                                    customer_group = @p_customer_group,
                                    HeatIndexSourceID = @p_HeatIndexSourceID, -- Project IT037
									HeatRate = @p_HeatRate -- Project IT037
									,evergreen_option_id		= case when @evergreen_option_id		is null then evergreen_option_id		else @evergreen_option_id		end -- IT021
									,evergreen_commission_end	= case when @evergreen_commission_end	is null then evergreen_commission_end	else @evergreen_commission_end	end -- IT021
									,residual_option_id			= case when @residual_option_id			is null then residual_option_id			else @residual_option_id		end -- IT021
									,residual_commission_end	= case when @residual_commission_end	is null then residual_commission_end	else @residual_commission_end	end -- IT021
									,initial_pymt_option_id		= case when @initial_pymt_option_id		is null then initial_pymt_option_id		else @initial_pymt_option_id	end -- IT021
									,evergreen_commission_rate	= case when @evergreen_commission_rate	is null	then evergreen_commission_rate	else @evergreen_commission_rate	end -- IT021
									,PriceID	= @PriceID -- IT106
   from deal_contract_account with (NOLOCK INDEX = deal_contract_account_idx)
   where contract_nbr                               = @p_contract_nbr 
   and   account_number                             = @p_account_number

   if @@error                                      <> 0 
   or @@rowcount                               = 0
   begin
      select @w_error                               = 'E'
      select @w_msg_id                              = '00000051'
      select @w_return                              = 1
      select @w_descp_add                           = '(Contract - Account)'
      goto goto_select
   end

end
/*
-- Mark custom rate as submitted
-- -----------------------------------------

-- IF Custom Rate no longer in use; release it 
if (select count(*) 
    from deal_pricing_detail 
	where product_id                            = @w_product_id 
    and rate_id                                     = @w_rate_id ) > 0 
begin
   declare @contr_count                             int 
   declare @acct_count                              int 

   select @contr_count                              = count(*) 
   from deal_contract 
   where product_id                                 = @w_product_id 
   and   rate_id                                    = @w_rate_id 
   and   contract_nbr                               = @p_contract_nbr

   select @acct_count                               = count(*) 
   from deal_contract_account 
   where product_id                                 = @w_product_id 
   and   rate_id                                    = @w_rate_id 
   and   contract_nbr                               = @p_contract_nbr
		
   if  @contr_count                                 = 0 
   and @acct_count                                  = 0
   begin 
	-- release the old rate 
      update deal_pricing_detail set rate_submit_ind = 0, 
                                     date_modified = getdate(), 
                                     modified_by = @p_username
      where product_id                              = @w_product_id 
      and   rate_id                                 = @w_rate_id
   end 
end

	-- mark the new rate
update deal_pricing_detail set rate_submit_ind = 1, 
                               date_modified = getdate(), 
                               modified_by = @p_username
where product_id                                    = @p_product_id 
and   rate_id                                       = @p_rate_id	

	
--end 
*/
-- per Douglas, date_deal will be the contracted date for custom pricing. 6/6/2007
------------------------------------
-- updating all records per contract
if @p_contract_date                            is not null
begin
   update deal_contract set date_deal = @p_contract_date
   where	contract_nbr	                        = @p_contract_nbr 

   update deal_contract_account set date_deal = @p_contract_date
   where	contract_nbr                            = @p_contract_nbr 
end

select @w_return                                    = 0

goto_select:

if @w_error                                        <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp output,
                                    @w_application
   select @w_descp = ltrim(rtrim(@w_descp)) + '' + @w_descp_add 
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

/****** Object:  StoredProcedure [dbo].[usp_contract_account_ins]    Script Date: 01/11/2013 16:41:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_contract_account_ins 'WVILCHEZ', '2006-0000121', '1234567890'

-- =============================================
-- Modified: Jose Munoz 1/14/2010
-- add HeatIndexSourceID and HeatRate for updates in the tables 
-- deal_contract, deal_contract_account and deal_pricing_detail
-- Project IT037
-- =============================================
-- =============================================
-- Modified: George Worthington 4/30/2010
-- added Sales Channel Settings overrided fields
-- Project IT021
-- =============================================
ALTER procedure [dbo].[usp_contract_account_ins]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30),
 @p_error                                           char(01)		= '',
 @p_meter_number									varchar(2000)	= 'NONE',
 @p_msg_id                                          char(08)		= '',
 @p_descp                                           varchar(250)	= '',
 @p_result_ind                                      char(01)		= 'Y',
 @p_utility_id										char(15) = null,
 @p_zone											varchar(20),
 @PriceID					int = 0)


as

select @p_account_number                            = upper(@p_account_number)
 
declare @w_error                                    char(01)
declare @w_msg_id                                   char(08)
declare @w_descp                                    varchar(250)
declare @w_return                                   int
declare @w_descp_add                                varchar(25)
 
select @w_error                                     = 'I'
select @w_msg_id                                    = '00000001'
select @w_descp                                     = ''
select @w_return                                    = 0
select @w_descp_add                                 = ''

declare @w_application                              varchar(20)
select @w_application                               = 'COMMON'

declare @w_account_id                               char(12)
select @w_account_id                                = ''

declare @w_account_number_prefix                    varchar(10)
declare @w_prefix_length							int
declare @w_address_link								int
declare @w_name_link								int


IF EXISTS(SELECT account_id FROM lp_account..account with (nolock)
			WHERE account_number = @p_account_number 
			AND utility_id = @p_utility_id )
BEGIN
	SELECT @w_account_id = account_id FROM lp_account..account with (nolock)
			WHERE account_number = @p_account_number 
			AND utility_id = @p_utility_id
END
ELSE 
BEGIN
exec @w_return                                      = usp_get_key @p_username, 
                                                                  'ACCOUNT ID', 
                                                                  @w_account_id output, 
                                                                  'N'
END                                                                 

if @w_return                                       <> 0
begin
   select @w_application                            = 'DEAL'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000001'
   select @w_return                                 = 1
   select @w_descp_add                              = '(Account ID)'
   goto goto_select
end

-- determine if a prefix needs to be added to account number  --------------------
select @w_account_number_prefix                      = AccountNumberPrefix
from  LibertyPower..Utility with (nolock)
where UtilityCode = (select top 1 utility_id 
                    from  deal_contract with (nolock) where contract_nbr = @p_contract_nbr)

select @w_prefix_length                              = len(@w_account_number_prefix)

select @w_address_link								 =	MAX(address_link)
from lp_deal_capture..deal_address with (nolock)
where contract_nbr = @p_contract_nbr

select @w_name_link								 =	MAX(name_link)
from lp_deal_capture..deal_name with (nolock)
where contract_nbr = @p_contract_nbr

if @w_prefix_length                                  > 0
begin
   if  (charindex('+', ltrim(rtrim(@w_account_number_prefix))) <> 0)
   and (left(@p_account_number, (@w_prefix_length - 1))        <> right(@w_account_number_prefix, (@w_prefix_length - 1)))
   begin
      select @p_account_number                       = right(@w_account_number_prefix, (@w_prefix_length - 1)) 
                                                     + @p_account_number
   end
end

exec @w_return = usp_contract_account_val @p_username,
                                          'I',
                                          'ALL',
                                          @p_contract_nbr,
                                          @p_account_number,
                                          @w_application output,
                                          @w_error output,
                                          @w_msg_id output,
                                          @p_utility_id



if @w_return <> 0
begin
   goto goto_select
end
insert into deal_contract_account 
	(contract_nbr,contract_type, account_number, status, account_id, retail_mkt_id, utility_id,account_type, product_id
	, rate_id, rate, account_name_link, customer_name_link, 
		customer_address_link,
       customer_contact_link,
		billing_address_link,
       billing_contact_link,
       owner_name_link,
       service_address_link,
       business_type,
       business_activity,
       additional_id_nbr_type,
       additional_id_nbr,
       contract_eff_start_date,
	   enrollment_type,
       term_months,
       date_end,
       date_deal,
       date_created,
       date_submit,
       sales_channel_role,
       username,
       sales_rep,
       origin,
       grace_period, chgstamp,requested_flow_start_date,
       deal_type,
       customer_code,
       customer_group
       ,[SSNClear],[SSNEncrypted],[CreditScoreEncrypted],HeatIndexSourceID,HeatRate
		,evergreen_option_id
		,evergreen_commission_end
		,residual_option_id
		,residual_commission_end
		,initial_pymt_option_id
		,evergreen_commission_rate
		,TaxStatus
		,zone
		,PriceID
		, RatesString)
       
select @p_contract_nbr,
       contract_type,
       @p_account_number,
       status                                       = ' ',
      @w_account_id,
       case when upper(rtrim(ltrim(retail_mkt_id))) = 'SELECT...'
            then 'NN'
            else retail_mkt_id
       end,
       case when upper(rtrim(ltrim(utility_id))) = 'SELECT...'
            then 'NONE'
            else utility_id
       end,
       account_type,
       case when upper(rtrim(ltrim(product_id))) = 'SELECT...'
            then 'NONE'
            else product_id
       end,
       case when upper(rtrim(ltrim(product_id))) = 'SELECT...'
            then 999999999
            else rate_id
       end,
       rate,
       @w_name_link,
       customer_name_link,
       customer_address_link,
       customer_contact_link,
       billing_address_link,
       billing_contact_link,
       owner_name_link,
       @w_address_link,
       business_type,
       business_activity,
       additional_id_nbr_type,
       additional_id_nbr,
       contract_eff_start_date,
	   enrollment_type,
       term_months,
       date_end,
       date_deal,
       date_created,
       date_submit,
       sales_channel_role,
       @p_username,
       
       sales_rep,
       origin,
       grace_period,
       0,	--chgstamp
       requested_flow_start_date,
       deal_type,
       customer_code,
       customer_group,
       SSNClear,
       SSNEncrypted,
       CreditScoreEncrypted,
	   HeatIndexSourceID, -- Project IT37
	   HeatRate       -- Project IT37
		,NULL --[evergreen_option_id] 
		,NULL --[evergreen_commission_end] 
		,NULL --[residual_option_id] 
		,NULL --[residual_commission_end] 
		,NULL --[initial_pymt_option_id] 
		,NULL --[evergreen_commission_rate] 
		,TaxStatus
		,@p_zone
		,@PriceID
		, RatesString
from  deal_contract with (NOLOCK INDEX = deal_contract_idx)
where contract_nbr                                  = @p_contract_nbr

if @@error <> 0 or @@rowcount = 0
begin
   select @w_application                            = 'COMMON'
   select @w_error                                  = 'E'
   select @w_msg_id                                 = '00000051'
   select @w_return                                 = 1
   select @w_descp_add                              = '(Account Number)'
end

select @w_return                                    = 0

if @p_meter_number                                 <> 'NONE'
begin
   declare @w_id			                        int
   declare @w_value                                 varchar(500)
   declare @w_rowcount                              int

   insert into account_meters
   select distinct
          @w_account_id,
          value 
   from lp_account.dbo.ufn_split_delimited_string (@p_meter_number, ',')
   where len(ltrim(rtrim(value)))                   > 0
end

goto_select:

if @w_error <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id, 
                                    @w_descp output,
                                    @w_application
   select @w_descp = ltrim(rtrim(@w_descp)) 
                   + ' ' 
                   + @w_descp_add 
end
 
if @p_result_ind = 'Y'
begin
   select flag_error = @w_error,
          code_error = @w_msg_id,
          message_error = @w_descp,
		  account_number = @p_account_number
   goto goto_return
end
 
select @p_error = @w_error,
       @p_msg_id = @w_msg_id,
       @p_descp = @w_descp,
	   @p_account_number = @p_account_number
 
goto_return:
return @w_return

--- END of procedure [dbo].[usp_contract_account_ins] -----------------------------------------------------------------

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK INSERT INTO #error_status (has_error) VALUES (1) SET NOEXEC ON END
GO

/****** Object:  StoredProcedure [dbo].[usp_contract_account_select_list]    Script Date: 01/15/2013 12:24:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_contract_account_sel_list 'WVILCHEZ', '2006-0000121'

ALTER procedure [dbo].[usp_contract_account_select_list]
(@p_username                                        nchar(100),
 @p_contract_nbr                                    char(12),
 @p_account_number                                  varchar(30))
as

declare @w_sales_channel_role                       nvarchar(50)
	
select @w_sales_channel_role                        = sales_channel_role
from deal_contract with (NOLOCK INDEX = deal_contract_idx)
where contract_nbr                                  = @p_contract_nbr

declare @w_user_id                                  int

select @w_user_id                                   = UserID
from lp_portal..Users with (nolock)
where Username                                      = @p_username

select ca.account_number,
	   ca.account_id,
       ca.status,
       ca.utility_id,
       ca.contract_type,
       ca.account_type,
       ca.customer_name_link,              
       ca.customer_address_link,
	   ca.customer_contact_link,
       ca.billing_address_link,
	   ca.billing_contact_link,
	   ca.owner_name_link,
	   ca.service_address_link,
	   ca.account_name_link,  
	   ca.additional_id_nbr, 
	   ca.additional_id_nbr_type,
	   ca.sales_channel_role,
	   ca.sales_rep,
	   ca.retail_mkt_id,
	   ca.product_id,
	   ca.date_deal,
	   ca.date_submit,
	   ca.business_type,
	   ca.business_activity,
	   ca.contract_eff_start_date,
	   ca.term_months,
	   ca.date_end,
	   ca.date_created,
	   ca.TaxStatus,
	   ca.origin,
	   ca.deal_type,
	   ca.customer_code,
	   ca.customer_group,
	   ca.SSNEncrypted,
       n.full_name,
       a.address,
       a.suite,
       a.city,
       a.state,
       a.zip,
       ca.requested_flow_start_date,
       ca.enrollment_type,
       ba.address as "Billingaddress",
       ba.suite as "Billingsuite",
       ba.city as "Billingcity",
       ba.state as "Billingstate",
       ba.zip as "Billingzip",
       ca.rate_id,
       ca.rate,
       m.meter_number,
       pr.rate_descp,
       --'' AS rate_descp,
       ca.customer_code,
       ai.name_key,
       ai.BillingAccount,
       ai.MeterDataMgmtAgent,
       ai.MeterServiceProvider,
       ai.MeterInstaller,
       ai.MeterReader,
       ai.SchedulingCoordinator,
       c.first_name,
       c.last_name,
       c.phone,
       c.title,
       c.fax,
       c.email,
       ca.zone,
       dcc.date_comment,
       dcc.comment,
       cb.first_name AS "BillingFirstName",
	   cb.last_name AS "BillingLastName",
	   cb.title AS "BillingTitle",
	   cb.Phone AS "BillingPhone",
	   cb.fax AS "BillingFax",
	   cb.email AS "BillingEmail",
	   cn.full_name AS "CustomerName",
	   ow.full_name AS "OwnerName",
	   cus.address AS "CustomerAddress",
	   cus.suite AS "CustomerSuite",
	   cus.state AS "CustomerState",
	   cus.zip AS "CustomerZip",
	   cus.city AS "CustomerCity",
	   dca.contract_nbr_amend,
	   ca.PriceID,
	   (SELECT ISNULL(IsCustom, 0)FROM lp_common..common_product WITH (NOLOCK) WHERE product_id = ca.product_id) AS IsCustom
	   , ca.RatesString
from deal_contract_account ca with (NOLOCK INDEX = deal_contract_account_idx)
left join deal_name n with (nolock) ON ca.contract_nbr = n.contract_nbr AND ca.account_name_link = n.name_link
left join deal_contact c with (nolock) ON ca.contract_nbr = c.contract_nbr AND ca.customer_contact_link = c.contact_link
left join deal_address a  with (nolock) ON ca.contract_nbr = a.contract_nbr AND ca.service_address_link = a.address_link
left join deal_address ba  with (nolock) ON ca.contract_nbr = ba.contract_nbr AND ca.billing_address_link = ba.address_link
left join deal_address cus  with (nolock) ON ca.contract_nbr = cus.contract_nbr AND ca.customer_address_link = cus.address_link
left join account_meters m  with (nolock) ON ca.account_id = m.account_id
left join deal_contract_comment dcc  with (nolock) ON ca.contract_nbr = dcc.contract_nbr
left join lp_common..common_product_rate pr  with (nolock) ON ca.product_id = pr.product_id AND ca.rate_id = pr.rate_id
left join lp_account..account_info ai  with (nolock) ON ca.account_id = ai.account_id
left join deal_contact cb  with (nolock) ON ca.contract_nbr = cb.contract_nbr AND ca.billing_contact_link = cb.contact_link
left join deal_name cn  with (nolock) ON ca.contract_nbr = cn.contract_nbr AND ca.account_name_link = cn.name_link
left join deal_name ow  with (nolock) ON ca.contract_nbr = ow.contract_nbr AND ca.account_name_link = ow.name_link
left join deal_contract_amend dca  with (nolock) ON ca.contract_nbr = dca.contract_nbr
where ca.contract_nbr                                  = @p_contract_nbr
and   @p_account_number							   IN ('',ca.account_number)
order by ca.account_id desc
GO

/*Create procedure Lp_deal_capture.dbo.GetPriceDetailsByPriceId*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lev Rosenblum
-- Create date: 02/18/2013
-- Description:	Get Price Details By PriceId
-- =============================================
CREATE PROCEDURE dbo.GetPriceDetailsByPriceId
	@PriceId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT dpd.[deal_pricing_detail_id]
		  ,dpd.[deal_pricing_id]
		  ,dpd.[product_id]
		  ,dpd.[rate_id]
		  ,dpd.[date_created]
		  ,dpd.[username]
		  ,dpd.[date_modified]
		  ,dpd.[modified_by]
		  ,dpd.[rate_submit_ind]
		  ,dpd.[ContractRate]
		  ,dpd.[Commission]
		  ,dpd.[Cost]
		  ,dpd.[MTM]
		  ,dpd.[HasPassThrough]
		  ,dpd.[BackToBack]
		  ,dpd.[HeatIndexSourceID]
		  ,dpd.[HeatRate]
		  ,dpd.[ExpectedTermUsage]
		  ,dpd.[ExpectedAccountsAmount]
		  ,dpd.[ETP]
		  ,dpd.[PriceID]
		  ,dpd.[SelfGenerationID]
		  , dp.account_name
		  , dp.sales_channel_role
		  , dp.commission_rate
		  , dp.date_expired
		  , dp.date_created
		  , dp.pricing_request_id
		  
	  FROM [Lp_deal_capture].[dbo].[deal_pricing_detail] dpd with (nolock)
		INNER JOIN [Lp_deal_capture].dbo.deal_pricing dp with (nolock) ON dp.deal_pricing_id=dpd.deal_pricing_id
	  WHERE PriceID=@PriceId
END
GO

--ROLLBACK
COMMIT
