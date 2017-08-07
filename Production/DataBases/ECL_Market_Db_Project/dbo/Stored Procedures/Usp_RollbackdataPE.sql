/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataPE]
 * PURPOSE:		Delete record from [Staging].[FirstEnergyPE] and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 09/11/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[Usp_RollbackdataPE]

(

	@FileId AS INT
 )

AS

BEGIN

 -- Delete the row from reference table[FirstEnergyPE].


 Delete from [Staging].[FirstEnergyPE] where Fileimportid=@FileId


 -- Delete the row from FileImport table

 Delete from dbo.FileImport where Id = @FileId


END

 







