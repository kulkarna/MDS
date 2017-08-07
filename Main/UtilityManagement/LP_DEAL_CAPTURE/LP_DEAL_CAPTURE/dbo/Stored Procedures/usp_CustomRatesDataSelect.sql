/*******************************************************************************
 * usp_CustomRatesDataSelect
 * Gets rates for custom prices
 *
 * History
 *******************************************************************************
 * 4/17/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_CustomRatesDataSelect]
	@Username		varchar(100),
	@UtilityCode	varchar(15),
	@AccountTypeID	int,
	@StartDate		datetime,
	@ContractDate	datetime,
	@Term			int
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@FirstDayOfMonth datetime
    SET		@FirstDayOfMonth = dateadd(mm,datediff(mm,0,@StartDate),0)
    
	SELECT	h.rate, pd.ContractRate, pd.HeatIndexSourceID, pd.HeatRate, h.contract_eff_start_date,
			h.product_id AS ProductId, h.rate_id AS RateId, d.date_expired AS ExpirationDate
    FROM	lp_common..product_rate_history h (NOLOCK)
    JOIN	lp_common..common_product p (NOLOCK) ON h.product_id = p.product_id
    JOIN	lp_common..common_product_rate pr (NOLOCK) ON pr.product_id = h.product_id and pr.rate_id = h.rate_id
    JOIN	lp_deal_capture..deal_pricing_detail pd (NOLOCK) ON h.product_id = pd.product_id AND h.rate_id = pd.rate_id
    JOIN	lp_deal_capture..deal_pricing d (NOLOCK) ON pd.deal_pricing_id = d.deal_pricing_id
    WHERE	--d.username			= @Username
    		sales_channel_role like '%/'+ @Username
			-- Commented out SR- 1-91434521 -> Term not populating
    ---AND		h.eff_date			= @ContractDate
    AND		p.utility_id		= @UtilityCode
    AND		p.account_type_id	= @AccountTypeID
	AND		(@StartDate IS NULL OR h.contract_eff_start_date = @FirstDayOfMonth)
	AND		d.date_expired		>= @ContractDate
	AND		h.term_months		= @Term
    AND		p.inactive_ind		= 0
    AND		pd.rate_submit_ind	= 0	
    AND		p.IsCustom			= 1   

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
