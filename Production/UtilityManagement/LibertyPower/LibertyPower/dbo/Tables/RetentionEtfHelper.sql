CREATE TABLE [dbo].[RetentionEtfHelper] (
    [AccountID]         INT NOT NULL,
    [RetentionDetailID] INT NOT NULL,
    [EtfID]             INT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'RetentionEtfHelper';

