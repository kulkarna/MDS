CREATE TABLE [dbo].[SalesChannelChannelGroup] (
    [SalesChannelChannelGroupID] INT      IDENTITY (1, 1) NOT NULL,
    [ChannelID]                  INT      NOT NULL,
    [ChannelGroupID]             INT      NOT NULL,
    [EffectiveDate]              DATETIME NOT NULL,
    [ExpirationDate]             DATETIME NULL,
    [UserIdentity]               INT      NOT NULL,
    [DateCreated]                DATETIME NOT NULL,
    CONSTRAINT [PK_SalesChannelChannelGroup] PRIMARY KEY CLUSTERED ([SalesChannelChannelGroupID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SalesChannelChannelGroup';

