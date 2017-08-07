/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
USE LIBERTYPOWER
GO
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO

IF not Exists (Select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'zAuditContract' and COLUMN_NAME = 'EstimatedAnnualUsage')
BEGIN

ALTER TABLE dbo.zAuditContract ADD
	EstimatedAnnualUsage int NULL;
	
END	
IF not Exists (Select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'zAuditContract' and COLUMN_NAME = 'ExternalNumber')
BEGIN

ALTER TABLE dbo.zAuditContract ADD
		ExternalNumber varchar(50) NULL;	
END
IF not Exists (Select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'zAuditContract' and COLUMN_NAME = 'DigitalSignature')
BEGIN

ALTER TABLE dbo.zAuditContract ADD
	DigitalSignature varchar(100) NULL;
	
END
IF not Exists (Select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME = 'zAuditContract' and COLUMN_NAME = 'AffinityCode')
BEGIN

ALTER TABLE dbo.zAuditContract ADD
	AffinityCode varchar(50) NULL;
	
END
GO
ALTER TABLE dbo.zAuditContract SET (LOCK_ESCALATION = AUTO)
GO
COMMIT