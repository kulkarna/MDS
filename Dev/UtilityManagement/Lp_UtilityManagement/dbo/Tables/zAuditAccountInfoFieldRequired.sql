﻿CREATE TABLE [dbo].[zAuditAccountInfoFieldRequired] (
    [IdPrimary]                   UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [Id]                          UNIQUEIDENTIFIER NOT NULL,
    [UtilityCompanyId]            UNIQUEIDENTIFIER NOT NULL,
    [AccountInfoFieldId]          UNIQUEIDENTIFIER NOT NULL,
    [IsRequired]                  BIT              NOT NULL,
    [Inactive]                    BIT              NOT NULL,
    [CreatedBy]                   NVARCHAR (100)   NOT NULL,
    [CreatedDate]                 DATETIME         NOT NULL,
    [LastModifiedBy]              NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]            DATETIME         NOT NULL,
    [IdPrevious]                  UNIQUEIDENTIFIER NULL,
    [UtilityCompanyIdPrevious]    UNIQUEIDENTIFIER NULL,
    [AccountInfoFieldIdPrevious]  UNIQUEIDENTIFIER NULL,
    [IsRequiredPrevious]          BIT              NULL,
    [InactivePrevious]            BIT              NULL,
    [CreatedByPrevious]           NVARCHAR (100)   NULL,
    [CreatedDatePrevious]         DATETIME         NULL,
    [LastModifiedByPrevious]      NVARCHAR (100)   NULL,
    [LastModifiedDatePrevious]    DATETIME         NULL,
    [SYS_CHANGE_VERSION]          BIGINT           NULL,
    [SYS_CHANGE_CREATION_VERSION] BIGINT           NULL,
    [SYS_CHANGE_OPERATION]        NCHAR (1)        NULL,
    [SYS_CHANGE_COLUMNS]          NVARCHAR (1000)  NULL,
    CONSTRAINT [PK_zAuditAccountInfoFieldRequired] PRIMARY KEY CLUSTERED ([IdPrimary] ASC)
);
