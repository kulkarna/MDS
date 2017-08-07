/*******************************************************************************
 * usp_SalesChannelChannelGroupIDByDateSelect
 * Gets channel group for sales channel by date specified
 *
 * History
 *******************************************************************************
 * 3/20/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelChannelGroupIDByDateSelect]
	@ChannelID	int,
	@Date		datetime
AS
BEGIN
    SET NOCOUNT ON;
        
	SELECT	ChannelGroupID 	
	FROM	Libertypower..SalesChannel sc WITH (NOLOCK)
			INNER JOIN Libertypower..SalesChannelChannelGroup scg WITH (NOLOCK)
			ON sc.channelid = scg.channelid    
	WHERE	sc.channelid = @ChannelID
	AND		EffectiveDate <= @Date
	AND		((ExpirationDate > @Date) OR (ExpirationDate IS NULL))	

    SET NOCOUNT OFF;
END
-- Copyright 2012 Liberty Power
