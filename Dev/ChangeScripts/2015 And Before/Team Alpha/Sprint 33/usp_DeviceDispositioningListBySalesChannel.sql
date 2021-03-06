USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_DeviceDispositioningListBySalesChannel]    Script Date: 06/10/2014 17:22:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************

 * PROCEDURE:	[usp_DeviceDispositioningListBySalesChannel]
 * PURPOSE:		Get the list of assigned devices for particular sales channel
 * HISTORY:		
 *******************************************************************************
 * 2/18/2013 - Pradeep Katiyar
 * Created.
 * 3/27/2014 - Pradeep Katiyar
 * Added created by and modified by fields
 * 4/23/2014 - Pradeep Katiyar
 * Added Margin Limit column
 *******************************************************************************

 */

ALTER PROCEDURE [dbo].[usp_DeviceDispositioningListBySalesChannel] 
	@p_sales_channel_id int=null
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

select DA.*,SC.ChannelName,AK.ApplicationKey,
DA.ClientSubApplicationKeyId, 
UM.Firstname + ' ' + UM.Lastname as ModifiedByName,
 UC.Firstname + ' ' + UC.Lastname as CreatedByName,
SC.MarginLimit 
from LibertyPower..SalesChannelDeviceAssignment DA  WITH (NoLock)
INNER JOIN Libertypower..SalesChannel SC WITH (NoLock) ON SC.ChannelID=Da.ChannelID
join LibertyPower..[User] UM with (NOLock) ON DA.ModifiedBy=UM.UserID 
join LibertyPower..[User] UC with (NOLock) ON DA.CreatedBy=UC.UserID 
Left outer join LibertyPower..ClientSubmitApplicationKey AK with (NOLock) ON AK.ClientSubApplicationKeyId=DA.ClientSubApplicationKeyId
where DA.ChannelID=@p_sales_channel_id or @p_sales_channel_id is null
		
Set NOCOUNT OFF;
END
-- Copyright 2/18/2013 Liberty Power


