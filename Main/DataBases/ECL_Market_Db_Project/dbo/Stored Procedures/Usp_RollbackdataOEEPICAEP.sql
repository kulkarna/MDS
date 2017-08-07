
/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataOEEPICAEP]
 * PURPOSE:		Delete record from OfferEngineEPICAEP and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 10/16/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[Usp_RollbackdataOEEPICAEP]
(
	
	@FileId AS INT
 )
AS
BEGIN
 -- Delete the row from reference table[OfferEngineEPICAEP].

 Delete from [Staging].[OfferEngineEPICAEP] where Fileimportid=@FileId

 -- Delete the row from FileImport table
 Delete from [dbo].[FileImport] where Id = @FileId

END
 



