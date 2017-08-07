

/*******************************************************************************
 * usp_DailyPricingLogSelect_Event
 * Gets event records
 *
 * History
 *******************************************************************************
 * 4/12/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingLogSelect_Event]  

AS

	SELECT	ID, [Message], DateCreated
	FROM	LibertyPower..DailyPricingLog_Event WITH (NOLOCK)	
	ORDER BY ID DESC                                                                                                                               
	
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingLogSelect_Event';

