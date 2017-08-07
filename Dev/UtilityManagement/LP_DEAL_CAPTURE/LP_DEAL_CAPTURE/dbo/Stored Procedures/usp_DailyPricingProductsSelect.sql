/*******************************************************************************
 * usp_DailyPricingProductsSelect
 * Gets products for specified parameters
 *
 * History
 *******************************************************************************
 * 7/22/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 9/9/10 Updated: To accomodate "Hybrid" ChannelTypes
 *******************************************************************************
 * Updated: 9/21/2010
 * Migrated table product_transition from [Workspace] to [LibertyPower]
 *******************************************************************************
 * Updated: 10/13/2010
 * By: Eric Hernandez, ticket 18936
 * removed the term filter which was causing problems with supersavers.
 *******************************************************************************
 * Updated: 10/18/2010
 * By: Isabelle Tamanini, ticket 18936
 * Usp changed so that it takes all available products for the given parameters,
 * independently of the existent rates
 *******************************************************************************
*/
-- EXEC lp_deal_capture..usp_DailyPricingProductsSelect @Username = 'libertypower\e3hernandez', @UtilityCode = 'CONED', @ShowActiveOnly = NULL
CREATE PROCEDURE [dbo].[usp_DailyPricingProductsSelect]
(		@Username				nchar(100),
		@ContractNumber			varchar(50) = '',
		@UtilityCode			char(15),
		@ChannelGroupID			int = 0,
		@ChannelTypeID			int = 0,
		@ProductCrossPriceSetID	int = 0,
		@ShowActiveOnly		tinyint = 1,
		@ShowSpecificInactiveValue varchar(50) = NULL
)
AS

EXEC lp_common.dbo.usp_ProductSelect 
  @Username = @Username
, @UtilityCode = @UtilityCode
, @ShowActiveOnly = @ShowActiveOnly
, @ShowSpecificInactiveValue = @ShowSpecificInactiveValue
, @HideDefault = 1
		

/*
	    SET NOCOUNT ON;
	
		DECLARE @UtilityID			int,
				@SalesChannelRole	varchar(50),
				@SalesChannelPrefix	varchar(100)
				
		SELECT	@SalesChannelPrefix= sales_channel_prefix  FROM lp_common..common_config WITH (NOLOCK)  
		SELECT	@SalesChannelRole = REPLACE(@Username , 'libertypower\', @SalesChannelPrefix) 			
					
		SELECT	@UtilityID	= ID
		FROM	LibertyPower..Utility WITH (NOLOCK)
		WHERE	UtilityCode	= @UtilityCode	
	
		CREATE TABLE	#ActivePrices (MarketID int, UtilityID int, ProductTypeID int, SegmentID int, 
						ZoneID int, ServiceClassID int, ChannelTypeID int, Term int)
		CREATE TABLE	#ProductRateIds (ProductID varchar(50), RateID int)
		CREATE TABLE	#ProductRates (ProductID varchar(50), MarketCode varchar(50), ProductCategory varchar(50), ProductDescription varchar(50), AccountTypeID int)
		
	---------- 	Active Prices  --------------------------------------------------------------------------------------------	
		INSERT	INTO #ActivePrices
		SELECT	DISTINCT pc.MarketID, pc.UtilityID, pc. ProductTypeID, pc.SegmentID, pc.ZoneID, 
				pc.ServiceClassID, pc.ChannelTypeID, oa.Term
		FROM	LibertyPower..ProductConfiguration pc WITH (NOLOCK)
				INNER JOIN LibertyPower..OfferActivation oa WITH (NOLOCK) ON pc.ProductConfigurationID = oa.ProductConfigurationID
				INNER JOIN LibertyPower..ProductCrossPrice pcp WITH (NOLOCK) 
					ON	pcp.MarketID			= pc.MarketID 
					AND	pcp.UtilityID			= pc.UtilityID
					AND	pcp.ProductTypeID		= pc.ProductTypeID
					AND	pcp.SegmentID			= pc.SegmentID	
					AND	pcp.ZoneID				= pc.ZoneID
					AND	pcp.ServiceClassID		= pc.ServiceClassID	
					AND	pcp.ChannelTypeID		= pc.ChannelTypeID
		WHERE	oa.IsActive					= 1	
		AND		pc.UtilityID				= @UtilityID
		AND		pcp.ProductCrossPriceSetID	= @ProductCrossPriceSetID
		AND		pcp.ChannelGroupID			= @ChannelGroupID
	-->	AND		pcp.ChannelTypeID			= @ChannelTypeID
		AND		(
					pcp.ChannelTypeID			= @ChannelTypeID								 -- Type is equal to  Channel's type.
					OR (@ChannelTypeID = 4 and (pcp.ChannelTypeID = 1 OR pcp.ChannelTypeID = 2)) -- If Type is Hybrid (id=4) then get abc and telesales.
				)
		
	---------- 	Product Rate IDs  -----------------------------------------------------------------------------------------	
		INSERT	INTO #ProductRateIds
		SELECT	DISTINCT product_id, rate_id
		FROM	#ActivePrices p WITH (NOLOCK)
				INNER JOIN LibertyPower.dbo.product_transition t WITH (NOLOCK)
					ON	p.MarketID			= t.MarketID
					AND	p.UtilityID			= t.UtilityID
					AND	p.ProductTypeID		= t.ProductTypeID
					AND	p.SegmentID			= t.AccountTypeID
					AND	p.ZoneID			= t.ZoneID
					AND	p.ServiceClassID	= t.ServiceClassID
					AND	p.ChannelTypeID		= t.ChannelTypeID
					--AND	p.Term				= t.Term	-- Ticket 18936	
				
	---------- 	Product Rates  --------------------------------------------------------------------------------------------				
		INSERT	INTO #ProductRates
		SELECT	DISTINCT p.product_id, u.retail_mkt_id, p.product_category, p.product_descp, account_type_id
		FROM	lp_common..common_product p WITH (NOLOCK)
				INNER JOIN lp_common..common_product_rate r WITH (NOLOCK) ON p.product_id = r.product_id
				INNER JOIN lp_common..common_utility u WITH (NOLOCK) ON p.utility_id = u.utility_id
				INNER JOIN #ProductRateIds ap ON p.product_id = ap.ProductID
		WHERE	r.inactive_ind				= 0
		AND		p.IsCustom					= 0
		
		-- custom prices
		INSERT	INTO #ProductRates
		SELECT	DISTINCT  pr.product_id, u.retail_mkt_id, p.product_category, p.product_descp, p.account_type_id 
		FROM	lp_common..common_product_rate pr with (NOLOCK INDEX = common_product_rate_idx)
				INNER JOIN lp_common..common_product p WITH (NOLOCK) ON pr.product_id = p.product_id 
				INNER JOIN lp_common..common_utility u WITH (NOLOCK) ON p.utility_id = u.utility_id
				INNER JOIN lp_deal_capture..deal_pricing_detail dpd WITH (NOLOCK) ON dpd.product_id = pr.product_id AND dpd.rate_id = pr.rate_id 
				INNER JOIN lp_deal_capture..deal_pricing dp WITH (NOLOCK) ON dp.deal_pricing_id = dpd.deal_pricing_id
	
	    WHERE	pr.eff_date		<= convert(char(08), getdate(), 112) 
	    AND		p.utility_id	= @UtilityCode
		AND		pr.due_date		>= convert(char(08), getdate(), 112) 
		AND		pr.inactive_ind	= 0
		AND		dp.date_expired	>= convert(char(08), getdate(), 112)  -- custom rate has not expired 
		AND		(	-- user has access to custom rate	
					dp.sales_channel_role		= @Username 
					OR dp.sales_channel_role	= @SalesChannelRole 
					OR dp.sales_channel_role IN 
					(	SELECT	b.RoleName 
						FROM	lp_portal..UserRoles a WITH (NOLOCK)
								JOIN lp_portal..Roles b WITH (NOLOCK) ON a.RoleID = b.RoleID  
								JOIN lp_portal..Users u with (NOLOCK INDEX = IX_Users)  ON a.userID = u.UserID
						WHERE	Username	= @Username
						AND		b.RoleName	LIKE LTRIM(RTRIM(@SalesChannelPrefix)) + '%' 
					)
					 OR lp_common.dbo.ufn_is_liberty_employee(@Username) = 1 
				 ) 
			-- rate has not already been submitted or exists on the current contract
			AND (	dpd.rate_submit_ind = 0 
					OR  EXISTS (	SELECT	contract_nbr 
									FROM	deal_contract WITH (NOLOCK) 
									WHERE	contract_nbr	= @ContractNumber 
									AND		@ContractNumber	<> '' 
									AND		product_id		= dpd.product_id 
									AND		rate_id			= dpd.rate_id 
									UNION 
									SELECT	contract_nbr 
									FROM	deal_contract_account WITH (NOLOCK) 
									WHERE	contract_nbr	= @ContractNumber 
									AND		@ContractNumber	<> '' 
									AND		product_id		= dpd.product_id 
									AND		rate_id			= dpd.rate_id
								) 
				) 	
		
	
		SELECT	*
		FROM	#ProductRates
	
		DROP TABLE	#ActivePrices
		DROP TABLE	#ProductRateIds
		DROP TABLE	#ProductRates
	
	    SET NOCOUNT OFF;
*/




