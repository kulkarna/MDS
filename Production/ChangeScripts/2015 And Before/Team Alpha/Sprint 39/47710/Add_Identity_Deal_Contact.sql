/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRY
IF NOT EXISTS (select 1 from sys.columns cols (nolock) join sys.tables tab (nolock) on 
				cols.object_id=tab.object_id
				where tab.name='deal_contact' and cols.name='ID')
BEGIN
BEGIN TRANSACTION

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

    CREATE TABLE dbo.Tmp_deal_contact
	    (
	    ID int NOT NULL IDENTITY (1, 1),
	    contract_nbr char(12) NOT NULL,
	    contact_link int NOT NULL,
	    first_name varchar(50) NOT NULL,
	    last_name varchar(50) NOT NULL,
	    title varchar(20) NOT NULL,
	    phone varchar(20) NOT NULL,
	    fax varchar(20) NOT NULL,
	    email nvarchar(256) NOT NULL,
	    birthday varchar(5) NOT NULL,
	    chgstamp smallint NOT NULL,
CONSTRAINT [PK_deal_contact] PRIMARY KEY NONCLUSTERED 
(
    [ID] ASC
)WITH (DATA_COMPRESSION = PAGE ,PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY];
 

    ALTER TABLE dbo.Tmp_deal_contact SET (LOCK_ESCALATION = TABLE)

    SET IDENTITY_INSERT dbo.Tmp_deal_contact OFF

    IF EXISTS(SELECT * FROM dbo.deal_contact)
		EXEC('INSERT INTO dbo.Tmp_deal_contact (contract_nbr, contact_link, first_name, last_name, title, phone, fax, email, birthday, chgstamp)
		    SELECT contract_nbr, contact_link, first_name, last_name, title, phone, fax, email, birthday, chgstamp FROM dbo.deal_contact WITH (HOLDLOCK TABLOCKX)')

    DROP TABLE dbo.deal_contact

    EXECUTE sp_rename N'dbo.Tmp_deal_contact', N'deal_contact', 'OBJECT' 

    CREATE UNIQUE CLUSTERED INDEX deal_contact_idx ON dbo.deal_contact
	    (
	    contract_nbr,
	    contact_link
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
