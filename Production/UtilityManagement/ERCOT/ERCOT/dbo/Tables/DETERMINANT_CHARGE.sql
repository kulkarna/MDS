CREATE TABLE [dbo].[DETERMINANT_CHARGE] (
    [DETERMINANT_ID]   INT          NOT NULL,
    [CHARGE_TYPE_ID]   INT          NOT NULL,
    [START_TIME]       DATETIME     NOT NULL,
    [STOP_TIME]        DATETIME     NULL,
    [FORMULATYPE]      VARCHAR (64) NULL,
    [PRIORITY]         INT          NULL,
    [TRANSACTION_DATE] DATETIME     NULL,
    CONSTRAINT [PK_DTRMNNTCH7_6] PRIMARY KEY CLUSTERED ([DETERMINANT_ID] ASC, [CHARGE_TYPE_ID] ASC, [START_TIME] ASC),
    CONSTRAINT [FK_DTRMNNTCH7_CHRGTYP41] FOREIGN KEY ([CHARGE_TYPE_ID]) REFERENCES [dbo].[CHARGE_TYPE] ([CHARGE_TYPE_ID]),
    CONSTRAINT [FK_DTRMNNTCH7_DTRMNNT44] FOREIGN KEY ([DETERMINANT_ID]) REFERENCES [dbo].[DETERMINANT] ([DETERMINANT_ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Houses bill determinants used for charges.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT_CHARGE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This INT uniquely identifies the bill determinant used for calculating settlements and billings.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT_CHARGE', @level2type = N'COLUMN', @level2name = N'DETERMINANT_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This INT uniquely identifies the bill determinant used for calculating settlements and billings.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT_CHARGE', @level2type = N'COLUMN', @level2name = N'CHARGE_TYPE_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row takes effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT_CHARGE', @level2type = N'COLUMN', @level2name = N'START_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row is no longer in effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT_CHARGE', @level2type = N'COLUMN', @level2name = N'STOP_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Formula Type.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT_CHARGE', @level2type = N'COLUMN', @level2name = N'FORMULATYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Priority.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT_CHARGE', @level2type = N'COLUMN', @level2name = N'PRIORITY';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DETERMINANT_CHARGE', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';

