﻿CREATE TABLE [dbo].[zAuditRequestModeEnrollmentType] (
    [Id]                          UNIQUEIDENTIFIER NOT NULL,
    [Name]                        NVARCHAR (50)    NOT NULL,
    [Description]                 NVARCHAR (255)   NOT NULL,
    [Inactive]                    BIT              NOT NULL,
    [CreatedBy]                   NVARCHAR (100)   NOT NULL,
    [CreatedDate]                 DATETIME         NOT NULL,
    [LastModifiedBy]              NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]            DATETIME         NOT NULL,
    [IdPrevious]                  UNIQUEIDENTIFIER NULL,
    [NamePrevious]                NVARCHAR (50)    NULL,
    [DescriptionPrevious]         NVARCHAR (255)   NULL,
    [InactivePrevious]            BIT              NULL,
    [CreatedByPrevious]           NVARCHAR (100)   NULL,
    [CreatedDatePrevious]         DATETIME         NULL,
    [LastModifiedByPrevious]      NVARCHAR (100)   NULL,
    [LastModifiedDatePrevious]    DATETIME         NULL,
    [SYS_CHANGE_VERSION]          BIGINT           NULL,
    [SYS_CHANGE_CREATION_VERSION] BIGINT           NULL,
    [SYS_CHANGE_OPERATION]        NCHAR (1)        NULL,
    [SYS_CHANGE_COLUMNS]          NVARCHAR (1000)  NULL,
    [EnumValue]                   INT              NOT NULL,
    [EnumValuePrevious]           INT              NULL
);



