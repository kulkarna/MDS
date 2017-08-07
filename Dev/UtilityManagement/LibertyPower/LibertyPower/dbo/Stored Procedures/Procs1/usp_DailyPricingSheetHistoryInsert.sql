/*******************************************************************************
 * usp_DailyPricingSheetHistoryInsert
 * Inserts the pricing sheet file generation history row
 *
 * History
 *******************************************************************************
 * 7/21/2010 - George Worthington
 * Created.
 *******************************************************************************
 */
Create PROCEDURE [dbo].[usp_DailyPricingSheetHistoryInsert]
	@Count			int,
	@GeneratedBy	int
AS

   INSERT INTO Libertypower..DailyPricingSheetFileGenerationHistory
   (FileCount, DateGenerated, GeneratedBy)
		Values
   (@Count, getdate(), @GeneratedBy)
   
   SELECT [DailyPricingSheetFileGenerationHistoryID]
      ,[FileCount]
      ,[DateGenerated]
      ,[GeneratedBy]
   FROM [LibertyPower].[dbo].[DailyPricingSheetFileGenerationHistory]
   WHERE [DailyPricingSheetFileGenerationHistoryID] = @@IDENTITY

-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DailyPricingSheetHistoryInsert';

