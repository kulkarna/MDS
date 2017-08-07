CREATE TABLE [dbo].[ComplaintDataMigrationErrorLog] (
    [ID]                INT            IDENTITY (1, 1) NOT NULL,
    [LegacyComplaintID] INT            NOT NULL,
    [ComplaintID]       INT            NULL,
    [ErrorDescription]  VARCHAR (1000) NULL,
    CONSTRAINT [PK_ComplaintDataMigrationErrorLog] PRIMARY KEY CLUSTERED ([ID] ASC)
);

