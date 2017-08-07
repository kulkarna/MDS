CREATE TABLE [dbo].[GENERATION_UNIT_DETERMINANT] (
    [UIDACCOUNT]           INT           NOT NULL,
    [DETERMINANT_ID]       INT           NOT NULL,
    [GENERATION_UNIT_CODE] VARCHAR (64)  NOT NULL,
    [START_TIME]           DATETIME      NOT NULL,
    [STOP_TIME]            DATETIME      NULL,
    [VALUE]                INT           NULL,
    [STARTING_VALUE]       VARCHAR (254) NULL,
    [TRANSACTION_DATE]     DATETIME      NULL,
    CONSTRAINT [PK_GNRTNNTDT13_11] PRIMARY KEY CLUSTERED ([UIDACCOUNT] ASC, [DETERMINANT_ID] ASC, [GENERATION_UNIT_CODE] ASC, [START_TIME] ASC),
    CONSTRAINT [FK_GNRTNNTDT13_DTRMNNT45] FOREIGN KEY ([DETERMINANT_ID]) REFERENCES [dbo].[DETERMINANT] ([DETERMINANT_ID]),
    CONSTRAINT [FK_GNRTNNTDT13_GNRTNNT89] FOREIGN KEY ([GENERATION_UNIT_CODE]) REFERENCES [dbo].[GENERATION_UNIT] ([GENERATION_UNIT_CODE])
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Table houses determinants specific to generation units.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT_DETERMINANT';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This INT uniquely identifies the account  associated with a Market Participant.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT_DETERMINANT', @level2type = N'COLUMN', @level2name = N'UIDACCOUNT';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This INT uniquely identifies the bill determinant used for calculating settlements and billings.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT_DETERMINANT', @level2type = N'COLUMN', @level2name = N'DETERMINANT_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies the fractional ownership of a generator by a power generating company.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT_DETERMINANT', @level2type = N'COLUMN', @level2name = N'GENERATION_UNIT_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row takes effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT_DETERMINANT', @level2type = N'COLUMN', @level2name = N'START_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row is no longer in effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT_DETERMINANT', @level2type = N'COLUMN', @level2name = N'STOP_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Value', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT_DETERMINANT', @level2type = N'COLUMN', @level2name = N'VALUE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Starting Value', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT_DETERMINANT', @level2type = N'COLUMN', @level2name = N'STARTING_VALUE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT_DETERMINANT', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';

