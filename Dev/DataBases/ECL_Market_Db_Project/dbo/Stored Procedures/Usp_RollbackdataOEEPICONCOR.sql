
/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataOEEPICONCOR]
 * PURPOSE:		Delete record from OfferEngineEPICONCOR and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 10/14/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[Usp_RollbackdataOEEPICONCOR]
(
	
	@FileId AS INT
 )
AS
BEGIN
 -- Delete the row from reference table[OfferEngineEPICONCOR].

 Delete from [Staging].[OfferEngineEPICONCOR] where Fileimportid=@FileId

 -- Delete the row from FileImport table
 Delete from [dbo].[FileImport] where Id = @FileId

END
 


