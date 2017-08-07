CREATE TABLE [dbo].[zAuditRateClassUtilityManagement] (
    [Id]                   INT            NOT NULL,
    [UtilityId]            INT            NOT NULL,
    [RateClassPropertyId]  INT            NOT NULL,
    [RateClassValueId]     INT            NOT NULL,
    [RateClassDescription] NVARCHAR (255) NULL,
    [AccountTypeId]        INT            NOT NULL,
    [Inactive]             BIT            NOT NULL,
    [CreateBy]             NVARCHAR (255) NULL,
    [CreateDate]           DATETIME       NULL,
    [LastModifiedBy]       NVARCHAR (255) NULL,
    [LastModifiedDate]     DATETIME       NULL
);

