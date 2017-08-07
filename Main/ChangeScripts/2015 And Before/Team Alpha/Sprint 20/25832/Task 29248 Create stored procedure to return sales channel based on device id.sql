
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Markus Geiger
-- Create date: 12/10/2013
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE usp_SalesChannelGetByDeviceID 
	@deviceID varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    DECLARE @channelID int ;
    
    SELECT TOP 1 @channelID = ChannelID FROM LibertyPower..SalesChannelDeviceAssignment WITH (NOLOCK) WHERE DeviceID = @deviceID;
    
    EXEC LibertyPower..usp_SalesChannelSelect @ChannelID = @ChannelID;

	SET NOCOUNT OFF;
END
GO
