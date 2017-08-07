CREATE TABLE [dbo].[SalesChannelUser] (
    [ChannelUserID] INT      IDENTITY (1, 1) NOT NULL,
    [ChannelID]     INT      NOT NULL,
    [UserID]        INT      NOT NULL,
    [DateCreated]   DATETIME CONSTRAINT [DF__SalesChan__DateC__0FA2421A] DEFAULT (getdate()) NOT NULL,
    [DateModified]  DATETIME CONSTRAINT [DF__SalesChan__DateM__10966653] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]     INT      CONSTRAINT [DF__SalesChan__Creat__118A8A8C] DEFAULT ((1)) NOT NULL,
    [ModifiedBy]    INT      CONSTRAINT [DF__SalesChan__Modif__127EAEC5] DEFAULT ((1)) NOT NULL,
    [EntityID]      INT      CONSTRAINT [DF__SalesChan__Entit__4F67C174] DEFAULT ((0)) NULL,
    [ReportsTo]     INT      NULL,
    CONSTRAINT [PK_SalesChannelUser_1] PRIMARY KEY CLUSTERED ([ChannelID] ASC, [UserID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_SalesChannelUser_SalesChannel] FOREIGN KEY ([ChannelID]) REFERENCES [dbo].[SalesChannel] ([ChannelID]),
    CONSTRAINT [FK_SalesChannelUser_User] FOREIGN KEY ([UserID]) REFERENCES [dbo].[User] ([UserID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SalesChannelUser';

