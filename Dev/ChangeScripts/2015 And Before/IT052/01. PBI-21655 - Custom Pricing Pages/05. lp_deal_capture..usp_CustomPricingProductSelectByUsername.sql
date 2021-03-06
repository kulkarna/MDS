USE [Lp_deal_capture]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CustomPricingProductSelectByUsername]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_CustomPricingProductSelectByUsername]
GO

-- =================================================
-- Created By: Gail Mangaroo 
-- Date Created: 12/2/2013
-- =================================================
CREATE procedure [dbo].[usp_CustomPricingProductSelectByUsername]
(
 @utilityId			int = 0,
 @accountTypeId		int = 0 ,
 @username		varchar(50)  = ''
) 

as
BEGIN 

	SET NOCOUNT ON;

	SELECT  DISTINCT
		p.product_id,
		p.product_descp,
		p.product_category,
		p.utility_id,
		p.frecuency,
		p.db_number,
		p.date_created,
		p.username,
		p.inactive_ind,   
		p.active_date,
		p.product_sub_category,
		product_descp_combined = product_descp + '  (' + utility_id + ')' ,
		p.account_type_id ,
		user_access = u.username , 
		pb.ProductTypeID,
		p.ProductBrandID
		
	FROM lp_common..common_product p (NOLOCK) 
		JOIN LibertyPower..Utility ut (NOLOCK) 
			ON ut.UtilityCode = p.utility_id
		JOIN lp_security..security_role_product rp WITH (NOLOCK) 
			ON p.product_id = rp.product_id
		JOIN lp_portal..UserRoles ur WITH (NOLOCK) 
			ON rp.role_id = ur.roleid
		JOIN lp_portal..Users u WITH (NOLOCK) 
			ON ur.userid = u.userid
		LEFT JOIN LibertyPower..ProductBrand pb (NOLOCK) 
			ON pb.ProductBrandID = p.ProductBrandID
		LEFT JOIN LibertyPower..AccountType at (NOLOCK) 
			ON p.account_type_id = at.ProductAccountTypeID
	WHERE
		p.inactive_ind = 0 
		AND ( u.username = @username OR ltrim(rtrim(isnull(@username,''))) = '' )
		AND ( ut.ID = @utilityId OR isnull(@utilityId,0) = 0 ) 
		AND ( at.ID = @accountTypeId OR isnull(@accountTypeId, 0) = 0 ) 
		AND	p.IsCustom = 1
		
	ORDER BY product_descp
	
	SET NOCOUNT OFF;
	
END 
