CREATE TABLE [dbo].[zAuditSalesChannelAccountType] (
    [zAuditID]            INT           IDENTITY (1, 1) NOT NULL,
    [ChannelID]           INT           NULL,
    [AccountTypeID]       INT           NULL,
    [MarketID]            INT           NULL,
    [AuditChangeType]     CHAR (3)      NOT NULL,
    [AuditChangeDate]     DATETIME      CONSTRAINT [DFzAuditSalesChannelAccountTypeChangeDate] DEFAULT (getdate()) NOT NULL,
    [AuditChangeBy]       VARCHAR (30)  CONSTRAINT [DFzAuditSalesChannelAccountTypeChangeBy] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [AuditChangeLocation] VARCHAR (30)  CONSTRAINT [DFzAuditSalesChannelAccountTypeChangeLocation] DEFAULT (substring(host_name(),(1),(30))) NOT NULL,
    [ColumnsUpdated]      VARCHAR (MAX) NULL,
    [ColumnsChanged]      VARCHAR (MAX) NULL,
    CONSTRAINT [PK_zAuditSalesChannelAccountType] PRIMARY KEY CLUSTERED ([zAuditID] ASC)
);

