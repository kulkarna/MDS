CREATE TABLE [dbo].[zAuditAccountStatus] (
    [zAuditAccountStatusID] INT           IDENTITY (1, 1) NOT NULL,
    [AccountStatusID]       INT           NOT NULL,
    [AccountContractID]     INT           NOT NULL,
    [Status]                VARCHAR (15)  NOT NULL,
    [SubStatus]             VARCHAR (15)  NOT NULL,
    [Modified]              DATETIME      NOT NULL,
    [ModifiedBy]            INT           NOT NULL,
    [DateCreated]           DATETIME      NOT NULL,
    [CreatedBy]             INT           NOT NULL,
    [AuditChangeType]       CHAR (3)      NOT NULL,
    [AuditChangeDate]       DATETIME      CONSTRAINT [DFzAuditAccountStatusAuditChangeDate] DEFAULT (getdate()) NOT NULL,
    [AuditChangeBy]         VARCHAR (30)  CONSTRAINT [DFzAuditAccountStatusAuditChangeBy] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [AuditChangeLocation]   VARCHAR (30)  CONSTRAINT [DFzAuditAccountStatusAuditChangeLocation] DEFAULT (substring(host_name(),(1),(30))) NOT NULL,
    [ColumnsUpdated]        VARCHAR (MAX) NULL,
    [ColumnsChanged]        VARCHAR (MAX) NULL
);


GO
CREATE NONCLUSTERED INDEX [NDX_zAuditAccountStatusAuditChangeDate]
    ON [dbo].[zAuditAccountStatus]([AuditChangeDate] ASC);

