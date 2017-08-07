
/*******************************************************************************
 * usp_ProductTypeGetByName
 *
 *
 ******************************************************************************/
CREATE PROCEDURE [dbo].[usp_ProductTypeGetByName]  
	@Name					varchar(200)
AS
	SELECT 
		[ProductTypeID]
		,[Name]
		,[Active]
		,[Username]
		,[DateCreated]
	FROM [LibertyPower].[dbo].[ProductType] 
	WHERE 
		[Name] = @Name                                                                                                                               
	
-- Copyright 2010 Liberty Power

