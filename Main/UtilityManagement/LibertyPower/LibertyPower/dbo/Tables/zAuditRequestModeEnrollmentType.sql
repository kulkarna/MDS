CREATE TABLE [dbo].[zAuditRequestModeEnrollmentType] (
    [Id]               INT            NOT NULL,
    [Name]             NVARCHAR (50)  NOT NULL,
    [Description]      NVARCHAR (255) NOT NULL,
    [Inactive]         BIT            NOT NULL,
    [CreatedBy]        NVARCHAR (100) NOT NULL,
    [CreatedDate]      DATETIME       NOT NULL,
    [LastModifiedBy]   NVARCHAR (100) NOT NULL,
    [LastModifiedDate] DATETIME       NOT NULL
);

