CREATE TABLE [dbo].[zAuditAccount] (
    [zAuditAccountID]          INT           IDENTITY (1, 1) NOT NULL,
    [AccountID]                INT           NULL,
    [AccountIdLegacy]          CHAR (12)     NULL,
    [AccountNumber]            VARCHAR (30)  NULL,
    [AccountTypeID]            INT           NULL,
    [CustomerID]               INT           NULL,
    [CustomerIdLegacy]         VARCHAR (10)  NULL,
    [EntityID]                 CHAR (15)     NULL,
    [RetailMktID]              INT           NULL,
    [UtilityID]                INT           NULL,
    [AccountNameID]            INT           NULL,
    [BillingAddressID]         INT           NULL,
    [BillingContactID]         INT           NULL,
    [ServiceAddressID]         INT           NULL,
    [Origin]                   VARCHAR (50)  NULL,
    [TaxStatusID]              INT           NULL,
    [PorOption]                BIT           NULL,
    [BillingTypeID]            INT           NULL,
    [Zone]                     VARCHAR (50)  NULL,
    [ServiceRateClass]         VARCHAR (50)  NULL,
    [StratumVariable]          VARCHAR (15)  NULL,
    [BillingGroup]             VARCHAR (15)  NULL,
    [Icap]                     VARCHAR (15)  NULL,
    [Tcap]                     VARCHAR (15)  NULL,
    [LoadProfile]              VARCHAR (50)  NULL,
    [LossCode]                 VARCHAR (15)  NULL,
    [MeterTypeID]              INT           NULL,
    [CurrentContractID]        INT           NULL,
    [CurrentRenewalContractID] INT           NULL,
    [Modified]                 DATETIME      NULL,
    [ModifiedBy]               INT           NULL,
    [DateCreated]              DATETIME      NULL,
    [CreatedBy]                INT           NULL,
    [MigrationComplete]        BIT           NULL,
    [AuditChangeType]          CHAR (3)      NOT NULL,
    [AuditChangeDate]          DATETIME      CONSTRAINT [DFzAuditAccountAuditChangeDate] DEFAULT (getdate()) NOT NULL,
    [AuditChangeBy]            VARCHAR (30)  CONSTRAINT [DFzAuditAccountAuditChangeBy] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [AuditChangeLocation]      VARCHAR (30)  CONSTRAINT [DFzAuditAccountAuditChangeLocation] DEFAULT (substring(host_name(),(1),(30))) NOT NULL,
    [ColumnsUpdated]           VARCHAR (MAX) NULL,
    [ColumnsChanged]           VARCHAR (MAX) NULL,
    [LoadProfileRefID]         INT           NULL
);


GO
CREATE NONCLUSTERED INDEX [NDX_zAuditAccountAuditChangeDate]
    ON [dbo].[zAuditAccount]([AuditChangeDate] ASC);


GO
CREATE NONCLUSTERED INDEX [idx1]
    ON [dbo].[zAuditAccount]([zAuditAccountID] ASC) WITH (FILLFACTOR = 100);

