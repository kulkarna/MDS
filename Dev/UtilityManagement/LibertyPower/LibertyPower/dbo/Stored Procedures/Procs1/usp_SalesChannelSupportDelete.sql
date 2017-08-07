-- =============================================
-- Author:		Jaime Forero
-- Create date: 4/7/2011
-- Description:	Deletes a records from the sales channel support table
-- =============================================
CREATE PROCEDURE usp_SalesChannelSupportDelete
	-- Add the parameters for the stored procedure here
	@SalesChannelSupportID INT
AS
BEGIN
	SET NOCOUNT ON;
	
	DELETE FROM LibertyPower.dbo.SalesChannelSupport
	WHERE	LibertyPower.dbo.SalesChannelSupport.SalesChannelSupportID = @SalesChannelSupportID
	;
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelSupportDelete';

