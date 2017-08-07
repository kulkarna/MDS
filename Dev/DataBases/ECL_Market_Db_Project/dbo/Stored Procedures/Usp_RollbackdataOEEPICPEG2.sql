
/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataOEEPICPEG2]
 * PURPOSE:		Delete record from OfferEngineEPICPEG2 and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 10/21/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[Usp_RollbackdataOEEPICPEG2]
(
	
	@FileId AS INT
 )
AS
BEGIN
 -- Delete the row from reference table[OfferEngineEPICPEG2].

 Delete from [Staging].[OfferEngineEPICPEG2] where Fileimportid=@FileId

 -- Delete the row from FileImport table
 Delete from [dbo].[FileImport] where Id = @FileId

END
 





