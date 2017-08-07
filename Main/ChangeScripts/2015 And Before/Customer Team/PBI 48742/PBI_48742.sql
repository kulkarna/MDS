/* ------------------------------------------------------------
   AUTHOR:	Jaime Forero
   DATE:	9/30/2014 2:45:21 PM
   ------------------------------------------------------------ */

SET NOEXEC OFF
SET ANSI_WARNINGS ON
SET XACT_ABORT ON
SET IMPLICIT_TRANSACTIONS OFF
SET ARITHABORT ON
SET NOCOUNT ON
SET QUOTED_IDENTIFIER ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
GO
USE [LibertyPower]
GO

BEGIN TRAN
GO

-- Add Column IsGas to [dbo].[ProductBrand]
Print 'Add Column IsGas to [dbo].[ProductBrand]'
GO
ALTER TABLE [dbo].[ProductBrand]
	ADD [IsGas] [bit] NULL
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Alter Procedure [dbo].[usp_ProductBrandsForPricingSelect]
Print 'Alter Procedure [dbo].[usp_ProductBrandsForPricingSelect]'
GO
/*******************************************************************************
 * usp_ProductBrandsForPricingSelect
 * Gets product brands for daily pricing
 *
 * History
 *******************************************************************************
 * 4/3/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 * Modified By Lev Rosenblum at 10/24/2012
 * b.IsMultiTerm has been added to output.
 *******************************************************************************
 * Modified By Thiago Nogueira at 04/04/2013
 * Changing logic to do not show only Default Variable
 *******************************************************************************
* Modified Rick Deigsler at 9/18/2014
* Added Parent field
*******************************************************************************
* Modified By Jaime Forero 10/10/2015
* Added new field IsGas PBI 48742
*******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_ProductBrandsForPricingSelect]
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	b.ProductBrandID, b.ProductTypeID, b.[Name], b.IsCustom, b.IsDefaultRollover, b.IsMultiTerm
			, b.RolloverBrandID, b.Active, b.Username, b.DateCreated, b.Parent, b.IsGas
	FROM	Libertypower..ProductBrand b WITH (NOLOCK)
			INNER JOIN Libertypower..ProductType t WITH (NOLOCK) ON b.ProductTypeID = t.ProductTypeID
	WHERE	b.IsDefaultRollover = 0
	AND		b.Active = 1
	AND		t.Active = 1
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO






IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Alter Procedure [dbo].[usp_ProductBrandsSelect]
Print 'Alter Procedure [dbo].[usp_ProductBrandsSelect]'
GO
/*******************************************************************************
 * usp_ProductBrandsSelect
 * Gets product brands
 *
 * History
 *******************************************************************************
 * 2/15/2012 - Rick Deigsler
 * Created.
 *******************************************************************************
 * 10/27/2012 - Lev Rosenblum
 * Add IsMultiTerm to output.
 *******************************************************************************
 *Modified Rick Deigsler at 9/18/2014
 * Added Parent field
 *******************************************************************************
 * Modified By Jaime Forero 10/10/2015
 * Added new field IsGas PBI 48742
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_ProductBrandsSelect]
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	b.ProductBrandID, b.ProductTypeID, b.[Name], b.IsCustom, b.IsDefaultRollover, 
			b.RolloverBrandID, b.Active, b.Username, b.DateCreated, b.IsMultiTerm, b.Parent, b.IsGas
	FROM	Libertypower..ProductBrand b WITH (NOLOCK)
			INNER JOIN Libertypower..ProductType t WITH (NOLOCK) ON b.ProductTypeID = t.ProductTypeID
	WHERE	b.Active = 1
	AND		t.Active = 1
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power

GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO







IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- Alter Procedure [dbo].[usp_ProductBrandSelect]
Print 'Alter Procedure [dbo].[usp_ProductBrandSelect]'
GO
/*******************************************************************************
 * usp_ProductBrandSelect
 * Gets product brand by product brand id
 *
 * History
 *******************************************************************************
 * 6/1/2010 - Rick Deigsler
 * Created.
 *******************************************************************************
 * Modified By Jaime Forero 10/10/2015
 * Added new field IsGas PBI 48742
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_ProductBrandSelect]
	@ProductBrandId int
AS
BEGIN
    SET NOCOUNT ON;
   
	SELECT	ProductBrandID, ProductTypeID, [Name], IsCustom, IsDefaultRollover, RolloverBrandID, Active, Username, DateCreated, IsMultiTerm, Parent, IsGas
	FROM	ProductBrand WITH (NOLOCK)
	WHERE	ProductBrandID	= @ProductBrandId
	
    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power


GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT


BEGIN TRAN

update Libertypower..ProductBrand 
set IsGas = 'True'
where Name like '%GAS%'

COMMIT



