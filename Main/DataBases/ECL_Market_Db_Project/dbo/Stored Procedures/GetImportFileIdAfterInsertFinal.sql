/*
******************************************************************************

 * PROCEDURE:	[GetImportFileIdAfterInsertFinal]
 * PURPOSE:		Insert file name and source id in File import table on the basis
				of input parameter
 * HISTORY:		 
 *******************************************************************************
 * 12/02/2014 - Santosh Rao
 * Created.
 *******************************************************************************
  */

CREATE PROCEDURE dbo.GetImportFileIdAfterInsertFinal
(
	@FileName varchar(100),
	@SourceName varchar(500) = NULL,
	@PackageId uniqueidentifier =Null,
	@ExecutionId uniqueidentifier =Null,
	@FileId AS INT OUTPUT
 )
AS
BEGIN

IF ISNULL(@SourceName,'%')='%'
BEGIN
		--insert new row
		INSERT INTO dbo.FileImport(FileName,PackageID,ExecutionID) values (@FileName,@PackageId,@ExecutionId);
END
ELSE
BEGIN
	--Getting SourceId from Source table on the basis of Source Name
	Declare @SourceId int
	Select @SourceId= ID from Source where Name=@SourceName
	
	--insert new row
	INSERT INTO dbo.FileImport(FileName,SourceID,PackageID,ExecutionID) values (@FileName,@SourceId,@PackageId,@ExecutionId);
END
--save identity value and return using stored procedure OUTPUT parameter

SET @FileId = (SELECT SCOPE_IDENTITY())

END
 


