﻿CREATE TABLE [dbo].[DIRECT_CURRENT_TIE_LINE] (
    [DIRECT_CURRENT_TIE_LINE_CODE] VARCHAR (64) NOT NULL,
    [DIRECT_CURRENT_TIE_LINE_NAME] VARCHAR (64) NOT NULL,
    [START_TIME]                   DATETIME     NOT NULL,
    [STOP_TIME]                    DATETIME     NULL,
    [TRANSACTION_DATE]             DATETIME     NULL,
    CONSTRAINT [PK_DRCTCRRNT11_7] PRIMARY KEY CLUSTERED ([DIRECT_CURRENT_TIE_LINE_CODE] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'A direct current non-synchronous transmission connection between ERCOT and non-ERCOTelectric power systems.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DIRECT_CURRENT_TIE_LINE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies a direct current non-synchronous transmission connection between ERCOT and non-ERCOTelectric power systems.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DIRECT_CURRENT_TIE_LINE', @level2type = N'COLUMN', @level2name = N'DIRECT_CURRENT_TIE_LINE_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The long name that uniquely identifies a direct current non-synchronous transmission connection between ERCOT and non-ERCOTelectric power systems.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DIRECT_CURRENT_TIE_LINE', @level2type = N'COLUMN', @level2name = N'DIRECT_CURRENT_TIE_LINE_NAME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row takes effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DIRECT_CURRENT_TIE_LINE', @level2type = N'COLUMN', @level2name = N'START_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row is no longer in effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DIRECT_CURRENT_TIE_LINE', @level2type = N'COLUMN', @level2name = N'STOP_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DIRECT_CURRENT_TIE_LINE', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';

