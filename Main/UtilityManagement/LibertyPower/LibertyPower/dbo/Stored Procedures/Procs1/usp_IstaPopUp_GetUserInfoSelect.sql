



-- =============================================
-- Created: Alejandro Iturbe 7/13/2012
-- Gets ISTA UserName for Login to ISTA.
-- SD 1-12366024
-- =============================================

CREATE PROCEDURE [dbo].[usp_IstaPopUp_GetUserInfoSelect]
	@libertyUserName varchar(50)
AS
BEGIN

	select
	i.UserID,
	u.UserName,
	i.IstaUsername,
	i.IstaPassword,
	i.SecUser_UserID as IstaUserID,
	i.DateCreated
	from dbo.ISTAUser (nolock) i
	join [User] (nolock) u on i.UserID = u.UserID
	where u.UserName = @libertyUserName

END





