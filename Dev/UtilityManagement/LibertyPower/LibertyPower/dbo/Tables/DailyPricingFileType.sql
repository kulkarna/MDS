CREATE TABLE [dbo].[DailyPricingFileType] (
    [DailyPricingFileTypeID] INT          IDENTITY (1, 1) NOT NULL,
    [FileType]               VARCHAR (10) NOT NULL,
    [DateCreated]            DATETIME     NOT NULL,
    [CreatedBy]              INT          NOT NULL,
    CONSTRAINT [PK_DailyPricingFileType] PRIMARY KEY CLUSTERED ([DailyPricingFileTypeID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DailyPricingFileType';

