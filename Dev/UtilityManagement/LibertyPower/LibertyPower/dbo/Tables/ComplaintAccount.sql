CREATE TABLE [dbo].[ComplaintAccount] (
    [ComplaintAccountID]   INT            IDENTITY (1, 1) NOT NULL,
    [AccountName]          VARCHAR (300)  NULL,
    [UtilityAccountNumber] VARCHAR (30)   NULL,
    [UtilityID]            INT            NULL,
    [MarketCode]           CHAR (2)       NULL,
    [SalesAgent]           VARCHAR (64)   NULL,
    [SalesChannelID]       INT            NULL,
    [Address]              NVARCHAR (150) NULL,
    [City]                 NVARCHAR (100) NULL,
    [Zip]                  CHAR (10)      NULL,
    [Phone]                VARCHAR (50)   NULL,
    CONSTRAINT [PK_ComplaintAccount] PRIMARY KEY CLUSTERED ([ComplaintAccountID] ASC)
);

