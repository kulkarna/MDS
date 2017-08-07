CREATE TABLE [dbo].[AccountEtfEndStatus] (
    [EtfEndStatusID] INT          NOT NULL,
    [Name]           VARCHAR (50) NOT NULL,
    [IsErrorStatus]  BIT          CONSTRAINT [DF_AccountEtfEndStatus_IsErrorStatus] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_AccountEtfEndStatus] PRIMARY KEY CLUSTERED ([EtfEndStatusID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountEtfEndStatus';

