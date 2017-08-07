CREATE TABLE [dbo].[CONGESTION_MGMT_ZONES] (
    [CONGESTION_MGT_ZONE_CODE] VARCHAR (64) NOT NULL,
    [CONGESTION_MGT_ZONE_NAME] VARCHAR (64) NOT NULL,
    [START_TIME]               DATETIME     NOT NULL,
    [STOP_TIME]                DATETIME     NULL,
    [TRANSACTION_DATE]         DATETIME     NULL,
    CONSTRAINT [PK_CNGSTNMGM8_3] PRIMARY KEY CLUSTERED ([CONGESTION_MGT_ZONE_CODE] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'An area of management of scheduled power transfers across a congested transmission path to ensure both system relaibility and effective utilization of the transmission system.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONGESTION_MGMT_ZONES';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies an ERCOT congestion management zone.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONGESTION_MGMT_ZONES', @level2type = N'COLUMN', @level2name = N'CONGESTION_MGT_ZONE_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The long name for an ERCOT congestion management zone.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONGESTION_MGMT_ZONES', @level2type = N'COLUMN', @level2name = N'CONGESTION_MGT_ZONE_NAME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row takes effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONGESTION_MGMT_ZONES', @level2type = N'COLUMN', @level2name = N'START_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row is no longer in effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONGESTION_MGMT_ZONES', @level2type = N'COLUMN', @level2name = N'STOP_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CONGESTION_MGMT_ZONES', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';

