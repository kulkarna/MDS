USE [LibertyPower]

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
GO
IF NOT EXISTS ( SELECT TOP 1 1 FROM INFORMATION_SCHEMA.COLUMNS WITH (NOLOCK) WHERE TABLE_NAME = 'SalesChannelDeviceAssignment' AND COLUMN_NAME = 'DateModified')
Alter table LibertyPower..[SalesChannelDeviceAssignment] add  DateModified  datetime not null DEFAULT (getdate())
go
IF NOT EXISTS ( SELECT TOP 1 1 FROM INFORMATION_SCHEMA.COLUMNS WITH (NOLOCK) WHERE TABLE_NAME = 'SalesChannelDeviceAssignment' AND COLUMN_NAME = 'ModifiedBy')
Alter table LibertyPower..[SalesChannelDeviceAssignment] add  ModifiedBy   int not null DEFAULT (1913)
GO
IF NOT EXISTS ( SELECT TOP 1 1 FROM INFORMATION_SCHEMA.COLUMNS WITH (NOLOCK) WHERE TABLE_NAME = 'SalesChannelDeviceAssignment' AND COLUMN_NAME = 'DateCreated')
Alter table LibertyPower..[SalesChannelDeviceAssignment] add  DateCreated   datetime not null DEFAULT (getdate())
go
IF NOT EXISTS ( SELECT TOP 1 1 FROM INFORMATION_SCHEMA.COLUMNS WITH (NOLOCK) WHERE TABLE_NAME = 'SalesChannelDeviceAssignment' AND COLUMN_NAME = 'CreatedBy')
Alter table LibertyPower..[SalesChannelDeviceAssignment] add  CreatedBy   int not null DEFAULT (1913)

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
 * 3/27/2014 - Pradeep Katiyar
 * Added created by and modified by fields
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_DeviceDispositioningListBySalesChannel] 
	@p_sales_channel_id int=null
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

select DA.*,SC.ChannelName,UM.Firstname + ' ' + UM.Lastname as ModifiedByName, UC.Firstname + ' ' + UC.Lastname as CreatedByName 
			from LibertyPower..SalesChannelDeviceAssignment DA  WITH (NoLock)
               INNER JOIN Libertypower..SalesChannel SC WITH (NoLock)
				ON SC.ChannelID=Da.ChannelID
			   join LibertyPower..[User] UM with (NOLock) 
				ON DA.ModifiedBy=UM.UserID 
               join LibertyPower..[User] UC with (NOLock) 
				ON DA.CreatedBy=UC.UserID 
               where 
               DA.ChannelID=@p_sales_channel_id or @p_sales_channel_id is null
		
Set NOCOUNT OFF;
END
-- Copyright 2/18/2013 Liberty Power
GO
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
 * 3/27/2014 - Pradeep Katiyar
 * Added created by and modified by fields
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_SalesChannelDeviceAssignmentInsert] 
	@p_sales_channel_id int,
	@p_device_id nvarchar(100),
	@p_active bit=1,
	@p_CreatedBy int=1913
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

if not exists(select Top 1 1 from LibertyPower..SalesChannelDeviceAssignment DA WITH (NoLock) where DA.DeviceID=ltrim(rtrim(@p_device_id)))
Begin
	insert into LibertyPower..SalesChannelDeviceAssignment(ChannelID,DeviceID,IsActive,ModifiedBy,CreatedBy)  values (@p_sales_channel_id,@p_device_id,@p_active,@p_CreatedBy,@p_CreatedBy) 
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
 * 3/27/2013 - Pradeep Katiyar
 * Updated - Added created by and modified by fields 
 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_SalesChannelDeviceAssignmentUpdate] 
	@p_assignment_id int,
	@p_sales_channel_id int,
	@p_device_id nvarchar(100),
	@p_active bit=1,
	@p_ModifiedBy int=1913
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
		set ChannelID=@p_sales_channel_id,DeviceID= @p_device_id, IsActive= @p_active, ModifiedBy=@p_ModifiedBy,DateModified=getdate()
		Where AssignmentID=@p_assignment_id
	select DA.* from LibertyPower..SalesChannelDeviceAssignment DA WITH (NoLock)
	Where DA.AssignmentID=@p_assignment_id
End
		
Set NOCOUNT OFF;
END
-- Copyright 2/18/2013 Liberty Power


