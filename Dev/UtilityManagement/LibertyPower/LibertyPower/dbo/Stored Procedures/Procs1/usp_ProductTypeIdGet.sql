
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
