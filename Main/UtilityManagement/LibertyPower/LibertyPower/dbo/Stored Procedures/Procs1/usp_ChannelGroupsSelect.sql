/*******************************************************************************
 * usp_ChannelGroupsSelect
 * Gets channel groups
 *
 * History
 *******************************************************************************
 * 6/4/2010 - Rick Deigsler
 * Created.
 *
 * 6/29/2011 - Rick Deigsler
 * Modified to pull only active channel groups that 
 * have at least one channel assigned to them.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ChannelGroupsSelect]

AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	ChannelGroupID, Name, [Description], [ChannelTypeID],[CommissionRate], [Active]
	FROM	Libertypower..ChannelGroup WITH (NOLOCK)
	--WHERE	ChannelGroupID IN
	--(
	--	SELECT DISTINCT cg.ChannelGroupID
	--	FROM Libertypower..SalesChannelChannelGroup cg WITH (NOLOCK)
	--	JOIN Libertypower..SalesChannel sc WITH (NOLOCK) ON sc.ChannelID = cg.ChannelID
	--	JOIN
	--	(
	--		SELECT MAX(SalesChannelChannelGroupID) as SalesChannelChannelGroupID, ChannelName
	--		FROM Libertypower..SalesChannelChannelGroup cg WITH (NOLOCK)
	--		JOIN Libertypower..SalesChannel sc ON sc.ChannelID = cg.ChannelID
	--		GROUP BY ChannelName
	--	) m ON cg.SalesChannelChannelGroupID = m.SalesChannelChannelGroupID
	--	WHERE sc.Inactive = 0
	--)
	--AND active = 1
	ORDER BY ChannelGroupID
  
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_ChannelGroupsSelect';

