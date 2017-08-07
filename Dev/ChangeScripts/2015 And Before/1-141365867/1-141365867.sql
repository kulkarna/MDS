
USE [LibertyPower]
GO

/* Removing unique constraint on SecUser_UserID field. */
ALTER TABLE [dbo].[ISTAUser]
DROP CONSTRAINT [UNQ__TableName__SecUser_UserID]
GO

/****** Object:  StoredProcedure [dbo].[usp_IstaPopUp_GetUserInfoInsert]    Script Date: 6/14/2013 4:42:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================

-- Created: Alejandro Iturbe 7/17/2012

-- Gets ISTA UserName for Login to ISTA.

-- SD 1-12366024

-- =============================================

-- =============================================

-- Updated: Sadiel Jarvis & Brahmaiah Chowdary Murakonda 6/14/2013

-- Removed checking on ISTA..SecUser restriction to be able to update/insert any username/password on LibertyPower..IstaUser table.

-- SD 1-141365867

-- =============================================



ALTER PROCEDURE [dbo].[usp_IstaPopUp_GetUserInfoInsert]

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

	where u.UserName = @libertyUserName


IF @@ROWCOUNT = 0


INSERT INTO [dbo].[ISTAUser]
           ([UserID]
           ,[IstaUsername]
           ,[IstaPassword]
           ,[DateCreated])

SELECT

	uu.UserID,

	@IstaUsername as IstaUsername,

	@IstaPassword as IstaPassword,

	getdate() as DateCreated

FROM libertypower..[user] (nolock) u

JOIN [User] (nolock) uu on u.UserID = uu.UserID AND uu.UserName = @libertyUserName

WHERE u.UserName = @libertyUserName

GO