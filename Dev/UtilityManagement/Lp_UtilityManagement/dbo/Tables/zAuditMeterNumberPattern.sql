﻿CREATE TABLE [dbo].[zAuditMeterNumberPattern] (
    [Id]                                       UNIQUEIDENTIFIER NOT NULL,
    [UtilityCompanyId]                         UNIQUEIDENTIFIER NOT NULL,
    [MeterNumberPattern]                       NVARCHAR (255)   NULL,
    [MeterNumberPatternDescription]            NVARCHAR (255)   NOT NULL,
    [MeterNumberAddLeadingZero]                INT              NULL,
    [MeterNumberTruncateLast]                  INT              NULL,
    [MeterNumberRequiredForEDIRequest]         BIT              NOT NULL,
    [Inactive]                                 BIT              NOT NULL,
    [CreatedBy]                                NVARCHAR (100)   NOT NULL,
    [CreatedDate]                              DATETIME         NOT NULL,
    [LastModifiedBy]                           NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]                         DATETIME         NOT NULL,
    [IdPrevious]                               UNIQUEIDENTIFIER NULL,
    [UtilityCompanyIdPrevious]                 UNIQUEIDENTIFIER NULL,
    [MeterNumberPatternPrevious]               NVARCHAR (255)   NULL,
    [MeterNumberPatternDescriptionPrevious]    NVARCHAR (255)   NULL,
    [MeterNumberAddLeadingZeroPrevious]        INT              NULL,
    [MeterNumberTruncateLastPrevious]          INT              NULL,
    [MeterNumberRequiredForEDIRequestPrevious] BIT              NULL,
    [InactivePrevious]                         BIT              NULL,
    [CreatedByPrevious]                        NVARCHAR (100)   NULL,
    [CreatedDatePrevious]                      DATETIME         NULL,
    [LastModifiedByPrevious]                   NVARCHAR (100)   NULL,
    [LastModifiedDatePrevious]                 DATETIME         NULL,
    [SYS_CHANGE_VERSION]                       BIGINT           NULL,
    [SYS_CHANGE_CREATION_VERSION]              BIGINT           NULL,
    [SYS_CHANGE_OPERATION]                     NCHAR (1)        NULL,
    [SYS_CHANGE_COLUMNS]                       NVARCHAR (1000)  NULL,
    [IdPrimary]                                UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_zAuditMeterNumberPattern] PRIMARY KEY CLUSTERED ([IdPrimary] ASC)
);

