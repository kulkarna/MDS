USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelDeviceAssignmentInsert]    Script Date: 09/02/2014 14:37:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
 * 09/02/2014
 * The retuned details was missing a column "ApplicationKey",
   Modified the logic to Return proper details with applicationKey.
 *******************************************************************************

 */

ALTER PROCEDURE [dbo].[usp_SalesChannelDeviceAssignmentInsert] 
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
	    --select DA.* from LibertyPower..SalesChannelDeviceAssignment DA WITH (NoLock)
	    --	where DA.AssignmentID=SCOPE_IDENTITY()
	    Select @p_device_id = DA.DeviceID from LibertyPower..SalesChannelDeviceAssignment DA
	    with(nolock) where DA.AssignmentID=SCOPE_IDENTITY();
    	
	    exec usp_SalesChannelDeviceByDeviceId @p_device_id;
    End
		
Set NOCOUNT OFF;
END
-- Copyright 2/18/2013 Liberty Power



