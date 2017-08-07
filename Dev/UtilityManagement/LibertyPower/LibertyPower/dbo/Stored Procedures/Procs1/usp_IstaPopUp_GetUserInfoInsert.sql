








--USE [LibertyPower]
--GO

--/****** Object:  StoredProcedure [dbo].[usp_IstaPopUp_GetUserInfoInsert]    Script Date: 07/17/2012 15:41:40 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

-- =============================================
-- Created: Alejandro Iturbe 7/17/2012
-- Gets ISTA UserName for Login to ISTA.
-- SD 1-12366024
-- =============================================


CREATE PROCEDURE [dbo].[usp_IstaPopUp_GetUserInfoInsert]
(
	@libertyUserName	varchar(50),
	@IstaUsername		varchar(50),
	@IstaPassword		varchar(50)
)
AS


SET NOCOUNT ON;

	UPDATE dbo.ISTAUser
	SET 
	IstaUsername		= @IstaUsername, 
	IstaPassword		= @IstaPassword
	FROM dbo.ISTAUser iu
	JOIN [User] (nolock) u on iu.UserID = u.UserID AND u.UserName = @libertyUserName
	JOIN
		(
			select 
			UserId,
			UserLogin
			from ISTA..SecUser
			where UserLogin <> 'inactive.user' and ActiveFlag = 1 and UserLogin <> 'mboddie'
		) i on @IstaUsername = I.UserLogin
	
	where u.UserName = @libertyUserName

IF @@ROWCOUNT = 0

INSERT INTO dbo.ISTAUser
SELECT
uu.UserID,
i.UserId as SecUser_UserID,
@IstaUsername as IstaUsername,
@IstaPassword as IstaPassword,
getdate() as DateCreated
--u.UserName
FROM libertypower..[user] (nolock) u
JOIN [User] (nolock) uu on u.UserID = uu.UserID AND uu.UserName = @libertyUserName
left join
(
	select 
	UserId,
	UserLogin
	from ISTA..SecUser
	where UserLogin <> 'inactive.user' and ActiveFlag = 1 and UserLogin <> 'mboddie'
) i on @IstaUsername = I.UserLogin

WHERE u.UserName = @libertyUserName







