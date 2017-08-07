CREATE TABLE [dbo].[zAuditBillingTypeUtilityManagement] (
    [Id]                   INT            NOT NULL,
    [UtilityId]            INT            NOT NULL,
    [DriverTypeId]         INT            NOT NULL,
    [DriverTypePropertyId] INT            NOT NULL,
    [DriverTypeValueId]    INT            NOT NULL,
    [DefaultBillingTypeId] INT            NOT NULL,
    [Inactive]             BIT            NOT NULL,
    [CreateBy]             NVARCHAR (255) NULL,
    [CreateDate]           DATETIME       NULL,
    [LastModifiedBy]       NVARCHAR (255) NULL,
    [LastModifiedDate]     DATETIME       NULL
);

