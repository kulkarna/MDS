CREATE TABLE [dbo].[DailyPricingSheetFileGenerationHistory] (
    [DailyPricingSheetFileGenerationHistoryID] INT      IDENTITY (1, 1) NOT NULL,
    [FileCount]                                INT      NOT NULL,
    [DateGenerated]                            DATETIME NOT NULL,
    [GeneratedBy]                              INT      NOT NULL,
    CONSTRAINT [PK_DailyPricingSheetFileGenerationHistory] PRIMARY KEY CLUSTERED ([DailyPricingSheetFileGenerationHistoryID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingSheetFileGenerationHistory';

