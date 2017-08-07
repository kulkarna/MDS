/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataPA]
 * PURPOSE:		Delete record from [Staging].[FirstEnergyPA] and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 09/12/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[Usp_RollbackdataPA]

(

	@FileId AS INT
 )

AS

BEGIN

 -- Delete the row from reference table[FirstEnergyPA].


 Delete from [Staging].[FirstEnergyPA] where Fileimportid=@FileId


 -- Delete the row from FileImport table

 Delete from dbo.FileImport where Id = @FileId


END


