CREATE TABLE [dbo].[MARKET_INTERVAL_HEADER] (
    [INTERVAL_DATA_ID]       INT           NOT NULL,
    [INTERVAL_ID]            INT           NOT NULL,
    [RECORDER]               VARCHAR (64)  NULL,
    [MARKET_INTERVAL]        INT           NULL,
    [START_TIME]             DATETIME      NULL,
    [STOP_TIME]              DATETIME      NULL,
    [SECONDS_PER_INTERVAL]   INT           NULL,
    [MEASUREMENT_UNITS_CODE] VARCHAR (64)  NULL,
    [DSTPARTICIPANT]         CHAR (1)      NULL,
    [TIMEZONE]               INT           NULL,
    [ORIGIN]                 CHAR (1)      NULL,
    [EDITED]                 CHAR (1)      NULL,
    [INTERNALVALIDATION]     CHAR (1)      NULL,
    [EXTERNALVALIDATION]     CHAR (1)      NULL,
    [MERGEFLAG]              CHAR (1)      NULL,
    [DELETEFLAG]             CHAR (1)      NULL,
    [VALFLAGE]               CHAR (1)      NULL,
    [VALFLAGI]               CHAR (1)      NULL,
    [VALFLAGO]               CHAR (1)      NULL,
    [VALFLAGN]               CHAR (1)      NULL,
    [TKWRITTENFLAG]          CHAR (1)      NULL,
    [DCFLOW]                 CHAR (1)      NULL,
    [ACCEPTREJECTSTATUS]     CHAR (2)      NULL,
    [TRANSLATIONTIME]        DATETIME      NULL,
    [DESCRIPTOR]             VARCHAR (254) NULL,
    [TIMESTAMP]              DATETIME      NULL,
    [COUNT]                  INT           NULL,
    [TRANSACTION_DATE]       DATETIME      NULL,
    [LOG_ID]                 INT           NULL,
    CONSTRAINT [PK_MARKET_INTERVAL_HEADER] PRIMARY KEY CLUSTERED ([INTERVAL_DATA_ID] ASC),
    CONSTRAINT [FK_MARKET_INTERVAL_HEADER_LOG_MARKET_PROCESSED] FOREIGN KEY ([LOG_ID]) REFERENCES [dbo].[LOG_MARKET_PROCESSED] ([ROW_ID]),
    CONSTRAINT [FK_MRKTNTRVL10_MSRMNTNTS818] FOREIGN KEY ([MEASUREMENT_UNITS_CODE]) REFERENCES [dbo].[MEASUREMENT_UNITS] ([MEASUREMENT_UNITS_CODE])
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Contains the header information for the interval data cuts. Records in this table are used by the Channel Cut Data and Channel Cut Edit tables.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'LINKS THIS TABLE WITH THE MARKET_INTERVAL_DATA TABLE.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'INTERVAL_DATA_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'LINKS THIS TABLE WITH THE MARKET_INTERVAL TABLE.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'INTERVAL_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'UNIQUE COMBINATION OF DETERMINANT NAME AND OTHER DESCRIPTORS SUCH AS QSE CODE, ZONE NAME  AND GENSITE ETC.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'RECORDER';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'INDICATES THE SETTLEMENT CHANNEL.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'MARKET_INTERVAL';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'INDICATES THE DATETIME AND TIME WHEN THE DATA IN A ROW TAKES EFFECT.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'START_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'INDICATES THE DATETIME AND TIME WHEN THE DATA IN A ROW IS NO LONGER IN EFFECT.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'STOP_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'THE INT OF SECONDS PER INTERVAL (SPI) FOR THE INTERVAL DATA CUT (I.E. 15 MINUTES = 900, 1 HOUR = 3600).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'SECONDS_PER_INTERVAL';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'LINKS THIS TABLE WITH THE MEASUREMENT_UNITS TABLE.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'MEASUREMENT_UNITS_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'INDICATES WHETHER THE INTERVAL DATA CUT PARTICIPATES IN ANY DAYLIGHT SAVINGS TIME (DST) TIME CHANGES (ALWAYS YES).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'DSTPARTICIPANT';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'NOT IN USE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'TIMEZONE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'A FLAG THAT INDICATES THE ORIGIN OF THE CUT:  M = METERED CUT, P = PROFILED CUT, C = COMPUTER CUT, S =  STATISTIC CUT.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'ORIGIN';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'NOT IN USE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'EDITED';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'NOT IN USE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'INTERNALVALIDATION';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'NOT IN USE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'EXTERNALVALIDATION';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'NOT IN USE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'MERGEFLAG';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'NOT IN USE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'DELETEFLAG';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'NOT IN USE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'VALFLAGE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'NOT IN USE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'VALFLAGI';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'NOT IN USE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'VALFLAGO';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'NOT IN USE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'VALFLAGN';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'NOT IN USE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'TKWRITTENFLAG';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'NOT IN USE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'DCFLOW';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'NOT IN USE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'ACCEPTREJECTSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'NOT IN USE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'TRANSLATIONTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'A description of the interval data cut.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'DESCRIPTOR';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'Batch Date', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'INDICATES WHETHER THE RECORD IS INTERVAL DATA (96) OR HOURLY DATA (24).', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'COUNT';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = N'INDICATES THE DATETIME AND TIME WHEN A RECORD WAS ADDED.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'MARKET_INTERVAL_HEADER', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';

