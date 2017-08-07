CREATE TABLE [dbo].[zAuditUtilityCompany] (
    [Id]                          UNIQUEIDENTIFIER NOT NULL,
    [UtilityCode]                 VARCHAR (50)     NOT NULL,
    [Inactive]                    BIT              NOT NULL,
    [CreatedBy]                   NVARCHAR (100)   NOT NULL,
    [CreatedDate]                 DATETIME         NOT NULL,
    [LastModifiedBy]              NVARCHAR (100)   NOT NULL,
    [LastModifiedDate]            DATETIME         NOT NULL,
    [IdPrevious]                  UNIQUEIDENTIFIER NULL,
    [UtilityCodePrevious]         NVARCHAR (50)    NULL,
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
    [FullName]                    NVARCHAR (255)   NULL,
    [IsoId]                       UNIQUEIDENTIFIER NULL,
    [MarketId]                    UNIQUEIDENTIFIER NULL,
    [PrimaryDunsNumber]           NVARCHAR (255)   NULL,
    [LpEntityId]                  NVARCHAR (255)   NULL,
    [SalesForceId]                NVARCHAR (255)   NULL,
    [FullNamePrevious]            NVARCHAR (255)   NULL,
    [IsoIdPrevious]               UNIQUEIDENTIFIER NULL,
    [MarketIdPrevious]            UNIQUEIDENTIFIER NULL,
    [PrimaryDunsNumberPrevious]   NVARCHAR (255)   NULL,
    [LpEntityIdPrevious]          NVARCHAR (255)   NULL,
    [SalesForceIdPrevious]        NVARCHAR (255)   NULL,
    [UtilityStatusId]             UNIQUEIDENTIFIER NULL,
    [UtilityStatusIdPrevious]     UNIQUEIDENTIFIER NULL,
    [ParentCompany]               NVARCHAR (255)   NULL,
    [ParentCompanyPrevious]       NVARCHAR (255)   NULL,
    CONSTRAINT [PK_zAuditUtilityCompany] PRIMARY KEY CLUSTERED ([IdPrimary] ASC)
);







