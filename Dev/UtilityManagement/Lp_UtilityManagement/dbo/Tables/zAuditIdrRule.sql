CREATE TABLE [dbo].[zAuditIdrRule] (
    [IdPrimary]                            UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Id]                                   UNIQUEIDENTIFIER NOT NULL,
    [UtilityCompanyId]                     UNIQUEIDENTIFIER NOT NULL,
    [RequestModeTypeId]                    UNIQUEIDENTIFIER NULL,
    [RateClassId]                          UNIQUEIDENTIFIER NULL,
    [LoadProfileId]                        UNIQUEIDENTIFIER NULL,
    [MinUsageMWh]                          INT              NULL,
    [MaxUsageMWh]                          INT              NULL,
    [IsOnEligibleCustomerList]             BIT              NOT NULL,
    [IsHistoricalArchiveAvailable]         BIT              NOT NULL,
    [Inactive]                             BIT              NOT NULL,
    [CreatedBy]                            NVARCHAR (100)   NOT NULL,
    [CreatedDate]                          DATETIME         NOT NULL,
    [LastModifiedBy]                       NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]                     DATETIME         NOT NULL,
    [IdPrevious]                           UNIQUEIDENTIFIER NULL,
    [UtilityCompanyIdPrevious]             UNIQUEIDENTIFIER NULL,
    [RequestModeTypeIdPrevious]            UNIQUEIDENTIFIER NULL,
    [RateClassIdPrevious]                  UNIQUEIDENTIFIER NULL,
    [LoadProfileIdPrevious]                UNIQUEIDENTIFIER NULL,
    [MinUsageMWhPrevious]                  INT              NULL,
    [MaxUsageMWhPrevious]                  INT              NULL,
    [IsOnEligibleCustomerListPrevious]     BIT              NULL,
    [IsHistoricalArchiveAvailablePrevious] BIT              NULL,
    [InactivePrevious]                     BIT              NULL,
    [CreatedByPrevious]                    NVARCHAR (100)   NULL,
    [CreatedDatePrevious]                  DATETIME         NULL,
    [LastModifiedByPrevious]               NVARCHAR (100)   NULL,
    [LastModifiedDatePrevious]             DATETIME         NULL,
    [SYS_CHANGE_VERSION]                   BIGINT           NULL,
    [SYS_CHANGE_CREATION_VERSION]          BIGINT           NULL,
    [SYS_CHANGE_OPERATION]                 NCHAR (1)        NULL,
    [SYS_CHANGE_COLUMNS]                   NVARCHAR (1000)  NULL,
    [RequestModeIdrId]                     UNIQUEIDENTIFIER NULL,
    [RequestModeIdrIdPrevious]             UNIQUEIDENTIFIER NULL,
    [TariffCodeId]                         UNIQUEIDENTIFIER NULL,
    [TariffCodeIdPrevious]                 UNIQUEIDENTIFIER NULL,
    CONSTRAINT [PK_zAuditIdrRule] PRIMARY KEY CLUSTERED ([IdPrimary] ASC)
);







