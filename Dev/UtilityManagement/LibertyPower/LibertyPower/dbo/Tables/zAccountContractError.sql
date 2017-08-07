CREATE TABLE [dbo].[zAccountContractError] (
    [zAccountContractErrorID] INT           IDENTITY (1, 1) NOT NULL,
    [AccountID]               INT           NULL,
    [ContractID]              INT           NULL,
    [AccountContractID]       INT           NULL,
    [AccountIDLegacy]         CHAR (12)     NULL,
    [ColumnName]              VARCHAR (50)  NULL,
    [ColumnValue]             VARCHAR (50)  NULL,
    [Message]                 VARCHAR (256) NULL,
    [BatchId]                 INT           NULL,
    [DateCreated]             DATETIME      CONSTRAINT [DF_zAccountContractError_DateCreated] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_zAccountContractError] PRIMARY KEY CLUSTERED ([zAccountContractErrorID] ASC)
);

