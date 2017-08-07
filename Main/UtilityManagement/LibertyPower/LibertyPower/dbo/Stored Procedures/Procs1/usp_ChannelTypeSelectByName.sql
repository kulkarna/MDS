/*******************************************************************************
 * usp_ChannelTypeSelectByName
 * Gets channel type for specified identity
 *
 * History
 *******************************************************************************
 * 6/4/2010 - George Worthington
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ChannelTypeSelectByName]
	@Name varchar(50)
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	ID, Name, [Description]
	FROM	ChannelType WITH (NOLOCK)
	WHERE	Name = @Name

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ChannelTypeSelectByName';

