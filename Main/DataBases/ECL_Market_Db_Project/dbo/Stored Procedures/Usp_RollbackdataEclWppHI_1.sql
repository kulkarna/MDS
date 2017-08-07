
/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataEclWppHI]
 * PURPOSE:		Delete record from [Staging].[FirstEnergyWPPHIECL] and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 09/01/2014 - Santosh Rao
 * Created.
 *12/02/2014 - Santosh Rao  - Change delete logic to update the is flag in table
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].Usp_RollbackdataEclWppHI_1
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
						 from [Staging].[FirstEnergyWPPHIECL] c
						 where c.FileImportID=@FileId

						 --- Updated Is valid flag to 0 which means record is not valid
						 Update fc
						 Set IsValid=0
						 from [dbo].[FileImport] fc
						 where fc.Id =@FileId
						 --Select 1/0;
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
				
					--set @RowCount=1/0;

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

