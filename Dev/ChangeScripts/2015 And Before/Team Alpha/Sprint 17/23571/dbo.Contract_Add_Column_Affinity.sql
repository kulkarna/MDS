
/* To prevent any potential data loss issues, you should review this script in detail 
before running it outside the context of the database designer.*/

USE LIBERTYPOWER
GO           
BEGIN TRANSACTION T1
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
IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = 'Contract' 
           AND  COLUMN_NAME = 'AffinityCode')
BEGIN
ALTER TABLE dbo.Contract ADD
	AffinityCode varchar(50) NULL;
ALTER TABLE dbo.Contract SET (LOCK_ESCALATION = TABLE);
END

COMMIT 

