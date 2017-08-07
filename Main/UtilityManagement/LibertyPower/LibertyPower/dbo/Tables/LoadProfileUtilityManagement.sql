CREATE TABLE [dbo].[LoadProfileUtilityManagement] (
    [Id]                     INT            IDENTITY (1, 1) NOT NULL,
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
    [LastModifiedDate]       DATETIME       NULL,
    CONSTRAINT [PK_LoadProfileUtilityManagement] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_LoadProfileUtilityManagement_AccountType] FOREIGN KEY ([AccountTypeId]) REFERENCES [dbo].[AccountType] ([ID]),
    CONSTRAINT [FK_LoadProfileUtilityManagement_Property_LoadProfile] FOREIGN KEY ([LoadProfilePropertyId]) REFERENCES [dbo].[Property] ([ID]),
    CONSTRAINT [FK_LoadProfileUtilityManagement_PropertyInternalRef_LoadProfile] FOREIGN KEY ([LoadProfileValueId]) REFERENCES [dbo].[PropertyInternalRef] ([ID]),
    CONSTRAINT [FK_LoadProfileUtilityManagement_Utility] FOREIGN KEY ([UtilityId]) REFERENCES [dbo].[vw_Utility] ([ID])
);

