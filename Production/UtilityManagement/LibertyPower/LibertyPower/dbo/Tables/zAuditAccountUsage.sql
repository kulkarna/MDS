CREATE TABLE [dbo].[zAuditAccountUsage] (
    [zAuditAccountUsage]  INT           IDENTITY (1, 1) NOT NULL,
    [AccountUsageID]      INT           NOT NULL,
    [AccountID]           INT           NOT NULL,
    [AnnualUsage]         INT           NULL,
    [UsageReqStatusID]    INT           NOT NULL,
    [EffectiveDate]       DATETIME      NOT NULL,
    [Modified]            DATETIME      NOT NULL,
    [ModifiedBy]          INT           NULL,
    [DateCreated]         DATETIME      NOT NULL,
    [CreatedBy]           INT           NULL,
    [AuditChangeType]     CHAR (3)      NOT NULL,
    [AuditChangeDate]     DATETIME      CONSTRAINT [DFzAuditAccountUsageAuditChangeDate] DEFAULT (getdate()) NOT NULL,
    [AuditChangeBy]       VARCHAR (30)  CONSTRAINT [DFzAuditAccountUsageAuditChangeBy] DEFAULT (substring(suser_sname(),(1),(30))) NOT NULL,
    [AuditChangeLocation] VARCHAR (30)  CONSTRAINT [DFzAuditAccountUsageAuditChangeLocation] DEFAULT (substring(host_name(),(1),(30))) NOT NULL,
    [ColumnsUpdated]      VARCHAR (MAX) NULL,
    [ColumnsChanged]      VARCHAR (MAX) NULL
);


GO
CREATE NONCLUSTERED INDEX [NDX_zAuditAccountUsageChangeDate]
    ON [dbo].[zAuditAccountUsage]([AuditChangeDate] ASC);

