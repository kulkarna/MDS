
/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataECLCEIHU]
 * PURPOSE:		Delete record from FirstEnergyCEIHU and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 08/22/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[Usp_RollbackdataECLCEIHU]
(
	
	@FileId AS INT
 )
AS
BEGIN
 -- Delete the row from reference table[FirstEnergyOH].

 Delete from [Staging].[FirstEnergyCEIHU] where Fileimportid=@FileId

 -- Delete the row from FileImport table
 Delete from [dbo].[FileImport] where Id = @FileId

END
 
