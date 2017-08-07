CREATE TABLE [dbo].[DailyPricingLog_Event] (
    [ID]          INT            IDENTITY (1, 1) NOT NULL,
    [Message]     VARCHAR (8000) NULL,
    [DateCreated] DATETIME       NOT NULL,
    CONSTRAINT [PK_DailyPricingLog_Event] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingLog_Event';

