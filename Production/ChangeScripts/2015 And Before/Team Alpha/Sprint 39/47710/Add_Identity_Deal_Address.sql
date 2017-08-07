/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRY
IF NOT EXISTS (select 1 from sys.columns cols (nolock) join sys.tables tab (nolock) on 
				cols.object_id=tab.object_id
				where tab.name='deal_address' and cols.name='ID')
BEGIN
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

CREATE TABLE dbo.Tmp_deal_address
	(
	ID int NOT NULL IDENTITY (1, 1),
	contract_nbr char(12) NOT NULL,
	address_link int NOT NULL,
	address char(50) NOT NULL,
	suite char(50) NOT NULL,
	city char(50) NOT NULL,
	state char(2) NOT NULL,
	zip char(10) NOT NULL,
	county char(10) NOT NULL,
	state_fips char(2) NOT NULL,
	county_fips char(3) NOT NULL,
	chgstamp smallint NOT NULL
	)  ON [PRIMARY]
ALTER TABLE dbo.Tmp_deal_address SET (LOCK_ESCALATION = TABLE)
IF EXISTS(SELECT * FROM dbo.deal_address)
	 EXEC('INSERT INTO dbo.Tmp_deal_address (contract_nbr, address_link, address, suite, city, state, zip, county, state_fips, county_fips, chgstamp)
		SELECT contract_nbr, address_link, address, suite, city, state, zip, county, state_fips, county_fips, chgstamp FROM dbo.deal_address WITH (HOLDLOCK TABLOCKX)')
DROP TABLE dbo.deal_address
EXECUTE sp_rename N'dbo.Tmp_deal_address', N'deal_address', 'OBJECT' 
ALTER TABLE dbo.deal_address ADD CONSTRAINT
	PK_deal_address PRIMARY KEY NONCLUSTERED 
	(
	ID
	) WITH( DATA_COMPRESSION = PAGE ,STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

CREATE UNIQUE CLUSTERED INDEX deal_address_idx ON dbo.deal_address
	(
	contract_nbr,
	address_link
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
