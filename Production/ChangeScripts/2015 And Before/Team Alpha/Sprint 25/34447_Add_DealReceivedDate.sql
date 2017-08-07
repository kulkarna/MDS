--Script to Add the column DealReceivedDate and set the constraint to Allow NULLs.
USE GENIE;
go
IF NOT EXISTS (SELECT *
               FROM   sys.all_columns
               WHERE  object_id = (SELECT object_id
                                   FROM   SYS.objects
                                   WHERE  name = 'T_Contract')
                      AND all_columns.name = 'DealReceivedDate')
    BEGIN
		BEGIN TRY
			BEGIN TRANSACTION;
			ALTER TABLE dbo.T_Contract
				ADD DealReceivedDate DATETIME CONSTRAINT DF_T_Contract_DealReceivedDate DEFAULT getdate() NOT NULL;
			ALTER TABLE dbo.T_Contract SET (LOCK_ESCALATION = TABLE);
			--Update the existing rows with the value from contractsign date
			DECLARE @SQLString AS NVARCHAR (500);
			SET @SQLString = N'Update T_Contract set DealReceivedDate = ContractSignDate where ContractSignDate is not NULL';
			EXECUTE sp_executesql @sqlstring;
        END TRY
        BEGIN CATCH
            SELECT ERROR_NUMBER() AS ErrorNumber,
                   ERROR_SEVERITY() AS ErrorSeverity,
                   ERROR_STATE() AS ErrorState,
                   ERROR_PROCEDURE() AS ErrorProcedure,
                   ERROR_LINE() AS ErrorLine,
                   ERROR_MESSAGE() AS ErrorMessage;
            IF @@TRANCOUNT > 0
                ROLLBACK;
        END CATCH;
        IF @@TRANCOUNT > 0
            COMMIT TRANSACTION;
    END