CREATE TABLE [dbo].[ProductConfiguration_111511] (
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
    [IsTermRange]            TINYINT       NULL
);

