/****** END usp_SalesChannelUpdate *******************************************************************************/

/****** usp_SalesChannelsActiveSelect *******************************************************************************/

/*******************************************************************************
 * usp_SalesChannelAccountTypesByAccountTypeSelect
 * Gets account types for account type ID.
 *
 * History
 *******************************************************************************
 * 10/21/2011 - Rick Deigsler
 * Created.
 **************************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelAccountTypesByAccountTypeSelect]
	@AccountTypeID	int
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	ChannelID, AccountTypeID, MarketID
	FROM	SalesChannelAccountType WITH (NOLOCK)
	WHERE	AccountTypeID = @AccountTypeID
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelAccountTypesByAccountTypeSelect';

