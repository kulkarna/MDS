﻿CREATE TABLE [dbo].[zAuditRateClass] (
    [IdPrimary]                     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Id]                            UNIQUEIDENTIFIER NOT NULL,
    [UtilityCompanyId]              UNIQUEIDENTIFIER NOT NULL,
    [LpStandardRateClassId]         UNIQUEIDENTIFIER NULL,
    [RateClassId]                   INT              NULL,
    [RateClassCode]                 NVARCHAR (255)   NOT NULL,
    [Description]                   NVARCHAR (255)   NOT NULL,
    [AccountTypeId]                 UNIQUEIDENTIFIER NOT NULL,
    [Inactive]                      BIT              NOT NULL,
    [CreatedBy]                     NVARCHAR (100)   NOT NULL,
    [CreatedDate]                   DATETIME         NOT NULL,
    [LastModifiedBy]                NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]              DATETIME         NOT NULL,
    [IdPrevious]                    UNIQUEIDENTIFIER NULL,
    [UtilityCompanyIdPrevious]      UNIQUEIDENTIFIER NULL,
    [LpStandardRateClassIdPrevious] UNIQUEIDENTIFIER NULL,
    [RateClassIdPrevious]           INT              NULL,
    [RateClassCodePrevious]         NVARCHAR (255)   NULL,
    [DescriptionPrevious]           NVARCHAR (255)   NULL,
    [AccountTypeIdPrevious]         UNIQUEIDENTIFIER NULL,
    [InactivePrevious]              BIT              NULL,
    [CreatedByPrevious]             NVARCHAR (100)   NULL,
    [CreatedDatePrevious]           DATETIME         NULL,
    [LastModifiedByPrevious]        NVARCHAR (100)   NULL,
    [LastModifiedDatePrevious]      DATETIME         NULL,
    [SYS_CHANGE_VERSION]            BIGINT           NULL,
    [SYS_CHANGE_CREATION_VERSION]   BIGINT           NULL,
    [SYS_CHANGE_OPERATION]          NCHAR (1)        NULL,
    [SYS_CHANGE_COLUMNS]            NVARCHAR (1000)  NULL,
    CONSTRAINT [PK_zAuditRateClass] PRIMARY KEY CLUSTERED ([IdPrimary] ASC)
);

