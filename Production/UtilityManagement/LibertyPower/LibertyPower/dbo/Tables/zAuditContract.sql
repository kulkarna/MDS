CREATE TABLE [dbo].[zAuditContract] (
    [zAuditContractID]    INT           IDENTITY (1, 1) NOT NULL,
    [ContractID]          INT           NOT NULL,
    [Number]              VARCHAR (50)  NOT NULL,
    [ContractTypeID]      INT           NOT NULL,
    [ContractDealTypeID]  INT           NOT NULL,
    [ContractStatusID]    INT           NOT NULL,
    [ContractTemplateID]  INT           NOT NULL,
    [ReceiptDate]         DATETIME      NULL,
    [StartDate]           DATETIME      NOT NULL,
    [EndDate]             DATETIME      NOT NULL,
    [SignedDate]          DATETIME      NOT NULL,
    [SubmitDate]          DATETIME      NOT NULL,
    [SalesChannelID]      INT           NOT NULL,
    [SalesRep]            VARCHAR (64)  NULL,
    [SalesManagerID]      INT           NULL,
    [PricingTypeID]       INT           NULL,
    [Modified]            DATETIME      NOT NULL,
    [ModifiedBy]          INT           NOT NULL,
    [DateCreated]         DATETIME      NOT NULL,
    [CreatedBy]           INT           NOT NULL,
    [IsFutureContract]    BIT           NULL,
    [MigrationComplete]   BIT           NOT NULL,
    [AuditChangeType]     CHAR (3)      NOT NULL,
    [AuditChangeDate]     DATETIME      CONSTRAINT [DFzAuditContractAuditChangeDate] DEFAULT (getdate()) NOT NULL,
    [AuditChangeBy]       VARCHAR (30)  CONSTRAINT [DFzAuditContractAuditChangeBy] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [AuditChangeLocation] VARCHAR (30)  CONSTRAINT [DFzAuditContractAuditChangeLocation] DEFAULT (substring(host_name(),(1),(30))) NOT NULL,
    [ColumnsUpdated]      VARCHAR (MAX) NULL,
    [ColumnsChanged]      VARCHAR (MAX) NULL
);


GO
CREATE NONCLUSTERED INDEX [NDX_zAuditContractAuditChangeDate]
    ON [dbo].[zAuditContract]([AuditChangeDate] ASC);

