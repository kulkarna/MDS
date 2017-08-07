USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentMapsByChannel]    Script Date: 01/17/2014 15:05:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetDocumentMapsByChannel]
	@ChannelID int = null

AS
BEGIN	

SELECT
	 m.DocumentMapID
	,m.MarketID
	,m.BrandID
	,m.AccountTypeID
	,m.TemplateTypeID
	,m.DocumentID 
FROM M_DocumentMap m 
INNER JOIN 
(
SELECT DISTINCT
	 m.DocumentID
	
FROM M_DocumentMap m WITH (NOLOCK)
INNER JOIN LK_PartnerMarket k on m.MarketID = k.MarketID
INNER JOIN T_Documents d on m.DocumentID = d.DocumentID
WHERE (k.PartnerID = @ChannelID)) d ON m.DocumentID = d.DocumentID

END
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentMapsByChannelAndMarket]    Script Date: 01/17/2014 15:05:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetDocumentMapsByChannelAndMarket]
	@ChannelID int = null,
	@MarketID int = null

AS
BEGIN	

SELECT
	 m.DocumentMapID
	,m.MarketID
	,m.BrandID
	,m.AccountTypeID
	,m.TemplateTypeID
	,m.DocumentID 
FROM M_DocumentMap m 
INNER JOIN 
(
SELECT DISTINCT
	 m.DocumentID
	
FROM M_DocumentMap m WITH (NOLOCK)
INNER JOIN LK_PartnerMarket k on m.MarketID = k.MarketID
INNER JOIN T_Documents d on m.DocumentID = d.DocumentID
WHERE (k.PartnerID = @ChannelID)
AND (k.MarketID = @MarketID)
) d ON m.DocumentID = d.DocumentID

END
GO

USE [GENIE]
GO

/****** Object:  StoredProcedure [dbo].[GetDocumentMapsByChannelAndMarketAndProduct]    Script Date: 01/17/2014 15:05:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[GetDocumentMapsByChannelAndMarketAndProduct]
	@ChannelID int = null,
	@MarketID int = null,
	@ProductID int = null

AS
BEGIN	

SELECT
	 m.DocumentMapID
	,m.MarketID
	,m.BrandID
	,m.AccountTypeID
	,m.TemplateTypeID
	,m.DocumentID 
FROM M_DocumentMap m 
INNER JOIN 
(
SELECT DISTINCT
	 m.DocumentID
	
FROM M_DocumentMap m WITH (NOLOCK)
INNER JOIN LK_PartnerMarket k on m.MarketID = k.MarketID
INNER JOIN T_Documents d on m.DocumentID = d.DocumentID
WHERE (k.PartnerID = @ChannelID)
AND (k.MarketID = @MarketID)
AND (m.BrandID = @ProductID)
) d ON m.DocumentID = d.DocumentID

END
GO


