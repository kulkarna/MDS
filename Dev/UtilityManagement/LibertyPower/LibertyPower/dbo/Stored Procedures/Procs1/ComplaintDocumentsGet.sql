-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Returns a list of complaint-specific documents
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintDocumentsGet]
	@ComplaintID int
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    SELECT cd.ComplaintDocumentID
      ,cd.ComplaintID
      ,cd.DocumentTypeID
      ,cdt.document_type_name As ComplaintDocumentTypeName
      ,cd.FileGuid
      ,cd.FileName
      ,cd.CreatedOn
      ,cd.AllowPublicView
  FROM [LibertyPower].[dbo].[ComplaintDocument] cd 
		INNER JOIN [LP_documents].[dbo].[document_type] cdt ON cd.DocumentTypeID = cdt.document_type_id
  WHERE cd.ComplaintID = @ComplaintID
  
END
