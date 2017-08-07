CREATE TABLE [dbo].[ESIIDSERVICEHIST_DELETE] (
    [UIDESIID]     CHAR (50) NOT NULL,
    [SERVICECODE]  CHAR (64) NOT NULL,
    [STARTTIME]    DATETIME  NOT NULL,
    [D_TIMESTAMP]  DATETIME  NULL,
    [SRC_ADDTIME]  DATETIME  NOT NULL,
    [Processed]    BIT       CONSTRAINT [DF__ESIIDSERV__Proce__5BE2A6F2] DEFAULT ((0)) NOT NULL,
    [ENTITY_ID]    CHAR (15) NOT NULL,
    [CREATED]      DATETIME  CONSTRAINT [DF_ESIIDSERVICEHIST_DELETE_CREATED] DEFAULT (getdate()) NULL,
    [ROW_ID]       INT       IDENTITY (1, 1) NOT NULL,
    [PROCESSED_ID] INT       NULL,
    CONSTRAINT [PK_ESIIDSERVICEHIST_DELETE] PRIMARY KEY CLUSTERED ([ROW_ID] ASC),
    CONSTRAINT [FK_ESIIDSERVICEHIST_DELETE_LOG_FILE_PROCESSED] FOREIGN KEY ([PROCESSED_ID]) REFERENCES [dbo].[LOG_FILE_PROCESSED] ([ROW_ID]),
    CONSTRAINT [IX_ESIIDSERVICEHIST_DELETE] UNIQUE NONCLUSTERED ([UIDESIID] ASC, [SERVICECODE] ASC, [STARTTIME] ASC, [SRC_ADDTIME] ASC, [ENTITY_ID] ASC)
);


GO
-- =============================================
-- Author:		Alberto Franco
-- Create date: November 13, 2007
-- Description:	Flags ESIIDSERVICEHIST row as deleted when a related row
--				in ESIIDSERVICEHIST_DELETE is inserted.
-- =============================================
CREATE TRIGGER [dbo].[TRG_DELETE_ESIIDSERVICEHIST]
   ON  [dbo].[ESIIDSERVICEHIST_DELETE]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	UPDATE ESIIDSERVICEHIST 
		SET Cancelled = 1, DELETE_ID = I.ROW_ID
		FROM ESIIDSERVICEHIST H
		INNER JOIN INSERTED I
			ON  H.UIDESIID    = I.UIDESIID 
			AND H.SERVICECODE = I.SERVICECODE
			AND H.STARTTIME   = I.STARTTIME 
			AND H.ADDTIME     = I.SRC_ADDTIME 
			AND H.ENTITY_ID   = I.ENTITY_ID
END

GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'DateCreated', @value = N'11/20/2006 3:22:23 PM', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'LastUpdated', @value = N'11/20/2006 3:24:13 PM', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'ESIIDSERVICEHIST_DELETE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'OrderByOn', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'Orientation', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'RecordCount', @value = N'7064', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'Updatable', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DecimalPlaces', @value = N'255', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'UIDESIID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'UIDESIID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_DELETE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'UIDESIID';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'SERVICECODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'64', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'SERVICECODE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_DELETE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'10', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'UnicodeCompression', @value = N'True', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SERVICECODE';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'STARTTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'STARTTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_DELETE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'STARTTIME';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'D_TIMESTAMP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'D_TIMESTAMP', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_DELETE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'D_TIMESTAMP';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMESentMode', @value = N'3', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'SRC_ADDTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'4', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'SRC_ADDTIME', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_DELETE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'8', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'SRC_ADDTIME';


GO
EXECUTE sp_addextendedproperty @name = N'AllowZeroLength', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'Attributes', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'CollatingOrder', @value = N'1033', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnHidden', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnOrder', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'ColumnWidth', @value = N'-1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'DataUpdatable', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'106', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Format', @value = N'Yes/No', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'Name', @value = N'Processed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'OrdinalPosition', @value = N'5', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'Required', @value = N'False', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'Size', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'SourceField', @value = N'Processed', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'SourceTable', @value = N'ESIIDSERVICEHIST_DELETE_local', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';


GO
EXECUTE sp_addextendedproperty @name = N'Type', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'ESIIDSERVICEHIST_DELETE', @level2type = N'COLUMN', @level2name = N'Processed';

