CREATE TABLE [dbo].[zAuditTariffCodeUtilityManagement] (
    [Id]                           INT            NOT NULL,
    [UtilityId]                    INT            NOT NULL,
    [RateClassUtilityManagementId] INT            NOT NULL,
    [TariffCodePropertyId]         INT            NOT NULL,
    [TariffCodeValueId]            INT            NOT NULL,
    [TariffCodeDescription]        NVARCHAR (255) NULL,
    [AccountTypeId]                INT            NOT NULL,
    [Inactive]                     BIT            NOT NULL,
    [CreateBy]                     NVARCHAR (255) NULL,
    [CreateDate]                   DATETIME       NULL,
    [LastModifiedBy]               NVARCHAR (255) NULL,
    [LastModifiedDate]             DATETIME       NULL
);

