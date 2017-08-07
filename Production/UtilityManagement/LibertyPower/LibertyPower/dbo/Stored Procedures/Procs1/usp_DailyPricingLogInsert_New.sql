

/*******************************************************************************
 * usp_DailyPricingLogInsert_New
 *
 * History
 *******************************************************************************
 * 3/31/2011 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyPricingLogInsert_New]  
	@MessageType		int,
	@DailyPricingModule	int,
	@Message			varchar(8000),
	@StackTrace			varchar(8000) = NULL,
	@CreatedBy			int	
AS
DECLARE @DailyPricingLogID int


	INSERT INTO [LibertyPower].[dbo].[DailyPricingLog_New]
           ([MessageType]
           ,[DailyPricingModule]
           ,[Message]
           ,[DateCreated]
           ,[StackTrace]
           ,[CreatedBy])
    VALUES
           (@MessageType
           ,@DailyPricingModule
           ,@Message
           ,getDate()
           ,@StackTrace
           ,@CreatedBy)


	SET @DailyPricingLogID = SCOPE_IDENTITY()

	SELECT l.[DailyPricingLogID]
      ,l.[MessageType]
      ,l.[DailyPricingModule]
      ,l.[Message]
      ,l.[DateCreated]
      ,l.[StackTrace]
      ,l.[CreatedBy]
      ,ISNULL(REPLACE(u.UserName, 'libertypower\', ''), 'System') AS UserName
	FROM [LibertyPower].[dbo].[DailyPricingLog_New] l WITH (NOLOCK)
		LEFT JOIN LibertyPower..[User] u WITH (NOLOCK)
		ON l.CreatedBy	= u.UserID	
	WHERE l.[DailyPricingLogID] = @DailyPricingLogID                                                                                                                                
	
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingLogInsert_New';

