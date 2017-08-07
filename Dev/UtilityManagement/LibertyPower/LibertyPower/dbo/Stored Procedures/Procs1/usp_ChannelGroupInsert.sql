
/*******************************************************************************
 * usp_ChannelGroupInsert
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ChannelGroupInsert]  
	@Name				varchar(50)
    ,@Description		varchar(100)
    ,@ChannelTypeID		int
    ,@CommissionRate    decimal(18,10) = 0
    ,@Active			bit = 1
AS

Declare @ChannelGroupID int

INSERT INTO [LibertyPower].[dbo].[ChannelGroup]
           ([Name]
			  ,[Description]
			  ,[ChannelTypeID]
			  ,[CommissionRate]
			  ,[Active]
			  )
     VALUES
           (@Name
			,@Description
			,@ChannelTypeID
			,@CommissionRate
			,@Active)


SET @ChannelGroupID = @@IDENTITY

	--SELECT [ChannelGroupID]
 --     ,[Name]
 --     ,[Description]
 --     ,[ChannelTypeID]
 --     ,[CommissionRate]
 --     ,[Active]
 -- FROM [LibertyPower].[dbo].[ChannelGroup]
	--WHERE [ChannelGroupID] = @ChannelGroupID                                                                                                                          
	
-- Copyright 2010 Liberty Power


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ChannelGroupInsert';

