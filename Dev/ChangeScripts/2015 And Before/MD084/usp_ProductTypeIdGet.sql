USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductTypeIdGet]    Script Date: 09/18/2012 14:26:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * [usp_ProductTypeIdGet]
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductTypeIdGet]  
	@PriceID					BIGINT
AS
	SELECT 
		ProductTypeID
	FROM [LibertyPower].[dbo].[Price] (NOLOCK)
	WHERE 
		ID = @PriceID                                                                                                                               
	
-- Copyright 2010 Liberty Power
