CREATE TABLE [dbo].[zAuditAccountContractCommission] (
    [zAuditAccountContractCommission] INT           IDENTITY (1, 1) NOT NULL,
    [AccountContractCommissionID]     INT           NOT NULL,
    [AccountContractID]               INT           NOT NULL,
    [EvergreenOptionID]               INT           NULL,
    [EvergreenCommissionEnd]          DATETIME      NULL,
    [EvergreenCommissionRate]         FLOAT (53)    NULL,
    [ResidualOptionID]                INT           NULL,
    [ResidualCommissionEnd]           DATETIME      NULL,
    [InitialPymtOptionID]             INT           NULL,
    [Modified]                        DATETIME      NOT NULL,
    [ModifiedBy]                      INT           NOT NULL,
    [DateCreated]                     DATETIME      NOT NULL,
    [CreatedBy]                       INT           NOT NULL,
    [AuditChangeType]                 CHAR (3)      NOT NULL,
    [AuditChangeDate]                 DATETIME      CONSTRAINT [DFzAuditAuditAccountContractCommissionAuditChangeDate] DEFAULT (getdate()) NOT NULL,
    [AuditChangeBy]                   VARCHAR (30)  CONSTRAINT [DFzAuditAuditAccountContractCommissionAuditChangeBy] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [AuditChangeLocation]             VARCHAR (30)  CONSTRAINT [DFzAuditAuditAccountContractCommissionAuditChangeLocation] DEFAULT (substring(host_name(),(1),(30))) NOT NULL,
    [ColumnsUpdated]                  VARCHAR (MAX) NULL,
    [ColumnsChanged]                  VARCHAR (MAX) NULL
);


GO
CREATE NONCLUSTERED INDEX [NDX_zAuditAccountContractCommissionAuditChangeDate]
    ON [dbo].[zAuditAccountContractCommission]([AuditChangeDate] ASC);

