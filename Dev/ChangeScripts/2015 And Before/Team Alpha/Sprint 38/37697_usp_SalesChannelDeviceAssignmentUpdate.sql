USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelDeviceAssignmentUpdate]    Script Date: 09/02/2014 14:41:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
 * 09/02/2014
 * The retuned details was missing a column "ApplicationKey",
   Modified the logic to Return proper details with applicationKey.
 *******************************************************************************

 */

ALTER PROCEDURE [dbo].[usp_SalesChannelDeviceAssignmentUpdate] 
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
	--select DA.* from LibertyPower..SalesChannelDeviceAssignment DA WITH (NoLock)
	--Where DA.AssignmentID=@p_assignment_id
	
	Select @p_device_id = DA.DeviceID from LibertyPower..SalesChannelDeviceAssignment DA
	with(nolock) where DA.AssignmentID=@p_assignment_id;
	exec usp_SalesChannelDeviceByDeviceId @p_device_id;
End
		
Set NOCOUNT OFF;
END
-- Copyright 2/18/2013 Liberty Power

