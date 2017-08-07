CREATE TABLE [dbo].[AccountEtfCalculationVariable] (
    [EtfCalculationVariableID] INT    IDENTITY (1, 1) NOT NULL,
    [EtfID]                    INT    NOT NULL,
    [AccountCount]             INT    NOT NULL,
    [AverageAnnualConsumption] BIGINT NOT NULL,
    CONSTRAINT [PK_AccountEtfCalculationVariable] PRIMARY KEY CLUSTERED ([EtfCalculationVariableID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_AccountEtfCalculationVariable_AccountEtf] FOREIGN KEY ([EtfID]) REFERENCES [dbo].[AccountEtf] ([EtfID])
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AccountEtfCalculationVariable';

