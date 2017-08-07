
CREATE PROCEDURE [dbo].[GetContractTemplateVersion](@VersionCode varchar(50)) AS  
BEGIN

SET NOCOUNT ON

SELECT TV.*
FROM lp_documents.dbo.TemplateVersions TV WITH (NOLOCK)
WHERE TV.VersionCode = @VersionCode

END