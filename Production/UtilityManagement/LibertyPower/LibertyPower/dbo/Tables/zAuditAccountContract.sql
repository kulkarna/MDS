CREATE TABLE [dbo].[zAuditAccountContract] (
    [zAuditAccountContractID] INT           IDENTITY (1, 1) NOT NULL,
    [AccountContractID]       INT           NOT NULL,
    [AccountID]               INT           NOT NULL,
    [ContractID]              INT           NOT NULL,
    [RequestedStartDate]      DATETIME      NULL,
    [SendEnrollmentDate]      DATETIME      NULL,
    [Modified]                DATETIME      NOT NULL,
    [ModifiedBy]              INT           NOT NULL,
    [DateCreated]             DATETIME      NOT NULL,
    [CreatedBy]               INT           NOT NULL,
    [MigrationComplete]       BIT           NOT NULL,
    [AuditChangeType]         CHAR (3)      NOT NULL,
    [AuditChangeDate]         DATETIME      CONSTRAINT [DFzAuditAccountContractAuditChangeDate] DEFAULT (getdate()) NOT NULL,
    [AuditChangeBy]           VARCHAR (30)  CONSTRAINT [DFzAuditAccountContractAuditChangeBy] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [AuditChangeLocation]     VARCHAR (30)  CONSTRAINT [DFzAuditAccountContractAuditChangeLocation] DEFAULT (substring(host_name(),(1),(30))) NOT NULL,
    [ColumnsUpdated]          VARCHAR (MAX) NULL,
    [ColumnsChanged]          VARCHAR (MAX) NULL,
    [DeliveryLocationRefID]   INT           NULL,
    [SettlementLocationRefID] INT           NULL
);


GO
CREATE NONCLUSTERED INDEX [NDX_zAuditAccountContractAuditChangeDate]
    ON [dbo].[zAuditAccountContract]([AuditChangeDate] ASC);


GO
CREATE NONCLUSTERED INDEX [zAuditAccountContract__AccountID_I]
    ON [dbo].[zAuditAccountContract]([AccountID] ASC)
    INCLUDE([AccountContractID], [ContractID]);

