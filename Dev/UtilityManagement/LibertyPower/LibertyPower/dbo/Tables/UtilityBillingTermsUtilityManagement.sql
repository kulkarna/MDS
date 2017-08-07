CREATE TABLE [dbo].[UtilityBillingTermsUtilityManagement] (
    [Id]                             INT            IDENTITY (1, 1) NOT NULL,
    [UtilityId]                      INT            NOT NULL,
    [AccountTypePropertyId]          INT            NOT NULL,
    [AccountTypeValueId]             INT            NOT NULL,
    [NumberOfDays]                   INT            NOT NULL,
    [TypeOfDaysProfilePropertyId]    INT            NOT NULL,
    [TypeOfDaysProfileValueId]       INT            NOT NULL,
    [EventInvoiceDate]               DATETIME       NOT NULL,
    [BillingTypeUtilityManagementId] INT            NOT NULL,
    [Inactive]                       BIT            NOT NULL,
    [CreateBy]                       NVARCHAR (255) NULL,
    [CreateDate]                     DATETIME       NULL,
    [LastModifiedBy]                 NVARCHAR (255) NULL,
    [LastModifiedDate]               DATETIME       NULL,
    CONSTRAINT [PK_UtilityBillingTermsUtilityManagement] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_UtilityBillingTermsUtilityManagement_Property_AccountType] FOREIGN KEY ([AccountTypePropertyId]) REFERENCES [dbo].[Property] ([ID]),
    CONSTRAINT [FK_UtilityBillingTermsUtilityManagement_Property_TypeOfDays] FOREIGN KEY ([TypeOfDaysProfilePropertyId]) REFERENCES [dbo].[Property] ([ID]),
    CONSTRAINT [FK_UtilityBillingTermsUtilityManagement_PropertyInternalRef_AccountType] FOREIGN KEY ([AccountTypeValueId]) REFERENCES [dbo].[PropertyInternalRef] ([ID]),
    CONSTRAINT [FK_UtilityBillingTermsUtilityManagement_PropertyInternalRef_TypeOfDays] FOREIGN KEY ([TypeOfDaysProfileValueId]) REFERENCES [dbo].[PropertyInternalRef] ([ID]),
    CONSTRAINT [FK_UtilityBillingTermsUtilityManagement_Utility] FOREIGN KEY ([UtilityId]) REFERENCES [dbo].[vw_Utility] ([ID])
);

