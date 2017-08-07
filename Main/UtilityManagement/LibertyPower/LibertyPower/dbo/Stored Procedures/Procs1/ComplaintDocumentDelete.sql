-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Deletes a complaint-specific document
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintDocumentDelete]
	@FileGuid uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON

	DELETE ComplaintDocument WHERE FileGuid = @FileGuid
  
END
