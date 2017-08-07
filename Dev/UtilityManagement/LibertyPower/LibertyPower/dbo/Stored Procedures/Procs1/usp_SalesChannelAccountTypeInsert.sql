/****** END usp_SalesChannelUpdate *******************************************************************************/

/****** usp_SalesChannelsActiveSelect *******************************************************************************/

/*******************************************************************************
 * usp_SalesChannelAccountTypeInsert
 * Inserts account type for given sales channel.
 *
 * History
 *******************************************************************************
 * 9/30/2011 - Rick Deigsler
 * Created.
 **************************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelAccountTypeInsert]
	@ChannelID		int,
	@AccountTypeID	int,
	@MarketID		int
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE	@ID	int

	INSERT INTO SalesChannelAccountType (ChannelID, AccountTypeID, MarketID)
	VALUES		(@ChannelID, @AccountTypeID, @MarketID)
	
	SET	@ID = SCOPE_IDENTITY()
	
	SELECT	a.ID, s.ChannelID, s.AccountTypeID, s.MarketID, a.[Description]
	FROM	SalesChannelAccountType s WITH (NOLOCK)
			INNER JOIN AccountType a WITH (NOLOCK) ON s.AccountTypeID = a.ID
	WHERE	s.ID = @ID

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelAccountTypeInsert';

