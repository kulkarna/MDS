CREATE TABLE [dbo].[CreditScoreHistory] (
    [CreditScoreHistoryID] INT            IDENTITY (1, 1) NOT NULL,
    [CustomerName]         VARCHAR (100)  NULL,
    [StreetAddress]        VARCHAR (100)  NULL,
    [City]                 VARCHAR (100)  NULL,
    [State]                CHAR (2)       NULL,
    [ZipCode]              NCHAR (15)     NULL,
    [DateAcquired]         DATETIME       NULL,
    [AgencyReferenceID]    VARCHAR (20)   NULL,
    [CreditAgencyID]       INT            NULL,
    [Score]                NUMERIC (8, 2) NULL,
    [ScoreType]            VARCHAR (30)   NULL,
    [FullXMLReport]        NVARCHAR (MAX) NULL,
    [Source]               VARCHAR (30)   NULL,
    [CustomerID]           INT            NULL,
    [Contract_nbr]         CHAR (30)      NULL,
    [Account_nbr]          CHAR (30)      NULL,
    [Username]             VARCHAR (50)   NULL,
    [DateCreated]          DATETIME       NULL,
    [CreditScoreEncrypted] NVARCHAR (512) NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'Credit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CreditScoreHistory';

