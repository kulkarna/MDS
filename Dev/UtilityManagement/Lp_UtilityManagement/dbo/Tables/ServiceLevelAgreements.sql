CREATE TABLE [dbo].[ServiceLevelAgreements] (
    [Id]                                                    UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [UtilityCompanyId]                                      UNIQUEIDENTIFIER NOT NULL,
    [UtilitysSlaToHistoricalUsageResponseInBusinessDays]    INT              NULL,
    [LPsSlaToFollowUpHistoricalUsageResponseInBusinessDays] INT              NULL,
    [UtilitysSlaToICapResponseInBusinessDays]               INT              NULL,
    [LPsSlaToFollowUpICapResponseInBusinessDays]            INT              NULL,
    [UtilitysSlaToIdrResponseInBusinessDays]                INT              NULL,
    [LPsSlaToFollowUpIdrResponseInBusinessDays]             INT              NULL,
    [Inactive]                                              BIT              NOT NULL,
    [CreatedBy]                                             NVARCHAR (100)   NOT NULL,
    [CreatedDate]                                           DATETIME         NOT NULL,
    [LastModifiedBy]                                        NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]                                      DATETIME         NOT NULL,
    CONSTRAINT [PK_ServiceLevelAgreements] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ServiceLevelAgreements_UtilityCompany] FOREIGN KEY ([UtilityCompanyId]) REFERENCES [dbo].[UtilityCompany] ([Id])
);

