﻿CREATE TABLE [dbo].[TPVFileData] (
    [EntryId]            INT           IDENTITY (1, 1) NOT NULL,
    [LangCode]           VARCHAR (250) NULL,
    [BTN]                VARCHAR (250) NULL,
    [AgentID]            VARCHAR (250) NULL,
    [SalesChannel]       VARCHAR (250) NULL,
    [FirstName]          VARCHAR (250) NULL,
    [LastName]           VARCHAR (250) NULL,
    [AccountNumber]      VARCHAR (250) NULL,
    [OfferCode]          VARCHAR (250) NULL,
    [Rate]               VARCHAR (250) NULL,
    [Term]               VARCHAR (250) NULL,
    [EstDateEffect]      VARCHAR (100) NULL,
    [PIN]                VARCHAR (250) NULL,
    [ServiceAddress]     VARCHAR (MAX) NULL,
    [ServiceCity]        VARCHAR (100) NULL,
    [ServiceState]       VARCHAR (250) NULL,
    [ServiceZip]         VARCHAR (250) NULL,
    [BillingAddress]     VARCHAR (MAX) NULL,
    [BillingCity]        VARCHAR (250) NULL,
    [BillingState]       VARCHAR (250) NULL,
    [BillingZip]         VARCHAR (250) NULL,
    [VerificationNumber] VARCHAR (250) NULL,
    [TPVCode]            VARCHAR (50)  NULL,
    [FEIN]               VARCHAR (250) NULL,
    [TPVFileId]          INT           NULL,
    CONSTRAINT [PK_TPVFileData] PRIMARY KEY CLUSTERED ([EntryId] ASC),
    CONSTRAINT [FK_TPVFileData_TPVFile] FOREIGN KEY ([TPVFileId]) REFERENCES [dbo].[TPVFile] ([ImportId])
);

