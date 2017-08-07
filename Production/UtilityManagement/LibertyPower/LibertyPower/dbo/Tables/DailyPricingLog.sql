CREATE TABLE [dbo].[DailyPricingLog] (
    [DailyPricingLogID]  INT            IDENTITY (1, 1) NOT NULL,
    [MessageType]        INT            NOT NULL,
    [DailyPricingModule] INT            NOT NULL,
    [Message]            VARCHAR (8000) NULL,
    [DateCreated]        DATETIME       NOT NULL,
    [StackTrace]         VARCHAR (8000) NULL,
    CONSTRAINT [PK_DailyPricingLog] PRIMARY KEY CLUSTERED ([DailyPricingLogID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_DailyPricingLog_DateCreated]
    ON [dbo].[DailyPricingLog]([DateCreated] DESC);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingLog';

