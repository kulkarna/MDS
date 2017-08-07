USE [lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_product_rate_type_sel]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_product_rate_type_sel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Gail Mangaroo
-- Create date: 10/18/2012
-- Description:	Returns list of product rate types
-- =============================================
CREATE PROCEDURE [dbo].[usp_product_rate_type_sel] 

AS
BEGIN

	SELECT [product_rate_type_id]
		  ,[product_rate_type_code]
		  ,[product_rate_type_descp]
	  FROM [lp_commissions].[dbo].[product_rate_type] (NOLOCK) 
END
GO


