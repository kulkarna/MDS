/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataEclPennPowerHI]
 * PURPOSE:		Delete record from [Staging].[FirstEnergyPennPowerHIECL] and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 09/09/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[Usp_RollbackdataEclPennPowerHI]
(
	
	@FileId AS INT
 )
AS
BEGIN
 -- Delete the row from reference table [Staging].[FirstEnergyWPPECLHU].

 Delete from [Staging].[FirstEnergyPennPowerHIECL] where Fileimportid=@FileId

 -- Delete the row from FileImport table
 Delete from [dbo].[FileImport] where Id = @FileId

END
 



