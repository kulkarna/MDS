CREATE TABLE [dbo].[SETTLEMENT_INTERVAL] (
    [INTERVAL_ID]                   INT          NOT NULL,
    [SERVICECODE]                   VARCHAR (64) NOT NULL,
    [START_TIME]                    DATETIME     NOT NULL,
    [STOP_TIME]                     DATETIME     NULL,
    [DETERMINANT_ID]                INT          NULL,
    [CONGESTION_MANAGEMENT_ZONE_CD] VARCHAR (64) NULL,
    [SCHEDULING_ENTITY_CODE]        VARCHAR (64) NULL,
    [DIRECT_CURRENT_TIE_LINE_CODE]  VARCHAR (64) NULL,
    [CSC_TRANSMISSION_PATH_CODE]    VARCHAR (64) NULL,
    [TRANSACTION_DATE]              DATETIME     NULL,
    [GENERATION_UNIT_CODE]          VARCHAR (64) NULL,
    [TIMESTAMP]                     DATETIME     NULL,
    [COUNTERPARTY_SCH_ENTITY]       VARCHAR (64) NULL,
    CONSTRAINT [PK_STTLMNTNT7_18] PRIMARY KEY CLUSTERED ([INTERVAL_ID] ASC, [SERVICECODE] ASC, [START_TIME] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The settlement history table describes the relationship between qualified scheduling entities and bill determinants for calculating  market settlems equations.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SETTLEMENT_INTERVAL';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This INT uniquely defines the unique combination of market participants, resources, and bill determinants that define a settlemen, load, or generation channel.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SETTLEMENT_INTERVAL', @level2type = N'COLUMN', @level2name = N'INTERVAL_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code defines the type of service that the channel is recording. The value for this code will be "ELE" for electrical service.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SETTLEMENT_INTERVAL', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'his timestamp represent the DATETIME and time when the data in a row takes effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SETTLEMENT_INTERVAL', @level2type = N'COLUMN', @level2name = N'START_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row is no longer in effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SETTLEMENT_INTERVAL', @level2type = N'COLUMN', @level2name = N'STOP_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This INT uniquely identifies the bill determinant used for calculating settlements and billings.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SETTLEMENT_INTERVAL', @level2type = N'COLUMN', @level2name = N'DETERMINANT_ID';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies an ERCOT congestion management zone.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SETTLEMENT_INTERVAL', @level2type = N'COLUMN', @level2name = N'CONGESTION_MANAGEMENT_ZONE_CD';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies a participant that is qualified by the ISO to submit schedules and ancillary services bids.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SETTLEMENT_INTERVAL', @level2type = N'COLUMN', @level2name = N'SCHEDULING_ENTITY_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies a direct current non-synchronous transmission connection between ERCOT and non-ERCOTelectric power systems.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SETTLEMENT_INTERVAL', @level2type = N'COLUMN', @level2name = N'DIRECT_CURRENT_TIE_LINE_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies a commercially significant constraint transmission path between two adjacent congestion management zones.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SETTLEMENT_INTERVAL', @level2type = N'COLUMN', @level2name = N'CSC_TRANSMISSION_PATH_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Timestamp', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SETTLEMENT_INTERVAL', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies the fractional ownership of a generator by a power generating company.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SETTLEMENT_INTERVAL', @level2type = N'COLUMN', @level2name = N'GENERATION_UNIT_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SETTLEMENT_INTERVAL', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies a participant that is qualified by the ISO to submit schedules and ancillary services bids.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SETTLEMENT_INTERVAL', @level2type = N'COLUMN', @level2name = N'COUNTERPARTY_SCH_ENTITY';

