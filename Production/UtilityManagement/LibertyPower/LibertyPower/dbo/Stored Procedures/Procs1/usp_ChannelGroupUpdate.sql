
/*******************************************************************************
 * usp_ChannelGroupUpdate
 *
 *
 ******************************************************************************/
Create PROCEDURE [dbo].[usp_ChannelGroupUpdate]  
	@ChannelGroupID		int
	,@Name				varchar(50) = null
    ,@Description		varchar(100) = null
    ,@ChannelTypeID		int = null
    ,@CommissionRate	decimal(18,10) = null
    ,@Active			bit	= null
AS

Update [LibertyPower].[dbo].[ChannelGroup]
SET	 [Name] = COALESCE(@Name, [Name])
	  ,[Description] = COALESCE(@Description, [Description])
	  ,[ChannelTypeID] = COALESCE(@ChannelTypeID, [ChannelTypeID])
	  ,[CommissionRate] = COALESCE(@CommissionRate, [CommissionRate])
	  ,[Active]= COALESCE(@Active, [Active])
WHERE @ChannelGroupID = ChannelGroupID


SET @ChannelGroupID = @@IDENTITY

	SELECT [ChannelGroupID]
      ,[Name]
      ,[Description]
      ,[ChannelTypeID]
      ,[CommissionRate]
      ,[Active]
  FROM [LibertyPower].[dbo].[ChannelGroup]
	WHERE [ChannelGroupID] = @ChannelGroupID                                                                                                                          
	
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ChannelGroupUpdate';

