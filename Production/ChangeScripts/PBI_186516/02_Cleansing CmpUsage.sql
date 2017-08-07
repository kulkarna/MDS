BEGIN TRY
	BEGIN TRANSACTION

	IF OBJECT_ID('Workspace..PBI_186516_Temp_CmpUsage') IS NOT NULL
		DROP TABLE Workspace..PBI_186516_Temp_CmpUsage

		SELECT * INTO Workspace..PBI_186516_Temp_CmpUsage FROM lp_transactions..CmpUsage

DELETE FROM lp_transactions..CmpUsage

	COMMIT
PRINT 'COMMIT TRAN'
END TRY
BEGIN CATCH
	SELECT  
		 ERROR_NUMBER() AS ErrorNumber  
		,ERROR_SEVERITY() AS ErrorSeverity  
		,ERROR_STATE() AS ErrorState  
		,ERROR_PROCEDURE() AS ErrorProcedure  
		,ERROR_LINE() AS ErrorLine  
		,ERROR_MESSAGE() AS ErrorMessage;  
	ROLLBACK TRAN
	PRINT 'ROLLBACK TRAN'
END CATCH