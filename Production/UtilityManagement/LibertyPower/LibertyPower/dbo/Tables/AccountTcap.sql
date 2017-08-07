CREATE TABLE [dbo].[AccountTcap] (
    [ID]           INT             IDENTITY (1, 1) NOT NULL,
    [AccountID]    INT             NOT NULL,
    [DataSourceID] INT             NOT NULL,
    [StartDate]    DATETIME        NULL,
    [EndDate]      DATETIME        NULL,
    [TcapValue]    DECIMAL (18, 4) NULL,
    [Created]      DATETIME        CONSTRAINT [DF_AccountTcap_Created] DEFAULT (getdate()) NOT NULL,
    [UserID]       INT             NOT NULL,
    [Modified]     DATETIME        NULL,
    CONSTRAINT [PK_AccountTcap] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_AccountTcap_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID]),
    CONSTRAINT [FK_AccountTcap_DataSource] FOREIGN KEY ([DataSourceID]) REFERENCES [dbo].[DataSource] ([ID])
);

