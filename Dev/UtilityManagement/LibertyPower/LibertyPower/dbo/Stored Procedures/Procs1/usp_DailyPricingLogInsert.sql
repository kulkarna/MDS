
/*******************************************************************************
 * usp_DailyPricingLogInsert
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_DailyPricingLogInsert]  
	@MessageType		int,
	@DailyPricingModule	int,
	@Message			varchar(8000),
	@StackTrace			varchar(8000) = NULL	
AS
DECLARE @DailyPricingLogID int


	INSERT INTO [LibertyPower].[dbo].[DailyPricingLog]
           ([MessageType]
           ,[DailyPricingModule]
           ,[Message]
           ,[DateCreated]
           ,[StackTrace])
    VALUES
           (@MessageType
           ,@DailyPricingModule
           ,@Message
           ,getDate()
           ,@StackTrace)


	SET @DailyPricingLogID = @@Identity

	SELECT [DailyPricingLogID]
      ,[MessageType]
      ,[DailyPricingModule]
      ,[Message]
      ,[DateCreated]
      ,[StackTrace]
	FROM [LibertyPower].[dbo].[DailyPricingLog]
	WHERE [DailyPricingLogID] = @DailyPricingLogID                                                                                                                                
	
-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingLogInsert';

