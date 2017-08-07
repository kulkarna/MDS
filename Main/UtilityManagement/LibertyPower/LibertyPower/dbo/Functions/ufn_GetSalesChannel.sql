-- =============================================
-- Author:		Jaime Forero
-- Create date: 8/19/2011
-- Description:	Get Sales channel
-- =============================================
CREATE FUNCTION [dbo].[ufn_GetSalesChannel]
(
	@p_SalesChannel VARCHAR(50)
)
RETURNS INT
AS
BEGIN
	DECLARE @w_SalesChannelID INT;
	IF LTRIM(RTRIM(LOWER(@p_SalesChannel))) != 'none'
		SELECT @w_SalesChannelID = SC.ChannelID FROM LibertyPower..SalesChannel SC  (NOLOCK) WHERE LOWER(SC.ChannelName) = REPLACE(LOWER(RTRIM(LTRIM(@p_SalesChannel))), 'sales channel/', '' )  ;
	ELSE
		SET @w_SalesChannelID = NULL; -- set to null since the channel is set to null

	-- Return the result of the function
	RETURN @w_SalesChannelID;
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetSalesChannel] TO [LIBERTYPOWER\SQLProdSupportRW]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[ufn_GetSalesChannel] TO [LIBERTYPOWER\SQLProdSupportRO]
    AS [dbo];

