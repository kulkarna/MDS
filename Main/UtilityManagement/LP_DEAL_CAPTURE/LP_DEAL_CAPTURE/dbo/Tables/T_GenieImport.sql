﻿CREATE TABLE [dbo].[T_GenieImport] (
    [ContractID]                INT             NOT NULL,
    [MarketCode]                CHAR (2)        NULL,
    [UtilityCode]               VARCHAR (50)    NULL,
    [BusinessType]              VARCHAR (50)    NULL,
    [PartnerName]               VARCHAR (100)   NOT NULL,
    [LoginID]                   VARCHAR (50)    NOT NULL,
    [AgentName]                 VARCHAR (50)    NOT NULL,
    [AccountTypeID]             INT             NOT NULL,
    [ProductSelection]          VARCHAR (50)    NULL,
    [CustomerName]              VARCHAR (100)   NULL,
    [DBA]                       VARCHAR (100)   NULL,
    [DUNS]                      VARCHAR (50)    NULL,
    [TaxExempt]                 BIT             NULL,
    [CertificateAtached]        BIT             NULL,
    [TaxID]                     VARCHAR (50)    NULL,
    [ContactFirstName]          VARCHAR (50)    NULL,
    [ContactLastName]           VARCHAR (50)    NULL,
    [ContactTitle]              VARCHAR (20)    NULL,
    [ContactPhone]              VARCHAR (20)    NULL,
    [ContactFax]                VARCHAR (20)    NULL,
    [ContactEmail]              NVARCHAR (256)  NULL,
    [ContractSignDate]          DATETIME        NULL,
    [ContractCreatedDate]       DATETIME        NULL,
    [GPSLat]                    FLOAT (53)      NULL,
    [GPSLong]                   FLOAT (53)      NULL,
    [LanguageID]                INT             NULL,
    [EmailPreference]           INT             NULL,
    [NumberOfAccounts]          INT             NULL,
    [ServiceAccountID]          INT             NOT NULL,
    [ServiceAccountNumber]      VARCHAR (36)    NOT NULL,
    [ServiceAccountName]        VARCHAR (100)   NULL,
    [EstimatedUsage]            INT             NULL,
    [FlowStartMonth]            DATETIME        NOT NULL,
    [ContractTerm]              INT             NOT NULL,
    [RateID]                    INT             NOT NULL,
    [TransferRate]              DECIMAL (12, 5) NOT NULL,
    [PartnerMarkup]             DECIMAL (12, 5) NOT NULL,
    [ServiceAddress1]           VARCHAR (50)    NOT NULL,
    [ServiceAddress2]           VARCHAR (50)    NULL,
    [ServiceCity]               VARCHAR (30)    NOT NULL,
    [ServiceState]              CHAR (2)        NOT NULL,
    [ServiceZip]                CHAR (10)       NOT NULL,
    [BillingSameAsService]      BIT             NOT NULL,
    [BillingAccountNumber]      VARCHAR (20)    NULL,
    [BillingAddress1]           VARCHAR (50)    NULL,
    [BillingAddress2]           VARCHAR (50)    NULL,
    [BillingCity]               VARCHAR (30)    NULL,
    [BillingState]              CHAR (2)        NULL,
    [BillingZip]                CHAR (10)       NULL,
    [UtilityNameKey]            CHAR (20)       NULL,
    [FlowStartDate]             DATETIME        NULL,
    [FlowEndDate]               DATETIME        NULL,
    [ZoneCode]                  VARCHAR (50)    NULL,
    [ContractNBR]               VARCHAR (20)    NULL,
    [AccountID]                 VARCHAR (20)    NULL,
    [DealCaptureStatus]         INT             NULL,
    [DealCaptureErrorCode]      VARCHAR (50)    NULL,
    [AgreementVersion]          VARCHAR (50)    NULL,
    [AttachmentVersion]         VARCHAR (50)    NULL,
    [TermsAndConditionsVersion] VARCHAR (50)    NULL,
    [ModDate]                   DATETIME        NULL
);


GO
CREATE NONCLUSTERED INDEX [idx2]
    ON [dbo].[T_GenieImport]([ContractNBR] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_T_GenieImport]
    ON [dbo].[T_GenieImport]([ContractID] ASC);

