/********************************************************************************
 * Creates a CustomerContactPreference table if not existing, adds content and 
 * adds column CustomerContactPreferenceID to CustomerPreference table if not 
 * existing.
 *
 * History
 *******************************************************************************
 * 01/08/2015 - Fernando Alves
 * PBI 57563 - Updates the CustomerPreferenceInsert stored procedure by adding a 
 * new column CustomerContactPreferenceID.
 *******************************************************************************
 */
USE Libertypower;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

BEGIN TRY
    BEGIN TRANSACTION
		IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomerContactPreference]') AND type in (N'U'))
			BEGIN
				CREATE TABLE CustomerContactPreference (
					CustomerContactPreferenceId	int NOT NULL,
					Description varchar(50) NOT NULL, 
				CONSTRAINT PK_CustomerContactPreference PRIMARY KEY CLUSTERED (
					CustomerContactPreferenceId ASC
				) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
				) ON [PRIMARY];

				INSERT CustomerContactPreference VALUES (1, 'Phone');
				INSERT CustomerContactPreference VALUES (2, 'Email');
				INSERT CustomerContactPreference VALUES (3, 'Fax');
			END

		IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'CustomerPreference' AND COLUMN_NAME = 'CustomerContactPreferenceId') 
			BEGIN
				ALTER TABLE CustomerPreference ADD CustomerContactPreferenceId int NULL;
				ALTER TABLE CustomerPreference ADD FOREIGN KEY (CustomerContactPreferenceId) REFERENCES CustomerContactPreference(CustomerContactPreferenceId);
			END
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    RAISERROR (N'Error during CustomerContactPreference column and dependencies creation', 1, 1);
END CATCH;
GO
