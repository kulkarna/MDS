
/**************************************************************************************
* 10/19/2010 - GW - Created
*	Gets the Channel Group history for a Sales Channel
**************************************************************************************/
CREATE proc [dbo].[usp_SalesChannelChannelGroupGetByChannelID]
	@ChannelID int	
as

SELECT [SalesChannelChannelGroupID]
      ,[ChannelID]
      ,sccg.[ChannelGroupId]
      ,[EffectiveDate]
      ,[ExpirationDate]
      ,[UserIdentity]
      ,[DateCreated]
      ,cg.Name as GroupName
  FROM [LibertyPower].[dbo].[SalesChannelChannelGroup] sccg
	Join [LibertyPower].[dbo].[ChannelGroup] cg on sccg.ChannelGroupId = cg.ChannelGroupID
  WHERE ChannelID = @ChannelID


-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelChannelGroupGetByChannelID';

