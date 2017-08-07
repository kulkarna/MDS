/*******************************************************************************
 * usp_ProductBrandInsert
 * Inserts product brand record returning record identifier
 *
 * History
 *******************************************************************************
 * 2/16/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_ProductBrandInsert]
	@Name				varchar(500),
	@ProductTypeID		int,
	@IsCustom			tinyint,
	@IsDefaultRollover	tinyint,
	@RolloverBrandID	int,
	@IsActive			tinyint,
	@Username			varchar(200),
	@DateCreated		datetime
AS
BEGIN
    SET NOCOUNT ON;
       
	INSERT INTO	ProductBrand (ProductTypeID, [Name], IsCustom, IsDefaultRollover, RolloverBrandID, Active, Username, DateCreated)
	VALUES		(@ProductTypeID, @Name, @IsCustom, @IsDefaultRollover, @RolloverBrandID, @IsActive, @Username, @DateCreated)
	
	SELECT SCOPE_IDENTITY()
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
