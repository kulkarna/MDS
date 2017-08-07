﻿CREATE TABLE [dbo].[zAuditICapTCapRefresh] (
    [Id]                          UNIQUEIDENTIFIER NOT NULL,
    [UtilityCompanyId]            UNIQUEIDENTIFIER NOT NULL,
    [ICapNextRefresh]             NVARCHAR (4)     NULL,
    [ICapEffectiveDate]           NVARCHAR (4)     NULL,
    [TCapNextRefresh]             NVARCHAR (4)     NULL,
    [TCapEffectiveDate]           NVARCHAR (4)     NULL,
    [Inactive]                    BIT              NOT NULL,
    [CreatedBy]                   NVARCHAR (100)   NOT NULL,
    [CreatedDate]                 DATETIME         NOT NULL,
    [LastModifiedBy]              NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]            DATETIME         NOT NULL,
    [IdPrevious]                  UNIQUEIDENTIFIER NULL,
    [UtilityCompanyIdPrevious]    UNIQUEIDENTIFIER NULL,
    [ICapNextRefreshPrevious]     NVARCHAR (4)     NULL,
    [ICapEffectiveDatePrevious]   NVARCHAR (4)     NULL,
    [TCapNextRefreshPrevious]     NVARCHAR (4)     NULL,
    [TCapEffectiveDatePrevious]   NVARCHAR (4)     NULL,
    [InactivePrevious]            BIT              NULL,
    [CreatedByPrevious]           NVARCHAR (100)   NULL,
    [CreatedDatePrevious]         DATETIME         NULL,
    [LastModifiedByPrevious]      NVARCHAR (100)   NULL,
    [LastModifiedDatePrevious]    DATETIME         NULL,
    [SYS_CHANGE_VERSION]          BIGINT           NULL,
    [SYS_CHANGE_CREATION_VERSION] BIGINT           NULL,
    [SYS_CHANGE_OPERATION]        NCHAR (1)        NULL,
    [SYS_CHANGE_COLUMNS]          NVARCHAR (1000)  NULL,
    [IdPrimary]                   UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_zAuditICapTCapRefresh] PRIMARY KEY CLUSTERED ([IdPrimary] ASC)
);
