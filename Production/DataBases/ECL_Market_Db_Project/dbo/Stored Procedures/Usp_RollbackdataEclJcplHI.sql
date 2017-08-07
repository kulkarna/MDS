/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataEclJcplHI]
 * PURPOSE:		Delete record from [Staging].[FirstEnergyJcplHIECL] and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 09/10/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[Usp_RollbackdataEclJcplHI]
(
	
	@FileId AS INT
 )
AS
BEGIN
 -- Delete the row from reference table [Staging].[FirstEnergyJcplHIECL].

 Delete from [Staging].[FirstEnergyJcplHIECL] where Fileimportid=@FileId

 -- Delete the row from FileImport table
 Delete from [dbo].[FileImport] where Id = @FileId

END
 




