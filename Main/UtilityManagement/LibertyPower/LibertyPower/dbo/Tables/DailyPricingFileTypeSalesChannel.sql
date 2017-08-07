CREATE TABLE [dbo].[DailyPricingFileTypeSalesChannel] (
    [DailyPricingFileTypeSalesChannelID] INT      IDENTITY (1, 1) NOT NULL,
    [DailyPricingFileTypeID]             INT      NOT NULL,
    [ChannelID]                          INT      NOT NULL,
    [DateCreated]                        DATETIME NOT NULL,
    [CreatedBy]                          INT      NOT NULL,
    CONSTRAINT [PK_DailyPricingFileTypeSalesChannel] PRIMARY KEY CLUSTERED ([DailyPricingFileTypeSalesChannelID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_DailyPricingFileTypeSalesChannel_DailyPricingFileType] FOREIGN KEY ([DailyPricingFileTypeID]) REFERENCES [dbo].[DailyPricingFileType] ([DailyPricingFileTypeID]),
    CONSTRAINT [FK_DailyPricingFileTypeSalesChannel_SalesChannel] FOREIGN KEY ([ChannelID]) REFERENCES [dbo].[SalesChannel] ([ChannelID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingFileTypeSalesChannel';

