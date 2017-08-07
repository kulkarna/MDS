CREATE TABLE [dbo].[ESIIDUSAGE] (
    [UIDESIID]     CHAR (50)  NOT NULL,
    [STARTTIME]    DATETIME   NOT NULL,
    [STOPTIME]     DATETIME   NULL,
    [BILLMONTH]    CHAR (10)  NULL,
    [METERTYPE]    CHAR (64)  NOT NULL,
    [TOTAL]        BIGINT     NULL,
    [READSTATUS]   CHAR (64)  NULL,
    [AVGDAILYUSG]  BIGINT     NULL,
    [ONPK]         BIGINT     NULL,
    [OFFPK]        BIGINT     NULL,
    [MDPK]         BIGINT     NULL,
    [SPK]          BIGINT     NULL,
    [ONPKADU]      BIGINT     NULL,
    [OFFPKADU]     BIGINT     NULL,
    [MDPKADU]      BIGINT     NULL,
    [SPKADU]       BIGINT     NULL,
    [ADDTIME]      DATETIME   NULL,
    [GLOBPROCID]   CHAR (100) NULL,
    [TIMESTAMP]    DATETIME   NOT NULL,
    [Cancelled]    BIT        CONSTRAINT [DF__ESIIDUSAG__Cance__59063A47] DEFAULT ((0)) NOT NULL,
    [ENTITY_ID]    CHAR (15)  NOT NULL,
    [CREATED]      DATETIME   CONSTRAINT [DF_ESIIDUSAGE_CREATED] DEFAULT (getdate()) NULL,
    [ROW_ID]       INT        IDENTITY (1, 1) NOT NULL,
    [PROCESSED_ID] INT        NULL,
    [DELETE_ID]    INT        NULL,
    CONSTRAINT [PK_ESIIDUSAGE] PRIMARY KEY CLUSTERED ([ROW_ID] ASC),
    CONSTRAINT [FK_ESIIDUSAGE_ESIIDUSAGE_DELETE] FOREIGN KEY ([DELETE_ID]) REFERENCES [dbo].[ESIIDUSAGE_DELETE] ([ROW_ID]),
    CONSTRAINT [FK_ESIIDUSAGE_LOG_FILE_PROCESSED] FOREIGN KEY ([PROCESSED_ID]) REFERENCES [dbo].[LOG_FILE_PROCESSED] ([ROW_ID]),
    CONSTRAINT [IX_ESIIDUSAGE] UNIQUE NONCLUSTERED ([UIDESIID] ASC, [STARTTIME] ASC, [METERTYPE] ASC, [TIMESTAMP] ASC, [ENTITY_ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE';


GO
EXECUTE sp_addextendedproperty @name = N'DateCreated', @value = N'11/20/2006 3:22:24 PM', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE';


GO
EXECUTE sp_addextendedproperty @name = N'LastUpdated', @value = N'11/20/2006 3:24:11 PM', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE';


GO
EXECUTE sp_addextendedproperty @name = N'OrderByOn', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE';


GO
EXECUTE sp_addextendedproperty @name = N'Orientation', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE';


GO
EXECUTE sp_addextendedproperty @name = N'RecordCount', @value = N'65493', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE';


GO
EXECUTE sp_addextendedproperty @name = N'Updatable', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'UIDESIID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'UIDESIID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'STARTTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'STARTTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'STOPTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'STOPTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'BILLMONTH', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'BILLMONTH', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'BILLMONTH';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'METERTYPE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'METERTYPE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'TOTAL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'5', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'TOTAL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TOTAL';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'READSTATUS', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'6', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'READSTATUS', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'READSTATUS';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'AVGDAILYUSG', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'7', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'AVGDAILYUSG', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'AVGDAILYUSG';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'ONPK', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'ONPK', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPK';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'OFFPK', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'9', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'OFFPK', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPK';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'MDPK', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'MDPK', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPK';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'SPK', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'11', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'50', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'SPK', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPK';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'ONPKADU', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'12', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'ONPKADU', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ONPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'OFFPKADU', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'13', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'OFFPKADU', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'OFFPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'MDPKADU', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'14', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'MDPKADU', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'MDPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'SPKADU', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'15', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'SPKADU', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'SPKADU';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'ADDTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'16', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'ADDTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'GLOBPROCID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'17', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'GLOBPROCID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'GLOBPROCID';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'TIMESTAMP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'18', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'TIMESTAMP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'106', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Format', @value = N'Yes/No', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'Cancelled', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'19', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'Cancelled', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE', @level2type = N'COLUMN', @level2name = N'Cancelled';

