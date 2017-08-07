
/*
******************************************************************************

 * PROCEDURE:	[GetImportFileIdAfterInsert]
 * PURPOSE:		Insert file name and source id in File import table on the basis
				of input parameter
 * HISTORY:		 
 *******************************************************************************
 * 08/11/2014 - Santosh Rao
 * Created.
 * 08/26/2014 - Updated by Santosh rao added @Source parameter in procedure
 *******************************************************************************
  */

CREATE PROCEDURE dbo.GetImportFileIdAfterInsert
(
	@FileName varchar(100),
	@SourceName varchar(500) = NULL,
	@FileId AS INT OUTPUT
 )
AS
BEGIN

IF ISNULL(@SourceName,'%')='%'
BEGIN
		--insert new row
		INSERT INTO dbo.FileImport(FileName) values (@FileName);
END
ELSE
BEGIN
	--Getting SourceId from Source table on the basis of Source Name
	Declare @SourceId int
	Select @SourceId= ID from Source where Name=@SourceName
	print @SourceId
	--insert new row
	INSERT INTO dbo.FileImport(FileName,SourceID) values (@FileName,@SourceId);
END
--save identity value and return using stored procedure OUTPUT parameter

SET @FileId = (SELECT SCOPE_IDENTITY())

END
 

