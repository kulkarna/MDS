CREATE TABLE [dbo].[AccountIcap] (
    [ID]           INT             IDENTITY (1, 1) NOT NULL,
    [AccountID]    INT             NOT NULL,
    [DataSourceID] INT             NOT NULL,
    [StartDate]    DATETIME        NULL,
    [EndDate]      DATETIME        NULL,
    [ICapValue]    DECIMAL (18, 4) NULL,
    [Created]      DATETIME        CONSTRAINT [DF_AccountIcap_Created] DEFAULT (getdate()) NOT NULL,
    [UserID]       INT             NOT NULL,
    [Modified]     DATETIME        NULL,
    CONSTRAINT [PK_AccountIcap] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_AccountIcap_Account] FOREIGN KEY ([AccountID]) REFERENCES [dbo].[Account] ([AccountID]),
    CONSTRAINT [FK_AccountIcap_DataSource] FOREIGN KEY ([DataSourceID]) REFERENCES [dbo].[DataSource] ([ID])
);

