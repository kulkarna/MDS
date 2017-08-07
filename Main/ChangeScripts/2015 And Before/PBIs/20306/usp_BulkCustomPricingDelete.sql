USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_BulkCustomPricingGet]    Script Date: 09/12/2013 17:10:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Thiago Nogueira
-- Create date: 5/30/2013
-- Description:	Returns all custom pricing to be inserted
-- =============================================
CREATE PROCEDURE [dbo].[usp_BulkCustomPricingDelete]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE
	FROM LibertyPower..BulkCustomPricing
END
