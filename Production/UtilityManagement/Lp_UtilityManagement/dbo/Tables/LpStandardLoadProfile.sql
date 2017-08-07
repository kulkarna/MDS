CREATE TABLE [dbo].[LpStandardLoadProfile] (
    [Id]                        UNIQUEIDENTIFIER NOT NULL,
    [LpStandardLoadProfileCode] NVARCHAR (255)   NOT NULL,
    [Inactive]                  BIT              NOT NULL,
    [CreatedBy]                 NVARCHAR (100)   NOT NULL,
    [CreatedDate]               DATETIME         NOT NULL,
    [LastModifiedBy]            NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]          DATETIME         NOT NULL,
    [UtilityCompanyId]          UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_LpStandardLoadProfile] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_LpStandardLoadProfile_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);


GO
ALTER TABLE [dbo].[LpStandardLoadProfile] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = OFF);

