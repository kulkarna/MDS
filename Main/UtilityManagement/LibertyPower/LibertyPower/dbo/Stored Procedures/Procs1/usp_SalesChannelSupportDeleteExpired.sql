-- =============================================
-- Author:		jaime Forero
-- Create date: 05/11/2011
-- Description:	Deletes all records that are set to expire
-- =============================================
CREATE PROCEDURE usp_SalesChannelSupportDeleteExpired
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRAN
		DELETE FROM LibertyPower..SalesChannelSupport
		FROM [LibertyPower].[dbo].[SalesChannelSupport]
		WHERE ExpirationDate IS NOT NULL
		AND   ExpirationDate < GETDATE()
		;
		
	COMMIT
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelSupportDeleteExpired';

