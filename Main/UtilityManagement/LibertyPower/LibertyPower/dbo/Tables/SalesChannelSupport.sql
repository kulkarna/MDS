CREATE TABLE [dbo].[SalesChannelSupport] (
    [SalesChannelSupportID] INT      IDENTITY (1, 1) NOT NULL,
    [SupportUserID]         INT      NOT NULL,
    [ManagerUserID]         INT      NOT NULL,
    [ChannelID]             INT      NULL,
    [SendEmail]             BIT      CONSTRAINT [DF_SalesChannelSupport_SendEmail] DEFAULT ((1)) NOT NULL,
    [ExpirationDate]        DATETIME NULL,
    [DateModified]          DATETIME CONSTRAINT [DF_SalesChannelSupport_Modified] DEFAULT (getdate()) NOT NULL,
    [DateCreated]           DATETIME CONSTRAINT [DF_SalesChannelSupport_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_SalesChannelSupport] PRIMARY KEY CLUSTERED ([SalesChannelSupportID] ASC),
    CONSTRAINT [FK_SalesChannelSupport_ManagerUser] FOREIGN KEY ([ManagerUserID]) REFERENCES [dbo].[User] ([UserID]),
    CONSTRAINT [FK_SalesChannelSupport_SalesChannel] FOREIGN KEY ([ChannelID]) REFERENCES [dbo].[SalesChannel] ([ChannelID]),
    CONSTRAINT [FK_SalesChannelSupport_SupportUser] FOREIGN KEY ([SupportUserID]) REFERENCES [dbo].[User] ([UserID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SalesChannelSupport';

