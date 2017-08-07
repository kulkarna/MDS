CREATE TABLE [dbo].[ProductConfiguration] (
    [ProductConfigurationID] INT           IDENTITY (1, 1) NOT NULL,
    [Name]                   VARCHAR (200) NULL,
    [SegmentID]              INT           NULL,
    [ChannelTypeID]          INT           NULL,
    [ProductTypeID]          INT           NULL,
    [MarketID]               INT           NULL,
    [UtilityID]              INT           NULL,
    [ZoneID]                 INT           NULL,
    [ServiceClassID]         INT           NULL,
    [CreatedBy]              INT           NULL,
    [DateCreated]            DATETIME      NULL,
    [ProductName]            VARCHAR (200) NULL,
    [RelativeStartMonth]     INT           NULL,
    [IsTermRange]            TINYINT       NULL,
    [ProductBrandID]         INT           NULL,
    [ModifiedBy]             INT           NULL,
    [DateModified]           DATETIME      NULL,
    CONSTRAINT [PK_ProductConfiguration] PRIMARY KEY CLUSTERED ([ProductConfigurationID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ndx_DateCreated]
    ON [dbo].[ProductConfiguration]([DateCreated] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ndx_Name]
    ON [dbo].[ProductConfiguration]([Name] ASC) WITH (FILLFACTOR = 90);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DailyPricing', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ProductConfiguration';

