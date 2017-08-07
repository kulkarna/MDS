
/**************************************************************************************
* 10/19/2010 - GW - Created
*	Inserts a Channel Group assignment record.
**************************************************************************************/
CREATE proc [dbo].[usp_SalesChannelChannelGroupInsert]
	@ChannelID int	
	,@ChannelGroupID int
	,@EffectiveDate datetime
	,@ExpirationDate datetime
	,@UserID int
as

-- Update any existing records expiration date as needed.
Update [LibertyPower].[dbo].[SalesChannelChannelGroup]
Set [ExpirationDate] = @EffectiveDate
Where [ChannelID] = @ChannelID
And [ExpirationDate] is null

Insert Into [LibertyPower].[dbo].[SalesChannelChannelGroup]
      (
		[ChannelID]
		,[ChannelGroupID]
		,[EffectiveDate]
		,[ExpirationDate]
		,[UserIdentity]
		,[DateCreated]
      )
      VALUES
      (
		@ChannelID 	
		,@ChannelGroupID 
		,@EffectiveDate 
		,@ExpirationDate 
		,@UserID 
		,GETDATE()
      ) 
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelChannelGroupInsert';

