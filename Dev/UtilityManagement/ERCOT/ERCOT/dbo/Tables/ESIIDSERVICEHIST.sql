CREATE TABLE [dbo].[ESIIDSERVICEHIST] (
    [UIDESIID]          CHAR (50) NOT NULL,
    [SERVICECODE]       CHAR (64) NOT NULL,
    [STARTTIME]         DATETIME  NOT NULL,
    [STOPTIME]          DATETIME  NULL,
    [REPCODE]           CHAR (64) NULL,
    [STATIONCODE]       CHAR (64) NULL,
    [PROFILECODE]       CHAR (64) NULL,
    [LOSSCODE]          CHAR (64) NULL,
    [ADDTIME]           DATETIME  NOT NULL,
    [DISPATCHFL]        CHAR (10) NULL,
    [MRECODE]           CHAR (64) NULL,
    [TDSPCODE]          CHAR (64) NULL,
    [REGIONCODE]        CHAR (64) NULL,
    [DISPATCHASSETCODE] CHAR (14) NULL,
    [STATUS]            CHAR (64) NULL,
    [ZIP]               CHAR (10) NULL,
    [PGCCODE]           CHAR (64) NULL,
    [DISPATCHTYPE]      CHAR (10) NULL,
    [Cancelled]         BIT       CONSTRAINT [DF__ESIIDSERV__Cance__5EBF139D] DEFAULT ((0)) NOT NULL,
    [ENTITY_ID]         CHAR (15) NOT NULL,
    [CREATED]           DATETIME  CONSTRAINT [DF_ESIIDSERVICEHIST_CREATED] DEFAULT (getdate()) NULL,
    [ROW_ID]            INT       IDENTITY (1, 1) NOT NULL,
    [PROCESSED_ID]      INT       NULL,
    [DELETE_ID]         INT       NULL,
    CONSTRAINT [PK_ESIIDSERVICEHIST] PRIMARY KEY CLUSTERED ([ROW_ID] ASC),
    CONSTRAINT [FK_ESIIDSERVICEHIST_ESIIDSERVICEHIST_DELETE] FOREIGN KEY ([DELETE_ID]) REFERENCES [dbo].[ESIIDSERVICEHIST_DELETE] ([ROW_ID]),
    CONSTRAINT [FK_ESIIDSERVICEHIST_LOG_FILE_PROCESSED] FOREIGN KEY ([PROCESSED_ID]) REFERENCES [dbo].[LOG_FILE_PROCESSED] ([ROW_ID]),
    CONSTRAINT [IX_ESIIDSERVICEHIST] UNIQUE NONCLUSTERED ([UIDESIID] ASC, [SERVICECODE] ASC, [STARTTIME] ASC, [ADDTIME] ASC, [ENTITY_ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST';


GO
EXECUTE sp_addextendedproperty @name = N'DateCreated', @value = N'11/20/2006 3:22:23 PM', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST';


GO
EXECUTE sp_addextendedproperty @name = N'LastUpdated', @value = N'11/20/2006 3:24:16 PM', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST';


GO
EXECUTE sp_addextendedproperty @name = N'OrderByOn', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST';


GO
EXECUTE sp_addextendedproperty @name = N'Orientation', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST';


GO
EXECUTE sp_addextendedproperty @name = N'RecordCount', @value = N'7187', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST';


GO
EXECUTE sp_addextendedproperty @name = N'Updatable', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'UIDESIID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'UIDESIID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'SERVICECODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'SERVICECODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'STARTTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'STARTTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'2310', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'STOPTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'STOPTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'2700', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_BoundColumn', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnCount', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnHeads', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ColumnWidths', @value = N'0;2880', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_LimitToList', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ListRows', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_ListWidth', @value = N'0twip', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_RowSource', @value = N'SELECT REP.REPCODE, REP.REPNAME FROM REP; ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_RowSourceType', @value = N'Table/View/StoredProc', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'REPCODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'REPCODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'1545', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'STATIONCODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'5', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'STATIONCODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'3975', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'PROFILECODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'6', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'PROFILECODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PROFILECODE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'1260', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'LOSSCODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'7', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'LOSSCODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'LOSSCODE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'2310', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'ADDTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'ADDTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'1365', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'DISPATCHFL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'9', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'DISPATCHFL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHFL';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'1170', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'MRECODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'MRECODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'MRECODE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'1245', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'TDSPCODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'11', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'TDSPCODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'TDSPCODE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'1485', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'REGIONCODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'12', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'REGIONCODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'REGIONCODE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'2340', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'DISPATCHASSETCODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'13', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'14', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'DISPATCHASSETCODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHASSETCODE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'930', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'STATUS', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'14', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'STATUS', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'STATUS';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'1125', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'ZIP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'15', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'ZIP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'ZIP';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'1155', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'PGCCODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'16', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'PGCCODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'PGCCODE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'1650', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'DISPATCHTYPE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'17', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'DISPATCHTYPE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'DISPATCHTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'106', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Format', @value = N'Yes/No', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'Cancelled', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'18', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'Cancelled', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST', @level2type = N'COLUMN', @level2name = N'Cancelled';

