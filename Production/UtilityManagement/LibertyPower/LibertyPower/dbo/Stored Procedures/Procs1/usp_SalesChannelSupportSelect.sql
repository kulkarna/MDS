-- =============================================
-- Author:		Jaime Forero
-- Create date: 4/7/2011
-- Description:	Selects records from the sales channel support table
-- =============================================
CREATE PROCEDURE [dbo].[usp_SalesChannelSupportSelect]
	-- Add the parameters for the stored procedure here
	@SalesChannelSupportID	INT = NULL,
	@ManagerUserID			INT = NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	IF	@SalesChannelSupportID IS NOT NULL 
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
		WHERE	SCS.SalesChannelSupportID = @SalesChannelSupportID
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
		WHERE	SCS.ManagerUserID	= ISNULL(@ManagerUserID, SCS.ManagerUserID)
		;
	END
	;
	
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelSupportSelect';

