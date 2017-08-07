/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataPP]
 * PURPOSE:		Delete record from [Staging].[FirstEnergyPP] and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 09/12/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[Usp_RollbackdataPP]

(

	@FileId AS INT
 )

AS

BEGIN

 -- Delete the row from reference table[FirstEnergyPP].


 Delete from [Staging].[FirstEnergyPP] where Fileimportid=@FileId


 -- Delete the row from FileImport table

 Delete from dbo.FileImport where Id = @FileId


END

