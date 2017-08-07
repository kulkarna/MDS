
/*******************************************************************************
 * usp_DailyPricingConfigurationGetCurrent
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricingConfigurationGetCurrent]  

AS
DECLARE @DailyPricingConfigurationID int




	SELECT top 1 [DailyPricingConfigurationID]
      ,[AutoGeneratePrices]
      ,[AutoGeneratePriceSheets]
      ,[CreatedBy]
      ,[DateCreated]
	FROM [LibertyPower].[dbo].[DailyPricingConfiguration] (NOLOCK)
	Order By [DateCreated] desc                                                                                                                              
	
-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingConfigurationGetCurrent';

