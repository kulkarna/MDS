/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRY
IF NOT EXISTS (select 1 from sys.columns cols (nolock) join sys.tables tab (nolock) on 
				cols.object_id=tab.object_id
				where tab.name='deal_name' and cols.name='ID')
BEGIN
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

CREATE TABLE dbo.Tmp_deal_name
	(
	ID int NOT NULL IDENTITY (1, 1),
	contract_nbr char(12) NOT NULL,
	name_link int NOT NULL,
	full_name varchar(100) NOT NULL,
	chgstamp smallint NOT NULL
	)  ON [PRIMARY]
ALTER TABLE dbo.Tmp_deal_name SET (LOCK_ESCALATION = TABLE)
IF EXISTS(SELECT * FROM dbo.deal_name)
	 EXEC('INSERT INTO dbo.Tmp_deal_name (contract_nbr, name_link, full_name, chgstamp)
		SELECT contract_nbr, name_link, full_name, chgstamp FROM dbo.deal_name WITH (HOLDLOCK TABLOCKX)')
DROP TABLE dbo.deal_name
EXECUTE sp_rename N'dbo.Tmp_deal_name', N'deal_name', 'OBJECT' 
ALTER TABLE dbo.deal_name ADD CONSTRAINT
	PK_deal_name PRIMARY KEY NONCLUSTERED 
	(
	ID
	) WITH( DATA_COMPRESSION = PAGE ,STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

CREATE UNIQUE CLUSTERED INDEX deal_name_idx ON dbo.deal_name
	(
	contract_nbr,
	name_link
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
END
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
END CATCH;
IF @@TRANCOUNT > 0
    COMMIT TRANSACTION;

