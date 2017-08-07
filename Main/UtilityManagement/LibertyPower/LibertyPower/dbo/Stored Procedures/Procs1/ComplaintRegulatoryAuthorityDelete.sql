-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Deletes a regulatory authority
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintRegulatoryAuthorityDelete]
	@RegulatoryAuthorityID int
AS
BEGIN

	UPDATE ComplaintRegulatoryAuthority SET
		IsActive = 0
	WHERE ComplaintRegulatoryAuthorityID = @RegulatoryAuthorityID

END
