CREATE TABLE [dbo].[DailyPricingSheetFileQueue] (
    [ID]                      INT      IDENTITY (1, 1) NOT NULL,
    [DailyPricingSheetFileID] INT      NULL,
    [FileSent]                TINYINT  CONSTRAINT [DF_DailyPricingSheetFileQueue_FileSent] DEFAULT ((0)) NOT NULL,
    [DateSent]                DATETIME NULL,
    CONSTRAINT [FK_DailyPricingSheetFileQueue_DailyPricingSheetFile] FOREIGN KEY ([DailyPricingSheetFileID]) REFERENCES [dbo].[DailyPricingSheetFile] ([ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingSheetFileQueue';

