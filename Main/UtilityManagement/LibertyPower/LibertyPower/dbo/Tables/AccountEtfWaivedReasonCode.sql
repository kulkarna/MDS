CREATE TABLE [dbo].[AccountEtfWaivedReasonCode] (
    [EtfWaivedReasonCodeID] INT          IDENTITY (1, 1) NOT NULL,
    [Reason]                VARCHAR (30) NOT NULL,
    CONSTRAINT [PK_AccountEtfWaivedReasonCode] PRIMARY KEY CLUSTERED ([EtfWaivedReasonCodeID] ASC) WITH (FILLFACTOR = 90)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountEtfWaivedReasonCode';

