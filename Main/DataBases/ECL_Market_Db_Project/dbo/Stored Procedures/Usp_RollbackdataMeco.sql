
/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataMeco]
 * PURPOSE:		Delete record from meco and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 11/10/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [Usp_RollbackdataMeco]
(
	
	@FileId AS INT
 )
AS
BEGIN
 -- Delete the row from reference table[meco].

 Delete from [Staging].[Meco] where Fileimportid= @FileId

 -- Delete the row from FileImport table
 Delete from [dbo].[FileImport] where Id = @FileId

END
 

