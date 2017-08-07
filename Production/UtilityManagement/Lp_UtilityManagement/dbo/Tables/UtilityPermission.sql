CREATE TABLE [dbo].[UtilityPermission] (
    [Id]                  UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityPermissionId] INT              NOT NULL,
    [UtilityCompanyId]    UNIQUEIDENTIFIER NOT NULL,
    [MarketId]            UNIQUEIDENTIFIER NOT NULL,
    [PaperContractOnly]   SMALLINT         NOT NULL,
    [CreatedBy]           NVARCHAR (100)   NOT NULL,
    [CreatedDate]         DATETIME         NOT NULL,
    [LastModifiedBy]      NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]    DATETIME         NOT NULL,
    CONSTRAINT [PK_UtilityPermission] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_UtilityPermission_Market] FOREIGN KEY ([MarketId]) REFERENCES [dbo].[Market] ([Id])
);

