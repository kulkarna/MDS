/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataOEEPICTEPN]
 * PURPOSE:		Delete record from [Staging].[OEEPICTPENAccount] & [Staging].[OEEPICTPENEsidata] and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 11/06/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[Usp_RollbackdataOEEPICTEPN]
(
	
	@FileId AS INT
 )
AS
BEGIN

 
 -- Delete the row from reference table[OEEPICTPENEsidata].

 Delete from [Staging].[OEEPICTPENEsidata] where Fileimportid=@FileId

 -- Delete the row from reference table[OEEPICTPENAccount].

 Delete from [Staging].[OEEPICTPENAccount] where Fileimportid=@FileId




 -- Delete the row from FileImport table
 Delete from [dbo].[FileImport] where Id = @FileId

END
 



