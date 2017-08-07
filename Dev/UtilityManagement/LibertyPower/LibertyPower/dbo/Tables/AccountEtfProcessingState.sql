CREATE TABLE [dbo].[AccountEtfProcessingState] (
    [EtfProcessingStateID] INT          NOT NULL,
    [Name]                 VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_AccountEtfProcessingState] PRIMARY KEY CLUSTERED ([EtfProcessingStateID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountEtfProcessingState';

