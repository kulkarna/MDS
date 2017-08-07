CREATE TABLE [dbo].[MARKET_INTERVAL] (
    [INTERVAL_ID]      INT      NOT NULL,
    [INTERVAL_CODE]    INT      NOT NULL,
    [VERSION_CODE]     INT      NOT NULL,
    [TRANSACTION_DATE] DATETIME NULL,
    [LOG_ID]           INT      NULL,
    CONSTRAINT [PK_MRKTNTRVL6_12] PRIMARY KEY CLUSTERED ([INTERVAL_ID] ASC),
    CONSTRAINT [FK_MARKET_INTERVAL_LOG_MARKET_PROCESSED] FOREIGN KEY ([LOG_ID]) REFERENCES [dbo].[LOG_MARKET_PROCESSED] ([ROW_ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'This table represents channels associated with recorders. The recorder and associated channel together for the "recorder,channel" ID used when loading interval data from the Lodestar Interval Database. This table i', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'LINKS THIS TABLE TO THE MARKET_INTERVAL_HEADER AND LOAD_INTERVAL TABLES.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL', @level2type = N'COLUMN', @level2name = N'INTERVAL_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'UNIQUE IDENTIFIER FOR THE CHANNEL RECORDER.   (MATCHES RECORDER FIELD IN MARKET_INTERVAL_HEADER TABLE)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL', @level2type = N'COLUMN', @level2name = N'INTERVAL_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'INDICATES THE SETTLEMENT CHANNEL.  (MATCHES MARKET_HEADER FIELD IN MARKET_INTERVAL_HEADER TABLE)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL', @level2type = N'COLUMN', @level2name = N'VERSION_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'INDICATES THE DATETIME AND TIME WHEN A RECORD WAS ADDED.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';

