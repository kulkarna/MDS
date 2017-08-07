
/*******************************************************************************
 * usp_ProductTypeGetById
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductTypeGetById]  
	@ProductTypeID					int
AS
	SELECT 
		[ProductTypeID]
		,[Name]
		,[Active]
		,[Username]
		,[DateCreated]
	FROM [LibertyPower].[dbo].[ProductType] 
	WHERE 
		[ProductTypeID] = @ProductTypeID                                                                                                                               
	
-- Copyright 2010 Liberty Power
