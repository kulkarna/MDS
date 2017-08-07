CREATE TABLE [dbo].[CONGESTION_COST] (
    [CSC_TRANMISSION_PATH_CODE] VARCHAR (64) NOT NULL,
    [CHARGE_TYPE_ID]            INT          NOT NULL,
    [TRADE_DATE]                DATETIME     NOT NULL,
    [AMOUNT]                    INT          NOT NULL,
    [TRANSACTION_DATE]          DATETIME     NULL,
    [INTERVAL_ID]               INT          NOT NULL,
    CONSTRAINT [PK_CNGSTNCST6_2] PRIMARY KEY CLUSTERED ([CSC_TRANMISSION_PATH_CODE] ASC, [CHARGE_TYPE_ID] ASC, [TRADE_DATE] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Table reflects the the cost incured to remove congestion.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONGESTION_COST';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies a commercially significant constraint transmission path between two adjacent congestion management zones.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONGESTION_COST', @level2type = N'COLUMN', @level2name = N'CSC_TRANMISSION_PATH_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This id identifies the charge type.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONGESTION_COST', @level2type = N'COLUMN', @level2name = N'CHARGE_TYPE_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row takes effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONGESTION_COST', @level2type = N'COLUMN', @level2name = N'TRADE_DATE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'AMOUNT', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONGESTION_COST', @level2type = N'COLUMN', @level2name = N'AMOUNT';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONGESTION_COST', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This INT uniquely defines the unique combination of market participants, resources, and bill determinants that define a settlement, load, or generation channel.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONGESTION_COST', @level2type = N'COLUMN', @level2name = N'INTERVAL_ID';

