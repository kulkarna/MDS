
/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataOEEPICPEG1]
 * PURPOSE:		Delete record from OfferEngineEPICPEG1 and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 10/17/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[Usp_RollbackdataOEEPICPEG1]
(
	
	@FileId AS INT
 )
AS
BEGIN
 -- Delete the row from reference table[OfferEngineEPICPEG1].

 Delete from [Staging].[OfferEngineEPICPEG1] where Fileimportid=@FileId

 -- Delete the row from FileImport table
 Delete from [dbo].[FileImport] where Id = @FileId

END
 




