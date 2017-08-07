CREATE TABLE [dbo].[CSC_TRANSMISSION_PATH] (
    [CSC_TRANSMISSION_PATH_CODE] VARCHAR (64) NOT NULL,
    [CSC_TRANSMISSION_PATH_NAME] VARCHAR (64) NOT NULL,
    [TRANSACTION_DATE]           DATETIME     NULL,
    [START_TIME]                 DATETIME     NOT NULL,
    [STOP_TIME]                  DATETIME     NULL,
    CONSTRAINT [PK_CSCTRNSMS7_4] PRIMARY KEY CLUSTERED ([CSC_TRANSMISSION_PATH_CODE] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Records the transmission path between commercially significant constraint zones.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CSC_TRANSMISSION_PATH';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies a commercially significant constraint transmission path between two adjacent congestion management zones.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CSC_TRANSMISSION_PATH', @level2type = N'COLUMN', @level2name = N'CSC_TRANSMISSION_PATH_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The long name for a commercially significant constraint transmission path between two adjacent congestion management zones.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CSC_TRANSMISSION_PATH', @level2type = N'COLUMN', @level2name = N'CSC_TRANSMISSION_PATH_NAME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CSC_TRANSMISSION_PATH', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row takes effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CSC_TRANSMISSION_PATH', @level2type = N'COLUMN', @level2name = N'START_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row is no longer in effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CSC_TRANSMISSION_PATH', @level2type = N'COLUMN', @level2name = N'STOP_TIME';

