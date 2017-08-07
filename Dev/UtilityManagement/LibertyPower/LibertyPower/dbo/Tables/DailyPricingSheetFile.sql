CREATE TABLE [dbo].[DailyPricingSheetFile] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [FileGuid]         VARCHAR (100) NULL,
    [File]             VARCHAR (200) NULL,
    [OriginalFileName] VARCHAR (200) NULL,
    [SalesChannelID]   INT           NULL,
    [FileDate]         DATETIME      NULL,
    CONSTRAINT [PK_DailyPricingSheetFile] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingSheetFile';

