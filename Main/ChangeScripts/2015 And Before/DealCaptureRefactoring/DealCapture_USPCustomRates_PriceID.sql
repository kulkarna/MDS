USE [Lp_deal_capture]
GO
/****** Object:  StoredProcedure [dbo].[usp_CustomRatesSelect]    Script Date: 07/10/2013 15:58:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_CustomRatesSelect
 * Gets rates for custom prices
 *
 * History
 *******************************************************************************
 * 4/2/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 5/21/2013 - Isabelle Tamanini
 * Modified. LPEmployees that are sales channels should not have access to custom rates
 * unless they are the sales channel of the rate
 * SR1-80796128
 *******************************************************************************
 * 7/11/2013 - Sara Lakshmanan
 * Modified. Added priceid field to the selectlist 
 * We were not able to pull the saved deal in DealCapture and then send it to LP 
 * because the priceId was not available, and only the rateid was available. So adding PriceId to the list
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_CustomRatesSelect]
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
    
	SELECT	DISTINCT option_id = pr.rate_descp + ' ' + DATENAME(month,h.contract_eff_start_date) + ' ' + DATENAME(year,h.contract_eff_start_date) + ' Start', 
			return_value = pr.rate_id,
			return_value1 = pd.PriceID --Added July 11 2013 to get the price for Custom Smart step deal
    FROM	lp_common..product_rate_history h (NOLOCK)
    JOIN	lp_common..common_product p (NOLOCK) ON h.product_id = p.product_id
    JOIN	lp_common..common_product_rate pr (NOLOCK) ON pr.product_id = h.product_id and pr.rate_id = h.rate_id
    JOIN	lp_deal_capture..deal_pricing_detail pd (NOLOCK) ON h.product_id = pd.product_id AND h.rate_id = pd.rate_id
    JOIN	lp_deal_capture..deal_pricing d (NOLOCK) ON pd.deal_pricing_id = d.deal_pricing_id
    WHERE	h.eff_date			= @ContractDate
    AND		p.utility_id		= @UtilityCode
    AND		p.account_type_id	= @AccountTypeID
    AND		p.inactive_ind		= 0
    AND		p.IsCustom			= 1 -- For custom products, start month matching is not enforced.
	AND		(@StartDate IS NULL OR h.contract_eff_start_date = @FirstDayOfMonth)
	AND		d.date_expired		>= @ContractDate
	AND		h.term_months		= @Term
	AND		(	-- user has access to custom rate	
				d.sales_channel_role		= @Username 
				OR d.sales_channel_role	= REPLACE(@Username , 'libertypower\', 'SALES CHANNEL') 
				OR d.sales_channel_role IN 
				(	SELECT	b.RoleName 
					FROM	lp_portal..UserRoles a
							JOIN lp_portal..Roles b ON a.RoleID = b.RoleID  
							JOIN lp_portal..Users u ON a.userID = u.UserID
					WHERE	Username	= @Username
					AND		b.RoleName	LIKE LTRIM(RTRIM('SALES CHANNEL')) + '%' 
				)
				 OR (lp_common.dbo.ufn_is_liberty_employee(@Username) = 1 
					 AND NOT EXISTS (select 1 from libertypower..SalesChannel with (nolock)
								  	 where ChannelName = REPLACE(@Username, 'libertypower\', '')))
			 ) 		

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
