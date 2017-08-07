CREATE TABLE [dbo].[AuditUsageUsed] (
    [AuditUsageUsedID] INT          IDENTITY (1, 1) NOT NULL,
    [AccountNumber]    VARCHAR (50) NOT NULL,
    [RowId]            BIGINT       NOT NULL,
    [TriggeringEvent]  VARCHAR (80) NOT NULL,
    [Created]          DATETIME     CONSTRAINT [DF_AuditUsageUsed_Created] DEFAULT (getdate()) NULL,
    [CreatedBy]        VARCHAR (30) NULL,
    CONSTRAINT [PK_AuditUsageUsed] PRIMARY KEY CLUSTERED ([AuditUsageUsedID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_AuditUsageUsed_3]
    ON [dbo].[AuditUsageUsed]([AccountNumber] ASC, [Created] ASC)
    INCLUDE([RowId]);


GO
CREATE NONCLUSTERED INDEX [IX_AuditUsageUsed_4]
    ON [dbo].[AuditUsageUsed]([Created] ASC)
    INCLUDE([RowId]);


GO
CREATE NONCLUSTERED INDEX [IX_AuditUsageUsed_5]
    ON [dbo].[AuditUsageUsed]([RowId] ASC)
    INCLUDE([Created]);

