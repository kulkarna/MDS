CREATE TABLE [dbo].[zAuditBillingTypeUtilityManagementApprovedLpBillingTypeToBillingType] (
    [Id]                             INT            NOT NULL,
    [BillingTypeUtilityManagementId] INT            NOT NULL,
    [BillingTypeId]                  INT            NOT NULL,
    [Inactive]                       BIT            NOT NULL,
    [CreateBy]                       NVARCHAR (255) NULL,
    [CreateDate]                     DATETIME       NULL,
    [LastModifiedBy]                 NVARCHAR (255) NULL,
    [LastModifiedDate]               DATETIME       NULL
);

