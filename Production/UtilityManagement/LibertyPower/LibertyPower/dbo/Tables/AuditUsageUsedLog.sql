CREATE TABLE [dbo].[AuditUsageUsedLog] (
    [ID]           INT           IDENTITY (100, 1) NOT NULL,
    [Namespace]    VARCHAR (50)  NOT NULL,
    [Method]       VARCHAR (50)  NOT NULL,
    [ErrorNumber]  INT           NULL,
    [ErrorMessage] VARCHAR (500) NULL,
    [Comment]      VARCHAR (500) NULL,
    [Created]      DATETIME      CONSTRAINT [DF_AuditUsageUsedLog_Created] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    VARCHAR (50)  NULL,
    CONSTRAINT [PK_AuditUsageUsedLog] PRIMARY KEY NONCLUSTERED ([ID] ASC)
);


GO
CREATE CLUSTERED INDEX [cidx_created_ID]
    ON [dbo].[AuditUsageUsedLog]([Created] ASC, [ID] ASC) WITH (FILLFACTOR = 95);

