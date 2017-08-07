
/*******************************************************************************
 * usp_DailyPricingMarketsSelect
 * Select markets for daily pricing
 *
 * History
 *******************************************************************************
 * 7/30/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingMarketsSelect]

AS
BEGIN
    SET NOCOUNT ON;
    
		SELECT	m.ID, m.retail_mkt_id, (m.retail_mkt_descp + ' (' + RTRIM(m.wholesale_mkt_id) + ')') AS retail_mkt_descp , m.wholesale_mkt_id, 
				m.puc_certification_number, m.date_created, m.username, 
				m.inactive_ind, m.active_date, m.chgstamp, m.transfer_ownership_enabled
		FROM	lp_common..common_retail_market m (NOLOCK)
				INNER JOIN lp_common..common_wholesale_market w (NOLOCK) ON m.wholesale_mkt_id = w.wholesale_mkt_id
				where m.inactive_ind = 0
		
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingMarketsSelect';

