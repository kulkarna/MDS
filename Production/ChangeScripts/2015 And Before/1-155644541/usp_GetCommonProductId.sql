USE [lp_mtm]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************
 *																								*
 *	Author:		fmedeiros																		*
 *	Created:	03/05/2013																		*
 *	Descp:		created for IT051 Phase 2a														*
 *																								*
 *	Modified:	7/24/2013 Gail Mangaroo (ticket 1-155644541)
  *			 : accept account type code and product brand filter 								*
 *																								*
 ********************************************************************************************** */
ALTER procedure [dbo].[usp_GetCommonProductId] 
(
	@productCategory as varchar(50)  
	,@utilityCode as varchar(50)	
	,@accountTypeID as int = null 
	,@accountType as varchar(30) = null 
	,@productBrandID as int = null 
)
as
BEGIN
SET NOCOUNT ON

	SELECT 
		p.product_id , *
	FROM lp_common..common_product p (nolock)
		JOIN lp_common..product_account_type pat (nolock) on p.account_type_id = pat.account_type_id 
	WHERE
		p.product_category = @productCategory
		and p.IsCustom = 1
		and p.inactive_ind = 0
		and p.utility_id = @utilityCode
		and p.account_type_id = isnull (@accountTypeID , p.account_type_id ) 
		and pat.account_type  = isnull ( @accountType , pat.account_type ) 
		and p.ProductBrandID = ISNULL (@productBrandID , p.ProductBrandID ) 
SET NOCOUNT OFF		
END
GO
