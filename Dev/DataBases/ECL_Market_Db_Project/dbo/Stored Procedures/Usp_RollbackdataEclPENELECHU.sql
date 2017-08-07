/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataEclPENELECHU]
 * PURPOSE:		Updated isvalid flag record from [Staging].[FirstEnergyPENELECHUECL] and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 09/05/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[Usp_RollbackdataEclPENELECHU]
(
	
	@FileId AS INT
 )
AS
BEGIN
Set nocount on;
Begin Transaction
        Begin try
		
				 --- Updated Is valid flag to 0 which means record is not valid
				 Update c
				 Set IsValid=0
				 from [Staging].[FirstEnergyPENELECHUECL] c
				 where c.FileImportID=@FileId

				 --- Updated Is valid flag to 0 which means record is not valid
				 Update fc
				 Set IsValid=0
				 from [dbo].[FileImport] fc
				 where fc.Id =@FileId

End Try
		
		Begin Catch
       DECLARE @ErrorMessage NVARCHAR(1000),
					@ErrorMessageText NVARCHAR(1000),
					@ErrorSeverity INT,
					@ErrorState INT,	
					@ErrorNumber int;

			SELECT  @ErrorNumber = ERROR_NUMBER(),
					@ErrorMessage = ERROR_MESSAGE(), 
					@ErrorMessageText = Case 
										  when ERROR_PROCEDURE() is  null then 'SQLError#: ' + convert(varchar,@ErrorNumber) + ', "' + ERROR_MESSAGE() + '"' + ', Sql in Procedure: ' + isnull(OBJECT_NAME(@@PROCID),'') + ', Line#: ' + convert(varchar,ERROR_LINE())
										  else 'SQLError#: ' + convert(varchar,@ErrorNumber) + ', "' + ERROR_MESSAGE() + '"' + ', Procedure: ' + isnull(ERROR_PROCEDURE(),'') + ', Line#: ' + convert(varchar,ERROR_LINE())
									   end,
					@ErrorSeverity = ERROR_SEVERITY(),
					@ErrorState = ERROR_STATE();
				
			if XACT_state() <> 0
			begin
--			    print 'Rollback'
				ROLLBACK TRANSACTION
			End

    		RAISERROR (@ErrorMessageText, @ErrorSeverity, @ErrorState);
	   End Catch
	   if XACT_state() > 0
	    begin
	      --print 'Commit'
		 Commit
		end
            

 SET NOCOUNT OFF

END





