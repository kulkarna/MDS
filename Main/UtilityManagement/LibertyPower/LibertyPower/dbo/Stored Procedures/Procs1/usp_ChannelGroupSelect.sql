/*******************************************************************************
 * usp_ChannelGroupSelect
 * Gets channel group for specified ID
 *
 * History
 *******************************************************************************
 * 6/4/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ChannelGroupSelect]
	@ChannelGroupID	int
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	ChannelGroupID, Name, [Description], [ChannelTypeID], [CommissionRate], [Active]
	FROM	ChannelGroup WITH (NOLOCK)
	WHERE	ChannelGroupID = @ChannelGroupID
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ChannelGroupSelect';

