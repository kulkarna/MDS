/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataWP]
 * PURPOSE:		Delete record from [Staging].[FirstEnergyWP] and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 09/12/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[Usp_RollbackdataWP]

(

	@FileId AS INT
 )

AS

BEGIN

 -- Delete the row from reference table[FirstEnergyWP].


 Delete from [Staging].[FirstEnergyWP] where Fileimportid=@FileId


 -- Delete the row from FileImport table

 Delete from dbo.FileImport where Id = @FileId


END


