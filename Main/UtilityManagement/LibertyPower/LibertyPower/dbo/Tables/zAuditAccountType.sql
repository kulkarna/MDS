CREATE TABLE [dbo].[zAuditAccountType] (
    [ID]                   INT           NOT NULL,
    [AccountType]          VARCHAR (50)  NOT NULL,
    [Description]          VARCHAR (100) NOT NULL,
    [AccountGroup]         VARCHAR (50)  NULL,
    [DateCreated]          DATETIME      NOT NULL,
    [ProductAccountTypeID] INT           NULL
);

