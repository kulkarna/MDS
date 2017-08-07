CREATE TABLE [dbo].[MEASUREMENT_UNITS] (
    [MEASUREMENT_UNITS_CODE]    VARCHAR (64) NOT NULL,
    [MEASUREMENT_UNITS_NAME]    VARCHAR (64) NOT NULL,
    [MEASUREMENTS_UNITS_ABBREV] VARCHAR (64) NOT NULL,
    [AGGREGATE]                 CHAR (1)     NOT NULL,
    [TODEMAND]                  INT          NULL,
    [TOTALIZE]                  CHAR (1)     NOT NULL,
    [TRANSACTION_DATE]          DATETIME     NULL,
    CONSTRAINT [PK_MSRMNTNTS8_16] PRIMARY KEY CLUSTERED ([MEASUREMENT_UNITS_CODE] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This table contains the various units of measure.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MEASUREMENT_UNITS';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies the unit of measue.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MEASUREMENT_UNITS', @level2type = N'COLUMN', @level2name = N'MEASUREMENT_UNITS_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This is the long name for the unit of measure.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MEASUREMENT_UNITS', @level2type = N'COLUMN', @level2name = N'MEASUREMENT_UNITS_NAME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Measurement unit.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MEASUREMENT_UNITS', @level2type = N'COLUMN', @level2name = N'MEASUREMENTS_UNITS_ABBREV';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Measurement aggregate.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MEASUREMENT_UNITS', @level2type = N'COLUMN', @level2name = N'AGGREGATE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Total demand.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MEASUREMENT_UNITS', @level2type = N'COLUMN', @level2name = N'TODEMAND';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Totalized flag', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MEASUREMENT_UNITS', @level2type = N'COLUMN', @level2name = N'TOTALIZE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MEASUREMENT_UNITS', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';

