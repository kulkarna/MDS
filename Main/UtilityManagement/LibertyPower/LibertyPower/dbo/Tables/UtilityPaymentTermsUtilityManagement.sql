CREATE TABLE [dbo].[UtilityPaymentTermsUtilityManagement] (
    [Id]                             INT            IDENTITY (1, 1) NOT NULL,
    [UtilityId]                      INT            NOT NULL,
    [AccountTypeId]                  INT            NOT NULL,
    [NumberOfDays]                   INT            NOT NULL,
    [TypeOfDaysId]                   INT            NOT NULL,
    [EventTypeId]                    INT            NOT NULL,
    [BillingTypeUtilityManagementId] INT            NOT NULL,
    [BillingWindowNumberOfDays]      INT            NOT NULL,
    [Inactive]                       BIT            NOT NULL,
    [CreateBy]                       NVARCHAR (255) NULL,
    [CreateDate]                     DATETIME       NULL,
    [LastModifiedBy]                 NVARCHAR (255) NULL,
    [LastModifiedDate]               DATETIME       NULL,
    CONSTRAINT [PK_UtilityPaymentTermsUtilityManagement] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_UtilityPaymentTermsUtilityManagement_AccountType] FOREIGN KEY ([AccountTypeId]) REFERENCES [dbo].[AccountType] ([ID]),
    CONSTRAINT [FK_UtilityPaymentTermsUtilityManagement_BillingTypeUtilityManagement] FOREIGN KEY ([BillingTypeUtilityManagementId]) REFERENCES [dbo].[BillingTypeUtilityManagement] ([Id]),
    CONSTRAINT [FK_UtilityPaymentTermsUtilityManagement_EventType] FOREIGN KEY ([EventTypeId]) REFERENCES [dbo].[EventType] ([Id]),
    CONSTRAINT [FK_UtilityPaymentTermsUtilityManagement_TypeOfDays] FOREIGN KEY ([TypeOfDaysId]) REFERENCES [dbo].[TypeOfDays] ([Id]),
    CONSTRAINT [FK_UtilityPaymentTermsUtilityManagement_Utility] FOREIGN KEY ([UtilityId]) REFERENCES [dbo].[vw_Utility] ([ID])
);

