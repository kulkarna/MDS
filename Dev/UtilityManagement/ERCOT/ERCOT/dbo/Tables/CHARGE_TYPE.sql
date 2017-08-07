CREATE TABLE [dbo].[CHARGE_TYPE] (
    [CHARGE_TYPE_ID]         INT          NOT NULL,
    [CHARGE_TYPE_CODE]       VARCHAR (32) NOT NULL,
    [CHARGE_TYPE_NAME]       VARCHAR (64) NOT NULL,
    [CONSUMPTION_FLAG]       CHAR (1)     NULL,
    [MEASUREMENT_UNITS_CODE] VARCHAR (64) NULL,
    [UIDRECEIVABLETYPE]      INT          NOT NULL,
    [TRANSACTION_DATE]       DATETIME     NULL,
    [UIDMARKET]              INT          NULL,
    [REPORTINGPRIORITY]      INT          NULL,
    [UIDRATEFORM]            INT          NULL,
    [DETERMLEVEL]            VARCHAR (64) NULL,
    [START_TIME]             DATETIME     NULL,
    [STOP_TIME]              DATETIME     NULL,
    [STMTCAT]                VARCHAR (64) NULL,
    [STMTPRTY]               INT          NULL,
    CONSTRAINT [PK_CHRGTYP4_1] PRIMARY KEY CLUSTERED ([CHARGE_TYPE_ID] ASC),
    CONSTRAINT [FK_CHRGTYP4_MSRMNTNTS815] FOREIGN KEY ([MEASUREMENT_UNITS_CODE]) REFERENCES [dbo].[MEASUREMENT_UNITS] ([MEASUREMENT_UNITS_CODE])
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Defines specific billing charge types.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This id identifies the charge type.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'CHARGE_TYPE_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code identifies the charge type.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'CHARGE_TYPE_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This name identifies the charge type.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'CHARGE_TYPE_NAME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code identifies the consumption.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'CONSUMPTION_FLAG';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies the unit of measue.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'MEASUREMENT_UNITS_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies the rececivable type.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'UIDRECEIVABLETYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies the market.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'UIDMARKET';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Reporting priority.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'REPORTINGPRIORITY';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies the rate form.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'UIDRATEFORM';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code identifies the determinant level.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'DETERMLEVEL';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row takes effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'START_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row is no longer in effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'STOP_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'STMTCAT', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'STMTCAT';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'STMTPRTY', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CHARGE_TYPE', @level2type = N'COLUMN', @level2name = N'STMTPRTY';

