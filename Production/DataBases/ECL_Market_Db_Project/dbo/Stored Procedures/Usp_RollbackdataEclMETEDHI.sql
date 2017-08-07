/*
******************************************************************************

 * PROCEDURE:	[Usp_RollbackdataEclMETEDHI]
 * PURPOSE:		Delete record from [Staging].[FirstEnergyMETEDHIECL] and Fileimport table on the basis of fieldId
 * HISTORY:		 
 *******************************************************************************
 * 09/09/2014 - Santosh Rao
 * Created.
 
 *******************************************************************************
  */
CREATE PROCEDURE [dbo].[Usp_RollbackdataEclMETEDHI]
(
	
	@FileId AS INT
 )
AS
BEGIN
 -- Delete the row from reference table [Staging].[FirstEnergyMETEDHIECL].

 Delete from [Staging].[FirstEnergyMETEDHIECL] where Fileimportid=@FileId

 -- Delete the row from FileImport table
 Delete from [dbo].[FileImport] where Id = @FileId

END
 




