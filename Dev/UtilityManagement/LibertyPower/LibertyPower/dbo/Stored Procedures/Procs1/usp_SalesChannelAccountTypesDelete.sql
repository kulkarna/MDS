/****** END usp_SalesChannelUpdate *******************************************************************************/

/****** usp_SalesChannelsActiveSelect *******************************************************************************/

/*******************************************************************************
 * usp_SalesChannelAccountTypesDelete
 * Deletes account types for given sales channel.
 *
 * History
 *******************************************************************************
 * 9/30/2011 - Rick Deigsler
 * Created.
 **************************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelAccountTypesDelete]
	@ChannelID	int,
	@MarketID	int
AS
BEGIN
    SET NOCOUNT ON;

	DELETE
	FROM	SalesChannelAccountType
	WHERE	ChannelID	= @ChannelID
	AND		MarketID	= @MarketID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelAccountTypesDelete';

