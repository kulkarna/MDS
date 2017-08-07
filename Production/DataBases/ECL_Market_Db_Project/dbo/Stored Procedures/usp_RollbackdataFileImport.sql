/*
******************************************************************************

 * PROCEDURE:	[usp_RollbackdataFileImport]
 * PURPOSE:		Delete record from Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 11/07/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[usp_RollbackdataFileImport]
(
	@FileId AS INT
)
AS
BEGIN
 -- Delete the row from FileImport table
 Delete from [dbo].[FileImport] where Id = @FileId

END
