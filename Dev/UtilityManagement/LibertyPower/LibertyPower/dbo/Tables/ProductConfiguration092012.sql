CREATE TABLE [dbo].[ProductConfiguration092012] (
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
    [DateModified]           DATETIME      NULL
);

