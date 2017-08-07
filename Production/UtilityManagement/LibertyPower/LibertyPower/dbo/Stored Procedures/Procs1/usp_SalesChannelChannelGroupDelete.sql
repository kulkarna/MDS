
/**************************************************************************************
* 10/19/2010 - GW - Created
*	Deletes a future Channel Group assignment record.
**************************************************************************************/
CREATE proc [dbo].[usp_SalesChannelChannelGroupDelete]
	@SalesChannelChannelGroupID int	
	,@ChannelID int
as

Delete From [LibertyPower].[dbo].[SalesChannelChannelGroup]
Where [SalesChannelChannelGroupID] = @SalesChannelChannelGroupID


-- Update any existing records expiration date as needed.
Update [LibertyPower].[dbo].[SalesChannelChannelGroup]
Set [ExpirationDate] = null
Where [ChannelID] = @ChannelID
And [ExpirationDate] > GETDATE()

-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelChannelGroupDelete';

