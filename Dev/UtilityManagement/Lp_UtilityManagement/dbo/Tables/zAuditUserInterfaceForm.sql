﻿CREATE TABLE [dbo].[zAuditUserInterfaceForm] (
    [Id]                            UNIQUEIDENTIFIER NOT NULL,
    [UserInterfaceFormName]         VARCHAR (50)     NOT NULL,
    [Inactive]                      BIT              NOT NULL,
    [CreatedBy]                     NVARCHAR (100)   NOT NULL,
    [CreatedDate]                   DATETIME         NOT NULL,
    [LastModifiedBy]                NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]              DATETIME         NOT NULL,
    [IdPrevious]                    UNIQUEIDENTIFIER NULL,
    [UserInterfaceFormNamePrevious] VARCHAR (50)     NULL,
    [InactivePrevious]              BIT              NULL,
    [CreatedByPrevious]             NVARCHAR (100)   NULL,
    [CreatedDatePrevious]           DATETIME         NULL,
    [LastModifiedByPrevious]        NVARCHAR (100)   NULL,
    [LastModifiedDatePrevious]      DATETIME         NULL,
    [SYS_CHANGE_VERSION]            BIGINT           NULL,
    [SYS_CHANGE_CREATION_VERSION]   BIGINT           NULL,
    [SYS_CHANGE_OPERATION]          NCHAR (1)        NULL,
    [SYS_CHANGE_COLUMNS]            NVARCHAR (1000)  NULL,
    [IdPrimary]                     UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_zAuditUserInterfaceForm] PRIMARY KEY CLUSTERED ([IdPrimary] ASC)
);

