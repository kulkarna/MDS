CREATE TABLE [dbo].[LpStandardTariffCode] (
    [Id]                       UNIQUEIDENTIFIER NOT NULL,
    [LpStandardTariffCodeCode] NVARCHAR (255)   NOT NULL,
    [Inactive]                 BIT              NOT NULL,
    [CreatedBy]                NVARCHAR (100)   NOT NULL,
    [CreatedDate]              DATETIME         NOT NULL,
    [LastModifiedBy]           NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]         DATETIME         NOT NULL,
    [UtilityCompanyId]         UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_LpStandardTariffCode] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_LpStandardTariffCode_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);


GO
ALTER TABLE [dbo].[LpStandardTariffCode] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = OFF);

