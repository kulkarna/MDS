
-- =============================================
-- Created by: Isabelle Tamanini 01/04/2012
-- Bug 3566
-- Gets the default rates for specified parameters
-- ============================================= 
--exec usp_DailyPricingDefaultRatesSelect 'libertypower\outboundtelesales', 'CONED', 'CONED_IP', 24, '20120201', '20120104', 0
CREATE PROCEDURE [dbo].[usp_DailyPricingDefaultRatesSelect]
	@Username					nchar(100),
	@UtilityCode				varchar(50),
	@p_product_id				char(20),
	@p_term_months				int				= NULL,
	@p_contract_eff_start_date	datetime		= NULL,
	@p_contract_date			datetime,		
	@p_verbose_description		int = 0
	
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE	@UtilityID as int
	SET @UtilityID = (SELECT ID FROM LibertyPower..Utility WHERE UtilityCode = @UtilityCode )
	
    DECLARE @FirstDayOfMonth DATETIME
    SET @FirstDayOfMonth = dateadd(mm,datediff(mm,0,@p_contract_eff_start_date),0)
      
    -- Retrieve list of possible rates to show
	SELECT	DISTINCT  pr.product_id as ProductID
		, pr.rate_id as return_value
		, prh.rate
		, prh.term_months
		, option_id = 
			CASE WHEN @p_verbose_description = 0
				 THEN convert(varchar(10),prh.rate) + ' for ' + convert(char(2),prh.term_months) + ' Months'
				 ELSE pr.rate_descp + ' ' + DATENAME(month,prh.contract_eff_start_date) + ' ' + DATENAME(year,prh.contract_eff_start_date) + ' Start'
				 END
	INTO #ProductRates
	FROM lp_common..common_product_rate pr (nolock)
	JOIN lp_common..product_rate_history prh (nolock) on pr.product_id = prh.product_id and pr.rate_id = prh.rate_id
	JOIN lp_common..common_product p (nolock) ON pr.product_id = p.product_id 
	WHERE prh.Inactive_ind = 0
	  AND prh.product_id = @p_product_id
	  AND prh.eff_date = @p_contract_date
      AND (@p_contract_eff_start_date is null 
		   OR prh.contract_eff_start_date = @FirstDayOfMonth)
      AND (@p_term_months is null OR prh.term_months = @p_term_months)
    
    
	-- This will determine the Channel Group that the Sales Channel was in based on the Contract Date /* Ticket 19091  */
	DECLARE @ChannelGroupID INT
	SELECT @ChannelGroupID = sccg.ChannelGroupID
	FROM LibertyPower..SalesChannel sc (NOLOCK)
	JOIN LibertyPower.dbo.SalesChannelChannelGroup sccg (NOLOCK)
		ON sc.ChannelID = sccg.ChannelID AND sccg.EffectiveDate <= @p_contract_date	AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) > @p_contract_date
	WHERE	ChannelName = REPLACE(@Username , 'libertypower\', '')

	-- The daily rates follow a naming convention which starts with the group ID.
	SELECT MAX(rate) as Rate, 
		   ProductID, 
		   term_months
	INTO #ProductRatesSalesChannel
	FROM #ProductRates pr
	WHERE @ChannelGroupID = LEFT(pr.return_value, 3) % 100
	   OR LEN(pr.return_value) <> 9
	GROUP BY ProductID, term_months
	
	SELECT pr.rate, 
		   pr.return_value,
		   pr.ProductID, 
		   pr.term_months,
		   pr.option_id
	FROM #ProductRates pr
	JOIN #ProductRatesSalesChannel prsc  ON prsc.rate = pr.rate 
										and prsc.term_months = pr.term_months
										and prsc.ProductID = pr.ProductID 
	WHERE @ChannelGroupID = LEFT(pr.return_value, 3) % 100
	   OR LEN(pr.return_value) <> 9
    
    SET NOCOUNT OFF;
END