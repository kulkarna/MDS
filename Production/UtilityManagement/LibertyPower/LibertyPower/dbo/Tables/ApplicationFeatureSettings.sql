CREATE TABLE [dbo].[ApplicationFeatureSettings] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [FeatureName]  NVARCHAR (50)  NULL,
    [FeatureValue] BIT            NULL,
    [ProcessName]  NVARCHAR (50)  NULL,
    [Description]  NVARCHAR (250) NULL,
    [CreatedBy]    INT            NULL,
    [CreatedOn]    DATETIME       NULL,
    [UpdatedBy]    INT            NULL,
    [UpdatedOn]    DATETIME       NULL
);

