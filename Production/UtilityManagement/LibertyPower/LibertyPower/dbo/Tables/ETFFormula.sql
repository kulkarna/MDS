CREATE TABLE [dbo].[ETFFormula] (
    [EtfFormulaId] INT           IDENTITY (1, 1) NOT NULL,
    [FormulaName]  VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_ETFFormula] PRIMARY KEY CLUSTERED ([EtfFormulaId] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'ETF', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ETFFormula';

