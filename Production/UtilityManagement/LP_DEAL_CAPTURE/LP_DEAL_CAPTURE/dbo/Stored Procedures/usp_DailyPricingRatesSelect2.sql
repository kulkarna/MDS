-- Stored Procedure

/*******************************************************************************
 * usp_DailyPricingRatesSelect
 * Gets rates for specified parameters
 *
 * History
 *******************************************************************************
 * 7/22/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 9/9/10 Updated: To accommodate "Hybrid" ChannelTypes
 *******************************************************************************
 * Updated: 9/21/2010
 * Migrated table product_transition from [Workspace] to [LibertyPower]
 *******************************************************************************
 *******************************************************************************
 * Updated: 10/26/2010
 * Ticket 19192
 * Comments this condition:
 * --	AND		pr.due_date		>= CONVERT(char(08), GETDATE(), 112) -- Comments ticket 19192
 *******************************************************************************
 * Updated: 11/1/2010
 * Ticket 19091
 * Get Channel group from SalesChannelChannelGroup table.
 *******************************************************************************
 * Updated: 06/24/2011
 * Ticket 23765 
 * Added logic to filter for the channel group id only if the rate is in the new format.
 *******************************************************************************
  *******************************************************************************
 * Updated: 07/25/2011
 * Ticket 24141 
 * Changed custom product rate value to deal_pricing_detail ContractRate.
 *******************************************************************************/

--exec usp_DailyPricingRatesSelect  'libertypower\\aea', '789456123', 'TXNMP', 'XNMP_SS_NOMC_ABC', '25', 'NONE',0,0,'5/02/2011', 0,'NORTH','NONE','4/6/2011'

CREATE PROCEDURE [dbo].[usp_DailyPricingRatesSelect2]
	@Username					nchar(100),
	@ContractNumber				varchar(50),
	@UtilityCode				varchar(50),
	@p_product_id				char(20),
	@p_term_months				int				= NULL,  
	@p_union_select				varchar(15)		= ' ',
	@p_show_active_flag			tinyint			= 0,
	@p_deal_price_id			int				= 0,
	@p_contract_eff_start_date	datetime		= NULL,
	@p_show_startdate_flag		tinyint			= 0,
	@p_zone						varchar(20)		= NULL,
	@p_service_class			varchar(20)		= 'NONE',
	@p_contract_date			datetime,			/* Ticket 17543*/
	@p_verbose_description		int = 0
	
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	-- get the zone id
	DECLARE	@ZoneID as int
	DECLARE	@UtilityID as int
	
	if @p_zone is not NULL
	BEGIN
		SET		@UtilityID = (SELECT ID FROM LibertyPower..Utility WHERE UtilityCode = @UtilityCode )
		SET		@ZoneID = (SELECT top 1 ZoneID FROM LibertyPower..ZoneMapping WHERE UtilityID = @UtilityID AND [Text] = @p_zone)
	END
	
    DECLARE @FirstDayOfMonth DATETIME
    SET @FirstDayOfMonth = dateadd(mm,datediff(mm,0,@p_contract_eff_start_date),0)
        
    -- Retrieve list of possible rates to show
	SELECT	DISTINCT  pr.product_id as ProductID
		, pr.rate_id as return_value
		, prh.rate
		--, LTRIM(RTRIM(pr.rate_descp)) as option_id
		, option_id = 
			CASE WHEN @p_verbose_description = 0
				 THEN LTRIM(RTRIM(pr.rate_descp))
				 ELSE pr.rate_descp + ' ' + DATENAME(month,prh.contract_eff_start_date) + ' ' + DATENAME(year,prh.contract_eff_start_date) + ' Start'
				 END
		, p.IsCustom
	INTO #ProductRates
	FROM lp_common..common_product_rate pr (nolock)
	JOIN lp_common..product_rate_history prh (nolock) on pr.product_id = prh.product_id and pr.rate_id = prh.rate_id
	JOIN lp_common..common_product p (nolock) ON pr.product_id = p.product_id 
	WHERE 1=1
	AND	prh.Inactive_ind = 0
	AND	prh.product_id = @p_product_id
	AND (p.iscustom = 1
		OR prh.eff_date = @p_contract_date) -- For custom products, contract date matching is not enforced.
    AND (p.iscustom = 1 -- For custom products, start month matching is not enforced.
		OR @p_contract_eff_start_date is null 
		OR prh.contract_eff_start_date = @FirstDayOfMonth)
    AND (@p_term_months is null OR prh.term_months = @p_term_months)
    AND	(@ZoneID is null OR (pr.zone_id = @ZoneID) OR p.iscustom = 1)
    
    SELECT COUNT(*) FROM #ProductRates
    
    -- Restrict results by user.  The logic is different for Custom vs Daily rates.
    IF EXISTS (SELECT * FROM lp_common..common_product WHERE IsCustom = 1 and product_id = @p_product_id)
    BEGIN
		print '1'
	    -- If its custom, only show the rates which should be shown to the specific user.
		SELECT pr.ProductID
			,  pr.return_value
			,  dpd.ContractRate AS rate
			,  pr.option_id
			,  pr.IsCustom
		FROM #ProductRates pr
		JOIN lp_deal_capture.dbo.deal_pricing_detail dpd (nolock) on pr.ProductID = dpd.product_id and pr.return_value = dpd.rate_id 
		JOIN lp_deal_capture.dbo.deal_pricing dp (nolock) on dpd.deal_pricing_id = dp.deal_pricing_id
		JOIN dbo.ufn_custom_rates_sel(@Username) c ON pr.ProductID = c.product_id and pr.return_value = c.rate_id
		WHERE dp.date_expired >= @p_contract_date 
	END
	ELSE
    BEGIN
		print '2'
		-- This will determine the Channel Group that the Sales Channel was in based on the Contract Date /* Ticket 19091  */
		DECLARE @ChannelGroupID INT
		SELECT @ChannelGroupID = sccg.ChannelGroupID
		FROM LibertyPower..SalesChannel sc (NOLOCK)
		JOIN LibertyPower.dbo.SalesChannelChannelGroup sccg (NOLOCK)
			ON sc.ChannelID = sccg.ChannelID AND sccg.EffectiveDate <= @p_contract_date	AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) > @p_contract_date
		WHERE	ChannelName = REPLACE(@Username , 'libertypower\', '')
		
		print @ChannelGroupID 
		
		-- The daily rates follow a naming convention which starts with the group ID.
		SELECT *
		FROM #ProductRates pr
		WHERE @ChannelGroupID = LEFT(pr.return_value, 3) % 100
		   OR LEN(pr.return_value) <> 9
	END
    
    
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power