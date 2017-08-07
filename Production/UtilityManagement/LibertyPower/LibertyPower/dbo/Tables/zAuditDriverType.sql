CREATE TABLE [dbo].[zAuditDriverType] (
    [Id]                INT            NOT NULL,
    [DriverName]        NVARCHAR (50)  NOT NULL,
    [DriverDescription] NVARCHAR (255) NOT NULL,
    [CreateBy]          NVARCHAR (255) NULL,
    [CreateDate]        DATETIME       NULL,
    [LastModifiedBy]    NVARCHAR (255) NULL,
    [LastModifiedDate]  DATETIME       NULL,
    [inactive]          BIT            NOT NULL
);

