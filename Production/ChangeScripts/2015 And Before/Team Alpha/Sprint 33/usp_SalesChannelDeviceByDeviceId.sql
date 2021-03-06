USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelDeviceByDeviceId]    Script Date: 06/10/2014 16:23:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************

 * PROCEDURE:	[usp_SalesChannelDeviceByDeviceId]
 * PURPOSE:		Check if deviceId already exists
 * HISTORY:		
 *******************************************************************************
 * 2/18/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

ALTER PROCEDURE [dbo].[usp_SalesChannelDeviceByDeviceId] 
	@p_device_id nvarchar(100)
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

SELECT		DA.*, SC.ChannelName, SC.MarginLimit , K.ApplicationKey
FROM		LibertyPower..SalesChannelDeviceAssignment DA WITH (NoLock)
JOIN		LibertyPower..SalesChannel SC WITH (NoLock)						ON DA.ChannelID = SC.ChannelID
LEFT  JOIN	[LibertyPower].[dbo].[ClientSubmitApplicationKey] K WITH (NOLOCK) ON DA.ClientSubApplicationKeyId = K.ClientSubApplicationKeyId
WHERE	DA.DeviceID=ltrim(rtrim(@p_device_id)) 


								
		
Set NOCOUNT OFF;
END
-- Copyright 2/18/2013 Liberty Power
