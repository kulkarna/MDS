USE LibertyPower

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Thiago Nogueira
-- Create date: 5/30/2013
-- Description:	Updates bulk record with saved PriceID
-- =============================================
CREATE PROCEDURE usp_BulkCustomPricingUpdate (
@p_BulkID int,
@p_PriceID bigint
)
AS
BEGIN
	UPDATE LibertyPower..BulkCustomPricing
	SET PriceID = @p_PriceID
	WHERE BulkID = @p_BulkID
END
GO
