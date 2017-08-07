CREATE TABLE [dbo].[GENERATION_UNIT] (
    [GENERATION_UNIT_CODE] VARCHAR (64) NOT NULL,
    [GENERATION_UNIT_NAME] VARCHAR (64) NOT NULL,
    [START_TIME]           DATETIME     NOT NULL,
    [STOP_TIME]            DATETIME     NULL,
    [TRANSACTION_DATE]     DATETIME     NULL,
    CONSTRAINT [PK_GNRTNNT8_10] PRIMARY KEY CLUSTERED ([GENERATION_UNIT_CODE] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'A subgenerator describes the fractional ownership of a generator  by a power generating company.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies the fractional ownership of a generator by a power generating company.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT', @level2type = N'COLUMN', @level2name = N'GENERATION_UNIT_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This is the long name identifing the fractional ownership of a generator by a power generating company.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT', @level2type = N'COLUMN', @level2name = N'GENERATION_UNIT_NAME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row takes effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT', @level2type = N'COLUMN', @level2name = N'START_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row is no longer in effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT', @level2type = N'COLUMN', @level2name = N'STOP_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'GENERATION_UNIT', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';

