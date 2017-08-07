CREATE TABLE [dbo].[DailyPricingSalesChannelProcessedForSheetsTemp] (
    [ID]             INT      IDENTITY (1, 1) NOT NULL,
    [SalesChannelID] INT      NULL,
    [DateCreated]    DATETIME NULL,
    [CreatedBy]      INT      NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingSalesChannelProcessedForSheetsTemp';

