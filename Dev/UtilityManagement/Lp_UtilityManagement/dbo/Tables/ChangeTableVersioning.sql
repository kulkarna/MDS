CREATE TABLE [dbo].[ChangeTableVersioning] (
    [Id]                    UNIQUEIDENTIFIER NOT NULL,
    [ChangeTrackingVersion] BIGINT           NOT NULL,
    [CreatedDate]           DATETIME         NOT NULL,
    CONSTRAINT [PK_ChangeTableVersioning] PRIMARY KEY CLUSTERED ([Id] ASC)
);

