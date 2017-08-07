USE Workspace
GO

BEGIN TRY
	BEGIN TRAN

	UPDATE Libertypower..Utility
	SET AccountLength		= 10
	WHERE ID				= 47 -- 47 is UNITIL Utility  

	UPDATE lp_common..common_utility
	SET account_length		= 10
	WHERE ID				= 47 -- 47 is UNITIL Utility  

	COMMIT TRAN
	PRINT ('COMMIT')
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
	PRINT ('ROLLBACK')
END CATCH
