﻿-- =============================================
-- Author:		Jaime Forero
-- Create date: 5/6/2011
-- Description:	Returns all users that belong to a channel id, if channel id is null it returns all users
-- =============================================
CREATE PROCEDURE [dbo].[usp_SalesChannelSupportSelectByChannelId]
	@ChannelID		 INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	@ChannelID IS NOT NULL 
	BEGIN
		-- only when selecting one and only one item, should not contain more items here
		SELECT	SCS.SalesChannelSupportID,
				SCS.ChannelID,
				SCS.SupportUserID,
				SCS.ManagerUserID,
				SCS.SendEmail,
				SCS.ExpirationDate,
				SCS.DateModified,
				SCS.DateCreated
		FROM	LibertyPower.dbo.SalesChannelSupport SCS (NOLOCK)
		WHERE	SCS.ChannelID = @ChannelID
		;
	END
	ELSE
	BEGIN
		-- SELECT Based on filter, any additional parameters should be taken care of in this branch
		SELECT	SCS.SalesChannelSupportID,
				SCS.ChannelID,
				SCS.SupportUserID,
				SCS.ManagerUserID,
				SCS.SendEmail,
				SCS.ExpirationDate,
				SCS.DateModified,
				SCS.DateCreated
		FROM	LibertyPower.dbo.SalesChannelSupport SCS (NOLOCK)
		WHERE	SCS.ChannelID IS NULL
		;
	END
	;
	
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelSupportSelectByChannelId';

