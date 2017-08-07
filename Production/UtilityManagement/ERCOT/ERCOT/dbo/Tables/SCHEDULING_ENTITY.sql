CREATE TABLE [dbo].[SCHEDULING_ENTITY] (
    [SCHEDULING_ENTITY_CODE]  VARCHAR (64) NOT NULL,
    [SCHEDULING_ENTITY_NAME]  VARCHAR (64) NOT NULL,
    [START_TIME]              DATETIME     NOT NULL,
    [STOP_TIME]               DATETIME     NULL,
    [TRANSACTION_DATE]        DATETIME     NULL,
    [UIDACCOUNT]              INT          NULL,
    [DUNS_AND_BRADSTREET_INT] VARCHAR (64) NOT NULL,
    CONSTRAINT [PK_SCHDLNGNT6_17] PRIMARY KEY CLUSTERED ([SCHEDULING_ENTITY_CODE] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'Any participant that is qualified by the ISO to submit schedules and ancillary services bids.  Requirements of qualifications may include technical and financial criteria (e.g., credit worthiness, twenty-four hou', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SCHEDULING_ENTITY';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies a participant that is qualified by the ISO to submit schedules and ancillary services bids.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SCHEDULING_ENTITY', @level2type = N'COLUMN', @level2name = N'SCHEDULING_ENTITY_CODE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'The long name that identifies a participant that is qualified by the ISO to submit schedules and ancillary services bids.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SCHEDULING_ENTITY', @level2type = N'COLUMN', @level2name = N'SCHEDULING_ENTITY_NAME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when the data in a row takes effect.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SCHEDULING_ENTITY', @level2type = N'COLUMN', @level2name = N'START_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SCHEDULING_ENTITY', @level2type = N'COLUMN', @level2name = N'STOP_TIME';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This timestamp represent the DATETIME and time when a new row is added or a column value in an existing row is updated.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SCHEDULING_ENTITY', @level2type = N'COLUMN', @level2name = N'TRANSACTION_DATE';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This INT uniquely identifies the account  associated with a QSE.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SCHEDULING_ENTITY', @level2type = N'COLUMN', @level2name = N'UIDACCOUNT';


GO
EXECUTE sp_addextendedproperty @name = N'Description', @value = 'This code uniquely identifies the market participant and is assigned and maintained by Dun and Bradstreet.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'SCHEDULING_ENTITY', @level2type = N'COLUMN', @level2name = N'DUNS_AND_BRADSTREET_INT';

