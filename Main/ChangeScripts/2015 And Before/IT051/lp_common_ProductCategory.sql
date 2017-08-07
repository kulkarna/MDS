USE [Lp_common]
GO
/****** Object:  StoredProcedure [dbo].[usp_product_is_flexible_sel]    Script Date: 04/11/2012 12:29:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		CAthy Ghazal
-- Create date: 4/11/2012
-- Description:	get the product category
-- =============================================
CREATE PROCEDURE [dbo].[usp_ProductCategory]

 @p_product_id			char(20)
AS

BEGIN	

	SELECT	product_category
	FROM	common_product
	WHERE	product_id = @p_product_id

END
