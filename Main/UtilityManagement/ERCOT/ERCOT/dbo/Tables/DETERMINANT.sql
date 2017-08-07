CREATE TABLE [dbo].[DETERMINANT] (
    [DETERMINANT_ID]         INT          NOT NULL,
    [DETERMINANT_CODE]       VARCHAR (64) NULL,
    [CHARGE_TYPE_CODE]       VARCHAR (32) NULL,
    [DETERMINANT_NAME]       VARCHAR (64) NULL,
    [MEASUREMENT_UNITS_CODE] VARCHAR (64) NULL,
    [BILLHISTCOLNAME]        VARCHAR (32) NULL,
    [AGGREGATE]              CHAR (1)     NULL,
    [TRANSACTION_DATE]       DATETIME     NULL,
    [DETERMINANT_TYPE]       VARCHAR (64) NULL,
    [START_TIME]             DATETIME     NULL,
    [STOP_TIME]              DATETIME     NULL,
    [DATAREQUIREMENT]        VARCHAR (3)  NULL,
    [SEVERITY]               VARCHAR (4)  NULL,
    [CMZONEFLAG]             CHAR (1)     NULL,
    CONSTRAINT [PK_DTRMNNT4_5] PRIMARY KEY CLUSTERED ([DETERMINANT_ID] ASC),
    CONSTRAINT [FK_DTRMNNT4_MSRMNTNTS816] FOREIGN KEY ([MEASUREMENT_UNITS_CODE]) REFERENCES [dbo].[MEASUREMENT_UNITS] ([MEASUREMENT_UNITS_CODE])
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Types of billing determinants (such as KWH, KW, KVAR, etc.) that can be used in bill calculations, rate analysis, profiling, aggregation, and settlement.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This INT uniquely identifies the bill determinant used for calculating settlements and billings.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT', @level2type = N'COLUMN', @level2name = N'DETERMINANT_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies the bill determinant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT', @level2type = N'COLUMN', @level2name = N'DETERMINANT_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'An identifier associated with the bill determinant, such as KWH, KW, etc.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT', @level2type = N'COLUMN', @level2name = N'CHARGE_TYPE_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The name the bill determinant represented by the record, such as Metered Energy, Metered Demand, etc.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT', @level2type = N'COLUMN', @level2name = N'DETERMINANT_NAME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies the unit of measue.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT', @level2type = N'COLUMN', @level2name = N'MEASUREMENT_UNITS_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The optional name of the column in a related Bill History record.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT', @level2type = N'COLUMN', @level2name = N'BILLHISTCOLNAME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'A flag that indicates how measurements based on the bill determinant are to be aggregated (Average, Max, or Total).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT', @level2type = N'COLUMN', @level2name = N'AGGREGATE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This column identifies the bill determinant classification. for example, STL for settlement determinants, LOAD for load related determinants, GEN for generation related determinants.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT', @level2type = N'COLUMN', @level2name = N'DETERMINANT_TYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row takes effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT', @level2type = N'COLUMN', @level2name = N'START_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row is no longer in effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT', @level2type = N'COLUMN', @level2name = N'STOP_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Data requirement', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT', @level2type = N'COLUMN', @level2name = N'DATAREQUIREMENT';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Severity code', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT', @level2type = N'COLUMN', @level2name = N'SEVERITY';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Congestion management code required flag.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT', @level2type = N'COLUMN', @level2name = N'CMZONEFLAG';

