USE [lp_common]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProductSelect]    Script Date: 11/13/2012 09:58:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_ProductSelect
 * Select product data for specified product id
 *
 * History
 *******************************************************************************
 * 4/30/2009 - Rick Deigsler
 * Created.
  *******************************************************************************
 * 6/21/2009 - Isabelle Tamanini
 * Field IsDefault added to select
   *******************************************************************************
 * 10/25/2011 - Rick Deigsler
 * Added market filtering by sales channel
 *******************************************************************************
  * 11/13/2011 - Lev Rosenblum
 * Add outer join with libertyPower.dbo.ProductBrand table
 * Add ISNULL(b.ProductTypeID, 1) AS ProductTypeID to output
 * replace IsCustom onto p.IsCustom and ProductBrandID onto p.ProductBrandID to eliminate ambigous statements
 *******************************************************************************
 */
ALTER PROCEDURE [dbo].[usp_ProductSelect]
	@ProductId	varchar(50) = NULL
	,@Username nvarchar(100) = NULL
	,@ShowActiveOnly tinyint = 1
	,@UtilityCode char(15) = NULL
	,@ShowSpecificInactiveValue varchar(50) = NULL
	,@EnforceSecurity tinyint = 1
	,@HideVariable tinyint = 0
	,@AccountTypeID tinyint = NULL
	,@IsCustom tinyint = NULL
	,@HideDefault tinyint = 0
AS
-- usp_ProductSelect @ProductId = '2010-0027962'
BEGIN
    SET NOCOUNT ON;

	CREATE TABLE #ProductsByUser (product_id VARCHAR(20))
	
	-- If Username was provided, get list of products into temp table.  Used as a filter below.
	IF (@Username IS NOT NULL AND @EnforceSecurity = 1)
	BEGIN
		DECLARE @ChannelID INT
		SELECT @ChannelID = ChannelID
		FROM LibertyPower..SalesChannelUser scu
		JOIN LibertyPower..[User] u ON scu.UserID = u.UserID
		WHERE u.Username = @Username
	
		INSERT INTO #ProductsByUser
		SELECT p.product_id
		FROM Libertypower..[User] u 
		JOIN Libertypower..[UserRole] ur on u.userid = ur.userid 
		JOIN Libertypower..[Role] r on ur.roleid = r.roleid
		JOIN lp_security..security_role_product rp ON r.RoleID = rp.role_id
		JOIN lp_common..common_product p ON p.product_id = rp.product_id
		JOIN lp_common..product_account_type at1 ON p.account_type_id = at1.account_type_id
		JOIN libertypower..accounttype at2 ON left(at1.account_type,3) = left(at2.accounttype,3)
		JOIN Libertypower.dbo.Utility ut (NOLOCK) ON p.utility_id = ut.UtilityCode
		JOIN Libertypower.dbo.Market m WITH (NOLOCK) ON ut.MarketID = m.ID		
		JOIN libertypower..SalesChannelAccountType scat 
		ON scat.AccountTypeID = at2.ID AND scat.MarketID = m.ID
		WHERE u.Username = @Username
		AND (scat.ChannelID = @ChannelID OR @ChannelID IS NULL)
	END

	SELECT	ltrim(rtrim(p.product_id)) AS ProductId
		, p.product_category AS Category
		, p.product_category AS ProductCategory
		, p.product_category
		, product_sub_category AS SubCategory
		, product_sub_category
		, utility_id AS UtilityCode
		, utility_id 
		, p.product_id
		, m.MarketCode
		, p.frecuency
		, p.db_number
		, p.date_created
		, p.username
		, p.inactive_ind
		, p.active_date
		, p.account_type_id
		, product_descp_combined = p.product_descp + '  (' + ltrim(rtrim(p.utility_id)) + ')'
		, user_access  = case when @Username is null then '' else u.username end
		, p.product_descp as ProductDescription
		, p.product_descp as [Description]
		, p.product_descp
		, account_type_id as AccountTypeID 
		, ISNULL(p.IsCustom, 0) AS IsCustom
		, ISNULL(is_flexible, 0) AS IsFlexible
		, case when p.product_category = 'VARIABLE' and p.product_sub_category in ('CUSTOM','PORTFOLIO')
			   then 1 else 0 end as ETFDisabled
		,IsDefault
		,p.ProductBrandID
		,ISNULL(b.ProductTypeID, 1) AS ProductTypeID -- default to fixed
	FROM common_product p (NOLOCK)
	JOIN Libertypower.dbo.Utility u (NOLOCK) ON p.utility_id = u.UtilityCode
	JOIN Libertypower.dbo.Market m WITH (NOLOCK) ON u.MarketID = m.ID
	LEFT JOIN Libertypower..ProductBrand b WITH (NOLOCK)
			ON b.ProductBrandID = p.ProductBrandID
	WHERE 1=1
	AND (@ProductId IS NULL OR product_id = @ProductId)
	AND (@UtilityCode IS NULL OR p.utility_id = @UtilityCode)
	AND (@AccountTypeID IS NULL OR p.account_type_id = @AccountTypeID)
	AND (@IsCustom IS NULL OR p.IsCustom = @IsCustom)
	AND (@HideVariable <> 1 OR NOT (p.product_category = 'VARIABLE' and p.product_sub_category in ('CUSTOM','PORTFOLIO')))
	AND (@HideDefault <> 1 OR p.IsDefault = 0)
	AND (
			(@ShowActiveOnly = 0 OR p.inactive_ind = 0)  -- Unless requested, don't show inactive products.
			OR p.product_id = @ShowSpecificInactiveValue -- The UI may need an inactive product_id to be shown.
		)
	AND (@ShowActiveOnly = 0 OR p.product_id not in ('CONED-PWRM-3','CONED_PM_RES')) -- we don't want to show these even though they are active.
	-- If username is specified, only return products for the security level of the user.
	AND (@Username IS NULL OR p.product_id IN (select product_id from #ProductsByUser))
	ORDER BY p.product_descp
	

    SET NOCOUNT OFF;
END
-- Copyright 2009 Liberty Power
