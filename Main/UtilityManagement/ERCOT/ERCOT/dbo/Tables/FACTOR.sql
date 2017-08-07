CREATE TABLE [dbo].[FACTOR] (
    [FACTOR_ID]              INT          NOT NULL,
    [OPCOCODE]               VARCHAR (64) NULL,
    [JURISCODE]              VARCHAR (64) NULL,
    [FACTOR_CODE]            VARCHAR (64) NOT NULL,
    [FACTOR_NAME]            VARCHAR (64) NOT NULL,
    [MEASUREMENT_UNITS_CODE] VARCHAR (64) NULL,
    [TRANSACTION_DATE]       DATETIME     NULL,
    CONSTRAINT [PK_FCTR2_8] PRIMARY KEY CLUSTERED ([FACTOR_ID] ASC),
    CONSTRAINT [FK_FCTR2_MSRMNTNTS817] FOREIGN KEY ([MEASUREMENT_UNITS_CODE]) REFERENCES [dbo].[MEASUREMENT_UNITS] ([MEASUREMENT_UNITS_CODE])
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This table represents various factors that can be used in various calculations performed by Lodestar applications. These can range from tax rates, to flat charges, to charges associated with block rates.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FACTOR';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The unique numeric identifier for the various factors that can be used in various calculations performed by Lodestar applications. These can range from tax rates, to flat charges, to charges associated with block ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FACTOR', @level2type = N'COLUMN', @level2name = N'FACTOR_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies an operating company.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FACTOR', @level2type = N'COLUMN', @level2name = N'OPCOCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies the ERCOT jurisdiction boundary.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FACTOR', @level2type = N'COLUMN', @level2name = N'JURISCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The unique alpha numeric identifier for the various factors that can be used in various calculations performed by Lodestar applications. These can range from tax rates, to flat charges, to charges associated wit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FACTOR', @level2type = N'COLUMN', @level2name = N'FACTOR_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The long name for the various factors that can be used in various calculations performed by Lodestar applications. These can range from tax rates, to flat charges, to charges associated with block rates.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FACTOR', @level2type = N'COLUMN', @level2name = N'FACTOR_NAME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies the unit of measue.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FACTOR', @level2type = N'COLUMN', @level2name = N'MEASUREMENT_UNITS_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'FACTOR', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';

