CREATE TABLE [dbo].[ProdConfigChannelAccess] (
    [ID]                     INT IDENTITY (1, 1) NOT NULL,
    [ProductConfigurationID] INT NOT NULL,
    [ChannelID]              INT NOT NULL,
    CONSTRAINT [PK_ProdConfigChannelAccess] PRIMARY KEY CLUSTERED ([ID] ASC)
);

