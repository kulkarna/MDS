USE [LibertyPower]

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_DeviceDispositioningListBySalesChannel' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE usp_DeviceDispositioningListBySalesChannel;
GO

/*******************************************************************************

 * PROCEDURE:	[usp_DeviceDispositioningListBySalesChannel]
 * PURPOSE:		Get the list of assigned devices for particular sales channel
 * HISTORY:		
 *******************************************************************************
 * 2/18/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_DeviceDispositioningListBySalesChannel] 
	@p_sales_channel_id int=null
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

select DA.*,SC.ChannelName from LibertyPower..SalesChannelDeviceAssignment DA  WITH (NoLock)
               INNER JOIN Libertypower..SalesChannel SC WITH (NoLock)
               ON SC.ChannelID=Da.ChannelID
               where 
               DA.ChannelID=@p_sales_channel_id or @p_sales_channel_id is null
		
Set NOCOUNT OFF;
END
-- Copyright 2/18/2013 Liberty Power


Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_SalesChannelDeviceAssignmentInsert' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_SalesChannelDeviceAssignmentInsert];
GO

/*******************************************************************************

 * PROCEDURE:	[usp_SalesChannelDeviceAssignmentInsert]
 * PURPOSE:		Insert the assigned devices for particular sales channel
 * HISTORY:		
 *******************************************************************************
 * 2/18/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_SalesChannelDeviceAssignmentInsert] 
	@p_sales_channel_id int,
	@p_device_id nvarchar(100),
	@p_active bit=1
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

if not exists(select Top 1 1 from LibertyPower..SalesChannelDeviceAssignment DA WITH (NoLock) where DA.DeviceID=ltrim(rtrim(@p_device_id)))
Begin
	insert into LibertyPower..SalesChannelDeviceAssignment(ChannelID,DeviceID,IsActive)  values (@p_sales_channel_id,@p_device_id,@p_active) 
	select DA.* from LibertyPower..SalesChannelDeviceAssignment DA WITH (NoLock)
		where DA.AssignmentID=SCOPE_IDENTITY()
End
		
Set NOCOUNT OFF;
END
-- Copyright 2/18/2013 Liberty Power



Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_SalesChannelDeviceAssignmentUpdate' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_SalesChannelDeviceAssignmentUpdate];
GO

/*******************************************************************************

 * PROCEDURE:	[usp_SalesChannelDeviceAssignmentUpdate]
 * PURPOSE:		Update the assigned devices for particular sales channel
 * HISTORY:		
 *******************************************************************************
 * 2/18/2013 - Pradeep Katiyar
 * Created.
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_SalesChannelDeviceAssignmentUpdate] 
	@p_assignment_id int,
	@p_sales_channel_id int,
	@p_device_id nvarchar(100),
	@p_active bit=1
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

if not exists(select Top 1 1 from LibertyPower..SalesChannelDeviceAssignment DA WITH (NoLock)
						where DA.DeviceID=ltrim(rtrim(@p_device_id)) 
								and DA.AssignmentID<>@p_assignment_id)
Begin
	update LibertyPower..SalesChannelDeviceAssignment  
		set ChannelID=@p_sales_channel_id,DeviceID= @p_device_id, IsActive= @p_active  
		Where AssignmentID=@p_assignment_id
	select DA.* from LibertyPower..SalesChannelDeviceAssignment DA WITH (NoLock)
	Where DA.AssignmentID=@p_assignment_id
End
		
Set NOCOUNT OFF;
END
-- Copyright 2/18/2013 Liberty Power




Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_SalesChannelDeviceByDeviceId' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_SalesChannelDeviceByDeviceId];
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

CREATE PROCEDURE [dbo].[usp_SalesChannelDeviceByDeviceId] 
	@p_device_id nvarchar(100)
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

select DA.* from LibertyPower..SalesChannelDeviceAssignment DA WITH (NoLock)
						where DA.DeviceID=ltrim(rtrim(@p_device_id)) 
								
		
Set NOCOUNT OFF;
END
-- Copyright 2/18/2013 Liberty Power