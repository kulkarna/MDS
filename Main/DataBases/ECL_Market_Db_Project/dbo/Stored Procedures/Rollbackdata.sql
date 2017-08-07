
CREATE PROCEDURE [dbo].[Rollbackdata]
(
	
	@FileId AS INT
 )
AS
BEGIN
 -- Delete the row from reference table[FirstEnergyOH].

 Delete from [Staging].[FirstEnergyOH] where Fileimportid=@FileId

 -- Delete the row from FileImport table
 Delete from [dbo].[FileImport] where Id = @FileId

END
 



