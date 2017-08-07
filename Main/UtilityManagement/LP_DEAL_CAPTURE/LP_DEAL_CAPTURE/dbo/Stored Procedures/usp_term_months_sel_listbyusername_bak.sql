-- For active products   exec usp_rate_sel_listbyusername 'libertypower\gmangaroo', 'AEPCE-FIXED-12' , ' ' , null , null 
-- For all products      exec usp_product_sel_listbyusername 'admin', 'CONED', @p_show_active_flag = null

-- ======================================================
-- Created by Eric Hernandez
-- 5/8/2008
-- ======================================================
-- Modified by Eric Hernandez
-- 5/6/2009
-- Added ability to select future rates and modified stored procedure to be backwards compatible.
-- ======================================================
-- Modified by José Muñoz
-- 11/17/2009
-- Added parameter "@p_contract_type" to filter then months where contract type is VOICE.
-- Ticket 11176
-- ======================================================
-- Modified by Diogo Lima
-- 8/9/2010
-- contract_eff_start_date range changed from 3 months to 6 months
-- Ticket 17511
-- ======================================================

CREATE procedure [dbo].[usp_term_months_sel_listbyusername_bak]
(@p_username                            nchar(100),
 @p_product_id                          char(20),
 @p_union_select                        varchar(15)		= ' ',
 @p_show_active_flag					tinyint			= 0,
 @p_deal_price_id						int				= 0 ,
 @p_contract_nbr						varchar(20)		= '',
 @p_contract_eff_start_date				Datetime		= null,
 @p_contract_type						varchar(20)		= ''   /* Ticket 11176 */
)
AS
BEGIN 
	declare @v_contract_type			varchar(5) /* Ticket 11176 */

	IF @p_contract_eff_start_date is null
		SET @p_contract_eff_start_date = getdate()

	DECLARE @w_sales_channel_prefix VARCHAR(100)

	SELECT @w_sales_channel_prefix = sales_channel_prefix  
	FROM lp_common..common_config with (NOLOCK)  

	DECLARE @product_rate table ( seq int, term_months int)
	DECLARE @SalesChannelRole varchar(50) 
	SELECT @SalesChannelRole = replace(@p_username , 'libertypower\', @w_sales_channel_prefix) 

	--- Get rates
	--- =================================================
	INSERT INTO @product_rate (seq, term_months)
	SELECT DISTINCT  2, pr.term_months
	FROM lp_common..common_product_rate pr with (NOLOCK INDEX = common_product_rate_idx)
	JOIN lp_common..common_product p ON pr.product_id = p.product_id 
	LEFT JOIN lp_deal_capture..deal_pricing_detail dpd ON dpd.product_id = pr.product_id and dpd.rate_id = pr.rate_id 
	LEFT JOIN lp_deal_capture..deal_pricing dp ON dp.deal_pricing_id = dpd.deal_pricing_id
    WHERE pr.product_id = @p_product_id
	AND pr.eff_date <= convert(char(08), getdate(), 112) 
	AND pr.due_date >= convert(char(08), getdate(), 112) 
	AND pr.inactive_ind = isnull(@p_show_active_flag,pr.inactive_ind)
	AND (
			(p.product_category = 'VARIABLE' AND p.product_category in ('PORTFOLIO','CUSTOM')) OR
			dp.deal_pricing_id is not null OR
			DATEPART(mm,pr.contract_eff_start_date) = DATEPART(mm,@p_contract_eff_start_date) OR
			DATEPART(mm,pr.contract_eff_start_date) = DATEPART(mm,DATEADD(MONTH,1,@p_contract_eff_start_date)) OR
			DATEPART(mm,pr.contract_eff_start_date) = DATEPART(mm,DATEADD(MONTH,2,@p_contract_eff_start_date)) OR
			DATEPART(mm,pr.contract_eff_start_date) = DATEPART(mm,DATEADD(MONTH,3,@p_contract_eff_start_date)) OR
			DATEPART(mm,pr.contract_eff_start_date) = DATEPART(mm,DATEADD(MONTH,4,@p_contract_eff_start_date)) OR /* Ticket 17511 */
			DATEPART(mm,pr.contract_eff_start_date) = DATEPART(mm,DATEADD(MONTH,5,@p_contract_eff_start_date)) OR /* Ticket 17511 */
			DATEPART(mm,pr.contract_eff_start_date) = DATEPART(mm,DATEADD(MONTH,6,@p_contract_eff_start_date))	  /* Ticket 17511 */
		)
	AND	(
		-- not custom pricing 
		dp.deal_pricing_id is null 
		
		OR ( -- rate has not expired 
			dp.date_expired > convert(char(08), getdate(), 112)
			-- user has access to deal pricing
			AND (
				 dp.sales_channel_role = @p_username 
				 OR dp.sales_channel_role = @SalesChannelRole 
				 OR dp.sales_channel_role in 
					(SELECT b.RoleName 
						FROM lp_portal..UserRoles a
							JOIN lp_portal..Roles b ON a.RoleID = b.RoleID  
							JOIN lp_portal..Users u with (NOLOCK INDEX = IX_Users)  ON a.userID = u.UserID
						WHERE Username = @p_username
							AND b.RoleName LIKE ltrim(rtrim(@w_sales_channel_prefix)) + '%' 
					 )
				 OR lp_common.dbo.ufn_is_liberty_employee(@p_username) = 1 
				) 
			-- rate has not already been submitted or exists on the current contract
			AND ( dpd.rate_submit_ind = 0 OR  EXISTS ( Select contract_nbr from deal_contract where contract_nbr = @p_contract_nbr and @p_contract_nbr <> '' and product_id = dpd.product_id and rate_id = dpd.rate_id UNION 
														Select contract_nbr from deal_contract_account where contract_nbr = @p_contract_nbr and  @p_contract_nbr <> '' and product_id = dpd.product_id and rate_id = dpd.rate_id
													) 
				)  
			)
		  )
		
	--- Get NONE selection if necessary
	--- =================================================
--	IF @p_union_select = 'NONE'
--	BEGIN
--		INSERT INTO @product_rate ( seq, term_months )
--		SELECT DISTINCT  1, 'None'
--	END 

	--- Final Select
	--- ==================================================== 


	/*Ticket 11176*/
	select @v_contract_type = upper(left(option_id,5)) 
	from lp_common..common_views with (nolock)
	where process_id		= 'CONTRACT TYPE'
	and seq					= @p_contract_type
	
	if upper(left(@p_contract_type,5)) = 'VOICE' or @v_contract_type = 'VOICE' 
	begin
		delete from @product_rate 
		where term_months > 24
	end
	/*Ticket 11176*/

	SELECT option_id = term_months, return_value = term_months
	FROM @product_rate 
	ORDER BY seq, option_id

END 

