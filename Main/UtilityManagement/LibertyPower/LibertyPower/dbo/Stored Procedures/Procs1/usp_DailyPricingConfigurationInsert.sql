
/*******************************************************************************
 * usp_DailyPricingConfigurationInsert
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricingConfigurationInsert]  
	@AutoGeneratePrices			 	bit,
	@AutoGeneratePriceSheets		bit,
	@CreatedBy						int	
AS
DECLARE @DailyPricingConfigurationID int


	INSERT INTO [LibertyPower].[dbo].[DailyPricingConfiguration]
           ([AutoGeneratePrices]
			  ,[AutoGeneratePriceSheets]
			  ,[CreatedBy]
			  ,[DateCreated])
    VALUES
           (@AutoGeneratePrices		
           ,@AutoGeneratePriceSheets
           ,@CreatedBy				
           ,getDate())


	SET @DailyPricingConfigurationID = @@Identity

	SELECT 
		[DailyPricingConfigurationID]
		,[AutoGeneratePrices]
		,[AutoGeneratePriceSheets]
		,[CreatedBy]
		,[DateCreated]
	FROM 
		[LibertyPower].[dbo].[DailyPricingConfiguration] (NOLOCK)
	WHERE 
		[DailyPricingConfigurationID] = @DailyPricingConfigurationID                                                                                                                                
	
-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingConfigurationInsert';

