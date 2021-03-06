USE [Lp_transactions]
GO

PRINT N'Creating [dbo].[UsageAccountStatusMessages]...';


GO
CREATE TABLE [dbo].[UsageAccountStatusMessages] (
    [Message]                   VARCHAR (255) NOT NULL,
    [IsRejection]               BIT           NOT NULL,
    [IsAcceptance]              BIT           NOT NULL,
    [IsAcceptanceInformational] BIT           NOT NULL,
    [IsAcceptanceIdrAvailable]  BIT           NOT NULL,
    [Description]               VARCHAR (255) NULL,
    CONSTRAINT [PK_UsageAccountStatusMessages] PRIMARY KEY CLUSTERED ([Message] ASC)
);


GO
PRINT N'Creating [dbo].[UsageEventsAggregate]...';


GO
CREATE TABLE [dbo].[UsageEventsAggregate] (
    [Id]            BIGINT        IDENTITY (1, 1) NOT NULL,
    [CorrelationId] BIGINT        NULL,
    [TimeSent]      DATETIME      NOT NULL,
    [MessageType]   VARCHAR (255) NOT NULL,
    [Body]          VARCHAR (MAX) NOT NULL,
    [Processing]    BIT           NOT NULL,
    [ProcessedAt]   DATETIME      NULL,
    [ErrorMessage]  VARCHAR (MAX) NULL,
    CONSTRAINT [PK_UsageEventsAggregate] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
PRINT N'Creating [dbo].[UsageEventsAggregate].[IX_MessageType_Processing]...';


GO
CREATE NONCLUSTERED INDEX [IX_MessageType_Processing]
    ON [dbo].[UsageEventsAggregate]([MessageType] ASC, [Processing] ASC);


GO
PRINT N'Creating [dbo].[UsageEventsTransaction]...';


GO
CREATE TABLE [dbo].[UsageEventsTransaction] (
    [TransactionId] BIGINT        IDENTITY (1, 1) NOT NULL,
    [TimeStamp]     DATETIME      NOT NULL,
    [AccountNumber] VARCHAR(255)     NOT NULL,
    [UtilityCode]   VARCHAR(255)     NOT NULL,
    [IsComplete]    BIT           CONSTRAINT [DF_UsageEventsTransaction_IsComplete] DEFAULT ((0)) NOT NULL,
    [Error]         VARCHAR (MAX) NULL,
    [Source] VARCHAR(255) NULL, 
    CONSTRAINT [PK_UsageEventsTransaction] PRIMARY KEY CLUSTERED ([TransactionId] ASC)
);


GO
PRINT N'Creating [dbo].[UsageEventsTransaction].[IX_Transactions_Account]...';


GO
CREATE NONCLUSTERED INDEX [IX_Transactions_Account]
    ON [dbo].[UsageEventsTransaction]([TransactionId] ASC);


GO
PRINT N'Creating Default Constraint on [dbo].[UsageAccountStatusMessages]....';


GO
ALTER TABLE [dbo].[UsageAccountStatusMessages]
    ADD DEFAULT 0 FOR [IsRejection];


GO
PRINT N'Creating Default Constraint on [dbo].[UsageAccountStatusMessages]....';


GO
ALTER TABLE [dbo].[UsageAccountStatusMessages]
    ADD DEFAULT 0 FOR [IsAcceptance];


GO
PRINT N'Creating Default Constraint on [dbo].[UsageAccountStatusMessages]....';


GO
ALTER TABLE [dbo].[UsageAccountStatusMessages]
    ADD DEFAULT 0 FOR [IsAcceptanceInformational];


GO
PRINT N'Creating Default Constraint on [dbo].[UsageAccountStatusMessages]....';


GO
ALTER TABLE [dbo].[UsageAccountStatusMessages]
    ADD DEFAULT 0 FOR [IsAcceptanceIdrAvailable];


GO
PRINT N'Creating DF_UsageEventsAggregate_Processing...';


GO
ALTER TABLE [dbo].[UsageEventsAggregate]
    ADD CONSTRAINT [DF_UsageEventsAggregate_Processing] DEFAULT ((0)) FOR [Processing];


GO
PRINT N'Creating DF_UsageEventsTransaction_IsComplete...';


GO
ALTER TABLE [dbo].[UsageEventsTransaction]
    ADD CONSTRAINT [DF_UsageEventsTransaction_IsComplete] DEFAULT ((0)) FOR [IsComplete];


GO

CREATE TYPE [dbo].[UsageEvents_MessageType] AS TABLE(
	[MessageType] [varchar](255) NULL
)
GO

