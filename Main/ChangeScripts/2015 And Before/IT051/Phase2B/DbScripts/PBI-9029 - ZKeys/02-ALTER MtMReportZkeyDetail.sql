USE lp_mtm
GO 

SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

CREATE TABLE dbo.Tmp_MtMReportZkeyDetail
	(
	ZKeyDetailID int NOT NULL IDENTITY (1, 1),
	ZkeyID int NOT NULL,
	CounterPartyID int NOT NULL,
	Zkey varchar(50) NOT NULL,
	DateCreated datetime NOT NULL,
	CreatedBy varchar(50) NOT NULL,
	DateModified datetime NULL,
	ModifiedBy varchar(50) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_MtMReportZkeyDetail SET (LOCK_ESCALATION = TABLE)
GO
ALTER TABLE dbo.Tmp_MtMReportZkeyDetail ADD CONSTRAINT
	DF_MtMReportZkeyDetail_DateCreated DEFAULT (getdate()) FOR DateCreated
GO
SET IDENTITY_INSERT dbo.Tmp_MtMReportZkeyDetail ON
GO
IF EXISTS(SELECT * FROM dbo.MtMReportZkeyDetail)
	 EXEC('INSERT INTO dbo.Tmp_MtMReportZkeyDetail (ZKeyDetailID, ZkeyID, CounterPartyID, Zkey, DateCreated, CreatedBy, DateModified, ModifiedBy)
		SELECT ZKeyDetailID, ZkeyID, CounterPartyID, Zkey, DateCreated, CreatedBy, DateModified, ModifiedBy FROM dbo.MtMReportZkeyDetail WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_MtMReportZkeyDetail OFF
GO
DROP TABLE dbo.MtMReportZkeyDetail
GO
EXECUTE sp_rename N'dbo.Tmp_MtMReportZkeyDetail', N'MtMReportZkeyDetail', 'OBJECT' 
GO

ALTER TABLE dbo.MtMReportZkeyDetail ADD CONSTRAINT
	PK_MtMReportZkeyDetail_1 PRIMARY KEY CLUSTERED 
	(
	ZKeyDetailID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]

GO