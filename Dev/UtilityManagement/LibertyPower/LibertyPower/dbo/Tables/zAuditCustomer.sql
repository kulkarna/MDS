CREATE TABLE [dbo].[zAuditCustomer] (
    [zAuditCustomer]       INT            IDENTITY (1, 1) NOT NULL,
    [CustomerID]           INT            NOT NULL,
    [NameID]               INT            NOT NULL,
    [OwnerNameID]          INT            NULL,
    [AddressID]            INT            NULL,
    [ContactID]            INT            NULL,
    [DBA]                  VARCHAR (128)  NULL,
    [Duns]                 VARCHAR (30)   NULL,
    [SsnClear]             NVARCHAR (100) NULL,
    [SsnEncrypted]         NVARCHAR (512) NULL,
    [TaxId]                VARCHAR (30)   NULL,
    [EmployerId]           VARCHAR (30)   NULL,
    [CreditAgencyID]       INT            NULL,
    [CreditScoreEncrypted] NVARCHAR (512) NULL,
    [BusinessTypeID]       INT            NULL,
    [BusinessActivityID]   INT            NULL,
    [ExternalNumber]       VARCHAR (64)   NULL,
    [Modified]             DATETIME       NOT NULL,
    [ModifiedBy]           INT            NOT NULL,
    [DateCreated]          DATETIME       NOT NULL,
    [CreatedBy]            INT            NOT NULL,
    [AuditChangeType]      CHAR (3)       NOT NULL,
    [AuditChangeDate]      DATETIME       CONSTRAINT [DFzAuditCustomerAuditChangeDate] DEFAULT (getdate()) NOT NULL,
    [AuditChangeBy]        VARCHAR (30)   CONSTRAINT [DFzAuditCustomerAuditChangeBy] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [AuditChangeLocation]  VARCHAR (30)   CONSTRAINT [DFzAuditCustomerAuditChangeLocation] DEFAULT (substring(host_name(),(1),(30))) NOT NULL,
    [ColumnsUpdated]       VARCHAR (MAX)  NULL,
    [ColumnsChanged]       VARCHAR (MAX)  NULL
);


GO
CREATE NONCLUSTERED INDEX [NDX_zAuditCustomerAuditChangeDate]
    ON [dbo].[zAuditCustomer]([AuditChangeDate] ASC);

