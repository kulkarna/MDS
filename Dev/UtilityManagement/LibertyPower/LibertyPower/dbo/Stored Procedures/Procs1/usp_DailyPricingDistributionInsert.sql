
/*******************************************************************************
 * usp_DailyPricingDistributionInsert
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricingDistributionInsert] 
	@ChannelID				int,
	@Email					varchar(100),
	@CreatedBy				int
As

Declare @ID int

SELECT @ID = [DailyPricingDistributionID]
FROM [LibertyPower].[dbo].[DailyPricingDistribution] (NOLOCK)
WHERE [Email] = @Email
	AND [ChannelID] = @ChannelID

IF @ID is null
BEGIN
	Insert Into [LibertyPower].[dbo].[DailyPricingDistribution]
		([ChannelID]
		  ,[Email]
		  ,[DateCreated]
		  ,[CreatedBy]
		  )
		 VALUES
		 (@ChannelID				
		  ,@Email 				
		  ,getDate()
		  ,@CreatedBy
		  )
	Set @ID = @@IDENTITY     
END

SELECT [DailyPricingDistributionID]
      ,[ChannelID]
      ,[Email]
      ,[DateCreated]
      ,[CreatedBy]
FROM [LibertyPower].[dbo].[DailyPricingDistribution] (NOLOCK)
Where [DailyPricingDistributionID] = @ID

-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingDistributionInsert';

