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
   *******************************************************************************
 * Updated: 05/30/2012
 * Ticket 1-16339906 
 * usp_DailyPricingRatesSelect needs performance 
 *********************************************************************************


exec usp_DailyPricingRatesSelect  @Username=N'libertypower\jmunoz'
					,@ContractNumber=N'2012-0164272'
					,@UtilityCode=N'ONCOR'
					,@p_product_id=N'ONCOR_IP_NOMC_ABC'
					,@p_contract_date=N'2012-04-17 00:00:00.000'

exec usp_DailyPricingRatesSelect_jmunoz  @Username=N'libertypower\jmunoz'
					,@ContractNumber=N'2012-0164272'
					,@UtilityCode=N'ONCOR'
					,@p_product_id=N'ONCOR_IP_NOMC_ABC'
					,@p_contract_date=N'2012-04-17 00:00:00.000'
					
exec usp_DailyPricingRatesSelect @Username=N'libertypower\EG1',@ContractNumber=N'2996394',@UtilityCode=N'CL&P',@p_product_id=N'CLP_IP_RES',@p_term_months=N'12',@p_union_select=N'NONE',@p_contract_eff_start_date='Jun  1 2012 12:00:00:000AM',@p_contract_date='May 21 2012 12:00:00:000AM'					
exec usp_DailyPricingRatesSelect_JMUNOZ @Username=N'libertypower\EG1',@ContractNumber=N'2996394',@UtilityCode=N'CL&P',@p_product_id=N'CLP_IP_RES',@p_term_months=N'12',@p_union_select=N'NONE',@p_contract_eff_start_date='Jun  1 2012 12:00:00:000AM',@p_contract_date='May 21 2012 12:00:00:000AM'					
					
--exec usp_DailyPricingRatesSelect  'libertypower\jmunoz', '2012-0164272', 'ONCOR', 'ONCOR_IP_NOMC_ABC', '25', 'NONE',0,0,'5/02/2011', 0,'NORTH','NONE','4/6/2011'
 */
 
CREATE PROCEDURE [dbo].[usp_DailyPricingRatesSelect_temp]
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

	/* Ticket 1-16339906 BEGIN 001 */
	DECLARE @ProductRates TABLE (ProductID			CHAR(20)
								,return_value		INT
								,rate				FLOAT
								,option_id			VARCHAR(280)
								,IsCustom			TINYINT)
								
	DECLARE @QuerySelect	VARCHAR(MAX)
	/* Ticket 1-16339906 END  001 */
	
	-- get the zone id
	DECLARE	@ZoneID as int
	DECLARE	@UtilityID as int
	
	if @p_zone is not NULL
	BEGIN
		SET		@UtilityID = (SELECT ID FROM LibertyPower..Utility WITH (NOLOCK) WHERE UtilityCode = @UtilityCode )
		SET		@ZoneID = (SELECT top 1 ZoneID FROM LibertyPower..ZoneMapping WITH (NOLOCK) WHERE UtilityID = @UtilityID AND [Text] = @p_zone)
	END
	
    DECLARE @FirstDayOfMonth DATETIME
    SET @FirstDayOfMonth = dateadd(mm,datediff(mm,0,@p_contract_eff_start_date),0)
    
    -- Retrieve list of possible rates to show
	/* ORIGINAL CODE 
		COMMENTED WITH TICKET 1-16339906
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
	FROM lp_common..common_product_rate pr WITH (NOLOCK)
	JOIN lp_common..product_rate_history prh WITH (NOLOCK) 
	on pr.product_id			= prh.product_id 
	and pr.rate_id				= prh.rate_id
	JOIN lp_common..common_product p WITH (NOLOCK) 
	ON pr.product_id			= p.product_id 
	WHERE prh.Inactive_ind		= 0
	AND	prh.product_id			= @p_product_id
	AND (p.iscustom				= 1
		OR prh.eff_date			= @p_contract_date) -- For custom products, contract date matching is not enforced.
    AND (p.iscustom				= 1 -- For custom products, start month matching is not enforced.
		OR @p_contract_eff_start_date is null 
		OR prh.contract_eff_start_date = @FirstDayOfMonth)
    AND (@p_term_months is null OR prh.term_months = @p_term_months)
    AND	(@ZoneID is null OR (pr.zone_id = @ZoneID) OR p.iscustom = 1)
	
	*/        
	/* Ticket 1-16339906 BEGIN 002 */
    SET @QuerySelect = 'SELECT	DISTINCT  pr.product_id as ProductID'
					+ ', pr.rate_id as return_value'
					+ ', prh.rate'
					+ ', option_id = '
					+ ' CASE WHEN ' + LTRIM(RTRIM(STR(@p_verbose_description))) + ' = 0'
					+ ' THEN LTRIM(RTRIM(pr.rate_descp))'
					+ ' ELSE pr.rate_descp + '' '' + DATENAME(month,prh.contract_eff_start_date) + '' '' + DATENAME(year,prh.contract_eff_start_date) + '' Start'''
					+ ' END'
					+ ', p.IsCustom'
					+ ' FROM lp_common..common_product_rate pr WITH (NOLOCK)'
					+ ' JOIN lp_common..product_rate_history prh WITH (NOLOCK)'
					+ ' on pr.product_id			= prh.product_id'
					+ ' and pr.rate_id				= prh.rate_id'
					+ ' JOIN lp_common..common_product p WITH (NOLOCK)'
					+ ' ON pr.product_id			= p.product_id'
					+ ' WHERE prh.Inactive_ind		= 0'
					+ ' AND	prh.product_id			= ''' + LTRIM(RTRIM(@p_product_id)) + ''''
					+ ' AND (p.iscustom				= 1	OR prh.eff_date			= ''' + CONVERT(VARCHAR(8),@p_contract_date,112) + ''')'
					
	IF NOT (@p_contract_eff_start_date IS NULL)
		SET @QuerySelect	= @QuerySelect
					+ ' AND (p.iscustom				= 1 OR prh.contract_eff_start_date = ''' + CONVERT(VARCHAR(8),@FirstDayOfMonth,112) + ''')'
					
	IF NOT (@p_term_months IS NULL)
		SET @QuerySelect	= @QuerySelect
					+ ' AND (prh.term_months		= ' + LTRIM(RTRIM(STR(@p_term_months))) + ')'
					
	IF NOT (@ZoneID IS NULL)
		SET @QuerySelect	= @QuerySelect
					+ ' AND	(pr.zone_id				= ''' + LTRIM(RTRIM(STR(@ZoneID))) + ''' OR p.iscustom = 1)'

	PRINT @QuerySelect

    INSERT INTO @ProductRates
    EXECUTE (@QuerySelect)
    /* Ticket 1-16339906 END 002 */

    -- Restrict results by user.  The logic is different for Custom vs Daily rates.
    IF EXISTS (SELECT 1 FROM lp_common..common_product WITH (NOLOCK) WHERE IsCustom = 1 and product_id = @p_product_id)
    BEGIN
	    -- If its custom, only show the rates which should be shown to the specific user.
		SELECT pr.ProductID
			,  pr.return_value
			,  dpd.ContractRate AS rate
			,  pr.option_id
			,  pr.IsCustom
		FROM @ProductRates pr
		JOIN lp_deal_capture.dbo.deal_pricing_detail dpd WITH (NOLOCK) on pr.ProductID = dpd.product_id and pr.return_value = dpd.rate_id 
		JOIN lp_deal_capture.dbo.deal_pricing dp WITH (NOLOCK) on dpd.deal_pricing_id = dp.deal_pricing_id
		JOIN dbo.ufn_custom_rates_sel(@Username) c ON pr.ProductID = c.product_id and pr.return_value = c.rate_id
		WHERE dp.date_expired >= @p_contract_date 
	END
	ELSE
    BEGIN
		-- This will determine the Channel Group that the Sales Channel was in based on the Contract Date /* Ticket 19091  */
		DECLARE @ChannelGroupID INT
		SELECT @ChannelGroupID = sccg.ChannelGroupID
		FROM LibertyPower..SalesChannel sc WITH (NOLOCK)
		JOIN LibertyPower.dbo.SalesChannelChannelGroup sccg WITH (NOLOCK)
			ON sc.ChannelID = sccg.ChannelID AND sccg.EffectiveDate <= @p_contract_date	AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) > @p_contract_date
		WHERE	ChannelName = REPLACE(@Username , 'libertypower\', '')

		-- The daily rates follow a naming convention which starts with the group ID.
		SELECT *
		FROM @ProductRates pr
		WHERE @ChannelGroupID = LEFT(pr.return_value, 3) % 100
		   OR LEN(pr.return_value) <> 9
	END
    
    
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power