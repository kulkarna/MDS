USE OnlineEnrollment
GO
IF NOT EXISTS(Select * from  OnlineEnrollment.sys.columns col (nolock) Join sys.tables tab 
(nolock) on col.object_id=tab.object_id where col.name='EnableCaptcha' and tab.name='Market' and tab.type='U')
BEGIN
    /* To prevent any potential data loss issues, you should review this script in detail before 
    running it outside the context of the database designer.*/
    BEGIN TRANSACTION
	   BEGIN TRY
		  SET QUOTED_IDENTIFIER ON
		  SET ARITHABORT ON
		  SET NUMERIC_ROUNDABORT OFF
		  SET CONCAT_NULL_YIELDS_NULL ON
		  SET ANSI_NULLS ON
		  SET ANSI_PADDING ON
		  SET ANSI_WARNINGS ON
		  ALTER TABLE dbo.Market ADD
		  EnableCaptcha bit NOT NULL CONSTRAINT DF_Market_EnableCaptcha DEFAULT 0
		  ALTER TABLE dbo.Market SET (LOCK_ESCALATION = TABLE)
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
END;



