CREATE TABLE [dbo].[UtilityPermissionToUtilityPermissionLegacy] (
    [Id]                        UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityPermissionId]       UNIQUEIDENTIFIER NOT NULL,
    [UtilityPermissionLegacyId] INT              NOT NULL,
    [CreatedBy]                 NVARCHAR (100)   NOT NULL,
    [CreatedDate]               DATETIME         NOT NULL,
    [LastModifiedBy]            NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]          DATETIME         NOT NULL,
    CONSTRAINT [PK_UtilityPermissionToUtilityPermissionLegacy] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_UtilityPermissionToUtilityPermissionLegacy_UtilityPermission] FOREIGN KEY ([UtilityPermissionId]) REFERENCES [dbo].[UtilityPermission] ([Id]),
    CONSTRAINT [FK_UtilityPermissionToUtilityPermissionLegacy_UtilityPermissionLegacy] FOREIGN KEY ([UtilityPermissionLegacyId]) REFERENCES [dbo].[UtilityPermissionLegacy] ([ID])
);

