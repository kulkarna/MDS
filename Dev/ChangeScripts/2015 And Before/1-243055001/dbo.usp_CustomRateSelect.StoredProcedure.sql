USE [Lp_deal_capture]
GO
/****** Object:  StoredProcedure [dbo].[usp_CustomRateSelect]    Script Date: 10/23/2013 09:02:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CustomRateSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CustomRateSelect]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CustomRateSelect]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*******************************************************************************
 * usp_CustomRateSelect
 * Gets rate for custom prices
 *
 * History
 *******************************************************************************
 * 4/2/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 10/23/2012 - Cathy Ghazal
 * Added pr.BillingTypeID
 *******************************************************************************
 *******************************************************************************
 * Modify : Thiago Nogueira
 * Date : 7/25/2013 
 * Ticket: 1-179692237
 * Changed PriceID to BIGINT
 *******************************************************************************
 * 10/23/2013 - Rick Deigsler
 * Added pd.PriceID
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_CustomRateSelect]
	@Username		varchar(100),
	@UtilityCode	varchar(15),
	@AccountTypeID	int,
	@StartDate		datetime,
	@ContractDate	datetime,
	@Term			int,
	@RateID			bigint
AS
BEGIN
    SET NOCOUNT ON;
    -- For custom products, start month matching is not enforced.  
    SET @Username = REPLACE (@Username, ''\\'', ''\'')
    DECLARE	@FirstDayOfMonth datetime
    SET		@FirstDayOfMonth = dateadd(mm,datediff(mm,0,@StartDate),0)
    
	SELECT	h.Rate AS rate, pd.ContractRate, pd.HeatIndexSourceID, pd.HeatRate, h.contract_eff_start_date,
			h.product_id AS ProductId, h.rate_id AS RateId, d.date_expired AS ExpirationDate, pr.BillingTypeID, 
			pd.PriceID
    FROM	lp_common..product_rate_history h (NOLOCK)
    JOIN	lp_common..common_product p (NOLOCK) ON h.product_id = p.product_id
    JOIN	lp_common..common_product_rate pr (NOLOCK) ON pr.product_id = h.product_id and pr.rate_id = h.rate_id
    JOIN	lp_deal_capture..deal_pricing_detail pd (NOLOCK) ON h.product_id = pd.product_id AND h.rate_id = pd.rate_id
    JOIN	lp_deal_capture..deal_pricing d (NOLOCK) ON pd.deal_pricing_id = d.deal_pricing_id
	WHERE	-- Commented out SR- 1-91434521 -> Term not populating
			--h.eff_date			= @ContractDate
    		p.utility_id		= @UtilityCode
    AND		p.account_type_id	= @AccountTypeID
	AND		(@StartDate IS NULL OR h.contract_eff_start_date = @FirstDayOfMonth)
	AND		d.date_expired		>= @ContractDate
	AND		h.term_months		= @Term
	AND (pd.rate_id = @RateID OR pd.PriceID = @RateID)
	--AND pd.rate_id = @RateID
    AND		p.inactive_ind		= 0
    AND		pd.rate_submit_ind	= 0	
    AND		p.IsCustom			= 1   
	AND		(	-- user has access to custom rate	
				d.sales_channel_role		= @Username 
				OR d.sales_channel_role	= REPLACE(@Username , ''libertypower\'', ''SALES CHANNEL'') 
				OR d.sales_channel_role IN 
				(	SELECT	b.RoleName 
					FROM	lp_portal..UserRoles a (NOLOCK)
							JOIN lp_portal..Roles b  (NOLOCK) ON a.RoleID = b.RoleID  
							JOIN lp_portal..Users u  (NOLOCK) ON a.userID = u.UserID
					WHERE	Username	= @Username
					AND		b.RoleName	LIKE LTRIM(RTRIM(''SALES CHANNEL'')) + ''%'' 
				)
				 OR lp_common.dbo.ufn_is_liberty_employee(@Username) = 1 
			 ) 	    

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
' 
END
GO
