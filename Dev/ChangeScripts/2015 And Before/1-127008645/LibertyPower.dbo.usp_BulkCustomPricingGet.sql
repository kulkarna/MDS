USE LibertyPower

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Thiago Nogueira
-- Create date: 5/30/2013
-- Description:	Returns all custom pricing to be inserted
-- =============================================
CREATE PROCEDURE usp_BulkCustomPricingGet
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT *
	FROM LibertyPower..BulkCustomPricing
END
GO
