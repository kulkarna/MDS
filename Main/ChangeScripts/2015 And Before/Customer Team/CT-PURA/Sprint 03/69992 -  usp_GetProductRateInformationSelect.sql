USE [Lp_common]
GO
/****** Object:  StoredProcedure [dbo].[usp_DefaultExpiredProductAndRateSelect]    Script Date: 05/13/2015 16:04:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		PH
-- Create date: 05/20/2015
-- Description:	Gets the rate information for a given 
-- product 
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetProductRateInformationSelect]
(
	@ProductId       char(20)
)

AS
BEGIN

	DECLARE @w_rate_id		int,
			@w_term_months	int,
			@w_rate			float,
			@w_product_category varchar(20)
	
			SELECT		TOP 1 @w_rate_id			= cpr.rate_id, 
						@w_term_months			= cpr.term_months, 
						@w_rate					= cpr.rate,
						@w_product_category     = cp.product_category
			FROM		lp_common..common_product cp WITH (NOLOCK) inner join lp_common..common_product_rate cpr WITH (NOLOCK) ON cp.product_id = cpr.product_id
			WHERE		cp.product_id								= @ProductId
			ORDER BY	rate_id

	SELECT @ProductId as ProductId, 
		   @w_rate_id as RateId, 
		   @w_term_months as Terms, 
		   @w_rate as Rate,
		   @w_product_category as ProductCategory

	SET NOCOUNT OFF
END 