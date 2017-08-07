CREATE TABLE [dbo].[DailyPricingLog_New] (
    [DailyPricingLogID]  INT            IDENTITY (1, 1) NOT NULL,
    [MessageType]        INT            NOT NULL,
    [DailyPricingModule] INT            NOT NULL,
    [Message]            VARCHAR (8000) NULL,
    [DateCreated]        DATETIME       NOT NULL,
    [StackTrace]         VARCHAR (8000) NULL,
    [CreatedBy]          INT            NULL,
    CONSTRAINT [PK_DailyPricingLog_New] PRIMARY KEY CLUSTERED ([DailyPricingLogID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ndx_DateCreated]
    ON [dbo].[DailyPricingLog_New]([DateCreated] ASC);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingLog_New';

