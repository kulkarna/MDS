CREATE TABLE [dbo].[ESIIDUSAGE_DELETE] (
    [UIDESIID]      CHAR (50)  NOT NULL,
    [STARTTIME]     DATETIME   NOT NULL,
    [METERTYPE]     CHAR (255) NOT NULL,
    [D_TIMESTAMP]   DATETIME   NOT NULL,
    [SRC_TIMESTAMP] DATETIME   NOT NULL,
    [Processed]     BIT        CONSTRAINT [DF__ESIIDUSAG__Proce__5535A963] DEFAULT ((0)) NOT NULL,
    [ENTITY_ID]     CHAR (15)  NOT NULL,
    [CREATED]       DATETIME   CONSTRAINT [DF_ESIIDUSAGE_DELETE_CREATED] DEFAULT (getdate()) NULL,
    [ROW_ID]        INT        IDENTITY (1, 1) NOT NULL,
    [PROCESSED_ID]  INT        NULL,
    CONSTRAINT [PK_ESIIDUSAGE_DELETE] PRIMARY KEY CLUSTERED ([ROW_ID] ASC),
    CONSTRAINT [FK_ESIIDUSAGE_DELETE_LOG_FILE_PROCESSED] FOREIGN KEY ([PROCESSED_ID]) REFERENCES [dbo].[LOG_FILE_PROCESSED] ([ROW_ID]),
    CONSTRAINT [IX_ESIIDUSAGE_DELETE] UNIQUE NONCLUSTERED ([UIDESIID] ASC, [STARTTIME] ASC, [METERTYPE] ASC, [D_TIMESTAMP] ASC, [ENTITY_ID] ASC)
);


GO
-- =============================================
-- Author:		Alberto Franco
-- Create date: November 14, 2007
-- Description:	When a row in ESIIDUSAGE_DELETE is inserted then
--				we must update the related row in ESIIDUSAGE by
--				setting the Cancelled flag and updating the
--				foreign key reference DELETE_ID pointing to the 
--				identity field in ESIIDUSAGE_DELETE indicating that
--				the row is cancelled.
-- =============================================
CREATE TRIGGER [dbo].[TRG_DELETE_ESIIDUSAGE]
   ON  [dbo].[ESIIDUSAGE_DELETE]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	UPDATE ESIIDUSAGE
	SET Cancelled = 1, DELETE_ID = I.ROW_ID
	FROM ESIIDUSAGE U
	INNER JOIN INSERTED I
		ON  U.UIDESIID  = I.UIDESIID
		AND U.STARTTIME = I.STARTTIME
		AND U.METERTYPE = I.METERTYPE
		AND U.TIMESTAMP = I.SRC_TIMESTAMP
		AND U.ENTITY_ID = I.ENTITY_ID
END

GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'DateCreated', @value = N'11/20/2006 3:22:25 PM', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'LastUpdated', @value = N'11/20/2006 3:23:49 PM', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'ESIIDUSAGE_DELETE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'OrderByOn', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'Orientation', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'RecordCount', @value = N'1154', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'Updatable', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'UIDESIID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'UIDESIID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_DELETE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'7', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'STARTTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'STARTTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_DELETE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'METERTYPE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'METERTYPE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_DELETE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'METERTYPE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'D_TIMESTAMP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'D_TIMESTAMP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_DELETE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'SRC_TIMESTAMP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'SRC_TIMESTAMP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_DELETE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'106', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Format', @value = N'Yes/No', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'Processed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'5', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'Processed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDUSAGE_DELETE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDUSAGE_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';

