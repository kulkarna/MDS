USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelUserGetByDeviceID]    Script Date: 12/09/2013 16:41:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Markus Geiger
-- Create date: 12/09/2013
-- Description:	Retrieves sales channel users by DeviceID
-- =============================================
CREATE PROCEDURE [dbo].[usp_SalesChannelUserGetByDeviceID] 
	@deviceID nvarchar(50),
	@includeInactive bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT
		U.ChannelID
		,C.ChannelDescription
		,CAST(0 as bit) IsChannelManager
		,CAST(0 as bit) IsDevelopmentManager
		,CAST(0 as bit) IsLPChannelManager
		,U.ReportsTo
		,U.EntityID
		,BU.LegacyID
		,BU.UserType
		,BU.UserID
		,BU.UserName
		,BU.Password
		,BU.Firstname
		,BU.Lastname
		,BU.Firstname + ' ' + BU.Lastname [DisplayName]
		,BU.Email
		,BU.DateCreated
		,BU.DateModified
		,BU.CreatedBy
		,BU.ModifiedBy
		,BU.isActive
		,BU.UserGUID
		,BU.UserImage
		
	FROM LibertyPower..SalesChannelUser U (NOLOCK)
	INNER JOIN LibertyPower..SalesChannelDeviceAssignment D (NOLOCK) ON D.ChannelID = U.ChannelID
	INNER JOIN LibertyPower..SalesChannel C (NOLOCK) ON C.ChannelID = U.ChannelID
	INNER JOIN LibertyPower..[User] BU (NOLOCK) ON BU.UserID = U.ChannelUserID
	WHERE D.DeviceID = @deviceID
	AND BU.IsActive = CASE WHEN @includeInactive = 0 THEN 'Y' ELSE 'N' END
	
    SET NOCOUNT OFF;
	
END
