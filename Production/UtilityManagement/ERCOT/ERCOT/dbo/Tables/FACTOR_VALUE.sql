CREATE TABLE [dbo].[FACTOR_VALUE] (
    [FACTOR_ID]        INT      NOT NULL,
    [START_TIME]       DATETIME NOT NULL,
    [VALUE]            INT      NULL,
    [PRORATEMETHOD]    CHAR (1) NULL,
    [TRANSACTION_DATE] DATETIME NULL,
    CONSTRAINT [PK_FCTRVL6_9] PRIMARY KEY CLUSTERED ([FACTOR_ID] ASC, [START_TIME] ASC),
    CONSTRAINT [FK_FCTRVL6_FCTR28] FOREIGN KEY ([FACTOR_ID]) REFERENCES [dbo].[FACTOR] ([FACTOR_ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This table represents various factors that can be used in various calculations performed by Lodestar applications. These can range from tax rates, to flat charges, to charges associated with block rates.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FACTOR_VALUE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The unique numeric identifier for the various factors that can be used in various calculations performed by Lodestar applications. These can range from tax rates, to flat charges, to charges associated with ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FACTOR_VALUE', @level2type = N'COLUMN', @level2name = N'FACTOR_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FACTOR_VALUE', @level2type = N'COLUMN', @level2name = N'START_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The factor value.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FACTOR_VALUE', @level2type = N'COLUMN', @level2name = N'VALUE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The proration method for applying the factor.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FACTOR_VALUE', @level2type = N'COLUMN', @level2name = N'PRORATEMETHOD';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FACTOR_VALUE', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';

