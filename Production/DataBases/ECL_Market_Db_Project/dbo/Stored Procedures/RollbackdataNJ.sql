

CREATE PROCEDURE [dbo].[RollbackdataNJ]

(

	@FileId AS INT
 )

AS

BEGIN

 -- Delete the row from reference table[FirstEnergyNJ].


 Delete from [Staging].[FirstEnergyNJ] where Fileimportid=@FileId


 -- Delete the row from FileImport table

 Delete from dbo.FileImport where Id = @FileId


END

 






