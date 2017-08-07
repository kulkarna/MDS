CREATE TABLE [dbo].[zAuditLoadProfileUtilityManagement] (
    [Id]                     INT            NOT NULL,
    [UtilityId]              INT            NOT NULL,
    [LoadProfileCode]        NVARCHAR (50)  NULL,
    [LoadProfileDescription] NVARCHAR (255) NULL,
    [LoadProfilePropertyId]  INT            NOT NULL,
    [LoadProfileValueId]     INT            NOT NULL,
    [AccountTypeId]          INT            NOT NULL,
    [Inactive]               BIT            NOT NULL,
    [CreateBy]               NVARCHAR (255) NULL,
    [CreateDate]             DATETIME       NULL,
    [LastModifiedBy]         NVARCHAR (255) NULL,
    [LastModifiedDate]       DATETIME       NULL
);

