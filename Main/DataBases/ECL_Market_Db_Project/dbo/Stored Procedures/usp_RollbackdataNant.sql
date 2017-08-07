/*
******************************************************************************

 * PROCEDURE:	[usp_RollbackdataNant]
 * PURPOSE:		Delete record from Nantucket and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 11/12/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [usp_RollbackdataNant]
(
	
	@FileId AS INT
 )
AS
BEGIN
 -- Delete the row from reference table[meco].

 Delete from [Staging].[Nantucket] where ID= @FileId

 -- Delete the row from FileImport table
 Delete from [dbo].[FileImport] where Id = @FileId

END
 


