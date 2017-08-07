/****** END usp_SalesChannelUpdate *******************************************************************************/

/****** usp_SalesChannelsActiveSelect *******************************************************************************/

/*******************************************************************************
 * usp_SalesChannelAccountTypesSelect
 * Gets account types for given sales channel.
 *
 * History
 *******************************************************************************
 * 9/30/2011 - Rick Deigsler
 * Created.
 **************************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelAccountTypesSelect]
	@ChannelID int
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	a.ID, s.ChannelID, s.AccountTypeID, a.AccountType, s.MarketID, a.[Description]
	FROM	SalesChannelAccountType s WITH (NOLOCK)
			INNER JOIN AccountType a WITH (NOLOCK) ON s.AccountTypeID = a.ID
	WHERE	s.ChannelID = @ChannelID
	ORDER BY a.AccountType

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelAccountTypesSelect';

