-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Creates a complaint-specific document
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintDocumentSave]
	@ComplaintID int,
	@ComplaintDocumentTypeID int,
	@FileGuid uniqueidentifier,
	@FileName varchar(200), 
	@AllowPublicView bit,
	@UploadedOn datetime = NULL
AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO ComplaintDocument(ComplaintID, DocumentTypeID, FileGuid, [FileName], AllowPublicView, UploadedOn)
	VALUES(@ComplaintID, @ComplaintDocumentTypeID, @FileGuid, @FileName, @AllowPublicView, @UploadedOn)
  
END
