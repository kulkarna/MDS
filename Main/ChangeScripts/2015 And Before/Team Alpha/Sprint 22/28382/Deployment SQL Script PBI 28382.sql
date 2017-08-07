USE LibertyPower
GO

/****** Object:  Table [dbo].[SalesChannelSelectedProducts]    Script Date: 01/16/2014 15:13:02 ******/


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Markus Geiger
-- Create date: 1/10/2014
-- Description:	Deletes as selected product for a specific channel and market
-- =============================================

CREATE TABLE [dbo].[SalesChannelSelectedProducts](
	[SalesChannelSelectedProductsID] [int] IDENTITY(1,1) NOT NULL,
	[ChannelID] [int] NOT NULL,
	[MarketID] [int] NOT NULL,
	[ProductBrandID] [int] NOT NULL,
 CONSTRAINT [PK_SalesChannelSelectedProducts_1] PRIMARY KEY NONCLUSTERED
  
(
	[SalesChannelSelectedProductsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE dbo.SalesChannelSelectedPRoducts
ADD CONSTRAINT AK_SelectedProductUnique UNIQUE CLUSTERED(ChannelID, MarketID, ProductBrandID)
GO



/****** Object:  StoredProcedure [dbo].[usp_SalesChannelSelectedProductsSelect]    Script Date: 01/16/2014 15:15:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Markus Geiger
-- Create date: 1/10/2014
-- Description:	Deletes as selected product for a specific channel and market
-- =============================================

CREATE PROCEDURE [dbo].[usp_SalesChannelSelectedProductsSelect]
 @ChannelID int = 0
AS 
BEGIN
	
	SET NOCOUNT ON;
	
	--Get Available Markets for the channel
	DECLARE @Username VARCHAR(50);

	SELECT @Username = 'libertypower\' + C.ChannelName FROM LibertyPower.dbo.SalesChannel C WITH (NOLOCK) WHERE C.ChannelID = @ChannelID;
	
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
	
	--Get Available Products
	SELECT [ProductBrandID]
		  ,[ProductTypeID]
		  ,[Name]
	      
	  FROM [LibertyPower].[dbo].[ProductBrand] WITH (NOLOCK);
    
    --Get Selected Products for the channel
	SELECT
		    ChannelID
		  , MarketID
		  , ProductBrandID
	  FROM [LibertyPower].[dbo].[SalesChannelSelectedProducts] WITH (NOLOCK)
	  WHERE ChannelID = @ChannelID;
	  
	SET NOCOUNT OFF;
	
END
GO


/****** Object:  StoredProcedure [dbo].[usp_SalesChannelSelectedProductDelete]    Script Date: 01/16/2014 15:17:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Markus Geiger
-- Create date: 1/10/2014
-- Description:	Deletes as selected product for a specific channel and market
-- =============================================
CREATE PROCEDURE [dbo].[usp_SalesChannelSelectedProductDelete]
	@ChannelID int = null,
	@MarketID int = null,
	@ProductBrandID int = null
AS
BEGIN
	
	SET NOCOUNT ON;

    IF(@ChannelID IS NOT NULL)
    BEGIN
		IF(@MarketID IS NOT NULL)
		BEGIN
			IF(@ProductBrandID IS NOT NULL)
			BEGIN
				IF(EXISTS(SELECT * FROM SalesChannelSelectedProducts WITH (NOLOCK) WHERE ChannelID = @ChannelID AND MarketID = @MarketID AND ProductBrandID = @ProductBrandID))
				BEGIN
					DELETE FROM SalesChannelSelectedProducts 
					WHERE ChannelID = @ChannelID
					AND MarketID = @MarketID
					AND ProductBrandID = @ProductBrandID
				END
			END
		END
    END
    
    SET NOCOUNT OFF;
END

GO


/****** Object:  StoredProcedure [dbo].[usp_SalesChannelSelectedProductInsert]    Script Date: 01/16/2014 15:19:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Markus Geiger	
-- Create date: 1/10/2014
-- Description:	Inserts a selected product for a specific sales channel and market
-- =============================================
CREATE PROCEDURE [dbo].[usp_SalesChannelSelectedProductInsert] 
	@ChannelID int = null,
	@MarketID int = null,
	@ProductBrandID int = null
AS
BEGIN
	
	SET NOCOUNT ON;

    IF(@ChannelID IS NOT NULL)
    BEGIN
		IF(@MarketID IS NOT NULL)
		BEGIN
			IF(@ProductBrandID IS NOT NULL)
			BEGIN
				IF(NOT EXISTS(SELECT * FROM LibertyPower..SalesChannelSelectedProducts WITH (NOLOCK) WHERE ChannelID = @ChannelID AND MarketID = @MarketID AND ProductBrandID = @ProductBrandID))
				BEGIN
					INSERT INTO LibertyPower..SalesChannelSelectedProducts
					(ChannelID, MarketID, ProductBrandID)
					VALUES(@ChannelID, @MarketID, @ProductBrandID);
				END
			END
		END
    END
    
    SET NOCOUNT OFF;
END

GO

