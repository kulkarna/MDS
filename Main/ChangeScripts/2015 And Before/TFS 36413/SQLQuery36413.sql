USE [LibertyPower]

Go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
GO
IF NOT EXISTS ( SELECT TOP 1 1 FROM INFORMATION_SCHEMA.COLUMNS WITH (NOLOCK) WHERE TABLE_NAME = 'SalesChannelDeviceAssignment' AND COLUMN_NAME = 'ClientSubApplicationKeyId')
Alter table LibertyPower..[SalesChannelDeviceAssignment] add  ClientSubApplicationKeyId  int  null 
go
IF NOT EXISTS ( SELECT TOP 1 1 FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE WITH (NOLOCK) WHERE TABLE_NAME = 'SalesChannelDeviceAssignment' AND CONSTRAINT_NAME = 'FK_SalesChannelDeviceAssignment_ClientSubApplicationKeyId')
ALTER TABLE LibertyPower..[SalesChannelDeviceAssignment]  WITH CHECK ADD  CONSTRAINT [FK_SalesChannelDeviceAssignment_ClientSubApplicationKeyId] FOREIGN KEY(ClientSubApplicationKeyId)
REFERENCES LibertyPower..[ClientSubmitApplicationKey] (ClientSubApplicationKeyId)
GO

DECLARE @AssignmentID INT
DECLARE @getAssignmentID CURSOR
SET @getAssignmentID = CURSOR FAST_FORWARD  FOR
SELECT AssignmentID
FROM  LibertyPower..SalesChannelDeviceAssignment  WITH (NoLock)
OPEN @getAssignmentID
FETCH NEXT FROM @getAssignmentID INTO @AssignmentID
WHILE @@FETCH_STATUS = 0
BEGIN
	if  exists(select Top 1 1 from LibertyPower..SalesChannelDeviceAssignment DA WITH (NoLock) where DA.AssignmentID=@AssignmentID and DA.ClientSubApplicationKeyId is null)
	Begin
		insert into LibertyPower..ClientSubmitApplicationKey
				(ApplicationKey,ClientApplicationTypeId,[Description],CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) 
			 Select top 1 NEWID(),ClientApplicationTypeId,'Tablet',1913, GETDATE(),1913,GETDATE() 
						from  LibertyPower..ClientApplicationType WITH (NoLock) where ClientApplicationType='Tablet'
		update LibertyPower..SalesChannelDeviceAssignment set ClientSubApplicationKeyId=SCOPE_IDENTITY() 
			where  AssignmentID=@AssignmentID
			
	End
 
FETCH NEXT
FROM @getAssignmentID INTO @AssignmentID
END
CLOSE @getAssignmentID
DEALLOCATE @getAssignmentID
GO

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

select DA.*,SC.ChannelName,AK.ApplicationKey,DA.ClientSubApplicationKeyId, UM.Firstname + ' ' + UM.Lastname as ModifiedByName, UC.Firstname + ' ' + UC.Lastname as CreatedByName 
			from LibertyPower..SalesChannelDeviceAssignment DA  WITH (NoLock)
               INNER JOIN Libertypower..SalesChannel SC WITH (NoLock)
				ON SC.ChannelID=Da.ChannelID
			   join LibertyPower..[User] UM with (NOLock) 
				ON DA.ModifiedBy=UM.UserID 
               join LibertyPower..[User] UC with (NOLock) 
				ON DA.CreatedBy=UC.UserID 
			   Left outer join LibertyPower..ClientSubmitApplicationKey AK with (NOLock) 
				ON AK.ClientSubApplicationKeyId=DA.ClientSubApplicationKeyId
               where 
               DA.ChannelID=@p_sales_channel_id or @p_sales_channel_id is null
		
Set NOCOUNT OFF;
END
-- Copyright 2/18/2013 Liberty Power
GO
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
	@p_ClientSubApplicationKeyId int,
	@p_active bit=1,
	@p_CreatedBy int=1913
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

if not exists(select Top 1 1 from LibertyPower..SalesChannelDeviceAssignment DA WITH (NoLock) where DA.DeviceID=ltrim(rtrim(@p_device_id)))
Begin
	insert into LibertyPower..SalesChannelDeviceAssignment(ChannelID,DeviceID,ClientSubApplicationKeyId,IsActive,ModifiedBy,CreatedBy)  values (@p_sales_channel_id,@p_device_id,@p_ClientSubApplicationKeyId,@p_active,@p_CreatedBy,@p_CreatedBy) 
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
	@p_ClientSubApplicationKeyId int,
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
		set ChannelID=@p_sales_channel_id,DeviceID= @p_device_id, IsActive=@p_active,ClientSubApplicationKeyId=@p_ClientSubApplicationKeyId, ModifiedBy=@p_ModifiedBy,DateModified=getdate()
		Where AssignmentID=@p_assignment_id
	select DA.* from LibertyPower..SalesChannelDeviceAssignment DA WITH (NoLock)
	Where DA.AssignmentID=@p_assignment_id
End
		
Set NOCOUNT OFF;
END
-- Copyright 2/18/2013 Liberty Power

GO
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT TOP 1 1 FROM sys.objects WITH (NOLOCK) WHERE name = 'usp_ValidateAndAddApplicationKey' AND type_desc = 'SQL_STORED_PROCEDURE')
DROP PROCEDURE [usp_ValidateAndAddApplicationKey];
GO

/*******************************************************************************

 * PROCEDURE:	[usp_ValidateAndAddApplicationKey]
 * PURPOSE:		Validate and add new application key
 * HISTORY:		
 *******************************************************************************
 * 4/3/2013 - Pradeep Katiyar
 * Created.

 *******************************************************************************

 */

CREATE PROCEDURE [dbo].[usp_ValidateAndAddApplicationKey] 
	@p_ApplicationKey uniqueidentifier,
	@p_ClientSubApplicationKeyId int output
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON;
--SET NO_BROWSETABLE OFF

if  exists(select Top 1 1 from LibertyPower..[ClientSubmitApplicationKey] AK WITH (NoLock) where AK.ApplicationKey=@p_ApplicationKey)
Begin
	if  exists(select Top 1 1 from LibertyPower..[ClientSubmitApplicationKey] AK WITH (NoLock)
									join LibertyPower..[SalesChannelDeviceAssignment] DA WITH (NoLock) on DA.ClientSubApplicationKeyId=AK.ClientSubApplicationKeyId
					 where AK.ApplicationKey=@p_ApplicationKey)
	Begin
		Set @p_ClientSubApplicationKeyId=0
	End
	Else
	Begin
	select @p_ClientSubApplicationKeyId=AK.ClientSubApplicationKeyId from LibertyPower..[ClientSubmitApplicationKey] AK WITH (NoLock) where AK.ApplicationKey=@p_ApplicationKey
	End
	
End
Else
	Begin
		insert into LibertyPower..ClientSubmitApplicationKey
				(ApplicationKey,ClientApplicationTypeId,[Description],CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) 
			 Select top 1 @p_ApplicationKey,ClientApplicationTypeId,'Tablet',1913, GETDATE(),1913,GETDATE() 
						from  LibertyPower..ClientApplicationType WITH (NoLock) where ClientApplicationType='Tablet'
		Set @p_ClientSubApplicationKeyId=SCOPE_IDENTITY()	
	End
		
Set NOCOUNT OFF;
END
-- Copyright 4/3/2013 Liberty Power



