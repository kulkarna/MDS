USE LP_DEAL_CAPTURE
GO
BEGIN TRANSACTION;
BEGIN TRY
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
IF NOT EXISTS (select 1 from sys.columns cols (nolock) join sys.tables tab (nolock) on 
				cols.object_id=tab.object_id
				where tab.name='deal_contract' and cols.name='ClientSubmitApplicationKeyId')
BEGIN
    ALTER TABLE dbo.deal_contract ADD
	    ClientSubmitApplicationKeyId int NULL;
    ALTER TABLE dbo.deal_contract SET (LOCK_ESCALATION = TABLE);
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


