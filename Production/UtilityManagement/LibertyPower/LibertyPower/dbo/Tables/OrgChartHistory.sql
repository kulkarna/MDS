CREATE TABLE [dbo].[OrgChartHistory] (
    [OrgID]           INT           IDENTITY (1, 1) NOT NULL,
    [ChannelCategory] VARCHAR (100) NULL,
    [SalesMgrChannel] VARCHAR (100) NULL,
    [ChannelType]     VARCHAR (100) NULL,
    [DirectReport]    VARCHAR (100) NULL,
    [EffectiveDate]   DATETIME      NULL
);

