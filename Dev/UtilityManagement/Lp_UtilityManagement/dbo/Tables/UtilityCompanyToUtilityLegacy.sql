CREATE TABLE [dbo].[UtilityCompanyToUtilityLegacy] (
    [Id]               UNIQUEIDENTIFIER NOT NULL,
    [UtilityCompanyId] UNIQUEIDENTIFIER NOT NULL,
    [UtilityLegacyId]  INT              NOT NULL,
    [Inactive]         BIT              NOT NULL,
    [CreatedBy]        NVARCHAR (100)   NOT NULL,
    [CreatedDate]      DATETIME         NOT NULL,
    [LastModifiedBy]   NVARCHAR (100)   NOT NULL,
    [LastModifiedDate] DATETIME         NOT NULL,
    CONSTRAINT [PK_UtilityCompanyToUtilityLegacy] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_UtilityCompanyToUtilityLegacy_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id]),
    CONSTRAINT [FK_UtilityCompanyToUtilityLegacy_UtilityLegacy] FOREIGN KEY ([UtilityLegacyId]) REFERENCES [dbo].[UtilityLegacy] ([ID])
);

