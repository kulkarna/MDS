
/*******************************************************************************
 * usp_DailyPricingFileTypeSalesChannelInsert
 *
 ******************************************************************************/
Create PROCEDURE [dbo].[usp_DailyPricingFileTypeSalesChannelInsert] 
	@ChannelID				int,
	@DailyPricingFileTypeID int,
	@CreatedBy				int
As

Declare @ID int

SELECT @ID = [DailyPricingFileTypeSalesChannelID]
FROM [LibertyPower].[dbo].[DailyPricingFileTypeSalesChannel] 
WHERE [DailyPricingFileTypeID] = @DailyPricingFileTypeID
	AND [ChannelID] = @ChannelID

IF @ID is null
BEGIN
	Insert Into [LibertyPower].[dbo].[DailyPricingFileTypeSalesChannel]
		([DailyPricingFileTypeID]
		  ,[ChannelID]
		  ,[DateCreated]
		  ,[CreatedBy]
		  )
		 VALUES
		 (@DailyPricingFileTypeID 
		  ,	@ChannelID							
		  ,getDate()
		  ,@CreatedBy
		  )
	Set @ID = @@IDENTITY     
END

SELECT FT.[DailyPricingFileTypeID]
      ,FT.[FileType]
      ,FT.[DateCreated]
      ,FT.[CreatedBy]
FROM [LibertyPower].[dbo].[DailyPricingFileType] FT
JOIN [LibertyPower].[dbo].[DailyPricingFileTypeSalesChannel] FTSC on FTSC.[DailyPricingFileTypeID] = FT.[DailyPricingFileTypeID]
Where [DailyPricingFileTypeSalesChannelID] = @ID

-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingFileTypeSalesChannelInsert';

