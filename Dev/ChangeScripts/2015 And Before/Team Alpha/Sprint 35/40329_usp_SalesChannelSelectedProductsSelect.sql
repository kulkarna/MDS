USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelSelectedProductsSelect]    Script Date: 07/16/2014 16:49:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Markus Geiger
-- Create date: 1/10/2014
-- Description:	Deletes as selected product for a specific channel and market
-- Satchi 07/16/2014
-- Added the logic to fetch the MarketProduct config from MarketProducts Table.

-- =============================================

ALTER PROCEDURE [dbo].[usp_SalesChannelSelectedProductsSelect]
 @ChannelID int = 0
AS 
BEGIN
	DECLARE @tableMarket TABLE(id int,MarketId varchar(2), MarketDesc varchar(100))
	SET NOCOUNT ON;
	
	--Get Available Markets for the channel
	DECLARE @Username VARCHAR(50);
	
	SELECT @Username = 'libertypower\' + C.ChannelName FROM LibertyPower.dbo.SalesChannel C WITH (NOLOCK) WHERE C.ChannelID = @ChannelID;
	INSERT INTO @tableMarket 
	SELECT	DISTINCT m.ID, m.retail_mkt_id AS MarketId, m.retail_mkt_descp AS MarketDesc   
	FROM	lp_common..common_retail_market m WITH (NOLOCK) 
	JOIN	lp_security..security_role_retail_mkt s WITH (NOLOCK)  ON m.retail_mkt_id = s.retail_mkt_id
	JOIN	lp_portal..Roles r WITH (NOLOCK) ON r.RoleName = s.role_name	
	JOIN	lp_portal..UserRoles ur WITH (NOLOCK)  ON r.RoleID = ur.RoleID
	JOIN	lp_portal..Users u WITH (NOLOCK) ON ur.userid = u.userid
	WHERE	u.Username = @Username
	AND   s.role_name <> 'All Utility Access'
	AND   m.inactive_ind = '0'	
	ORDER BY m.retail_mkt_descp
	--Get Market Details
	select * from @tableMarket
	--Get Available Products
	SELECT b.ProductBrandID,b.ProductTypeID,b.Name,m.MarketCode 
	from MarketProducts mp with(nolock) 
	JOIN ProductBrand b with(nolock) on mp.ProductBrandID = b.ProductBrandID
	JOIN Market m with(nolock) on mp.MarketID = m.ID
	where mp.MarketID in (Select Id from @tableMarket) AND m.InactiveInd=0
	
	--SELECT [ProductBrandID]
	--	  ,[ProductTypeID]
	--	  ,[Name]
	--FROM [LibertyPower].[dbo].[ProductBrand] WITH (NOLOCK);
    
    --Get Selected Products for the channel
	SELECT
		    ChannelID
		  , MarketID
		  , ProductBrandID
	  FROM [LibertyPower].[dbo].[SalesChannelSelectedProducts] WITH (NOLOCK)
	  WHERE ChannelID = @ChannelID;
	  
	SET NOCOUNT OFF;
	
END
