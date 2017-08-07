CREATE TABLE [dbo].[ESIID] (
    [UIDESIID]     CHAR (50)     NOT NULL,
    [ESIID]        VARCHAR (100) NOT NULL,
    [STARTTIME]    DATETIME      NULL,
    [STOPTIME]     DATETIME      NULL,
    [ADDTIME]      DATETIME      NULL,
    [ENTITY_ID]    CHAR (15)     NOT NULL,
    [CREATED]      DATETIME      CONSTRAINT [DF_ESIID_CREATED] DEFAULT (getdate()) NULL,
    [ROW_ID]       INT           IDENTITY (1, 1) NOT NULL,
    [PROCESSED_ID] INT           NULL,
    CONSTRAINT [PK_ESIID] PRIMARY KEY CLUSTERED ([ROW_ID] ASC),
    CONSTRAINT [FK_ESIID_LOG_FILE_PROCESSED] FOREIGN KEY ([PROCESSED_ID]) REFERENCES [dbo].[LOG_FILE_PROCESSED] ([ROW_ID]),
    CONSTRAINT [IX_ESIID] UNIQUE NONCLUSTERED ([UIDESIID] ASC, [ENTITY_ID] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'DateCreated', @value = N'11/20/2006 3:22:23 PM', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'LastUpdated', @value = N'11/20/2006 3:24:16 PM', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'ESIID_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'OrderByOn', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Orientation', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'RecordCount', @value = N'2467', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Updatable', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'UIDESIID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'UIDESIID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIID_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'ESIID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'ESIID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIID_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ESIID';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'STARTTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'STARTTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIID_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'STOPTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'STOPTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIID_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'STOPTIME';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'ADDTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'ADDTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIID_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIID', @level2type = N'COLUMN', @level2name = N'ADDTIME';

