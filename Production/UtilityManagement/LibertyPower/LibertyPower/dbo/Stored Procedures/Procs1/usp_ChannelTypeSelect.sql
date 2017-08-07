﻿/*******************************************************************************
 * usp_ChannelTypeSelect
 * Gets channel type for specified identity
 *
 * History
 *******************************************************************************
 * 6/2/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ChannelTypeSelect]
	@Identity	int
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	ID, Name, [Description]
	FROM	ChannelType WITH (NOLOCK)
	WHERE	ID = @Identity

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ChannelTypeSelect';
