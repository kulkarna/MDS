CREATE TABLE [dbo].[ManagedBin] (
    [ID]            INT            IDENTITY (1, 1) NOT NULL,
    [ManagerRootID] INT            NOT NULL,
    [RelativePath]  VARCHAR (1024) NOT NULL,
    [ItemCount]     INT            CONSTRAINT [DF_ManagedBin_ItemCount] DEFAULT ((0)) NOT NULL,
    [CreationTime]  DATETIME       CONSTRAINT [DF_ManagedBin_CreationTime] DEFAULT (getdate()) NOT NULL,
    [UserID]        INT            NOT NULL,
    CONSTRAINT [PK_ManagedBin] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ManagedBin_ManagerRoot] FOREIGN KEY ([ManagerRootID]) REFERENCES [dbo].[ManagerRoot] ([ID])
);

